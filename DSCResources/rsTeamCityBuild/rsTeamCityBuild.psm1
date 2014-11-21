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


function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$Name,

		[System.String]
		$CheckFile,

		[System.String]
		$TeamCityAPIBuild,

		[System.String]
		$TeamCityUser,

		[System.String]
		$TeamCityPass,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)
$IsValid = $false
	
	if ($Ensure -like 'Present')
	{
		Write-Verbose "Checking for $CheckFile"
		if(!(Test-Path -Path $CheckFile))
		{
			Write-Verbose "$CheckFile is not present, Checking API for build in progres"
            
		}
        
		else
		{
			Write-Verbose "$CheckFile is present, build not needed"
			$IsValid = $true
            
		}
	}
	else
	{
		Write-Verbose "Ensure set to False, no action needed."
		$IsValid = $true
	}
	return $IsValid
}


Export-ModuleMember -Function *-TargetResource

