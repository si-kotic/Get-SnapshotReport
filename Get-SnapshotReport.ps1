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
            $xmlChannel = $xmlBody.CreateNode("element","channel",$null)
            $xmlChannel.InnerText = $vm
            $xmlValue = $xmlBody.CreateNode("element","value",$null)
            $xmlValue.InnerText = ((Get-Date) - $_.Created).Days
            $xmlResult.AppendChild($xmlChannel)
            $xmlResult.AppendChild($xmlValue)
            $xmlRoot.AppendChild($xmlResult)
        }
    }
    Disconnect-VIServer -Server $ESXiServer -Confirm:$false
    $xmlBody.AppendChild($xmlRoot)
    #Invoke-RestMethod -Method POST -ContentType "application/xml" -UseBasicParsing -Uri $PrtgUri -Body $xmlBody
    $xmlBody.OuterXml
}