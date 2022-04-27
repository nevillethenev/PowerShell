#################################
######Author: Neville Charles
######Title: Change Power Settings to Maximum Power
######Date: 03/06/2020
#################################
######Description: Changes the settings of the default power scheme of Windows 10 to High Performance
######Prevents sleep, idle, power saving etc... 
#################################

function HighPerformance {

###extract GUID of power scheme
$activeScheme = cmd /c "powercfg /getactivescheme"
$regEx = '(\{){0,1}[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}(\}){0,1}'
$asGuid = [regex]::Match($activeScheme,$regEx).Value


####check if High Performance is active and if not then change to high performance.

###Put High Performance GUID into a variable 
$HighPer = "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"
if ($asGuid -eq $HighPer) { 
    ##do nothing
    } else { 
            ###Activate High Performance    
            powercfg -SetActive $HighPer 
            } 
Write-Host "Power scheme set to High Performance."

###extract GUID of power scheme (again)
$activeScheme = cmd /c "powercfg /getactivescheme"
$regEx = '(\{){0,1}[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}(\}){0,1}'
$asGuid = [regex]::Match($activeScheme,$regEx).Value

###change settings of powershceme 

powercfg -setacvalueindex SCHEME_CURRENT SUB_DISK DISKIDLE 0
Write-Host "Turn off hard disk set to Never."
powercfg -setacvalueindex SCHEME_CURRENT SUB_SLEEP STANDBYIDLE 0
Write-Host "Sleep set to Never."
powercfg -setacvalueindex SCHEME_CURRENT SUB_SLEEP HYBRIDSLEEP 0
Write-Host "Hybrid sleep - disabled."
powercfg -setacvalueindex SCHEME_CURRENT SUB_SLEEP HIBERNATEIDLE 0
Write-Host "Hibernate set to Never."
powercfg -setacvalueindex SCHEME_CURRENT SUB_SLEEP RTCWAKE 0
Write-Host "Allow Wake timers - disabled."
powercfg /change monitor-timeout-ac 20
Write-Host "Turn off Display after 20 min."

###USB Selective suspend (0=disable, 1=enabled)
powercfg -setacvalueindex $asGuid 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0
Write-Host "USB Selective suspend - disabled."

#####Disable Windows 10 fast boot 
REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d "0" /f
Write-Host "Fast boot - disabled."
}

##Call Function 
HighPerformance
Read-Host "Press Enter to Exit"