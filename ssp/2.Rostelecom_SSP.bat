@echo off
title NEWSEED_BYPASS_WINDOW
cd /d "%~dp0..\bin"

if "%1"=="1" winws.exe --wf-tcp=80,443 --wf-udp=443,50000-50100 --hostlist="list.txt" --dpi-desync=split2 --dpi-desync-split-pos=1 --wssize 1:6
if "%1"=="2" winws.exe --wf-tcp=80,443 --wf-udp=443,50000-50100 --hostlist="list.txt" --dpi-desync=fake,split2 --dpi-desync-split-pos=1 --wssize 1:6
if "%1"=="3" winws.exe --wf-tcp=80,443 --wf-udp=443,50000-50100 --hostlist="list.txt" --dpi-desync=fake,split2 --dpi-desync-split-pos=1 --dpi-desync-ttl=4 --wssize 1:6
exit