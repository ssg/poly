{
p01y - Firma takip rutinleri...
}

{$I PDEFS}

unit PFirma;

interface

uses

  GView,XIO,XInput,XOld,XDev,Dos,Drivers,PTypes,XGfx,XTypes,Tools,Debris,
  Objects;

type

  PFirmaHdr = ^TFirmaHDr;
  TFirmaHdr = record
    Name      : string[39];
  end;

  PFirmaRec = ^TFirmaRec;
  TFirmaRec = record
    Name     : string[39];
    Filename : string[12];
  end;

  PTransRec = ^TTransRec;
  TTransRec = record
    Name       : string[39];
    Unitname   : string[9];
    Qty        : comp;
    Unitprice  : comp;
    Totalprice : comp;
  end;

  PFirmCollection = ^TFirmCollection;
  TFirmCollection = object(TSortedCollection)
    procedure FreeItem(item:pointer);virtual;
    function Compare(k1,k2:pointer):integer;virtual;
  end;

  PTransRecColl = ^TTransRecColl;
  TTransRecColl = object(TCollection)
    procedure FreeItem(item:pointer);virtual;
  end;

  PPayment = ^TPayment;
  TPayment = record
    Description : string[39];
    Amount      : comp;
  end;

  PPaymentColl = ^TPaymentColl;
  TPaymentColl = object(TCollection)
    procedure FreeItem(item:pointer);virtual;
  end;

  PPaymentLister = ^TPaymentLister;
  TPaymentLister = object(TFormattedLister)
    function GetText(item:longint):string;virtual;
  end;

  PTransaction = ^TTransaction;
  TTransaction = record
    Description : string[39];
    Date        : longint;
    NumRecs     : longint;
    NumPayments : longint;
    Payments    : PPaymentColl;
    Items       : PTransRecColl;
  end;

  PTransactionColl = ^TTransactionCOll;
  TTransactionColl = object(TSortedCollection)
    procedure FreeItem(item:pointer);virtual;
    function  Compare(k1,k2:pointer):integer;virtual;
  end;

  PFirmaLister = ^TFirmaLister;
  TFirmaLister = object(TListViewer)
    function  Gettext(item:longint):string;virtual;
    procedure ItemDoubleClicked(item:longint);virtual;
  end;

  PFirmaWindow = ^TFirmaWindow;
  TFirmaWindow = object(TDialog)
    Lister : PFirmaLister;
    constructor Init;
    procedure   HandleEvent(var Event:TEvent);virtual;
  end;

  PFirmAddDialog = ^TFirmAddDialog;
  TFirmAddDialog = object(TDialog)
    constructor Init;
  end;

  PTransactionLister = ^TTransactionLister;
  TTransactionLister = object(TFormattedLister)
    function  GetText(item:longint):string;virtual;
    procedure ItemFocused(item:longint);virtual;
  end;

  PTransRecLister = ^TTransRecLister;
  TTransRecLister = object(TFormattedLister)
    constructor Init(x,y,arows:byte);
    function    GetText(item:longint):string;virtual;
  end;

  PTransactionDialog = ^TTransactionDialog;
  TTransactionDialog = object(TDialog)
    Lister    : PTransactionLister;
    RecLister : PTransRecLister;
    PayLister : PPaymentLister;
    constructor Init;
    procedure   HandleEvent(var Event:TEvent);virtual;
  end;

  PTransAddDialog = ^TTransAddDialog;
  TTransAddDialog = object(TDialog)
    Lister    : PTransRecLister;
    PayLister : PPaymentLister;
    constructor Init;
    procedure   HandleEvent(var Event:TEvent);virtual;
  end;

  PPaymentAddDialog = ^TPaymentAddDialog;
  TPaymentAddDialog = object(TDialog)
    constructor Init;
  end;

  PTransRecAddDialog = ^TTransRecAddDialog;
  TTransRecAddDialog = object(TDialog)
    minput,binput,tinput : PInputNum;
    constructor Init;
    procedure HandleEvent(var Event:TEvent);virtual;
  end;

const

  firmList : PFirmCollection = NIL;
  transList : PTransactionColl = NIL;

  activeFirm : PFirmaRec = NIL;
  firmExt : string[4] = '.PFR';

procedure FirmaTakipet;

implementation

type

  TTransScr = record
    Name       : string[30];
    Unitname   : string[9];
    Qty        : comp;
    Unitprice  : comp;
    Totalprice : comp;
  end;

constructor TTransRecAddDialog.Init;
var
  R:TRect;
  procedure putinput(x,y:integer; s:string; len:byte);
  var
    P:PInputStr;
  begin
    NEw(P,Init(x,y,len,s,len,Idc_StrDefault));
    P^.GetBounds(R);
    Insert(P);
  end;
  function putninput(x,y:integer; s:string; len:byte):PInputNum;
  var
    P:PInputNum;
  begin
    New(P,Init(x,y,len,s,Stf_Comp,len,0,Idc_NumDefault));
    P^.GetBounds(R);
    Insert(P);
    putninput := P;
  end;
begin
  R.Assign(0,0,0,0);
  inherited Init(R,'Yeni');
  Options := Options or Ocf_Centered;
  putinput (5,5,      'Malçn adç   ',30);
  putinput (5,r.b.y+5,'Birim adç   ',9);
  minput := putninput(5,r.b.y+5,'Miktar      ',15);
  binput := putninput(5,r.b.y+5,'Birim fiat  ',15);
  tinput := putninput(5,r.b.y+5,'Toplam fiat ',15);
  InsertBlock(GetBlock(5,r.b.y+5,mnfHorizontal,
    NewButton('~Kaydet',cmOK,
    NewButton('~Vazgeá',cmCancel,
    NIL))));
  SelectNext(true);
  FitBounds;
end;

procedure TTransRecAddDialog.HandleEvent;
var
  scr: TTransScr;
begin
  inherited handleEvent(Event);
  if Event.What = evBroadcast then if Event.Command = cmInputlineChanged then
    if (Event.InfoPtr = binput) or (Event.InfoPtr = minput) then begin
      GetData(scr);
      scr.Totalprice := scr.Qty*scr.Unitprice;
      tinput^.setData(scr.TotalPrice);
      tinput^.PaintView;
      ClearEvent(Event);
    end;
end;

constructor TpaymentAddDialog.Init;
var
  R:TRect;
  procedure putinput(x,y:integer; s:string; len:byte);
  var
    P:PInputStr;
  begin
    NEw(P,Init(x,y,len,s,len,Idc_StrDefault));
    P^.GetBounds(R);
    Insert(P);
  end;
  procedure putninput(x,y:integer; s:string; len:byte);
  var
    P:PInputNum;
  begin
    New(P,Init(x,y,len,s,Stf_Comp,len,0,Idc_NumDefault));
    P^.GetBounds(R);
    Insert(P);
  end;
begin
  R.Assign(0,0,0,0);
  inherited Init(R,'Ekle');
  Options := Options or Ocf_Centered;
  putinput (5,5,      'Aáçklama ',30);
  putninput(5,r.b.y+5,'Miktar   ',15);
  InsertBlock(GetBlock(5,r.b.y+5,mnfHorizontal,
    NewButton('~Kaydet',cmOK,
    NewButton('~Vazgeá',cmCancel,
    NIL))));
  SelectNext(true);
  FitBounds;
end;

function TPaymentLister.GetText;
var
  P:PPayment;
begin
  P := ItemList^.At(item);
  GetText := P^.Description + '|'+ cn2b(c2s(P^.Amount));
end;

procedure TpaymentColl.FreeItem;
begin
  Dispose(PPayment(item));
end;

constructor TTransAddDialog.Init;
var
  R:TRect;
  rhinocort:string;
  procedure putinput(x,y:integer; s:String; len:byte);
  var
    Pi:PInputStr;
  begin
    New(Pi,Init(x,y,len,s,len,Idc_StrDefault));
    Pi^.GetBounds(R);
    Insert(Pi);
  end;
  procedure putlabel(x,y:integer; s:string);
  var
    Pl:PLabel;
  begin
    New(Pl,Init(x,y,s,ViewFont));
    Pl^.GetBounds(R);
    Insert(Pl);
  end;
begin
  R.Assign(0,0,0,0);
  inherited Init(R,'Yeni');
  Options := Options or Ocf_Centered;
  putinput(5,5,'Aáçklama',39);
  Putlabel(5,r.b.y+5,'Sipariü listesi');
  New(Lister,Init(5,r.b.y+5,10));
  Lister^.SetConfig(Lvc_KeepList,True);
  Lister^.GetBounds(R);
  Insert(Lister);
  Lister^.NEwList(New(PTransRecColl,Init(10,10)));
  rhinocort := GetBlock(5,r.b.y+5,mnfHorizontal+mnfNoSelect,
    NewButton('Ek~le',cmAdd,
    NewButton('S~il',cmDel,
    NIL)));
  GetBlockBounds(rhinocort,R);
  InsertBlock(rhinocort);
  putlabel(5,r.b.y+5,'ôdeme planç');
  New(payLister,Init(5,r.b.y+5,ViewFont,10,
    NewColumn('Aáçklama',240,cofNormal,
    NewColumn('Tutar',124,cofRJust,
    NIL))));
  payLister^.SetConfig(Lvc_KeepList,True);
  PayLister^.GetBounds(R);
  Insert(payLister);
  payLister^.NewList(New(PPaymentColl,Init(10,10)));
  InsertBlock(GetBlock(5,r.b.y+5,mnfHorizontal+mnfNoSelect,
    newButton('~Ekle',cmVAdd,
    NewButton('~Sil',cmVDel,
    NewButton('~Kaydet',cmOK,
    NewButton('~Vazgec',cmCancel,
    NIL))))));
  SelectNext(True);
  FitBounds;
end;

procedure TTransAddDialog.HandleEvent;
  procedure addit;
  var
    P:PTransRecAddDialog;
    pc:PCollection;
    Pr:PTransRec;
    rec:TTransScr;
    code:word;
  begin
    New(P,Init);
    code := GSystem^.ExecView(P);
    if code = cmOK then begin
      P^.GetData(rec);
      New(Pr);
      Pr^.Name := rec.Name;
      Pr^.Unitname := rec.Unitname;
      Pr^.Qty := rec.Qty;
      Pr^.Unitprice := rec.Unitprice;
      Pr^.TotalPrice := rec.Totalprice;
      Pc := Lister^.ItemList;
      Pc^.Insert(Pr);
      Lister^.ItemList := NIL;
      Lister^.Update(Pc);
    end;
    Dispose(P,Done);
  end;

  procedure delit;
  begin
    if Lister^.ItemList^.Count = 0 then exit;
    if MessageBox('Emin misiniz?',0,mfYesNo) = cmYes then begin
      Lister^.DeleteItem(Lister^.FocusedItem);
    end;
  end;

  procedure vaddit;
  type
    TPaymentScr = record
      Description : string[30];
      Amount : comp;
    end;
  var
    P:PPaymentAddDialog;
    Pc:PCollection;
    Pr:PPayment;
    rec:TPaymentScr;
    code:word;
  begin
    New(P,Init);
    code := GSystem^.ExecView(P);
    if code = cmOK then begin
      P^.GetData(rec);
      New(Pr);
      Pr^.Description := rec.Description;
      Pr^.Amount      := rec.Amount;
      Pc := PayLister^.ItemList;
      Pc^.Insert(Pr);
      PayLister^.ItemList := NIL;
      PayLister^.Update(Pc);
    end;
    Dispose(P,Done);
  end;

  procedure vdelit;
  begin
    if PayLister^.ItemList^.Count = 0 then exit;
    if MessageBox('Emin misiniz?',0,mfYesNo) = cmYes then begin
      PayLister^.DeleteItem(PayLister^.FocusedItem);
    end;
  end;
begin
  inherited HandleEvent(Event);
  if Event.What = evCommand then case Event.Command of
    cmAdd : Addit;
    cmDel :  Delit;
    cmVAdd : VAddit;
    cmVDel : Vdelit;
  end; {Case}
end;

function TTransactionLister.GetText;
var
  P:PTransaction;
begin
  P := ItemList^.At(Item);
  GetText := P^.Description+'|'+Date2Str(P^.Date,true);
end;

constructor TTransactionDialog.Init;
var
  R:TRect;
begin
  R.Assign(0,0,0,0);
  inherited Init(R,activeFirm^.Name);
  Options := Options or Ocf_Centered;
  New(Lister,Init(5,5,ViewFont,10,
    NewColumn('Aáçklama',200,cofNormal,
    NewColumn('Tarih',84,cofNormal,
    NIL))));
  Lister^.SetConfig(Lvc_KeepList,True);
  Lister^.GetBounds(R);
  Insert(Lister);
  New(PayLister,Init(r.b.x+5,r.a.y,ViewFont,10,
    NewColumn('Aáçklama',180,cofNormal,
    NewColumn('Tutar',124,cofRJust,
    NIL))));
  PayLister^.SetConfig(Lvc_KeepList,True);
  PayLister^.GetBounds(R);
  Insert(PayLister);
  InsertBlock(GetBlock(5,r.b.y+5,mnfHorizontal+mnfNoSelect,
    NewButton('~Ekle',cmAdd,
    NewButton('~Sil',cmDel,
    NIL))));
  New(RecLister,Init(5,r.b.y+50,10));
  RecLister^.SetCOnfig(Lvc_KeepList,True);
  RecLister^.GetBounds(R);
  Insert(RecLister);
  InsertBlock(GetBlock(5,r.b.y+5,mnfHorizontal+mnfNoSelect,
    NewButton('~Kapat',cmClose,NIL)));
  SelectNext(True);
  FitBounds;
end;

procedure TTransactionDialog.HandleEvent;
  procedure AddTransaction;
  var
    Pd:PTransAddDialog;
    P:PTransaction;
    code:word;
  begin
    New(Pd,Init);
    code := GSystem^.ExecView(Pd);
    if code = cmOK then begin
      New(P);
      Pd^.GetData(P^);
      P^.Date := GetSysMoment;
      P^.Payments := PPaymentColl(Pd^.PayLister^.ItemList);
      P^.Items    := PTransRecColl(Pd^.Lister^.ItemList);
      P^.NumRecs := P^.Items^.Count;
      P^.NumPayments := P^.Payments^.Count;
      transList^.Insert(P);
      Lister^.Update(transList);
    end;
    Dispose(Pd,Done);
  end;

  procedure DelTransaction;
  begin
    if transList^.Count = 0 then exit;
    if messageBox('Emin misiniz?',0,mfYesNo) = cmYes then begin
      Lister^.DeleteItem(lister^.FocusedItem);
      if transList^.Count = 0 then begin
        RecLister^.Update(NIL);
        PayLister^.Update(NIL);
      end;
    end;
  end;

var
  P:PTransaction;
begin
  inherited HandleEvent(Event);
  if Event.What = evCommand then case Event.Command of
    cmEbeninAMI : begin
      EventWait;
      P := Lister^.ItemList^.At(Lister^.FocusedItem);
      RecLister^.Update(P^.Items);
      payLister^.Update(P^.Payments);
    end;
    cmAdd : AddTransaction;
    cmDel : DelTransaction;
  end; {Case}
end;

procedure SaveTransList;
var
  T:TDosStream;
  h:TFirmaHdr;
  P:PTransaction;
  Pr:PTransRec;
  Pp : PPayment;
  n,n1:longint;
begin
  EventWait;
  T.Init(wkdir+activeFirm^.Filename,stOpenRead);
  T.Read(h,SizeOf(h));
  T.Done;
  T.Init(wkdir+activeFirm^.Filename,stCreate);
  T.Write(h,SizeOf(h));
  for n:=0 to transList^.Count-1 do begin
    P := transList^.At(n);
    P^.NumRecs := P^.Items^.Count;
    P^.NumPayments := P^.Payments^.Count;
    T.Write(P^,SizeOf(P^));
    for n1:=0 to P^.Items^.Count-1 do begin
      Pr := P^.Items^.At(n1);
      T.Write(Pr^,SizeOf(Pr^));
    end;
    for n1 := 0 to P^.Payments^.Count-1 do begin
      Pp := P^.Payments^.At(n1);
      T.Write(Pp^,SizeOf(Pp^));
    end;
  end;
  T.Done;
end;

procedure LoadTransList;
var
  T:TDosStream;
  h:TFirmaHdr;
  P:PTransaction;
  Pt:PTransRec;
  Pp : PPayment;
  n:longint;
begin
  if transList = NIL then New(transList,Init(10,10)) else transList^.FreeAll;
  StartPerc('Firma iülemleri yÅkleniyor');
  T.Init(wkdir+activeFirm^.Filename,stOpenRead);
  T.Read(h,SizeOf(h));
  if T.Status = stOK then while T.GetPos < T.GetSize do begin
    UpdatePerc(T.GetPos,T.GetSize);
    New(P);
    T.Read(P^,SizeOf(P^));
    New(P^.Items,Init(10,10));
    New(P^.Payments,Init(10,10));
    for n:=1 to P^.NumRecs do begin
      New(Pt);
      T.Read(Pt^,SizeOf(pt^));
      P^.Items^.Insert(Pt);
    end;
    for n:=1 to P^.NumPayments do begin
      New(Pp);
      T.Read(Pp^,SizeOf(Pp^));
      P^.Payments^.Insert(Pp);
    end;
    transList^.Insert(P);
  end;
  T.Done;
  DonePerc;
end;

constructor TFirmAddDialog.Init;
var
  R:TRect;
  procedure putinput(s:string; len:byte; config:word);
  var
    P:PInputStr;
  begin
    New(P,Init(r.a.x,r.a.y,len,s,len,config));
    P^.GetBounds(R);
    Insert(P);
    r.a.y := r.b.y+5;
  end;
begin
  R.Assign(0,0,0,0);
  inherited Init(R,'Yeni firma');
  Options := Options or Ocf_Centered;
  r.a.x := 5;
  r.a.y := 5;
  putinput('Firma adç ',39,Idc_StrDefault);
  putinput('Firma kodu',8,Idc_UpperStr);
  InsertBlock(GetBlock(5,r.a.y,mnfHorizontal,
    NewButton('~Kaydet',cmOK,
    NewButton('~Vazgec',cmCancel,
    NIL))));
  FitBounds;
  SelectNext(true);
end;

constructor TFirmaWindow.Init;
var
  R:TRect;
  procedure putlabel(s:string);
  var
    P:PLabel;
  begin
    New(P,Init(r.a.x,r.a.y,s,ViewFont));
    P^.GetBounds(R);
    Insert(P);
  end;
begin
  R.Assign(0,0,0,0);
  inherited Init(R,'Firma listesi');
  Options := Options or Ocf_Centered;
  r.a.x := 5;
  r.a.y := 5;
  putlabel('Firma listesi');
  R.Assign(5,r.b.y+5,320,200);
  New(Lister,Init(R,ViewFont));
  Lister^.SetConfig(Lvc_KeepList,True);
  Lister^.GetBounds(R);
  Insert(Lister);
  InsertBlock(getBlock(5,r.b.y+5,mnfHorizontal+mnfNoSelect,
    NewButton('~Ekle',cmAdd,
    NewButton('~Sil',cmDel,
    NewButton('~Incele',cmOpen,
    NewButton('~Kapat',cmClose,
    NIL))))));
  Insert(New(PAccelerator,Init(
    NewAcc(kbIns,cmAdd,
    NewAcc(kbDel,cmDel,
    NIL)))));
  FitBounds;
end;

procedure LoadFirmList;
var
  T:TDosStream;
  h:TFirmaHdr;
  P:PFirmaRec;
  dirinfo:SearchRec;
begin
  EventWait;
  if firmList = NIL then New(firmList,Init(10,10)) else firmList^.FreeAll;
  FindFirst(wkdir+'*'+firmExt,Archive,dirinfo);
  while DosError = 0 do begin
    New(P);
    P^.Filename := dirinfo.name;
    T.Init(wkdir+dirinfo.name,stOpenRead);
    if T.Status = stOK then T.Read(h,SizeOf(h)) else begin
      T.Done;
      Dispose(P);
      FindNExt(dirinfo);
      Continue;
    end;
    T.Done;
    P^.Name := h.Name;
    firmList^.Insert(P);
    FindNext(dirinfo);
  end;
end;

procedure TFirmaWindow.HandleEvent;
  procedure UpdateFirmList;
  begin
    LoadFirmList;
    Lister^.Update(firmList);
  end;

  procedure AddFirm;
  var
    Pd:PFirmAddDialog;
    code:word;
    rec:TFirmaRec;
    h:TFirmaHdr;
    T:TDosStream;
  begin
    New(Pd,Init);
    code := GSystem^.ExecView(Pd);
    if code = cmOK then begin
      Pd^.GetData(rec);
      T.Init(wkdir+rec.Filename+'.pfr',stCreate);
      h.Name := rec.Name;
      if T.Status = stOK then T.Write(h,SizeOf(h));
      T.Done;
      UpdateFirmList;
    end;
    Dispose(pd,Done);
  end;

  procedure DelFirm;
  var
    P:PFirmaRec;
  begin
    if firmList^.Count = 0 then exit;
    P := firmList^.At(Lister^.FocusedItem);
    if MessageBox('Seáili firmayç silmek istedißinizden emin misiniz?',0,mfYesNo+mfCOnfirm) = cmYes then begin
      XDeleteFile(wkdir+P^.Filename);
      UpdateFirmList;
    end;
  end;

  procedure OpenFirm;
  var
    P:PFirmaRec;
    Pd:PTransactionDialog;
  begin
    if firmList^.Count = 0 then exit;
    P := firmList^.At(Lister^.FocusedItem);
    activeFirm := P;
    LoadTransList;
    New(Pd,Init);
    Pd^.Lister^.NewList(transList);
    GSystem^.ExecView(Pd);
    SaveTransList;
    if transList <> NIL then begin
      Dispose(transList,Done);
      transList := NIL;
    end;
  end;

begin
  inherited HandleEvent(Event);
  if Event.What = evCommand then case Event.Command of
    cmAdd : AddFirm;
    cmDel : DelFirm;
    cmOpen : OpenFirm;
  end; {case}
end;

function TFirmaLister.GetText;
begin
  GetText := PFirmaRec(ItemList^.At(item))^.Name;
end;

procedure TFirmaLister.ItemDoubleClicked;
begin
  Message(Owner,evCommand,cmOpen,NIL);
end;

procedure TTransRecColl.FreeItem;
begin
  Dispose(PTransRec(item));
end;

procedure TTransactionColl.FreeItem;
begin
  Dispose(PTransaction(item)^.Items,Done);
  Dispose(PTransaction(item)^.Payments,Done);
  Dispose(PTransaction(item));
end;

function TTransactionColl.Compare;
var
  p1,p2:PTransaction;
begin
  p1 := k1;
  p2 := k2;
  if CompareMoment(p1^.Date,p2^.Date) > 0 then Compare := 1 else Compare := -1;
end;

procedure TFirmCollection.FreeItem;
begin
  Dispose(PFirmaRec(item));
end;

function TFirmCollection.Compare;
var
  p1,p2:PFirmaRec;
begin
  p1 := k1;
  p2 := k2;
  if p1^.Name > p2^.Name then Compare := 1 else Compare := -1;
end;

procedure FirmaTakipet;
var
  Pd:PFirmaWindow;
begin
  LoadFirmList;
  New(Pd,Init);
  Pd^.Lister^.NewList(firmList);
  GSystem^.ExecView(Pd);
  Dispose(Pd,Done);
  if firmList <> NIL then begin
    Dispose(firmList,Done);
    firmList := NIL;
  end;
end;

constructor TTransRecLister.Init;
begin
  inherited Init(x,y,ViewFont,arows,
    NewColumn('Adç',214,cofNormal,
    NewColumn('Miktar',50,cofRJust,
    NewColumn('Birim',76,cofNormal,
    NewColumn('Birim fiatç',120,cofRJust,
    NewColumn('Toplam fiat',120,cofRJust,
    NIL))))));
  SetConfig(Lvc_KeepList,True);
end;

function TTransRecLister.GetText;
var
  P:PTransRec;
begin
  P := ItemList^.At(Item);
  GetText := P^.Name+'|'+c2s(P^.Qty)+'|'+P^.Unitname+'|'+cn2b(c2s(P^.Unitprice))+'|'+cn2b(c2s(P^.Totalprice));
end;

procedure TTransactionLister.ItemFocused;
begin
  Message(Owner,evCommand,cmEbeninAMI,NIL);
end;

end.