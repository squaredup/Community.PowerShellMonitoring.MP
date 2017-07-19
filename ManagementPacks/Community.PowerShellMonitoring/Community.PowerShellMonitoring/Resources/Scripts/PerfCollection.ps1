# Any Arguments specified will be sent to the script as a single string.
# If you need to send multiple values, delimit them with a space, semicolon or other separator and then use split.
param([string]$Arguments)

$ScomAPI = New-Object -comObject "MOM.ScriptAPI"

# Collect your performance counter here.  Note that in order to support the DW this script MUST only return a single
# object/counter and those must be static values.  You can return multiple instances just fine though.

$Instances = @("Instance1", "Instance2")
$Metric = 42

Foreach ($Instance in $Instances)
{
$PropertyBag = $ScomAPI.CreatePropertyBag()
$PropertyBag.AddValue("Metric", $Metric)
$PropertyBag.AddValue("Instance",$Instance)

# Send output to SCOM
$PropertyBag
}