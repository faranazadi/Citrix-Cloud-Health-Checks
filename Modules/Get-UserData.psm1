function Get-UserData {
    param (
    [Parameter(Mandatory=$true)]
    [string] $completeToken)

        Write-ToConsole -messageType "INFO" -message "Retrieving user data..."
        $headers = @{"Authorization" = "$completeToken"; "Customer" = $customerName}
        $url = "https://$customerID.xendesktop.net/Citrix/Monitor/OData/v4/Data/Users"

        $result = Invoke-WebRequest -Uri $url -Headers $headers

        Write-ToConsole -messageType "INFO" -message "User data retrieved: $result.Content"
        $result.content | ConvertTo-Json -Depth 100 | Out-File "$timestampedLogRootDir\UserData.json"

        $readableJSON = Get-Content -Raw -Path $timestampedLogRootDir\UserData.json | ConvertFrom-Json
        Write-Host $readableJSON


}

Export-ModuleMember -Function Get-UserData