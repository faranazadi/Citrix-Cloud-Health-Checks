Function Write-ToConsole {
    param(
        [ValidateSet("INFO", "WARNING", "ERROR")][string]$messageType = "INFO", 
        [string]$message)
        
        $dateAndTime = Get-Date -Format g
        
        Write-Host "[$dateAndTime][$messageType] $message"
}

Export-ModuleMember -Function Write-ToConsole
