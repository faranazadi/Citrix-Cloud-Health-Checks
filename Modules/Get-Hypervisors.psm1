function Get-Hypervisors {
    param (
    [Parameter(Mandatory=$true)]
    [string] $completeToken)
    
        Write-ToConsole -messageType "INFO" -message "Retrieving hosts/hypervisors..."
        $headers = @{"Authorization" = "$completeToken"; "Customer" = $customerName}
        $url = "https://$customerID.xendesktop.net/Citrix/Monitor/OData/v4/Data/Hypervisors"  
    
        $result = Invoke-WebRequest -Uri $url -Headers $headers
    
        Write-ToConsole -messageType "INFO" -message "Hypervisor data retrieved: $result.Content"
        $result.content | ConvertTo-Json -depth 100 | Out-File "$timestampedLogRootDir\Hypervisors.json"
}

Export-ModuleMember -Function Get-Hypervisors