<#
    Sample: Agent task / Diagnostic / Recovery / Event Triggered Script
    Lists software installed locally and outputs as a PowerShell table.  Note that the Format-Table -Autosize | Out-String | Write-Host at the end is to
    get around issues with the PowerShell modules limiting Write-Output to 80 characters regardless of host settings.
#>
$addRemoveEntries = Get-ChildItem HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall
$addRemoveEntries += Get-ChildItem HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall

$results = @()
$propertyNames = @('Publisher','DisplayName','DisplayVersion','HelpLink')


foreach ($entry in $addRemoveEntries)
{
    $valueNames = $entry.GetValueNames()
    if ($valueNames -notcontains 'UninstallString' -or $valueNames -notcontains 'DisplayName')
    {
        continue;
    }
    $properties = @{}
    $skipEntry = $false
    Foreach ($property in $valueNames)
    {        
        Switch ($property) 
        {  
            "ParentKeyName" {
                $skipEntry = $skipEntry -or [string]::IsNullOrEmpty($entry.GetValue($property).trim()) -eq $false
                break;
            }         
            "UninstallString" {
                $skipEntry = $skipEntry -or [string]::IsNullOrEmpty($entry.GetValue($property))
                break;
            }
            "SystemComponent" {
                $skipEntry = $skipEntry -or $entry.GetValue($property) -eq "1"
                break;
            }
            "DisplayName"{
                $displayName = $entry.GetValue($property).trim()
                $skipEntry = $skipEntry -or [string]::IsNullOrEmpty($displayName)
                $properties.Add($property, $displayName)
                break;
            }
            "EstimatedSize" {
                $size = ''
                if ([double]::TryParse($entry.GetValue($property), [ref] $size))
                {
                    if ($size -lt 1024) 
                    {
                        $size = "$size KB"
                    }
                    elseif ($size -gt 1048576)
                    {
                        $size = "$([Math]::Round($size / 1048576, 2)) GB"
                    }
                    else
                    {
                        $size = "$([Math]::Round($size / 1024)) MB"
                    }
                }
                $properties.Add($property, $size)
                break;
            }
            "InstallDate" {
                    $installDate = $entry.GetValue($property) -replace '^(\d{4})(\d{2})(\d{2})$','$1\$2\$3'
                    $properties.Add($property, $installDate)
                    break;
                }
            {$propertyNames -contains $_} {                   
                $properties.Add($property, $entry.GetValue($property))
                break;
            }
        }
    }
    if ($properties.Count -gt 0 -and $skipEntry -eq $false)
    {
        $results += New-Object PSObject -Property $properties
    }
}

$results | Sort-Object DisplayName | Format-Table DisplayName,Publisher,DisplayVersion,EstimatedSize -AutoSize | Out-String -Width 4096 | Write-Host
