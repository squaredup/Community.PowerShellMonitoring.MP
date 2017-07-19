Param ($Arguments = [system.string]::Empty)

#Initialize Global Variables
$scomAPI = New-Object -ComObject "MOM.ScriptAPI"
$folderPath = $Arguments

#Check Folder path is populated and exists
If (($folderPath -ne [System.String]::Empty) -and (Test-Path $folderPath))
{    
    $subFolders = Get-ChildItem -Path $folderPath | Where-Object {$_.PSIsContainer -eq $true} 
    If ($subFolders -ne $null)
    {
        ForEach ($folder in $subFolders)
        {
            $files = (Get-ChildItem $folder.FullName | Where-Object {$_.PSIsContainer -eq $false}  | Measure-Object -Sum Length)

			# Report results to SCOM			
            $propertyBag = $scomAPI.CreatePropertyBag()
            $propertyBag.AddValue("Folder", $folder.Name)
            $propertyBag.AddValue("NoOfJobs", $files.Count)
            $propertyBag.AddValue("SizeBytes", $files.Sum)

            #We don't need to add property bags to the API object or call $scomAPI.ReturnItems() in Powershell, simply return property bags as output.
            $propertyBag
        }
    }
    Else
    {
            $scomAPI.LogScriptEvent("FolderStats.ps1",102 ,0 , "No Subfolders found on that path.")
    }
}