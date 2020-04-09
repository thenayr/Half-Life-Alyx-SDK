
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
GOTO:file_copy_prompt

:file_copy_prompt
IF exist "%steampath%" ( echo Found steam directory, continuing ) ELSE ( GOTO DontRun )
IF /I NOT "%continue_file_copy%"=="Y" GOTO DontRun

:find_alyx
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Looking for Half life alyx directory
ECHO :::::::::::::::::::::::::::::::::::::::
IF exist "%steampath%/common/Half-Life Alyx/" ( SET "alyx_dir=%steampath%/common/Half-Life Alyx/" ) ELSE ( SET /P alyx_dir=Couldn't find HL:A, please check you have Half-Life Alyx installed )
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Alyx dir is set to %alyx_dir%
ECHO :::::::::::::::::::::::::::::::::::::::

:find_steamvr
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Looking for steamvr tools
ECHO :::::::::::::::::::::::::::::::::::::::
IF exist "%steampath%/common/SteamVR/" ( SET "steamvr_dir=%steampath%/common/SteamVR" ) ELSE ( SET /P steamvr_dir=Couldn't find SteamVR tools, please check you have SteamVR installed )
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO SteamVR dir is set to %steamvr_dir%
ECHO :::::::::::::::::::::::::::::::::::::::

:find_sourcemods
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Looking for sourcemods folder
ECHO :::::::::::::::::::::::::::::::::::::::
IF exist "%steampath%/sourcemods/" ( SET "sourcemods_dir=%steam_default_dir%/sourcemods" ) ELSE ( SET /P sourcemods_dir=please check you have steam installed )
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Sourcemods dir is set to %sourcemods_dir%
ECHO :::::::::::::::::::::::::::::::::::::::

:file_copy
:: Prepare Alyx SDK directory
SET "alyx_sdk_dir=%sourcemods_dir%/Half-Life Alyx SDK"
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Prepping Half Life Alyx SDK directories
ECHO :::::::::::::::::::::::::::::::::::::::
IF NOT exist "%alyx_sdk_dir%" ( ECHO it doesn't exist, creating & mkdir "%alyx_sdk_dir%" "%alyx_sdk_dir%/game" ) ELSE ( ECHO it already exists )
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Copying SteamVR files....
ECHO :::::::::::::::::::::::::::::::::::::::
robocopy "%steamvr_dir%/tools/steamvr_environments/game/bin" "%alyx_sdk_dir%/game/bin" /s /e /nfl /ndl /njh 
robocopy "%steamvr_dir%/tools/steamvr_environments/game/core" "%alyx_sdk_dir%/game/core" /s /e /nfl /ndl /njh
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Done copying Steam VR files.
ECHO :::::::::::::::::::::::::::::::::::::::

ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Copying Half Life Alyx files...
ECHO :::::::::::::::::::::::::::::::::::::::
robocopy "%alyx_dir%/game/hlvr" "%alyx_sdk_dir%/game/hlvr" /s /e /nfl /ndl /njh /XD maps
robocopy "%alyx_dir%/game/bin/win64" "%alyx_sdk_dir%/game/bin/win64" hlvr.exe
robocopy "%alyx_dir%/game/core" "%alyx_sdk_dir%/game/core" /s /e /nfl ndl /njh
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Done copying Half Life Alyx files.
ECHO :::::::::::::::::::::::::::::::::::::::

ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Replacing Half-Life Alyx dll's
ECHO :::::::::::::::::::::::::::::::::::::::
robocopy "%steamvr_dir%/tools/steamvr_environments/game/steamtours/bin/win64" "%alyx_sdk_dir%/game/hlvr/bin/win64" /s /e /nfl /ndl /njh
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Done replacing Half-Life Alyx dll's
ECHO :::::::::::::::::::::::::::::::::::::::

GOTO Success

:Success
ECHO Copied files successfully 
ECHO ::::::::::::::::NOTE:::::::::::::::::::
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO You MUST download .FGD files from https://github.com/gvarados1/Half-Life-Alyx-FGD and put them into %alyx_sdk_dir%/game/hlvr
ECHO Run the BAT to start it!
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO :::::::::::::::::::::::::::::::::::::::

ECHO DONE...Happy modding.
PAUSE
GOTO:EOF

:DontRun
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Stopping HL Alyx editor setup cancelled due to errors
ECHO :::::::::::::::::::::::::::::::::::::::
PAUSE 
