function Get-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param
		(
		        
        [parameter(Mandatory)]
		[String[]]
		$CheckFile,

        [parameter(Mandatory)]
		[String]
		$Server,
        
        [ValidateRange(1,65535)]
        [unit16]
		$Port = 8111,

        [ValidateSet("HTTP","HTTPS")]
        [String]
		$Protocol = "HTTPS",

        [parameter(Mandatory)]
		[String]
		$BuildID,


        [parameter(Mandatory)]
		[String]
		$User,
        
        [parameter(Mandatory)]
		[PSCredential]
		$PasswordCredential,

		[ValidateSet("Present","Absent")]
		[String]
		$Ensure = "Present",

        
        [uint16]
		$BuildTimeout = 30
	)




	
	$returnValue = @{
		BuildID = $BuildID
        CheckFile = $CheckFile
		Server = $Server
		Port = $Port
		Protocol = $Protocol
		User = $User
		Password = "PSCredential"
		Ensure = $Ensure
        BuildTimeout = $BuildTimeout
	}

	return $returnValue
	
}


function Set-TargetResource
{
	[CmdletBinding()]
	param
		(
		        
        [parameter(Mandatory)]
		[String[]]
		$CheckFile,

        [parameter(Mandatory)]
		[String]
		$Server,
        
        [ValidateRange(1,65535)]
        [unit16]
		$Port = 8111,

        [ValidateSet("HTTP","HTTPS")]
        [String]
		$Protocol = "HTTPS",

        [parameter(Mandatory)]
		[String]
		$BuildID,


        [parameter(Mandatory)]
		[String]
		$User,
        
        [parameter(Mandatory)]
		[PSCredential]
		$PasswordCredential,

		[ValidateSet("Present","Absent")]
		[String]
		$Ensure = "Present",

        
        [uint16]
		$BuildTimeout = 30
	)

    
#Create event log source for module
   try
   {
       $myLogSource = $PSCmdlet.MyInvocation.MyCommand.ModuleName
       New-Eventlog -LogName "DevOps" -Source $myLogSource -ErrorAction SilentlyContinue
   }
   catch{}


#build URI for API request
#default port is 8111 - see $port param
#default protocol is https - see $protocol param

    $buildURI = ($protocol,"://",$Server,":",$Port,"/httpAuth/rest/buildQueue" -join '')
    Write-Verbose -Message "`$buildURI = $buildURI"

#convert credentials for use with basic auth against API

    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $User,$PasswordCredential)))
    Write-Verbose -Message "`$base64AuthInfo = $base64AuthInfo"


#create xml object used in body of build API request

    [xml]$buildXML = {
    <build>
    <buildType id="BuildTypeID"/>
    </build>
    } -replace "BuildTypeID",$BuildID
    Write-Verbose -Message "`$buildXML = $buildXML"




#Log build time to registry value and initiate build

    $loggedTime = Get-Date

    $regPath = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\WinDevOps"

    if(!(Test-Path -Path $regPath))
    {
        New-Item -Path $regPath -Name "WinDevOps" -Force
    }

    $i = 0
    $retries = 5
    $timeout = 10

    do{
        try
        {
            $response = (Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -Body $buildXML -uri $buildURI)
            Set-ItemProperty -Path $regPath -Name "TeamCityBuildTime" -Value $loggedTime -Force
            $i = $retries
        }

        catch
        {
            Write-Verbose -Message "Build attempt failed, sleeping for $timeout seconds before retry"
            Write-EventLog -LogName DevOps -Source rsTeamCityBuild -EntryType Warning -Message "Build attempt failed, sleeping for $timeout seconds before retry `n $($_.Exception.Message)"
            $i++
            Start-Sleep -Seconds $timeout
        }
    }

    while ($i -lt $retries)
}


function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
		(
		        
        [parameter(Mandatory)]
		[String[]]
		$CheckFile,

        [parameter(Mandatory)]
		[String]
		$Server,
        
        [ValidateRange(1,65535)]
        [unit16]
		$Port = 8111,

        [ValidateSet("HTTP","HTTPS")]
        [String]
		$Protocol = "HTTPS",

        [parameter(Mandatory)]
		[String]
		$BuildID,


        [parameter(Mandatory)]
		[String]
		$User,
        
        [parameter(Mandatory)]
		[PSCredential]
		$PasswordCredential,

		[ValidateSet("Present","Absent")]
		[String]
		$Ensure = "Present",

        
        [uint16]
		$BuildTimeout = 30
	)




if ($Ensure -eq "Present")
	{
        Write-Verbose -Message "Checking for $checkFile"

		if((Test-Path -Path $CheckFile) -contains $false)
        {
            Write-Verbose -Message "A `$checkFile is not present, checking registry value for recent build"
            
            try
            {
                
                $buildTime = ((Get-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\WinDevOps" -Name "TeamCityBuildTime" -ErrorAction Stop).TeamCityBuildTime)
                
                $currentTime = Get-Date
                
                $timeDiff = (New-TimeSpan -Start $buildTime -End $currentTime).Minutes

                if($timeDiff -lt $BuildTimeout)
                {
                    Write-Verbose -Message "Build initiated within timeout, exiting"
                    return $true
                }

                else
                {
                    Write-Verbose -Message "Build timeout expired"
                    return $false
                }


            }

            catch
            {
                if(!($buildTime))
                {
                    Write-Verbose -Message "Error - HKEY_LOCAL_MACHINE\SOFTWARE\WinDevOps\TeamCityBuildTime value does not exist"
                }

                else
                {
                    Write-Verbose -Message "Error - HKEY_LOCAL_MACHINE\SOFTWARE\WinDevOps\TeamCityBuildTime value exists, but try block failed"
                }

                return $false
            }
        }

        else
        {
            Write-Verbose -Message "`$checkFile present, all good"
            return $true
        }
    }

    else
{
    Write-Verbose -Message "`$Ensure set to false, exiting"
    return $true
}


}


Export-ModuleMember -Function *-TargetResource
