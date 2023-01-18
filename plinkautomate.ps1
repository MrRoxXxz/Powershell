# Search for Plink.exe in the "program files"\PuTTY directory
$path = "C:\Program Files\PuTTY"
$plinkExe = Get-ChildItem -Path $path -Filter "Plink.exe"
if ($plinkExe) {
    Write-Host "Plink.exe found at $($plinkExe.FullName)"
} else {
    Write-Host "Plink.exe not found in $path"
}

# Identify COM port being used and set as variable
$com = [System.IO.Ports.SerialPort]::getportnames()
Write-Host "COM port in use: $com"

# Create list of commands in commands.txt
$commands = "enable", "term len 0", "show version", "show interfaces description","show interfaces trunk","show ip interface","show mac address-table","show ip arp","show vlan","show cdp neighbor detail", "show spanning-tree detail", "show run" ,"exit"
$commands | Out-File -FilePath "commands.txt"

# Use commands.txt as input to plink.exe
$user = [System.Environment]::UserName
#$filepath = 
$filename = Read-Host "Enter the filename for this output"

cmd /C "type commands.txt | plink.exe -serial $com -sercfg 9600,8,n,1,N" | Out-File "$filename.txt" -Append


EXIT