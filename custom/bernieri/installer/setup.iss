; setup.iss --- Inno setup file
; (Important: *MUST* be DOS encoded)
;
; Copyright (C) 2002 - 2011 Raymond Penners <raymond@dotsphinx.com>
; Copyright (C) 2010 - 2011 Rob Caelers <robc@krandor.nl>
; Copyright (C) 2012 Ray Satiro <raysatiro@yahoo.com>
; All rights reserved.
;
; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;


;
;
; -REQUIRED-
; You must change the preprocessor defines below to reflect your build and dependency directories.
; For example the program files directory where your visual studio dependencies are located may be 
; "C:\Program Files" (32-bit Windows OS) and not "C:\Program Files (x86)" (64-bit Windows OS)
;
#define GtkmmPath "C:\gtkmm"
#define MSVCRTPath "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\redist\x86\Microsoft.VC100.CRT"
#define WorkraveINSTALLPath "X:\workrave\bernieri\build_install\output_for_installer"

#define SrcApp "X:\workrave\bernieri\build_install\output_for_installer\lib\Workrave.exe"
#define FileCopyrightInfo GetFileCopyright(SrcApp)


;
;
;http://stackoverflow.com/questions/357803/automated-build-version-number-with-wix-inno-setup-and-vs2008
#define FileVerStr GetFileVersion(SrcApp)
#if FileVerStr == ""
    #error FileVerStr - Version information not found!
#endif
#define StripBuild(str VerStr) Copy(VerStr, 1, RPos(".", VerStr)-1)
#define AppVerStr StripBuild(FileVerStr)

; Change this to the last number of screenshot files in screenshots_for_installer directory.
; For example I have Screenshot0,1,2,3,4,5. The high is 5.
#define ScreenshotArrayHigh 5
; Make sure to test the size of each screenshot in normal 96dpi mode
; Larger BMP images will be resized and the code doesn't shrink very well


[Messages]
SetupAppTitle=Setup - Workrave
SetupWindowTitle=Setup - Workrave Custom Edition for Bernieri Consulting
WizardInfoBefore=License
InfoBeforeLabel=The Workrave program is free software with NO WARRANTY. Its software license covers the copying, distribution and modification of the program.

;ClickNext=

[Setup]
AppName=Workrave
;AppVerName=Workrave {#AppVerStr} (Custom Edition for Bernieri Consulting)
AppVerName=Workrave Setup v{#FileVerStr} (Custom Edition for Bernieri Consulting)
AppPublisher=Rob Caelers, Raymond Penners, Ray Satiro
AppPublisherURL=http://www.workrave.org
AppSupportURL=http://www.workrave.org
AppUpdatesURL=http://www.workrave.org
InfoBeforeFile=License_GPLv3.rtf
WizardImageFile=images_for_installer\WizardImage.bmp
WizardSmallImageFile=images_for_installer\logo.bmp
PrivilegesRequired=admin
ShowTasksTreeLines=yes
SetupIconFile=images_for_installer\WorkraveXP.ico

UsePreviousAppDir=no
DefaultDirName={pf}\Workrave
DisableDirPage=yes
AlwaysShowDirOnReadyPage=yes

UsePreviousGroup=no
DefaultGroupName=Workrave
DisableProgramGroupPage=yes
AlwaysShowGroupOnReadyPage=yes

;Minimum version is Windows XP
;http://www.jrsoftware.org/ishelp/index.php?topic=winvernotes
MinVersion=0,5.1

;OutputBaseFilename=workrave-custom-win32-v{#FileVerStr}-installer
;OutputBaseFilename=Workrave Setup v{#FileVerStr} (Custom Edition for Bernieri Consulting)
OutputBaseFilename={#SetupSetting("AppVerName")}

#define MyInstCreationDateTime GetDateTimeString ('yyyy/mm/dd hh:nn:ss', '-', ':');
;VersionInfoCopyright={#FileCopyrightInfo}
AppCopyright={#FileCopyrightInfo}
VersionInfoDescription=Workrave Setup built {#MyInstCreationDateTime}
VersionInfoVersion={#FileVerStr}
VersionInfoProductName={#SetupSetting("AppVerName")}


[LangOptions]
DialogFontSize=10
;WelcomeFontSize=12
;CopyrightFontSize=8


[Tasks]
Name: desktopicon; Description: Create a &desktop icon; GroupDescription: Additional icons:;


[Files]
#define DefaultFlags "ignoreversion restartreplace uninsrestartdelete"
;
; BEGIN - FILES NEEDED TO RUN THE INSTALLER PROGRAM
Source: License_GPLv3.rtf; DestDir: {app}; Flags: {#DefaultFlags}
Source: binaries\libzapper-0.dll; DestDir: {app}; Flags: {#DefaultFlags}
Source: binaries\ChangeAutorun.exe; DestDir: {app}\lib; Flags: {#DefaultFlags}
Source: images_for_installer\Workrave Hot Green - Custom Edition.bmp; Flags: dontcopy
Source: images_for_installer\Bernieri_Card.bmp; Flags: dontcopy
Source: screenshots_for_installer\*.*; Flags: dontcopy
;
; END - FILES NEEDED TO RUN THE INSTALLER PROGRAM

; required text notices
Source: ..\..\..\AUTHORS; DestDir: {app}; DestName: AUTHORS.txt; Flags: {#DefaultFlags}
Source: ..\..\..\NEWS; DestDir: {app}; DestName: NEWS.txt; Flags: {#DefaultFlags}
Source: ..\..\..\COPYING; DestDir: {app}; DestName: COPYING.txt; Flags: {#DefaultFlags}

; required gtkmm redistributable files
#include "gtkmm.isi"
#include "gtkmm_locales.isi"

; required bernieri redistributable files (should include gtk share/themes folder)
Source: redist\*.*; DestDir: {app}; Flags: {#DefaultFlags} recursesubdirs

; required Visual Studio redistributable files
Source: {#MSVCRTPath}\*.*; DestDir: {app}\lib; Flags: {#DefaultFlags} recursesubdirs

; applets. technically not required.
Source: ..\..\..\frontend\applets\win32\src\Release\workrave-applet.dll; DestDir: {app}\lib; Check: not IsWin64; Flags: {#DefaultFlags} regserver 32bit
Source: ..\..\..\frontend\applets\win32\src\Release64\workrave-applet.dll; DestDir: {app}\lib; DestName: workrave-applet64.dll; Check: IsWin64; Flags: {#DefaultFlags} regserver 64bit

; 64-bit version of harpoon
Source: ..\..\..\common\win32\Release64\harpoon64.dll; DestDir: {app}\lib; Check: IsWin64; Flags: {#DefaultFlags}
Source: ..\..\..\common\win32\Release64\harpoonHelper.exe; DestDir: {app}\lib; Check: IsWin64; Flags: {#DefaultFlags}


; all other required files -- your workrave INSTALL location
Source: {#WorkraveINSTALLPath}\*.*; DestDir: {app}; Flags: {#DefaultFlags} recursesubdirs

;my test stuff
;Source: X:\Workrave\redist\gtkmm\*.*; DestDir: {app}; Flags: {#DefaultFlags} recursesubdirs
;Source: X:\Workrave\redist\msvc\*.*; DestDir: {app}; Flags: {#DefaultFlags} recursesubdirs
;Source: X:\Workrave\redist\other\*.*; DestDir: {app}; Flags: {#DefaultFlags} recursesubdirs
;Source: X:\Workrave\bernieri\redist\*.*; DestDir: {app}; Flags: {#DefaultFlags} recursesubdirs


[Registry]
Root: HKLM; Subkey: SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Workrave.exe; ValueType: string; ValueData: {app}\lib\Workrave.exe; Flags: uninsdeletekey
Root: HKLM; Subkey: SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Workrave.exe; ValueName: Path; ValueType: string; ValueData: {app}\lib
Root: HKLM; Subkey: SOFTWARE\Workrave; ValueName: CommonGTK; ValueType: string; ValueData: FALSE;


#define ActiveSetupSubkey 'SOFTWARE\Microsoft\Active Setup\Installed Components\{{180B0AC5-6FDA-438B-9466-C9894322B6BA}'

Root: HKLM32; Check: not IsWin64; Subkey: {#ActiveSetupSubkey}; Flags: uninsdeletekey
Root: HKLM32; Check: not IsWin64; Subkey: {#ActiveSetupSubkey}; ValueType: string; ValueData: {code:GetActiveSetupValue|ComponentID};
Root: HKLM32; Check: not IsWin64; Subkey: {#ActiveSetupSubkey}; ValueName: ComponentID; ValueType: string; ValueData: {code:GetActiveSetupValue|ComponentID};
Root: HKLM32; Check: not IsWin64; Subkey: {#ActiveSetupSubkey}; ValueName: IsInstalled; ValueType: dword; ValueData: 1;
Root: HKLM32; Check: not IsWin64; Subkey: {#ActiveSetupSubkey}; ValueName: DontAsk; ValueType: dword; ValueData: 2;
Root: HKLM32; Check: not IsWin64; Subkey: {#ActiveSetupSubkey}; ValueName: Locale; ValueType: string; ValueData: {code:GetActiveSetupValue|Locale};
Root: HKLM32; Check: not IsWin64; Subkey: {#ActiveSetupSubkey}; ValueName: StubPath; ValueType: string; ValueData: {code:GetActiveSetupValue|StubPath};
Root: HKLM32; Check: not IsWin64; Subkey: {#ActiveSetupSubkey}; ValueName: Version; ValueType: string; ValueData: {code:GetActiveSetupValue|Version};

; This installer should not set Active Setup in the 32-bit registry view on 64-bit Windows.
; On 64-bit Windows use 64-bit registry view:
; 32-bit applications may not be initialized and installed correctly for a new user on a 64-bit version of Windows Server 2003
; http://support.microsoft.com/kb/907660
Root: HKLM64; Check: IsWin64; Subkey: {#ActiveSetupSubkey}; Flags: uninsdeletekey
Root: HKLM64; Check: IsWin64; Subkey: {#ActiveSetupSubkey}; ValueType: string; ValueData: {code:GetActiveSetupValue|ComponentID};
Root: HKLM64; Check: IsWin64; Subkey: {#ActiveSetupSubkey}; ValueName: ComponentID; ValueType: string; ValueData: {code:GetActiveSetupValue|ComponentID};
Root: HKLM64; Check: IsWin64; Subkey: {#ActiveSetupSubkey}; ValueName: IsInstalled; ValueType: dword; ValueData: 1;
Root: HKLM64; Check: IsWin64; Subkey: {#ActiveSetupSubkey}; ValueName: DontAsk; ValueType: dword; ValueData: 2;
Root: HKLM64; Check: IsWin64; Subkey: {#ActiveSetupSubkey}; ValueName: Locale; ValueType: string; ValueData: {code:GetActiveSetupValue|Locale};
Root: HKLM64; Check: IsWin64; Subkey: {#ActiveSetupSubkey}; ValueName: StubPath; ValueType: string; ValueData: {code:GetActiveSetupValue|StubPath};
Root: HKLM64; Check: IsWin64; Subkey: {#ActiveSetupSubkey}; ValueName: Version; ValueType: string; ValueData: {code:GetActiveSetupValue|Version};


[Icons]
Name: {group}\Workrave; Filename: {app}\lib\Workrave.exe
Name: {group}\News; Filename: {app}\NEWS.txt
Name: {group}\Read me; Filename: {app}\README.txt
Name: {group}\License; Filename: {app}\License_GPLv3.rtf
Name: {group}\Uninstall; Filename: {uninstallexe}
Name: {userdesktop}\Workrave; Filename: {app}\lib\Workrave.exe; Tasks: desktopicon
Name: {app}\Workrave; Filename: {app}\lib\Workrave.exe

[Run]
Filename: {app}\lib\Workrave.exe; Description: Launch Workrave; Flags: nowait postinstall skipifsilent shellexec

; If we're adding an autorun entry for the current user only..
Filename: {syswow64}\reg.exe; Parameters: "add ""HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"" /v Workrave /t REG_SZ /d ""\""{app}\lib\Workrave.exe\"""" /f"; Flags: runasoriginaluser runhidden skipifdoesntexist; Check: ShouldOriginalUserAutorun; StatusMsg: Adding autorun entry for current user...

; Workrave's Active Setup for Autorun on 64-bit Windows is set using the 64-bit registry view.
; If the Active Setup key exists in the 32-bit registry view then delete the key from that view.
; That would only happen if a customer had installed Workrave on 32-bit Windows and then upgraded to 64-bit Windows.
; This installer should not set Active Setup in the 32-bit registry view on 64-bit Windows.
Filename: {syswow64}\reg.exe; Parameters: "delete ""HKLM\{#ActiveSetupSubkey}"" /f"; Flags: runhidden skipifdoesntexist; Check: IsWin64;


[InstallDelete]
Type: files; Name: {userstartup}\Workrave.lnk
Type: files; Name: {app}\share\sounds\*.wav


[Code]

function FindWorkrave(): Boolean;
external 'FindWorkrave@{tmp}\libzapper-0.dll cdecl delayload';

function ZapWorkrave(): Boolean;
external 'ZapWorkrave@{tmp}\libzapper-0.dll cdecl delayload';

function KillProcess(name : String): Boolean;
external 'KillProcess@{tmp}\libzapper-0.dll cdecl delayload';

Function FindWorkraveWithRetries(count: Integer) : Boolean;
var retVal : Boolean;
//var count : Integer;
begin
	//count := 10;
	retVal := True;
	while ((count > 0) and (retVal)) do
	begin
		retVal := FindWorkrave();
		if retVal then
		begin
			Sleep(100)
		end
		count := count - 1;
	end
	Result := retVal;
end;

Function EnsureWorkraveIsNotRunning() : Boolean;
var retVal : Boolean;
begin
	Result := True;
	try
		retVal := FindWorkraveWithRetries(10);
		if retVal then
		begin
			if MsgBox('Workrave is still running. Setup must close Workrave before continuing. Please click OK to continue, or Cancel to exit',
					mbConfirmation, MB_OKCANCEL) = IDOK then
			begin
				retVal := ZapWorkrave();
				if retVal then
				begin
					retVal := FindWorkraveWithRetries(30);
					if retVal then
					begin
						KillProcess('workrave.exe');
						retVal := FindWorkraveWithRetries(20);
						//retVal := FindWorkrave();
					end
					if retVal then
					begin
						MsgBox('Failed to close Workrave. Please close Workrave manually.', mbError, MB_OK);
						//Result := False;
					end
				end
			end
			else
			begin
				Result := False;
			end
		end
		//KillProcess('dbus-daemon.exe');
		//KillProcess('harpoonHelper.exe');
	except
		MsgBox('Failed to close Workrave. Please close Workrave manually.', mbError, MB_OK);
		MsgBox(GetExceptionMessage, mbInformation, mb_Ok);
	end;
end;


Function InitializeSetup() : Boolean;
begin
	ExtractTemporaryFile('libzapper-0.dll');
	Result := EnsureWorkraveIsNotRunning();
	//CreateCustomForm;
end;

Function InitializeUninstall() : Boolean;
begin
	FileCopy(ExpandConstant('{app}\libzapper-0.dll'), ExpandConstant('{tmp}\libzapper-0.dll'), False);
	Result := EnsureWorkraveIsNotRunning();
end;


// Add a button to the license dialog to view the file in Wordpad
// http://stackoverflow.com/a/8960439
procedure ViewLicenseButtonClick(Sender: TObject);
var WordpadLoc: String;
	RetCode: Integer;
begin
	RegQueryStringValue(HKLM, 'SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\WORDPAD.EXE', '', WordpadLoc);
	
	// on NT/2000 it's a REG_EXPAND_SZ, so expand constant ProgramFiles
	StringChange(WordpadLoc, '%ProgramFiles%', ExpandConstant('{pf}'));
	// remove " at begin and end pf string
	StringChange(WordpadLoc, '"', '');
	
	try
		ExtractTemporaryFile('License_GPLv3.rtf')
	except
		MsgBox('Cannot extract license file.', mbError, mb_Ok);
	end;
	
	if not Exec(WordpadLoc, '"' + ExpandConstant('{tmp}\License_GPLv3.rtf') + '"', '', SW_SHOW, ewNoWait, RetCode) then
		MsgBox('Cannot display license file.', mbError, mb_Ok);
end;


function AdjustLabelHeight(const ALabel: TNewStaticText): Integer;
{ Increases or decreases a label's height so that all text fits.
  Returns the difference in height. }
var
	W, H: Integer;
begin
	W := ALabel.Width;
	H := ALabel.Height;
	ALabel.AutoSize := True;
	ALabel.AutoSize := False;
	ALabel.Width := W;
	Result := ALabel.Height - H;
end;

procedure IncTopDecHeight(const AControl: TControl; const Amount: Integer);
begin
	AControl.SetBounds(AControl.Left, AControl.Top + Amount,
		AControl.Width, AControl.Height - Amount);
end;




var
	AboutButton: TNewButton;
	URLLabel: TNewStaticText;
	
	ScreenshotPage: TWizardPage;
	AutorunPage : TInputOptionWizardPage;
	
	
	RegularClientHeight,
	RegularClientWidth,
	RegularLeft,
	RegularTop,
	
	RegularBevelWidth,
	RegularBevelTop,
	
	RegularAboutButtonLeft,
	RegularAboutButtonTop,
	
	RegularURLLabelLeft,
	RegularURLLabelTop,
	
	RegularCancelButtonLeft,
	RegularCancelButtonTop,
	RegularNextButtonLeft,
	RegularNextButtonTop,
	RegularBackButtonLeft,
	RegularBackButtonTop,
	
	RegularInnerNotebookHeight,
	RegularInnerNotebookWidth,
	RegularInnerNotebookLeft,
	RegularInnerNotebookTop,
	
	RegularOuterNotebookHeight,
	RegularOuterNotebookWidth,
	RegularOuterNotebookLeft,
	RegularOuterNotebookTop : Integer;
	
	
procedure StoreWizardRegularSize; //call this from InitializeWizard before anything else
begin
	RegularClientHeight := WizardForm.ClientHeight;
	RegularClientWidth := WizardForm.ClientWidth;
	RegularLeft := WizardForm.Left;
	RegularTop := WizardForm.Top;
	
	RegularBevelWidth := WizardForm.Bevel.Width;
	RegularBevelTop := WizardForm.Bevel.Top;
	
	RegularAboutButtonLeft := AboutButton.Left;
	RegularAboutButtonTop := AboutButton.Top;
	
	RegularURLLabelLeft := URLLabel.Left;
	RegularURLLabelTop := URLLabel.Top;
	
	RegularCancelButtonLeft := WizardForm.CancelButton.Left;
	RegularCancelButtonTop := WizardForm.CancelButton.Top;
	
	RegularNextButtonLeft := WizardForm.NextButton.Left;
	RegularNextButtonTop := WizardForm.NextButton.Top;
	
	RegularBackButtonLeft := WizardForm.BackButton.Left;
	RegularBackButtonTop := WizardForm.BackButton.Top;
	
	RegularInnerNotebookHeight := WizardForm.InnerNotebook.Height;
	RegularInnerNotebookWidth := WizardForm.InnerNotebook.Width;
	RegularInnerNotebookLeft := WizardForm.InnerNotebook.Left;
	RegularInnerNotebookTop := WizardForm.InnerNotebook.Top;
	
	RegularOuterNotebookHeight := WizardForm.OuterNotebook.Height;
	RegularOuterNotebookWidth := WizardForm.OuterNotebook.Width;
	RegularOuterNotebookLeft := WizardForm.OuterNotebook.Left;
	RegularOuterNotebookTop := WizardForm.OuterNotebook.Top;
end;

procedure ChangeWizardToRegularSize;
begin
	WizardForm.MainPanel.Visible := True;
	WizardForm.Bevel1.Visible := True;
	
	WizardForm.ClientHeight := RegularClientHeight;
	WizardForm.ClientWidth := RegularClientWidth;
	WizardForm.Left := RegularLeft;
	WizardForm.Top := RegularTop;
	
	WizardForm.Bevel.Width := RegularBevelWidth;
	WizardForm.Bevel.Top := RegularBevelTop;
	
	AboutButton.Left := RegularAboutButtonLeft;
	AboutButton.Top := RegularAboutButtonTop;
	
	URLLabel.Left := RegularURLLabelLeft;
	URLLabel.Top := RegularURLLabelTop;
	
	WizardForm.CancelButton.Left := RegularCancelButtonLeft;
	WizardForm.CancelButton.Top := RegularCancelButtonTop;
	
	WizardForm.NextButton.Left := RegularNextButtonLeft;
	WizardForm.NextButton.Top := RegularNextButtonTop;
	
	WizardForm.BackButton.Left := RegularBackButtonLeft;
	WizardForm.BackButton.Top := RegularBackButtonTop;
	
	WizardForm.InnerNotebook.Height := RegularInnerNotebookHeight;
	WizardForm.InnerNotebook.Width := RegularInnerNotebookWidth;
	WizardForm.InnerNotebook.Left := RegularInnerNotebookLeft;
	WizardForm.InnerNotebook.Top := RegularInnerNotebookTop;
	
	WizardForm.OuterNotebook.Height := RegularOuterNotebookHeight;
	WizardForm.OuterNotebook.Width := RegularOuterNotebookWidth;
	WizardForm.OuterNotebook.Left := RegularOuterNotebookLeft;
	WizardForm.OuterNotebook.Top := RegularOuterNotebookTop;
end;

procedure ChangeWizardToScreenshotSize;
var
	X, Y : Integer;
begin
	X := ScaleX(50);
	Y := ScaleY(30);
	
	ChangeWizardToRegularSize;
	
	WizardForm.MainPanel.Visible := False;
	WizardForm.Bevel1.Visible := False;
	
	//MsgBox(IntToStr(WizardForm.InnerNotebook.Width),mbInformation,MB_OK);
	//MsgBox(IntToStr(WizardForm.ClientWidth),mbInformation,MB_OK);
	
	WizardForm.ClientHeight := WizardForm.ClientHeight + Y;
	WizardForm.ClientWidth := WizardForm.ClientWidth + (X*2); //this also adjusts the clientwidth
	WizardForm.Left := WizardForm.Left - X;
	WizardForm.Top := WizardForm.Top - Y;
	//MsgBox(IntToStr(X),mbInformation,MB_OK);
	//MsgBox(IntToStr(Y),mbInformation,MB_OK);
	
	WizardForm.Bevel.Width := WizardForm.ClientWidth;
	WizardForm.Bevel.Top := WizardForm.Bevel.Top + Y;
	
	AboutButton.Left := AboutButton.Left + X;
	AboutButton.Top := AboutButton.Top + Y;
	
	URLLabel.Left := URLLabel.Left + X;
	URLLabel.Top := URLLabel.Top + Y;
	
	WizardForm.CancelButton.Left := WizardForm.CancelButton.Left + X;
	WizardForm.CancelButton.Top := WizardForm.CancelButton.Top + Y;
	
	WizardForm.NextButton.Left := WizardForm.NextButton.Left + X;
	WizardForm.NextButton.Top := WizardForm.NextButton.Top + Y;
	
	WizardForm.BackButton.Left := WizardForm.BackButton.Left + X;
	WizardForm.BackButton.Top := WizardForm.BackButton.Top + Y;
	
	WizardForm.InnerNotebook.Height := WizardForm.Bevel.Top;
	WizardForm.InnerNotebook.Width := WizardForm.ClientWidth;
	WizardForm.InnerNotebook.Left := 0;
	WizardForm.InnerNotebook.Top := 0;
	
	WizardForm.OuterNotebook.Height := WizardForm.InnerNotebook.Height;
	WizardForm.OuterNotebook.Width := WizardForm.InnerNotebook.Width;
	WizardForm.OuterNotebook.Left := WizardForm.InnerNotebook.Left;
	WizardForm.OuterNotebook.Top := WizardForm.InnerNotebook.Top;
	
	(*
		WizardForm.Width := WizardForm.Width + 100;
		WizardForm.OuterNotebook.Width := WizardForm.OuterNotebook.Width + 100;
		WizardForm.InnerNotebook.Width := WizardForm.InnerNotebook.Width + 100;
	*)
	(*
	WizardForm.InnerPage.ClientWidth := WizardForm.ClientWidth;
	WizardForm.InnerPage.Left := 0;
	ScreenshotPage.Surface.Left := 0;
	//WizardForm.OuterNotebook.Left := 0;
	
//DefaultTop - (LicenseHeight - DefaultHeight) div 2;
	//WizardForm.Top := WizardForm.Top - a;
	WizardForm.OuterNotebook.Width := WizardForm.OuterNotebook.Width + 100;
	WizardForm.InnerNotebook.Width := WizardForm.InnerNotebook.Width + 100;
	//WizardForm.Height := WizardForm.Height + a;
	WizardForm.OuterNotebook.Height := 550;//WizardForm.OuterNotebook.Height + (LicenseHeight - DefaultHeight);
	WizardForm.CancelButton.Top := DefaultCancelTop + (LicenseHeight - DefaultHeight);
	WizardForm.NextButton.Top := DefaultNextTop + (LicenseHeight - DefaultHeight);
	WizardForm.BackButton.Top := DefaultBackTop + (LicenseHeight - DefaultHeight);
	WizardForm.Bevel.Top := DefaultBevelTop + (LicenseHeight - DefaultHeight);
	*)
	
end;

function BackOrNextButtonClick(CurPageID: Integer): Boolean;
begin
	Result := True;
	if CurPageID = ScreenshotPage.ID then
	begin
		ChangeWizardToRegularSize;
	end
	else
	begin
		// Get the window position again. The user may have moved the window since InitializeWizard.
		RegularTop := WizardForm.Top;
		RegularLeft := WizardForm.Left;
	end;
end;

function BackButtonClick(CurPageID: Integer): Boolean;
begin
	Result := BackOrNextButtonClick(CurPageID);
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
	Result := BackOrNextButtonClick(CurPageID);
end;

procedure CurPageChanged(CurPageID: Integer);
begin
	if CurPageID = ScreenshotPage.ID then
	begin
		WizardForm.Visible := False;
		ChangeWizardToScreenshotSize;
		WizardForm.Visible := True;
	end;
end;



function BoolToStr(Value : Boolean) : String; 
begin
	if Value then
		result := 'true'
	else
		result := 'false';
end;

// http://stackoverflow.com/questions/5851785/hook-standard-inno-setup-checkbox
procedure ClickEvent(Sender : TObject);
var
	Msg : String;
begin
	// Click Event, allowing inspection of the Values.
	Msg := 'The Following Items are Checked' +#10#13; 
	Msg := Msg + 'Values[0]=' + BoolToStr(AutorunPage.Values[0]) +#10#13;
	Msg := Msg + 'Values[1]=' + BoolToStr(AutorunPage.Values[1]) +#10#13;
	Msg := Msg + 'Values[2]=' + BoolToStr(AutorunPage.Values[2]) +#10#13;
	Msg := Msg + 'Values[3]=' + BoolToStr(AutorunPage.Values[3]) +#10#13;
	Msg := Msg + 'Values[4]=' + BoolToStr(AutorunPage.Values[4]);

	MsgBox(Msg,mbInformation,MB_OK);
end;


procedure RegisterPreviousData(PreviousDataKey: Integer);
var
	Autorun: String;
begin
	Autorun := 'none';
	
	case AutorunPage.SelectedValueIndex of
		0: Autorun := 'new';
		1: Autorun := 'existing';
		2: Autorun := 'everyone';
		3: Autorun := 'current';
		4: Autorun := 'none';
	end;
	SetPreviousData(PreviousDataKey, 'Autorun', Autorun);
end;

procedure BernieriClick(Sender: TObject);
var
	ErrorCode: Integer;
begin
	ShellExecAsOriginalUser('open', 'http://www.berniericonsulting.com/', '', '', SW_SHOWNORMAL, ewNoWait, ErrorCode);
end;

procedure WorkraveClick(Sender: TObject);
var
	ErrorCode: Integer;
begin
	ShellExecAsOriginalUser('open', 'http://www.workrave.org/', '', '', SW_SHOWNORMAL, ewNoWait, ErrorCode);
end;


procedure AboutButtonOnClick(Sender: TObject);
var
	Form: TSetupForm;
	OKButton: TNewButton;
	Label1: TLabel;
	BitmapImage, BitmapImage2: TBitmapImage;
	BitmapFileName: String;
begin
	Form := CreateCustomForm();
	try
		Form.ClientWidth := ScaleX(500);
		Form.ClientHeight := ScaleY(1);
		Form.Caption := 'About';
		Form.CenterInsideControl(WizardForm, False);
		
		BitmapFileName := ExpandConstant('{tmp}\Workrave Hot Green - Custom Edition.bmp');
		ExtractTemporaryFile(ExtractFileName(BitmapFileName));
		
		BitmapImage := TBitmapImage.Create(Form);
		BitmapImage.AutoSize := True;
		BitmapImage.Bitmap.LoadFromFile(BitmapFileName);
		BitmapImage.Cursor := crHand;
		BitmapImage.OnClick := @WorkraveClick;
		BitmapImage.Left := (Form.ClientWidth div 2) - (BitmapImage.Width div 2);
		BitmapImage.Top := ScaleX(20);
		BitmapImage.Parent := Form;
		
		Label1 := TLabel.Create(Form);
		Label1.AutoSize := false;
		Label1.Left := ScaleX(20);
		Label1.Top := BitmapImage.Top + BitmapImage.Height + ScaleX(20);
		Label1.Width := Form.ClientWidth - ( Label1.Left * 2 );
		Label1.Height := ScaleY(1);
		Label1.Caption := 'Workrave is a program that assists in the recovery and prevention of Repetitive Strain Injury (RSI). The program alerts you to take micro-pauses, rest breaks and can restrict you to a daily time limit. This installer will install a version of Workrave with custom settings from Bernieri Consulting.';
		Label1.Transparent := True;
		Label1.WordWrap := True;
		Label1.AutoSize := True;
		Label1.Parent := Form;
		
		BitmapFileName := ExpandConstant('{tmp}\Bernieri_Card.bmp');
		ExtractTemporaryFile(ExtractFileName(BitmapFileName));
		
		BitmapImage2 := TBitmapImage.Create(Form);
		BitmapImage2.AutoSize := True;
		BitmapImage2.Bitmap.LoadFromFile(BitmapFileName);
		BitmapImage2.Cursor := crHand;
		BitmapImage2.OnClick := @BernieriClick;
		BitmapImage2.Left := (Form.ClientWidth div 2) - (BitmapImage2.Width div 2);
		BitmapImage2.Top := Label1.Top + Label1.Height + ScaleX(20);
		BitmapImage2.Parent := Form;
		
		OKButton := TNewButton.Create(Form);
		OKButton.Parent := Form;
		OKButton.Width := ScaleX(75);
		OKButton.Height := ScaleY(23);
		OKButton.Left := (Form.ClientWidth div 2) - (OKButton.Width div 2);
		//OKButton.Top := Form.ClientHeight - ScaleY(23 + 10);
		OKButton.Top := BitmapImage2.Top + BitmapImage2.Height + ScaleX(20);
		OKButton.Caption := 'OK';
		OKButton.ModalResult := mrOk;
		
		Form.ClientHeight := OKButton.Top + OKButton.Height + ScaleX(20);
		Form.ActiveControl := OKButton;
		Form.Center();
		Form.ShowModal();
	finally
		Form.Free();
	end;
end;


// Creates an 'About' button and web link for each Wizard page.
// This function copied from Inno Setup's CodeClasses.iss example
procedure CreateAboutButtonAndURLLabel(ParentForm: TSetupForm; CancelButton: TNewButton);
begin
	AboutButton := TNewButton.Create(ParentForm);
	AboutButton.Left := ParentForm.ClientWidth - CancelButton.Left - CancelButton.Width;
	AboutButton.Top := CancelButton.Top;
	AboutButton.Width := CancelButton.Width;
	AboutButton.Height := CancelButton.Height;
	AboutButton.Caption := '&About...';
	AboutButton.OnClick := @AboutButtonOnClick;
	AboutButton.Parent := ParentForm;
	
	URLLabel := TNewStaticText.Create(ParentForm);
	URLLabel.Caption := 'berniericonsulting.com';
	URLLabel.Cursor := crHand;
	URLLabel.OnClick := @BernieriClick;
	URLLabel.Parent := ParentForm;
	{ Alter Font *after* setting Parent so the correct defaults are inherited first }
	URLLabel.Font.Style := URLLabel.Font.Style + [fsUnderline];
	
	if GetWindowsVersion >= $040A0000 then   { Windows 98 or later? }
		URLLabel.Font.Color := clHotLight
	else
		URLLabel.Font.Color := clBlue;
	
	URLLabel.Top := AboutButton.Top + AboutButton.Height - URLLabel.Height - 2;
	URLLabel.Left := AboutButton.Left + AboutButton.Width + ScaleX(20);
end;


var
	// all of the Screenshot* arrays must be sized the same
	ScreenshotImage: array [0..{#ScreenshotArrayHigh}] of TBitmapImage;
	ScreenshotLabel: array [0..{#ScreenshotArrayHigh}] of TLabel;

procedure ChangeScreenshot(Sender: TObject);
var
	i, j, n, last: Integer;
begin
	last := {#ScreenshotArrayHigh};
	for i := 0 to last do
	begin
		if ScreenshotImage[i].Visible = True then
			break;
	end;
	
	if i <= last then
		n := i
	else
		n := -1;
	
	for j := 0 to last do
	begin
		// if button tag == 1 then go back else go forward
		if TNewButton(Sender).Tag = 1 then
			n := n - 1
		else
			n := n + 1;
		
		if n > last then
			n := 0
		else if n < 0 then
			n := last;
		
		if ScreenshotImage[n].Enabled = True then
		begin
			if i <= last then
			begin
				ScreenshotLabel[i].Visible := False;
				ScreenshotImage[i].Visible := False;
			end;
			
			if ScreenshotLabel[n].Caption <> '' then
				ScreenshotLabel[n].Visible := True;
			
			ScreenshotImage[n].Visible := True;
			break;
		end;
	end;
end;

procedure CreateScreenshotPage;
var
	ForwardButton, BackButton: TNewButton;
	Panel: TPanel;
	Basename, LabelFileName, BitmapFileName: String;
	i: Integer;
	s: String;
	maxheight, maxwidth, tw, th: Integer;
	fh, fw, scale: Single;
begin
	ChangeWizardToScreenshotSize;
	
	ScreenshotPage := CreateCustomPage(wpInfoBefore, 'Getting Started', 'Adjusting to Workrave in your workplace');
	
	ForwardButton := TNewButton.Create(ScreenshotPage);
	ForwardButton.OnClick := @ChangeScreenshot;
	ForwardButton.Caption := '>';
	ForwardButton.Tag := 0;
	ForwardButton.Width := ForwardButton.Height;
	ForwardButton.Top := ScreenshotPage.SurfaceHeight - ForwardButton.Height;
	ForwardButton.Left := ( ScreenshotPage.SurfaceWidth div 2 );
	ForwardButton.Parent := ScreenshotPage.Surface;
	
	BackButton := TNewButton.Create(ScreenshotPage);
	BackButton.OnClick := @ChangeScreenshot;
	BackButton.Caption := '<';
	BackButton.Tag := 1;
	BackButton.Width := BackButton.Height;
	BackButton.Top := ScreenshotPage.SurfaceHeight - BackButton.Height;
	BackButton.Left := ( ScreenshotPage.SurfaceWidth div 2 ) - BackButton.Width;
	BackButton.Parent := ScreenshotPage.Surface;
	
	Panel := TPanel.Create(ScreenshotPage);
	Panel.Parent := ScreenshotPage.Surface;
	Panel.Top := ScaleY(0);
	Panel.Left := ScaleX(0);
	Panel.Height := ScaleY(20);
	Panel.Width := ScreenshotPage.SurfaceWidth;
	Panel.Font.Size := Panel.Font.Size + 2;
	Panel.Font.Style := Panel.Font.Style + [fsBold]; 
	Panel.Caption := 'Screenshots';
	Panel.Color := clWindow;
	Panel.ParentBackground := False;
	
	
	for i := 0 to {#ScreenshotArrayHigh} do
	begin
		Basename := 'Screenshot' + IntToStr(i);
		
		LabelFileName := ExpandConstant('{tmp}\' + Basename + '.txt');
		ScreenshotLabel[i] := TLabel.Create(ScreenshotPage);
		ScreenshotLabel[i].Parent := ScreenshotPage.Surface;
		ScreenshotLabel[i].AutoSize := false;
		ScreenshotLabel[i].Top := Panel.Top + Panel.Height +  ScaleY(10);
		ScreenshotLabel[i].Left := ScaleX(10);
		ScreenshotLabel[i].Height := ScaleY(1);
		ScreenshotLabel[i].Width := ScreenshotPage.SurfaceWidth - ( ScreenshotLabel[i].Left * 2 );
		ScreenshotLabel[i].Transparent := True;
		ScreenshotLabel[i].WordWrap := True;
		s := '';
		try
			ExtractTemporaryFile(ExtractFileName(LabelFileName));
			LoadStringFromFile(LabelFileName, s);
		finally
		end;
		ScreenshotLabel[i].Caption := s;
		if ScreenshotLabel[i].Caption <> '' then 
		begin
			ScreenshotLabel[i].AutoSize := True;
		end;
		ScreenshotLabel[i].Enabled := False;
		ScreenshotLabel[i].Visible := False;
		
		BitmapFileName := ExpandConstant('{tmp}\' + Basename + '.bmp');
		ScreenshotImage[i] := TBitmapImage.Create(ScreenshotPage);
		ScreenshotImage[i].Visible := False;
		ScreenshotImage[i].Enabled := False;
		try
			ExtractTemporaryFile(ExtractFileName(BitmapFileName));
			ScreenshotImage[i].Parent := ScreenshotPage.Surface;
			ScreenshotImage[i].AutoSize := True;
			ScreenshotImage[i].Bitmap.LoadFromFile(BitmapFileName);
			
			maxheight := ForwardButton.Top;
			if ScreenshotLabel[i].Caption <> '' then
				maxheight := maxheight - (ScreenshotLabel[i].Top + ScreenshotLabel[i].Height);
			
			maxwidth := ScreenshotPage.SurfaceWidth;
			
			if (ScreenshotImage[i].Height > maxheight) or (ScreenshotImage[i].Width > maxwidth) then
			begin
				ScreenshotImage[i].AutoSize := False
				ScreenshotImage[i].Stretch := True;
				fh := maxheight / ScreenshotImage[i].Height;
				fw := maxwidth / ScreenshotImage[i].Width;
				
				if fh < fw then
					scale := fh
				else
					scale := fw;
				
				th := trunc(ScreenshotImage[i].Height * scale);
				tw := trunc(ScreenshotImage[i].Width * scale);
				ScreenshotImage[i].Height := th;
				ScreenshotImage[i].Width := tw;
			end;
			
			ScreenshotImage[i].Top := ForwardButton.Top - ScreenshotImage[i].Height - ((maxheight - ScreenshotImage[i].Height) div 2);
			ScreenshotImage[i].Left := (ScreenshotPage.SurfaceWidth div 2) - (ScreenshotImage[i].Width div 2);
			ScreenshotImage[i].Enabled := True;
			ScreenshotLabel[i].Enabled := True;
		finally
		end;
	th := ScreenshotImage[i].Top - (ScreenshotLabel[i].Top + ScreenshotLabel[i].Height);///
	tw := ForwardButton.Top - (ScreenshotImage[i].Top + ScreenshotImage[i].Height);
	end;
	
	
	ChangeScreenshot(ForwardButton);
	
	ChangeWizardToRegularSize;
end;

procedure CreateViewLicenseButton;
var
	ViewLicenseButton: TButton;
begin
	ViewLicenseButton := TButton.Create(WizardForm.InfoBeforeMemo.Parent);
	ViewLicenseButton.Caption := '&View in WordPad';
	ViewLicenseButton.Width := ScaleX(120);
	ViewLicenseButton.Left := WizardForm.InfoBeforeMemo.Left +
		WizardForm.InfoBeforeMemo.Width - ViewLicenseButton.Width;
	//    ViewLicenseButton.Top := WizardForm.InfoBeforeMemo.Top - ViewLicenseButton.Height - 10;
	ViewLicenseButton.Top := WizardForm.InfoBeforeClickLabel.Top;
	ViewLicenseButton.OnClick := @ViewLicenseButtonClick;
	//ViewLicenseButton.Parent := WizardForm.InfoBeforeMemo.Parent;
	ViewLicenseButton.Parent := WizardForm.InfoBeforePage;
end;

procedure InitializeWizard();
var
	Autorun: String;
begin
	// Creates an 'About' button and web link for each Wizard page.
	CreateAboutButtonAndURLLabel(WizardForm, WizardForm.CancelButton);
	
	// Creates a 'View in Wordpad' button to view the license file in wordpad
	CreateViewLicenseButton;
	
	// this should be called right after any buttons are created and before the wizard is modified
	StoreWizardRegularSize; 
	
	
	AutorunPage := CreateInputOptionPage(
		wpSelectTasks,
		'Autorun options for Workrave',
		'Workrave can start automatically (autorun) at user logon.',
		'Here you can choose whether or not to start Workrave automatically at user logon.'
			+ #10#10 
			+ 'Any user can later change their own individual autorun setting from within '
			+ 'Workrave''s preferences panel '
			+ '(Preferences > User interface > ''Start Workrave on Windows startup'').' 
			+ #10#10 
			+ 'Create/update autorun settings for:',
		true,
		false
		);
	AutorunPage.Add('New Workrave users (any user that has never before started Workrave).');
	AutorunPage.Add('Existing Workrave users (updates existing autorun entries only).');
	AutorunPage.Add('Everyone on this computer (ignore any existing settings -- re-create for all).');
	AutorunPage.Add('Current computer user only.');
	AutorunPage.Add('Do not make any autorun modifications.');
	
	Autorun := ExpandConstant('{param:Autorun}');
	
	if Autorun = '' then
		Autorun := GetPreviousData('Autorun', '');
	
	Autorun := Lowercase(Autorun);
	case Autorun of
		'new': AutorunPage.SelectedValueIndex := 0;
		'existing': AutorunPage.SelectedValueIndex := 1;
		'everyone': AutorunPage.SelectedValueIndex := 2;
		'current': AutorunPage.SelectedValueIndex := 3;
		'none': AutorunPage.SelectedValueIndex := 4;
	else
		AutorunPage.SelectedValueIndex := 3;
	end;
	
	// Assign the Click Event.
	//AutorunPage.CheckListBox.OnClickCheck := @ClickEvent;
	
	CreateScreenshotPage;
	
	WizardForm.NoRadio.Checked := True;
end;


function GetActiveSetupValue(V: String) : string;
var
	ChangeAutorun: String;
begin
	Result := '';
	ChangeAutorun := '"' + ExpandConstant('{app}\lib\ChangeAutorun.exe') + '"'
	
	if V = 'ComponentID' then
		Result := 'Workrave Autorun Setup'
	else if V = 'Locale' then
		Result := 'EN'
	else if V = 'Version' then
		Result := GetDateTimeString( 'yyyy/mm/dd/hhnnss', ',', #0 )
	else if V = 'StubPath' then
	begin
		case AutorunPage.SelectedValueIndex of
		0: Result := ChangeAutorun + ' -b' //new
		1: Result := ChangeAutorun + ' -u' //existing
		2: Result := ChangeAutorun + ' -a' //everyone
		//3: //current
		//4: //none
		end;
	end;
	
end;

function ShouldOriginalUserAutorun(): Boolean;
begin
	Result := False;
	
	if AutorunPage.SelectedValueIndex = 3 then
		Result := True;
end;


function UpdateReadyMemo(Space, NewLine, MemoUserInfoInfo, MemoDirInfo, MemoTypeInfo,
	MemoComponentsInfo, MemoGroupInfo, MemoTasksInfo: String): String;
var
	S: String;
begin
	S := '';
	S := S + 'Program settings:' + NewLine + Space;
	S := S + 'Custom settings from Bernieri Consulting' + NewLine;
	
	if MemoUserInfoInfo <> '' then S := S + NewLine + MemoUserInfoInfo + NewLine;
	if MemoDirInfo <> '' then S := S + NewLine + MemoDirInfo + NewLine;
	if MemoTypeInfo <> '' then S := S + NewLine + MemoTypeInfo + NewLine;
	if MemoComponentsInfo <> '' then S := S + NewLine + MemoComponentsInfo + NewLine;
	if MemoGroupInfo <> '' then S := S + NewLine + MemoGroupInfo + NewLine;
	if MemoTasksInfo <> '' then S := S + NewLine + MemoTasksInfo + NewLine;
	
	if AutorunPage.SelectedValueIndex < 4 then
	begin
		S := S + NewLine;
		S := S + 'Create/update autorun settings for:' + NewLine + Space;
		case AutorunPage.SelectedValueIndex of
			0: S := S + 'New Workrave users (any user that has never before started Workrave)';
			1: S := S + 'Existing Workrave users (updates existing autorun entries only)';
			2: S := S + 'Everyone on this computer (ignore any existing settings -- re-create for all)';
			3: S := S + 'Current computer user only';
		end;
		S := S + NewLine;
	end;
	
	Result := S;
end;

procedure InitializeUninstallProgressForm();
begin
	{ Custom controls }
	// About button and URL will not work on uninstall
end;

[_ISTool]
LogFile=X:\Workrave\bernieri\msi_installer\Output\testing.log
LogFileAppend=false
