# General variables #
$scriptStart = Get-Date
$formattedDate = $scriptStart.Date | Select-Object Day, Month, Year
$formattedTime = $scriptStart.TimeOfDay | Select-Object Hours, Minutes, Seconds

$scriptRootDir = Split-Path $MyInvocation.InvocationName
$moduleRootDir = $scriptRootDir + "\Modules\"
$logRootDir = $scriptRootDir + "\Logs\"
$datedLogRootDir = $logRootDir + "$($formattedDate.Day)-$($formattedDate.Month)-$($formattedDate.Year)\"
$timestampedLogRootDir = $datedLogRootDir + "$($formattedTime.Hours)H.$($formattedTime.Minutes)M.$($formattedTime.Seconds)s\"

$transcriptLogPath = $timestampedLogRootDir + "ScriptTranscript.txt"
# End general variables #

# Credentials used to connect to Monitor API - get these from Citrix Cloud #
$clientID = ""
$customerID = ""
$customerName = ""
$clientSecret = ""
# End credentials #

# Import all of the modules from the 'Modules' folder
ForEach ($module in Get-Childitem $moduleRootDir -Name -Filter "*.psm1") {
    Import-Module $moduleRootDir\$module -Force -Verbose
}

# Check if log directories exist, if not, create them #
if (-not (Test-Path -LiteralPath $logRootDir)) {
    try {
        New-Item -Path $logRootDir -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
    } catch {
        Write-ToConsole -messageType "ERROR" -message "Unable to create the root log directory."       
    }
    Write-ToConsole -messageType "INFO" -message "Successfully created log file directory."
}
else {
    Write-ToConsole -messageType "INFO" -message "$logRootDir already existed."
}

if (-not (Test-Path -LiteralPath $datedLogRootDir)) {
    try {
        New-Item -Path $datedLogRootDir -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
    } catch {
        Write-ToConsole -messageType "ERROR" -message "Unable to create a dated directory."       
    }
    Write-ToConsole -messageType "INFO" -message "Successfully created dated directory."
}
else {
    Write-ToConsole -messageType "INFO" -message "$datedLogRootDir already existed."
}

if (-not (Test-Path -LiteralPath $timestampedLogRootDir)) {
    try {
        New-Item -Path $timestampedLogRootDir -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
    } catch {
        Write-ToConsole -messageType "ERROR" -message "Unable to create a timestamped directory."       
    }
    Write-ToConsole -messageType "INFO" -message "Successfully created timestamped directory."
}
else {
    Write-ToConsole -messageType "INFO" -message "$timestampedLogRootDir already existed."
}

# If the log file exists or isn't empty, add on to the end of the existing logs instead of completely overwriting - prevents losing any valuable info #
if(![string]::IsNullOrEmpty($transcriptLogPath)) {
    Start-Transcript -Append $transcriptLogPath
}

function Main {
    $bearerToken = Get-BearerToken $clientID $clientSecret

    # Not able to access API with bearerToken alone, need to prepend it with 'CwsAuth Bearer='
    $completeToken = "CwsAuth Bearer=" + $bearerToken

    Get-UserData $completeToken
    
    Get-MachineData $completeToken

    Get-CatalogData $completeToken

    Get-AllConnectionFailures $completeToken

    Get-ConnectionFailureTypes $completeToken

    Get-AllFailures $completeToken

    Get-MachineFailures $completeToken

    Get-SessionAndLogonData $completeToken

    Get-Hypervisors $completeToken

    Stop-Script
}


# HELPER FUNCTIONS #
function Get-BearerToken {
    param (
    [Parameter(Mandatory=$true)]
    [string] $clientID,
    [Parameter(Mandatory=$true)]
    [string] $clientSecret)
    
        $postHeaders = @{"Content-Type"="application/json"}
        $body = @{
        "ClientId"=$clientID;
        "ClientSecret"=$clientSecret
        }
        
        $trustUrl = " https://trust.citrixworkspacesapi.net/root/tokens/clients "
        $response = Invoke-RestMethod -Uri $trustUrl -Method POST -Body (ConvertTo-Json $body) -Headers $postHeaders
        $bearerToken = $response.token
    
        Write-ToConsole -messageType "INFO" -message "Returned a bearer token of: $bearerToken"
    
        return $bearerToken;
    }
    
Function Stop-Script {
    # Originally caused script to crash as it tried to stop the transript if it wasn't transcripting
    if(![string]::IsNullOrEmpty($transcriptLogPath))
    {
            Try {
                $scriptEnd = Get-Date
                $scriptRuntime =  $scriptEnd - $scriptStart | Select-Object TotalSeconds
                $scriptRuntimeInSeconds = $scriptRuntime.TotalSeconds
                Write-ToConsole -messageType "INFO" -message "Script was running for $($scriptRuntimeInSeconds) seconds."
            
                Write-ToConsole -messageType "INFO" -message "Stopping script transcript..."
            
                Stop-Transcript 
                Exit
            } catch {
                Write-ToConsole -messageType "ERROR" -message "An error occurred when trying to stop script transcript."
        }
    }
}  

# SCRIPT ENTRY POINT #
Main

