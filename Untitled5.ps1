    $readfile = ((Get-Content "C:\Users\jonathan.madison\Documents\GitHub\869379_DoubleDutchHK\SecureCredentials.json") -join "`n"|ConvertFrom-Json)




    $readfile = $readfile |ConvertTo-Json
    $user = "jmadtest"

    $readfile = ($readfile|ConvertTo-Json)

    
    $newjson = @{"Administrator"=@{"thumbprint" = "123456";"encrypted_key" = "8976546"}}|ConvertTo-Json

    
    
    $newjson = $newjson|ConvertTo-Json


    $output = $readfile+=$newjson|ConvertTo-Json

    $new = @{
        Administrator2 = @{
            thumbprint = "12345"
            encrypted_key = "98765"
        }
    }

    $new2 = New-Object psobject -Property $new


    $readfile | Get-Member

    foreach($member in ($readfile|get-member | Where-Object {$_.Name -NotMatch "Equals|GetHashCode|GetType|ToString"})){
    write-host $member.Name
    }
    

    $readfile += $newjson

    ($readfile |ConvertFrom-Json)



$readfile | Add-Member -PassThru NoteProperty params @{User2={thumbprint=}}


$thumb = $readfile.Administrator.thumbprint

$key = $readfile.Administrator.encrypted_key

$data = $readfile.Administrator.encrypted_data


$json = (@{AdministratorNew = @{encrypted_data = $data; encrypted_key = $key; thumbprint = $thumb}}|ConvertTo-Json)

$readfile += $json


Get-command *Member

$_.UserName = @{
                    "encrypted_data" = $encryptedSecureString;
                    "encrypted_key"  = [System.Convert]::ToBase64String($encryptedKey);
                    "thumbprint"     = [System.Convert]::ToBase64String([char[]]$Thumbprint)
                }

                $readfile = @()
                $readfile += @{User2=@{"value"="2"}}|ConvertTo-Json
                $readfile += @{User3=@{"value"="2"}}|ConvertTo-Json