$loggedTime = Get-Date

$newtime = Get-Date

Set-Content -Path "C:\DSC\deploytime.txt" -Value $loggedTime

$fileTime = Get-Content -Path "C:\DSC\deploytime.txt"



$Path = "C:\DevOps"
$File = "TCBuildTime.txt"

if(!(Test-Path -Path ($Path+$File -join '\'))){
    $loggedTime = Get-Date
    New-Item -Path $Path -Name $File -ItemType "file" -Force
    Set-Content -Path ($Path+$File -join '\') -Value $loggedTime
}
else{
Write-Host "File Present"
}


Get-Content -Path $Path


Remove-Item -Path $Path


#SET
if(!(Test-Path -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\WinDevOps")) {
   New-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE" -Name "WinDevOps" -Force
   Set-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\WinDevOps" -Name "TeamCityBuildTime" -Value $loggedTime -Force
}


if(!(Get-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\WinDevOps" -Name "BuildScript")){}
   Set-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\WinDevOps" -Name "BuildScript" -Value 1 -Force

