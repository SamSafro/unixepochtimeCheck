<#

Breaking commands

$45mins = New-TimeSpan -Minutes -45
Set-Date -Adjust $45mins



$45mins = New-TimeSpan -Minutes 45
Set-Date -Adjust $45mins


$25mins = New-TimeSpan -Minutes -25
Set-Date -Adjust $25mins



$25mins = New-TimeSpan -Minutes 25
Set-Date -Adjust $25mins



$300mins = New-TimeSpan -Minutes -300
Set-Date -Adjust $300mins


$300mins = New-TimeSpan -Minutes 300
Set-Date -Adjust $300mins


CRAZYYYYYYY
5000 Minutes added

$300mins = New-TimeSpan -Minutes 5000
Set-Date -Adjust $300mins


#>





<##

No matter what it needs to be multiplied by -1 

if ($differenceinminutes -lt 0) { 
    ## If behind, convert to positive integer to adjust accordingly ##
    Write-Output "Clock is behind $differenceinminutes minutes" 
    $adjusttime = $differenceinminutes * -1
    Write-Output "Time to add to Date-Time: $adjusttime"

    } elseif ($differenceinminutes -gt 0) {
    Write-Output "Clock is behind $differenceinminutes minutes" 
    $adjusttime = $differenceinminutes * -1
    Write-Output "Time to subtract from Date-Time: $adjusttime"
    }
##>
