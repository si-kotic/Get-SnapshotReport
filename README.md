# Get-SnapshotReport

This function will provide a report on all snapshots for all VMs on a VMware ESXi Host.

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

## Usage

Get-SnapshotReport -ESXiServer servername.domain.com -ESXiUsername "domain\username" -ESXiSecurePassword (ConvertTo-SecureString -String "ENCRYPTED STRING")

## Example Output

```
Name                           Port  User                    
----                           ----  ----                    
servername.domain.com          443   DOMAIN\username

Description  : Before a reboot.
State        : PoweredOn
VM Name      : INDEXSVR
Created Date : 12/01/2013 09:51:52
Size (MB)    : 48488.62887287139892578125
Is Current   : True
Age (Days)   : 2243.18111577797
```