unit XP_OTAFileNamer;

{
 $Source: /cvsroot/dunit/dunit/Contrib/DUnitWizard/Common/XP_OTAFileNamer.pas,v $
 $Revision: 1.1 $
 $Date: 2003/01/27 12:48:27 $
 Last amended by $Author: pvspain $
 $State: Exp $

 TXP_OTAFileNamerForm:

 Copyright (c) 2001,2002 by The Excellent Programming Company Pty Ltd
 (ABN 27 005 394 918). All rights reserved.

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
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type

////////////////////////////////////////////////////////////////////////////
///          TXP_OTAFileNamerForm declaration
////////////////////////////////////////////////////////////////////////////

  TXP_OTAFileNamerForm = class(TForm)
    FileNameEdit: TEdit;
    FolderNameEdit: TEdit;
    SelectFolder: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    CreateFolder: TCheckBox;
    CreateFile: TButton;
    Cancel: TButton;

    procedure SelectFolderClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FileNameChange(Sender: TObject);
    procedure CreateFileClick(Sender: TObject);

  private

    FFileName: string;

    procedure SetFileName(const Value: string);
    procedure ParseFileName;
    procedure CheckFileName;

  public

    property FileName: string read FFileName write SetFileName;

  end;


implementation

uses
  FileCtrl;

{$R *.DFM}

const CVSID: string = '$Header: /cvsroot/dunit/dunit/Contrib/DUnitWizard/Common/XP_OTAFileNamer.pas,v 1.1 2003/01/27 12:48:27 pvspain Exp $';

////////////////////////////////////////////////////////////////////////////
///          TXP_OTAFileNamerForm implementation
////////////////////////////////////////////////////////////////////////////

procedure TXP_OTAFileNamerForm.ParseFileName;
begin
  FileNameEdit.Text := SysUtils.ExtractFileName(FFileName);
  FolderNameEdit.Text := SysUtils.ExcludeTrailingBackslash(
    SysUtils.ExtractFilePath(FFileName));
end;

procedure TXP_OTAFileNamerForm.CheckFileName;
var
 AFolderName, AFileName: string;

begin
  AFolderName := SysUtils.Trim(FolderNameEdit.Text);
  AFileName := SysUtils.Trim(FileNameEdit.Text);

  CreateFolder.Enabled := not FileCtrl.DirectoryExists(AFolderName);
  CreateFile.Enabled := (AFolderName <> '')
    and (AFileName <> '')
    // Folder must exist or we must be allowed to create it
    and ((not CreateFolder.Enabled)
      or (CreateFolder.Enabled and CreateFolder.Checked));
  end;

procedure TXP_OTAFileNamerForm.SetFileName(const Value: string);
begin
  FFileName := Value;
end;

procedure TXP_OTAFileNamerForm.SelectFolderClick(Sender: TObject);
var
  NewFolder: string;
begin

  if FileCtrl.DirectoryExists(FolderNameEdit.Text) then
    NewFolder := FolderNameEdit.Text
  else
    NewFolder := '';

  if FileCtrl.SelectDirectory(NewFolder, [sdAllowCreate], 0) then
    FolderNameEdit.Text := NewFolder;

  ActiveControl := FolderNameEdit;
  FolderNameEdit.SelectAll;
end;

procedure TXP_OTAFileNamerForm.FileNameChange(Sender: TObject);
begin
  CheckFileName;
end;

procedure TXP_OTAFileNamerForm.FormShow(Sender: TObject);
begin
  ParseFileName;
  CheckFileName;
  ActiveControl := FileNameEdit;
  FileNameEdit.SelectAll;
end;

procedure TXP_OTAFileNamerForm.CreateFileClick(Sender: TObject);
begin
  SysUtils.FmtStr(FFileName, '%s\%s', [ SysUtils.Trim(FolderNameEdit.Text),
    SysUtils.Trim(FileNameEdit.Text) ]);
end;

end.
