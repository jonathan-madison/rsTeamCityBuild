
### Checks for presence of files in $CheckFile array
Function Get-rsCheckFiles{
param (
[string[](mandatory=$true)]
$CheckFile
)

    foreach($file in $CheckFile){
        if(!(Test-Path $file)){
        return $false
        }

        else{
        return $true
        }
    }

}





### Checks for TeamCityBuild in progress
Function Get-rsBuildInProgress{
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

#define base API request including auth
$baseURI = ("https://"+$TeamCityServer+":"+$TeamCityPort+"/app/rest/server" -join '')
(Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -uri $baseURI).server|select -ExpandProperty versionMajor

$app = ($baseRequest+"/app/rest/server" -join '')


}

