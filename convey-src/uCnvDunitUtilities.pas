unit uCnvDunitUtilities;

interface

procedure RunDunitApp;

implementation

uses
  Forms,
  SysUtils,
  TestFramework,
  GUITestRunner,
  XMLTestRunner2;

procedure RunDunitApp;
var
  TestForm : TGUITestRunner;
begin
  if (ParamCount >= 1) and (ParamStr(1) = '-console') then
    IsConsole := True;
  Application.Initialize;
  if IsConsole and (ParamCount >= 3) then
    RegisteredTests.LoadConfiguration(ParamStr(3), False, False);
  if IsConsole and (ParamCount >= 2) then
    XMLTestRunner2.RunRegisteredTests(ExpandFileName(ParamStr(2)))
  else
    begin
      Application.CreateForm(TGUITestRunner, TestForm);
      TestForm.Suite := RegisteredTests;
      Application.Run;
    end;
end;

end.
