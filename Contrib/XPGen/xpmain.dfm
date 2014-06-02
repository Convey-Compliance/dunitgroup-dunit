object frmxpgenMain: TfrmxpgenMain
  Left = 196
  Top = 175
  Width = 478
  Height = 386
  Caption = 'xpGen'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object memoSrcOutput: TMemo
    Left = 0
    Top = 0
    Width = 470
    Height = 340
    Align = alClient
    TabOrder = 0
  end
  object MainMenu1: TMainMenu
    Left = 82
    Top = 13
    object File1: TMenuItem
      Caption = '&File'
      object mnuOpen: TMenuItem
        Caption = '&Open...'
        OnClick = mnuOpenClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object eXit1: TMenuItem
        Caption = 'Exit'
        OnClick = eXit1Click
      end
    end
    object edit1: TMenuItem
      Caption = '&Edit'
      object Copy1: TMenuItem
        Caption = 'Copy'
        OnClick = Copy1Click
      end
    end
  end
  object odOpen: TOpenDialog
    DefaultExt = 'pas'
    FileName = '*.pas'
    Filter = 'Delphi Source File (*.pas)|*.pas'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Title = 'Open Source File'
    Left = 55
    Top = 104
  end
end
