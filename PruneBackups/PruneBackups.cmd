@Echo Off
Rem This script is designed to prune Windows backup directories keeping the most recent x directories
Rem
SetLocal
Set BackupDir=.
Set RetainBackups=2
Set LogFile=
If "%1"=="/?" Goto :Help
If "%2"=="/?" Goto :Help
If "%3"=="/?" Goto :Help
If Not "%4"=="" Goto :Help
Rem %%1 = directory to check
Rem %%2 = number of backups to retain (override default of 2)
Rem %%3 = directory to log to (console if omitted)
If Not "%~1"=="" Set BackupDir=%~1
If Not "%~2"=="" Set RetainBackups=%~2
If Not "%~3"=="" Set "LogFile=>> %3"

Echo %date% %time%: %0 %* starting %LogFile%
For /F "usebackq delims=" %%a In (`dir /ad /b "%BackupDir%\Backup Set ????-??-?? ??????" /o-n`) Do Call :Process "%%a"
Echo %date% %time%: %0 %* ending %LogFile%
Goto :EOF

:Process
If %RetainBackups% GTR 0 (
	Echo Retaining current backup directory %1 %LogFile%
	Set /A RetainBackups=RetainBackups-1
) Else (
	Echo Removing old backup directory %1 %LogFile%
	RD /s /q "%BackupDir%\%~1" %LogFile%
)
Goto :EOF

:Help
Echo Prunes the older Windows 7 backup directories to leave x directories remaining (default 2)
Echo.
Echo %0 "Directory path" N "Log file"
Echo.
Echo     Directory path - the base directory which contains backup
Echo         sub-directories of form "Backup YYYY-MM-DD HHMMSS"
Echo     N - the number of directories to retain (default %RetainBackups%)
Echo     Log file - a file to log messages to (default console)
Echo.
Echo A new directory is started with each full (or manual backup).
Echo According to Microsoft, the default period is 365 days which
Echo will result in very few, very large backup sets.
Echo.
Echo A better solution would be to produce four-weekly backup sets.
Echo According to Microsoft you can do this by setting a registry value.
Echo Copy and paste the following text into a text file and save it as a
Echo registry .REG file and then import it.
Echo.
Echo Windows Registry Editor Version 5.00
Echo.
Echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsBackup\AutomaticFullBackup]
Echo "TimePeriodInDays"=dword:0000001c
