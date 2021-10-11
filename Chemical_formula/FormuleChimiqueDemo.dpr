program FormuleChimiqueDemo;

uses
  Forms,
  uFormuleChimiqueDemo in 'uFormuleChimiqueDemo.pas' {Form1},
  unitFormuleChimique in 'unitFormuleChimique.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
