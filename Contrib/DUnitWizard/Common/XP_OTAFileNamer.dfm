object XP_OTAFileNamerForm: TXP_OTAFileNamerForm
  Left = 797
  Top = 458
  Width = 320
  Height = 156
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSizeToolWin
  Color = clBtnFace
  Constraints.MaxHeight = 156
  Constraints.MinHeight = 156
  Constraints.MinWidth = 320
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SelectFolder: TSpeedButton
    Left = 288
    Top = 67
    Width = 21
    Height = 24
    Anchors = [akTop, akRight]
    Caption = '...'
    Flat = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = SelectFolderClick
  end
  object Label1: TLabel
    Left = 5
    Top = 2
    Width = 45
    Height = 13
    Caption = 'File name'
    Layout = tlCenter
  end
  object Label2: TLabel
    Left = 5
    Top = 50
    Width = 29
    Height = 13
    Caption = 'Folder'
    Layout = tlCenter
  end
  object FileNameEdit: TEdit
    Left = 5
    Top = 20
    Width = 278
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    OnChange = FileNameChange
  end
  object FolderNameEdit: TEdit
    Left = 5
    Top = 68
    Width = 278
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    OnChange = FileNameChange
  end
  object CreateFolder: TCheckBox
    Left = 5
    Top = 103
    Width = 97
    Height = 17
    Caption = 'Create folder'
    Checked = True
    State = cbChecked
    TabOrder = 2
    OnClick = FileNameChange
  end
  object CreateFile: TButton
    Left = 151
    Top = 99
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Create'
    Default = True
    ModalResult = 1
    TabOrder = 3
    OnClick = CreateFileClick
  end
  object Cancel: TButton
    Left = 233
    Top = 99
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
end
