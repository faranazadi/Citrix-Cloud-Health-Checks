function Get-AllFailures {
    param (
    [Parameter(Mandatory=$true)]
    [string] $completeToken)
    
        Write-ToConsole -messageType "INFO" -message "Retrieving failures (connection/machine) counts by time period and Delivery Group..."
        $headers = @{"Authorization" = "$completeToken"; "Customer" = $customerName}
        $url = "https://$customerID.xendesktop.net/Citrix/Monitor/OData/v4/Data/FailureLogSummaries"  
    
        $result = Invoke-WebRequest -Uri $url -Headers $headers
    
        Write-ToConsole -messageType "INFO" -message "Failure log summary retrieved: $result.Content"
        $result.content | ConvertTo-Json -depth 100 | Out-File "$timestampedLogRootDir\AllFailures.json"
}

Export-ModuleMember -Function Get-AllFailures