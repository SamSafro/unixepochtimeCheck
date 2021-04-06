## Get machine time zone, hour and year for check. ##
$item = [System.TimeZone]::CurrentTimeZone | Select-Object -Property StandardName
$timezone = [string]$item.StandardName
$currenthour = (Get-Date).hour
$currentyear = (Get-Date).year
$currentmonth = (Get-Date).month
$currentminute = (Get-Date).minute
$zero = 0

## If hour is between 0 and 9am, add 0 for comparison from api pull ##
if ($currenthour -lt 10) {
    $currenthour = -join ($zero, $currenthour)
    }

## Take time zone from above and grab known time for that zone ##
if ($timezone -match "Mountain") {
    Write-Output "Mountain Standard Time" 
    $TimeZone = "America/Denver" 
    $TimeZoneURI = "http://worldtimeapi.org/api/timezone/" + $TimeZone
    $TimeZoneInfo = Invoke-RestMethod -Uri $TimeZoneURI -Method GET
    } 
    elseif ($timezone -match "Pacific") {
    $TimeZone = "America/Los_Angeles" 
    $TimeZoneURI = "http://worldtimeapi.org/api/timezone/" + $TimeZone
    $TimeZoneInfo = Invoke-RestMethod -Uri $TimeZoneURI -Method GET
    Write-Output "Pacific Standard Time"
    } 
    elseif ($timezone -match "Eastern") {
    Write-Output "Eastern Standard Time"
    $TimeZone = "America/New_York" 
    $TimeZoneURI = "http://worldtimeapi.org/api/timezone/" + $TimeZone
    $TimeZoneInfo = Invoke-RestMethod -Uri $TimeZoneURI -Method GET 
    } else {
    Write-Output "Central Standard Time" 
    $TimeZone = "America/Mexico_City" 
    $TimeZoneURI = "http://worldtimeapi.org/api/timezone/" + $TimeZone
    $TimeZoneInfo = Invoke-RestMethod -Uri $TimeZoneURI -Method GET
    }

## Pull two digit hour out of string ##
$desiredtime = $timezoneinfo.unixtime


## This string manipulation is for comparison against hours ##
#$desiredtime = $timezoneinfo.datetime
#$desiredtime = $desiredtime.Substring(11)
#$desiredtime = $desiredtime -replace ".{19}$"
#Write-Output $desiredtime

## Make sure DesiredTime isn't null ##
if (!$desiredtime) {
for ($counter = 1; $counter -le 5; $counter++ )
{
if ($timezone -match "Mountain") {
    Write-Output "Mountain Standard Time" 
    $TimeZone = "America/Denver" 
    $TimeZoneURI = "http://worldtimeapi.org/api/timezone/" + $TimeZone
    Sleep -Seconds 5
    $TimeZoneInfo = Invoke-RestMethod -Uri $TimeZoneURI -Method GET
    } 
    elseif ($timezone -match "Pacific") {
    $TimeZone = "America/Los_Angeles" 
    $TimeZoneURI = "http://worldtimeapi.org/api/timezone/" + $TimeZone
    Sleep -Seconds 5
    $TimeZoneInfo = Invoke-RestMethod -Uri $TimeZoneURI -Method GET
    Write-Output "Pacific Standard Time"
    } 
    elseif ($timezone -match "Eastern") {
    Write-Output "Eastern Standard Time"
    $TimeZone = "America/New_York" 
    $TimeZoneURI = "http://worldtimeapi.org/api/timezone/" + $TimeZone
    Sleep -Seconds 5
    $TimeZoneInfo = Invoke-RestMethod -Uri $TimeZoneURI -Method GET 
    } else {
    Write-Output "Central Standard Time" 
    $TimeZone = "America/Mexico_City" 
    $TimeZoneURI = "http://worldtimeapi.org/api/timezone/" + $TimeZone
    Sleep -Seconds 5
    $TimeZoneInfo = Invoke-RestMethod -Uri $TimeZoneURI -Method GET
    }
  }
}

if (!$desiredtime) {
    Write-Output "<-Start Result->"
    Write-Output "Result=Unable To Pull TimeInfo"
    Write-Output "<-End Result->"
    exit 0
    }

if ($currenthour -ne $desiredtime) {
    Write-Output "Time is off by at least 1 hour"
    Write-Output "Rest Date and Time"
    Write-Output "<-Start Result->"
    Write-Output "Result=Time Off By At Least An Hour"
    Write-Output "<-End Result->"
    exit 1
    } else { 
    Write-Output "Time is set correctly" 
    Write-Output "<-Start Result->"
    Write-Output "Result=Time Set Correctly"
    Write-Output "<-End Result->"
    exit 0
    }

    <## Unix Epoch Approach ##
    
    The Fix: use ghetto time command in cmd and then restart cp service

    ## Two ways to get the machines time relative to unix utc
    
    $thispctime = [Math]::Floor([decimal](Get-Date(Get-Date).ToUniversalTime()-uformat "%s"))
    $thispctime

    $unixEpochStart = new-object DateTime 1970,1,1,0,0,0,([DateTimeKind]::Utc)
    [int]([DateTime]::UtcNow - $unixEpochStart).TotalSeconds



https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-date?view=powershell-7.1

we see that unix time on machine is greater than desired by more than 30 minutes in milliseconds
or we see that unix time on machine isis less than desired by more than 30 minutes in milliseconds

can pshell compare these  
Get-Date -Format "HH:mm"

Get-Date "dddd MM/dd/yyyy HH:mm K"
Get-Date -Date "MM/dd/yyyy"













#>