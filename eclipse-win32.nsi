; eclipse-win32.nsi
; Copyright (c) 2013 The Eclipse Foundation

;---------------------------
;Include Modern UI

!include "MUI2.nsh"
  
; The name of the installer
Name "Eclipse"

; The file to write
OutFile "eclipse_setup32.exe"

; The default installation directory
InstallDir $PROGRAMFILES\Eclipse 

; Registry key to check for directory (so if you install again, it will
; overwrite the old one automatically)
InstallDirRegKey HKLM "Software\Eclipse" "Install_Dir"

; Request application privileges for windows if available
RequestExecutionLevel admin

;----------------------------

; Pages
!insertmacro MUI_PAGE_LICENSE "eula.txt"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
  
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

;-----------------------------

; Languages
!insertmacro MUI_LANGUAGE "English"

;Interface Settings

!define MUI_ABORTWARNING

; The Stuff to install
Section "Eclipse Required Files"

	SectionIn RO
	
	; Set output path to the installation directory
	SetOutPath $INSTDIR
	
	; Install main Eclipse files
	File "eclipse.exe"
	File ".eclipseproduct"
	File "eclipsec.exe"
	File "notice.html"
	File "artifacts.xml"
	File "epl-v10.html"
	File "eclipse.ini"
	
	; Create the Directorys we need for Eclipse to function
	CreateDirectory $INSTDIR\configuration
	CreateDirectory $INSTDIR\dropins
	CreateDirectory $INSTDIR\features
	CreateDirectory $INSTDIR\p2
	CreateDirectory $INSTDIR\plugins
	CreateDirectory $INSTDIR\readme
	
	; Install the files in the direcories
	File /r "configuration"
	File /r "features"
	File /r "p2"
	File /r "plugins"
	File /r "readme"
		
	; Install Eclipse Configuration
	; File "configuration\config.ini"
	; CreateDirectory $INSTDIR\configuration\org.eclipse.update
	; CreateDirectory $INSTDIR\configuration\org.eclipse.equinox.source
	; CreateDirectory $INSTDIR\configuration\org.eclipse.equinox.simpleconfigurator
	; File "org.eclipse.update\platform.xml"
	; File "org.eclipse.equinox.source\source.info"
	; File "org.eclipse.equinox.simpleconfigurator\bundles.info"
	
	; Write the installation path into the registry
	WriteRegStr HKLM SOFTWARE\Eclipse "Install_Dir" "$INSTDIR"

	; Write the uninstall keys for windows
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Eclipse" "Eclipse" "The Eclipse Foundation"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Eclipse" "UninstallString" '"$INSTDIR\uninstall.exe"'
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Eclipse" "NoModify" 1
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Eclipse" "NoRepair" 1
	WriteUninstaller "uninstall.exe"
	
	; Start Menu Shortcuts
	CreateDirectory "$SMPROGRAMS\Eclipse"
	CreateShortCut "$SMPROGRAMS\Eclipse\Eclipse.lnk" "$INSTDIR\eclipse.exe"  "" "$INSTDIR\eclipse.exe" 0
	CreateShortCut "$SMPROGRAMS\Eclipse\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
		
SectionEnd

; Optional Desktop Icon

Section "Desktop Shortcuts"
	
	; Create Desktop Icons
	CreateShortCut "$DESKTOP\Eclipse.lnk" "$INSTDIR\eclipse.exe" ""
	
SectionEnd

; Uninstaller 
Section "Uninstall"

	; Remove Registry keys
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Eclipse"
	DeleteRegKey HKLM SOFTWARE\Eclipse
	
	; Remove files and Uninstaller
	Delete $INSTDIR\eclipse.exe
	Delete $INSTDIR\uninstall.exe
	Delete $INSTDIR\.eclipseproduct
	Delete $INSTDIR\eclipsec.exe
	Delete $INSTDIR\notice.html
	Delete $INSTDIR\artifacts.xml
	Delete $INSTDIR\epl-v10.html
	Delete $INSTDIR\eclipse.ini
	
	; Remove the Directories
	RMDir /r $INSTDIR\configuration
	RMDir /r $INSTDIR\dropins
	RMDir /r $INSTDIR\features
	RMDir /r $INSTDIR\p2
	RMDir /r $INSTDIR\plugins
	RMDir /r $INSTDIR\readme
	
	; Remove Shortcuts, if any
	Delete "$SMPROGRAMS\Eclipse\*.*"
    Delete "$DESKTOP\Eclipse.lnk"
	
	; Remove direcotries used
	RMDir "$SMPROGRAMS\Eclipse"
	RMDir "$INSTDIR"
	
SectionEnd
	


	