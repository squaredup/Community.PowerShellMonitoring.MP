# Any Arguments specified will be sent to the script as a single string.
# If you need to send multiple values, delimit them with a space, semicolon or other separator and then use split.
param([string]$Arguments)

$ScomAPI = New-Object -comObject "MOM.ScriptAPI"
$PropertyBag = $ScomAPI.CreatePropertyBag()

# Enter a script that outputs the required data to generate the event using a property bag
# Example script that returns three properties:

$PropertyBag.AddValue("EventID", 10)
$PropertyBag.AddValue("EventParam1","SomeText")
$PropertyBag.AddValue("EventParam2","SomeText")

# Send output to SCOM
$PropertyBag
                