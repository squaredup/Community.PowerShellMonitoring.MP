# Any Arguments specified will be sent to the script as a single string.
# If you need to send multiple values, delimit them with a space, semicolon or other separator and then use split.
param([string]$Arguments)

$ScomAPI = New-Object -comObject "MOM.ScriptAPI"
$PropertyBag = $ScomAPI.CreatePropertyBag()

# Example of use below, in this case return the length of the string passed in and we'll set health state based on that.
# Since the health state comparison is string based in this template we'll need to create a state value and return it.
# Ensure you return a unique value per health state (e.g. a service status), or a unique combination of values.

$PropertyBag.AddValue("MessageText",$Arguments)
$PropertyBag.AddValue("Length",$Arguments.length)   

if($Arguments.length -gt 10) {
  $PropertyBag.AddValue("State","OverUpperThreshold")
}
elseif($Arguments.Length -gt 5) {
  $PropertyBag.AddValue("State","OverMiddleThreshold")
}
else
{
  $PropertyBag.AddValue("State","UnderThreshold")
}
             
# Send output to SCOM
$PropertyBag