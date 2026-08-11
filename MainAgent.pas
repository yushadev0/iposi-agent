unit MainAgent;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    PopupMenu1: TPopupMenu;
    TrayIcon1: TTrayIcon;
    Durum1: TMenuItem;
    Durum2: TMenuItem;
    procedure Durum2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Durum2Click(Sender: TObject);
begin
  Application.Terminate;
end;

end.
