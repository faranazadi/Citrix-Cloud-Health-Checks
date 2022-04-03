function Get-SessionAndLogonData {
    param (
    [Parameter(Mandatory=$true)]
    [string] $completeToken)
    
        Write-ToConsole -messageType "INFO" -message "Retrieving Session counts and logon data by time period and delivery group..."
        $headers = @{"Authorization" = "$completeToken"; "Customer" = $customerName}
        $url = "https://$customerID.xendesktop.net/Citrix/Monitor/OData/v4/Data/SessionActivitySummaries"  
    
        $result = Invoke-WebRequest -Uri $url -Headers $headers
    
        Write-ToConsole -messageType "INFO" -message "Session/logon summary retrieved: $result.Content"
        $result.content | ConvertTo-Json -depth 100 | Out-File "$timestampedLogRootDir\SessionDataSummary.json"
}

Export-ModuleMember -Function Get-SessionAndLogonData