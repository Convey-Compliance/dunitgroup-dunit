unit uCnvDunitUtilities;

interface

procedure RunDunitApp;

implementation

uses
  Forms,
  {$IFNDEF CONSOLE_TESTRUNNER}
  Console,
  {$EndIF}
  SysUtils,
  TestFramework,
  GUITestRunner,
  GTestStyleTestRunner,
  XMLTestRunner2;

procedure RunDunitApp;
var
  TestForm : TGUITestRunner;
  {$IFNDEF CONSOLE_TESTRUNNER}
  Cons : TStdConsole;
  {$EndIf}
begin
  if (ParamCount >= 1) and (ParamStr(1) = '-console') then
    IsConsole := True;
  Application.Initialize;
  if IsConsole and (ParamCount >= 3) then
    RegisteredTests.LoadConfiguration(ParamStr(3), False, False);
  if IsConsole and (ParamCount >= 2) then
    begin
      {$IFNDEF CONSOLE_TESTRUNNER}
      Cons := TStdConsole.Create(nil);
      try
        Cons.Open;
      {$ENDIF}
        TestFramework.RunTest(RegisteredTests, [
          TXMLTestListener.Create(ExpandFileName(ParamStr(2))) as ITestListener,
          TGTestStyleTestListener.Create as ITestListener]);
      {$IFNDEF CONSOLE_TESTRUNNER}
      finally
        Cons.Free;
      end;
      {$ENDIF}
    end
  else
    begin
      Application.CreateForm(TGUITestRunner, TestForm);
      TestForm.Suite := RegisteredTests;
      Application.Run;
    end;
end;

end.
