Function Lock-WorkStation {
 
$signature = @"
[DllImport("user32.dll", SetLastError = true)]
public static extern bool LockWorkStation();
"@
 
$LockWorkStation = Add-Type -memberDefinition $signature -name "Win32LockWorkStation" -namespace Win32Functions -passthru
 
$LockWorkStation::LockWorkStation() | Out-Null
 
}
 
Lock-WorkStation