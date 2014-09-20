
rsTeamCityBuild
=======================


check a folder for presence of a key file (e.g. web.config)

if present, do nothing

if not present, submit HTTP request using basic auth to team city server api

=======================
Usage
=======================
<pre>
rsTeamCityBuild test1
{
  Name = "prod1"
  CheckFile = "C:\inetpub\wwwroot\test.txt"
  TeamCityAPIBuild = "https://23.253.104.253/httpAuth/action.html?add2Queue=Test1_80"
  TeamCityUser = "admin"
  TeamCityPass = "blahblah"
  Ensure = "Present"
  DependsOn = @("[xWebsite]jmad_rackspacedevops_com")
}
</pre>
