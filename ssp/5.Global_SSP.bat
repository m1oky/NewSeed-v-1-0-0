@echo off
title NEWSEED_ENGINE
cd /d "%~dp0..\bin"

if "%1"=="1" winws.exe --wf-tcp=80,443,2053,2083,2087,2096,8443 --wf-udp=443,19294-19344,50000-50100 --hostlist="list.txt" --dpi-desync=fake,split2 --dpi-desync-split-pos=1 --dpi-desync-any-protocol=1 --wssize 1:6
if "%1"=="2" winws.exe --wf-tcp=80,443,2053,2083,8443 --wf-udp=443,50000-50100 --hostlist="list.txt" --dpi-desync=fake,hostfakesplit --dpi-desync-hostfakesplit-mod=altorder=1 --dpi-desync-any-protocol=1 --wssize 1:6
if "%1"=="3" winws.exe --wf-tcp=80,443,8443 --wf-udp=443,50000-50100 --hostlist="list.txt" --dpi-desync=fake,disorder2 --dpi-desync-split-pos=1 --dpi-desync-ttl=5 --dpi-desync-any-protocol=1 --wssize 1:6
exit