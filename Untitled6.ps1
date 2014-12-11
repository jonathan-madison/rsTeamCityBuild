$TeamCityUser = "devops"
$TeamCityPass = "fmsource001"
$Server = "source.doubledutch.me"
$ProjectID = "Deployments"
$BuildTypeID = "Deployments_HKApiRole"
$Protocol = "https"
$Port = "443"


#create auth header
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $TeamCityUser,$TeamCityPass)))
$authHeader = @{Authorization=("Basic {0}" -f $base64AuthInfo)}

#create URIs
if($Port){
    $baseURI = ($Protocol+"://"+$Server+":"+$Port+"/app/rest" -join '')
    $infoURI = $($baseURI+"/server" -join '')
    $buildURI = $($baseURI+"/builds" -join '')
    $projectURI = $($baseURI+"/projects/id:Deployments" -join '')

}
else{
    $baseURI = ($Protocol+"://"+$Server+"/app/rest" -join '')
    $infoURI = $($baseURI+"/server" -join '')
    $buildURI = $($baseURI+"/builds" -join '')
    $projectURI = $($baseURI+"/projects/id:$ProjectID" -join '')
}



#check build exists

$info = (Invoke-RestMethod -Headers $authHeader -uri $infoURI)  
$projects  = (Invoke-RestMethod -Headers $authHeader -uri $projectURI) 
$buildcheck = (Invoke-RestMethod -Headers $authHeader -uri $buildURI)


$versioninfo = (Get-rsTeamCityAPIVersion -baseURI $baseURI -authHeader $authHeader)
$versionMajor = $versioninfo[0]
$versionMinor = $versioninfo[1]


$buildExists = (Get-rsBuildTypeIDExists -baseURI $baseURI -authHeader $authHeader -ProjectID $ProjectID -BuildTypeID $BuildTypeID)



    #including function to return major and minor API version - future compatibility may need this

    function Get-rsTeamCityAPIVersion{
        param(
            [string]$baseURI,
            [hashtable]$authHeader
        )
        #build uri to api info
        $infoURI = $($baseURI+"/server" -join '')

        #retrieve api info
        $apiInfo  = (Invoke-RestMethod -Headers $authHeader -uri $infoURI) 

        $versionMajor = ($apiInfo.server.versionMajor)

        $versionMinor = ($apiInfo.server.versionMinor)

        return ($versionMajor,$versionMinor)

    }




    #used to check if supplied buildTypeID  exists under ProjectID
    function Get-rsBuildTypeIDExists{
    param(
    [string]$baseURI,
    [hashtable]$authHeader,
    [string]$ProjectID,
    [string]$BuildTypeID
    )
        #build uri to project root
        $projectURI = $($baseURI+"/projects/id:$ProjectID" -join '')
    
        #retrieve projects info
        $projects  = (Invoke-RestMethod -Headers $authHeader -uri $projectURI) 
    
    
        #check for existance of projects
        if($projects.project.buildTypes.buildtype|Where-Object {$_.id -eq $BuildTypeID}){
            return $true
        }
        else{
            return $false
        }
    }