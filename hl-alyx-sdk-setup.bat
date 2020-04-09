
@ECHO OFF
ECHO NOTE
ECHO Make sure you have enough space, about double the game size!
ECHO Please follow instructions at the end of script to extract / download additional needed files!
ECHO :::::::::::::::::::::::::::::::::::::::
pause
:: Steam directory check
:: Getting Steam path from registry
for /f "usebackq tokens=1,2,*" %%i in (`reg query "HKCU\Software\Valve\Steam" /v "SteamPath"`) do set "steampath=%%~k"
:: Replacing "/"'s with "\" in some cases
set steampath=%steampath:/=\%
:: Testing common paths
if not exist "%steampath%\steam.exe" (
	if not exist "%ProgramFiles(x86)%\steam\\steam.exe" (
		if not exist "%ProgramFiles%\steam\steam.exe" (
			goto DontRun
		) else (
			set steampath=%ProgramFiles%\steam
		)
	) else set steampath=%ProgramFiles(x86)%\steam
IF exist "%steampath%" ( echo Found steam directory, continuing ) ELSE ( GOTO DontRun )
IF /I NOT "%continue_file_copy%"=="Y" GOTO DontRun


ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Looking for Half life alyx directory
ECHO :::::::::::::::::::::::::::::::::::::::
IF exist "%steampath%/common/Half-Life Alyx/" ( SET "alyx_dir=%steampath%/common/Half-Life Alyx/" ) ELSE ( SET /P alyx_dir=Couldn't find HL:A, please specify the directory it is located in or check you have Half-Life Alyx installed )
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Alyx dir is set to %alyx_dir%
ECHO :::::::::::::::::::::::::::::::::::::::


ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Looking for steamvr tools
ECHO :::::::::::::::::::::::::::::::::::::::
IF exist "%steampath%/common/SteamVR/" ( SET "steamvr_dir=%steampath%/common/SteamVR" ) ELSE ( SET /P steamvr_dir=Couldn't find SteamVR tools, please specify the directory it is located in or  check you have SteamVR installed )
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO SteamVR dir is set to %steamvr_dir%
ECHO :::::::::::::::::::::::::::::::::::::::

ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Select destination folder
ECHO :::::::::::::::::::::::::::::::::::::::
set /p mod_dir= Specify the folder you want to place everything into
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Final folder will be in %sourcemods_dir%
ECHO :::::::::::::::::::::::::::::::::::::::


ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Copying SteamVR files....
ECHO :::::::::::::::::::::::::::::::::::::::
robocopy "%steamvr_dir%/tools/steamvr_environments/game/bin" "%mod_dir%/game/bin" /s /e /nfl /ndl /njh 
robocopy "%steamvr_dir%/tools/steamvr_environments/game/core" "%mod_dir%/game/core" /s /e /nfl /ndl /njh /XF pak02*
start /w "" /D "%mod_dir%\core" %steamvr_dir%/tools/steamvr_environments/game/bin/vpk.exe pak02.vpk
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Done copying Steam VR files.
ECHO :::::::::::::::::::::::::::::::::::::::

ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Copying Half Life Alyx files...
ECHO :::::::::::::::::::::::::::::::::::::::
robocopy "%alyx_dir%/game/hlvr" "%mod_dir%/game/hlvr" /s /e /nfl /ndl /njh /XD maps
robocopy "%alyx_dir%/game/bin/win64" "%mod_dri%/game/bin/win64" hlvr.exe
robocopy "%alyx_dir%/game/core" "%mod_dir%/game/core" /s /e /nfl ndl /njh
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Done copying Half Life Alyx files.
ECHO :::::::::::::::::::::::::::::::::::::::

ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Replacing Half-Life Alyx dll's
ECHO :::::::::::::::::::::::::::::::::::::::
robocopy "%steamvr_dir%/tools/steamvr_environments/game/steamtours/bin/win64" "%mod_dir%/game/hlvr/bin/win64" /s /e /nfl /ndl /njh
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Done replacing Half-Life Alyx dll's
ECHO :::::::::::::::::::::::::::::::::::::::


ECHO Copied files successfully 
ECHO ::::::::::::::::NOTE:::::::::::::::::::
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO You MUST download .FGD files from https://github.com/gvarados1/Half-Life-Alyx-FGD and put them into %alyx_sdk_dir%/game/hlvr
ECHO Run launch-hl-alyx.bat to start it!
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO :::::::::::::::::::::::::::::::::::::::

ECHO DONE...Happy modding.
PAUSE
GOTO:EOF

:DontRun
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Stopping HL Alyx editor setup (cancelled due to errors)
ECHO :::::::::::::::::::::::::::::::::::::::
PAUSE 
