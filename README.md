# Administration-BATCH-psexec

(RU) Скрипт для администрирования парка ПК на Windows без сервера через [psexec](https://www.google.com/search?q=psexec "official site"). Автор не несет ответственности за любые последствия в результате установки и использования данного скрипта, пользователь использует его "как есть" на свой страх и риск.

(EN) Script for administering a PC park on Windows without a server via [psexec](https://www.google.com/search?q=psexec "official site"). The author is not responsible for any consequences as a result of the installation and use of this script, the user uses it "as is" at his own peril and risk.

----

В проекте 3 файла:
```
\remote_admin_module_and_binary_psexec.cmd - гибридный(bat+js) скрипт удаленного администрирования с "psexec" внутри.
\remote_admin_module.cmd                   - скрипт удаленного администрирования (нужно положить рядом psexec.exe)
\add_user.cmd                              - скрипт добавления пользователя на целевом ПК.
```

**add_user.cmd**

```cmd
REM Code-page:866
@net user Admin01 P@s$wOrD1 /ADD>nul 2>&1
@net localgroup "Администраторы" Admin01 /ADD>nul 2>&1
@reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v Admin01 /t REG_DWORD /d 0 /f>nul 2>&1
@reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 1 /f>nul 2>&1
@wmic useraccount where "name='Admin01'" set passwordexpires=false
```


**remote_admin_module.cmd R_HOST R_USER R_PWD R_CMD**

```cmd
@echo R_HOST - ip address server
@echo R_USER - remote host username
@echo R_PWD - remote host password 
@echo R_CMD - remote host command (batch,script,execution file etc.)
```

**Usage:** 
1. Запустить на целевом ПК **"add_user.cmd"** от имени "Администратора".
2. Запустить **remote_admin_module_and_binary_psexec.cmd 192.168.0.1 Admin01 P@s$wOrD1 cmd.exe**

*P.S. Если используем **remote_admin_module.cmd** не забываем скачать и положить рядом со скриптом [psexec](https://www.google.com/search?q=psexec "official site")* 
