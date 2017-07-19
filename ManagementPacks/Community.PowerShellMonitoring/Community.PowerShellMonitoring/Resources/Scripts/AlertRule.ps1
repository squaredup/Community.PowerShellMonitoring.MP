# Any Arguments specified will be sent to the script as a single string.
# If you need to send multiple values, delimit them with a space, semicolon or other separator and then use split.
param([string]$Arguments)

$ScomAPI = New-Object -comObject "MOM.ScriptAPI"
$PropertyBag = $ScomAPI.CreatePropertyBag()

# Example of use below, in this case return the length of the string passed in and we'll alert based on that.
# Since the alert comparison is string based in this template we'll need to create a result value and return it.
# Ensure you return a result even if an alert shouldn't be triggered, or the expression filter will error and the module will be unloaded.

$PropertyBag.AddValue("MessageText",$Arguments)
$PropertyBag.AddValue("Length",$Arguments.length)   

if($Arguments.length -gt 10) {
  $PropertyBag.AddValue("Result","OverThreshold")
}
else
{
  $PropertyBag.AddValue("Result","UnderThreshold")
}
             
# Send output to SCOM
$PropertyBag