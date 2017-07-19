<#
    Sample: Agent Task
    Simple Agent Task that removes the contents of the specified folder recursivly.
#>
Param ($Arguments = [system.string]::Empty)

#Initialize Global Variables
$folderPath = $Arguments

#Check Folder path is populated and exists
If (($folderPath -ne [System.String]::Empty) -and (Test-Path $folderPath)){
    Get-ChildItem $folderPath -Force | ForEach-Object {Write-host "Removing $_..."; $_} | Remove-Item -Recurse -Force
}