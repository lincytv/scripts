$To = "lincy.varghese@powerupcloud.com"

$From = "audit@powerupcloud.com"

$Subject = "10days expiring user report"

$Subject1 = " expiring user report For All users"

$Body = "The attached CSV file contains a list of user accounts in the domain that are due to expire in the next 10 days."

$Body1 = "The attached CSV file contains a list of all user accounts in the domain With password expire date"

$SMTPServer = "localhost"

$ReportName = "C:\10days_Expiring_Users_$Date.csv"

$ReportName1 = "C:\all_days_Expiring_Users_$Date.csv"

$DaysWithinExpiration = 10

$MaxPwdAge   = (Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge.Days

$expiredDate = (Get-Date).addDays(-$MaxPwdAge)

$emailDate = (Get-Date).addDays(-($MaxPwdAge - $DaysWithinExpiration)).ToShortDateString()

$userlist = Get-ADUser -Filter {(PasswordLastSet -lt $emailDate) -and (PasswordLastSet -gt $expiredDate) -and (PasswordNeverExpires -eq $false) -and (Enabled -eq $true)} –Properties "PasswordLastSet","DisplayName", "msDS-UserPasswordExpiryTimeComputed"|Select-Object -Property "DisplayName",@{Name="Expirydate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}

If ($UserList -eq $null){}

Else

{

   $UserList | Export-CSV $ReportName

   Send-MailMessage -To $To -From $From -Subject $Subject -Body $Body -SMTPServer $SMTPServer -Attachments $ReportName

}

$userlist1= Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} -Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed" |Select-Object -Property "Displayname",@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}

If ($UserList1 -eq $null){}

Else

{

   $UserList1 | Export-CSV $ReportName1

   Send-MailMessage -To $To -From $From -Subject $Subject1 -Body $Body1 -SMTPServer $SMTPServer -Attachments $ReportName1

}
