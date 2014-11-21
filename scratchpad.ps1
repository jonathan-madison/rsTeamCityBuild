$TeamCityUser = "admin"
$TeamCityPass = "fmsource001"
$TeamCityServer = "source.doubledutch.me"
$ProjectID = ""
$BuildTypeID = "Deployments_HCacheDeploy"

$buildXML = [xml]{
<build>
</build>}
$buildXML.build.AppendChild()

$buildID = 


    <buildType id =$BuildTypeID/>

$projectURI = ($uri,"/projects/id:",$ProjectID -join '')
$buildURL = ($projectURI)
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $TeamCityUser,$TeamCityPass)))

(Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -uri ($uri,"server" -join '')).server

(Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -uri ($uri,"builds" -join '')).builds.build

###Check to see if project and build exists
$exists = ((Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -uri ($uri,"projects/id:Deployments" -join '')).project.buildTypes.buildtype | where {$_.id -eq "Deployments_HCacheDeploy"})
$exists
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