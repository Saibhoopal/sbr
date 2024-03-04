$CinegyAirUserSecretName = "svc_ottcinegyair"
$AirUser = Get-SECSecretValue -SecretId $CinegyAirUserSecretName -Select SecretString
$AirUser1 = $AirUser.split(":")
$CinegyAirUserName = $AirUser1[0].trim('{')
$CinegyAirUserName = "corp\" + $CinegyAirUserName.trim('"')
$CinegyAirPassword = $AirUser1[1].trim('}')
$CinegyAirPassword = $CinegyAirPassword.trim('"')

# Define the name of the scheduled task
$taskName = "CinegyPlayoutDashboardTask"

# Check if the task exists
$taskExists = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue

if (-not $taskExists) {
    # Create the scheduled task with an "AtStartup" trigger
	$action = New-ScheduledTaskAction -Execute "C:\Program Files\Cinegy\Cinegy Playout\PlayoutDashboard.exe" -Argument '-ExecutionPolicy Bypass'
    $trigger = New-ScheduledTaskTrigger -AtStartup
	$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
    Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -User $CinegyAirUserName -Password $CinegyAirPassword -RunLevel Highest -Settings $settings -TaskPath "\"
    Write-Host "Scheduled task created."

    # Run the task once immediately
    Start-ScheduledTask -TaskName $taskName
    Write-Host "Task started immediately."
} else {
    Write-Host "Scheduled task already exists. Nothing to do."
}

