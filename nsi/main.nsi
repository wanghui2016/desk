; ��װ�����ʼ���峣��
!define NAME "xinsheng"
!define PRODUCT_NAME "������ѧ"
!define PRODUCT_SRC "..\dist-win\${NAME}-win32-x64"
!define PRODUCT_VERSION "0.0.12"
!define PRODUCT_SETUPICON "..\resources\modern-install-blue-full.ico"
!define PRODUCT_UNINSTALLICON "..\resources\modern-uninstall-blue-full.ico"
!define PRODUCT_PUBLISHER "��ǵ��ѣ��������Ƽ����޹�˾, Inc."
!define PRODUCT_WEB_SITE "https://web.xinshengdaxue.com/"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\${NAME}.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

!define INSTALLER_DEST "..\installer\${PRODUCT_NAME}-v${PRODUCT_VERSION}.exe"

SetCompressor lzma

; ------ MUI �ִ����涨�� (1.67 �汾���ϼ���) ------
!include "MUI.nsh"
!include LogicLib.nsh
!include nsProcess.nsh

; MUI Ԥ���峣��
!define MUI_WELCOMEPAGE_TITLE "\r\n	��ӭ��װ������ѧ"
!define MUI_WELCOMEPAGE_TEXT "     ������ѧ��һ�����ϻ��ۣ�����ѧϰ�����ջ��������ѧϰƽ̨��"
!define MUI_ABORTWARNING
!define MUI_ICON "${PRODUCT_SETUPICON}"
!define MUI_UNICON "${PRODUCT_UNINSTALLICON}"

; ��ӭҳ��
!insertmacro MUI_PAGE_WELCOME
; ���Э��ҳ��
!insertmacro MUI_PAGE_LICENSE "..\Licence"
; ��װĿ¼ѡ��ҳ��
!insertmacro MUI_PAGE_DIRECTORY
; ��װ����ҳ��
!insertmacro MUI_PAGE_INSTFILES
; ��װ���ҳ��
!define MUI_FINISHPAGE_RUN "$INSTDIR\${NAME}.exe"
!insertmacro MUI_PAGE_FINISH

; ��װж�ع���ҳ��
!insertmacro MUI_UNPAGE_INSTFILES

; ��װ�����������������
!insertmacro MUI_LANGUAGE "SimpChinese"
;�ļ��汾����
  VIProductVersion "0.0.2.0"
  VIAddVersionKey /LANG=2052 "ProductName" "${PRODUCT_NAME}"
  VIAddVersionKey /LANG=2052 "Comments" "���ʹ�á�"
  VIAddVersionKey /LANG=2052 "CompanyName" "http://www.tinfinite.com/"
  VIAddVersionKey /LANG=2052 "LegalTrademarks" "tinfinite"
  VIAddVersionKey /LANG=2052 "LegalCopyright" "��ǵ���"
  VIAddVersionKey /LANG=2052 "FileDescription" "${PRODUCT_NAME}"
  VIAddVersionKey /LANG=2052 "FileVersion" "${PRODUCT_VERSION}"

; ��װԤ�ͷ��ļ�
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
; ------ MUI �ִ����涨����� ------

Name "${PRODUCT_NAME}"
OutFile "${INSTALLER_DEST}"
InstallDir "$PROGRAMFILES\${NAME}"
InstallDirRegKey HKLM "${PRODUCT_UNINST_KEY}" "UninstallString"
ShowInstDetails hide
ShowUnInstDetails hide
BrandingText "${PRODUCT_PUBLISHER}"

Section "�������" SEC01
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer
  File "..\dist-win\${NAME}-win32-x64\${NAME}.exe"
  CreateDirectory "$SMPROGRAMS\${NAME}"
  CreateShortCut "$SMPROGRAMS\${NAME}\${PRODUCT_NAME}.lnk" "$INSTDIR\${NAME}.exe"
  CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\${NAME}.exe"
SectionEnd

Section "��������" SEC02
  File /r "..\dist-win\${NAME}-win32-x64\*.*"
SectionEnd

Section -AdditionalIcons
  WriteIniStr "$INSTDIR\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateShortCut "$SMPROGRAMS\${NAME}\Website.lnk" "$INSTDIR\${PRODUCT_NAME}.url"
  CreateShortCut "$SMPROGRAMS\${NAME}\Uninstall.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\${NAME}e.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\${NAME}.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

/******************************
 *  �����ǰ�װ�����ж�ز���  *
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

  RMDir /r "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd

#-- ���� NSIS �ű��༭�������� Function ���α�������� Section ����֮���д���Ա��ⰲװ�������δ��Ԥ֪�����⡣--#

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "��ȷʵҪ��ȫ�Ƴ� $(^Name) ���������е������" IDYES +2
  Abort
	;�رս���
  Push $R0
  CheckProc:
    Push "${NAME}.exe"
    ProcessWork::existsprocess
    Pop $R0
    IntCmp $R0 0 not_running
    MessageBox MB_OKCANCEL|MB_ICONSTOP "��װ�����⵽ ${PRODUCT_NAME} �������С�$\r$\n$\r$\n��� ��ȷ���� ǿ�ƹر�${PRODUCT_NAME}��������װ��$\r$\n��� ��ȡ���� �˳���װ����" IDCANCEL Exit
    Push "${NAME}.exe"
    Processwork::KillProcess
    Sleep 1000
    Goto CheckProc
    Exit:
    Abort
    not_running:
    Pop $R0
FunctionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) �ѳɹ��ش����ļ�����Ƴ���"
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
  ;�رս���
  Push $R0
  CheckProc:
    Push "${NAME}.exe"
    ProcessWork::existsprocess
    Pop $R0
    IntCmp $R0 0 not_running
    MessageBox MB_OKCANCEL|MB_ICONSTOP "��װ�����⵽ ${PRODUCT_NAME} �������С�$\r$\n$\r$\n��� ��ȷ���� ǿ�ƹر�${PRODUCT_NAME}��������װ��$\r$\n��� ��ȡ���� �˳���װ����" IDCANCEL Exit
    Push "${NAME}.exe"
    Processwork::KillProcess
    Sleep 1000
    Goto CheckProc
    Exit:
    Abort
    not_running:
    Pop $R0

  ClearErrors
  ReadRegStr $UNINSTALL_PROG ${PRODUCT_UNINST_ROOT_KEY} ${PRODUCT_UNINST_KEY} "UninstallString"
  IfErrors  done

  ReadRegStr $LOCAL_VER ${PRODUCT_UNINST_ROOT_KEY} ${PRODUCT_UNINST_KEY} "DisplayVersion"
	${VersionCheck} "$LOCAL_VER" "${PRODUCT_VERSION}" $CheckRet
	${select} $CheckRet
		${case} 0
			Goto installOld
    ${case} 2
    	Goto installOld
    ${case} 1
      MessageBox MB_OK|MB_ICONQUESTION \
	    "��⵽�����Ѿ���װ�˽��°汾 ${PRODUCT_NAME} $LOCAL_VER��\
	    $\n$\n����ж���Ѱ�װ�İ汾��"
     Abort
  ${endselect}

installOld:
 ;${PRODUCT_VERSION} > $LOCAL_VER
  MessageBox MB_YESNOCANCEL|MB_ICONQUESTION \
  "��⵽�����Ѿ���װ�� ${PRODUCT_NAME} $LOCAL_VER��\
  $\n$\n�Ƿ�ж���Ѱ�װ�İ汾��" \
    /SD IDYES \
    IDYES uninstall \
    IDNO done
    Abort

uninstall:
  StrCpy $LOCAL_PATH $UNINSTALL_PROG -10

  ExecWait '"$UNINSTALL_PROG" /S _?=$LOCAL_PATH' $0
  DetailPrint "uninst.exe returned $0"
;  MessageBox MB_OK \
;	    "uninst.exe returned��$0"
	${If} $0 == 0
	  Delete "$UNINSTALL_PROG"
	  RMDir /r $LOCAL_PATH
  ${EndIf}

done:
FunctionEnd
