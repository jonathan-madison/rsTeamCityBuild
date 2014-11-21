#Two paths to take, one with unique build id, one without



#Test Function

#1 Check for files on disk
    #a If all files present, return $true
    #b If any files missing, check API for build in progress (preferably with unique build id - servername)
        #i if In Progress, and return $true
        #ii else return $false

        
#Set Function

#1 Check that build ID actually exists
    #a if not, log error to eventlog

#2 Initiate build via API.




#Additional Functions

#1 Invoke-rsCheckFiles
#2 Get-rsBuildInProgress
#3 Start-rsTeamCityBuild
#4 Get-rsTeamCityAPIVersion (forward compatibility)
#5 Get-rsBuildExists