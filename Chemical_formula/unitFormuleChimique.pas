unit UnitFormuleChimique;

//******************************************************************************
// Dessiner une Formule chimique dans une ListBox ou dans n'importe quel Canvas.
// (avec avec indices et exposants ... mais sans avoir � utiliser des balises).
//******************************************************************************


interface

uses Graphics, StdCtrls, SysUtils, Windows;

// 1) La routine principale :

procedure FormuleChimVersCanvas(CanvasCible : TCanvas; Formule : string; X,Y : integer);
  // La SYNTAXE � RESPECTER pour la saisie des string des Formules chimiques avec
  // le code qui suit est toute simple vu qu'elle imite l'�criture manuscrite sans
  // balises-codes dont la pr�sence lors de la saisie fatiguerait les yeux en
  // engandrant des erreurs. En fait, c'est la pr�sence ou l'absence d'espace(s) ' '
  // dans la formule qui joue ici le r�le de balises :
  // - Mettre un espace ' ' devant chaque sous-cha�ne d�butant par un caract�re
  //   alpha-num�rique devant �tre dessin� en taille normale avec la fonte du canvas
  // - Ne pas mettre d'espace ' ' entre la fin d'un symbole alphab�tique et tout
  //   caract�re num�rique devant �tre plac� en indice.
  // - Saisir imm�diatement � la suite et sans espace interpos� autant de '+' ou
  //   de '-' qu'il y a d'ions qui seront affich�s en exposant sous la forme 'n+'
  //   et � la verticale de l'indice s'il y a un indice.
  // - S'il s'agit d'une formule de r�action chimique donc avec l'op�rateur d'addition
  //   Mettre un espace ' ' devant le '+', devant le '===>', et tout commentaire
  //   textuel associ� et qui seront dessin�s en taille normale.
  //   Exemple : Lancer l'appli, et modifier un peu la formule pr�sente dans le TEdit
  //   pour obtenir un aper�u du r�sultat.

// 2)  Proc�dures d'appel de FormuleChimVersCanvas() :

  // 2.a) Pour dessiner la formule sur le canvas d'un TForm ou autre de taille suffisante
  // on peut appeller directement FormuleChimVersCanvas()

  // 2.b) Pour dessiner la formule sur le canvas d'un TLabel :
  procedure FormuleChimVersLabel(Formule : string; LabelCible : tLabel);
  //<--     Ajuste la taille du LabelCible en fonction de celle de la Fonte
  //        de son canvas puis appelle FormuleChimVersCanvas().
  //        ( mais on peut appeller directement FormuleChimVersCanvas si LabelCible
  //        est de taille suffisante par conception)

  // 2.c) Pour dessiner la formule sur le canvas d'un TListBox :
  procedure FormuleChimVersListBox( ListBoxCible: TListBox; Formule : String; Index: Integer;
                                    Coul1,Coul2 : tColor);
  //<--     G�re l'ajout ou le remplacement d'un Item et son dessin dans ListBoxCible
  //        avec couleurs d'arri�re-plan altern�es Coul1/Coul2.
  //        (A appeller dans le code utilisateur suivant l'exemple pr�sent et comment�
  //        dans le code de l'unit� uFormuleChimiqueDemo : voir TForm1.ListBox1DrawItem()

implementation

procedure FormuleChimVersCanvas(CanvasCible : TCanvas; Formule : string; X,Y : integer);
//        - N�cessite d'utiliser une fonte True-Type comme Arial par exemple
//          Type, Taille et couleur de Fonte : � d�clarer dans l'Inspecteur d'objets
//          ou dans la proc�dure d'appel,
//        - Taille du canvas-de-destination : � fixer via l'Inspecteur d'objets
//          ou � pr�-dimensionner dans la proc�dure d'appel
//        - Syntaxe � respecter pour la saisie de la string Formule : voir commentaire introductif.
const     num = ['1'..'9','+','-'];
          sym = [#0..#42,#47,#58..#255]; //< tout sauf +,-. et 0..9
var       cc,cp : Char; // caract : courant, pr�c�dent
          cIons : Char; extr  : shortString;
          w,h,nIons : byte; i,xss,FontSizeN,FontSizeIE,Len,HLig : integer;
begin     FontSizeN :=CanvasCible.Font.Size; // Taille normale
          FontSizeIE:=round(FontSizeN*3/5);  // Taille indice et exposant
          Len:=length(Formule);
          cp:=' '; xss:=0; cIons:=#0; i:=1; extr:='';
          with CanvasCible do
          begin HLig:=TextHeight('H');
                repeat cc:=Formule[i];
                       while (Not (cc in Num)) or ((cc in num) and (cp=' '))
                       and   (i<=Len) do // caract en position et taille normale
                       begin Font.Size:=FontSizeN;
                             TextOut(x, y, cc);
                             w:=TextWidth(cc); x:=x+w; xss:=x; cp:=cc;
                             inc(i); if i>Len then BREAK
                                     else cc:=Formule[i];
                       end;
                       if (cp in sym) then
                       begin while (cc in Num) and (cc<>'+') and (cc<>'-')
                             and   (i<=Len) do // caract�res en indice
                             begin Font.Size:=FontSizeIE;
                                   h:=TextHeight(cc);
                                   TextOut(x, Y + Hlig - h, cc);
                                   w:=TextWidth(cc); x:=x+w; cp:=cc;
                                   inc(i); if i>Len then BREAK
                                           else cc:=Formule[i];
                             end;
                       end else
                       if (cp=' ') or (cp in Num) or (cp in ['.',',']) then
                       begin while (cc in Num) and (cc<>'+') and (cc<>'-')
                             and   (i<=Len) do // caracteres en posit normale pour nombre de KJoules par ex
                             begin Font.Size:=FontSizeN;
                                   h:=TextHeight(cc);
                                   TextOut(x, Y + Hlig - h, cc);
                                   w:=TextWidth(cc); x:=x+w; cp:=cc;
                                   inc(i); if i>Len then BREAK
                                           else cc:=Formule[i];
                             end;
                       end;
                       nIons:=0; // Ions '+' ou '-' comptage
                       while (cp<>' ') and ((cc='+') or (cc='-')) and (i<=Len) do
                       begin cIons:=cc; inc(nIons); Inc(i); cp:=cc;
                             if i<=Len then cc:=Formule[i];
                       end;
                       if nIons>0 then // Ions en exposant
                       begin Font.Size:=FontSizeIE;
                             if nIons=1 then extr:=cIons
                             else extr:=intToStr(nIons)+cIons;
                             TextOut(xss, Y, extr);
                             w:=TextWidth(extr); x:=x+w;
                             if i>Len then BREAK;
                       end;
                until i>=Len;
                Font.Size:=FontSizeN;
          end;
end; // FormuleChimVersCanvas

procedure FormuleChimVersLabel(Formule : string; LabelCible : tLabel);
begin     with LabelCible do // Pr�-dimensionnement du Label
          begin caption:=''; Autosize:=False;
                width:=Canvas.TextWidth(Formule);
                height:=Canvas.TextHeight(']') + 5;
                UpDate;
          end; // Puis trac� de la formule dans le Label :
          FormuleChimVersCanvas(LabelCible.Canvas, Formule, 5, 5 );
end; // FormuleChimVersLabel()

procedure FormuleChimVersListBox( ListBoxCible: TListBox; Formule : String; Index: Integer;
                                  Coul1,Coul2 : tColor);
var       Rect: TRect;
begin     with ListBoxCible do
          begin Style:=(lbOwnerDrawFixed);
                if Odd(Index) then Canvas.Brush.Color:=Coul1  // Couleur d'arri�re plan
                              else Canvas.Brush.Color:=Coul2; // altern�e bleu/blanc
                if Index>Items.count-1 then // Ajout en fin de liste
                begin Items.Add(Formule); Index:=Items.count-1; end else
                begin if Formule='' then Formule:=Items[Index]  // Item inchang�
                                    else Items[index]:=Formule; // Item remplac�
                end;
                Rect:=ItemRect(Index);
                Canvas.FillRect(Rect); // Remplit le rect de l'Index sur canvas avec Brush.color
                // Texte de l'Item
                Formule:=ListBoxCible.Items[Index];
                FormuleChimVersCanvas(ListBoxCible.Canvas, Formule, Rect.Left+3, Rect.Top);
          end;
end; // FormuleChimVersListBox()

End. //=========================================================================
