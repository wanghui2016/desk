﻿; 安装程序初始定义常量
!define NAME "{{name}}"
!define PRODUCT_NAME "{{productName}}"
!define PRODUCT_SRC "{{src}}"
!define PRODUCT_VERSION "{{version}}"
!define PRODUCT_ICON "{{icon}}"
!define PRODUCT_SETUPICON "{{setupIcon}}"
!define PRODUCT_UNINSTALLICON "{{unInstallIcon}}"
!define PRODUCT_PUBLISHER "{{publisher}}"
!define PRODUCT_WEB_SITE "{{webSite}}"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\${NAME}.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

!define INSTALLER_DEST "{{dest}}"

SetCompressor lzma

; ------ MUI 现代界面定义 (1.67 版本以上兼容) ------
!include "MUI.nsh"

; MUI 预定义常量
;!define MUI_WELCOMEPAGE_TITLE "{{welTitle}}"
;!define MUI_WELCOMEPAGE_TEXT "{{welTxt}}"
!define MUI_ABORTWARNING
!define MUI_ICON "${PRODUCT_SETUPICON}"
!define MUI_UNICON "${PRODUCT_UNINSTALLICON}"

; 欢迎页面
!insertmacro MUI_PAGE_WELCOME
; 许可协议页面
!insertmacro MUI_PAGE_LICENSE "..\Licence"
; 安装目录选择页面
!insertmacro MUI_PAGE_DIRECTORY
; 安装过程页面
!insertmacro MUI_PAGE_INSTFILES
; 安装完成页面
!define MUI_FINISHPAGE_RUN "$INSTDIR\${NAME}.exe"
!insertmacro MUI_PAGE_FINISH

; 安装卸载过程页面
!insertmacro MUI_UNPAGE_INSTFILES

; 安装界面包含的语言设置
!insertmacro MUI_LANGUAGE "SimpChinese"
;文件版本声明
  VIProductVersion "${PRODUCT_VERSION}.0"
  VIAddVersionKey /LANG=2052 "ProductName" "${PRODUCT_NAME}"
  VIAddVersionKey /LANG=2052 "Comments" "{{Comments}}"
  VIAddVersionKey /LANG=2052 "CompanyName" "${PRODUCT_PUBLISHER}"
  VIAddVersionKey /LANG=2052 "LegalTrademarks" "tinfinite"
  VIAddVersionKey /LANG=2052 "LegalCopyright" "${PRODUCT_PUBLISHER}"
  VIAddVersionKey /LANG=2052 "FileDescription" "${PRODUCT_NAME}"
  VIAddVersionKey /LANG=2052 "FileVersion" "${PRODUCT_VERSION}"

; 安装预释放文件
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
; ------ MUI 现代界面定义结束 ------

Name "${PRODUCT_NAME}"
OutFile "${INSTALLER_DEST}"
InstallDir "$PROGRAMFILES\${NAME}"
InstallDirRegKey HKLM "${PRODUCT_UNINST_KEY}" "UninstallString"
ShowInstDetails hide
ShowUnInstDetails hide
BrandingText "${PRODUCT_PUBLISHER}"

Section "程序入口" SEC01
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer
  File "${PRODUCT_SRC}\${NAME}.exe"
  CreateDirectory "$SMPROGRAMS\${NAME}"
  CreateShortCut "$SMPROGRAMS\${NAME}\${PRODUCT_NAME}.lnk" "$INSTDIR\${NAME}.exe"
  CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\${NAME}.exe"
SectionEnd

;以下为注册表检测方式，两种方式可以选其一，不过，推荐使用注册表检测方式。
;Section "check xinsheng running"
;ReadRegStr $R2 HKLM ${PRODUCT_UNINST_KEY} "UninstallString"
;  StrCmp $R2 "" NO YES
;    YES:
;    MessageBox MB_ICONQuESTION|MB_YESNO "安装程序检测到 新生大学($R2 + ${PRODUCT_UNINST_KEY}) 正在运行，您必须将其关闭才能进行下一步安装，是否现在进行卸载？" IDYES keep IDNO none
;  keep:
;    ExecWait $R2
;  none:
;    Quit
;    NO:
;SectionEnd

Section "程序依赖" SEC02
  File /r "${PRODUCT_SRC}\*.*"
SectionEnd

Section -AdditionalIcons
  WriteIniStr "$INSTDIR\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateShortCut "$SMPROGRAMS\${NAME}\Website.lnk" "$INSTDIR\${PRODUCT_NAME}.url"
  CreateShortCut "$SMPROGRAMS\${NAME}\Uninstall.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\${NAME}.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\${NAME}.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

/******************************
 *  以下是安装程序的卸载部分  *
 ******************************/

Section Uninstall
  Delete "$INSTDIR\${PRODUCT_NAME}.url"
  Delete "$INSTDIR\uninst.exe"
  Delete "$INSTDIR\${NAME}.exe"

  Delete "$SMPROGRAMS\${NAME}\Uninstall.lnk"
  Delete "$SMPROGRAMS\${NAME}\Website.lnk"
  Delete "$DESKTOP\${PRODUCT_NAME}.lnk"
  Delete "$SMPROGRAMS\${NAME}\${PRODUCT_NAME}.lnk"

  RMDir "$SMPROGRAMS\${NAME}"

  RMDir /r "$INSTDIR\resources"
  RMDir /r "$INSTDIR\locales"

  RMDir "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd

#-- 根据 NSIS 脚本编辑规则，所有 Function 区段必须放置在 Section 区段之后编写，以避免安装程序出现未可预知的问题。--#

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "您确实要完全移除 $(^Name) ，及其所有的组件？" IDYES +2
  Abort
FunctionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) 已成功地从您的计算机移除。"
FunctionEnd

var P1	; file pointer, used to "remember" the position in the Version1 string
var P2	; file pointer, used to "remember" the position in the Version2 string
var V1	;version number from Version1
var V2	;version number from Version2
Var Reslt	; holds the return flag


;	[Macros]
!macro VersionCheck Ver1 Ver2 OutVar
	;	To make this work, one character must be added to the version string:
	Push "x${Ver2}"
	Push "x${Ver1}"
	Call VersionCheckF
	Pop ${OutVar}

!macroend

;	[Defines]
!define VersionCheck "!insertmacro VersionCheck"

;	[Functions]
Function VersionCheckF
	Exch $1 ; $1 contains Version 1
	Exch
	Exch $2 ; $2 contains Version 2
	Exch
	Push $R0
	;	initialize Variables
	StrCpy $V1 ""
	StrCpy $V2 ""
	StrCpy $P1 ""
	StrCpy $P2 ""
	StrCpy $Reslt ""
	;	Set the file pointers:
	IntOp $P1 $P1 + 1
	IntOp $P2 $P2 + 1
	;  ******************* Get 1st version number for Ver1 **********************
	V11:
	;	I use $1 and $2 to help keep identify "Ver1" vs. "Ver2"
	StrCpy $R0 $1 1 $P1 ;$R0 contains the character at position $P1
	IntOp $P1 $P1 + 1 	;increments the file pointer for the next read
	StrCmp $R0 "" V11end 0	;check for empty string
	strCmp $R0 "." v11end 0
	strCpy $V1 "$V1$R0"
	Goto V11
	V11End:
	StrCmp $V1 "" 0 +2
	StrCpy $V1 "0"
	;  ******************* Get 1st version number for Ver2 **********************
	V12:
	StrCpy $R0 $2 1 $P2 ;$R0 contains the character at position $P1
	IntOp $P2 $P2 + 1 	;increments the file pointer for the next read
	StrCmp $R0 "" V12end 0	;check for empty string
	strCmp $R0 "." v12end 0
	strCpy $V2 "$V2$R0"
	Goto V12
	V12End:
	StrCmp $V2 "" 0 +2
	StrCpy $V2 "0"
	;	At this point, we can compare the results.  If the numbers are not
	;		equal, then we can exit
	IntCmp $V1 $V2 cont1 older1 newer1
	older1: ; Version 1 is older (less than) than version 2
	StrCpy $Reslt 2
	Goto ExitFunction
	newer1:	; Version 1 is newer (greater than) Version 2
	StrCpy $Reslt 1
	Goto ExitFunction
	Cont1: ;Versions are the same.  Continue searching for differences
	;	Reset $V1 and $V2
	StrCpy $V1 ""
	StrCpy $V2 ""

	;  ******************* Get 2nd version number for Ver1 **********************
	V21:
	StrCpy $R0 $1 1 $P1 ;$R0 contains the character at position $P1
	IntOp $P1 $P1 + 1 	;increments the file pointer for the next read
	StrCmp $R0 "" V21end 0	;check for empty string
	strCmp $R0 "." v21end 0
	strCpy $V1 "$V1$R0"
	Goto V21
	V21End:
	StrCmp $V1 "" 0 +2
	StrCpy $V1 "0"
	;  ******************* Get 2nd version number for Ver2 **********************
	V22:
	StrCpy $R0 $2 1 $P2 ;$R0 contains the character at position $P1
	IntOp $P2 $P2 + 1 	;increments the file pointer for the next read
	StrCmp $R0 "" V22end 0	;check for empty string
	strCmp $R0 "." V22end 0
	strCpy $V2 "$V2$R0"
	Goto V22
	V22End:
	StrCmp $V2 "" 0 +2
	StrCpy $V2 "0"
	;	At this point, we can compare the results.  If the numbers are not
	;		equal, then we can exit
	IntCmp $V1 $V2 cont2 older2 newer2
	older2: ; Version 1 is older (less than) than version 2
	StrCpy $Reslt 2
	Goto ExitFunction
	newer2:	; Version 1 is newer (greater than) Version 2
	StrCpy $Reslt 1
	Goto ExitFunction
	Cont2: ;Versions are the same.  Continue searching for differences
	;	Reset $V1 and $V2
	StrCpy $V1 ""
	StrCpy $V2 ""
	;  ******************* Get 3rd version number for Ver1 **********************
	V31:
	StrCpy $R0 $1 1 $P1 ;$R0 contains the character at position $P1
	IntOp $P1 $P1 + 1 	;increments the file pointer for the next read
	StrCmp $R0 "" V31end 0	;check for empty string
	strCmp $R0 "." v31end 0
	strCpy $V1 "$V1$R0"
	Goto V31
	V31End:
	StrCmp $V1 "" 0 +2
	StrCpy $V1 "0"
	;  ******************* Get 3rd version number for Ver2 **********************
	V32:
	StrCpy $R0 $2 1 $P2 ;$R0 contains the character at position $P1
	IntOp $P2 $P2 + 1 	;increments the file pointer for the next read
	StrCmp $R0 "" V32end 0	;check for empty string
	strCmp $R0 "." V32end 0
	strCpy $V2 "$V2$R0"
	Goto V32
	V32End:
	StrCmp $V2 "" 0 +2
	StrCpy $V2 "0"
	;	At this point, we can compare the results.  If the numbers are not
	;		equal, then we can exit
	IntCmp $V1 $V2 cont3 older3 newer3
	older3: ; Version 1 is older (less than) than version 2
	StrCpy $Reslt 2
	Goto ExitFunction
	newer3:	; Version 1 is newer (greater than) Version 2
	StrCpy $Reslt 1
	Goto ExitFunction
	Cont3: ;Versions are the same.  Continue searching for differences
	;	Reset $V1 and $V2
	StrCpy $V1 ""
	StrCpy $V2 ""
	;  ******************* Get 4th version number for Ver1 **********************
	V41:
	StrCpy $R0 $1 1 $P1 ;$R0 contains the character at position $P1
	IntOp $P1 $P1 + 1 	;increments the file pointer for the next read
	StrCmp $R0 "" V41end 0	;check for empty string
	strCmp $R0 "." v41end 0
	strCpy $V1 "$V1$R0"
	Goto V41
	V41End:
	StrCmp $V1 "" 0 +2
	StrCpy $V1 "0"
	;  ******************* Get 4th version number for Ver2 **********************
	V42:
	StrCpy $R0 $2 1 $P2 ;$R0 contains the character at position $P1
	IntOp $P2 $P2 + 1 	;increments the file pointer for the next read
	StrCmp $R0 "" V42end 0	;check for empty string
	strCmp $R0 "." V42end 0
	strCpy $V2 "$V2$R0"
	Goto V42
	V42End:
	StrCmp $V2 "" 0 +2
	StrCpy $V2 "0"
	;	At this point, we can compare the results.  If the numbers are not
	;		equal, then we can exit
	IntCmp $V1 $V2 cont4 older4 newer4
	older4: ; Version 1 is older (less than) than version 2
	StrCpy $Reslt 2
	Goto ExitFunction
	newer4:	; Version 1 is newer (greater than) Version 2
	StrCpy $Reslt 1
	Goto ExitFunction
	Cont4:
	;Versions are the same.  We've reached the end of the version
	;	strings, so set the function to 0 (equal) and exit
	StrCpy $Reslt 0
	ExitFunction:
	Pop $R0
	Pop $1
	Pop $2
	Push $Reslt
FunctionEnd

Var UNINSTALL_PROG
Var LOCAL_VER
Var LOCAL_PATH
Var CheckRet
Function .onInit
  ClearErrors
  ReadRegStr $UNINSTALL_PROG ${PRODUCT_UNINST_ROOT_KEY} ${PRODUCT_UNINST_KEY} "UninstallString"
  IfErrors  done

  ReadRegStr $LOCAL_VER ${PRODUCT_UNINST_ROOT_KEY} ${PRODUCT_UNINST_KEY} "DisplayVersion"
	${VersionCheck} "$LOCAL_VER" "${PRODUCT_VERSION}" $CheckRet
	!if ${CheckRet} <= 0
		MessageBox MB_YESNOCANCEL|MB_ICONQUESTION \
	    "检测到本机已经安装了 ${PRODUCT_NAME} $LOCAL_VER ${PRODUCT_VERSION} $CheckRet。\
	    $\n$\n是否卸载已安装的版本？" \
	      /SD IDYES \
	      IDYES uninstall \
	      IDNO done
	!else
			MessageBox MB_OK|MB_ICONQUESTION \
	    "检测到本机已经安装了更新版本 ${PRODUCT_NAME} $LOCAL_VER。\
	    $\n$\n请先卸载已安装的版本？"
	!endif
  Abort

uninstall:
  StrCpy $LOCAL_PATH $UNINSTALL_PROG -10

  ExecWait '"$UNINSTALL_PROG" /S _?=$LOCAL_PATH' $0
  DetailPrint "uninst.exe returned $0"
  Delete "$UNINSTALL_PROG"
  RMDir $LOCAL_PATH

done:
FunctionEnd
