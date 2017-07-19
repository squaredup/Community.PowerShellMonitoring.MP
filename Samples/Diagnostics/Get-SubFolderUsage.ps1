Param ($Arguments = [system.string]::Empty)

#Initialize Global Variables
$folderPath = $Arguments

#Check Folder path is populated and exists
If (($folderPath -ne [System.String]::Empty) -and (Test-Path $folderPath))
{    
    $subFolders = Get-ChildItem -Path $folderPath | Where-Object {$_.PSIsContainer -eq $true} 
    If ($subFolders -ne $null)
    {
        $results = @()
        ForEach ($folder in $subFolders)
        {
            $fileCount = Get-ChildItem $folder.FullName -Recurse | Where-Object {$_.PSIsContainer -eq $false}  | Measure-Object -Sum Length

            $results += [PSCustomObject]@{
                'Name' = $folder.Name
                'Files' = $fileCount.Count
                'Size' = $fileCount.Sum
            }
            
        }
        $results | Sort-Object Size,Files,Name -Descending | Format-Table Size,Files,Name -AutoSize | Out-String -Width 4096 | Write-Host
    }
    Else
    {
            Write-host "No Subfolders found on that path."
    }
}