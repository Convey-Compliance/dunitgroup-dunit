unit XPDUnitProjectWizard;

{
 $Source: /cvsroot/dunit/dunit/Contrib/DUnitWizard/Wizard/XPDUnitProjectWizard.pas,v $
 $Revision: 1.1 $
 $Date: 2003/01/27 12:49:45 $
 Last amended by $Author: pvspain $
 $State: Exp $

 XPDUnitProjectWizard:

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
function ProjectWizard: IOTAProjectWizard;

implementation

uses
  Windows,          // HICON, LoadIcon()
  Classes,          // TStrings, TStringList
  SysUtils,         // Supports()
  XPDUnitConstants,
  XP_OTAUtils,      // GetCurrentProjectGroup(), TXP_OTAFile
  XP_OTACreators,   // TXP_OTAProjectCreator
  XP_OTAWizards;    // TXP_OTAProjectWizard

// IMPORTANT: Include resources for this unit
{$R *.res}

const CVSID: string = '$Header: /cvsroot/dunit/dunit/Contrib/DUnitWizard/Wizard/XPDUnitProjectWizard.pas,v 1.1 2003/01/27 12:49:45 pvspain Exp $';
const DisplayName = 'DUnit Project';
const AuthorName = 'Paul Spain, EPC';
const WizardComment = 'Unit testing framework';
resourcestring rsProjectPage = 'New';

type

//////////////////////////////////////////////////////////////////////////////
///     Wizard declaration
//////////////////////////////////////////////////////////////////////////////

  TProjectWizard = class(TXP_OTAProjectWizard)
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
///     TProjectCreator declaration
//////////////////////////////////////////////////////////////////////////////

 TProjectCreator = class (TXP_OTAProjectCreator)
 protected

   function GetCreatorType: string; override;
   { Create and return the Project source file }
   function NewProjectSource(const ProjectName: string): IOTAFile; override;

 end;


//////////////////////////////////////////////////////////////////////////////
///     TProjectSource declaration
//////////////////////////////////////////////////////////////////////////////

  TProjectSource = class (TXP_OTAFile)
  private

    FSourceTemplate: string;

  protected

    { Return the actual source code }
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
  ToolsAPI.RegisterPackageWizard(ProjectWizard)
  end;
}

function ProjectWizard: IOTAProjectWizard;
begin
  Result := TProjectWizard.Create;
end;

//////////////////////////////////////////////////////////////////////////////
///   Wizard implementation
//////////////////////////////////////////////////////////////////////////////

procedure TProjectWizard.Execute;
var
  AProjectFileName: string;

begin

  // Suggest a directory below path of currently selected IDE editor.
  if XP_OTAUtils.GetCurrentProjectName(AProjectFileName) then
    AProjectFileName := SysUtils.Format('%sdunit\%sTests.dpr',
      [ SysUtils.ExtractFilePath(AProjectFileName),
       XP_OTAUtils.ExtractFileStem(AProjectFileName) ])
  else
    AProjectFileName := '';

  // Query user and create project on success
  if XP_OTAUtils.AskFileName('DUnit project file name...',
    AProjectFileName) then
    XP_OTAUtils.CreateModule(TProjectCreator.Create(AProjectFileName));

end;

function TProjectWizard.GetAuthor: string;
begin
  Result := AuthorName;
end;

function TProjectWizard.GetComment: string;
begin
  Result := WizardComment;
end;

function TProjectWizard.GetGlyph: TXPIconHandle;
begin
  Result := Windows.LoadIcon(SysInit.HInstance, ProjectIconResource);
end;

function TProjectWizard.GetName: string;
begin
  Result := DisplayName;
end;

function TProjectWizard.GetPage: string;
begin
  Result := rsProjectPage;
end;

//////////////////////////////////////////////////////////////////////////////
///     TProjectCreator implementation
//////////////////////////////////////////////////////////////////////////////

function TProjectCreator.NewProjectSource(const ProjectName: string): IOTAFile;
begin
  Result :=  TProjectSource.Create(ProjectName);
end;

function TProjectCreator.GetCreatorType: string;
begin
  // We provide all necessary information
  Result := '';
end;


//////////////////////////////////////////////////////////////////////////////
///     TProjectSource implementation
//////////////////////////////////////////////////////////////////////////////

constructor TProjectSource.Create(const AFileName: string);
begin
  inherited Create(AFileName);
  FSourceTemplate := PChar( Windows.LockResource(
    Windows.LoadResource( SysInit.HInstance,
    Windows.FindResource( SysInit.HInstance,
    ProjectTextResource, RT_RCDATA ) ) ) );
end;

function TProjectSource.GetSource: string;
begin
  SysUtils.FmtStr(Result, FSourceTemplate, [FFileName]);
end;

end.


