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
$uri = "http://source.doubledutch.me/app/rest/"
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user,$pass)))

(Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -uri ($uri,"server" -join '')).server

(Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -uri ($uri,"builds" -join '')).builds.build

(Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -uri ($uri,"projects/id:Deployments" -join '')).project


(Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -uri ($uri,"agents" -join '')).agents.agent

(Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -uri ($uri,"buildQueue" -join '')).builds