unit UnitFormuleChimique;

//******************************************************************************
// Dessiner une Formule chimique dans une ListBox ou dans n'importe quel Canvas.
// (avec avec indices et exposants ... mais sans avoir à utiliser des balises).
//******************************************************************************


interface

uses Graphics, StdCtrls, SysUtils, Windows;

// 1) La routine principale :

procedure FormuleChimVersCanvas(CanvasCible : TCanvas; Formule : string; X,Y : integer);
  // La SYNTAXE à RESPECTER pour la saisie des string des Formules chimiques avec
  // le code qui suit est toute simple vu qu'elle imite l'écriture manuscrite sans
  // balises-codes dont la présence lors de la saisie fatiguerait les yeux en
  // engandrant des erreurs. En fait, c'est la présence ou l'absence d'espace(s) ' '
  // dans la formule qui joue ici le rôle de balises :
  // - Mettre un espace ' ' devant chaque sous-chaîne débutant par un caractère
  //   alpha-numérique devant être dessiné en taille normale avec la fonte du canvas
  // - Ne pas mettre d'espace ' ' entre la fin d'un symbole alphabétique et tout
  //   caractère numérique devant être placé en indice.
  // - Saisir immédiatement à la suite et sans espace interposé autant de '+' ou
  //   de '-' qu'il y a d'ions qui seront affichés en exposant sous la forme 'n+'
  //   et à la verticale de l'indice s'il y a un indice.
  // - S'il s'agit d'une formule de réaction chimique donc avec l'opérateur d'addition
  //   Mettre un espace ' ' devant le '+', devant le '===>', et tout commentaire
  //   textuel associé et qui seront dessinés en taille normale.
  //   Exemple : Lancer l'appli, et modifier un peu la formule présente dans le TEdit
  //   pour obtenir un aperçu du résultat.

// 2)  Procédures d'appel de FormuleChimVersCanvas() :

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
  //<--     Gère l'ajout ou le remplacement d'un Item et son dessin dans ListBoxCible
  //        avec couleurs d'arrière-plan alternées Coul1/Coul2.
  //        (A appeller dans le code utilisateur suivant l'exemple présent et commenté
  //        dans le code de l'unité uFormuleChimiqueDemo : voir TForm1.ListBox1DrawItem()

implementation

procedure FormuleChimVersCanvas(CanvasCible : TCanvas; Formule : string; X,Y : integer);
//        - Nécessite d'utiliser une fonte True-Type comme Arial par exemple
//          Type, Taille et couleur de Fonte : à déclarer dans l'Inspecteur d'objets
//          ou dans la procédure d'appel,
//        - Taille du canvas-de-destination : à fixer via l'Inspecteur d'objets
//          ou à pré-dimensionner dans la procédure d'appel
//        - Syntaxe à respecter pour la saisie de la string Formule : voir commentaire introductif.
const     num = ['1'..'9','+','-'];
          sym = [#0..#42,#47,#58..#255]; //< tout sauf +,-. et 0..9
var       cc,cp : Char; // caract : courant, précédent
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
                             and   (i<=Len) do // caractères en indice
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
begin     with LabelCible do // Pré-dimensionnement du Label
          begin caption:=''; Autosize:=False;
                width:=Canvas.TextWidth(Formule);
                height:=Canvas.TextHeight(']') + 5;
                UpDate;
          end; // Puis tracé de la formule dans le Label :
          FormuleChimVersCanvas(LabelCible.Canvas, Formule, 5, 5 );
end; // FormuleChimVersLabel()

procedure FormuleChimVersListBox( ListBoxCible: TListBox; Formule : String; Index: Integer;
                                  Coul1,Coul2 : tColor);
var       Rect: TRect;
begin     with ListBoxCible do
          begin Style:=(lbOwnerDrawFixed);
                if Odd(Index) then Canvas.Brush.Color:=Coul1  // Couleur d'arrière plan
                              else Canvas.Brush.Color:=Coul2; // alternée bleu/blanc
                if Index>Items.count-1 then // Ajout en fin de liste
                begin Items.Add(Formule); Index:=Items.count-1; end else
                begin if Formule='' then Formule:=Items[Index]  // Item inchangé
                                    else Items[index]:=Formule; // Item remplacé
                end;
                Rect:=ItemRect(Index);
                Canvas.FillRect(Rect); // Remplit le rect de l'Index sur canvas avec Brush.color
                // Texte de l'Item
                Formule:=ListBoxCible.Items[Index];
                FormuleChimVersCanvas(ListBoxCible.Canvas, Formule, Rect.Left+3, Rect.Top);
          end;
end; // FormuleChimVersListBox()

End. //=========================================================================
