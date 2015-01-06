function Get-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$Name
	)

	#Write-Verbose "Use this cmdlet to deliver information about command processing."

	#Write-Debug "Use this cmdlet to write debug information while troubleshooting."


	
	$returnValue = @{
		Name = [System.String]
		CheckFile = [System.String]
		TeamCityAPIBuild = [System.String]
		TeamCityUser = [System.String]
		TeamCityPass = [System.String]
		Ensure = [System.String]
	}

	$returnValue
	
}


function Set-TargetResource
{
	[CmdletBinding()]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$BuildTypeID,

		[System.String[](Mandatory=$true)]
		$CheckFile,

		[System.String(Mandatory=$true)]
		$TeamCityServer,

		[System.String]
		$TeamCityPort,

		[System.String(Mandatory=$true)]
		$TeamCityUser,

		[System.String(Mandatory=$true)]
		$TeamCityPass,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)


	if ($Ensure -like 'Present')
	
Function Checkit{
    $CheckFile = @("C:\Dell\UpdatePackage\log\DELLMUP.log","C:\rs-pkgs\Error-Clone.txt")

    foreach($file in $CheckFile){
         
        if(!(Test-Path $file)){
            $notdeployed += $true
        }
        else{
            return $true
        }

        
    }
    if($notdeployed){return "not present"}
    else{return "present"}
}


	else
	{
		Write-Verbose "Ensure set to false, no action needed"
	}


}


function Get-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param
		(
		[parameter(Mandatory = $true)]
		[System.String]
		$Name,
        
        [parameter(Mandatory = $true)]
		[System.String[]]
		$CheckFile,

        [parameter(Mandatory = $true)]
		[System.String]
		$Server,
        
        [ValidateRange(1,65535)]
        [unit16]
		$Port,

        [ValidateSet("HTTP","HTTPS")]
        [System.String]
		$Protocol = "HTTPS",

        [parameter(Mandatory = $true)]
		[System.String]
		$ProjectID,

        [parameter(Mandatory = $true)]
		[System.String]
		$BuildTypeID,


        [parameter(Mandatory = $true)]
		[System.String]
		$User,
        
        [parameter(Mandatory = $true)]
		[System.String]
		$Password,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)




	
	$returnValue = @{
		Name = [System.String]$Name
		CheckFile = [System.String]
		TeamCityAPIBuild = [System.String]
		TeamCityUser = [System.String]
		TeamCityPass = [System.String]
		Ensure = [System.String]
	}

	$returnValue
	
}


function Set-TargetResource
{
	[CmdletBinding()]
	param
		(
		[parameter(Mandatory = $true)]
		[System.String]
		$Name,
        
        [parameter(Mandatory = $true)]
		[System.String[]]
		$CheckFile,

        [parameter(Mandatory = $true)]
		[System.String]
		$Server,
        
        [ValidateRange(1,65535)]
        [unit16]
		$Port,

        [ValidateSet("HTTP","HTTPS")]
        [System.String]
		$Protocol = "HTTPS",

        [parameter(Mandatory = $true)]
		[System.String]
		$ProjectID,

        [parameter(Mandatory = $true)]
		[System.String]
		$BuildTypeID,


        [parameter(Mandatory = $true)]
		[System.String]
		$User,
        
        [parameter(Mandatory = $true)]
		[System.String]
		$Password,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

    
#Create event log source for module
   try
   {
       $myLogSource = $PSCmdlet.MyInvocation.MyCommand.ModuleName
       New-Eventlog -LogName "DevOps" -Source $myLogSource -ErrorAction SilentlyContinue
   }
   catch{}


   if($Ensure -eq "Present")
   {
    
   }
   
	#Write-Verbose "Use this cmdlet to deliver information about command processing."

	#Write-Debug "Use this cmdlet to write debug information while troubleshooting."

	#Include this line if the resource requires a system reboot.
	#$global:DSCMachineStatus = 1
	if ($Ensure -like 'Present')
	{
		if(!(Test-Path -Path $CheckFile)) 
		{
			Write-Verbose "$CheckFile is not present, initiating build"
			$downloadtry = 1
			While ($attempt -lt 3)
				{
					try{
						$webclient = new-object System.Net.WebClient
						$webclient.Credentials = new-object System.Net.NetworkCredential($TeamCityUser, $TeamCityPass)
						$webpage = $webclient.DownloadString($TeamCityAPIBuild)
						$attempt = 3
					}
					catch{
						Write-Verbose "retrying"
						$downloadtry++
					}
				}
		}
		else
		{
			Write-Verbose "$CheckFile is present, no action needed."
		}
	}
	else
	{
		Write-Verbose "Ensure set to false, no action needed"
	}


}


function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
		(
		[parameter(Mandatory = $true)]
		[System.String]
		$Name,
        
        [parameter(Mandatory = $true)]
		[System.String[]]
		$CheckFile,

        [parameter(Mandatory = $true)]
		[System.String]
		$Server,
        
        [ValidateRange(1,65535)]
        [unit16]
		$Port,

        [ValidateSet("HTTP","HTTPS")]
        [System.String]
		$Protocol = "HTTPS",

        [parameter(Mandatory = $true)]
		[System.String]
		$ProjectID,

        [parameter(Mandatory = $true)]
		[System.String]
		$BuildTypeID,


        [parameter(Mandatory = $true)]
		[System.String]
		$User,
        
        [parameter(Mandatory = $true)]
		[System.String]
		$Password,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)




if ($Ensure -eq "Present")
	{
        Write-Verbose "Checking for $checkFile"

		if((Test-Path -Path $CheckFile) -contains $false)
        {
            Write-Verbose -Message "A `$checkFile is not present, checking registry value for recent build"
            
            try
            {
                
                $buildTime = ((Get-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\WinDevOps" -Name "TeamCityBuildTime" -ErrorAction Stop).TeamCityBuildTime)
                
                $currentTime = Get-Date
                
                $timeDiff = (New-TimeSpan -Start $buildTime -End $currentTime).Minutes

                if($timeDiff -lt $buildTimeout)
                {
                    Write-Verbose "Build initiated within timeout, exiting"
                    return $true
                }

                else
                {
                    Write-Verbose "Build timeout expired"
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
            Write-Verbose "`$checkFile present, all good"
            return $true
        }
    }

    else
{
    Write-Verbose "`$Ensure set to false, exiting"
    return $true
}


}


Export-ModuleMember -Function *-TargetResource

