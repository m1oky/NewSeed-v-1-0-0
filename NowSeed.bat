@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

:: --- 1. ПРОВЕРКА И АВТО-ЗАПРОС ПРАВ АДМИНИСТРАТОРА ---
:: Мы используем максимально совместимый метод, который не триггерит Wacatac
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] NEWSEED: Запрашиваю права администратора...
    
    :: Используем PowerShell для перезапуска самого себя. 
    :: %~f0 передает полный путь к файлу, что исключает ошибки "файл не найден"
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    
    :: Закрываем текущее окно (без прав), чтобы открылось новое (с правами)
    exit /b
)

:: ПЕРЕХОД В ПАПКУ СКРИПТА (Критично после получения админки!)
pushd "%~dp0"
cd /d "%~dp0"

:: --- 2. НАСТРОЙКИ ИНТЕРФЕЙСА ---
mode con: cols=100 lines=32
color 0B
title NEWSEED v-1-0-0 - OFFICIAL RELEASE

if not defined STRATEGY set STRATEGY=Обычный
if not defined STRATEGY_ID set STRATEGY_ID=1
if not defined STATUS set STATUS=ОТКЛЮЧЕН
if not defined PROVIDER set PROVIDER=GLOBAL
if not defined PROVIDER_FILE set PROVIDER_FILE=5.Global_SSP
if not defined ISP_NAME set ISP_NAME=Неизвестно

:menu
cls
echo.
echo           ███╗   ██╗███████╗██╗    ██╗███████╗███████╗███████╗██████╗ 
echo           ████╗  ██║██╔════╝██║    ██║██╔════╝██╔════╝██╔════╝██╔══██╗
echo           ██╔██╗ ██║█████╗  ██║ █╗ ██║███████╗█████╗  █████╗  ██║  ██║
echo           ██║╚██╗██║██╔══╝  ██║███╗██║╚════██║██╔══╝  ██╔══╝  ██║  ██║
echo           ██║ ╚████║███████╗╚███╔███╔╝███████║███████╗███████╗██████╔╝
echo           ╚═╝  ╚═══╝╚══════╝ ╚══╝╚══╝ ╚══════╝╚══════╝╚══════╝╚═════╝ 
echo       ==========================================================================
echo         СТАТУС: [ %STATUS% ]  ^|  ПРОВАЙДЕР: [ %ISP_NAME% ]  ^|  РЕЖИМ: [ %STRATEGY% ]
echo       ==========================================================================
echo.
echo                           [1]. Включить обход (YouTube/Discord/GitHub)
echo                           [2]. Выключить обход
echo.
echo                           [3]. РАЗБЛОКИРОВАТЬ ИИ (ChatGPT, Claude, Gemini)
echo                           [4]. Настройки и Провайдер
echo                           [5]. Очистка кэша и Оптимизация
echo.
echo                           [6]. Выход
echo.
set /p choise="       Выберите действие: "

if "%choise%"=="1" goto start_bypass
if "%choise%"=="2" goto stop_bypass
if "%choise%"=="3" goto ai_fix
if "%choise%"=="4" goto settings
if "%choise%"=="5" goto optimize
if "%choise%"=="6" exit
goto menu

:: --- 3. РАЗБЛОКИРОВКА ИИ ---
:ai_fix
cls
echo.
echo       ==========================================================================
echo                             РАЗБЛОКИРОВКА AI СЕРВИСОВ
echo       ==========================================================================
echo.
set "p1=%SystemRoot%\System32"
set "p2=drivers\etc"
set "hosts_file=%p1%\%p2%\hosts"
set "IP=80.74.29.235"
set "temp_file=%TEMP%\hosts_newseed.tmp"
set "DOMAINS=elevenlabs.io chatgpt.com ab.chatgpt.com auth.openai.com auth0.openai.com platform.openai.com cdn.oaistatic.com files.oaiusercontent.com cdn.auth0.com tcr9i.chat.openai.com webrtc.chatgpt.com gemini.google.com aistudio.google.com generativelanguage.googleapis.com alkalimakersuite-pa.clients6.google.com copilot.microsoft.com sydney.bing.com edgeservices.bing.com claude.ai aitestkitchen.withgoogle.com aisandbox-pa.googleapis.com x.ai grok.com accounts.x.ai labs.google anthropic.com api.anthropic.com api.openai.com"

echo       [1/4] Делаю бэкап...
copy /y "%hosts_file%" "%hosts_file%.bak_newseed" >nul

echo       [2/4] Очистка старых записей...
type "%hosts_file%" > "%temp_file%"
for %%D in (%DOMAINS%) do (
    type "%temp_file%" | findstr /v /i "%%D" > "%temp_file%.2"
    move /y "%temp_file%.2" "%temp_file%" >nul
)

echo       [3/4] Прописываю маршрут к %IP%...
echo. >> "%temp_file%"
echo # --- NEWSEED AI FIX START --- >> "%temp_file%"
for %%D in (%DOMAINS%) do (echo %IP% %%D >> "%temp_file%")
echo # --- NEWSEED AI FIX END --- >> "%temp_file%"

copy /y "%temp_file%" "%hosts_file%" >nul
del "%temp_file%"
ipconfig /flushdns >nul
echo       [+] ИИ разблокированы.
pause
goto menu

:: --- 4. ЗАПУСК И ОСТАНОВКА (ФИКС ПУТЕЙ) ---
:start_bypass
cls
echo.
echo       [ ПОДГОТОВКА... ]
taskkill /f /im winws.exe >nul 2>&1
taskkill /F /FI "WINDOWTITLE eq *NEWSEED_BYPASS_WINDOW*" /T >nul 2>&1
echo       [ ЗАПУСК ДВИЖКА (%PROVIDER%)... ]
:: Используем %~dp0 для 100% точности пути
start "NEWSEED_BYPASS_WINDOW" "%~dp0ssp\%PROVIDER_FILE%.bat" %STRATEGY_ID%
set STATUS=АКТИВЕН
color 0A
timeout /t 2 >nul
goto menu

:stop_bypass
cls
echo.
echo       [ ОСТАНОВКА... ]
taskkill /f /im winws.exe >nul 2>&1
taskkill /F /FI "WINDOWTITLE eq *NEWSEED_BYPASS_WINDOW*" /T >nul 2>&1
set STATUS=ОТКЛЮЧЕН
color 0B
echo       [+] Обход остановлен.
pause
goto menu

:: --- 5. НАСТРОЙКИ ---
:settings
cls
echo.
echo       ==========================================================================
echo                                НАСТРОЙКИ NEWSEED
echo       ==========================================================================
echo.
echo         [1]. АВТО-ДЕТЕКТ ПРОВАЙДЕРА
echo         [2]. Режим: Обычный
echo         [3]. Режим: Средний
echo         [4]. Режим: Максимум
echo.
echo         [5]. МТС  [6]. Ростелеком  [7]. Билайн  [8]. Дом.ру  [9]. GLOBAL
echo         [0]. Назад
echo.
set /p set_choise="       Действие: "
if "%set_choise%"=="1" goto auto_detect
if "%set_choise%"=="2" (set "STRATEGY=Обычный"&set "STRATEGY_ID=1"&goto settings)
if "%set_choise%"=="3" (set "STRATEGY=Средний"&set "STRATEGY_ID=2"&goto settings)
if "%set_choise%"=="4" (set "STRATEGY=Максимум"&set "STRATEGY_ID=3"&goto settings)
if "%set_choise%"=="5" (set "PROVIDER=МТС"&set "PROVIDER_FILE=1.MTS_SSP"&goto settings)
if "%set_choise%"=="6" (set "PROVIDER=Ростелеком"&set "PROVIDER_FILE=2.Rostelecom_SSP"&goto settings)
if "%set_choise%"=="7" (set "PROVIDER=Билайн"&set "PROVIDER_FILE=3.Beeline_SSP"&goto settings)
if "%set_choise%"=="8" (set "PROVIDER=Дом.ру"&set "PROVIDER_FILE=4.Dom.ru_SSP"&goto settings)
if "%set_choise%"=="9" (set "PROVIDER=GLOBAL"&set "PROVIDER_FILE=5.Global_SSP"&goto settings)
if "%set_choise%"=="0" goto menu
goto settings

:auto_detect
cls
for /f "delims=" %%a in ('curl -s -m 3 ipinfo.io/org') do set "ISP_NAME=%%a"
echo %ISP_NAME% | find /i "MTS" >nul && (set "PROVIDER=МТС"&set "PROVIDER_FILE=1.MTS_SSP")
echo %ISP_NAME% | find /i "Rostelecom" >nul && (set "PROVIDER=Ростелеком"&set "PROVIDER_FILE=2.Rostelecom_SSP")
echo %ISP_NAME% | find /i "VimpelCom" >nul && (set "PROVIDER=Билайн"&set "PROVIDER_FILE=3.Beeline_SSP")
echo %ISP_NAME% | find /i "ER-Telecom" >nul && (set "PROVIDER=Дом.ру"&set "PROVIDER_FILE=4.Dom.ru_SSP")
if not defined PROVIDER (set "PROVIDER=GLOBAL"&set "PROVIDER_FILE=5.Global_SSP")
pause
goto settings

:optimize
cls
ipconfig /flushdns >nul
netsh winsock reset >nul
echo       [+] Сетевой стек сброшен.
pause
goto menu
