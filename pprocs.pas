{
poly - procedures
}

{$I PDEFS}

unit PProcs;

interface

function  KeyPressed:boolean;
procedure SaveSetup;
procedure LoadISP;
procedure SaveISP;

implementation

uses

  XDev,Objects,PTypes,Drivers,XKey;

procedure LoadISP;
var
  T:TDosStream;
  P:PISpanyolet;
  w:word;
begin
  if ispList = NIL then New(ispList,Init(10,10));
  ispList^.FreeAll;
  T.Init(wkdir+ispFile,stOpenRead);
  if T.Status = stOK then begin
    T.Read(w,SizeOf(w));
    while w > 0 do begin
      New(P);
      T.Read(P^,SizeOf(TISpanyolet));
      ispList^.Insert(P);
      dec(w);
    end;
  end;
  T.Done;
end;

procedure SaveISP;
var
  T:TDosStream;
  i:integer;
  w:word;
begin
  {$IFNDEF DEMO}
  T.Init(wkdir+ispFile,stCreate);
  w := ispList^.Count;
  T.Write(w,SizeOf(w));
  for i:=0 to ispList^.Count-1 do T.Write(PIspanyolet(ispList^.At(i))^,SizeOf(TIspanyolet));
  T.Done;
  {$ENDIF}
end;

procedure SaveSetup;
var
  T:TDosStream;
begin
  {$IFNDEF DEMO}
  EventWait;
  T.Init(wkdir+setupFile,stCreate);
  T.Write(setup,SizeOf(setup));
  T.Done;
  SaveISP;
  {$ENDIF}
end;

function KeyPressed;
var
  Event:TEvent;
begin
  GetExtendedKeyEvent(Event);
  KeyPressed := Event.What <> evNothing;
end;

end.