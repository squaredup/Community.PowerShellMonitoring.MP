# Any Arguments specified will be sent to the script as a single string.
# If you need to send multiple values, delimit them with a space, semicolon or other separator and then use split.
param([string]$Arguments)

$ScomAPI = New-Object -comObject "MOM.ScriptAPI"

$PropertyBag = $ScomAPI.CreatePropertyBag()

# use some code to gather the value(s) you want to send to SCOM
$metric = 42
$PropertyBag.AddValue("Metric", $metric)

# Send output to SCOM
$PropertyBag
