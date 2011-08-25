{
p01y - Cek takip modulu...
}

{$I PDEFS}

unit PCek;

interface

uses

  PTypes,PKey,

  GView,XOld,XInput,XSys,Dos,Drivers,XTypes,XGfx,XStr,Debris,Tools,XDev,
  XPrn,Objects;

type

  PCekRec = ^TCekRec;
  TCekRec = record
    Bank     : string[39];
    Name     : string[39];
    CekNo    : string[39];
    Date     : longint;
    Amount   : comp;
  end;

  PCekColl = ^TCekColl;
  TCekColl = object(TSortedCollection)
    function Compare(k1,k2:pointer):integer;virtual;
    procedure FreeItem(item:pointer);virtual;
  end;

  PCekLister = ^TCekLister;
  TCekLister = object(TFormattedLister)
    function GetText(item:longint):string;virtual;
  end;

  PCekDialog = ^TCekDialog;
  TCekDialog = object(TDialog)
    constructor Init(ahdr:string);
  end;

  PCekWindow = ^TCekWindow;
  TCekWindow = object(TDialog)
    vLister,aLister : PCekLister;
    constructor Init;
    procedure HandleEvent(var Event:TEvent);virtual;
  end;

procedure CektakipEt;

implementation

procedure TCekColl.FreeItem;
begin
  Dispose(PCekRec(item));
end;

function TCekColl.Compare;
var
  p1,p2:PCekRec;
begin
  p1 := k1;
  p2 := k2;
  if CompareMoment(p1^.Date,p2^.Date) >=0 then Compare := 1 else Compare := -1;
end;

const

  vCekList : PCekColl = NIL;
  aCekList : PCekColl = NIL;

procedure ReadCek(fn:String; Pc:PCekColl);
var
  T:TDosStream;
  P:PCekRec;
begin
  Pc^.FreeAll;
  T.Init(fn,stOpenRead);
  if T.Status = stOK then begin
    while T.GetPos < T.GetSize do begin
      New(P);
      T.Read(P^,SizeOf(TCekRec));
      Pc^.Insert(P);
    end;
  end;
  T.Done;
end;

procedure LoadCek;
begin
  EventWait;
  if vCekList = NIL then New(vCekList,Init(10,10));
  if aCekList = NIL then New(aCekList,Init(10,10));
  ReadCek(wkdir+vcekFile,vCekList);
  ReadCek(wkdir+acekFile,aCekList);
end;

procedure WriteCek(fn:string; Pc:PCekCOll);
var
  T:TDosStream;
  P:PCekRec;
  n:integer;
begin
  {$IFNDEF DEMO}
  T.Init(fn,stCreate);
  if Pc <> NIL then for n := 0 to Pc^.Count-1 do begin
    P := Pc^.At(n);
    T.Write(P^,SizeOf(TCekRec));
  end;
  T.Done;
  {$ENDIF}
end;

procedure SaveCek;
begin
  EventWait;
  WriteCek(wkdir+vCekFile,vCekList);
  WriteCek(wkdir+aCekFile,aCekList);
end;

function TCekLister.GetText;
var
  P:PCekRec;
begin
  P := itemList^.At(item);
  GetText := Date2Str(P^.Date,true)+'|'+P^.Name+'|'+P^.CekNo+'|'+P^.Bank+'|'+cn2b(c2s(P^.Amount));
end;

constructor TCekWindow.Init;
var
  R:TRect;
  s:string;
  procedure putlabel(s:string);
  var
    P:PLabel;
  begin
    New(P,Init(r.a.x,r.a.y,s,ViewFont));
    P^.GetBounds(R);
    Insert(P);
  end;
  function putlister(x,y:integer; alist:PCekColl):PCekLister;
  var
    P:PCekLister;
  begin
    New(P,Init(x,y,ViewFont,15,
      NewColumn('Tarih',90,cofNormal,
      NewColumn('òsim',150,cofNormal,
      NewColumn('Äek no',120,cofNormal,
      NewColumn('Banka',120,cofNormal,
      NewColumn('Tutar',120,cofRJust,
      NIL)))))));
    P^.SetConfig(Lvc_KeepList,True);
    P^.NewList(vCekList);
    PutListerScroller(P,@Self);
    P^.GetBounds(R);
    Insert(P);
    putlister := P;
  end;
begin
  R.Assign(0,0,0,0);
  inherited Init(R,'Cek takibi');
  Options := Options or OCf_Centered;
  r.a.x := 5;
  r.a.y := 5;
  putlabel('Verilen cekler');
  vLister := putlister(5,r.b.y+5,vCekList);
  s := GetBlock(5,r.b.y+5,mnfHorizontal+mnfNoSelect,
    NewButton('Ek~le',cmVAdd,
    NewButton('S~il',cmVDel,
    NewButton('Y~azdçr',cmVPrint,
    NIL))));
  GetBlockBounds(s,R);
  InsertBlock(s);
  r.a.x := 5;
  r.a.y := r.b.y+5;
  putlabel('Alinan cekler');
  aLister := putlister(5,r.b.y+5,aCekList);
  InsertBlock(GetBlock(5,r.b.y+5,mnfHorizontal+mnfNoSelect,
    NewButton('~Ekle',cmAAdd,
    NewButton('~Sil',cmADel,
    NewButton('~Yazdçr',cmPrint,
    NewButton('~Kapat',cmClose,
    NIL))))));
  Insert(New(Paccelerator,Init(
    NewAcc(kbIns,cmAdd,
    NewAcc(kbDel,cmDel,
    NIL)))));
  FitBounds;
end;

procedure TCekWindow.HandleEvent;
type
  TCekScr = record
    Cekno : string[39];
    Bank  : string[39];
    Name  : string[39];
    day : string[2];
    month : string[2];
    year : string[4];
    Amount : comp;
  end;
  procedure VAdddddddd;
  var
    rec:TCekScr;
    T:DateTime;
    Pd:PCekDialog;
    P:PCekRec;
    l:longint;
    code:word;
  begin
    New(Pd,Init('Yeni "verilmi$ cek" kaydi'));
    code := GSystem^.ExecView(Pd);
    if code = cMOK then begin
      EventWait;
      Pd^.GetData(rec);
      New(P);
      P^.Name := rec.Name;
      P^.Amount := rec.Amount;
      P^.Bank   := rec.Bank;
      P^.Cekno  := rec.Cekno;
      T.Year := s2l(rec.year);
      T.Month := s2l(rec.month);
      T.Day   := s2l(rec.Day);
      T.Hour  := 2;
      T.Min   := 33;
      T.Sec   := 40;
      PackTime(T,l);
      P^.Date := l;
      vCekList^.Insert(P);
      vLister^.Update(vCekList);
    end;
    Dispose(Pd,Done);
  end;

  procedure VDelllllll;
  begin
    if vCekList = NIL then Error('Delllll','Bu ne curet? Ceklist nIL???');
    if vCekList^.Count = 0 then exit;
    if MessageBox('Seáili kaydç silmek istedißinizden emin misiniz?',0,mfYesNo+mfConfirm) = cmYes then begin
      EventWait;
      vLister^.DeleteItem(vLister^.FocusedItem);
    end;
  end;

  procedure AAdddddddd;
  var
    rec:TCekScr;
    T:DateTime;
    Pd:PCekDialog;
    P:PCekRec;
    l:longint;
    code:word;
  begin
    New(Pd,Init('Yeni "alinmi$ cek" kaydi'));
    code := GSystem^.ExecView(Pd);
    if code = cMOK then begin
      EventWait;
      Pd^.GetData(rec);
      New(P);
      P^.Name := rec.Name;
      P^.Amount := rec.Amount;
      P^.Bank   := rec.Bank;
      P^.Cekno  := rec.Cekno;
      T.Year := s2l(rec.year);
      T.Month := s2l(rec.month);
      T.Day   := s2l(rec.Day);
      T.Hour  := 2;
      T.Min   := 33;
      T.Sec   := 40;
      PackTime(T,l);
      P^.Date := l;
      aCekList^.Insert(P);
      aLister^.Update(aCekList);
    end;
    Dispose(Pd,Done);
  end;

  procedure ADelllllll;
  begin
    if aCekList = NIL then Error('Delllll','Bu ne curet? Ceklist nIL???');
    if aCekList^.Count = 0 then exit;
    if MessageBox('Seáili kaydç silmek istedißinizden emin misiniz?',0,mfYesNo+mfConfirm) = cmYes then begin
      EventWait;
      aLister^.DeleteItem(aLister^.FocusedItem);
    end;
  end;

  procedure VPrint;
  var
    n:integer;
    P:PCekRec;
  begin
    if vCekList^.Count = 0 then exit;
    BeginPrint;
    WritePrn(keycode+' VERòLEN ÄEK LòSTESò');
    WritePrn('');
    for n:=0 to vCekList^.Count-1 do begin
      P := vCekList^.At(n);
      WritePrn(Date2Str(P^.Date,true)+' '+Fix(p^.CekNo,30)+' '+Fix(P^.Name,20)+' '+RFix(cn2b(c2s(P^.Amount)),15));
    end;
    EndPrint;
  end;

  procedure Print;
  var
    n:integer;
    P:PCekRec;
  begin
    EventWait;
    if aCekList^.Count = 0 then exit;
    BeginPrint;
    WritePrn(keycode+' ALINAN ÄEK LòSTESò');
    WritePrn('');
    for n:=0 to aCekList^.Count-1 do begin
      P := aCekList^.At(n);
      WritePrn(Date2Str(P^.Date,true)+' '+Fix(p^.CekNo,30)+' '+Fix(P^.Name,20)+' '+RFix(cn2b(c2s(P^.Amount)),15));
    end;
    EndPrint;
  end;

begin
  inherited HandleEvent(Event);
  if Event.What = evCommand then case Event.Command of
    cmVAdd : VAdddddddd;
    cmVPrint : VPrint;
    cmPrint : Print;
    cmVDel : VDelllllll;
    cmAAdd : AAdddddddd;
    cmADel : ADelllllll;
  end; {case}
end;

constructor TCekDialog.Init;
var
  R:TRect;
  blackPearlJam:integer;
  procedure putinput(x,y:integer; prompt:string; len:byte; config:word);
  var
    Pi:PInputStr;
  begin
    New(Pi,Init(x,y,len,prompt,len,config));
    Pi^.GetBounds(R);
    Insert(Pi);
  end;

  procedure putninput(x,y:integer; prompt:string; numtype,len:byte; config:word);
  var
    Pi:PInputNum;
  begin
    New(Pi,Init(x,y,len,prompt,numtype,len,0,config));
    Pi^.GetBounds(R);
    Insert(Pi);
  end;

begin
  R.Assign(0,0,0,0);
  inherited Init(R,ahdr);
  Options := Options or Ocf_Centered;
  putinput(5,5,       'Äek no        ',39,Idc_StrDefault);
  putinput(5,r.b.y+5, 'Banka adç     ',39,Idc_StrDefault);
  putinput(5,r.b.y+5, 'òsim          ',39,Idc_StrDefault+Idc_FirstUpper);
  blackPearlJam := r.b.y+5;
  putinput(5,blackPearlJam,
                      'Äek tarihi    ',2,Idc_StrDefault);
  putinput(r.b.x+1,blackPearlJam,'/',2,Idc_StrDefault);
  putinput(r.b.x+1,blackPearlJam,'/',4,Idc_StrDefault);
  putninput(5,r.b.y+5,'Tutar         ',Stf_Comp,15,Idc_NumDefault);
  InsertBlock(getBlock(5,r.b.y+5,mnfHorizontal,
    NewButton('~Kaydet',cmOK,
    NewButton('~Vazgeá',cmCancel,
    NIL))));
  SelectNext(True);
  FitBounds;
end;

procedure CekTakipEt;
var
  P:PCekWindow;
begin
  New(P,Init);
  LoadCek;
  P^.vLister^.NewList(vCekList);
  P^.aLister^.NEwLIst(aCekList);
  GSystem^.ExecView(P);
  SaveCek;
  Dispose(P,Done);
  if vCekList <> NIL then begin
    Dispose(vCekList,Done);
    vCekList := NIL;
  end;
  if aCekList <> NIL then begin
    Dispose(aCekList,Done);
    aCekList := NIL;
  end;
end;

end.