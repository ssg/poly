{
p01y - taksit takip rutinleri
}

{$I PDEFS}

unit PTaks;

interface

uses

  PHelp,Dos,XOld,GView,XBuf,XStr,XInput,Tools,XGfx,XScroll,XTypes,Drivers,
  Objects;

type

  PTakCollection = ^TTakCollection;
  TTakCollection = object(TSortedCollection)
    procedure FreeItem(item:pointer);virtual;
    function Compare(k1,k2:pointer):integer;virtual;
  end;

  PAyCollection = ^TAyCollection;
  TAyCollection = object(TSortedCollection)
    procedure FreeItem(item:pointer);virtual;
    function Compare(k1,k2:pointer):integer;virtual;
  end;

  PAyLister = ^TAyLister;
  TAyLister = object(TFormattedLister)
    function GetText(item:longint):string;virtual;
    procedure itemDoubleClicked(item:longint);virtual;
  end;

  PAyDialog = ^TAyDialog;
  TAyDialog = object(TDialog)
    constructor Init;
  end;

  PTakDialog = ^TTakDialog;
  TTakDialog = object(TDialog)
    Lister   : PAyLister;
    constructor Init(ahdr:string);
    procedure HandleEvent(var Event:TEvent);virtual;
  end;

  PTakLister = ^TTakLister;
  TTakLister = object(TFormattedLister)
    function GetText(item:longint):string;virtual;
    procedure ItemDoubleClicked(item:longint);virtual;
  end;

  PTakWindow = ^TTakWindow;
  TTakWindow = object(TDialog)
    Lister   : PTakLister;
    constructor Init;
    procedure   HandleEvent(var Event:TEvent);virtual;
  end;

  PAyRec = ^TAyRec;
  TAyRec = record
    Cost  : comp;
    Year  : word;
    Month : byte;
    Day   : byte;
    Paid  : boolean;
  end;

  PTakRec = ^TTakRec;
  TTakRec = record
    Name     : string[40];
    Addr1    : string[40];
    Addr2    : string[40];
    Addr3    : string[40];
    Tel      : string[40];
    Ays      : byte;
    Ay       : array[1..24] of TAyRec;
  end;

procedure TaksitTakipet;

implementation

uses

  Debris,XDev,PTypes;

const

  takList : PTakCollection = NIL;

constructor TAyDialog.Init;
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
  inherited Init(R,'Taksit giriŸi');
  Options := Options or OCf_Centered;
  putinput(5,5,      'BaŸlang‡ tarihi ',2,Stf_Byte,Idc_StrDefault);
  putinput(r.b.x+1,5,'/',2,Stf_Byte,Idc_StrDefault);
  putinput(r.b.x+1,5,'/',4,Stf_Word,Idc_StrDefault);
  putinput(5,r.b.y+5,'Taksit says    ',2,Stf_Byte,Idc_StrDefault);
  putinput(5,r.b.y+5,'Aylk tutar      ',15,Stf_Comp,Idc_NumDefault);
  InsertBlock(GetBlock(5,r.b.y+5,mnfHorizontal,
    NewButton('~Kaydet',cmOk,
    NewButton('~Vazge‡',cmCancel,
    NIL))));
  SelectNext(true);
  FitBounds;
end;

procedure TAyCollection.FreeItem(item:pointer);
begin
  Dispose(PAyRec(item));
end;

function TAyCollection.Compare(k1,k2:pointer):integer;
var
  p1,p2:PAyRec;
begin
  p1 := k1;
  p2 := k2;
  if p1^.Year > p2^.Year then Compare := 1 else
    if p1^.Year < p2^.Year then Compare := -1 else
      if p1^.Month > p2^.Month then Compare := 1 else
        Compare := -1;
end;

function TAyLister.GetText;
var
  P:PAyRec;
begin
  P := itemList^.At(item);
  GetText := z2s(P^.Day,2)+'/'+z2s(P^.Month,2)+'/'+z2s(P^.Year,4)+'|'+cn2b(c2s(P^.Cost))+'|'+GetBool(P^.Paid,'* ™DEND˜ *','');
end;

procedure TAyLister.ItemDoubleClicked;
begin
  Message(Owner,evCommand,cmModify,NIL);
end;

procedure LoadTak;
var
  T:TdosStream;
  P:PTakRec;
begin
  EventWait;
  if takList = NIL then New(takList,Init(20,20))
                   else takList^.FreeAll;
  {$IFNDEF DEMO}
  T.init(wkdir+takFile,stOpenRead);
  if T.Status = stOK then while T.GetPos < T.GetSize do begin
    NEw(P);
    T.Read(P^,SizeOf(TTakRec));
    takList^.Insert(P);
  end;
  T.Done;
  {$ENDIF}
end;

procedure SaveTak;
var
  T:TDosStream;
  n:integer;
  P:PTakRec;
begin
  {$IFNDEF DEMO}
  EventWait;
  if takList = NIL then exit;
  T.Init(wkdir+takFile,stCreate);
  for n:=0 to takList^.Count-1 do begin
    P := takList^.At(n);
    T.Write(P^,SizeOf(TTakRec));
  end;
  T.Done;
  {$ENDIF}
end;

constructor TTakDialog.Init;
var
  R:TRect;
  cfig:word;
  Ps:PScrollBar;
  procedure putinput(aprompt:string);
  var
    Pi:PInputStr;
  begin
    New(Pi,Init(5,r.a.y,30,Fix(aprompt,11),40,cfig));
    Pi^.GetBounds(R);
    r.a.y := r.b.y+5;
    Insert(Pi);
  end;
begin
  R.Assign(0,0,0,0);
  inherited Init(R,ahdr);
  Options := Options or Ocf_Centered;
  r.a.y := 5;
  cfig := Idc_FirstUpper+Idc_StrDefault;
  putinput('Ad Soyad');
  cfig := Idc_StrdEFAULT;
  putinput('Adresi');
  putinput('');
  putinput('');
  putinput('Telefonu');
  New(Lister,Init(5,r.b.y+5,ViewFOnt,10,
    NewColumn('Tarih',84,cofNormal,
    NewColumn('Tutar',120,cofRJust,
    NewColumn('Durumu',80,cofNormal,
    NIL)))));
  Lister^.GetBounds(R);
  r.a.x := r.b.x+2;
  r.b.x := r.a.x+sbButtonSize;
  r.a.y := r.a.y+8;
  New(Ps,Init(R));
  Insert(Ps);
  Lister^.AssignScroller(Ps);
  Insert(Lister);
  InsertBlock(GetBlock(r.b.x+5,r.a.y,mnfVertical+mnfNoSelect,
    NewButton('~Ekle  ',cmAdd,
    NewButton('€ka~r ',cmDel,
    NewButton('~Tahsil',cmModify,
    NIL)))));
  Insert(New(PAccelerator,Init(
    NewAcc(kbIns,cmAdd,
    NewAcc(kbDel,cmDel,
    NIL)))));
  InsertBlock(GetBlock(5,r.b.y+5,mnfHorizontal,
    NewButton('~Kaydet',cmOK,
    NewButton('~Vazge‡',cmCancel,
    NIL))));
  HelpContext := hcTaksitTakibi;
  SelectNext(True);
  FitBounds;
end;

procedure TTakDialog.HandleEvent;
  procedure AddTaks;
  type
    TAyScr = record
      Day        : byte;
      Month      : byte;
      Year       : word;
      Adet       : byte;
      Miktar     : comp;
    end;
  var
    Pd:PAyDialog;
    Pa:PAyCollection;
    P:PAyRec;
    code:word;
    rec:TAyScr;
    y,m,d,dow:word;
  begin
    New(Pd,Init);
    GetDate(y,m,d,dow);
    rec.Day := d;
    rec.Month := m;
    rec.Year  := y;
    rec.Adet  := 1;
    rec.Miktar := 0;
    Pd^.SetData(rec);
    code := GSystem^.ExecView(Pd);
    if code = cmOK then begin
      Pa := PAyCollection(Lister^.ItemList);
      Pd^.GetData(rec);
      y := rec.Year;
      m := rec.Month;
      d := rec.Day;
      for dow := 1 to rec.Adet do begin
        New(P);
        P^.Paid := false;
        P^.Cost := rec.Miktar;
        P^.Month := m;
        P^.Year  := y;
        if d > DaysOfMonths[m] then P^.Day := DaysOfMonths[m]
                               else P^.Day := d;
        inc(m);
        if m > 12 then begin
          m := 1;
          inc(y);
        end;
        Pa^.Insert(P);
      end;
      Lister^.ItemList := NIL;
      Lister^.Update(Pa);
    end;
  end;

  procedure DelTaks;
  begin
    if Lister^.ItemList^.Count = 0 then exit;
    if MessageBox('Se‡miŸ oldu§unuz ayla ilgili taksit bilgisini silmek istedi§inizden emin misiniz?',0,
       mfConfirm+mfYesNo) = cmYes then Lister^.DeleteItem(Lister^.FocusedItem);
  end;

  procedure ModiTaks;
  var
    P:PAyRec;
  begin
    if Lister^.ItemList^.Count=0 then exit;
    P := Lister^.ItemList^.At(Lister^.FocusedItem);
    P^.Paid := not P^.Paid;
    Lister^.PaintView;
  end;

begin
  inherited HandleEvent(Event);
  if Event.What = evCommand then case Event.Command of
    cmAdd : AddTaks;
    cmDel : DelTaks;
    cmModify : ModiTaks;
  end; {Case}
end;

procedure TTakLister.ItemDoubleClicked;
begin
  Message(Owner,evCOmmand,cmModify,NIL);
end;

procedure GetBorcInfo(var rec:TTakRec; var total,thismonth:comp);
var
  b:byte;
  y,m,d,dow:word;
begin
  GetDate(y,m,d,dow);
  total := 0;
  thismonth := 0;
  for b:=1 to rec.Ays do with rec.Ay[b] do if not Paid then begin
    if (Month = m) and (Year = y) then thismonth := thismonth + Cost;
    total := total + Cost;
  end;
end;

function TTakLister.GetText;
var
  P:PTakRec;
  totalborc,monthborc:comp;
begin
  P := itemList^.At(item);
  GetBorcInfo(P^,totalborc,monthborc);
  GetText := P^.Name+'|'+cn2b(c2s(totalborc))+'|'+cn2b(c2s(monthborc));
end;

constructor TTakWindow.Init;
var
  R:TRect;
  Ps:PScrollBar;
begin
  R.Assign(0,0,0,0);
  inherited Init(R,'Taksit takibi');
  Options := Options or Ocf_Centered;
  New(Lister,Init(5,5,ViewFont,20,
    NewColumn('MŸteri',200,cofNormal,
    NewColumn('Toplam bor‡',120,cofRJust,
    NewColumn('Bu ay',120,cofRJust,
    NIL)))));
  Lister^.GetBounds(R);
  r.a.x := r.b.x+2;
  r.b.x := r.a.x+sbButtonSize;
  New(Ps,Init(R));
  Insert(Ps);
  Lister^.AssignScroller(Ps);
  Lister^.SetConfig(Lvc_KeepList,True);
  Lister^.NewList(takList);
  Insert(Lister);
  InsertBlock(GetBlock(5,r.b.y+5,mnfHorizontal+mnfNoSelect,
    NewButton('~Ekle',cmAdd,
    NewButton('~Sil',cmDel,
    NewButton('˜~ncele',cmModify,
    NewButton('~Kapat',cmClose,
    NIL))))));
  Insert(New(PAccelerator,Init(
    NEwAcc(kbIns,cmAdd,
    NewAcc(kbDel,cmDel,
    NIL)))));
  FitBounds;
end;

function GetAyList(var rec:TTakRec):PAyCollection;
var
  Pa:PAyCollection;
  P:PAyRec;
  b:byte;
begin
  New(Pa,Init(10,10));
  for b:=1 to rec.Ays do begin
    New(P);
    P^ := rec.Ay[b];
    Pa^.Insert(P);
  end;
  GetAyList := Pa;
end;

procedure AbsorbAyList(Pa:PAyCollection; var rec:TTakRec);
var
  n:integer;
begin
  rec.Ays := Pa^.Count;
  for n:=0 to Pa^.Count-1 do rec.Ay[n+1] := PAyRec(Pa^.At(n))^;
end;

procedure TTakWindow.HandleEvent;

  function ExecDialog(var rec:TTakRec; ahdr:string):boolean;
  var
    P:PTakDialog;
    code:word;
    Pa:PAyCollection;
  begin
    New(P,Init(ahdr));
    P^.SetData(rec);
    Pa := GetAyList(rec);
    P^.Lister^.NewList(Pa);
    code := GSystem^.ExecView(P);
    if code = cMOK then begin
      P^.GetData(rec);
      AbsorbAyList(Pa,rec);
    end;
    Dispose(P,Done);
    ExecDialog := code = cmOK;
  end;

  procedure AddRec;
  var
    P:PTakRec;
  begin
    New(P);
    ClearBuf(P^,SizeOf(TTakRec));
    if ExecDialog(P^,'Yeni kayt') then begin
      takList^.Insert(P);
      Lister^.Update(takList);
      SaveTak;
    end;
  end;

  procedure DelRec;
  begin
    if takList^.Count > 0 then if MessageBox('Se‡ili kayd silmek istedi§inizden emin misiniz?',0,
      mfConfirm+mfYesNo) = cmYes then begin
      Lister^.DeleteItem(Lister^.FocusedItem);
      Lister^.PaintView;
      SaveTak;
    end;
  end;

  procedure ModifyRec;
  var
    P:PTakRec;
  begin
    if takList^.Count = 0 then exit;
    P := takList^.At(Lister^.FocusedItem);
    ExecDialog(P^,'Kayd incele');
    Lister^.PaintView;
  end;

begin
  if Event.What = evKeyDown then if Event.KeyCode = kbIns then begin
    AddRec;
    ClearEvent(Event);
    exit;
  end;
  inherited HandleEvent(Event);
  case Event.What of
    evCommand : case Event.Command of
                  cmAdd    : AddRec;
                  cmDel    : DelRec;
                  cmModify : ModifyRec;
                  else exit;
                end; {Case}
    else exit;
  end; {case}
  ClearEvent(Event);
end;

function TTakCollection.Compare;
var
  p1,p2:PTakRec;
begin
  p1 := k1;
  p2 := k2;
  if p1^.Name > p2^.Name then Compare := 1 else
    if p1^.Name < p2^.Name then Compare := -1 else
      Compare := 0;
end;

procedure TTakCollection.FreeItem;
begin
  Dispose(PTakRec(item));
end;

procedure TaksitTakipEt;
var
  P:PTakWindow;
begin
  LoadTak;
  New(P,Init);
  GSystem^.ExecView(P);
  SaveTak;
  Dispose(P,Done);
  if takLIst <> NIL then begin
    Dispose(takList,Done);
    takList := NIL;
  end;
end;

end.