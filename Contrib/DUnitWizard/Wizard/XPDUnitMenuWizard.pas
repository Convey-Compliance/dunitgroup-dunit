unit XPDUnitMenuWizard;

{
 $Source: /cvsroot/dunit/dunit/Contrib/DUnitWizard/Wizard/XPDUnitMenuWizard.pas,v $
 $Revision: 1.1 $
 $Date: 2003/01/27 12:49:45 $
 Last amended by $Author: pvspain $
 $State: Exp $

 XPDUnitMenuWizard:
 Adds DUnit submenu to IDE main menu

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

function MenuWizard(
  const TestCaseWizard, ProjectWizard: IOTAWizard): IOTAWizard;


implementation

uses
  Windows,              // RT_ICON
  Classes,              // TResourceStream
  Graphics,             // TIcon
  SysUtils,             // Supports()
  Menus,                // NewMenuItem()
  XPDUnitConstants,
  XP_OTAWizards,        // TXP_OTAWizard
  XP_OTAUtils,          // GetCurrentProjectGroup()
  XPDUnitProjectWizard; // ProjectCreator()

const CVSID: string = '$Header: /cvsroot/dunit/dunit/Contrib/DUnitWizard/Wizard/XPDUnitMenuWizard.pas,v 1.1 2003/01/27 12:49:45 pvspain Exp $';
const Author = 'Paul Spain, EPC';
const DisplayName = 'DUnit Menu Wizard';

type

//////////////////////////////////////////////////////////////////////////////
///     Wizard declaration
//////////////////////////////////////////////////////////////////////////////

  TXPDUnitMenuWizard = class(TXP_OTAWizard)
  private

    FDUnitMenu: TMenuItem;
    FTestCaseWizard, FProjectWizard: IOTAWizard;

  protected

    function GetAuthor: string; override;
    function GetName: string; override;

    procedure ProjectItemClick(Sender: TObject);
    procedure TestCaseItemClick(Sender: TObject);

  public

    constructor Create(const TestCaseWizard, ProjectWizard: IOTAWizard);
    destructor Destroy; override;
  end;

//////////////////////////////////////////////////////////////////////////////
///     Wizard entry point
//////////////////////////////////////////////////////////////////////////////

function MenuWizard(
  const TestCaseWizard, ProjectWizard: IOTAWizard): IOTAWizard;
begin
  Result := TXPDUnitMenuWizard.Create(TestCaseWizard, ProjectWizard);
end;

//////////////////////////////////////////////////////////////////////////////
///   Wizard implementation
//////////////////////////////////////////////////////////////////////////////

constructor TXPDUnitMenuWizard.Create(
  const TestCaseWizard, ProjectWizard: IOTAWizard);
const
  ShortCut = 0;            
  HelpContext = 0;         
  Enabled = True;
  UnChecked = False;
  SubMenuCaption = 'D&Unit';
  SubMenuName = 'DUnit';
  ProjectItemCaption = 'New &Project...';
  ProjectItemName = 'DUnitNewProject';
  TestCaseItemCaption = 'New &TestCase...';
  TestCaseItemName = 'DUnitNewTestCase';

var
  NTAServices: INTAServices;
  ProjectImage, TestCaseImage: TBitmap;
  ProjectImageIndex, TestCaseImageIndex: integer;

  function FindDUnitMenu: boolean;
  var
    idx: integer;

  begin
    idx := NTAServices.MainMenu.Items.Count - 1;
    Result := false;

    while (idx >= 0) and not Result do
    begin
      Result := NTAServices.MainMenu.Items[idx].Name = SubMenuName;
      System.Dec(idx);
    end;

  end;

begin
  inherited Create;
  FTestCaseWizard := TestCaseWizard;
  FProjectWizard := ProjectWizard;
  // Initialise to nil so we don't need to nest try finallys
  ProjectImage := nil;
  TestCaseImage := nil;

  try

    if SysUtils.Supports(BorlandIDEServices, INTAServices, NTAServices)
      and System.Assigned(NTAServices.MainMenu) and (not FindDUnitMenu)
      then
    begin
      // New submenu and two contained items for New Project and New TestCase
      FDUnitMenu := Menus.NewSubMenu(SubMenuCaption, HelpContext, SubMenuName,
        [ Menus.NewItem(ProjectItemCaption, ShortCut, UnChecked,
            Enabled, ProjectItemClick, HelpContext, ProjectItemName),
          Menus.NewItem(TestCaseItemCaption, ShortCut, UnChecked,
            Enabled, TestCaseItemClick, HelpContext, TestCaseItemName) ],
        Enabled);

      // Insert submenu as new main menu item immediately before Help
      NTAServices.MainMenu.Items.Insert(
        NTAServices.MainMenu.Items.Count - 1, FDUnitMenu);

      // Load up images from package resources

      ProjectImage := TBitmap.Create;
      ProjectImage.LoadFromResourceName(SysInit.HInstance,
        ProjectMenuResource);
      TestCaseImage := TBitmap.Create;
      TestCaseImage.LoadFromResourceName(SysInit.HInstance,
        TestCaseMenuResource);

      // Assign images to menu items

      NTAServices.MainMenu.Images.Masked := true;
      ProjectImageIndex
        := NTAServices.MainMenu.Images.AddMasked(ProjectImage, clWhite);
      TestCaseImageIndex
        := NTAServices.MainMenu.Images.AddMasked(TestCaseImage, clWhite);
      NTAServices.MainMenu.Images.Masked := false;
      FDUnitMenu.Items[0].ImageIndex := ProjectImageIndex;
      FDUnitMenu.Items[1].ImageIndex := TestCaseImageIndex;
    end;

  finally
    TestCaseImage.Free;
    ProjectImage.Free;
  end;

end;

destructor TXPDUnitMenuWizard.Destroy;
begin

  if System.Assigned(FDUnitMenu) then
  begin
    // Menu items remove themselves from parent menu as part of destructor
    // action, so FDUnitMenu.Count will be consequently adjusted for each 
    // iteration.
    while FDUnitMenu.Count > 0 do
      FDUnitMenu.Items[0].Free;

  end;

  FDUnitMenu.Free;
  inherited Destroy;
end;

function TXPDUnitMenuWizard.GetAuthor: string;
begin
   Result := Author;
end;

function TXPDUnitMenuWizard.GetName: string;
begin
  Result := DisplayName;
end;

procedure TXPDUnitMenuWizard.ProjectItemClick(Sender: TObject);
begin

  // Invoke wizard (to add to current project group).
  if System.Assigned(FProjectWizard) then
    FProjectWizard.Execute;

end;

procedure TXPDUnitMenuWizard.TestCaseItemClick(Sender: TObject);
begin

  // Invoke wizard (to add to current project).
  if System.Assigned(FTestCaseWizard) then
    FTestCaseWizard.Execute;

end;

end.


