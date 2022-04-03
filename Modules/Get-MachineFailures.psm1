function Get-MachineFailures {
    param (
    [Parameter(Mandatory=$true)]
    [string] $completeToken)
    
        Write-ToConsole -messageType "INFO" -message "Retrieving machine failures by start and end date in the site..."
        $headers = @{"Authorization" = "$completeToken"; "Customer" = $customerName}
        $url = "https://$customerID.xendesktop.net/Citrix/Monitor/OData/v4/Data/MachineFailureLogs"  
    
        $result = Invoke-WebRequest -Uri $url -Headers $headers
    
        Write-ToConsole -messageType "INFO" -message "Machine failure log summary retrieved: $result.Content"
        $result.content | ConvertTo-Json -depth 100 | Out-File "$timestampedLogRootDir\MachineFailures.json"
}

Export-ModuleMember -Function Get-MachineFailures