@Echo Off
Rem This script is designed to prune Windows backup directories keeping the most recent x directories
Rem
Rem You should also set HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsBackup\AutomaticFullBackup\TimePeriodInDays=dword:xx days
Rem to create a new backup set every xx days (e.g. 28 days for monthly) to avoid having a single large yearly backup set.
If "%1"=="/?" Goto :Help
If "%2"=="/?" Goto :Help
If Not "%3"=="" Goto :Help
SetLocal
Rem Default number of backups
Set RetainBackups=2
Set BackupDir=.
Rem %%1 = directory to check
Rem %%2 = number of backups to retain (override)
If .%2 NEQ . Set RetainBackups=%2
If .%1 NEQ . Set BackupDir=%~1

For /F "usebackq delims=" %%a In (`dir /ad /b "%BackupDir%\Backup ????-??-?? ??????" /o-n`) Do Call :Process "%%a"
Goto :EOF

:Process
If %RetainBackups% GTR 0 (
	Set /A RetainBackups=RetainBackups-1
) Else (
	Echo Removing old backup directory %1
	RD /s /q "%BackupDir%\%~1"
)
Goto :EOF

:Help
Echo Prunes the older Windows 7 backup directories to leave x directories remaining (default 2)
Echo.
Echo %0 "Directory Path" N
Echo.
Echo     Directory path - the base directory which contains backup
Echo         sub-directories of form "Backup YYYY-MM-DD HHMMSS"
Echo     N - the number of direcories to retain
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
