unit uFormuleChimiqueDemo;

//******************************************************************************
// Exemple d'utilisation de l'UnitFormuleChimique pour :
// - la saisie d'une formule chimique dans un TEdit avec aperçu de contrôle du
//   résultat dans un TLabel,
// - le dessin dans une ListBox de plusieurs formules déclarées avec les Strings
//   de l'Inspecteur d'objets de la ListBox,
// - le dessin de remplacement ou d'ajout dans une ListBox d'une formule saisie
//   dans le TEdit précité.
//******************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls,
  unitFormuleChimique;

type
  TForm1 = class(TForm)
    Label2: TLabel;
    Label1: TLabel;
    EditSaisie: TEdit;
    LabelApercu: TLabel;
    ListBox1: TListBox;
    btnAjouterFormuleEnFinDeListe: TSpeedButton;
    btnAjoutDansListBoxALIndex: TSpeedButton;
    procedure FormActivate(Sender: TObject);
    procedure btnAjouterFormuleEnFinDeListeClick(Sender: TObject);
    procedure EditSaisieChange(Sender: TObject);
    procedure ListBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure btnAjoutDansListBoxALIndexClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

// 1)     Appel direct de FormuleChimVersCanvas pour dessiner sur Form1 : ------
procedure TForm1.FormPaint(Sender: TObject);
var       i,x,y : integer;
          R,G,B,dr,dg,db : byte; //<- pour tracé avec ombre (pendant qu'on y est)
begin     Canvas.Brush.Style:=bsClear;
          Canvas.Font.Size:=48;
          x:=8; y:=130;
          R:=GetRValue(ColorToRGB(Color)); G:=GetGValue(ColorToRGB(Color));
          B:=GetBValue(ColorToRGB(Color));
          dr:=round(R/6);  dg:=round(G/6); db:=round(B/6);
          for i:=5 DownTo 0 do
          begin dec(R,dr); dec(G,dg); dec(B,db);
                Form1.Canvas.Font.Color:=RGB(R,G,B);
                if i=0 then Form1.Canvas.Font.Color:=clYellow;
                FormuleChimVersCanvas(Form1.canvas, 'SO4--', x+i, y+i);
          end;
end;

// 2)     Appel de FormuleChimVersLabel() : ------------------------------------
//        ( utilisé ici pour obtenir un aperçu de contrôle sur le résultat au fur
//        et à mesure de la saisie dans EditSaisie )
procedure TForm1.EditSaisieChange(Sender: TObject);
begin
     FormuleChimVersLabel(EditSaisie.Text, LabelApercu);
end;

// 3)  Exemples d'utilisation pour une ListBox : -------------------------------

// 3.1)   Appel de FormuleChimVersListBox() via onDrawItem de la ListBox cible :
procedure TForm1.ListBox1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin     FormuleChimVersListBox( ListBox1, '', //<-- le '' donne la priorité aux Items existants
                                  Index, clAqua,clWhite);
end;

// 3.2)   Appel de FormuleChimVersListBox() pour cas où les formules chimiques
//        sont déclarées avec les Strings de l'Inspecteur d'objets de la ListBox
procedure TForm1.FormActivate(Sender: TObject);
var       index : integer;
begin     for index:=0 to ListBox1.Items.Count-1
          do FormuleChimVersListBox( ListBox1,'', //<-- le '' donne la priorité aux Items existants
                                     Index, clAqua,clWhite);
end;

// 3.3)   Appel de FormuleChimVersListBox() pour cas où la formule chimique saisie
//        dans un tEdit est ajoutée à la fin d'une tListBox :
procedure TForm1.btnAjouterFormuleEnFinDeListeClick(Sender: TObject);
var       index : integer;
begin     index:=ListBox1.Items.Count;
          FormuleChimVersListBox(ListBox1, EditSaisie.text, index, clAqua,clWhite);
end;

// 3.4)   Appel de FormuleChimVersListBox() pour cas où la formule chimique saisie
//        dans un tEdit est dessinée à un indice donné de la ListBox :
procedure TForm1.btnAjoutDansListBoxALIndexClick(Sender: TObject);
var       index : integer;
begin     if ListBox1.ItemIndex<>-1 then
          index:=ListBox1.ItemIndex; //<-- C'est FormuleChimVersListBox()
          // qui vérifie si index est <= ListBox1.Items.Count-1
          FormuleChimVersListBox(ListBox1, EditSaisie.Text, index, clAqua,clWhite);
end;

END. // ========================================================================
