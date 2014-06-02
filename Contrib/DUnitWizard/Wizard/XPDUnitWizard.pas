unit XPDUnitWizard;

{
 $Source: /cvsroot/dunit/dunit/Contrib/DUnitWizard/Wizard/XPDUnitWizard.pas,v $
 $Revision: 1.1 $
 $Date: 2003/01/27 12:49:45 $
 Last amended by $Author: pvspain $
 $State: Exp $

 XPDUnitWizard:

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

procedure Register;

implementation

uses
  ToolsAPI,
  XP_OTAWizards,
  XP_OTAUtils,
  XPDUnitProjectWizard,
  XPDUnitTestCaseWizard,
  XPDUnitMenuWizard;

const CVSID: string = '$Header: /cvsroot/dunit/dunit/Contrib/DUnitWizard/Wizard/XPDUnitWizard.pas,v 1.1 2003/01/27 12:49:45 pvspain Exp $';
const Author = 'Paul Spain, EPC';
const DisplayName = 'EPC DUnit Wizard';

type

//////////////////////////////////////////////////////////////////////////////
///     Wizard declaration
//////////////////////////////////////////////////////////////////////////////

  TXPDUnitWizard = class(TXP_OTAWizard)
  private

    FProjectWizardHandle: integer;
    FTestCaseWizardHandle: integer;
    FMenuWizardHandle: integer;

  protected

    function GetAuthor: string; override;
    function GetName: string; override;

  public

    constructor Create;
    destructor Destroy; override;
  end;

//////////////////////////////////////////////////////////////////////////////
///     Wizard entry point
//////////////////////////////////////////////////////////////////////////////

procedure Register;
  begin
  ToolsAPI.RegisterPackageWizard(TXPDUnitWizard.Create)
  end;

//////////////////////////////////////////////////////////////////////////////
///   Wizard implementation
//////////////////////////////////////////////////////////////////////////////

constructor TXPDUnitWizard.Create;
var
  ATestCaseWizard, AProjectWizard: IOTAWizard;

begin
  inherited;
  AProjectWizard := XPDUnitProjectWizard.ProjectWizard;
  XP_OTAUtils.AddWizard(AProjectWizard, FProjectWizardHandle);
  ATestCaseWizard := XPDUnitTestCaseWizard.TestCaseWizard;
  XP_OTAUtils.AddWizard(ATestCaseWizard, FTestCaseWizardHandle);
  XP_OTAUtils.AddWizard( XPDUnitMenuWizard.MenuWizard(ATestCaseWizard,
    AProjectWizard), FMenuWizardHandle );
end;

destructor TXPDUnitWizard.Destroy;
begin
  XP_OTAUtils.DeleteWizard(FMenuWizardHandle);
  XP_OTAUtils.DeleteWizard(FTestCaseWizardHandle);
  XP_OTAUtils.DeleteWizard(FProjectWizardHandle);
  inherited;
end;

function TXPDUnitWizard.GetAuthor: string;
begin
   Result := Author;
end;

function TXPDUnitWizard.GetName: string;
begin
  Result := DisplayName;
end;

end.


