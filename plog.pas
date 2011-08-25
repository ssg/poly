{
p01y - Log tracking routines..
}

unit PLog;

interface

uses

  XInput,XTypes,XGFx,Drivers,GView,XStr,XScroll,PCalc,XDev,Tools,Dos,
  PHelp,XOld,Objects,PTypes;

type

  PLogCollection = ^TLogCollection;
  TLogCollection = object(TSortedCollection)
    procedure FreeItem(item:pointer);virtual;
    function Compare(k1,k2:pointer):integer;virtual;
  end;

  PLogLister = ^TLogLister;
  TLogLister = object(TFormattedLister)
    function GetText(item:longint):string;virtual;
    procedure ItemFocused(item:longint);virtual;
  end;

  PLogDialog = ^TLogDialog;
  TLogDialog = object(TDialog)
    TotalLister : PMeasureLister;
    TotalInput  : PInputNum;
    LogLister   : PLogLister;
    LogDetail   : PMeasureLister;
    constructor Init;
    destructor  Done;virtual;
    procedure   HandleEvent(var Event:TEvent);virtual;
    procedure   NewDate(year:word; month:byte);
    procedure   UpdateDetail;
  end;

  PDateChangeDialog = ^TDateChangeDialog;
  TDateChangeDialog = object(TDialog)
    constructor Init;
  end;

const

  LogList : PLogCollection = NIL;

procedure OpenLog;

implementation

constructor TDateChangeDialog.Init;
var
  R:TRect;
  procedure putinput(x,y:integer; prompt:string; len:byte; numtype,config:word);
  var
    Pi:PInputNum;
  begin
    New(Pi,Init(x,y,len,prompt,numtype,len,0,config));
    Pi^.GetBounds(R);
    Insert(Pi);
  end;
begin
  R.Assign(0,0,0,0);
  inherited Init(R,'Yeni tarih');
  Options := Options or Ocf_Centered;
  putinput(5,5,'Tarih ',2,Stf_Byte,Idc_StrDefault);
  putinput(r.b.x+2,5,'/',4,Stf_Word,Idc_StrDefault);
  InsertBlock(GetBlock(5,r.b.y+5,mnfHorizontal,
    NewButton('~Tamam',cmOK,
    NewButton('~Vazgeá',cmCancel,
    NIL))));
  SelectNext(True);
  FitBounds;
end;

function TLogLister.GetText;
var
  P:PLogRec;
begin
  P := itemList^.At(item);
  GetText := P^.What+'|'+z2s(P^.Day,2)+'/'+z2s(P^.Month,2)+'/'+z2s(P^.Year,4);
end;

procedure TLogLister.ItemFocused;
begin
  Message(Owner,evCommand,cmUpdateLogDetail,nil);
end;

procedure ReadLogList(y:word; m:byte);
var
  T:TDosStream;
  P:PLOgRec;
  rec:TLogRec;
begin
  EventWait;
  if LogList = NIL then new(LogList,Init(20,20));
  LogList^.FreeAll;
  T.Init(wkdir+logFile,stOpenRead);
  StartPerc('Kayçtlar yÅkleniyor');
  if T.Status = stOK then while T.GetPos < T.GetSize do begin
    T.Read(rec,SizeOf(rec));
    if (rec.Year = y) and (rec.Month = m) then begin
      New(P);
      Move(rec,P^,SizeOf(TLogRec));
      P^.Offs := T.GetPos;
      LogList^.Insert(P);
    end;
    T.Seek(T.GetPos+(rec.NumEntries*SizeOf(TMeasure)));
    UpdatePerc(T.GetPos,T.GetSize);
  end;
  T.Done;
  DonePerc;
end;

procedure TLogDialog.UpdateDetail;
var
  P:PLogRec;
  Detail:PMeasureCollection;
  n:integer;
  l:longint;
  Pm:PMeasure;
  T:TDosStream;
begin
  EventWait;
  New(Detail,Init(20,20));
  if LogList^.Count > 0 then begin
    P := LogLister^.ItemList^.At(LogLister^.FocusedItem);
    T.Init(wkdir+logFile,stOpenRead);
    if T.Status = stOK then begin
      T.Seek(P^.Offs);
      for l:=1 to P^.NumEntries do begin
        New(Pm);
        T.Read(Pm^,SizeOf(TMeasure));
        Detail^.Insert(Pm);
      end;
    end;
    T.Done;
  end;
  LogDetail^.Update(Detail);
end;

procedure TLogDialog.HandleEvent;
  procedure ChangeDate;
  type
    TDateScr = record
      Month : byte;
      Year  : word;
    end;
  var
    Pd:PDateChangeDialog;
    scr:TDateScr;
    code:word;
    y,m,d,dow:word;
  begin
    New(Pd,Init);
    GetDate(y,m,d,dow);
    scr.Year := y;
    scr.Month := m;
    Pd^.SetData(scr);
    code := GSystem^.ExecView(pd);
    if code = cmOK then begin
      Pd^.GetData(scr);
      NewDate(scr.Year,scr.Month);
    end;
    Dispose(Pd,Done);
  end;
begin
  inherited HandleEvent(Event);
  if Event.What = evCommand then case Event.Command of
    cmUpdateLogDetail : UpdateDetail;
    cmChange : ChangeDate;
  end;
end;

procedure TLogDialog.NewDate;
var
  totalList:PMeasureCollection;
  rec:TMeasure;
  Pl:PLogRec;
  T:TDosStream;
  n:integer;
  l:longint;
  bigtotal:comp;
  procedure AddTotal;
  var
    subloop:integer;
    Pm:PMeasure;
  begin
    bigtotal := bigtotal + rec.Price;
    for subloop := 0 to totalList^.Count-1 do begin
      Pm := totalList^.At(subloop);
      if SameMeasure(Pm,@rec) then begin
        Pm^.Qty := Pm^.Qty + rec.Qty;
        Pm^.Price := Pm^.Price + rec.Price;
        exit;
      end;
    end;
    New(Pm);
    Move(rec,Pm^,SizeOf(TMeasure));
    totalList^.Insert(Pm);
  end;
begin
  EventWait;
  bigtotal := 0;
  ReadLogList(year,month);
  New(totalList,Init(20,20));
  T.Init(wkdir+logFile,stOpenRead);
  if T.Status = stOK then for n:=0 to logList^.Count-1 do begin
    Pl := logList^.At(n);
    T.Seek(Pl^.Offs);
    for l:=1 to Pl^.NumEntries do begin
      T.Read(rec,SizeOf(rec));
      AddTotal;
    end;
  end;
  T.Done;
  logLister^.Update(logList);
  totalLister^.Update(totalList);
  totalInput^.SetData(bigtotal);
  UpdateDetail;
end;

constructor TLogDialog.Init;
var
  R:TRect;
  procedure putlabel(s:string);
  var
    Pl:PLabel;
  begin
    New(Pl,Init(100,r.a.y,s,ViewFont));
    Pl^.GetBounds(R);
    Insert(Pl);
    r.a.y := r.b.y+5;
  end;
begin
  R.Assign(0,0,0,0);
  inherited Init(R,'Kayçtlç iülemler');
  Options := Options or Ocf_Centered;
  r.a.y := 5;
  putlabel('Aylçk toplam');
  New(TotalLister,Init(5,r.a.y,ViewFont,15,
    NewColumn('Paráa',120,cofNormal,
    NewColumn('ôláÅ',144,cofRJust,
    NewColumn('Adet',40,cofRjust,
    NewCOlumn('Tutar',120,cofRJust,
    NIL))))));
  putListerScroller(totalLister,@Self);
  TotalLister^.GetBounds(R);
  Insert(TotalLister);
  InsertBlock(GetBlock(r.b.x+sbButtonSize+7,r.a.y,mnfVertical,
    NewButton('Tarihi ~deßiütir',cmChange,
    NewButton('~Kapat          ',cmOK,
    NIL))));
  NEw(totalInput,Init(216,r.b.y+5,20,'Toplam',Stf_Comp,20,0,Idc_NumDefault));
  totalInput^.SetState(Scf_Disabled,True);
  totalInput^.GetBounds(R);
  Insert(totalInput);
  r.a.y := r.b.y+5;
  putlabel('Detaylç rapor');
  New(LogLister,Init(5,r.a.y,ViewFont,15,
    NewColumn('Aáçklama',152,cofNormal,
    NewColumn('Tarih',85,cofNormal,
    NIL))));
  putListerScroller(LogLister,@Self);
  LogLister^.GetBounds(R);
  LogLister^.SetConfig(Lvc_KeepList,True);
  Insert(LogLister);
  New(LogDetail,Init(r.b.x+7+sbButtonSize,r.a.y,ViewFont,15,
    NewColumn('Paráa',120,cofNormal,
    NewColumn('ôláÅ',144,cofRJust,
    NewColumn('Adet',40,cofRjust,
    NIL)))));
  putListerScroller(logDetail,@Self);
  logDetail^.GetBounds(R);
  Insert(logDetail);
  HelpContext := hcKayitliIslemler;
  SelectNExt(True);
  FitBounds;
end;

destructor TLogDialog.Done;
begin
  Dispose(LogList,Done);
  LogList := NIL;
  inherited Done;
end;

procedure TLogCollection.FreeItem;
begin
  Dispose(PLogRec(item));
end;

function TLogCollection.Compare;
var
  p1,p2:PLogRec;
begin
  p1 := k1;
  p2 := k2;
  if p1^.Year > p2^.Year then Compare := 1 else
    if p1^.Year < p2^.Year then Compare := -1 else
      if p1^.Month > p2^.Month then Compare := 1 else
        if p1^.Month < p2^.Month then Compare := -1 else
          if p1^.Day > p2^.Day then Compare := 1 else Compare := -1;
end;

procedure OpenLog;
var
  Pd:PLogDialog;
  y,m,d,dow:word;
  code:word;
begin
  New(Pd,Init);
  GetDate(y,m,d,dow);
  Pd^.NewDate(y,m);
  code := GSystem^.ExecView(pd);
  Dispose(Pd,Done);
end;

end.