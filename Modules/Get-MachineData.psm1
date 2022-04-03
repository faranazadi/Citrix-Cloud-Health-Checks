function Get-MachineData {
    param (
    [Parameter(Mandatory=$true)]
    [string] $completeToken)

        Write-ToConsole -messageType "INFO" -message "Retrieving machine data..."
        $headers = @{"Authorization" = "$completeToken"; "Customer" = $customerName}
        $url = "https://$customerID.xendesktop.net/Citrix/Monitor/OData/v4/Data/Machines"

        $result = Invoke-WebRequest -Uri $url -Headers $headers

        Write-ToConsole -messageType "INFO" -message "Machine data retrieved: $result.Content"
        $result.content | ConvertTo-Json -depth 100 | Out-File "$timestampedLogRootDir\MachineData.json"
}

Export-ModuleMember -Function Get-MachineData