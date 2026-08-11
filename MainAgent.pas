unit MainAgent;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ExtCtrls,
  System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent,
  IdBaseComponent, IdComponent, IdCustomTCPServer, IdCustomHTTPServer,
  IdHTTPServer, IdContext, ShellAPI;

type
  TForm1 = class(TForm)
    PopupMenu1: TPopupMenu;
    TrayIcon1: TTrayIcon;
    mnuOpenIposi: TMenuItem;
    Durum2: TMenuItem;
    IdHTTPServer1: TIdHTTPServer;
    NetHTTPClient1: TNetHTTPClient;
    mnuStatus: TMenuItem;
    N1: TMenuItem;
    mnuQuit: TMenuItem;
    procedure IdHTTPServer1CommandGet(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure mnuQuitClick(Sender: TObject);
    procedure mnuOpenIposiClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.IdHTTPServer1CommandGet(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin
  AResponseInfo.CustomHeaders.AddValue('Access-Control-Allow-Origin', '*');
  AResponseInfo.CustomHeaders.AddValue('Access-Control-Allow-Methods',
    'GET, POST, PUT, PATCH, DELETE, OPTIONS');
  AResponseInfo.CustomHeaders.AddValue('Access-Control-Allow-Headers', '*');

  if ARequestInfo.Command = 'OPTIONS' then
  begin
    AResponseInfo.ResponseNo := 200;
    AResponseInfo.ContentText := 'OK';
    Exit;
  end;

  // 3. IposiAgent Ayakta mı Testi (Ping)
  if ARequestInfo.Document = '/ping' then
  begin
    AResponseInfo.ResponseNo := 200;
    AResponseInfo.ContentType := 'application/json';
    AResponseInfo.ContentText :=
      '{"status": "running", "agent": "IposiAgent v1.0"}';
    Exit;
  end;

  // Iposi, hedef URL'yi özel bir Header içinde (örn: X-Iposi-Target-URL) gönderecek
  var
    TargetURL: string := ARequestInfo.Params.Values['target'];

  if TargetURL <> '' then
  begin
    var
    HttpClient := TNetHTTPClient.Create(nil);
    var
    ReqBody := TStringStream.Create('', TEncoding.UTF8);
    try
      // İstek gövdesini (POST, PUT vb. verilerini) oku
      if Assigned(ARequestInfo.PostStream) then
        ReqBody.CopyFrom(ARequestInfo.PostStream, 0);

      var
        Response: IHTTPResponse;
      var
        Method: string := UpperCase(ARequestInfo.Command);

      try
        if Method = 'GET' then
          Response := HttpClient.Get(TargetURL)
        else if Method = 'POST' then
          Response := HttpClient.Post(TargetURL, ReqBody)
        else if Method = 'PUT' then
          Response := HttpClient.Put(TargetURL, ReqBody)
        else if Method = 'DELETE' then
          Response := HttpClient.Delete(TargetURL)
        else if Method = 'PATCH' then
          Response := HttpClient.Patch(TargetURL, ReqBody);

        if Assigned(Response) then
        begin
          AResponseInfo.ResponseNo := Response.StatusCode;

          // YENİ: Gelen yanıtın formatını (JSON/HTML/XML) Iposi'ye aynen iletiyoruz
          AResponseInfo.ContentType := Response.HeaderValue['Content-Type'];

          AResponseInfo.ContentText := Response.ContentAsString(TEncoding.UTF8);
        end;
      except
        on E: Exception do
        begin
          AResponseInfo.ResponseNo := 500;
          AResponseInfo.ContentType := 'application/json';
          AResponseInfo.ContentText := '{"agent_error": "' +
            E.Message.Replace('"', '\"') + '"}';
        end;
      end;

    finally
      HttpClient.Free;
      ReqBody.Free;
    end;
    Exit;
  end
  else if (ARequestInfo.Document <> '/ping') then
  begin
    // Eğer bir hedef URL yoksa ve ping atılmıyorsa Indy'nin varsayılan HTML'ini ez ve bizi uyar!
    AResponseInfo.ResponseNo := 400;
    AResponseInfo.ContentType := 'application/json';
    AResponseInfo.ContentText := '{"error": "Agent received no Target URL!"}';
    Exit;
  end;
end;

procedure TForm1.mnuOpenIposiClick(Sender: TObject);
begin
  ShellExecute(0, 'open', 'https://hasup.net/iposi', nil, nil, SW_SHOWNORMAL);
end;

procedure TForm1.mnuQuitClick(Sender: TObject);
begin
  Application.Terminate;
end;

end.
