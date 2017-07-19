<#
    Sample: Monitor
    Two/Three state monitoring script to check the size of a folder/number of files in a specified folder
#>
param([string]$Arguments)

$ScomAPI = New-Object -comObject "MOM.ScriptAPI"
$PropertyBag = $ScomAPI.CreatePropertyBag()

$FolderPath = "c:\JobQueue"
$state = "Unknown"
$fileCount = 0
$threshold = 1GB

try {
    if (Test-Path $FolderPath) {
        $contents = Get-ChildItem $FolderPath -Force -Recurse | Measure-Object -Sum Length    
        if ($contents.Sum -lt $threshold) {
            $state = "UnderThreshold"
        }
        else {
            $state = "OverThreshold"
        }

        # Report size in an appropriate unit
        if ($contents.sum -lt 1MB) {
             $PropertyBag.AddValue("SizeKB", [Math]::Round($contents.Sum / 1KB, 2)) 
        }
        elseif ($contents.sum -lt 1GB) { 
            $PropertyBag.AddValue("SizeMB", [Math]::Round($contents.Sum / 1MB, 2)) 
        }
        else { 
            $PropertyBag.AddValue("SizeGB", [Math]::Round($contents.Sum / 1GB, 2)) 
        }
        
        # Report raw stats
        $PropertyBag.AddValue("SizeBytes", $contents.Sum) 
        $fileCount = $contents.count

    }
    else {
        $state = "FolderMissing"    
    }
}
finally {

    # Context for alert or performance collection
    $PropertyBag.AddValue("FolderPath",$FolderPath)
    $PropertyBag.AddValue("Files", $fileCount)
    
    # State value for Monitor
    $PropertyBag.AddValue("State",$state)

    # Send output to SCOM
    $PropertyBag
}