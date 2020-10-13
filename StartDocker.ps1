param ($clientApp='/bin/bash',$optional='')
$ip=get-WmiObject Win32_NetworkAdapterConfiguration|Where {$_.Ipaddress.length -gt 1}
$ipaddress = $ip.ipaddress[0]
$localPath= $pwd.Path
echo "docker run --rm -it -e DISPLAY=${ipaddress}:0.0 -v ${localPath}:/home/studente/current_dir bozzochet/studenti:latest ${clientApp} ${optional}"
docker run --rm -it -e DISPLAY=${ipaddress}:0.0 -v ${localPath}:/home/studente/current_dir bozzochet/studenti:latest ${clientApp} ${optional}