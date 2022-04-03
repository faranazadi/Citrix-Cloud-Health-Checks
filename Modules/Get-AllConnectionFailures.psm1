function Get-AllConnectionFailures {
    param (
    [Parameter(Mandatory=$true)]
    [string] $completeToken)
    
        Write-ToConsole -messageType "INFO" -message "Retrieving all connection failures"
        $headers = @{"Authorization" = "$completeToken"; "Customer" = $customerName}
        $url = "https://$customerID.xendesktop.net/Citrix/Monitor/OData/v4/Data/ConnectionFailureLogs"  
    
        $result = Invoke-WebRequest -Uri $url -Headers $headers
    
        Write-ToConsole -messageType "INFO" -message "Connection failures retrieved: $result.Content"
        $result.content | ConvertTo-Json -depth 100 | Out-File "$timestampedLogRootDir\AllConnectionFailures.json"
}

Export-ModuleMember -Function Get-AllConnectionFailures