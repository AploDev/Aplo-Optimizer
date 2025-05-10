
@echo off

NET SESSION >nul 2>&1
if %errorlevel% NEQ 0 (
    echo Este script necesita permisos de administrador.
    echo Se reiniciara con permisos elevados...
    pause

    powershell -Command "Start-Process -FilePath '%~s0' -Verb RunAs"
    exit
)

color 6F
title APLO OPTIMIZER

:menu
cls
echo ==============================
echo       APLO OPTIMIZER
echo ==============================
echo.
echo 0. Ejecutar todas las optimizaciones (modo completo)
echo 1. Limpiar archivos temporales
echo 2. Vaciar papelera de reciclaje
echo 3. Liberar RAM
echo 4. Reparar archivos del sistema
echo 5. Optimizar disco duro
echo 6. Desactivar programas en segundo plano
echo 7. Eliminar logs innecesarios
echo 8. Desactivar servicios de telemetria
echo 9. Crear plan de energia "Aplo Power Plan"
echo 10. Limpiar cache de navegadores
echo 11. Borrar historial de actualizaciones fallidas
echo 12. Desactivar sugerencias/ads de Windows
echo 13. Vaciar Prefetch
echo 14. Reiniciar Explorador de Windows
echo 15. Renovar IP y limpiar DNS
echo 16. Limpiar cola de impresion
echo 17. Limpiar carpeta Descargas
echo 18. Desactivar servicios innecesarios
echo 19. Comprobar disco con CHKDSK
echo 20. Limpiar restos de Windows Update
echo 21. Limpiar shadow copies (restauracion)
echo 22. Desactivar animaciones visuales
echo 23. Reiniciar servicios de red
echo 24. Desactivar Ahorro de Energia de Red
echo 25. Deshabilitar IPv6
echo 26. Ajustar configuracion TCP/IP
echo 27. Ajustar prioridad de red
echo 28. Desactivar animaciones visuales
echo 29. Desactivar ahorro de energia para adaptadores de red
echo 30. Salir
echo.
set /p opcion=Elige una opcion [1-30]:

if "%opcion%"=="0" goto todo
if "%opcion%"=="1" goto limpiar_temp
if "%opcion%"=="2" goto vaciar_papelera
if "%opcion%"=="3" goto liberar_ram
if "%opcion%"=="4" goto reparar_sistema
if "%opcion%"=="5" goto optimizar_disco
if "%opcion%"=="6" goto desactivar_programas
if "%opcion%"=="7" goto eliminar_logs
if "%opcion%"=="8" goto desactivar_telemetria
if "%opcion%"=="9" goto crear_plan
if "%opcion%"=="10" goto limpiar_cache_navegadores
if "%opcion%"=="11" goto limpiar_wu_historial
if "%opcion%"=="12" goto desactivar_ads
if "%opcion%"=="13" goto vaciar_prefetch
if "%opcion%"=="14" goto reiniciar_explorer
if "%opcion%"=="15" goto renovar_ip_dns
if "%opcion%"=="16" goto limpiar_impresion
if "%opcion%"=="17" goto limpiar_descargas
if "%opcion%"=="18" goto desactivar_servicios
if "%opcion%"=="19" goto comprobar_disco
if "%opcion%"=="20" goto limpiar_update_cache
if "%opcion%"=="21" goto limpiar_shadow
if "%opcion%"=="22" goto desactivar_animaciones
if "%opcion%"=="23" goto reiniciar_red
if "%opcion%"=="24" goto desactivar_ahorro_energia_red
if "%opcion%"=="25" goto deshabilitar_ipv6
if "%opcion%"=="26" goto ajustar_tcp_ip
if "%opcion%"=="27" goto ajustar_prioridad_red
if "%opcion%"=="28" goto desactivar_animaciones
if "%opcion%"=="29" goto desactivar_ahorro_energia_red
if "%opcion%"=="30" goto salir
goto menu

:limpiar_temp
echo Limpiando archivos temporales con PowerShell...
powershell -command "Get-ChildItem $env:TEMP -Recurse -Force | Remove-Item -Force -ErrorAction SilentlyContinue"
powershell -command "Get-ChildItem 'C:\Windows\Temp' -Recurse -Force | Remove-Item -Force -ErrorAction SilentlyContinue"
echo Archivos temporales eliminados (los que no estaban en uso).
pause
goto menu

:deshabilitar_ipv6
echo Deshabilitando IPv6...
netsh interface ipv6 set global disabled
echo IPv6 deshabilitado.
pause
goto menu

:ajustar_tcp_ip
echo Ajustando configuracion de TCP/IP...
netsh int tcp set global autotuninglevel=disabled
netsh int tcp set global rss=enabled
netsh int tcp set global chimney=enabled
echo Configuracion de TCP/IP optimizada.
pause
goto menu

:ajustar_prioridad_red
echo Ajustando prioridad de red...
netsh interface ipv4 set interface "Ethernet" metric=1
netsh interface ipv4 set interface "Wi-Fi" metric=10
echo Prioridad de red ajustada.
pause
goto menu

:vaciar_papelera
echo Vaciando papelera...
powershell -command "Clear-RecycleBin -Force" >nul
echo Listo!
pause
goto menu

:liberar_ram
echo Liberando RAM...
powershell -command "[System.GC]::Collect()" >nul
echo Listo!
pause
goto menu

:reparar_sistema
echo Reparando archivos del sistema...
sfc /scannow
pause
goto menu

:optimizar_disco
echo Optimizando disco...
defrag C: /O
pause
goto menu

:desactivar_programas
echo Desactivando programas en segundo plano...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f
echo Listo!
pause
goto menu

:eliminar_logs
echo Eliminando logs del sistema...
del /f /q C:\Windows\Logs\*.* >nul
del /f /q C:\Windows\System32\LogFiles\*.* >nul
echo Listo!
pause
goto menu

:desactivar_telemetria
echo Desactivando servicios de telemetria...
sc stop DiagTrack >nul
sc config DiagTrack start= disabled >nul
sc stop dmwappushservice >nul
sc config dmwappushservice start= disabled >nul
echo Listo!
pause
goto menu

:crear_plan
echo Creando plan de energia personalizado "Aplo Power Plan"...
powercfg -duplicatescheme SCHEME_MIN
powercfg -changename SCHEME_MIN "Aplo Power Plan" "Potencia extrema personalizada"
powercfg -setactive SCHEME_MIN
echo Plan de energia 'Aplo Power Plan' activado.
pause
goto menu

:limpiar_cache_navegadores
echo Limpiando cache de navegadores...
del /q /s "%LocalAppData%\Google\Chrome\User Data\Default\Cache\*" >nul 2>nul
del /q /s "%LocalAppData%\Microsoft\Edge\User Data\Default\Cache\*" >nul 2>nul
echo Listo.
pause
goto menu

:limpiar_wu_historial
echo Limpiando historial de actualizaciones fallidas...
net stop wuauserv >nul
del /f /s /q C:\Windows\SoftwareDistribution\Download\*.* >nul 2>nul
net start wuauserv >nul
echo Hecho.
pause
goto menu

:desactivar_ads
echo Desactivando sugerencias y anuncios del sistema...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338388Enabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338389Enabled /t REG_DWORD /d 0 /f >nul
echo Listo.
pause
goto menu

:vaciar_prefetch
echo Vaciando carpeta Prefetch...
del /q C:\Windows\Prefetch\*.* >nul 2>nul
echo Hecho.
pause
goto menu

:reiniciar_explorer
echo Reiniciando Explorador de Windows...
taskkill /f /im explorer.exe >nul
start explorer.exe
echo Reiniciado.
pause
goto menu

:renovar_ip_dns
echo Renovando IP y limpiando DNS...
ipconfig /release
ipconfig /renew
ipconfig /flushdns
echo Red actualizada.
pause
goto menu

:limpiar_impresion
echo Limpiando cola de impresion...
net stop spooler
del /Q /F /S "%systemroot%\System32\spool\PRINTERS\*.*" >nul 2>nul
net start spooler
echo Hecho.
pause
goto menu

:limpiar_descargas
echo Seguro que deseas limpiar la carpeta Descargas? (S/N)
set /p conf=
if /I "%conf%"=="S" (
    del /f /q "%UserProfile%\Downloads\*.*" >nul 2>nul
    echo Carpeta Descargas limpiada.
) else (
    echo Cancelado.
)
pause
goto menu

:desactivar_servicios
echo Desactivando servicios innecesarios seguros...
sc config XblGameSave start= disabled >nul
sc config WSearch start= disabled >nul
sc config SysMain start= disabled >nul
sc config Fax start= disabled >nul
sc config WerSvc start= disabled >nul
sc stop XblGameSave >nul
sc stop WSearch >nul
sc stop SysMain >nul
sc stop Fax >nul
sc stop WerSvc >nul
echo Servicios secundarios desactivados.
pause
goto menu

:comprobar_disco
echo Comprobando disco con CHKDSK...
chkdsk C: /F /R
echo Finalizado (puede requerir reinicio si hay errores).
pause
goto menu

:limpiar_update_cache
echo Limpiando archivos antiguos de Windows Update...
cleanmgr /sagerun:1
echo Limpieza iniciada (puede tardar).
pause
goto menu

:limpiar_shadow
echo Eliminando copias de seguridad antiguas...
vssadmin delete shadows /all /quiet
echo Shadow copies eliminadas.
pause
goto menu

:desactivar_animaciones
echo Desactivando animaciones visuales...
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul
echo Listo. Efectos visuales desactivados para mas rendimiento.
pause
goto menu

:reiniciar_red
echo Reiniciando servicios de red...
net stop Dhcp >nul
net start Dhcp >nul
net stop dnscache >nul
net start dnscache >nul
net stop nlasvc >nul
net start nlasvc >nul
echo Servicios de red reiniciados.
pause
goto menu

:desactivar_ahorro_energia_red
echo Desactivando el ahorro de energia para adaptadores de red...
powercfg -devicequery wake_armed
netsh interface ipv4 set subinterface "Ethernet" mtu=1500 store=persistent
echo Ahorro de energia para adaptadores de red desactivado.
pause
goto menu

:todo
call :limpiar_temp
call :vaciar_papelera
call :liberar_ram
call :reparar_sistema
call :optimizar_disco
call :desactivar_programas
call :eliminar_logs
call :desactivar_telemetria
call :crear_plan
call :limpiar_cache_navegadores
call :limpiar_wu_historial
call :desactivar_ads
call :vaciar_prefetch
call :reiniciar_explorer
call :renovar_ip_dns
call :limpiar_impresion
call :limpiar_descargas
call :desactivar_servicios
call :comprobar_disco
call :limpiar_update_cache
call :limpiar_shadow
call :desactivar_animaciones
call :reiniciar_red
call :desactivar_ahorro_energia_red
call :deshabilitar_ipv6
call :ajustar_tcp_ip
call :ajustar_prioridad_red
echo.
echo ==============================
echo    OPTIMIZACION COMPLETA!
echo ==============================
pause
goto menu

