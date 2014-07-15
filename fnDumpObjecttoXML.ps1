function DumpObjectToXml($obj) {
$a = $obj

$openingTag = "<" + $a.GetType().Name + ">"

$ret = $ret + $openingTag

Get-Member -InputObject $a -MemberType Properties | ForEach-Object {

$CurrentName = $_.Name

$a.GetType().GetProperties() | ? { $_.Name -eq $CurrentName } | ForEach-Object {

$specialSerialization = $false

# Handle specialized serialization for object properties of parent object

if ($_.Name -eq "SamlEndpoints") {

if ($obj.SamlEndpoints -ne $null) {

$d = $obj.SamlEndpoints | ? { $_.BindingUri -like "*HTTP-POST" }

$val = $d.Location.AbsoluteUri

$specialSerialization= $true

}

else {

$val = ""

}

}

if ($_.CanRead -eq $true -and $specialSerialization -eq $false) {

$val = $_.GetValue($a, $null)

}

}

$out = "<" + $_.Name + ">" + $val + "</" + $_.Name + ">"

$ret = $ret + $out

}

$closingTag = "</" + $a.GetType().Name + ">"

$ret = $ret + $closingTag

return $ret

}
