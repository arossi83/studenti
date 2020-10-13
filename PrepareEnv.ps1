$ip=get-WmiObject Win32_NetworkAdapterConfiguration|Where {$_.Ipaddress.length -gt 1}
$ipaddress = $ip.ipaddress[0]
$localPath= $pwd.Path