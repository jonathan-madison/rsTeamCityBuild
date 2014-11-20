$user = "admin"
$pass = "fmsource001"
$statusAPI = ""

$webclient = New-Object System.Net.WebClient
$webclient.Credentials = New-Object System.Net.NetworkCredential($user,$pass)
$webclient.ResponseHeaders

Invoke-RestMethod -uri http://source.doubledutch.me/app/rest/projects -Method Get -Headers @{}

http://teamcity:8111/httpAuth/app/rest/projects


$user = "devops"
$pass = "fmsource001"
$uri = "http://source.doubledutch.me/app/rest/projects"
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user,$pass)))

$proj = Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -uri $uri