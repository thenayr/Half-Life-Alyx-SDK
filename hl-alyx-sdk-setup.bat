@ECHO OFF
ECHO NOTE
ECHO Please follow instructions at the end of script to extract / download additional needed files!
ECHO :::::::::::::::::::::::::::::::::::::::
SET steam_default_dir=C:/Program Files (x86)/Steam/steamapps
:: Steam directory check
SET /P steam_defaults=Use default steam directory %steam_default_dir% (Y\N)?
IF /I NOT "%steam_defaults%"=="Y" GOTO SetupSteamDir
GOTO:file_copy_prompt

:SetupSteamDir
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Using custom steam directory
ECHO :::::::::::::::::::::::::::::::::::::::
SET /P steam_default_dir=Enter location of steamapps directory:

:file_copy_prompt
IF exist "%steam_default_dir%" ( echo Found steam directory, continuing ) ELSE ( GOTO DontRun )
SET /P continue_file_copy=Continue SDK setup, requires ~2GB for base install (Y/N)
IF /I NOT "%continue_file_copy%"=="Y" GOTO DontRun

:find_alyx
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Looking for Half life alyx directory
ECHO :::::::::::::::::::::::::::::::::::::::
IF exist "%steam_default_dir%/common/Half-Life Alyx/" ( SET "alyx_dir=%steam_default_dir%/common/Half-Life Alyx/" ) ELSE ( SET /P alyx_dir=Couldn't find alyx, please specify directory to Half-Life Alyx: )
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Alyx dir is set to %alyx_dir%
ECHO :::::::::::::::::::::::::::::::::::::::

:find_steamvr
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Looking for steamvr tools
ECHO :::::::::::::::::::::::::::::::::::::::
IF exist "%steam_default_dir%/common/SteamVR/" ( SET "steamvr_dir=%steam_default_dir%/common/SteamVR" ) ELSE ( SET /P steamvr_dir=Couldn't find SteamVR tools, please specify directory to SteamVR: )
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO SteamVR dir is set to %steamvr_dir%
ECHO :::::::::::::::::::::::::::::::::::::::

:find_sourcemods
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Looking for sourcemods folder
ECHO :::::::::::::::::::::::::::::::::::::::
IF exist "%steam_default_dir%/sourcemods/" ( SET "sourcemods_dir=%steam_default_dir%/sourcemods" ) ELSE ( SET /P sourcemods_dir=Couldn't find sourcemods dir, please specify directory to sourcemods: )
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
robocopy "%steamvr_dir%/tools/steamvr_environments/game/core" "%alyx_sdk_dir%/game/core" /s /e /nfl /ndl /njh /XF pak* /XF shaders*
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Done copying Steam VR files.
ECHO :::::::::::::::::::::::::::::::::::::::

ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Copying Half Life Alyx files...
ECHO :::::::::::::::::::::::::::::::::::::::
robocopy "%alyx_dir%/game/hlvr" "%alyx_sdk_dir%/game/hlvr" /s /e /nfl /ndl /njh /XF pak* /XD maps
robocopy "%alyx_dir%/game/bin/win64" "%alyx_sdk_dir%/game/bin/win64" hlvr.exe
robocopy "%alyx_dir%/game/core" "%alyx_sdk_dir%/game/core" pak* /nfl ndl /njh 
robocopy "%alyx_dir%/game/core" "%alyx_sdk_dir%/game/core" shaders* /nfl ndl /njh 
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
ECHO You MUST extract pak_01.dir file from Half Life Alyx game directory into %alyx_sdk_dir%/game/hlvr
ECHO You MUST download .FGD files from https://github.com/gvarados1/Half-Life-Alyx-FGD and extract them into %alyx_sdk_dir%/game/hlvr
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO :::::::::::::::::::::::::::::::::::::::

ECHO DONE...Happy mapping.
PAUSE
GOTO:EOF

:DontRun
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Stopping HL Alyx editor setup (cancelled)
ECHO :::::::::::::::::::::::::::::::::::::::
PAUSE
