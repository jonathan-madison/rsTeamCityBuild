Function Get-rsTeamCityVersion{
[OutputType([Hashtable])]
param(


)
$versionMajor = ((Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -uri $baseURI).server|select -ExpandProperty versionMajor)
$versionMinor = ((Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -uri $baseURI).server|select -ExpandProperty versionMinor)


$versionInfo = @{
                versionMajor = $versionMajor
                versionMinor = $versionMinor
                }


return $versionInfo

}