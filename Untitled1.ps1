New-EventLog -LogName "DevOps" -Source BasePrep


if(Get-EventLog -LogName "System" -ErrorAction SilentlyContinue){return $true}
else{ return $false}


