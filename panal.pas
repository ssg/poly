{
p01y - e$$egin amIna su kacirma modulu...
}

unit PAnal;

interface

uses

  XOld,XInput,XDev,Dos,XGfx,XTypes,PTaks,PCek,PTypes,PProcs,XStr,Debris,
  XPrn,Drivers,Tools,Objects;

type

  PAnalRec = ^TAnalRec;
  TAnalRec = record
    Description : string[39];
    Gelir,Gider : comp;
  end;

  PAnalColl = ^TAnalColl;
  TAnalColl = object(TCollection)
    procedure FreeItem(item:pointer);virtual;
  end;

  PAnalLister = ^TAnalLister;
  TAnalLister = object(TFormattedLister)
    function GetText(item:longint):string;virtual;
  end;

  PAnalWindow = ^TAnalWindow;
  TAnalWindow = object(TDialog)
    Lister : PAnalLister;
    Getot,Gitot,Toto : PInputNum;
    constructor Init;
    procedure HandleEvent(var Event:TEvent);virtual;
  end;

procedure AnalizBoku;

implementation

constructor TAnalWindow.Init;
var
  R:TRect;
  function putinput(x,y:integer; s:String):PInputNum;
  var
    P:PInputNUm;
  begin
    New(P,Init(x,y,20,s,Stf_Comp,20,0,Idc_NumDefault));
    P^.SetState(scf_Disabled,True);
    P^.GetBounds(R);
    Insert(P);
    putinput := P;
  end;

begin
  R.Assign(0,0,0,0);
  inherited Init(R,'Gelir gider analizi');
  Options := Options or Ocf_Centered;
  New(Lister,Init(5,5,ViewFont,10,
    NewColumn('Aáçklama',244,cofNormal,
    NewColumn('Gelir',124,cofRJust,
    NEwColumn('Gider',124,cofRJust,
    NIL)))));
  Lister^.GetBounds(R);
  Insert(Lister);
  getot := putinput(5,r.b.y+5,'Gelir toplamç                            ');
  gitot := putinput(5,r.b.y+5,'Gider toplamç                            ');
  toto  := putinput(5,r.b.y+5,'Gelir fazlasç                            ');
  InsertBlock(GetBlock(5,r.b.y+5,mnfHorizontal+mnfNoSelect,
    NewButton('~Yazdçr',cmPrint,
    NewButton('~Kapat',cmClose,
    NIL))));
  FitBounds;
end;

procedure TAnalWindow.HandleEvent;
  procedure pRint;
  type
    TBokScr = record
      tgelir : comp;
      tgider : comp;
      t      : comp;
    end;
  var
    scr:TBokScr;
    n:integer;
    P:PAnalRec;
  begin
    if Lister^.ItemList^.Count = 0 then exit;
    EventWait;
    BeginPrint;
    GetData(scr);
    WritePrn(keycode+' GELiR GiDER ANALiZi');
    WritePrn('');
    for n:=0 to Lister^.ItemList^.Count-1 do begin
      P := Lister^.ItemList^.At(n);
      WritePrn(Fix(P^.Description,30)+' '+RFix(cn2b(c2s(P^.Gelir)),15)+' '+RFix(cn2b(c2s(P^.Gider)),15));
    end;
    WritePrn('');
    WritePrn(Fix('Gelir toplamç',46)+' '+RFix(cn2b(c2s(scr.tgelir)),15));
    WritePrn(Fix('Gider toplamç',46)+' '+RFix(cn2b(c2s(scr.tgider)),15));
    WritePrn(Fix('Gelir farkç',46)+' '+RFix(cn2b(c2s(scr.t)),15));
    EndPrint;
  end;
begin
  inherited HandleEvent(Event);
  if Event.What = evCommand then if Event.Command = cmPrint then pRint;
end;

function TAnalLister.GetText;
var
  P:PAnalRec;
begin
  P := ItemList^.At(item);
  GetText := P^.Description+'|'+cn2b(c2s(P^.Gelir))+'|'+cn2b(c2s(P^.Gider));
end;

procedure TAnalColl.FreeItem;
begin
  Dispose(PAnalRec(item));
end;

procedure AnalizBoku;
var
  T:TDosStream;
  takrec:TTakrec;
  cekrec: TCekRec;
  dt:DateTime;
  Pd:PAnalWindow;
  Pc:PAnalColl;
  takGelir : comp;
  cekGider,cekGelir : comp;
  day,month,year,code:word;
  b:byte;
  procedure AddInfo(s:string; ge,gi:comp);
  var
    P:PAnalRec;
  begin
    New(P);
    P^.Description := s;
    P^.Gelir       := ge;
    P^.Gider       := gi;
    Pc^.Insert(P);
  end;
begin
  EventWait;
  StartPerc('Taksit kayçtlarç inceleniyor');
  GetDate(year,month,day,code);
  New(Pc,Init(10,10));
  takgelir := 0;
  cekGelir := 0;
  cekGider := 0;
  T.Init(wkdir+takFile,stOpenRead);
  if T.Status = stOK then while T.GetPos < T.GetSize do begin
    UpdatePerc(T.GetPos,T.GetSize);
    T.Read(takrec,SizeOf(takrec));
    for b:=1 to takrec.Ays do if (takrec.Ay[b].Year = Year) and
                                 (takrec.Ay[b].Month = Month) then begin
      takGelir := takGelir + takrec.ay[b].Cost;
    end;
  end;
  T.Done;
  AddInfo('Taksitler',takGelir,0);
  UpdatePercText('ôdenecek áek kayçtlarç inceleniyor');
  T.Init(wkdir+vcekFile,stOpenRead);
  if T.Status = stOK then while T.getPos < T.getSize do begin
    UpdatePerc(T.GetPos,T.GetSize);
    T.Read(cekrec,SizeOf(cekrec));
    UnpackTime(cekrec.Date,dt);
    if (dt.year = year) and (dt.month = month) then cekGider := cekGider + cekrec.Amount;
  end;
  T.Done;
  AddInfo('ôdenecek áekler',0,cekGider);
  UpdatePercText('Tahsil edilecek áekler');
  T.Init(wkdir+acekFile,stOpenRead);
  if T.Status = stOK then while T.GetPos < T.GetSize do begin
    UpdatePerc(T.GetPos,T.GetSize);
    T.Read(cekrec,SizeOf(cekrec));
    UnpackTime(cekrec.Date,dt);
    if (dt.year = year) and (dt.month = month) then cekGelir := cekGelir + cekrec.Amount;
  end;
  T.Done;
  AddInfo('Tahsil edilecek áekler',0,cekGelir);
  New(Pd,init);
  cekGelir := cekGelir + takGelir;
  Pd^.Getot^.SetData(cekGelir);
  Pd^.GiTot^.SetData(cekGider);
  cekGider := cekGelir-cekGider;
  Pd^.Toto^.SetData(cekGider);
  DonePerc;
  Pd^.Lister^.NEwList(Pc);
  GSystem^.ExecView(Pd);
  Dispose(Pd,Done);
end;

end.