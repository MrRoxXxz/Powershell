# Allow PS1 to run
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process

# Search for Plink.exe in the "program files"\PuTTY directory
$path = "C:\Program Files\"
$plinkExe = Get-ChildItem -Path $path -Filter "Plink.exe" -Recurse
if ($plinkExe) {
    Write-Host "Plink.exe found at $($plinkExe.FullName)"
} else {
    Write-Host "Plink.exe not found in $path"
	exit
}

# Identify COM port being used and set as variable
$com = [System.IO.Ports.SerialPort]::getportnames()
if ($com) { 
Write-Host "COM port in use: $com"
} Else {Write-Host "No COM detected. Exiting"
	EXIT
	}

# Create list of commands in commands.txt
$commands = "", "enable", "term len 0", "show version", "show interfaces description","show interfaces trunk","show ip interface","show mac address-table","show ip arp","show vlan","show cdp neighbor detail", "show spanning-tree detail", "show run" ,"exit"
$commands | Out-File -FilePath "commands.txt"

#Create output filename
$filename = Read-Host "Enter the filename for this output"

#Echo commands being run
$commands = Get-Content -Path "commands.txt"
foreach ($command in $commands) {Write-Output "Running command: $command"}

#Set Timer
Write-Host "Printing to $filename, Please wait 10 seconds and then use ^C to exit"


# Use commands.txt as input to plink.exe
cmd /C "type commands.txt | plink.exe -serial $com -sercfg 9600,8,n,1,N" | Out-File "$filename.txt" -Append
 return