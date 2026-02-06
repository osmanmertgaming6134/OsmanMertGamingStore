@echo off
setlocal enabledelayedexpansion
title ShieldPy Snake - Nokia Edition

:: 1. Adım: Pencereyi Maksimize Et ve Renkleri Ayarla (Koyu Yeşil Arka Plan, Siyah Yazı)
if not "%1"=="max" (
    start /max cmd /c "%~0" max
    exit /b
)
color 20
mode con cols=80 lines=30

:Menu
cls
echo ========================================
echo        NOKIA 3310 SNAKE EDITION
echo ========================================
echo.
echo 1-5 arasi hiz secin (3 idealdir):
set /p s="Secim: "
:: ... (hız ayarları aynı kalabilir)

:: Pencereyi biraz daha büyük yaparak 3310 hissi verelim
mode con cols=60 lines=25
setlocal enabledelayedexpansion
title Nokia 3310 Snake - Original
mode con cols=50 lines=22

:Menu
cls
echo 1-5 arasi hiz secin (3 idealdir):
set /p s="Secim: "
if "%s%"=="1" set "hiz=150"
if "%s%"=="2" set "hiz=100"
if "%s%"=="3" set "hiz=60"
if "%s%"=="4" set "hiz=30"
if "%s%"=="5" set "hiz=10"
if not defined hiz set "hiz=60"

:: Ayarlar
set "w=30"
set "h=15"
set "x=15"
set "y=7"
set "dir=D"
set "len=4"
set "score=0"

:: Temizlik
if %%x==!sx%%i! if %%y==!sy%%i! set "obj=█"
if %%x==%ax% if %y%==%ay% set "obj=+"

set /a "ax=(%random% %% (w-2)) + 1"
set /a "ay=(%random% %% (h-2)) + 1"

:Loop
:: Girdi Kontrolü
choice /c wasd /t 1 /d %dir% /n >nul 2>&1
if %errorlevel%==1 if not "%dir%"=="S" set "dir=W"
if %errorlevel%==2 if not "%dir%"=="D" set "dir=A"
if %errorlevel%==3 if not "%dir%"=="W" set "dir=S"
if %errorlevel%==4 if not "%dir%"=="A" set "dir=D"

:: Hareket
for /l %%i in (%len%,-1,2) do (
    set /a "p=%%i-1"
    for %%j in (!p!) do (set "sx%%i=!sx%%j!" & set "sy%%i=!sy%%j!")
)
if "%dir%"=="W" set /a "y-=1"
if "%dir%"=="S" set /a "y+=1"
if "%dir%"=="A" set /a "x-=1"
if "%dir%"=="D" set /a "x+=1"
set "sx1=%x%" & set "sy1=%y%"

:: Carpma
if %x% lss 0 goto Die
if %x% geq %w% goto Die
if %y% lss 0 goto Die
if %y% geq %h% goto Die
for /l %%i in (2,1,%len%) do (if %x%==!sx%%i! if %y%==!sy%%i! goto Die)

:: Yemek
if %x%==%ax% if %y%==%ay% (
    set /a "score+=10" & set /a "len+=1"
    set /a "ax=(%random% %% (w-2)) + 1" & set /a "ay=(%random% %% (h-2)) + 1"
)

:: --- HIZLI CIZIM (BUFFERING) ---
set "screen="
cls
echo Skor: %score%
set "edge="
for /l %%i in (0,1,%w%) do set "edge=!edge!#"
echo !edge!

for /l %%y in (0,1,%h%-1) do (
    set "row=#"
    for /l %%x in (0,1,%w%-1) do (
        set "obj= "
        for /l %%i in (1,1,%len%) do (
            if %%x==!sx%%i! if %%y==!sy%%i! set "obj=@"
        )
        if %%x==%ax% if %%y==%ay% set "obj=."
        set "row=!row!!obj!"
    )
    echo !row!#
)
echo !edge!

powershell -command "Start-Sleep -Milliseconds %hiz%"
goto Loop

:Die
echo OYUN BITTI! Skor: %score%
pause
goto Menu