$Path = "C:\Logs" # Path where the file is located
$Days = "7" # Number of days before current date
 
#Calculate Cutoff date
$CutoffDate = (Get-Date).AddDays(-$Days)
 
#Get All Files modified more than the last 7 days
Get-ChildItem -Path $Path -Recurse -File | Where-Object { $_.LastWriteTime -lt $CutoffDate } | Remove-Item -Force -Verbose
