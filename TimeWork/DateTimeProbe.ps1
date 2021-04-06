<########################################################################
This script will check the machines UTC time agains unix time then compare
that to worldtimeapi.org's unixtime. It will alert if the machine is out of 
sync. The amount of time that equals out of sync can be changed at line 43.

Developed by:
   Sam Safronoff - Sam.Safronoff@fourwindsinteractive.com - April 2021

#########################################################################>

## Get what this machine thinks is UTC Time and calculate unixtime ##
$unixEpochStart = new-object DateTime 1970,1,1,0,0,0,([DateTimeKind]::Utc)
$currenttime = [int]([DateTime]::UtcNow - $unixEpochStart).TotalSeconds  

## Get posted UnixEpoch Time from worldtimeapi.org ## 
$TimeZone = "America/Denver" 
$TimeZoneURI = "http://worldtimeapi.org/api/timezone/" + $TimeZone
$TimeZoneInfo = Invoke-RestMethod -Uri $TimeZoneURI -Method GET
$unixtime = $timezoneinfo.unixtime

## Make sure UnixTime isn't null ##
if (!$unixtime) {
for ($counter = 1; $counter -le 5; $counter++ ){
$TimeZone = "America/Denver" 
$TimeZoneURI = "http://worldtimeapi.org/api/timezone/" + $TimeZone
$TimeZoneInfo = Invoke-RestMethod -Uri $TimeZoneURI -Method GET
$unixtime = $timezoneinfo.unixtime
    }
  }
## If UnitxTime still Null exit good ##
if (!$unixtime) {
    Write-Output "<-Start Result->"
    Write-Output "Result=Unable To Pull TimeInfo"
    Write-Output "<-End Result->"
    exit 0
    }

## Convert to a positive integer for compare below ##
$negcheck = $currenttime - $unixtime
if ($negcheck -lt 0) { $unixtime = $negcheck * -1 } else { $unixtime = $negcheck }

## If Unixtime is greater than or equal to 30 minutes in seconds exit in a bad state ##
if ($unixtime -ge 600) {
    Write-Host "Result=Time Off by +-10min"
    } else { 
    Write-Output "Result=Time Set Correctly"
    }