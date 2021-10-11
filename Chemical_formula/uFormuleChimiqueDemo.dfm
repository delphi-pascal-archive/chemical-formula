object Form1: TForm1
  Left = 229
  Top = 128
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Chemical formula'
  ClientHeight = 226
  ClientWidth = 683
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clYellow
  Font.Height = -80
  Font.Name = 'Times New Roman'
  Font.Style = [fsBold]
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnPaint = FormPaint
  PixelsPerInch = 120
  TextHeight = 90
  object Label2: TLabel
    Left = 8
    Top = 16
    Width = 122
    Height = 16
    Caption = 'Edit formula here:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 8
    Top = 40
    Width = 49
    Height = 16
    Caption = 'Result:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object LabelApercu: TLabel
    Left = 168
    Top = 36
    Width = 54
    Height = 24
    Caption = 'result'
    Color = clBtnFace
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -20
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object btnAjouterFormuleEnFinDeListe: TSpeedButton
    Left = 8
    Top = 72
    Width = 153
    Height = 25
    Caption = 'Add formula'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    OnClick = btnAjouterFormuleEnFinDeListeClick
  end
  object btnAjoutDansListBoxALIndex: TSpeedButton
    Left = 8
    Top = 104
    Width = 153
    Height = 25
    Caption = 'Replace formula '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    OnClick = btnAjoutDansListBoxALIndexClick
  end
  object EditSaisie: TEdit
    Left = 168
    Top = 8
    Width = 505
    Height = 24
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    Text = 'MnO4- + 8H+ + 5Fe++  ==> Mn++ + 4H2O + 5Fe+++'
    OnChange = EditSaisieChange
  end
  object ListBox1: TListBox
    Left = 168
    Top = 72
    Width = 505
    Height = 148
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -20
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    IntegralHeight = True
    ItemHeight = 24
    Items.Strings = (
      'H2SO4'
      'Mg++'
      'MnO4- + 8H+ + 5Fe++ ==> Mn++ + 4H2O + 5Fe+++'
      'Ferricyanure de potassium : (K3[Fe(CN)6])'
      'Al(OH)3  + (K3[Fe(CN)6]) ==> 55.88 Kj/mole')
    ParentFont = False
    TabOrder = 1
    OnDrawItem = ListBox1DrawItem
  end
end
