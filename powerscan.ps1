# Search for dumpcap.exe in the "program files"\Wireshark directory
$path = "C:\Program Files\Wireshark"
$dumpExe = Get-ChildItem -Path $path -Filter "dumpcap.exe" -Recurse
if ($dumpExe) {
    Write-Host "dumpcap.exe found at $($dumpExe.FullName)"
} else {
    Write-Host "dumpcap.exe not found in $path"
	exit
	
}

# Search for mergecap.exe in the "program files"\Wireshark directory
$path = "C:\Program Files\Wireshark"
$mergeExe = Get-ChildItem -Path $path -Filter "mergecap.exe" -Recurse
if ($mergeEXE) {
    Write-Host "mergecap.exe found at $($mergeEXE.FullName)"
} else {
    Write-Host "mergecap.exe not found in $path"
	exit
	
}

# Search for tshark.exe in the "program files"\Wireshark directory
$path = "C:\Program Files\Wireshark"
$tsharkExe = Get-ChildItem -Path $path -Filter "tshark.exe" -Recurse
if ($tsharkEXE) {
    Write-Host "tshark.exe found at $($tsharkEXE.FullName)"
} else {
    Write-Host "tshark.exe not found in $path"
	exit
}

#create a folder
$folder = Read-Host "Enter the foldername"
New-Item $folder -ItemType Directory
cd $folder
$pwd

Write-Output "-------------------------------------------------------------------------------------------"
Write-Output "----------------------------Showing your network interface---------------------------------"
Write-Output "-------------------------------------------------------------------------------------------"

cmd /C $dumpExe.FullName -D

$interface = Read-Host -Prompt 'Select your network interface '

Write-Output "-------------------------------------------------------------------------------------------"
Write-Output "---------------------------------Set the Autostop timer------------------------------------"
Write-Output "-------------------------------------------------------------------------------------------"

$duration = Read-Host -Prompt 'Set the timer (in seconds) '

Write-Output "-------------------------------------------------------------------------------------------"
Write-Output "--------------------------------Set the file buffer size-----------------------------------"
Write-Output "-------------------------------------------------------------------------------------------"

$buffer = Read-Host -Prompt 'Set the file size buffer '

Write-Output "-------------------------------------------------------------------------------------------"
Write-Output "-----------------------------------Set the file name---------------------------------------"
Write-Output "-------------------------------------------------------------------------------------------"


$pcapfile = Read-Host -Prompt 'Type your output file name (including .pcapng) '


cmd /C $dumpExe.FullName -i $interface -a duration:$duration -b filesize:$buffer -w $pcapfile

#mergecap find all PCAP files

$pcapsfile = Get-ChildItem | Where-Object {$_.Extension -eq ".pcapng"}

Write-Output "-------------------------------------------------------------------------------------------"
Write-Output "------------------------------------Merge the PCAPS----------------------------------------"
Write-Output "-------------------------------------------------------------------------------------------"

$mergeanswer = Read-Host -Prompt 'Would you like to merge the pcaps? (yes/no) '

Write-Output "-------------------------------------------------------------------------------------------"
Write-Output "--------------------------------Set the Merged Filename------------------------------------"
Write-Output "-------------------------------------------------------------------------------------------"

$mergedfile = Read-Host -Prompt 'Enter the merged filename (Include .pcapng) '

if ($mergeanswer = "yes") { cmd /C $mergeEXE.FullName -F pcapng "-w", $mergedfile $pcapsfile}

else {exit}
#Convert merged files to JSON

Write-Output "-------------------------------------------------------------------------------------------"
Write-Output "----------------------------------Create a JSON file---------------------------------------"
Write-Output "-------------------------------------------------------------------------------------------"
$jsonanswer = Read-Host -Prompt 'Would you like to create a json file? (yes/no) '

Write-Output "-------------------------------------------------------------------------------------------"
Write-Output "-------------------------------Set the JSON Filename---------------------------------------"
Write-Output "-------------------------------------------------------------------------------------------"

$jsonfile = Read-Host -Prompt 'Enter the JSON filename (include .json) '

if ($jsonanswer = "yes") { cmd /C $tsharkEXE.FullName -T json -r $mergedfile > $jsonfile}

else {exit}