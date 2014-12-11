$TeamCityUser = "devops"
$TeamCityPass = "fmsource001"
$TeamCityServer = "source.doubledutch.me"
$ProjectID = "Deployments"
$BuildTypeID = "Deployments_HCacheDeploy"
$TeamCityPort = [int32]443

[xml]$buildXML = {
<build>
<buildType id="BuildTypeID"/>
</build>
} -replace "BuildTypeID",$BuildTypeID

$uri = ("https://"+$TeamCityServer+":"+$TeamCityPort+"/app/rest" -join '')
$uri = ("https://"+$TeamCityServer+":"+$TeamCityPort+"/app/rest/projects/id:"+$ProjectID -join '')

$projectURI = ($uri,"/projects/id:",$ProjectID -join '')
$buildURL = ($projectURI)
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $TeamCityUser,$TeamCityPass)))

(Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -uri $uri).projects.project.Deployments
$builduri2 = ((Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -uri $uri).project.buildTypes.buildType|Where-Object {$_.id -eq "$BuildTypeID"}|select -expa href)

(Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -uri $uri).projects.project

(Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -uri ($uri,$builduri2 -join '')).buildtype

###Check to see if project and build exists

$exists = $null
$exists = ((Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -uri ($uri,"/projects/id:$ProjectID" -join '')).project.buildTypes.buildtype | where {$_.id -eq $BuildTypeID})
if($exists){return $true}else{return $false}
if($exists){return "yes"}

(Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -uri ($uri,"agents" -join '')).agents.agent

(Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -uri ($uri,"buildQueue" -join '')).builds

Function Test-rsBuildExists
{
param(
[System.String]
$TeamCityServer,

[System.String]
$ProjectID,


[System.String]
$a

)
}