Script changeAllowedIPs {
         $GetScript = { return (@{"allowedAddresses"="192.168.*.*,127.0.0.1,::1,192.30.252.*"})}
         SetScript = {
            [xml]$webConfig = Get-Content "C:\inetpub\wwwroot\Arnie\Arnie\web.config"
            $webConfig.configuration.arnieConfig.allowedAddresses = "192.168.*.*,127.0.0.1,::1,192.30.252.*"
            $webConfig.Save("C:\inetpub\wwwroot\Arnie\Arnie\web.config")
         }
         TestScript = {
            [xml]$webConfig = Get-Content "C:\inetpub\wwwroot\Arnie\Arnie\web.config"
            if( $webConfig.configuration.arnieConfig.allowedAddresses -eq "192.168.*.*,127.0.0.1,::1,192.30.252.*" )
            {return $true} 
            else {return $false}
         }
         DependsOn = "[rsGit]Arnie"
      } 


      Function blah{
      return (@{"allowedAddresses"="192.168.*.*,127.0.0.1,::1,192.30.252.*"})
      }

      blah