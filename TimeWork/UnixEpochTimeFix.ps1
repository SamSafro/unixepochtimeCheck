<########################################################################
This script will check the machines UTC time agains unix time then compare
that to worldtimeapi.org's unixtime. The script then uses the difference to
manually adjust the clock. It then restarts content player service to bring
the machine back online in fwi-cloud if needed.

Developed by:
   Sam Safronoff - Sam.Safronoff@fourwindsinteractive.com - April 2021
#########################################################################>

## Get current machine time against unix epoch in seconds ##
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

## Convert difference between current and actual unix time and add or subtract that to the system clock ##
$differenceinseconds = $currenttime - $unixtime
$differenceinminutes = $differenceinseconds/60
## Inverse the difference to bring the clock to the correct time ##
$adjusttime = $differenceinminutes * -1

## Adjust time accordingly ##
Set-Date -Date (Get-Date).Addminutes($adjusttime)
Restart-Service "Content Player Service"