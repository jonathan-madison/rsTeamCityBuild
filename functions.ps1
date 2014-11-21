
### Checks for presence of files in $CheckFile array
Function Invoke-rsCheckFiles{
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

$buildStatusURI = 


}
