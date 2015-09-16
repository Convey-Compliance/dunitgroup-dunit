unit GTestStyleTestRunner;

interface

uses
  Classes, TestFramework, Windows;

type
  TGTestStyleTestListener = class(TInterfacedObject, ITestListener, ITestListenerX)
  private
    FConsoleHandle: THandle;
    FOldColorAttributes: Word;
    procedure CaptureConsoleAttributes;
    procedure FlushOutput;
    function GetTestFullName(ATest: ITest): string;
    procedure PrintError(error: TTestFailure);
    procedure PrintFailure(failure: TTestFailure);
    procedure PrintFailureOrErrorDetails(failure: TTestFailure);
    procedure ResetConsoleColor;
    procedure RestoreOldConsoleColor;
    procedure SetConsoleColor(AColor: Word);
    procedure SetConsoleGreen;
    procedure SetConsoleRed;
  public
    // implement the ITestListener interface
    procedure AddSuccess(test: ITest); virtual;
    procedure AddError(error: TTestFailure); virtual;
    procedure AddFailure(failure: TTestFailure); virtual;
    function  ShouldRunTest(test :ITest):boolean; virtual;
    procedure StartSuite(suite: ITest); virtual;
    procedure EndSuite(suite: ITest); virtual;
    procedure EndTest(test: ITest); virtual;
    procedure StartTest(test: ITest); virtual;
    procedure TestingStarts; virtual;
    procedure TestingEnds(testResult: TTestResult); virtual;
    procedure Status(test :ITest; const Msg :string);
    procedure Warning(test :ITest; const Msg :string);
    procedure Report(r: TTestResult);
    class function RunTest(suite: ITest): TTestResult;
    class function RunRegisteredTests: TTestResult;
  protected
    procedure PrintErrors(r: TTestResult); virtual;
    procedure PrintFailures(r: TTestResult); virtual;
    procedure PrintHeader(r: TTestResult); virtual;
    procedure PrintFailureItems(r :TTestResult); virtual;
    procedure PrintErrorItems(r :TTestResult); virtual;
  end;

function RunTest(suite: ITest): TTestResult;
function RunRegisteredTests: TTestResult;

implementation

uses
  SysUtils;

resourcestring
  STR_ = '%s: %s';
  STR_AtAddress = 'at address ';
  STR_DUnitLines = '[----------]';
  STR_DUnitTestingStarts = ' DUnit testing starts';
  STR_ERROR = '[  ERROR   ]';
  STR_ERROREDOUTTESTS = '%d ERRORED OUT TESTS';
  STR_Exception = 'Exception ';
  STR_FAILED = '[  FAILED  ]';
  STR_FAILEDTESTS = '%d FAILED TESTS';
  STR_TEST_TIME = ' %s (%d ms)';
  STR_OK = '[       OK ]';
  STR_PASSED = '[  PASSED  ]';
  STR_RUN = '[ RUN      ]';
  STR_RunningTestsDoubleLines = '[==========]';
  STR_RunningTestsFromSuite = ' Running %d tests from suite %s';
  STR_Tests = ' %d tests.';
  STR_TestsFromMsTotal = ' %d tests from %s (%d ms total)';
  STR_TestsListedBelow = ' %d tests, listed below:';
  STR_WARNING = 'WARNING %s: %s';

const
  DEFAULT_DOS_COLOR = FOREGROUND_BLUE or FOREGROUND_RED or FOREGROUND_GREEN or FOREGROUND_INTENSITY; // not used for now
  RED_COLOR = FOREGROUND_RED or FOREGROUND_INTENSITY;
  GREEN_COLOR = FOREGROUND_GREEN or FOREGROUND_INTENSITY;

{ TGTestStyleTestListener }

procedure TGTestStyleTestListener.AddSuccess(test: ITest);
begin
  if test.CountTestCases > 1 then
    exit;
  SetConsoleGreen;
  try
    write(STR_OK);
  finally
    ResetConsoleColor;
  end;
  writeln(Format(STR_TEST_TIME, [test.GetName, test.ElapsedTestTime]));
  FlushOutput;
end;

procedure TGTestStyleTestListener.AddError(error: TTestFailure);
begin
  PrintFailureOrErrorDetails(error);
  PrintError(error);
end;

procedure TGTestStyleTestListener.AddFailure(failure: TTestFailure);
begin
  PrintFailureOrErrorDetails(failure);
  PrintFailure(failure);
end;

procedure TGTestStyleTestListener.Report(r: TTestResult);
begin
  PrintHeader(r);
  PrintErrors(r);
  PrintFailures(r);
end;

procedure TGTestStyleTestListener.PrintErrors(r: TTestResult);
begin
  if (r.errorCount = 0) then
    exit;
  SetConsoleRed;
  try
    write(STR_ERROR);
  finally
    ResetConsoleColor;
  end;
  writeln(Format(STR_TestsListedBelow, [r.errorCount]));
  PrintErrorItems(r);
  FlushOutput;
end;

procedure TGTestStyleTestListener.PrintFailureItems(r :TTestResult);
var
  i: Integer;
  failure: TTestFailure;
begin
  for i := 0 to r.FailureCount - 1 do
    begin
      failure := r.Failures[i];
      SetConsoleRed;
      try
        write(STR_FAILED);
      finally
        ResetConsoleColor;
      end;
      writeln(' ', GetTestFullName(failure.failedTest));
    end;
  FlushOutput;
end;

procedure TGTestStyleTestListener.PrintErrorItems(r :TTestResult);
var
  i: Integer;
  error: TTestFailure;
begin
  for i := 0 to r.ErrorCount - 1 do
    begin
      error := r.Errors[i];
      SetConsoleRed;
      try
        write(STR_ERROR);
      finally
        ResetConsoleColor;
      end;
      writeln(' ', GetTestFullName(error.failedTest));
    end;
  FlushOutput;
end;

procedure TGTestStyleTestListener.PrintFailures(r: TTestResult);
begin
  if (r.FailureCount = 0) then
    exit;
  SetConsoleRed;
  try
    write(STR_FAILED);
  finally
    ResetConsoleColor;
  end;
  writeln(Format(STR_TestsListedBelow, [r.failureCount]));
  PrintFailureItems(r);
  FlushOutput;
end;

procedure TGTestStyleTestListener.PrintHeader(r: TTestResult);
begin
  SetConsoleGreen;
  try
    write(STR_PASSED);
  finally
    ResetConsoleColor;
  end;
  writeln(Format(STR_Tests, [r.RunCount - r.ErrorCount - r.FailureCount]));
  FlushOutput;
end;

procedure TGTestStyleTestListener.StartTest(test: ITest);
begin
  if test.CountTestCases > 1 then
    exit;
  SetConsoleGreen;
  try
    write(STR_RUN);
  finally
    ResetConsoleColor;
  end;
  writeln(' ', test.Name);
  FlushOutput;
end;

procedure TGTestStyleTestListener.TestingStarts;
begin
  CaptureConsoleAttributes;
  ResetConsoleColor;
  SetConsoleGreen;
  try
    write(STR_DUnitLines);
  finally
    ResetConsoleColor;
  end;
  writeln(STR_DUnitTestingStarts);
  FlushOutput;
end;

procedure TGTestStyleTestListener.TestingEnds(testResult: TTestResult);
begin
  Report(testResult);
  writeln;
  SetConsoleRed;
  try
    if testResult.FailureCount > 0 then
      writeln(Format(STR_FAILEDTESTS, [testResult.FailureCount]));
    if testResult.FailureCount > 0 then
      writeln(Format(STR_ERROREDOUTTESTS, [testResult.ErrorCount]));
    writeln;
  finally
    RestoreOldConsoleColor;
  end;
  FlushOutput;
end;

class function TGTestStyleTestListener.RunTest(suite: ITest): TTestResult;
begin
  Result := TestFramework.RunTest(suite, [TGTestStyleTestListener.Create]);
end;

class function TGTestStyleTestListener.RunRegisteredTests: TTestResult;
begin
  Result := RunTest(registeredTests);
end;

function RunTest(suite: ITest): TTestResult;
begin
  Result := TestFramework.RunTest(suite, [TGTestStyleTestListener.Create]);
end;

function RunRegisteredTests: TTestResult;
begin
   Result := RunTest(registeredTests);
end;

procedure TGTestStyleTestListener.CaptureConsoleAttributes;
var
  csbiInfo : TConsoleScreenBufferInfo;
begin
  FConsoleHandle := GetStdHandle(STD_OUTPUT_HANDLE);
  if (FConsoleHandle <> 0) and GetConsoleScreenBufferInfo(FConsoleHandle, csbiInfo) then
    FOldColorAttributes := csbiInfo.wAttributes;
end;

function TGTestStyleTestListener.GetTestFullName(ATest: ITest): string;
begin
  {$IFNDEF STANDARD_DUNIT}
  if ATest.Parent <> nil then
    Result := GetTestFullName(ATest.Parent) + '.' + ATest.Name
  else {$ENDIF} Result := ATest.Name;
end;

procedure TGTestStyleTestListener.Status(test: ITest; const Msg: string);
begin
  writeln(Format(STR_, [test.Name, Msg]));
  FlushOutput;
end;

procedure TGTestStyleTestListener.Warning(test: ITest; const Msg: string);
begin
  writeln(Format(STR_WARNING, [test.Name, Msg]));
  FlushOutput;
end;

function TGTestStyleTestListener.ShouldRunTest(test: ITest): boolean;
begin
  Result := test.Enabled;
end;

procedure TGTestStyleTestListener.EndSuite(suite: ITest);
begin
  SetConsoleGreen;
  try
    write(STR_DUnitLines);
  finally
    ResetConsoleColor;
  end;
  writeln(Format(STR_TestsFromMsTotal, [suite.CountEnabledTestCases, suite.Name, suite.ElapsedTestTime]));
  FlushOutput;
end;

procedure TGTestStyleTestListener.EndTest(test: ITest);
begin
end;

procedure TGTestStyleTestListener.FlushOutput;
begin
  Flush(Output);
end;

procedure TGTestStyleTestListener.PrintError(error: TTestFailure);
begin
  SetConsoleRed;
  try
    write(STR_ERROR);
  finally
    ResetConsoleColor;
  end;
  writeln(Format(STR_TEST_TIME, [error.FailedTest.GetName, error.FailedTest.ElapsedTestTime]));
  FlushOutput;
end;

procedure TGTestStyleTestListener.PrintFailure(failure: TTestFailure);
begin
  SetConsoleRed;
  try
    write(STR_FAILED);
  finally
    ResetConsoleColor;
  end;
  writeln(Format(STR_TEST_TIME, [failure.FailedTest.GetName, failure.FailedTest.ElapsedTestTime]));
  FlushOutput;
end;

procedure TGTestStyleTestListener.PrintFailureOrErrorDetails(failure:
    TTestFailure);
begin
  writeln(STR_Exception, failure.ThrownExceptionName);
  writeln(failure.ThrownExceptionMessage);
  writeln(STR_AtAddress, failure.AddressInfo);
  writeln(failure.LocationInfo);
  writeln(failure.StackTrace);
  FlushOutput;
end;

procedure TGTestStyleTestListener.ResetConsoleColor;
begin
  RestoreOldConsoleColor;
end;

procedure TGTestStyleTestListener.RestoreOldConsoleColor;
begin
  SetConsoleColor(FOldColorAttributes);
end;

procedure TGTestStyleTestListener.SetConsoleColor(AColor: Word);
begin
  if FConsoleHandle <> 0 then
    SetConsoleTextAttribute(FConsoleHandle, AColor);
end;

procedure TGTestStyleTestListener.SetConsoleGreen;
begin
  SetConsoleColor(GREEN_COLOR);
end;

procedure TGTestStyleTestListener.SetConsoleRed;
begin
  SetConsoleColor(RED_COLOR);
end;

procedure TGTestStyleTestListener.StartSuite(suite: ITest);
begin
  SetConsoleGreen;
  try
    write(STR_RunningTestsDoubleLines);
  finally
    ResetConsoleColor;
  end;
  writeln(Format(STR_RunningTestsFromSuite, [suite.CountEnabledTestCases, suite.Name]));
  FlushOutput;
end;

end.

