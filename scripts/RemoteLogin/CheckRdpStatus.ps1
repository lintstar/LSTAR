function CheckRdpStatus {
    [CmdletBinding()]
    Param (
        [string]$fDenyTSConnections
    )

    # Search
    $TSConnectionRegPath = "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server"
    $TSConnectionRegValue = (Get-ItemProperty -Path $TSConnectionRegPath -ErrorAction Stop).fDenyTSConnections

    if($TSConnectionRegValue -eq 0){
        write-host "RDP Status: Open"
    }
    else{
        write-host "RDP Status: Close"
    }
}