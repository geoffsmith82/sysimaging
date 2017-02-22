program unattendhostname;

{$APPTYPE CONSOLE}

{$R *.res}

uses System.SysUtils,XMLDoc, XMLIntf,xmldom, ActiveX;

procedure ProcessComponent(component : IXMLNode;computerName:String);
var
  k : Integer;
begin
  if(component.Attributes['name']='Microsoft-Windows-Shell-Setup') then
    begin
      for k := 0 to component.ChildNodes.Count-1 do
        begin
          if(component.ChildNodes[k].NodeName='ComputerName') then
            begin
              component.ChildNodes[k].NodeValue := ComputerName;
            end;
        end;
    end;
end;

procedure ProcessSettings(settings: IXMLNode;computerName:String);
var
  j : Integer;
  component : IXMLNode;
begin
  for j := 0 to settings.ChildNodes.Count-1 do
    begin
      component := settings.ChildNodes[j];
      Writeln(component.NodeName);
      ProcessComponent(component,computername);
    end;
end;


var
  Doc          : IXMLDocument;
  i            : Integer;
  unattend     : IXMLNodeList;
  computerName : String;
  unattendxml  : String;
  settings     : IXMLNode;
begin
  if(ParamCount<>2) then
    begin
      Writeln(Extractfilename(paramStr(0))+' unattend.xml ComputerName');
      Exit;
    end;

  UnattendXML  := ParamStr(1);
  computerName := ParamStr(2);
  if(not FileExists(unattendxml)) then
    begin
      Writeln('unattend.xml doesn''t exist');
      Exit;
    end;

  Writeln('Setting Computer Name To: ' + computerName);
  Writeln('Unattend.xml location: '+ unattendxml);
  CoInitialize(nil);
  Doc := TXMLDocument.Create(nil);
  try
    Doc.LoadFromFile(unattendxml);
    Doc.Active := True;
    unattend := doc.Node.ChildNodes;
    for i := 0 to unattend.Count-1 do
      begin
        Writeln(unattend.Nodes[1].ChildNodes.Nodes[i].NodeName);
        settings := unattend.Nodes[1].ChildNodes.Nodes[i];
        processSettings(settings,computerName);
      end;
      doc.SavetoFile(unattendxml);
    { TODO -oUser -cConsole Main : Insert code here }
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
