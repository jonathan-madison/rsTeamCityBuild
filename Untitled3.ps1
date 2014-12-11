Function Check-rsTeamCityBuild{
param(
[string(mandatory=$true)]
$TeamCityServer,

[int32(mandatory=$true)]
$TeamCityPort,

[string(mandatory=$true)]
$TeamCityUser,

[string(mandatory=$true)]
$TeamCityPass,

[string(mandatory=$true)]
$BuildTypeID
)
#convert credentials to Base64 for auth header
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $TeamCityUser,$TeamCityPass)))

#define starting URI
$baseURI = ("https://"+$TeamCityServer+":"+$TeamCityPort+"/app/rest/server" -join '')

#return API version info V1
$versionInfo = (Get-VersionV1 -base64AuthInfo $base64AuthInfo -baseURI $baseURI)
if($versionInfo.versionMajor -ne "8"){
#do whatever
}



#return API version info V2
$info = ((Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -uri $baseURI).server)
if($info.versionMajor -ne "8"){
#do whatever
}




}

Function Get-VersionV1{
[OutputType([Hashtable])]
param(
[string]$base64AuthInfo,
[string]$baseURI
)

$versionMajor = ((Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -uri $baseURI).server|select -ExpandProperty versionMajor)
$versionMinor = ((Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -uri $baseURI).server|select -ExpandProperty versionMinor)


$versionInfo = @{
                versionMajor = $versionMajor
                versionMinor = $versionMinor
                }


return $versionInfo
}







Function Get-VersionV2{
[OutputType([Hashtable])]
param(
[string]$base64AuthInfo,
[string]$baseURI
)

$versionMajor = ((Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -uri $baseURI).server|select -ExpandProperty versionMajor)
$versionMinor = ((Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -uri $baseURI).server|select -ExpandProperty versionMinor)


$versionInfo = @{
                versionMajor = $versionMajor
                versionMinor = $versionMinor
                }


return $versionInfo
}

