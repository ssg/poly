{
p01y - montaj takip modulu...
}

{$I PDEFS}

unit PMont;

interface

uses

  PTypes,

  XInput,XSys,Dos,Drivers,XTypes,XGfx,XStr,Debris,Tools,XDev,Objects;

type

  PMontajRec = ^TMontajRec;
  TMontajRec = record
    Name     : string[40];
    Done     : boolean;
    Date     : longint;
  end;

  PMontajColl = ^TMontajColl;
  TMontajColl = object(TSortedCollection)
    function Compare(k1,k2:pointer):integer;virtual;
    procedure FreeItem(item:pointer);virtual;
  end;

  PMontLister = ^TMontLister;
  TMontLister = object(TFormattedLister)
    function GetText(item:longint):string;virtual;
    procedure ItemDoubleClicked(item:longint);virtual;
  end;

  PMontDialog = ^TMontDialog;
  TMontDialog = object(TDialog)
    constructor Init;
  end;

  PMontWindow = ^TMontWindow;
  TMontWindow = object(TDialog)
    Lister    : PMontLister;
    constructor Init;
    procedure HandleEvent(var Event:TEvent);virtual;
  end;

procedure MontajtakipEt;

implementation

procedure TmontajColl.FreeItem;
begin
  Dispose(PMontajRec(item));
end;

function TMontajColl.Compare;
var
  p1,p2:PMontajRec;
begin
  p1 := k1;
  p2 := k2;
  if CompareMoment(p1^.Date,p2^.Date) >=0 then Compare := -1 else Compare := 1;
end;

const

  montajList : PMontajColl = NIL;

procedure LoadMont;
var
  T:TDosStream;
  P:PMontajRec;
begin
  EventWait;
  if montajList = NIL then New(montajList,Init(10,10)) else montajList^.FreeAll;
  T.Init(wkdir+montFile,stOpenRead);
  if T.Status = stOK then begin
    while T.GetPos < T.GetSize do begin
      New(P);
      T.Read(P^,SizeOf(TMontajRec));
      montajList^.Insert(P);
    end;
  end;
  T.Done;
end;

procedure SaveMont;
var
  T:TDosStream;
  P:PMontajRec;
  n:integer;
begin
  {$IFNDEF DEMO}
  EventWait;
  T.Init(wkdir+montFile,stCreate);
  if montajList <> NIL then for n := 0 to montajList^.Count-1 do begin
    P := montajList^.At(n);
    T.Write(P^,SizeOf(TMontajRec));
  end;
  T.Done;
  {$ENDIF}
end;

function TMontLister.GetText;
var
  P:PMontajRec;
begin
  P := itemList^.At(item);
  GetText := Date2Str(P^.Date,true)+'|'+P^.Name+'|'+GetBool(P^.Done,'* TAMAMLANDI *','');
end;

procedure TMontLister.ItemDoubleClicked;
var
  P:PMontajRec;
begin
  EventWait;
  P := itemList^.At(item);
  P^.Done := not P^.Done;
  PaintView;
end;

constructor TMontWindow.Init;
var
  R:TRect;
begin
  R.Assign(0,0,0,0);
  inherited Init(R,'Montaj takibi');
  Options := Options or OCf_Centered;
  New(Lister,Init(5,5,ViewFont,20,
    NewColumn('Tarih',90,cofNormal,
    NewColumn('òsim',200,cofNormal,
    NewColumn('Durumu',120,cofNormal,
    NIL)))));
  Lister^.SetConfig(Lvc_KeepList,True);
  Lister^.NewList(montajList);
  PutListerScroller(Lister,@Self);
  Lister^.GetBounds(R);
  Insert(Lister);
  InsertBlock(GetBlock(5,r.b.y+5,mnfHorizontal+mnfNoSelect,
    NewButton('~Ekle',cmAdd,
    NewButton('~Sil',cmDel,
    NewButton('~Kapat',cmClose,
    NIL)))));
  Insert(New(Paccelerator,Init(
    NewAcc(kbIns,cmAdd,
    NewAcc(kbDel,cmDel,
    NIL)))));
  FitBounds;
end;

procedure TMontWindow.HandleEvent;
  procedure Adddddddd;
  type
    TMontScr = record
      Name : string[40];
      day : string[2];
      month : string[2];
      year : string[4];
    end;
  var
    rec:TMontScr;
    T:DateTime;
    Pd:PMontDialog;
    P:PMontajRec;
    l:longint;
    code:word;
  begin
    New(Pd,Init);
    code := GSystem^.ExecView(Pd);
    if code = cMOK then begin
      EventWait;
      Pd^.GetData(rec);
      New(P);
      P^.Name := rec.Name;
      T.Year := s2l(rec.year);
      T.Month := s2l(rec.Month);
      T.Day   := s2l(rec.Day);
      T.Hour  := 2;
      T.Min   := 33;
      T.Sec   := 40;
      PackTime(T,l);
      P^.Date := l;
      P^.Done := false;
      montajList^.Insert(P);
      Lister^.Update(montajList);
    end;
    Dispose(Pd,Done);
  end;

  procedure Delllllll;
  begin
    if montajList = NIL then Error('Delllll','Bu ne curet? montajlist nIL???');
    if montaJList^.Count = 0 then exit;
    if MessageBox('Seáili kaydç silmek istedißinizden emin misiniz?',0,mfYesNo+mfConfirm) = cmYes then begin
      EventWait;
      Lister^.DeleteItem(Lister^.FocusedItem);
    end;
  end;

begin
  inherited HandleEvent(Event);
  if Event.What = evCommand then case Event.Command of
    cmAdd : Adddddddd;
    cmDel : Delllllll;
  end; {case}
end;

constructor TMontDialog.Init;
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
begin
  R.Assign(0,0,0,0);
  inherited Init(R,'Yeni montaj kaydç');
  Options := Options or Ocf_Centered;
  putinput(5,5,'òsim          ',40,Idc_StrDefault+Idc_FirstUpper);
  blackPearlJam := r.b.y+5;
  putinput(5,blackPearlJam,      'Montaj tarihi ',2,Idc_StrDefault);
  putinput(r.b.x+1,blackPearlJam,'/',2,Idc_StrDefault);
  putinput(r.b.x+1,blackPearlJam,'/',4,Idc_StrDefault);
  InsertBlock(getBlock(5,r.b.y+5,mnfHorizontal,
    NewButton('~Kaydet',cmOK,
    NewButton('~Vazgec',cmCancel,
    NIL))));
  SelectNext(True);
  FitBounds;
end;

procedure MontajTakipEt;
var
  P:PMontWindow;
begin
  New(P,Init);
  LoadMont;
  P^.Lister^.NewList(montajList);
  GSystem^.ExecView(P);
  SaveMont;
  Dispose(P,Done);
  if montajList <> NIL then begin
    Dispose(montajList,Done);
    montajList := NIL;
  end;
end;

end.