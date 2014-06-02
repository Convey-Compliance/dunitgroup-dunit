unit XPDUnitTestCaseWizard;

{
 $Source: /cvsroot/dunit/dunit/Contrib/DUnitWizard/Wizard/XPDUnitTestCaseWizard.pas,v $
 $Revision: 1.1 $
 $Date: 2003/01/27 12:49:45 $
 Last amended by $Author: pvspain $
 $State: Exp $

 XPDUnitTestCaseWizard:

 Copyright (c) 2002 by The Excellent Programming Company Pty Ltd
 (Australia) (ABN 27 005 394 918). All rights reserved.

 Contact Paul Spain via email: paul@xpro.com.au

 This unit is free software; you can redistribute it and/or
 modify it under the terms of the GNU Lesser General Public
 License as published by the Free Software Foundation; either
 version 2.1 of the License, or (at your option) any later version.

 This unit is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public
 License along with this unit; if not, the license can be viewed at:
 http://www.gnu.org/copyleft/lesser.html
 or write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 Boston, MA  02111-1307  USA
}

interface

uses
  ToolsAPI;

// procedure Register;
function TestCaseWizard: IOTAFormWizard;

implementation

uses
  XPDUnitConstants,
  SysUtils,         // FmtStr()
  Windows,          // HICON, LoadIcon(), ...
  XP_OTAUtils,      // TXP_OTAFile, AskFileName(), CreateModule()
  XP_OTACreators,   // TXP_OTAProjectCreator
  XP_OTAWizards;    // TXP_OTAProjectWizard

// IMPORTANT: Include resources for this unit
{$R *.res}

const CVSID: string = '$Header: /cvsroot/dunit/dunit/Contrib/DUnitWizard/Wizard/XPDUnitTestCaseWizard.pas,v 1.1 2003/01/27 12:49:45 pvspain Exp $';

const DisplayName = 'DUnit TestCase';
const AuthorName = 'Paul Spain';
const WizardComment = 'Unit test cases';
resourcestring rsTestCasePage = 'New';

type

//////////////////////////////////////////////////////////////////////////////
///     Wizard declaration
//////////////////////////////////////////////////////////////////////////////

  // NOTE: We must implement IOTAFormWizard or IOTAProjectWizard  to get
  // added to the ObjectRepository, even though they are empty
  // interfaces...

  TTestCaseWizard = class(TXP_OTARepositoryWizard, IOTAFormWizard)
  protected

    // IOTAWizard implementation

    function GetName: string; override;
    procedure Execute; override;

    // IOTARepositoryWizard implementation

    function GetAuthor: string; override;
    function GetComment: string; override;
    function GetPage: string; override;
    function GetGlyph: TXPIconHandle; override;

  end;

//////////////////////////////////////////////////////////////////////////////
///     TTestCaseCreator declaration
//////////////////////////////////////////////////////////////////////////////

 TTestCaseCreator = class (TXP_OTAUnitCreator)
 private

   FSource: IXP_OTAFile;

 protected

   // Create and return the new unit's file
   function NewImplSource(const ModuleIdent, FormIdent,
     AncestorIdent: string): IOTAFile; override;

   constructor Create(const AUnitName: string = '');
 end;

//////////////////////////////////////////////////////////////////////////////
///     TTestCaseSource declaration
//////////////////////////////////////////////////////////////////////////////

  TTestCaseSource = class (TXP_OTAFile)
  private

    FSourceTemplate: string;

  protected

    // Return the complete text of the project file.
    function GetSource: string; override;

  public

    constructor Create(const AFileName: string = ''); override;
  end;

//////////////////////////////////////////////////////////////////////////////
///     Wizard entry points
//////////////////////////////////////////////////////////////////////////////

{
procedure Register;
  begin
  ToolsAPI.RegisterPackageWizard(CreateXPDUnitTestCaseWizard)
  end;
}

function TestCaseWizard: IOTAFormWizard;
begin
  Result := TTestCaseWizard.Create;
end;

//////////////////////////////////////////////////////////////////////////////
///   Wizard implementation
//////////////////////////////////////////////////////////////////////////////

procedure TTestCaseWizard.Execute;
var
  AUnitName: string;

begin

  // Suggest a directory below path of currently selected IDE editor.
  if XP_OTAUtils.GetCurrentUnitName(AUnitName) then
    AUnitName := SysUtils.Format('%sdunit\%sTests.pas',
      [ SysUtils.ExtractFilePath(AUnitName),
      XP_OTAUtils.ExtractFileStem(AUnitName) ])
  else
    AUnitName := '';

  // Query user and create project on success
  if XP_OTAUtils.AskFileName('TestCase file name...', AUnitName) then
    XP_OTAUtils.CreateModule(TTestCaseCreator.Create(AUnitName));

end;

function TTestCaseWizard.GetAuthor: string;
begin
  Result := AuthorName;
end;

function TTestCaseWizard.GetComment: string;
begin
  Result := WizardComment;
end;

function TTestCaseWizard.GetGlyph: TXPIconHandle;
begin
  Result := Windows.LoadIcon(SysInit.HInstance, TestCaseIconResource);
end;

function TTestCaseWizard.GetName: string;
begin
  Result := DisplayName;
end;

function TTestCaseWizard.GetPage: string;
begin
  Result := rsTestCasePage;
end;

//////////////////////////////////////////////////////////////////////////////
///     TTestCaseCreator implementation
//////////////////////////////////////////////////////////////////////////////

constructor TTestCaseCreator.Create(const AUnitName: string);
begin
  inherited Create(AUnitName);
  // Name is passed in during NewImplSource()
  FSource := TTestCaseSource.Create('');
end;

function TTestCaseCreator.NewImplSource(const ModuleIdent, FormIdent,
  AncestorIdent: string): IOTAFile;
begin
  FSource.FileName := ModuleIdent;
  Result := FSource;
end;

//////////////////////////////////////////////////////////////////////////////
///     TProjectSource implementation
//////////////////////////////////////////////////////////////////////////////

constructor TTestCaseSource.Create(const AFileName: string);
begin
  inherited;
  FSourceTemplate := PChar( Windows.LockResource(
    Windows.LoadResource( SysInit.HInstance,
    Windows.FindResource( SysInit.HInstance,
    TestCaseTextResource, RT_RCDATA ) ) ) );

end;

function TTestCaseSource.GetSource: string;
begin
  SysUtils.FmtStr(Result, FSourceTemplate, [FFileName]);
end;

end.
