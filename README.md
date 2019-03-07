# Get-SnapshotReport

This function will interrogate all snapshots for all VMs on a VMware ESXi Host and report the age of each snapshot back to PRTG.

## Parameters

**ESXiServer**
This parameter allows you to specify the address of the ESXi host.

**ESXiUsername**
This parameter allows you to specify the username used to authenticate against the ESXi Host.

**ESXiSecurePassword**
This parameter allows you to specify the password used to authenticate against the ESXi Host.
The password must be supplied in the format of a SecureString.

SecureStrings can be converted into encrypted standard strings so that they can be included in scripts.
They can only be decrypted by the user who encrypted them meaning that you can, as the user who will run the script, convert the secure string to an encrypted string and save the password in the script with confidence that, if someone obtained the encrypted password, they would be unable to decrypt it.

To obtain your encrypted password string, run the following command as the user as whom the script will be run:
`ConvertFrom-SecureString -SecureString (Get-Credentials).Password`

Once you have your encrypted string, you can provide the function to convert it to a secure string as your parameter value:
`ConvertTo-SecureString -String "ENCRYPTED STRING"`

**PrtgUri**
This parameter allows you to specify the base URI of a PRTG system.  Currently it has a default value of the base URI for PRTG at Bridge Partners.  

**PrtgSensorGUID**
This parameter allows you to provide the GUID of the sensor to which you wish to send the data.  You can find this by editing the sensor settings within PRTG.

You can specify this parameter in order to override the default value.

**WarningThreshold**
This parameter allows you to specify the age of a snapshot, in days, which is considered 'too old'.  If a snapshot exceeds this age then it is flagged as a warning within PRTG.  Currently it defaults to 10 days but you can specify this parameter to overwrite the value.

## Usage

`Get-SnapshotReport -ESXiServer servername.domain.com -ESXiUsername "domain\username" -ESXiSecurePassword (ConvertTo-SecureString -String "ENCRYPTED STRING")`