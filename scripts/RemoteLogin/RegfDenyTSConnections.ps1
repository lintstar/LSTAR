function RegfDenyTSConnections {
    [CmdletBinding()]
    Param (
        [string]$fDenyTSConnections
    )

    # Search
    $TSConnectionRegPath = "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server"
    $TSConnectionRegValue = (Get-ItemProperty -Path $TSConnectionRegPath -ErrorAction Stop).fDenyTSConnections

    write-host "Old status (0 open / 1 close): "$TSConnectionRegValue

    # Change
    Set-Itemproperty -path $TSConnectionRegPath -Name 'fDenyTSConnections' -value $fDenyTSConnections

    # Search
    $TSConnectionRegValueCheck = (Get-ItemProperty -Path $TSConnectionRegPath -ErrorAction Stop).fDenyTSConnections

    write-host "New status (0 open / 1 close): "$TSConnectionRegValueCheck

}