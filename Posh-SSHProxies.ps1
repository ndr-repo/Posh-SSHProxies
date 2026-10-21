$user=$(Write-Output username)
$proxyHost=$(Write-Output hostname)
function Stop-PortProcess { (netstat -aon | rg -oP ".*\:$args\ .*" | Out-String -Stream).Split() | rg -oP "[0-9]{5}" | % { Get-Process -Id $_ -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Name ; Stop-Process -Id $_ -Force -Verbose -ErrorAction SilentlyContinue } }
# Dynamic Proxies - SOCKS5
function New-SSHDynamicProxy { ssh $user@$proxyHost -D $args -v -f -N }
function New-SSHDynamicProxySession { ssh $user@$proxyHost -D $args -v -N }
function New-SSHDynamicProxyTranscript { ssh $user@$proxyHost -D $args -v -f -N -E ssh-dynamic-proxy-$args.log }
# Local Port Proxies
# Change the first & second argument variable ($args) to create an SSH Proxy redirector to another destination port 
function New-SSHLocalPortProxyTranscript { ssh -L (Write-output 127.0.0.1:"$args":(tailscale ip --4 $proxyHost):$args) -f -N -E ssh-local-portproxy-$args.log }
function New-SSHLocalPortProxy { ssh -L (Write-output 127.0.0.1:"$args":(tailscale ip --4 $proxyHost):$args) -f -N }
function New-SSHLocalPortProxySession { ssh -L (Write-output 127.0.0.1:"$args":$(tailscale ip --4 $proxyHost):"$args") ssh $user@$proxyHost -v -f -N }
