Function Get-SnapshotReport {
    Param (
        [String]$ESXiServer,
        [String]$ESXiUsername,
        [SecureString]$ESXiSecurePassword,
        [Uri]$PrtgUri = "http://brazil.bridgepartners.local:5050/9F53BAD6-E2FF-40B1-A25A-C845FF8CA182"
    )
    Write-Debug -Message "ESXiSecurePassword = $ESXiSecurePassword"
    $ESXiCredentials = New-Object System.Management.Automation.PSCredential($ESXiUsername,$ESXiSecurePassword)
    Connect-VIServer -Server $ESXiServer -Credential $ESXiCredentials

    [XML]$xmlBody = New-Object System.Xml.XmlDocument
    $xmlDeclaration = $xmlBody.CreateXmlDeclaration("1.0","UTF-8",$null)
    $xmlBody.AppendChild($xmlDeclaration) | Out-Null
    $xmlRoot = $xmlBody.CreateNode("element","prtg",$null)

    Get-VM | Foreach-Object {
        $vm = $_.Name
        Get-Snapshot -VM $_.Name | Foreach-Object {
            $xmlResult = $xmlBody.CreateNode("element","result",$null)
            $xmlUnit = $xmlBody.CreateNode("element","CustomUnit",$null)
            $xmlUnit.InnerText = "Days"
            $xmlChannel = $xmlBody.CreateNode("element","channel",$null)
            $xmlChannel.InnerText = $vm
            $xmlValue = $xmlBody.CreateNode("element","value",$null)
            $snapshotAge = ((Get-Date) - $_.Created).Days
            $xmlValue.InnerText = $snapshotAge
            $xmlWarning = $xmlBody.CreateNode("element","Warning",$null)
            IF ($snapshotAge -ge 10) {
                $xmlWarning.InnerText = "1"
            } ELSE {
                $xmlWarning.InnerText = "0"
            }
            $xmlResult.AppendChild($xmlChannel)
            $xmlResult.AppendChild($xmlValue)
            $xmlResult.AppendChild($xmlUnit)
            $xmlResult.AppendChild($xmlWarning)
            $xmlRoot.AppendChild($xmlResult)
        }
    }
    Disconnect-VIServer -Server $ESXiServer -Confirm:$false
    $xmlBody.AppendChild($xmlRoot)
    #Invoke-RestMethod -Method POST -ContentType "application/xml" -UseBasicParsing -Uri $PrtgUri -Body $xmlBody
    $xmlBody.OuterXml
}