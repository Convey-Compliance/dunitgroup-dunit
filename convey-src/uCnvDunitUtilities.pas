unit uCnvDunitUtilities;

interface

procedure RunDunitApp;

implementation

uses
  Forms,
  Console,
  SysUtils,
  TestFramework,
  GUITestRunner,
  GTestStyleTestRunner,
  XMLTestRunner2;

procedure RunDunitApp;
var
  TestForm : TGUITestRunner;
  Cons : TStdConsole;
begin
  if (ParamCount >= 1) and (ParamStr(1) = '-console') then
    IsConsole := True;
  Application.Initialize;
  if IsConsole and (ParamCount >= 3) then
    RegisteredTests.LoadConfiguration(ParamStr(3), False, False);
  if IsConsole and (ParamCount >= 2) then
    begin
      Cons := TStdConsole.Create(nil);
      try
        Cons.Open;
        TestFramework.RunTest(RegisteredTests, [
          TXMLTestListener.Create(ExpandFileName(ParamStr(2))) as ITestListener,
          TGTestStyleTestListener.Create as ITestListener]);
      finally
        Cons.Free;
      end;
    end
  else
    begin
      Application.CreateForm(TGUITestRunner, TestForm);
      TestForm.Suite := RegisteredTests;
      Application.Run;
    end;
end;

end.
