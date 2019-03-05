Function Get-SnapshotReport {
    Param (
        [String]$ESXiServer,
        [String]$ESXiUsername,
        [SecureString]$ESXiEncrpytedPassword
    )

    $ESXiCredentials = New-Object System.Management.Automation.PSCredential($ESXiUsername,$ESXiEncrpytedPassword)
    Connect-VIServer -Server $ESXiServer -Credential $ESXiCredentials

    Get-VM | Foreach-Object {
        $vm = $_.Name
        Get-Snapshot -VM $_.Name | Foreach-Object {
            $Report = "" | Select-Object Name,Description,State,"VM Name","Created Date","Size (MB)","Is Current","Age (Days)"
            $Report."VM Name" = $vm
            $Report.Name = $_.Name
            $Report.Description = $_.Description
            $Report.State = $_.PowerState
            $Report."Created Date" = $_.Created
            $Report."Size (MB)" = $_.SizeMB
            $Report."Is Current" = $_.IsCurrent
            $Report."Age (Days)" = ((Get-Date) - $_.Created).TotalDays
            $Report
        }
    }
    Disconnect-VIServer -Server $ESXiServer
}