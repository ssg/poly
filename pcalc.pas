{
p01y - Modelling and calculation
}

unit PCalc;

interface

uses

  XScroll,XInput,Tools,XGfx,GView,Debris,XTypes,XPrn,XStr,XSys,PTypes,
  PHelp,Dos,PTaks,Drivers,XOld,Objects;

type

  PBasicWindow = ^TBasicWindow;
  TBasicWindow = object(TObject)
    rw          : PCompArray;
    clone       : PCompArray;
    LoadPtr     : pointer;
    rn          : byte;
    Kind        : char;
    xsize,ysize : byte;
    index       : integer;
    kasaWidth   : comp;
    kasaHeight  : comp;
    kasaThick   : comp;
    superKasa   : boolean;
    region1     : byte;
    constructor Init;
    destructor  Done;virtual;
    procedure Load(var T:TStream);virtual;
    procedure Store(var T:TStream);virtual;
    procedure ResetVars;
    procedure Draw;virtual;
    procedure ReadData;virtual;
    procedure InitKesimHesabi;
    procedure KesimHesabi;virtual;
    procedure DoneKesimHesabi;
    procedure InitMusteriHesabi;
    procedure MusteriHesabi;virtual;
    procedure DoneMusteriHesabi;
    function  GetRegionList:PRegion;virtual;

    procedure OutModel;virtual;
    procedure OutRegions;
    procedure mOut(x,y:byte; s:string);
    procedure FlushModel;
    procedure PrintModel;

    procedure AskGen(ask:byte; regn:byte);
    procedure InitWidths(regn:byte);
    procedure DoneWidths;
    procedure AdjustWidths(kesim:boolean);
    procedure AddMeasure(measuretype:TMeasureType; PVC:boolean; what:string; qty,x1,x2,price:comp);
    procedure AddMusteriCam(height:comp);
    procedure AddMusteriLambri(width,height:comp);
    procedure CalcMusteriPenc(width,height:comp);
    procedure FinalizeMusteri;
    procedure CalcOut(penc:byte; width,height:comp);
    procedure CalcOutKasa;
    procedure CalcOutCam(width,height:comp);
    procedure CalcOutLambri(width,height:comp);
    procedure CalcOutKayit(qty,length:comp);
    procedure CalcOutKapi(width,height:comp);
    procedure CalcOutPVC(qty,length:comp; what:string);
  end;

  PEmptyWindow = ^TEmptyWindow;
  TEmptyWindow = object(TBasicWindow)
    constructor Init;
    function  GetRegionList:PRegion;virtual;
  end;

  PTuranjWIndow = ^TTuranjWindow;
  TTuranjWindow = object(TEmptyWIndow)
    region2     : byte;
    okGAP       : comp;
    procedure Load(var T:TStream);virtual;
    procedure Store(var T:TStream);virtual;
    procedure Draw;virtual;
    function GetRegionList:PRegion;virtual;
    procedure ReadData;virtual;
    procedure KesimHesabi;virtual;
    procedure MusteriHesabi;virtual;
  end;

  PCiftAcilir = ^TCiftAcilir;
  TCiftAcilir = object(TBasicWindow)
    procedure Draw;virtual;
    procedure KesimHesabi;virtual;
    procedure MusteriHesabi;virtual;
  end;

  PLambri = ^TLambri;
  TLambri = object(TBasicWindow)
    procedure Draw;virtual;
    procedure MusteriHesabi;virtual;
    procedure KesimHesabi;virtual;
  end;

  PSWingWindow = ^TSWingWindow;
  TSWingWindow = object(TBasicWIndow)
    FirstGAP   : comp;
    constructor Init;
    procedure Load(var T:TStream);virtual;
    procedure Store(var T:TStream);virtual;
    procedure Draw;virtual;
    function  GetRegionList:PRegion;virtual;
    procedure OutModel;virtual;
    procedure ReadData;virtual;
    procedure KesimHesabi;virtual;
    procedure MusteriHesabi;virtual;
  end;

  PDWingWIndow = ^TDWingWIndow;
  TDWingWindow = object(TBasicWindow)
    region2,region3 : byte;
    procedure Load(var T:TStream);virtual;
    procedure Store(var T:TStream);virtual;
    constructor Init;
    function    GetRegionList:PRegion;virtual;
    procedure OutModel;virtual;
    procedure Draw;virtual;
    procedure ReadData;virtual;
    procedure KesimHesabi;virtual;
    procedure MusteriHesabi;virtual;
  end;

  PFruko = ^TFruko;
  TFruko = object(TDWingWindow)
    region4,region5,region6: byte;
    firstHeight:comp;
    procedure Load(var T:TStream);virtual;
    procedure Store(var T:TStream);virtual;
    function GetRegionList:PRegion;virtual;
    procedure Draw;virtual;
    procedure ReadData;virtual;
    procedure KesimHesabi;virtual;
    procedure MusteriHesabi;virtual;
  end;

  PHQuadWindow = ^THQuadWindow;
  THQuadWindow = object(TDWingWindow)
    okGAP : comp;
    procedure Load(var T:TStream);virtual;
    procedure Store(var T:TStream);virtual;
    procedure OutModel;virtual;
    function  GetRegionList:PRegion;virtual;
    procedure Draw;virtual;
    procedure ReadData;virtual;
    procedure KesimHesabi;virtual;
    procedure MusteriHesabi;virtual;
  end;

  PHReverseWindow = ^THReverseWindow;
  THReverseWindow = object(THQuadWindow)
    region4,region5:byte;
    procedure Load(var T:TStream);virtual;
    procedure Store(var T:TStream);virtual;
    procedure Draw;virtual;
    function    GetRegionList:PRegion;virtual;
    procedure ReadData;virtual;
    procedure KesimHesabi;virtual;
    procedure MusteriHesabi;virtual;
  end;

  PQCrossWindow = ^TQCrossWIndow;
  TQCrossWindow = object(TBasicWIndow)
    FirstGAP    : comp;
    okGAP       : comp;
    region2 : byte;
    procedure Load(var T:TStream);virtual;
    procedure Store(var T:TStream);virtual;
    function    GetRegionList:PRegion;virtual;
    procedure OutModel;virtual;
    procedure Draw;virtual;
    procedure ReadData;virtual;
    procedure KesimHesabi;virtual;
    procedure MusteriHesabi;virtual;
  end;

  PHexWindow = ^THexWindow;
  THexWindow = object(THReverseWindow)
    region6:byte;
    procedure Load(var T:TStream);virtual;
    procedure Store(var T:TStream);virtual;
    function  GetRegionList:PRegion;virtual;
    procedure Draw;virtual;
    procedure ReadData;virtual;
    procedure KesimHesabi;virtual;
    procedure MusteriHesabi;virtual;
  end;

  PQSliceWindow = ^TQSliceWindow;
  TQSliceWindow = object(THexWindow)
    region7,region8:byte;
    procedure Load(var T:TStream);virtual;
    procedure Store(var T:TStream);virtual;
    constructor Init;
    function    GetRegionList:PRegion;virtual;
    procedure Draw;virtual;
    procedure ReadData;virtual;
    procedure KesimHesabi;virtual;
    procedure MusteriHesabi;virtual;
  end;

  PDortluWindow = ^TDortluWindow;
  TDortluWindow = object(TBasicWindow)
    region2,region3,region4:byte;
    procedure Load(var T:TStream);virtual;
    procedure Store(var T:TStream);virtual;
    constructor Init;
    function    GetRegionList:PRegion;virtual;
    procedure   Draw;virtual;
    procedure   ReadData;virtual;
    procedure   KesimHesabi;virtual;
    procedure   MusteriHesabi;virtual;
  end;

  PBesliWindow = ^TBesliWindow;
  TBesliWindow = object(TDortluWindow)
    region5 : byte;
    procedure Load(var T:TStream);virtual;
    procedure Store(var T:TStream);virtual;
    constructor Init;
    function    GetRegionList:PRegion;virtual;
    procedure   Draw;virtual;
    procedure   ReadData;virtual;
    procedure   KesimHesabi;virtual;
    procedure   MusteriHesabi;virtual;
  end;

  PSCamDoor = ^TSCamDoor;
  TSCamDoor = object(TBasicWindow)
    LamHeight : comp;
    kapiKanadi : byte;
    procedure Load(var T:TStream);virtual;
    procedure Store(var T:TStream);virtual;
    constructor Init;
    procedure OutModel;virtual;
    procedure Draw;virtual;
    procedure ReadData;virtual;
    procedure MusteriHesabi;virtual;
    procedure KesimHesabi;virtual;
  end;

  PCamDoor = ^TCamDoor;
  TCamDoor = object(TBasicWindow)
    constructor Init;
    procedure Draw;virtual;
    procedure MusteriHesabi;virtual;
    procedure KesimHesabi;virtual;
  end;

  PSUstDoor = ^TSUstDoor;
  TSUstDoor = object(TSCamDoor)
    okGAP   : comp;
    procedure Load(var T:TStream);virtual;
    procedure Store(var T:TStream);virtual;
    procedure OutModel;virtual;
    procedure Draw;virtual;
    procedure ReadData;virtual;
    procedure MusteriHesabi;virtual;
    procedure KesimHesabi;virtual;
  end;

  P1Balkon = ^T1Balkon;
  T1Balkon = object(TBasicWindow)
    middleGAP : comp;
    lamHeight : comp;
    region2   : byte;
    procedure Load(var T:TStream);virtual;
    procedure Store(var T:TStream);virtual;
    constructor Init;
    function    GetRegionList:PRegion;virtual;
    procedure   OutModel;virtual;
    procedure   Draw;virtual;
    procedure   MusteriHesabi;virtual;
    procedure   KesimHesabi;virtual;
    procedure   ReadBalkonData;
    procedure ReadData;virtual;
  end;

  P2Balkon = ^T2Balkon;
  T2Balkon = object(T1Balkon)
    region3,region4 : byte;
    procedure Load(var T:TStream);virtual;
    procedure Store(var T:TStream);virtual;
    constructor Init;
    function    GetRegionList:PRegion;virtual;
    procedure   OutModel;virtual;
    procedure   Draw;virtual;
    procedure   MusteriHesabi;virtual;
    procedure   KesimHesabi;virtual;
    procedure ReadData;virtual;
  end;

  P3Balkon = ^T3Balkon;
  T3Balkon = object(T2Balkon)
    region5,region6:byte;
    procedure Load(var T:TStream);virtual;
    procedure Store(var T:TStream);virtual;
    constructor Init;
    function    GetRegionList:PRegion;virtual;
    procedure   Draw;virtual;
    procedure   MusteriHesabi;virtual;
    procedure   KesimHesabi;virtual;
    procedure ReadData;virtual;
  end;

  P4Balkon = ^T4Balkon;
  T4Balkon = object(T3Balkon)
    region7,region8:byte;
    procedure Load(var T:TStream);virtual;
    procedure Store(var T:TStream);virtual;
    constructor Init;
    function    GetRegionList:PRegion;virtual;
    procedure   Draw;virtual;
    procedure   MusteriHesabi;virtual;
    procedure   KesimHesabi;virtual;
    procedure ReadData;virtual;
  end;

  P5Balkon = ^T5Balkon;
  T5Balkon = object(T4Balkon)
    region9,region10:byte;
    procedure Load(var T:TStream);virtual;
    procedure Store(var T:TStream);virtual;
    constructor Init;
    function    GetRegionList:PRegion;virtual;
    procedure   Draw;virtual;
    procedure   MusteriHesabi;virtual;
    procedure   KesimHesabi;virtual;
    procedure ReadData;virtual;
  end;

  P1SBalkon = ^T1SBalkon;
  T1SBalkon = object(TBasicWindow)
    lamHeight : comp;
    procedure Load(var T:TStream);virtual;
    procedure Store(var T:TStream);virtual;
    constructor Init;
    function    GetRegionList:PRegion;virtual;
    procedure   OutModel;virtual;
    procedure   Draw;virtual;
    procedure   MusteriHesabi;virtual;
    procedure   KesimHesabi;virtual;
    procedure ReadBalkonData;
    procedure ReadData;virtual;
  end;

  P2SBalkon = ^T2SBalkon;
  T2SBalkon = object(T1SBalkon)
    region2:byte;
    procedure Load(var T:TStream);virtual;
    procedure Store(var T:TStream);virtual;
    constructor Init;
    function    GetRegionList:PRegion;virtual;
    procedure   OutModel;virtual;
    procedure   Draw;virtual;
    procedure   MusteriHesabi;virtual;
    procedure   KesimHesabi;virtual;
    procedure ReadData;virtual;
  end;

  P3SBalkon = ^T3SBalkon;
  T3SBalkon = object(T2SBalkon)
    region3:byte;
    procedure Load(var T:TStream);virtual;
    procedure Store(var T:TStream);virtual;
    constructor Init;
    function    GetRegionList:PRegion;virtual;
    procedure   Draw;virtual;
    procedure   MusteriHesabi;virtual;
    procedure   KesimHesabi;virtual;
    procedure ReadData;virtual;
  end;

  P4SBalkon = ^T4SBalkon;
  T4SBalkon = object(T3SBalkon)
    region4:byte;
    procedure Load(var T:TStream);virtual;
    procedure Store(var T:TStream);virtual;
    constructor Init;
    function    GetRegionList:PRegion;virtual;
    procedure   Draw;virtual;
    procedure   MusteriHesabi;virtual;
    procedure   KesimHesabi;virtual;
    procedure ReadData;virtual;
  end;

  P5SBalkon = ^T5SBalkon;
  T5SBalkon = object(T4SBalkon)
    region5:byte;
    procedure Load(var T:TStream);virtual;
    procedure Store(var T:TStream);virtual;
    constructor Init;
    function    GetRegionList:PRegion;virtual;
    procedure   Draw;virtual;
    procedure   MusteriHesabi;virtual;
    procedure   KesimHesabi;virtual;
    procedure ReadData;virtual;
  end;

  {-------------------------------------------------------------------}

  PMemoryRec = ^TMemoryRec;
  TMemoryRec = object(TPriceRec)
    Cift      : boolean; {caminfo}
    Obj       : PBasicWindow;
    Image     : PChar;
    Qty       : comp;
    Kal1,Kal2 : byte;
    CamC      : byte;
  end;

  PMemoryColl = ^TMemoryColl;
  TMemoryColl = object(TCollection)
    procedure FreeItem(item:pointer);virtual;
  end;

  PPriceColl = ^TPriceColl; {bu sag ustteki nane}
  TPriceColl = object(TCollection)
    procedure FreeItem(item:pointer);virtual;
  end;

  PFiatHeaderColl = ^TFiatHeaderColl; {bu ise archives}
  TFiatHeaderColl = object(TSortedCollection)
    function Compare(k1,k2:pointer):integer;virtual;
    procedure FreeItem(item:pointer);virtual;
  end;

  PMeasureCollection = ^TMeasureCollection;
  TMeasureCollection = object(TSortedCollection)
    procedure FreeItem(item:pointer);virtual;
    function Compare(k1,k2:pointer):integer;virtual;
  end;

  PRegInput = ^TRegInput;
  TRegInput = object(TInputNum)
    x1,y1,x2,y2:byte;
    procedure SetState(astate:word; enable:boolean);virtual;
  end;

  PModelView = ^TModelView;
  TModelView = object(TView)
    Buffer   : PChar;
    Cols     : byte;
    Rows     : byte;
    constructor Init(x,y:integer; acols,arows:byte);
    destructor  Done;virtual;
    procedure   Clear;
    procedure   PutChar(x,y,color:byte; c:char);
    procedure   SetColor(x,y,color:byte);
    procedure   PutStr(x,y,color:byte; s:string);
    procedure   SetBuffer(abuf:PChar);
    procedure   Paint;virtual;
  end;

  PPVCCalcWindow = ^TPVCCalcWindow;
  TPVCCalcWindow = object(TDialog)
    constructor Init;
    destructor  Done;virtual;
    procedure Enablebuttons;
    procedure DisableButtons;
    procedure HandleEvent(var Event:TEvent);virtual;
    procedure SetModel(amodel:PBasicWindow);
  end;

  PPriceLister = ^TPriceLister;
  TPriceLister = object(TFormattedLister)
    function GetText(item:longint):string;virtual;
    function GetColor(item:longint):byte;virtual;
    procedure ItemTagged(item:longint);virtual;
    procedure ItemDoubleClicked(item:longint);virtual;
  end;

  PMemoryLister = ^TMemoryLister;
  TMemoryLister = object(TPriceLister)
    procedure ItemFocused(item:longint);virtual;
  end;

  PMeasureLister = ^TMeasureLister;
  TMeasureLister = object(TFormattedLister)
    function GetText(item:longint):string;virtual;
  end;

  PMaliyetDialog = ^TMaliyetDialog;
  TMaliyetDialog = object(TDialog)
    constructor Init;
    procedure   HandleEvent(var Event:TEvent);virtual;
  end;

  PVasistasDialog = ^TVasistasDialog;
  TVasistasDialog = object(TDialog)
    constructor Init;
  end;

  PMemoryAddDialog = ^TMemoryAddDialog;
  TMemoryAddDialog = object(TDialog)
    constructor Init;
  end;

  PCamRec = ^TCamRec;
  TCamRec = record
    Cift         : boolean;
    Kal1,Kal2    : byte;
    CamC         : byte;
    Width,Height : comp;
    Qty          : comp;
  end;

  PCamCollection = ^TCamCollection;
  TCamCollection = object(TSortedCollection)
    function Compare(k1,k2:pointer):integer;virtual;
    procedure FreeItem(item:pointer);virtual;
  end;

  PCamLister = ^TCamLister;
  TCamLister = object(TFormattedLister)
    function GetText(item:longint):string;virtual;
  end;

  PPVCLister = ^TPVCLister;
  TPVCLister = object(TFormattedLister)
    function GetText(item:longint):string;virtual;
  end;

  PCamDialog = ^TCamDialog;
  TCamDialog = object(TDialog)
    Lister   : PCamLister;
    constructor Init;
    procedure HandleEvent(var Event:TEvent);virtual;
  end;

  PRegionDialog = ^TRegionDialog;
  TRegionDialog = object(TDialog)
    CurrentRegion : PRegion;
    constructor Init(aregions:PRegion);
    procedure HandleEvent(var Event:TEvent);virtual;
    procedure DrawRegion(color:byte; direction:byte);
  end;

  PKesimDialog = ^TKesimDialog;
  TKesimDialog = object(TDialog)
    Lister : PPVCLister;
    constructor Init;
    procedure HandleEvent(var Event:TEvent);virtual;
  end;

  PFiatLister = ^TFiatLister;
  TFiatLister = object(TFormattedLister)
    function GetText(item:longint):string;virtual;
    procedure ItemDoubleClicked(item:longint);virtual;
  end;

  PFiatDialog = ^TFiatDialog;
  TFiatDialog = object(TDialog)
    Lister    : PFiatLister;
    constructor Init;
  end;

var

  PrinterBuffer : array[1..80,1..66] of char;

const

  maxwindows = 15;

  tempcode : string = '';

var

  timer       : longint absolute 0:$46c;

  TotalPVC    : comp;
  TotalPesin  : comp;
  TotalVade   : comp;
  TotalAksesuar : comp;
  TotalCAM    : comp;
  TotalLambri : comp;
  TotalKAPI   : comp;
  TotalZivana : comp;
  PesinKDV    : comp;
  VadeKDV     : comp;

const

  drawColor      : byte = cLightGreen;
  CurrentModel   : integer = 0;
  CurrentType    : char = 'P';

  PriceList      : PPriceColl = NIL;
  ObjList        : PCollection = NIL;
  Memory         : PMemoryColl = NIL;

  MV             : PModelView = NIL;
  ModelLabel     : PDynamicLabel = NIL;
  MeasureLister  : PMeasureLister = NIL;
  KesimInput     : PInputNum    = NIL;
  Measures       : PMeasureCollection = NIL;
  PesinInput     : PInputNum   = NIL;
  VadeInput      : PInputNum = NIL;
  MusteriLister  : PPriceLister = NIL;
  MemLister      : PmemoryLister = NIL;
  MemPesinInput  : PInputNum = NIL;
  MemVadeInput   : PInputNum = NIL;
  EntryDialog    : PDialog = NIL;
  EntryY         : integer = 5;

procedure InitObjects;
procedure DrawBox(x1,y1,x2,y2:byte);
procedure DrawHLine(x1,x2,y:byte);
procedure DrawVLine(x,y1,y2:byte);
procedure DrawSolidBox(x1,y1,x2,y2:byte);

function SameMeasure(p1,p2:PMeasure):boolean;

implementation

uses

  XDev,XBuf;

function CastObject(vmt:word; loadptr:pointer):PBasicWindow;assembler;
asm
  push  vmt
  xor   ax,ax
  push  ax
  push  ax
  call  loadptr
end;

function CopyObject(P:PBasicWindow):PBasicWindow;
var
  NewP:PBasicWindow;
  vmt:word;
  T:TDosStream;
begin
  vmt := word(TypeOf(P^));
  NewP := CastObject(vmt,P^.loadPtr);
  NewP^.rw := NIL;
  NewP^.clone := NIL;
  NewP^.InitWidths(P^.rn);
  Move(P^.rw^,NewP^.rw^,SizeOf(comp)*P^.rn);
  Move(P^.clone^,NewP^.Clone^,SizeOf(comp)*P^.rn);
  NewP^.Index := P^.Index;
  T.Init(wkdir+tempFile,StCreate);
  P^.Store(T);
  T.Seek(0);
  NewP^.Load(T);
  T.Done;
  CopyObject := NewP;
end;

procedure UpdateMemoryTotals;
var
  P:PMemoryRec;
  vadetotal,pesintotal:comp;
  n:integer;
begin
  pesintotal := 0;
  vadetotal  := 0;
  for n:=0 to Memory^.Count-1 do begin
    P := Memory^.At(n);
    if P^.Include then begin
      pesintotal := pesintotal + P^.Pesin;
      vadetotal := vadetotal + P^.Vade;
    end;
  end;
  MemPesinInput^.SetData(pesintotal);
  MemVadeInput^.SetData(vadetotal);
end;

procedure GetPriceTotals(var pesin,vade:comp);
var
  Pm:PPriceRec;
  n:integer;
begin
  pesin := 0;
  vade  := 0;
  for n:=0 to PriceList^.Count-1 do begin
    Pm := PriceList^.At(n);
    if Pm^.Include then begin
      Pesin := Pesin + Pm^.Pesin;
      Vade  := vade + Pm^.Vade;
    end;
  end;
end;

procedure UpdatePriceTotals;
var
  totalPesin,totalVade:comp;
begin
  GetPriceTotals(totalPesin,totalVade);
  PesinInput^.SetData(totalPesin);
  vadeInput^.SetData(totalVade);
end;

procedure AddPrice(what:string; pesincost,vadecost:comp; include:boolean);
var
  P:PPriceRec;
begin
  if pesincost = 0 then exit;
  New(P);
  P^.What := what;
  P^.Pesin := pesincost;
  P^.Vade  := VadeCost;
  P^.Include := include;
  PriceList^.Insert(P);
  MusteriLister^.ItemList := NIL;
  MusteriLister^.Update(PriceList);
end;

procedure AddMemory(what:string; pesincost,vadecost,qty:comp; cift:boolean; kal1,kal2,camc:byte);
var
  P:PMemoryRec;
begin
  if pesincost = 0 then exit;
  if vadecost = 0 then exit;
  New(P);
  P^.What  := what;
  P^.Pesin := pesincost*qty;
  P^.Vade  := vadecost*qty;
  P^.Qty   := qty;
  P^.Include := true;
  P^.Obj := CopyObject(ObjList^.At(currentModel));
  P^.Cift   := cift;
  P^.Kal1   := kal1;
  P^.Kal2   := kal2;
  P^.Camc   := camc;
  GetMem(P^.Image,mvBufSize);
  Move(MV^.Buffer^,P^.Image^,mvBufSize);
  Memory^.Insert(P);
  MemLister^.Update(Memory);
  UpdateMemoryTotals;
end;

procedure NCharInput(prompt:string; var c:char);
var
  R:TRect;
  P:PINputStr;
begin
  New(P,Init(5,EntryY,1,Fix(prompt,30),1,Idc_UpperStr));
  P^.GetBounds(R);
  P^.Source := @c;
  EntryDialog^.Insert(P);
  EntryY := r.b.y+5;
end;

procedure NRegInput(prompt:string; x1,y1,x2,y2:integer; var l:comp);
var
  P:PRegInput;
  R:TRect;
begin
  New(P,Init(5,EntryY,10,Fix(prompt,30),Stf_Comp,10,0,Idc_StrDefault));
  P^.GetBounds(R);
  P^.Source := @l;
  P^.x1     := x1;
  P^.y1     := y1;
  P^.x2     := x2;
  P^.y2     := y2;
  EntryDialog^.Insert(P);
  EntryY := r.b.y + 5;
end;

procedure SetAttr(x1,y1,x2,y2,color:byte);
var
  x,y:byte;
begin
  for x:=x1 to x2 do begin
    MV^.SetColor(x,y1,color);
    MV^.SetColor(x,y2,color);
  end;
  for y:=y1+1 to y2-1 do begin
    MV^.SetColor(x1,y,color);
    MV^.SetColor(x2,y,color);
  end;
  MV^.PaintView;
end;

function TFiatHeaderColl.Compare;
var
  p1,p2:PFiatHeader;
  d1,d2:DateTime;
  i:integer;
begin
  p1 := k1;
  p2 := k2;
  i := CompareMoment(p2^.Date,p1^.Date);
  if i = 0 then i := -1;
  Compare := i;
end;

procedure TFiatHeaderColl.FreeItem;
begin
  Dispose(PFiatHeader(item));
end;

procedure TFiatLister.ItemDoubleClicked;
begin
  Message(Owner,evCommand,cmOK,@Self);
end;

function TFiatLister.GetText;
var
  P:PFiatheader;
begin
  P := ItemList^.At(item);
  GetText := Date2Str(P^.Date,false)+'|'+Time2Str(P^.Date)+'|'+P^.Name;
end;

constructor TFiatDialog.Init;
var
  R:TRect;
begin
  R.Assign(0,0,0,0);
  inherited Init(R,'Kayçtlç fiatlar');
  Options := Options or Ocf_Centered;
  New(lister,Init(5,5,ViewFont,15,
    NewColumn('Tarih',68,cofNormal,
    NewColumn('Saat',44,cofNormal,
    NewColumn('òsim',275,cofNormal,
    NIL)))));
  Lister^.GetBounds(R);
  Insert(Lister);
  InsertBlock(GetBlock(5,r.b.y+5,mnfHorizontal+mnfNoSelect,
    NewButton('~YÅkle',cmOK,
    NewButton('~Vazgeá',cmCancel,
    NIL))));
  FitBounds;
end;

constructor TKesimDialog.Init;
var
  R:TRect;
begin
  R.Assign(0,0,0,0);
  inherited Init(R,'Kesim listesi');
  Options := Options or Ocf_Centered;
  New(Lister,init(5,5,ViewFont,15,
    NewColumn('Aáçklama',128,cofNormal,
    NewColumn('ôláÅ',128,cofNormal,
    NewColumn('Adet',40,cofRJust,
    NIL)))));
  Lister^.GetBounds(R);
  PutListerScroller(Lister,@Self);
  Insert(Lister);
  InsertBlock(getBlock(5,r.b.y+5,mnfHorizontal,
    NewButton('~Yazdçr',cmPrint,
    NewButton('~Vazgeá',cmClose,
    NIL))));
  SelectNext(true);
  FitBounds;
end;

procedure TKesimDialog.HandleEvent(var Event:TEvent);
  procedure Print;
  var
    Pm:PMeasure;
    n:integer;
    mstr:string;
  begin
    ClearEvent(Event);
    EventWait;
    BeginPrint;
    WritePrn(keycode+' öRETòM KESòM LòSTESò');
    WritePrn('');
    WritePrn(Fix('Aáçklama',15)+'  '+Fix('ôláÅ',15)+'  Adet');
    WritePrn('');
    for n:=0 to Lister^.ItemList^.Count-1 do begin
      Pm := Lister^.ItemList^.At(n);
      case Pm^.MeasureType of
        mtLong : mstr := c2s(Pm^.Length)+'mm';
        mtSquare : mstr := c2s(Pm^.Width)+'x'+c2s(Pm^.Height)+' ('+x2s((Pm^.Width*Pm^.height)/1000000,3,2)+'m˝)';
        mtItem : mstr := '';
        else mstr := '???';
      end; {case}
      WritePrn(Fix(Pm^.What,15)+'  '+Fix(mstr,15)+' '+RFix(c2s(Pm^.Qty),5));
    end;
    EndPrint;
  end;
begin
  inherited HandleEvent(Event);
  if Event.What = evCommand then if Event.Command = cmPrint then Print;
end;

constructor TRegionDialog.Init(aregions:PRegion);
var
  R:TRect;
  Pl:PLabel;
begin
  R.Assign(0,0,0,0);
  inherited Init(R,'Onay');
  Options := Options or Ocf_Centered;
  CurrentRegion := aregions;
  New(Pl,Init(5,5,'Gîsterilen bîlgedeki varsa aáçlçrçn yînÅ nedir?',ViewFont));
  Pl^.GetBounds(R);
  Insert(Pl);
  InsertBlock(GetBlock(5,r.b.y+5,mnfHorizontal,
    NewButton('~Yok',cmYok,
    NewButton('~<-',cmLeft,
    NewButton('-~>',cmRight,
    NewButton('~'#24,cmUp,
    NewButton('~'#25,cmDown,
    NewButton('~Vazgeá',cmCancel,
    NIL))))))));
  DrawRegion(cLightRed,rdNone);
  SelectNext(True);
  FitBounds;
end;

procedure TRegionDialog.DrawRegion;
var
  xsize,ysize:word;
  procedure DrawToLeft(x1,y1,x2,y2:byte);
  var
    x,y:byte;
    middle:byte;
  begin
    if xsize > 2 then begin
      inc(x1);
      dec(x2);
      dec(xsize,2);
    end;
    if ysize > 2 then begin
      inc(y1);
      dec(y2);
      dec(ysize,2);
    end;
    if xsize < (ysize div 2) then begin
      middle := ((ysize-(xsize*2)) div 2)+1;
      inc(y1,middle);
      dec(y2,middle);
      ysize := (y2-y1)+1;
    end;
    x := x2;
    middle := y1+(ysize div 2);
    for y:=y1 to y2 do begin
      if y < middle then begin
        MV^.putstr(x,y,cCyan,'/');
        dec(x);
      end else if (odd(ysize)) and (y=middle) then begin
        MV^.putStr(x,y,cCyan,'<');
      end else begin
        inc(x);
        MV^.PutStr(x,y,cCyan,'\');
      end;
    end;
  end;

  procedure DrawToRight(x1,y1,x2,y2:byte);
  var
    x,y:byte;
    middle:byte;
  begin
    if xsize > 2 then begin
      inc(x1);
      dec(x2);
      dec(xsize,2);
    end;
    if ysize > 2 then begin
      inc(y1);
      dec(y2);
      dec(ysize,2);
    end;
    if xsize < (ysize div 2) then begin
      middle := ((ysize-(xsize*2)) div 2)+1;
      inc(y1,middle);
      dec(y2,middle);
      ysize := (y2-y1)+1;
    end;
    x := x1;
    middle := y1+(ysize div 2);
    for y:=y1 to y2 do begin
      if y < middle then begin
        MV^.putstr(x,y,cCyan,'\');
        inc(x);
      end else if (odd(ysize)) and (y=middle) then begin
        MV^.putStr(x,y,cCyan,'>');
      end else begin
        dec(x);
        MV^.PutStr(x,y,cCyan,'/');
      end;
    end;
  end;

  procedure DrawToUp(x1,y1,x2,y2:byte);
  var
    x,y:byte;
    middle:byte;
  begin
    if xsize > 2 then begin
      inc(x1);
      dec(x2);
      dec(xsize,2);
    end;
    if ysize > 2 then begin
      inc(y1);
      dec(y2);
      dec(ysize,2);
    end;
    if ysize < (xsize div 2) then begin
      xsize := ((ysize-1)*2);
      inc(x1,((((x2-x1)+1)-xsize) div 2));
      x2 := (x1+xsize)-1;
    end;
    y := y2;
    middle := x1+(xsize div 2);
    for x:=x1 to x2 do begin
      if x < middle then begin
        MV^.putstr(x,y,cCyan,'/');
        dec(y);
      end else if (odd(xsize)) and (x=middle) then begin
        MV^.putStr(x,y,cCyan,'^');
      end else begin
        inc(y);
        MV^.PutStr(x,y,cCyan,'\');
      end;
    end;
  end;

  procedure DrawToDown(x1,y1,x2,y2:byte);
  var
    x,y:byte;
    middle:byte;
  begin
    if xsize > 2 then begin
      inc(x1);
      dec(x2);
      dec(xsize,2);
    end;
    if ysize > 2 then begin
      inc(y1);
      dec(y2);
      dec(ysize,2);
    end;
    if ysize < (xsize div 2) then begin
      xsize := ((ysize-1)*2)+1;
      inc(x1,((((x2-x1)+1)-xsize) div 2));
      x2 := (x1+xsize)-1;
    end;
    y := y1;
    middle := x1+(xsize div 2);
    for x:=x1 to x2 do begin
      if x < middle then begin
        MV^.putstr(x,y,cCyan,'\');
        inc(y);
      end else if (odd(xsize)) and (x=middle) then begin
        MV^.putStr(x,y,cCyan,'V');
      end else begin
        dec(y);
        MV^.PutStr(x,y,cCyan,'/');
      end;
    end;
  end;

begin
  if CurrentRegion = NIL then Error('TRegionDialog.DrawRegion','CurrentRegion = NIL');
  DrawColor := color;
  with CurrentRegion^ do begin
    DrawBox(x1,y1,x2,y2);
    xsize := (x2-x1)+1;
    ysize := (y2-y1)+1;
    case direction of
      rdLeft  : DrawToLeft(x1,y1,x2,y2);
      rdRight : DrawToRight(x1,y1,x2,y2);
      rdUp    : DrawToUp(x1,y1,x2,y2);
      rdDown  : DrawToDown(x1,y1,x2,y2);
    end; {case}
  end;
  MV^.PaintView;
  DrawColor := cLightGreen;
end;

procedure TRegionDialog.HandleEvent(var Event:TEvent);
  procedure Go(yon:byte);
  var
    b:^byte;
  begin
    EventWait;
    ClearEvent(Event);
    b := CurrentRegion^.Data;
    b^ := yon;
    if yon>0 then DrawRegion(cWhite,yon) else DrawRegion(cBlack,rdNone);
    CurrentRegion := CurrentRegion^.Next;
    if CurrentRegion = NIL then EndModal(cmOK) else DrawRegion(cLightRed,rdNone);
  end;
begin
  if Event.What = evKeyDown then case Event.KeyCode of
    kbUp : Go(rdUp);
    kbDown : Go(rdDown);
    kbLeft : Go(rdLeft);
    kbRight : Go(rdRight);
  end; {case}
  if Event.What = evNothing then exit;
  inherited HandleEvent(Event);
  if Event.What = evCommand then case Event.Command of
    cmYok : Go(rdNone);
    cmLeft : Go(rdLeft);
    cmRight : Go(rdRight);
    cmUp    : Go(rdUp);
    cmDown  : Go(rdDown);
  end; {Case}
end;

function TCamCollection.Compare(k1,k2:pointer):integer;
var
  p1,p2:PCamRec;
begin
  p1 := k1;
  p2 := k2;
  if p1^.Width < p2^.Width then Compare := 1 else Compare := -1;
end;

procedure TCamCollection.FreeItem(item:pointer);
begin
  Dispose(PCamRec(item));
end;

function TCamLister.GetText(item:longint):string;
var
  P:PCamRec;
begin
  P := ItemList^.At(item);
  GetText := l2s(P^.Kal1)+'+'+l2s(P^.Kal2)+' ('+l2s(P^.Camc)+') '+
             GetBool(P^.Cift,'Äift','Tek')+' cam'+'|'+c2s(P^.Width)+'|'+c2s(P^.Height)+'|'+
             c2s(P^.Qty);
end;

constructor TCamDialog.Init;
var
  R:TRect;
  n:integer;
begin
  R.Assign(0,0,0,0);
  inherited Init(R,'Cam sipariü formu');
  Options := Options or Ocf_Centered;
  New(Lister,Init(5,5,ViewFont,15,
    NewColumn('Aáçklama',152,cofNormal,
    NewColumn('Geniülik',75,cofRJust,
    NewColumn('YÅkseklik',75,cofRJust,
    NewColumn('Adet',40,cofRjust,
    NIL))))));
  PutListerScroller(Lister,@Self);
  Lister^.GetBounds(R);
  Insert(Lister);
  InsertBlock(getBlock(5,r.b.y+5,mnfHorizontal,
    NewButton('~Yazdçr',cmPrint,
    NewButton('~Kapat',cmClose,
    NIL))));
  SelectNext(True);
  FitBounds;
end;

procedure TCamDialog.HandleEvent;
  procedure Print;
  var
    Pcam:PCamRec;
    Pc:PCamCollection;
    n:integer;
  begin
    EventWait;
    Pc := PCamCollection(Lister^.ItemList);
    ClearEvent(Event);
    BeginPrint;
    WritePrn(KeyCode+' CAM SòPARòû LòSTESò    ('+Date2Str(GetSysMoment,True)+')');
    WritePrn('');
    WritePrn(Fix('Aáçklama',30)+' '+Fix('Adet',5)+' '+Fix('Ebat',10));
    WritePrn(Duplicate('-',30)+' '+Duplicate('-',5)+' '+Duplicate('-',10));
    for n:=0 to Pc^.Count-1 do begin
      Pcam := Pc^.At(n);
      WritePrn(Fix(l2s(Pcam^.Kal1)+'+'+l2s(Pcam^.Kal2)+' ('+l2s(Pcam^.CamC)+') '+GetBool(Pcam^.Cift,'Äift','Tek')+' cam',30)+
               ' '+RFix(c2s(Pcam^.Qty),5)+' '+RFix(RFix(c2s(Pcam^.Width),4)+'x'+RFix(c2s(Pcam^.Height),4),10));
    end;
    EndPrint;
  end;
begin
  inherited HandleEvent(Event);
  if Event.What = evCommand then if Event.Command = cmPrint then Print;
end;

constructor TVasistasDialog.Init;
var
  R:TRect;
  Ps:PStaticText;
begin
  R.Assign(0,0,0,0);
  inherited Init(R,'Onay');
  R.Assign(5,5,320,21);
  New(Ps,Init(R,'Gîsterilen bîlgede aáçlçr var mç?',ViewFont,cBlack,Col_Back));
  Ps^.GetBOunds(R);
  Insert(Ps);
  InsertBlock(GetBLock(5,r.b.y+5,mnfHorizontal,
    NewButton('~Evet',cmYes,
    NewButton('~Hayçr',cmNo,
    NewButton('~Vazgeá',cmCancel,
    NIL)))));
  SelectNext(True);
  FitBounds;
end;

constructor TMemoryAddDialog.Init;
var
  R:TRect;
  Psc:PSingleCheckbox;
  procedure putinputstr(s:string; numlen:byte);
  var
    P:PInputStr;
  begin
    New(P,Init(5,r.a.y,numlen,s,numlen,Idc_StrDefault));
    P^.GetBounds(R);
    Insert(P);
    r.a.y := r.b.y+5;
  end;

  procedure putinput(s:string; numlen:byte);
  var
    P:PInputNum;
  begin
    New(P,Init(5,r.a.y,numlen,s,Stf_Comp,numlen,0,Idc_NumDefault));
    P^.GetBounds(R);
    Insert(P);
    r.a.y := r.b.y+5;
  end;

  procedure putinputbyte(s:string);
  var
    P:PInputNum;
  begin
    New(P,Init(5,r.a.y,5,s,Stf_Byte,5,0,Idc_NumDefault));
    P^.GetBounds(R);
    Insert(P);
    r.a.y := r.b.y+5;
  end;
begin
  R.Assign(0,0,0,0);
  inherited Init(R,'Hafçzaya ekle');
  Options := Options or Ocf_Centered;
  r.a.y := 5;
  putinputstr('Aáçklama          ',15);
  putinput   ('Adet              ',5);
  putinput   ('Peüin birim fiatç ',20);
  putinput   ('Vadeli birim fiatç',20);
  New(Psc,Init(5,r.a.y+5,ViewFont,'Äift cam'));
  Psc^.GetBounds(R);
  Insert(Psc);
  r.a.y := r.b.y+5;
  putinputbyte('1. cam kalçnlçßç (mm)    ');
  putinputbyte('2. cam kalçnlçßç (mm)    ');
  putinputbyte('Cam áçtasç kalçnlçßç (mm)');
  InsertBlock(GetBlock(5,r.a.y,mnfHorizontal,
    NewButton('~Tamam',cmOK,
    NewButton('~Vazgeá',cmCancel,
    NIL))));
  SelectNext(True);
  FitBounds;
end;

function TMeasureLister.GetText;
var
  P:PMeasure;
  mstr:string;
begin
  P := itemList^.At(item);
  case P^.MeasureType of
    mtLong : mstr := c2s(P^.Length)+'mm';
    mtSquare : mstr := c2s(P^.Width)+'x'+c2s(P^.Height)+' ('+x2s((P^.Width*P^.height)/1000000,3,2)+'m˝)';
    mtItem : mstr := '';
    else mstr := '???';
  end; {case}
  GetText := P^.What+'|'+mstr+'|'+c2s(P^.Qty)+'|'+cn2b(c2s(P^.Price));
end;

function TPVCLister.GetText(item:longint):string;
var
  P:PMeasure;
  mstr:string;
begin
  P := itemList^.At(item);
  case P^.MeasureType of
    mtLong : mstr := c2s(P^.Length)+'mm';
    mtSquare : mstr := c2s(P^.Width)+'x'+c2s(P^.Height)+' ('+x2s((P^.Width*P^.height)/1000000,3,2)+'m˝)';
    mtItem : mstr := '';
    else mstr := '???';
  end; {case}
  GetText := P^.What+'|'+mstr+'|'+c2s(P^.Qty);
end;


procedure UpdateToplamMaliyet;
var
  P:PMeasure;
  total:comp;
  n:integer;
begin
  total := 0;
  for n:=0 to Measures^.Count-1 do begin
    P := Measures^.At(n);
    total := total + P^.Price;
  end;
  KesimInput^.SetData(total);
end;

constructor TMaliyetDialog.Init;
var
  R:TRect;
  Ps:PScrollBar;
  s:string;
begin
  R.Assign(0,0,0,0);
  inherited Init(R,'Maliyet Hesabç');
  Options := Options or Ocf_Centered;
  New(MeasureLister,Init(5,5,ViewFont,20,
    NewColumn('Paráa',120,cofNormal,
    NewColumn('ôláÅ',144,cofRJust,
    NewColumn('Adet',36,cofRjust,
    NewColumn('Tutar',120,cofRJust,
    NIL))))));
  MeasureLIster^.GetBounds(R);
  r.a.x := r.b.x+2;
  r.b.x := r.a.x+sbButtonSize;
  r.a.y := r.a.y+10;
  New(Ps,Init(R));
  Insert(Ps);
  MeasureLister^.AssignScroller(ps);
  MeasureLister^.SetConfig(Lvc_KeepList,True);
  MeasureLister^.NewList(Measures);
  Insert(MeasureLister);
  s := GetBlock(5,r.b.y+5,mnfHorizontal,
    NewButton('~Kapat',cmOK,
    NewButton('K~aydet',cmSave,
    NewButton('~Yazdçr',cmPrint,
    NIL))));
  GetBlockBounds(s,R);
  InsertBlock(s);
  New(KesimInput,Init(r.b.x+5,r.a.y+2,18,'Toplam ',Stf_Comp,18,0,Idc_NumDefault));
  KesimInput^.SetState(Scf_Disabled,True);
  Insert(kesimInput);
  UpdateToplamMaliyet;
  SelectNext(True);
  FitBounds;
end;

procedure TMaliyetDialog.HandleEvent;
  procedure PrintMaliyet;
  var
    P:PBasicWindow;
    Pm:PMeasure;
    n:integer;
    whoa:string;
  begin
    EventWait;
    P := ObjList^.At(currentModel);
    BeginPrint;
    WritePrn(keycode+' MALòYET ANALòZò');
    WritePrn('');
    P^.PrintModel;
    for n:=0 to Measures^.Count-1 do begin
      Pm := Measures^.At(n);
      case Pm^.MeasureType of
        mtLong : whoa := c2s(Pm^.Length)+'mm';
        mtSquare : whoa := c2s(Pm^.Width)+'x'+c2s(Pm^.Height)+' ('+x2s(Pm^.Width*Pm^.Height/1000000,3,2)+'m˝)';
        else whoa := '';
      end; {case}
      WritePrn(Fix(Pm^.What+' '+whoa,30)+' '+RFix(c2s(Pm^.qty),4)+' adet ');
    end;
    EndPrint;
  end;

  procedure SaveLog;
  var
    T:TDosStream;
    P:PMeasure;
    n:integer;
    rec:TLogRec;
    y,m,d,dow:word;
  begin
    rec.What := 'öretim';
    if not InputBox('òülem kaydç','Aáçklama',0,ViewFont,rec.What,19) then exit;
    EventWait;
    GetDate(y,m,d,dow);
    rec.Year := y;
    rec.Month := m;
    rec.Day   := d;
    rec.NumEntries := Measures^.Count;
    rec.Offs       := 0;
    T.Init(wkdir+logFile,stOpen);
    if T.Status <> stOK then begin
      T.Done;
      T.Init(wkdir+logFile,stCreate);
    end;
    T.Seek(T.GetSize);
    T.Write(rec,SizeOf(rec));
    for n:=0 to Measures^.Count-1 do begin
      P := Measures^.At(n);
      T.Write(P^,SizeOf(TMeasure));
    end;
    T.Done;
  end;
begin
  inherited HandleEvent(Event);
  if Event.What = evCOmmand then case Event.Command of
    cmPrint : PrintMaliyet;
    cmSave  : SaveLog;
    else exit;
  end else exit; {case}
  ClearEvent(Event);
end;

procedure TRegInput.SetState(astate:word; enable:boolean);
begin
  inherited SetState(astate,enable);
  if GetState(Scf_Exposed) then if astate and Scf_Focused > 0 then if Enable then SetAttr(x1,y1,x2,y2,cLightRed)
                                               else SetAttr(x1,y1,x2,y2,cLightGreen);
end;

procedure DisposeRegion(P:PRegion);
begin
  if P = NIL then exit;
  if P^.Next <> NIL then DisposeRegion(P^.Next);
  Dispose(P);
end;

function NewRegion(x1,y1,x2,y2:byte; data:pointer; next:PRegion):PRegion;
var
  P:PRegion;
begin
  New(P);
  P^.Next := next;
  P^.x1   := x1;
  P^.x2   := x2;
  P^.y1   := y1;
  P^.y2   := y2;
  P^.Data := data;
  NewRegion := P;
end;

function TPriceLister.GetColor;
var
  P:PPriceRec;
begin
  P := ItemList^.At(item);
  if P^.Include then GetColor := cBlack else GetColor := cDarkGray;
end;

procedure TPriceLister.ItemDoubleClicked;
begin
  ItemTagged(item);
end;

procedure TPriceLister.ItemTagged;
var
  P:PPriceRec;
begin
  P := ItemList^.At(item);
  P^.Include := not P^.Include;
  PaintView;
  Message(Owner,evCommand,cmPriceTotalChanged,@Self);
end;

function TPriceLister.GetText;
var
  P:PPriceRec;
begin
  P := ItemList^.At(item);
  GetText := P^.What+'|'+cn2b(c2s(P^.Pesin))+'|'+cn2b(c2s(P^.Vade));
end;

procedure TMemoryLister.ItemFocused;
var
  P:PMemoryRec;
begin
  P := ItemList^.At(item);
  if P^.Obj <> NIL then Message(Owner,evCommand,cmFocusModel,P);
end;

constructor TPVCCalcWindow.Init;
var
  R,R1:TRect;
  s:string;
  Ps:PScrollbar;
  Pb:PButton;
  savex,savey:integer;
  procedure putbut(title:string; cmd:word; disabled:boolean);
  begin
    New(Pb,Init(r.a.x,r.a.y,title,cmd));
    if disabled then begin
      Pb^.SetGroupId(gidButtons);
      Pb^.SetState(Scf_Disabled,True);
    end;
    Pb^.Options := Pb^.Options and not Ocf_Selectable;
    Pb^.GetBounds(R);
    r.a.x := r.b.x+3;
    Insert(Pb);
  end;

  function Putinput(x,y:integer; s:string):PInputNum;
  var
    Pi:PInputNum;
  begin
    New(Pi,Init(x,y,15,s,Stf_Comp,15,0,Idc_NumDefault));
    Pi^.SetState(Scf_Disabled,True);
    Pi^.GetBounds(R);
    Insert(Pi);
    Putinput := Pi;
  end;
begin
  R.Assign(0,0,0,0);
  inherited Init(R,'PVC HESABI');
  InitObjects;
  s := getBlock(5,5,mnfHorizontal+mnfNoSelect,
    NewButton('~Pencere',cmSelPencere,
    NewButton('~Kapç',cmSelKapi,
    NewButton('~Balkon',cmSelBalkon,
    NewButton('~!',cmReadMeasureData,
    NIL)))));
  GetBlockBounds(s,R);
  InsertBlock(s);
  New(MV,Init(5,r.b.y+5,mvXsize,mvYSize));
  MV^.GetBounds(R);
  R1 := R;
  New(ModelLabel,Init(5,r.b.y+5,24,'P0',cBlack,Col_Back,ViewFont));
  ModelLabel^.GetBounds(R);
  Insert(ModelLabel);
  New(MemLister,Init(5,r.b.y+5,ViewFont,10,
    NewColumn('Model',120,cofNormal,
    NewColumn('Peüin',120,cofRJust,
    NewColumn('Vadeli',120,cofRJust,
    NIL)))));
  if Memory = NIL then New(Memory,Init(10,10));
  New(Measures,Init(10,10));
  MemLister^.NewList(Memory);
  MemLister^.SetConfig(Lvc_KeepList,True);
  MemLister^.GetBounds(R);
  r.a.x := r.b.x+2;
  r.a.y := r.a.y+8;
  r.b.x := r.a.x+sbButtonSize;
  New(Ps,Init(R));
  Insert(Ps);
  MemLister^.AssignScroller(Ps);
  MemLister^.GetBounds(R);
  Insert(MemLister);
  New(Pb,Init(5,r.b.y+5,'~Sil',cmClearMemory));
  Pb^.Options := Pb^.Options and not Ocf_Selectable;
  Pb^.GetBounds(R);
  Insert(Pb);
  MemPesinInput := putinput(r.b.x+12,r.a.y+5,'Toplam ');
  MemVadeInput := putinput(r.b.x+2,r.a.y,'');
  UpdateMemoryTotals;
  Insert(MV);
  R := R1;
  r.a.x := r.b.x+5;
  r.b.x := r.a.x + 300;
  r.a.y := 5;
  r.b.y := r.a.y + 200;
  New(MusteriLister,Init(r.a.x,5,ViewFont,10,
    NewColumn('Aáçklama',120,cofNormal,
    NewColumn('Peüin',120,cofRJust,
    NewColumn('Vadeli',120,cofRJust,
    NIL)))));
  New(PriceList,Init(10,10));
  MusteriLister^.GetBounds(R);
  savex := r.a.x;
  MusteriLister^.NewList(priceList);
  Insert(MusteriLister);
  PesinInput := putinput(savex+2,r.b.y+5,'Toplam        ');
  VadeInput  := putinput(r.b.x+2,r.a.y,'');
  savex := MV^.Origin.X+MV^.Size.X;
  r.a.y := r.b.y+5;
  r.a.x := savex;
  putbut('Hafçzaya ~ekle',cmAddMemory,true);
  putbut('~Maliyet',cmMaliyetHesabi,true);
  putbut('~Taksit',cmTaksitTakibi,false);
  putbut('Kapat',cmClose,false);
  InsertBlock(GetBlock(MemLister^.Origin.X+MemLister^.Size.X+11,MemLister^.Origin.Y-15,mnfVertical+mnfNoSelect,
    NewButton('Tek~lif áçktçsç ',cmTeklif,
    newButton('Kes~im áçktçsç  ',cmKesimHesabi,
    NewButton('~Cam listesi    ',cmCamHesabi,
    NewButton('Kay~det         ',cmSaveFiats,
    NewButton('~YÅkle          ',cmLoadFiats,
    NIL)))))));
{  r.a.x := 5;
  r.a.y := MemLister^.Origin.Y+MemLister^.Size.Y+7;
  putbut('Tek~lif áçktçsç',cmTeklif,false);
  putbut('Kes~im áçktçsç',cmKesimHesabi,false);
  putbut('~Cam listesi',cmCamHesabi,false);}
  DisableButtons;
  FitBounds;
  HelpContext := hcPVCHesabi;
  SetModel(ObjList^.At(CurrentModel));
end;

destructor TPVCCalcWindow.Done;
begin
  MV := NIL;
  Dispose(ObjList,Done);
  Dispose(Measures,Done);
  inherited Done;
end;

procedure TPVCCalcWindow.DisableButtons;
var
  c:comp;
  procedure SubDisable(p:PView);far;
  begin
    P^.SetState(Scf_Disabled,True);
  end;
begin
  GrpForEach(gidButtons,@SubDisable);
  MusteriLister^.ItemList := NIL;
  PriceList^.FreeAll;
  c := 0;
  MusteriLister^.Update(PriceList);
  PesinInput^.SetData(c);
  VadeInput^.SetData(c);
end;

procedure TPVCCalcWindow.EnableButtons;
  procedure SubEnable(p:PView);far;
  begin
    P^.SetState(Scf_Disabled,False);
  end;
begin
  GrpForEach(gidButtons,@SubEnable);
end;

procedure TPVCCalcWindow.handleEvent;
  procedure SelPrevModel;
  var
    P:PBasicWindow;
  begin
    DrawColor := cLightGreen;
    DisableButtons;
    repeat
      dec(currentModel);
      if currentModel < 0 then currentModel := ObjList^.Count-1;
      P := ObjList^.At(currentModel);
    until P^.Kind = currentType;
    SetModel(P);
  end;

  procedure SelNextModel;
  var
    P:PBasicWindow;
  begin
    DrawColor := cLightGreen;
    DisableButtons;
    repeat
      inc(currentModel);
      if currentModel > ObjList^.Count-1 then currentModel := 0;
      P := ObjList^.At(currentModel);
    until P^.Kind = currentType;
    SetModel(P);
  end;

  procedure Sel(what:char);
  begin
    currentType := what;
    SelNextModel;
  end;

  function ReadRegionData(reg:PRegion):boolean;
  var
    P:PRegionDialog;
    Pb:PBasicWindow;
    code:word;
  begin
    if reg = NIL then begin
      ReadRegionData := true;
      exit;
    end;
    New(P,Init(reg));
    code := Gsystem^.ExecView(P);
    Dispose(P,Done);
    ReadRegionData := code = cmOK;
    if code <> cmOK then begin
      MV^.Clear;
      DrawColor := cLightGreen;
      Pb := ObjList^.At(currentModel);
      Pb^.Draw;
      MV^.PaintView;
      exit;
    end;
  end;

  function ReadMeasureData:boolean;
  var
    R:TRect;
    P:PbasicWindow;
    Pv:PView;
    code:word;
    c:char;
  begin
    P := ObjList^.At(currentModel);
    R.Assign(0,0,0,0);
    New(EntryDialog,Init(R,'ôláÅ giriüi'));
    EntryY := 5;
    EntryDialog^.Options := EntryDialog^.Options or Ocf_Centered;
    NCharInput('Kasa tÅrÅ (Ekonomik/SÅper)',c);
    Pv := EntryDialog^.Top;
    while Pv^.ViewType <> vtInputLine do Pv := Pv^.Next;
    NRegInput('Kasa geniülißi (mm)',1,1,P^.Xsize,1,P^.kasaWidth);
    NRegInput('Kasa yÅkseklißi (mm)',1,1,1,P^.YSize,P^.kasaHeight);
    P^.ReadData;
    EntryDialog^.InsertBlock(GetBlock(5,EntryY,mnfHorizontal,
      NewButton('~Tamam',cmOK,
      NewButton('~Vazgeá',cmCancel,
      NIL))));
    EntryDialog^.SelectNext(true);
    EntryDialog^.FitBounds;
    code := GSystem^.ExecView(EntryDialog);
    if code = cmOK then begin
      if upper(c) = 'E' then begin
        P^.kasaThick := Setup.econThick;
        P^.superKasa := false;
      end else begin
        P^.kasaThick := Setup.superThick;
        P^.superKasa := true;
      end;
      Pv := Pv^.Next;
      while Pv^.ViewType = vtInputLine do begin
        Pv^.GetData(PInputStr(Pv)^.Source^);
        Pv := Pv^.Next;
      end;
      Move(P^.rw^,P^.clone^,SizeOf(comp)*P^.rn);
      ReadMeasureData := true;
    end else ReadMeasureData := false;
    Dispose(EntryDialog,Done);
  end;

  procedure ShowMusteriHesabi(vade:boolean);
  var
    P:PBasicWIndow;
    temp:TSetupRec;
  begin
    EventWait;
    if vade then begin
      Move(Setup,temp,SizeOf(Setup));
      Move(Setup.vPencAksesuar,Setup,7*SizeOf(comp));
    end;
    PriceList^.FreeAll;
    MusteriLister^.ItemList := NIL;
    MusteriLister^.Update(PriceList);
    P := ObjList^.At(currentModel);
    P^.InitMusteriHesabi;
    P^.MusteriHesabi;
    P^.DoneMusteriHesabi;
    if vade then Move(temp,Setup,SizeOf(temp));
  end;

  procedure ReadMeasures;
  var
    P:PBasicWindow;
    reg:PRegion;
  begin
    P := ObjList^.At(currentModel);
    MV^.Clear;
    P^.Draw;
    reg := P^.GetRegionList;
    DisableButtons;
    if ReadRegionData(reg) then if ReadMeasureData then begin
      EnableButtons;
      ShowMusteriHesabi(false);
    end;
    DisposeRegion(reg);
  end;

  procedure ClearMemory;
  begin
    if MessageBox('Listede üu anda gîrÅnen fiyatlar silinecektir. Emin misiniz?',0,mfConfirm+mfYesNo) = cmYes then begin
      Memory^.FreeAll;
      MemLister^.Update(Memory);
      UpdateMemoryTotals;
    end;
  end;

  procedure AddModelToMemory;
  type
    TMemoryAddScr = record
      What  : string[15];
      Adet  : comp;
      Pesin : comp;
      Vade  : comp;
      Cift  : boolean;
      Kal1,Kal2 : byte;
      CamC      : byte;
    end;
  var
    rec:TMemoryAddScr;
    Pd:PMemoryAddDialog;
    P:PBasicWindow;
    Pm:PMemoryRec;
    n:integer;
    code:word;
    pesinTotal,vadeTotal:comp;
  begin
    P := ObjList^.At(currentModel);
    New(Pd,Init);
    GetPriceTotals(pesinTotal,vadetotal);
    rec.What := P^.Kind+l2s(currentModel);
    rec.Adet := 1;
    rec.Pesin := pesinTotal;
    rec.Vade  := vadeTotal;
    rec.Cift  := true;
    rec.Kal1  := 4;
    rec.Kal2  := 4;
    rec.CamC  := 9;
    if Pd^.DataSize <> SizeOf(TMemoryAddScr) then Error('AddModelToMemory','DataSize mismatch');
    Pd^.SetData(rec);
    code := GSystem^.ExecView(Pd);
    if code = cmOK then begin
      Pd^.GetData(rec);
      with rec do AddMemory(What,Pesin,Vade,Adet,cift,kal1,kal2,camc);
    end;
    DIspose(Pd,Done);
  end;

  procedure MusteriPrint;
  var
    P:PBasicWindow;
    n:integer;
    c1,c2:comp;
    Pm:PMemoryRec;
  begin
    EventWait;
    P := ObjList^.At(currentModel);
    BeginPrint;
    WritePrn(keycode);
    WritePrn('');
    P^.PrintModel;
    for n:=0 to PriceList^.Count-1 do begin
      Pm := PriceList^.At(n);
      if pm^.include then WritePrn(Fix(Pm^.What,15)+' '+RFix(cn2b(c2s(Pm^.Pesin)),20)+' '+RFix(cn2b(c2s(Pm^.Vade)),20));
    end;
    WritePrn('');
    GetPriceTotals(c1,c2);
    WritePrn(Fix('Toplam',15)+' '+RFix(cn2b(c2s(c1)),20)+' '+RFix(cn2b(c2s(c2)),20));
    EndPrint;
  end;

  procedure ShowMaliyetHesabi;
  var
    P:PBasicWindow;
    Pd:PMaliyetDialog;
  begin
    EventWait;
    P := ObjList^.At(currentModel);
    P^.InitKesimHesabi;
    P^.KesimHesabi;
    P^.DoneKesimHesabi;
    New(Pd,Init);
    GSystem^.ExecView(Pd);
    Dispose(Pd,Done);
  end;

  procedure CamHesabi;
  var
    Pd:PCamDialog;
    Pm:PMemoryRec;
    Pmsr:PMeasure;
    Pc:PCamCollection;
    Pcam:PCamRec;
    code:word;
    n,n1:integer;
    procedure AddCam(width,height:comp; qty:comp);
    var
      subloop:integer;
    begin
      for subloop := 0 to Pc^.Count-1 do begin
        Pcam := Pc^.At(subloop);
        if (Pcam^.Width=width) and
           (Pcam^.Height=height) and
           (Pcam^.Cift = Pm^.Cift) and
           (Pcam^.Kal1 = Pm^.Kal1) and
           (Pcam^.Kal2 = Pm^.Kal2) and
           (Pcam^.Camc = Pm^.Camc) then begin
          Pcam^.Qty := Pcam^.Qty + qty;
          exit;
        end;
      end;
      New(Pcam);
      Pcam^.Cift := Pm^.Cift;
      Pcam^.Kal1 := Pm^.Kal1;
      Pcam^.Kal2 := Pm^.Kal2;
      Pcam^.Camc := Pm^.Camc;
      Pcam^.Qty  := Qty;
      Pcam^.Width := width;
      Pcam^.Height := height;
      Pc^.Insert(Pcam);
    end;
  begin
    if Memory^.Count = 0 then exit;
    EventWait;
    StartPerc('Cam bilgisi toplançyor...');
    New(Pd,Init);
    New(Pc,Init(10,10));
    for n:=0 to Memory^.Count-1 do begin
      UpdatePerc(n,Memory^.Count-1);
      Pm := Memory^.At(n);
      if Pm^.Obj <> NIL then begin
        Pm^.Obj^.InitKesimHesabi;
        Pm^.Obj^.KesimHesabi;
        Pm^.Obj^.DoneKesimHesabi;
        for n1 := 0 to Measures^.Count-1 do begin
          Pmsr := Measures^.At(n1);
          if Pmsr^.MeasureType = mtSquare then if pos('CAM',Upper(Pmsr^.What)) > 0 then
            AddCam(Pmsr^.Width,Pmsr^.Height,Pmsr^.Qty*Pm^.Qty);
        end;
      end;
    end;
    DonePerc;
    Pd^.Lister^.NewList(Pc);
    code := GSystem^.ExecView(Pd);
    Dispose(Pd,Done);
  end;

  procedure Teklif;
  var
    Pm:PMemoryRec;
    pesintotal,vadetotal:comp;
    n:integer;
  begin
    if Memory^.Count = 0 then exit;
    EventWait;
    StartPerc('Yazdçrçlçyor...');
    BeginPrint;
    WritePrn(keycode+' FòAT LòSTESò');
    WritePrn('');
    pesintotal := 0;
    vadetotal  := 0;
    for n:=0 to Memory^.Count-1 do begin
      UpdatePerc(n,Memory^.Count-1);
      Pm := Memory^.At(n);
      WritePrn(Pm^.What);
      MV^.SetBuffer(Pm^.Image);
      Pm^.Obj^.PrintModel;
      WritePrn(RFix(c2s(Pm^.Qty),3)+' adet. ');
      WritePrn(RFix('Peüin = ',18)+RFix(cn2b(c2s(Pm^.Pesin)),20)+' TL');
      WritePrn(RFix('Vadeli= ',18)+RFix(cn2b(c2s(Pm^.Vade)),20)+' TL');
      WritePrn('');
      pesintotal := pesintotal + Pm^.Pesin;
      vadetotal  := vadetotal + Pm^.Vade;
    end;
    WritePrn('');
    WritePrn(RFix('Peüin toplam = ',18)+RFix(cn2b(c2s(pesinTotal)),20)+' TL');
    WritePrn(RFix('Vadeli toplam = ',18)+RFix(cn2b(c2s(vadeTotal)),20)+' TL');
    EndPrint;
    DonePerc;
  end;

  procedure KesimHesabi;
  var
    Pd:PKesimDialog;
    Pl:PMeasureCollection;
    Pm:PMemoryRec;
    Pmsr,Pmsr2:PMeasure;
    Pb:PBasicWindow;
    n1,n2,n3:integer;
    dont_touch:boolean;
  begin
    if Memory^.Count=0 then exit;
    EventWait;
    New(Pl,Init(10,10));
    for n1 := 0 to Memory^.Count-1 do begin
      Pm := Memory^.At(n1);
      with Pm^.Obj^ do begin
        InitKesimHesabi;
        KesimHesabi;
        DoneKesimHesabi;
      end;
      for n2 := 0 to Measures^.Count-1 do begin
        Pmsr := Measures^.At(n2);
        if Pmsr^.PVC then begin
          dont_touch := false;
          for n3 := 0 to Pl^.Count-1 do begin
            Pmsr2 := Pl^.At(n3);
            if SameMeasure(Pmsr,Pmsr2) then begin
              Pmsr2^.Qty := Pmsr2^.Qty + (Pmsr^.Qty*Pm^.Qty);
              dont_touch := true;
              break;
            end;
          end;
          if not dont_touch then begin
            New(Pmsr2);
            Move(Pmsr^,Pmsr2^,SizeOf(TMeasure));
            Pmsr2^.Qty := Pmsr2^.Qty * Pm^.Qty;
            Pl^.Insert(Pmsr2);
          end;
        end;
      end;
    end;
    New(Pd,Init);
    Pd^.Lister^.NewList(Pl);
    Gsystem^.ExecView(Pd);
    Dispose(Pd,Done);
  end;

  procedure FocusModel(P:PMemoryRec);
  begin
    EventWait;
    DisableButtons;
    SetModel(P^.Obj);
    MV^.SetBuffer(P^.Image);
  end;

  procedure SaveFiats;
  var
    T:TDosStream;
    rec:TFiatRec;
    h:TFiatHeader;
    P:PMemoryRec;
    lastpos:longint;
    n:integer;
  begin
    if Memory^.Count = 0 then exit;
    if InputBox('Fiat kaydç','òsim',0,ViewFont,h.Name,39) then begin
      EventWait;
      T.Init(wkdir+priceFile,stOpen);
      if T.Status <> stOK then begin
        T.Done;
        T.Init(wkdir+priceFile,stCreate);
        if T.Status <> stOK then Error('SaveFiats','cannot create '+wkdir+priceFile);
      end;
      T.Seek(T.GetSize);
      h.Date := GetSysMoment;
      h.Items := Memory^.Count;
      lastpos := T.GetPos;
      T.Write(h,SizeOf(h));
      for n:=0 to Memory^.Count-1 do begin
        P := Memory^.At(n);
        rec.What := P^.What;
        rec.ObjIndex := P^.Obj^.Index;
        Move(P^.Image^,rec.Image,mvBufSize);
        rec.Pesin := P^.Pesin;
        rec.Vade := P^.Vade;
        rec.Qty := P^.Qty;
        rec.Kal1 := P^.Kal1;
        rec.Kal2 := P^.Kal2;
        rec.CamC := P^.CamC;
        rec.Cift := P^.Cift;
        rec.Include := P^.Include;
        T.Write(rec,SizeOf(rec));
        P^.Obj^.Store(T);
      end;
      h.Size := T.GetPos-(lastpos+sizeof(h));
      T.Seek(lastpos);
      T.Write(h,SizeOf(h));
      T.Done;
    end;
  end;

  procedure LoadFiats;
  var
    T:TdosStream;
    rec:TFiatRec;
    Pd:PFiatDialog;
    Pc:PFiatHeaderColl;
    Pf:PFiatHeader;
    Pm:PMemoryRec;
    P:PBasicWindow;
    n:integer;
    code:word;
  begin
    T.Init(wkdir+priceFile,stOpenRead);
    if T.Status <> stOK then begin
      T.Done;
      MessageBox('Kayçtlç fiat bilgisi yok',0,mfInfo);
      exit;
    end;
    EventWait;
    StartPerc('YÅkleniyor...');
    New(Pc,Init(10,20));
    while T.GetPos < T.GetSize do begin
      New(Pf);
      T.Read(Pf^,SizeOf(Pf^));
      if T.Status <> stOK then begin
        T.Done;
        Dispose(Pf);
        Dispose(Pc,Done);
        DonePerc;
        MessageBox('Verilerin yÅklenmesinde bir hata oluütu',0,mfError);
        exit;
      end;
      Pf^.Offs := T.GetPos;
      Pc^.Insert(Pf);
      UpdatePerc(T.GetPos,T.GetSize);
      UpdatePercText(Pf^.Name);
      T.Seek(T.GetPos+Pf^.Size);
    end;
    DonePerc;
    New(Pd,Init);
    Pd^.Lister^.NewList(Pc);
    code := GSystem^.ExecView(Pd);
    if code = cmOK then begin
      EventWait;
      Pf := Pc^.At(Pd^.Lister^.FocusedItem);
      T.Seek(Pf^.Offs);
      Dispose(Pd,Done);
      Memory^.FreeAll;
      for n:=0 to Pf^.Items-1 do begin
        T.Read(rec,SizeOf(rec));
        New(Pm);
        Pm^.What := rec.What;
        P := CopyObject(ObjList^.At(rec.ObjIndex));
        Pm^.Obj  := P;
        GetMem(Pm^.Image,mvBufSize);
        Move(rec.Image,Pm^.Image^,mvBufSize);
        Pm^.Pesin := rec.Pesin;
        Pm^.Vade  := rec.Vade;
        Pm^.Qty   := rec.Qty;
        Pm^.Kal1  := rec.Kal1;
        Pm^.Kal2  := rec.Kal2;
        Pm^.CamC  := rec.CamC;
        Pm^.Cift  := rec.Cift;
        Pm^.Include := rec.Include;
        P^.Load(T);
        Memory^.Insert(Pm);
      end;
      MemLister^.Update(memory);
      UpdateMemoryTotals;
    end else Dispose(Pd,DOne);
    T.Done;
  end;

begin
  if Event.What = evKeyDown then if Event.KeyCode = kbEnter then begin
    ReadMeasures;
    ClearEvent(Event);
    exit;
  end;
  inherited handleEvent(Event);
  case Event.What of
    evKeyDown : case Event.KeyCode of
                  kbLeft : SelPrevModel;
                  kbRight : SelNextModel;
                  else exit;
                end; {case}
    evCommand : case Event.Command of
                  cmSelPencere : Sel('P');
                  cmSelKapi    : Sel('K');
                  cmSelBalkon  : Sel('B');
                  cmReadMeasureData : ReadMeasures;
                  cmClearMemory : ClearMemory;
                  cmPesinPrice : ShowMusteriHesabi(false);
                  cmVadePrice : ShowMusteriHesabi(true);
                  cmMaliyetHesabi : ShowMaliyetHesabi;
                  cmAddMemory   : AddModelToMemory;
                  cmTaksitTakibi : TaksitTakipet;
                  cmCamHesabi : CamHesabi;
                  cmTeklif    : Teklif;
                  cmKesimHesabi : KesimHesabi;
                  cmFocusModel : FocusModel(Event.InfoPtr);
                  cmSaveFiats : SaveFiats;
                  cmLoadFiats : LoadFiats;
                  cmPriceTotalChanged : begin
                    UpdatePriceTotals;
                    UpdateMemoryTotals;
                  end;
                  else exit;
                end; {case}
    else exit;
  end; {case}
  ClearEvent(Event);
end;

procedure TPVCCalcWindow.SetModel;
var
  P:PBasicWindow;
  n:integer;
begin
  for n:=0 to ObjList^.Count-1 do begin
    P := ObjList^.At(n);
    if P = amodel then begin
      currentModel := n;
      break;
    end;
  end;
  P := amodel;
  currentType := P^.Kind;
  ModelLabel^.NewText(P^.Kind+l2s(currentModel));
  MV^.Clear;
  P^.Draw;
  MV^.PaintView;
end;

constructor TModelView.Init(x,y:integer; acols,arows:byte);
var
  R:TRect;
begin
  R.Assign(0,0,acols*8+1,arows*GetFontHeight(2)+1);
  R.Move(x,y);
  inherited Init(R);
  Cols := acols;
  Rows := arows;
  GetMem(Buffer,cols*2*rows);
  Clear;
end;

destructor TModelView.Done;
begin
  FreeMem(Buffer,cols*2*rows);
  inherited Done;
end;

procedure TModelView.SetBuffer;
begin
  Move(abuf^,Buffer^,cols*rows*2);
  PaintView;
end;

procedure TModelView.Clear;
begin
  FillWord(Buffer^,cols*rows,$2000);
end;

procedure TModelView.PutChar(x,y,color:byte; c:char);
var
  offs:word;
begin
  offs := ((x-1)*2)+((y-1)*cols*2);
  Buffer[offs] := c;
  Buffer[offs+1] := char(color);
end;

procedure TModelView.SetColor;
var
  offs:word;
begin
  offs := ((x-1)*2)+((y-1)*cols*2);
  Buffer[offs+1] := char(color);
end;

procedure TModelView.PutStr;
var
  ax:byte;
begin
  for ax:=x to x+length(s)-1 do PutChar(ax,y,color,s[(ax-x)+1]);
end;

procedure TModelView.Paint;
var
  R:TRect;
  x,y:byte;
  xx:integer;
  startoffs,offs:word;
  lastcolor:byte;
  s:string;
  xsize:integer;
  color:byte;
  fonth:integer;
  procedure OutStr;
  begin
    SetTextColor(lastcolor,cBlack);
    xsize := GetStringSize(2,s);
    XPrintStr(xx+1,(y-1)*fonth+1,xsize,2,s);
    inc(xx,xsize);
  end;
begin
  PaintBegin;
  GetExtent(R);
  ShadowBox(R,False);
  lastcolor := 255;
  fonth := GetFontHeight(2);
  for y:=1 to rows do begin
    xx := 0;
    s := '';
    startoffs := (y-1)*cols*2;
    for x:=1 to cols do begin
      offs := startoffs + ((x-1)*2);
      color := Byte(Buffer[offs+1]);
      if color = lastcolor then s := s + Buffer[offs] else begin
        if s <> '' then OutStr;
        s := Buffer[offs];
        lastcolor := color;
      end;
    end;
    if s <> '' then outStr;
  end;
  PaintEnd;
end;

procedure DrawBox(x1,y1,x2,y2:byte);
var
  y:integer;
begin
  if MV = NIL then exit;
  with MV^ do begin
    PutStr(x1,y1,DrawColor,cLU+Duplicate(cHZ,(x2-x1)-1)+cRU);
    for y:=y1+1 to y2-1 do begin
      PutStr(x1,y,DrawColor,cVT);
      PutStr(x2,y,DrawColor,cVT);
    end;
    PutStr(x1,y2,DrawColor,cLD+Duplicate(cHZ,(x2-x1)-1)+cRD);
  end;
end;

procedure DrawHLine(x1,x2,y:byte);
begin
  if MV = NIL then exit;
  with MV^ do PutStr(x1,y,DrawColor,Duplicate(cHZ,(x2-x1)+1));
end;

procedure DrawVLine(x,y1,y2:byte);
var
  y:byte;
begin
  if MV = NIL then exit;
  with MV^ do for y:=y1 to y2 do PutChar(x,y,DrawColor,cVT);
end;

function CopyLine(x,y,len:byte):string;
var
  ax:byte;
  offs:word;
  s:string;
begin
  s := '';
  if MV <> NIL then begin
    for ax:=x to x+len-1 do begin
      offs := (((ax-1)*2)+((y-1)*MV^.cols*2));
      if MV^.Buffer[offs+1] <> #0 then s := s + MV^.Buffer[offs]
                                  else s := s + #32;
    end;
  end;
  CopyLine := s;
end;

procedure DrawSolidBox(x1,y1,x2,y2:byte);
var
  y:byte;
begin
  if MV <> NIL then for y:=y1 to y2 do MV^.PutStr(x1,y,DrawColor,Duplicate('/',(x2-x1)+1));
end;

function TMeasureCollection.Compare;
var
  p1,p2:PMeasure;
begin
  p1 := k1;
  p2 := k2;
  if (p1^.What < p2^.What) then Compare := -1 else Compare := 1;
end;

procedure TMeasureCollection.FreeItem;
begin
  Dispose(PMeasure(item));
end;

procedure TPriceColl.FreeItem;
begin
  Dispose(PPriceRec(item));
end;

procedure TMemoryColl.FreeItem;
begin
  FreeMem(PMemoryRec(item)^.Image,mvBufSize);
  Dispose(PMemoryRec(item)^.Obj,Done);
  Dispose(PMemoryRec(item));
end;

{---}
procedure TCiftAcilir.Draw;
begin
  inherited Draw;
  DrawBox(2,2,15,ysize-1);
  DrawBox(16,2,xsize-1,ysize-1);
end;

procedure TCiftAcilir.KesimHesabi;
var
  icXGAP:comp;
  icYGAP:comp;
begin
  CalcOutKasa;
  icXGAP := ((kasaWidth-(kasathick*2))/2)-(setup.PencThick*2);
  icYGAP := (kasaHeight-(kasathick*2))-(setup.PencThick*2);
  CalcOut(rdLeft, icXGAP, icYGAP);
  CalcOut(rdRight, icXGAP, icYGAP);
end;

procedure TCiftAcilir.MusteriHesabi;
begin
  totalPVC := (kasaWidth*2)+(kasaHeight*2);
  CalcMusteriPenc(kasaWidth/2,kasaHeight);
  CalcMusteriPenc(kasaWidth/2,kasaHeight);
  AddMusteriCam(kasaHeight);
end;

{---}
procedure T1Balkon.Store;
begin
  inherited Store(T);
  T.Write(middleGAP,SizeOf(middleGAP));
  T.Write(lamHeight,SizeOf(lamHeight));
  T.Write(region2,SizeOf(region2));
end;

procedure T1Balkon.Load;
begin
  inherited Load(T);
  T.Read(middleGAP,SizeOf(middleGAP));
  T.Read(lamHeight,SizeOf(lamHeight));
  T.Read(region2,SizeOf(region2));
end;

constructor T1Balkon.Init;
begin
  inherited Init;
  xsize := 6;
end;

procedure T1Balkon.OutModel;
begin
  TBasicWindow.OutModel;
  mOut(1,6,c2s(middleGAP));
  mOut(1,9,c2s(lamHeight));
end;

procedure T1Balkon.Draw;
begin
  DrawBox(1,1,xsize,ysize);
  DrawHline(2,xsize-1,3);
  DrawHLine(2,xsize-1,7);
  DrawSolidBox(2,8,xsize-1,ysize-1);
end;

procedure T1Balkon.ReadBalkonData;
begin
  NRegInput('Orta bosluk mesafesi (mm)',1,3,1,7,middleGAP);
  NRegInput('Lambri yuksekligi (mm)',1,7,1,9,lamHeight);
end;

procedure T1Balkon.ReadData;
begin
  ReadBalkonData;
end;

function T1Balkon.GetRegionList;
begin
  GetRegionList :=
    NewRegion(2,2,xsize-1,2,@region1,
    NewRegion(2,4,xsize-1,6,@region2,
    NIL));
end;

procedure T1Balkon.KesimHesabi;
var
  FirstGAP:comp;
  okGAP:comp;
begin
  CalcOutKasa;
  FirstGAP := kasaWidth-(kasathick*2);
  okGAP := kasaHeight-(lamHeight+((kasathick+setup.Okthick)*2)+middleGAP);
  CalcOutKayit(2,FirstGAP);
  CalcOutLambri(FirstGAP,lamheight);
  CalcOut(region1, FirstGAP, okGAP);
  CalcOut(region2, FirstGAP, middleGAP);
end;

procedure T1Balkon.MusteriHesabi;
var
  okGAP:comp;
begin
  totalPVC := (kasaWidth*4)+(kasaHeight*2);
  okGAP := kasaHeight-(lamHeight+middleGAP);
  if region1>0 then CalcMusteriPenc(kasaWidth,okGAP);
  if region2>0 then CalcMusteriPenc(kasaWidth,middleGAP);
  AddMusteriLambri(kasaWidth, lamHeight);
  AddMusteriCam(kasaHeight-lamHeight);
end;

{---}
procedure T2Balkon.Load;
begin
  inherited Load(T);
  T.Read(region3,SizeOf(region3));
  T.Read(region4,SizeOf(region4));
end;

procedure T2Balkon.Store;
begin
  inherited Store(T);
  T.Write(region3,SizeOf(region3));
  T.Write(region4,SizeOf(region4));
end;

constructor T2Balkon.Init;
begin
  TBasicWindow.Init;
  xsize := 12;
  InitWidths(2);
end;

procedure T2Balkon.OutModel;
begin
  T1Balkon.OutModel;
  OutRegions;
end;

procedure T2Balkon.Draw;
begin
  T1Balkon.Draw;
  DrawVLine(6,2,ysize-1);
end;

procedure T2Balkon.ReadData;
begin
  ReadBalkonData;
  AskGen(region1 or region3, 1);
  AskGen(region2 or region4, 2);
end;

function T2Balkon.GetRegionList;
begin
  GetRegionList :=
    NewRegion(2,2,5,2,@region1,
    NewRegion(7,2,xsize-1,2,@region2,
    NewRegion(2,4,5,6,@region3,
    NewRegion(7,4,xsize-1,6,@region4,
    NIL))));
end;

procedure T2Balkon.KesimHesabi;
var
  okGAP:comp;
begin
  CalcOutKasa;
  AdjustWidths(true);
  okGAP := kasaHeight-(lamHeight+((kasathick+setup.Okthick)*2)+middleGAP);
  CalcOutKayit(2,rw^[1]);
  CalcOutKayit(2,rw^[2]);
  CalcOutLambri(rw^[1],lamheight);
  CalcOutLambri(rw^[2],lamheight);
  CalcOut(region1, rw^[1], okGAP);
  CalcOut(region2, rw^[2], okGAP);
  CalcOut(region3, rw^[1],middleGAP);
  CalcOut(region4, rw^[2],middleGAP);
end;

procedure T2Balkon.MusteriHesabi;
var
  okGAP:comp;
begin
  totalPVC := (kasaWidth*4)+(kasaHeight*3);
  AdjustWidths(false);
  okGAP := kasaHeight-(middleGAP+lamHeight);
  if region1>0 then CalcMusteriPenc(rw^[1],okGAP);
  if region2>0 then CalcMusteriPenc(rw^[2],okGAP);
  if region3>0 then CalcMusteriPenc(rw^[1],middleGAP);
  if region4>0 then CalcMusteriPenc(rw^[2],middleGAP);
  AddMusteriLambri(kasaWidth, lamHeight);
  AddMusteriCam(kasaHeight-lamHeight);
end;

{--}
procedure T3Balkon.Store;
begin
  inherited Store(T);
  T.Write(region5,SizeOf(region5));
  T.Write(region6,SizeOf(region6));
end;

procedure T3Balkon.Load;
begin
  inherited Load(T);
  T.Read(region5,SizeOf(region5));
  T.Read(region6,SizeOf(region6));
end;

constructor T3Balkon.Init;
begin
  TBasicWindow.Init;
  xsize := 18;
  InitWidths(3);
end;

procedure T3Balkon.Draw;
begin
  inherited Draw;
  DrawVLine(12,2,ysize-1);
end;

procedure T3Balkon.ReadData;
begin
  ReadBalkonData;
  AskGen(region1 or region4, 1);
  AskGen(region2 or region5, 2);
  AskGen(region3 or region6, 3);
end;

function T3Balkon.GetRegionList;
begin
  GetRegionList :=
    NewRegion(2,2,5,2,@region1,
    NewRegion(7,2,11,2,@region2,
    NewRegion(13,2,xsize-1,2,@region3,
    NewRegion(2,4,5,6,@region4,
    NewRegion(7,4,11,6,@region5,
    NewRegion(13,4,xsize-1,6,@region6,
    NIL))))));
end;

procedure T3Balkon.KesimHesabi;
var
  okGAP:comp;
begin
  CalcOutKasa;
  AdjustWidths(true);
  okGAP := kasaHeight-(lamHeight+((kasathick+setup.Okthick)*2)+middleGAP);
  CalcOutKayit(2,rw^[1]);
  CalcOutKayit(2,rw^[2]);
  CalcOutKayit(2,rw^[3]);
  CalcOutLambri(rw^[1],lamheight);
  CalcOutLambri(rw^[2],lamheight);
  CalcOutLambri(rw^[3],lamheight);
  CalcOut(region1, rw^[1], okGAP);
  CalcOut(region2, rw^[2], okGAP);
  CalcOut(region3, rw^[3], okGAP);
  CalcOut(region4, rw^[1],middleGAP);
  CalcOut(region5, rw^[2],middleGAP);
  CalcOut(region6, rw^[3],middleGAP);
end;

procedure T3Balkon.MusteriHesabi;
var
  OkGAP:comp;
begin
  totalPVC := (kasaWidth*4)+(kasaHeight*4);
  AdjustWidths(false);
  okGAP := kasaHeight-(middleGAP+lamHeight);
  if region1>0 then CalcMusteriPenc(rw^[1],okGAP);
  if region2>0 then CalcMusteriPenc(rw^[2],okGAP);
  if region3>0 then CalcMusteriPenc(rw^[3],okGAP);
  if region4>0 then CalcMusteriPenc(rw^[1],middleGAP);
  if region5>0 then CalcMusteriPenc(rw^[2],middleGAP);
  if region6>0 then CalcMusteriPenc(rw^[3],middleGAP);
  AddMusteriLambri(kasaWidth, lamHeight);
  AddMusteriCam(kasaHeight-lamHeight);
end;

{--}
procedure T4Balkon.Store;
begin
  inherited Store(T);
  T.Write(region7,SizeOf(region7));
  T.Write(region8,SizeOf(region8));
end;

procedure T4Balkon.Load;
begin
  inherited Load(T);
  T.Read(region7,Sizeof(region7));
  T.read(region8,SizeOf(region8));
end;

constructor T4Balkon.Init;
begin
  TBasicWindow.Init;
  xsize := 24;
  InitWidths(4);
end;

procedure T4Balkon.Draw;
begin
  inherited Draw;
  DrawVLine(18,2,ysize-1);
end;

procedure T4Balkon.ReadData;
begin
   ReadBalkonData;
   AskGen(region1 or region5, 1);
   AskGen(region2 or region6, 2);
   AskGen(region3 or region7, 3);
   AskGen(region4 or region8, 4);
end;

function T4Balkon.GetRegionList;
begin
  GetRegionList :=
    NewRegion(2,2,5,2,@region1,
    NewRegion(7,2,11,2,@region2,
    NewRegion(13,2,17,2,@region3,
    NewRegion(19,2,23,2,@region4,
    NewRegion(2,4,5,6,@region5,
    NewRegion(7,4,11,6,@region6,
    NewRegion(13,4,17,6,@region7,
    NewRegion(19,4,23,6,@region8,
    NIL))))))));
end;

procedure T4Balkon.KesimHesabi;
var
  okGAP:comp;
begin
  CalcOutKasa;
  AdjustWidths(true);
  okGAP := kasaHeight-(lamHeight+((kasathick+setup.Okthick)*2)+middleGAP);
  CalcOutKayit(2,rw^[1]);
  CalcOutKayit(2,rw^[2]);
  CalcOutKayit(2,rw^[3]);
  CalcOutKayit(2,rw^[4]);
  CalcOutLambri(rw^[1],lamheight);
  CalcOutLambri(rw^[2],lamheight);
  CalcOutLambri(rw^[3],lamheight);
  CalcOutLambri(rw^[4],lamheight);
  CalcOut(region1, rw^[1], okGAP);
  CalcOut(region2, rw^[2], okGAP);
  CalcOut(region3, rw^[3], okGAP);
  CalcOut(region4, rw^[4], okGAP);
  CalcOut(region5, rw^[1],middleGAP);
  CalcOut(region6, rw^[2],middleGAP);
  CalcOut(region7, rw^[3],middleGAP);
  CalcOut(region8, rw^[4],middleGAP);
end;

procedure T4Balkon.MusteriHesabi;
var
  okGAP:comp;
begin
  totalPVC := (kasaWidth*4)+(kasaHeight*5);
  AdjustWidths(false);
  okGAP := kasaHeight-(middleGAP+lamHeight);
  if region1>0 then CalcMusteriPenc(rw^[1],okGAP);
  if region2>0 then CalcMusteriPenc(rw^[2],okGAP);
  if region3>0 then CalcMusteriPenc(rw^[3],okGAP);
  if region4>0 then CalcMusteriPenc(rw^[4],okGAP);
  if region5>0 then CalcMusteriPenc(rw^[1],middleGAP);
  if region6>0 then CalcMusteriPenc(rw^[2],middleGAP);
  if region7>0 then CalcMusteriPenc(rw^[3],middleGAP);
  if region8>0 then CalcMusteriPenc(rw^[4],middleGAP);
  AddMusteriLambri(kasaWidth, lamHeight);
  AddMusteriCam(kasaHeight-lamHeight);
end;

{--}
constructor T5Balkon.Init;
begin
  TBasicWindow.Init;
  xsize := 30;
  InitWidths(5);
end;

procedure T5Balkon.Store;
begin
  inherited Store(T);
  T.write(region9,SizeOf(region9));
  T.Write(region10,SizeOf(region10));
end;

procedure T5Balkon.Load;
begin
  inherited Load(T);
  T.Read(region9,SizeOf(region9));
  T.Read(region10,SizeOf(region10));
end;

procedure T5Balkon.Draw;
begin
  inherited Draw;
  DrawVLine(24,2,ysize-1);
end;

procedure T5Balkon.ReadData;
begin
  ReadBalkonData;
  AskGen(region1 or region6, 1);
  AskGen(region2 or region7, 2);
  AskGen(region3 or region8, 3);
  AskGen(region4 or region9, 4);
  AskGen(region5 or region10, 5);
end;

function T5Balkon.GetRegionList;
begin
  GetRegionList :=
    NewRegion(2,2,5,2,@region1,
    NewRegion(7,2,11,2,@region2,
    NewRegion(13,2,17,2,@region3,
    NewRegion(19,2,23,2,@region4,
    NewRegion(25,2,29,2,@region5,
    NewRegion(2,4,5,6,@region6,
    NewRegion(7,4,11,6,@region7,
    NewRegion(13,4,17,6,@region8,
    NewRegion(19,4,23,6,@region9,
    NewRegion(25,4,29,6,@region10,
    NIL))))))))));
end;

procedure T5Balkon.KesimHesabi;
var
  okGAP:comp;
begin
  CalcOutKasa;
  AdjustWidths(true);
  okGAP := kasaHeight-(lamHeight+((kasathick+setup.Okthick)*2)+middleGAP);
  CalcOutKayit(2,rw^[1]);
  CalcOutKayit(2,rw^[2]);
  CalcOutKayit(2,rw^[3]);
  CalcOutKayit(2,rw^[4]);
  CalcOutKayit(2,rw^[5]);
  CalcOutLambri(rw^[1],lamheight);
  CalcOutLambri(rw^[2],lamheight);
  CalcOutLambri(rw^[3],lamheight);
  CalcOutLambri(rw^[4],lamheight);
  CalcOutLambri(rw^[5],lamheight);
  CalcOut(region1, rw^[1], okGAP);
  CalcOut(region2, rw^[2], okGAP);
  CalcOut(region3, rw^[3], okGAP);
  CalcOut(region4, rw^[4], okGAP);
  CalcOut(region5, rw^[5], okGAP);
  CalcOut(region6, rw^[1],middleGAP);
  CalcOut(region7, rw^[2],middleGAP);
  CalcOut(region8, rw^[3],middleGAP);
  CalcOut(region9, rw^[4],middleGAP);
  CalcOut(region10, rw^[5],middleGAP);
end;

procedure T5Balkon.MusteriHesabi;
var
  okGAP:comp;
begin
  totalPVC := (kasaWidth*4)+(kasaHeight*6);
  AdjustWidths(false);
  okGAP := kasaHeight-(middleGAP+lamHeight);
  if region1>0  then CalcMusteriPenc(rw^[1],okGAP);
  if region2>0  then CalcMusteriPenc(rw^[2],okGAP);
  if region3>0  then CalcMusteriPenc(rw^[3],okGAP);
  if region4>0  then CalcMusteriPenc(rw^[4],okGAP);
  if region5>0  then CalcMusteriPenc(rw^[5],okGAP);
  if region6>0  then CalcMusteriPenc(rw^[1],middleGAP);
  if region7>0  then CalcMusteriPenc(rw^[2],middleGAP);
  if region8>0  then CalcMusteriPenc(rw^[3],middleGAP);
  if region9>0  then CalcMusteriPenc(rw^[4],middleGAP);
  if region10>0 then CalcMusteriPenc(rw^[5],middleGAP);
  AddMusteriLambri(kasaWidth, lamHeight);
  AddMusteriCam(kasaHeight-lamHeight);
end;

{---}
procedure T1SBalkon.Store;
begin
  inherited Store(T);
  T.Write(lamHeight,SizeOf(lamHeight));
end;

procedure T1SBalkon.Load;
begin
  inherited Load(T);
  T.Read(lamHeight,SizeOf(LamHeight));
end;

constructor T1SBalkon.Init;
begin
  inherited Init;
  xsize := 6;
end;

procedure T1SBalkon.OutModel;
begin
  TBasicWindow.OutModel;
  mOut(1,9,c2s(lamHeight));
end;

procedure T1SBalkon.Draw;
begin
  DrawBox(1,1,xsize,ysize);
  DrawHLine(2,xsize-1,7);
  DrawSolidBox(2,8,xsize-1,ysize-1);
end;

procedure T1SBalkon.ReadBalkonData;
begin
  NRegInput('Lambri yuksekligi (mm)',1,7,1,9,lamHeight);
end;

procedure T1SBalkon.ReadData;
begin
  ReadBalkonData;
end;

function T1SBalkon.GetRegionList;
begin
  GetRegionList :=
    NewRegion(2,2,xsize-1,6,@region1,NIL);
end;

procedure T1SBalkon.KesimHesabi;
var
  okGAP:comp;
  FirstGAP:comp;
begin
  CalcOutKasa;
  FirstGAP := kasaWidth-(kasathick*2);
  okGAP := kasaHeight-((kasathick*2)+lamHeight+setup.okThick);
  CalcOutKayit(1,FirstGAP);
  CalcOutLambri(FirstGAP,lamheight);
  CalcOut(region1, FirstGAP, okGAP);
end;

procedure T1SBalkon.MusteriHesabi;
var
  okGAP:comp;
begin
  totalPVC := (kasaWidth*3)+(kasaHeight*2);
  okGAP := kasaHeight-lamHeight;
  if region1>0 then CalcMusteriPenc(kasaWidth,okGAP);
  AddMusteriLambri(kasaWidth, lamHeight);
  AddMusteriCam(kasaHeight-lamHeight);
end;

{---}
procedure T2SBalkon.Store;
begin
  inherited Store(T);
  T.Write(region2,SizeOf(region2));
end;

procedure T2SBalkon.Load;
begin
  inherited Load(T);
  T.Write(region2,SizeOf(region2));
end;

constructor T2SBalkon.Init;
begin
  TBasicWindow.Init;
  xsize := 12;
  INitWidths(2);
end;

procedure T2SBalkon.OutModel;
begin
  T1SBalkon.OutModel;
  OutRegions;
end;

procedure T2SBalkon.Draw;
begin
  inherited Draw;
  DrawVLine(6,2,ysize-1);
end;

procedure T2SBalkon.ReadData;
begin
  ReadBalkonData;
  AskGen(region1, 1);
  AskGen(region2, 2);
end;

function T2SBalkon.GetRegionList;
begin
  GetRegionList :=
    NewRegion(2,2,5,6,@region1,
    NewRegion(7,2,xsize-1,6,@region2,
    NIL));
end;

procedure T2SBalkon.KesimHesabi;
var
  middleGAP:comp;
begin
  CalcOutKasa;
  ADjustWidths(true);
  middleGAP := kasaHeight-(lamHeight+(kasaThick*2)+(setup.okThick));
  CalcOutKayit(1,rw^[1]);
  CalcOutKayit(1,rw^[2]);
  CalcOutLambri(rw^[1],lamheight);
  CalcOutLambri(rw^[2],lamheight);
  CalcOut(region1, rw^[1], middleGAP);
  CalcOut(region2, rw^[2], middleGAP);
end;

procedure T2SBalkon.MusteriHesabi;
var
  middleGAP:comp;
begin
  totalPVC  := (kasaWidth*3)+(kasaHeight*3);
  AdjustWidths(false);
  middleGAP := kasaHeight-lamHeight;
  if region1>0 then CalcMusteriPenc(rw^[1],middleGAP);
  if region2>0 then CalcMusteriPenc(rw^[2],middleGAP);
  AddMusteriLambri(kasaWidth, lamHeight);
  AddMusteriCam(kasaHeight-lamHeight);
end;

{--}
procedure T3SBalkon.Store;
begin
  inherited Store(T);
  T.Write(region3,SizeOf(region3));
end;

procedure T3SBalkon.Load;
begin
  inherited Load(T);
  T.Read(region3,SizeOf(region3));
end;

constructor T3SBalkon.Init;
begin
  TBasicWIndow.Init;
  xsize := 18;
  InitWidths(3);
end;

procedure T3SBalkon.Draw;
begin
  inherited Draw;
  DrawVLine(12,2,ysize-1);
end;

procedure T3SBalkon.ReadData;
begin
  ReadBalkonData;
  AskGen(region1, 1);
  AskGen(region2, 2);
  AskGen(region3, 3);
end;

function T3SBalkon.GetRegionList;
begin
  GetRegionList :=
    NewRegion(2,2,5,6,@region1,
    NewRegion(7,2,11,6,@region2,
    NewRegion(13,2,xsize-1,6,@region3,
    NIL)));
end;

procedure T3SBalkon.KesimHesabi;
var
  middleGAP:comp;
begin
  CalcOutKasa;
  AdjustWIdths(true);
  middleGAP := kasaHeight-(lamHeight+(kasaThick*2)+(setup.okThick));
  CalcOutKayit(1,rw^[1]);
  CalcOutKayit(1,rw^[2]);
  CalcOutKayit(1,rw^[3]);
  CalcOutLambri(rw^[1],lamheight);
  CalcOutLambri(rw^[2],lamheight);
  CalcOutLambri(rw^[3],lamheight);
  CalcOut(region1, rw^[1], middleGAP);
  CalcOut(region2, rw^[2], middleGAP);
  CalcOut(region3, rw^[3], middleGAP);
end;

procedure T3SBalkon.MusteriHesabi;
var
  middleGAP:comp;
begin
  totalPVC := (kasaWidth*3)+(kasaHeight*4);
  AdjustWidths(false);
  middleGAP := kasaHeight-lamHeight;
  if region1>0 then CalcMusteriPenc(rw^[1],middleGAP);
  if region2>0 then CalcMusteriPenc(rw^[2],middleGAP);
  if region3>0 then CalcMusteriPenc(rw^[3],middleGAP);
  AddMusteriLambri(kasaWidth, lamHeight);
  AddMusteriCam(kasaHeight-lamHeight);
end;

{--}
procedure T4SBalkon.Store;
begin
  inherited Store(T);
  T.Write(region4,SizeOf(region4));
end;

procedure T4SBalkon.Load;
begin
  inherited Load(T);
  T.Read(region4,SizeOf(region4));
end;

constructor T4SBalkon.Init;
begin
  TBasicWindow.Init;
  xsize := 24;
  InitWidths(4);
end;

procedure T4SBalkon.Draw;
begin
  inherited Draw;
  DrawVLine(18,2,ysize-1);
end;

procedure T4SBalkon.ReadData;
begin
  ReadBalkonData;
  AskGen(region1, 1);
  AskGen(region2, 2);
  AskGen(region3, 3);
  AskGen(region4, 4);
end;

function T4SBalkon.GetRegionList;
begin
  GetRegionList :=
    newRegion(2,2,5,6,@region1,
    newRegion(7,2,11,6,@region2,
    newRegion(13,2,17,6,@region3,
    newRegion(19,2,23,6,@region4,
    NIL))));
end;

procedure T4SBalkon.KesimHesabi;
var
  middleGAP:comp;
begin
  CalcOutKasa;
  AdjustWidths(true);
  middleGAP := kasaHeight-(lamHeight+(kasaThick*2)+(setup.okThick));
  CalcOutKayit(1,rw^[1]);
  CalcOutKayit(1,rw^[2]);
  CalcOutKayit(1,rw^[3]);
  CalcOutKayit(1,rw^[4]);
  CalcOutLambri(rw^[1],lamheight);
  CalcOutLambri(rw^[2],lamheight);
  CalcOutLambri(rw^[3],lamheight);
  CalcOutLambri(rw^[4],lamheight);
  CalcOut(region1, rw^[1],middleGAP);
  CalcOut(region2, rw^[2],middleGAP);
  CalcOut(region3, rw^[3],middleGAP);
  CalcOut(region4, rw^[4],middleGAP);
end;

procedure T4SBalkon.MusteriHesabi;
var
  middleGAP:comp;
begin
  totalPVC := (kasaWidth*3)+(kasaHeight*5);
  AdjustWidths(false);
  middleGAP := kasaHeight-lamHeight;
  if region1>0 then CalcMusteriPenc(rw^[1],middleGAP);
  if region2>0 then CalcMusteriPenc(rw^[2],middleGAP);
  if region3>0 then CalcMusteriPenc(rw^[3],middleGAP);
  if region4>0 then CalcMusteriPenc(rw^[4],middleGAP);
  AddMusteriLambri(kasaWidth, lamHeight);
  AddMusteriCam(kasaHeight-lamHeight);
end;

{--}
procedure T5SBalkon.Store;
begin
  inherited Store(T);
  T.Write(region5,SizeOf(region5));
end;

procedure T5SBalkon.Load;
begin
  inherited Load(T);
  T.Read(region5,SizeOf(region5));
end;

constructor T5SBalkon.Init;
begin
  TBasicWindow.Init;
  xsize := 30;
  InitWidths(5);
end;

procedure T5SBalkon.Draw;
begin
  inherited Draw;
  DrawVLine(24,2,ysize-1);
end;

procedure T5SBalkon.ReadData;
begin
  ReadBalkonData;
  AskGen(region1, 1);
  AskGen(region2, 2);
  AskGen(region3, 3);
  AskGen(region4, 4);
  AskGen(region5, 5);
end;

function T5SBalkon.GetRegionList;
begin
  GetRegionList :=
    NewRegion(2,2,5,6,@region1,
    NewRegion(7,2,11,6,@region2,
    NewRegion(13,2,17,6,@region3,
    NewRegion(19,2,23,6,@region4,
    NewRegion(25,2,29,6,@region5,
    NIL)))));
end;

procedure T5SBalkon.KesimHesabi;
var
  middleGAP:comp;
begin
  CalcOutKasa;
  AdjustWidths(true);
  middleGAP := kasaHeight-(lamHeight+(kasaThick*2)+(setup.okThick));
  CalcOutKayit(1,rw^[1]);
  CalcOutKayit(1,rw^[2]);
  CalcOutKayit(1,rw^[3]);
  CalcOutKayit(1,rw^[4]);
  CalcOutKayit(1,rw^[5]);
  CalcOutLambri(rw^[1],lamheight);
  CalcOutLambri(rw^[2],lamheight);
  CalcOutLambri(rw^[3],lamheight);
  CalcOutLambri(rw^[4],lamheight);
  CalcOutLambri(rw^[5],lamheight);
  CalcOut(region1, rw^[1],middleGAP);
  CalcOut(region2, rw^[2],middleGAP);
  CalcOut(region3, rw^[3],middleGAP);
  CalcOut(region4, rw^[4],middleGAP);
  CalcOut(region5, rw^[5],middleGAP);
end;

procedure T5SBalkon.MusteriHesabi;
var
  middleGAP:comp;
begin
  totalPVC := (kasaWidth*3)+(kasaHeight*6);
  AdjustWidths(false);
  middleGAP := kasaHeight-lamHeight;
  if region1>0 then CalcMusteriPenc(rw^[1],middleGAP);
  if region2>0 then CalcMusteriPenc(rw^[2],middleGAP);
  if region3>0 then CalcMusteriPenc(rw^[3],middleGAP);
  if region4>0 then CalcMusteriPenc(rw^[4],middleGAP);
  if region5>0 then CalcMusteriPenc(rw^[5],middleGAP);
  AddMusteriLambri(kasaWidth, lamHeight);
  AddMusteriCam(kasaHeight-lamHeight);
end;

{---}
procedure TSUstDoor.Store;
begin
  inherited Store(T);
  T.Write(okGAP,SizeOf(okGAP));
end;

procedure TSUstDoor.Load;
begin
  inherited Load(T);
  T.Read(okGAp,SizeOf(okGAP));
end;

procedure TSUstDoor.OutModel;
begin
  TBasicWindow.OutModel;
  mOut(1,3,c2s(okGAP));
  mOut(1,9,c2s(lamHeight));
end;

procedure TSUstDoor.Draw;
begin
  DrawBox(1,1,xsize,ysize);
  DrawBox(2,5,xsize-1,ysize-1);
  DrawHLine(2,xsize-1,4);
  DrawHLine(3,xsize-2,ysize-4);
  DrawSolidBox(3,ysize-3,xsize-2,ysize-2);
end;

procedure TSUstDoor.ReadData;
begin
  NRegInput('Ust cam yuksekligi (mm)',1,1,1,3,okGAP);
  NRegInput('Lambri yuksekligi (mm)',1,7,1,10,LamHeight);
end;

procedure TSUstDoor.MusteriHesabi;
var
  subprice:comp;
begin
  totalKAPI := (kasaWidth*2)+((kasaHeight-okGAP)*2);
  totalPVC := (kasaWidth*3)+(kasaHeight*2);
  AddMusteriLambri(kasaWidth,lamHeight);
  AddMusteriCam(kasaHeight-lamHeight);
end;

procedure TSUstDoor.KesimHesabi;
var
  icWidth,icHeight:comp;
begin
  CalcOutKasa;
  icWidth   := (kasaWidth-(kasathick*2));
  icHeight  := (kasaHeight-(kasathick*2)-(okGAP+setup.okThick));
  CalcOutCam(icWidth,okGAP);
  CalcOutKapi(icWidth,icHeight);
  CalcOutKayit(1,icWidth);
  icWidth := icWidth-(setup.kapiThick*2)+setup.pencFire;
  icHeight := icHeight-(setup.kapiThick*2)+setup.PencFire;
  CalcOutKayit(1,icWidth);
  CalcOutLambri(icWidth,lamHeight);
  CalcOutCam(icWidth,icHeight-(Setup.okThick+lamHeight));
end;

{---}
constructor TCamDoor.Init;
begin
  inherited init;
  xsize := 12;
  ysize := 15;
end;

procedure TCamDoor.Draw;
begin
  inherited Draw;
  DrawBox(2,2,xsize-1,ysize-1);
end;

procedure TCamDoor.MusteriHesabi;
begin
  totalPVC := (kasaWidth*2)+(kasaheight*2);
  totalKAPI := (kasaWidth*2)+(kasaHeight*2);
  AddMusteriCam(kasaHeight);
end;

procedure TCamDoor.KesimHesabi;
var
  icWidth,icHeight:comp;
begin
  CalcOutKasa;
  icWidth := kasaWidth-(kasathick*2);
  icHeight := kasaHeight-(kasathick*2);
  CalcOutKapi(icWidth,icHeight);
  icWidth := icWidth-(setup.KapiThick*2);
  icHeight := icHeight-(setup.KapiThick*2);
  CalcOutCam(icWidth,icHeight);
end;

{---}
procedure TSCamDoor.Store;
begin
  inherited Store(T);
  T.Write(lamHeight,SizeOf(lamHeight));
  T.Write(kapiKanadi,SizeOf(kapiKanadi));
end;

procedure TSCamDoor.Load;
begin
  inherited Load(T);
  T.Read(lamHeight,SizeOf(lamHeight));
  T.Read(kapikanadi,SizeOf(kapikanadi));
end;

constructor TSCamDoor.Init;
begin
  inherited Init;
  xsize := 12;
  ysize := 15;
end;

procedure TSCamDoor.OutModel;
begin
  TBasicWIndow.OutModel;
  mOut(1,9,c2s(lamHeight));
end;

procedure TSCamDoor.Draw;
begin
  DrawBox(1,1,xsize,ysize);
  DrawBox(2,2,xsize-1,ysize-1);
  DrawHLine(3,xsize-2,ysize-4);
  DrawSolidBox(3,ysize-3,xsize-2,ysize-2);
end;

procedure TSCamDoor.ReadData;
begin
  NRegInput('Lambri yuksekligi (mm)',1,7,1,10,LamHeight);
end;

procedure TSCamDoor.MusteriHesabi;
var
  subprice:comp;
begin
  totalKAPI := (kasaWidth*2)+(kasaHeight*2);
  totalPVC := (kasaWidth*3)+(kasaHeight*2);
  AddMusteriLambri(kasaWidth,lamHeight);
  AddMusteriCam(kasaHeight-lamHeight);
end;

procedure TSCamDoor.KesimHesabi;
var
  realGAP:comp;
  icWidth,icHeight:comp;
begin
  CalcOutKasa;
  realGAP   := lamHeight + kasathick + setup.okthick;
  icWidth   := (kasaWidth-(kasathick*2));
  icHeight  := (kasaHeight-(kasathick*2));
  CalcOutKapi(icWidth,icHeight);
  icWidth := icWidth-(setup.kapiThick*2)+setup.pencFire;
  icHeight := icHeight-(setup.kapiThick*2)+setup.PencFire;
  CalcOutKayit(1,icWidth);
  CalcOutLambri(icWidth,lamHeight);
  CalcOutCam(icWidth,icHeight-(Setup.okThick+lamHeight));
end;

{---}
procedure TDortluWindow.Store;
begin
  inherited Store(T);
  T.Write(region2,SizeOf(region2));
  T.Write(region3,SizeOf(region3));
  T.Write(region4,SizeOf(region4));
end;

procedure TDortluWindow.Load;
begin
  inherited Load(T);
  T.Read(region2,SizeOf(region2));
  T.Read(region3,Sizeof(region3));
  T.Read(region4,SizeOf(region4));
end;

constructor TDortluWindow.Init;
begin
  inherited Init;
  xsize  := 24;
  InitWidths(4);
end;

function TDortluWindow.GetRegionList:PRegion;
begin
  GetRegionList :=
    NewRegion(2,2,5,9,@region1,
    NewRegion(7,2,11,9,@region2,
    NewRegion(13,2,17,9,@region3,
    NewRegion(19,2,xsize-1,9,@region4,
    NIL))));
end;

procedure TDortluWindow.ReadData;
begin
  AskGen(region1,1);
  AskGen(region2,2);
  AskGen(region3,3);
  AskGen(region4,4);
end;

procedure TDortluWindow.Draw;
begin
  DrawBox(1,1,xsize,ysize);
  DrawVLine(6,2,ysize-1);
  DrawVLine(12,2,ysize-1);
  DrawVLine(18,2,ysize-1);
end;

procedure TDortluWindow.KesimHesabi;
var
  ickasa:comp;
begin
  CalcOutKasa;
  AdjustWidths(true);
  ickasa := kasaheight-(kasathick*2);
  CalcOutKayit(3,ickasa);
  CalcOut(region1,rw^[1],ickasa);
  CalcOut(region2,rw^[2],ickasa);
  CalcOut(region3,rw^[3],ickasa);
  CalcOut(region4,rw^[4],ickasa);
end;

procedure TDortluWindow.MusteriHesabi;
begin
  AdjustWidths(false);
  totalPVC := (kasaWidth*2)+(kasaHeight*5);
  if region1>0 then CalcMusteriPenc(rw^[1],kasaHeight);
  if region2>0 then CalcMusteriPenc(rw^[2],kasaHeight);
  if region3>0 then CalcMusteriPenc(rw^[3],kasaHeight);
  if region4>0 then CalcMusteriPenc(rw^[4],kasaHeight);
  AddMusteriCam(kasaHeight);
end;

{---}
procedure TBesliWindow.Store;
begin
  inherited Store(T);
  T.Write(region5,Sizeof(region5));
end;

procedure TBesliWindow.Load;
begin
  inherited Load(T);
  T.Read(region5,SizeOf(region5));
end;

constructor TBesliWindow.Init;
begin
  TBasicWindow.Init;
  xsize  := 30;
  InitWidths(5);
end;

function TBesliWindow.GetRegionList:PRegion;
begin
  GetRegionList :=
    NewRegion(2,2,5,9,@region1,
    NewRegion(7,2,11,9,@region2,
    NewRegion(13,2,17,9,@region3,
    NewRegion(19,2,23,9,@region4,
    NewRegion(25,2,xsize-1,9,@region5,
    NIL)))));
end;

procedure TBesliWindow.ReadData;
begin
  AskGen(region1,1);
  AskGen(region2,2);
  AskGen(region3,3);
  AskGen(region4,4);
  AskGen(region5,5);
end;

procedure TBesliWindow.Draw;
begin
  DrawBox(1,1,xsize,ysize);
  DrawVLine(6,2,ysize-1);
  DrawVLine(12,2,ysize-1);
  DrawVLine(18,2,ysize-1);
  DrawVLine(24,2,ysize-1);
end;

procedure TBesliWindow.KesimHesabi;
var
  ickasa:comp;
begin
  CalcOutKasa;
  AdjustWidths(true);
  ickasa := kasaheight-(kasathick*2);
  CalcOutKayit(4,ickasa);
  CalcOut(region1,rw^[1],ickasa);
  CalcOut(region2,rw^[2],ickasa);
  CalcOut(region3,rw^[3],ickasa);
  CalcOut(region4,rw^[4],ickasa);
  CalcOut(region5,rw^[5],ickasa);
end;

procedure TBesliWindow.MusteriHesabi;
begin
  AdjustWidths(false);
  totalPVC := (kasaWidth*2)+(kasaHeight*6);
  if region1>0 then CalcMusteriPenc(rw^[1],kasaHeight);
  if region2>0 then CalcMusteriPenc(rw^[2],kasaHeight);
  if region3>0 then CalcMusteriPenc(rw^[3],kasaHeight);
  if region4>0 then CalcMusteriPenc(rw^[4],kasaHeight);
  if region5>0 then CalcMusteriPenc(rw^[5],kasaHeight);
  AddMusteriCam(kasaHeight);
end;

{---}
procedure TQSliceWindow.Store;
begin
  inherited Store(T);
  T.Write(region7,SizeOf(region7));
  T.Write(region8,SizeOf(region8));
end;

procedure TQSliceWindow.Load;
begin
  inherited Load(T);
  T.Read(region7,SizeOf(region7));
  T.Read(region8,SizeOf(region8));
end;

constructor TQSliceWindow.init;
begin
  inherited init;
  xsize := 24;
  InitWidths(4);
end;

procedure TQSliceWindow.Draw;
begin
  DrawBox(1,1,xsize,ysize);
  DrawHLine(2,xsize-1,4);
  DrawVLine(6,2,ysize-1);
  DrawVLine(12,2,ysize-1);
  DrawVLine(18,2,ysize-1);
end;

procedure TQSliceWindow.ReadData;
begin
  NRegInput('Yatay orta kayçt mesafesi (mm)',6,1,6,4,okGAP);
  AskGen(region1 or region5,1);
  AskGen(region2 or region6,2);
  AskGen(region3 or region7,3);
  AskGen(region4 or region8,4);
end;

function TQSliceWindow.GetRegionList;
begin
  GetRegionList :=
    NewRegion(2,2,5,3,@region1,
    NewRegion(7,2,11,3,@region2,
    NewRegion(13,2,17,3,@region3,
    NewRegion(19,2,23,3,@region4,
    NewRegion(2,5,5,9,@region5,
    NewRegion(7,5,11,9,@region6,
    NewRegion(13,5,17,9,@region7,
    NewRegion(19,5,23,9,@region8,
    NIL))))))));
end;

procedure TQSliceWindow.KesimHesabi;
var
  realGAP:comp;
  ickasa,altkasa:comp;
begin
  CalcOutKasa;
  AdjustWidths(true);
  realGAP   := okGAP + kasathick + setup.okthick;
  ickasa := kasaheight-(kasathick*2);
  altkasa := kasaheight-(realgap+kasathick);
  CalcOutKayit(3,ickasa);
  CalcOutKayit(1,rw^[1]);
  CalcOutKayit(1,rw^[2]);
  CalcOutKayit(1,rw^[3]);
  CalcOutKayit(1,rw^[4]);
  CalcOut(region1,rw^[1],okGAP);
  CalcOut(region2,rw^[2],okGAP);
  CalcOut(region3,rw^[3],okGAP);
  CalcOut(region4,rw^[4],okGAP);
  CalcOut(region5,rw^[1],altkasa);
  CalcOut(region6,rw^[2],altkasa);
  CalcOut(region7,rw^[3],altkasa);
  CalcOut(region8,rw^[4],altkasa);
end;

procedure TQSliceWindow.MusteriHesabi;
begin
  AdjustWidths(false);
  totalPVC := (kasaWidth*3)+(kasaHeight*5);
  if region1>0 then CalcMusteriPenc(rw^[1],okGAP);
  if region2>0 then CalcMusteriPenc(rw^[2],okGAP);
  if region3>0 then CalcMusteriPenc(rw^[3],okGAP);
  if region4>0 then CalcMusteriPenc(rw^[4],okGAP);
  if region5>0 then CalcMusteriPenc(rw^[1],kasaHeight-(okGAP));
  if region6>0 then CalcMusteriPenc(rw^[2],kasaHeight-(okGAP));
  if region7>0 then CalcMusteriPenc(rw^[3],kasaHeight-(okGAP));
  if region8>0 then CalcMusteriPenc(rw^[4],kasaHeight-(okGAP));
  AddMusteriCam(kasaHeight);
end;

{--}
procedure THexWindow.Store;
begin
  inherited Store(T);
  T.Write(region6,SizeOf(region6));
end;

procedure THexWindow.Load;
begin
  inherited Load(T);
  T.Read(region6,SizeOf(region6));
end;

procedure THexWindow.Draw;
begin
  TDWingWindow.Draw;
  DrawHLine(2,8,4);
  DrawHLine(10,20,4);
  DrawHLine(22,xsize-1,4);
end;

procedure THexWindow.ReadData;
begin
  NRegInput('Yatay orta kayçt mesafesi (mm)',9,1,9,4,okGAP);
  AskGen(region1 or region4,1);
  AskGen(region2 or region5,2);
  AskGen(region3 or region6,3);
end;

function THexWindow.GetRegionList;
begin
  GetRegionList :=
    NewRegion(2,2,8,3,@region1,
    NewRegion(11,2,20,3,@region2,
    NewRegion(23,2,29,3,@region3,
    NewRegion(2,5,8,9,@region4,
    NewRegion(11,5,20,9,@region5,
    NewRegion(23,5,29,9,@region6,
    NIL))))));
end;

procedure THexWindow.KesimHesabi;
var
  realGAP:comp;
  altkasa:comp;
begin
  CalcOutKasa;
  AdjustWidths(true);
  realGAP   := okGAP + kasathick + Setup.okthick;
  altkasa := kasaHeight-(realGAP+kasathick);
  CalcOutKayit(2,(kasaHeight-(kasathick*2)));
  CalcOutKayit(1,rw^[1]);
  CalcOutKayit(1,rw^[2]);
  CalcOutKayit(1,rw^[3]);
  CalcOut(region1,rw^[1],okGAP);
  CalcOut(region2,rw^[2],okGAP);
  CalcOut(region3,rw^[3],okGAP);
  CalcOut(region4,rw^[1],altkasa);
  CalcOut(region5,rw^[2],altkasa);
  CalcOut(region6,rw^[3],altkasa);
end;

procedure THexWindow.MusteriHesabi;
begin
  AdjustWidths(false);
  totalPVC := (kasaWidth*3)+(kasaHeight*4);
  if region1>0 then CalcMusteriPenc(rw^[1],okGAP);
  if region2>0 then CalcMusteriPenc(rw^[2],okGAP);
  if region3>0 then CalcMusteriPenc(rw^[3],okGAP);
  if region4>0 then CalcMusteriPenc(rw^[1],kasaHeight-okGAP);
  if region5>0 then CalcMusteriPenc(rw^[2],kasaHeight-okGAP);
  if region6>0 then CalcMusteriPenc(rw^[3],kasaHeight-okGAP);
  AddMusteriCam(kasaHeight);
end;

{---}
procedure TQCrossWindow.Store;
begin
  inherited Store(T);
  T.Write(firstGAP,SizeOf(firstGAP));
  T.Write(okGAP,SizeOf(okGAP));
  T.Write(region2,SizeOf(region2));
end;

procedure TQCrossWindow.Load;
begin
  inherited Load(T);
  T.Read(firstGAP,SizeOf(firstGAP));
  T.Read(okGAP,SizeOf(okGAP));
  T.Read(region2,SizeOf(region2));
end;

procedure TQCrossWindow.OutModel;
begin
  TBasicWindow.OutModel;
  mOut(1,3,c2s(okGAP));
  mOut(7,ysize+2,c2s(FirstGAP));
end;

procedure TQCrossWindow.Draw;
begin
  DrawBox(1,1,xsize,ysize);
  DrawVLine(9,2,ysize-1);
  DrawHLine(2,8,4);
  DrawHLine(10,xsize-1,4);
end;

procedure TQCrossWindow.ReadData;
begin
  NRegInput('1. bîlge geniülißi (mm)',1,1,9,1,FirstGAP);
  NRegInput('Yatay orta kayçt mesafesi (mm)',9,1,9,4,okGAP);
end;

function TQCrossWindow.GetRegionList;
begin
  GetRegionList :=
    NewRegion(2,5,8,9,@region1,
    NewRegion(2,2,8,3,@region2,
    NIL));
end;

procedure TQCrossWindow.KesimHesabi;
var
  realFirst:comp;
  realGAP:comp;
begin
  CalcOutKasa;
  realFirst := FirstGAP + kasathick + Setup.okthick;
  realGAP   := okGAP + kasathick + Setup.okthick;
  CalcOutKayit(1,(kasaHeight-(kasathick*2)));
  CalcOutKayit(1,FirstGAP);
  CalcOutKayit(1,(kasaWidth-(realFirst+kasathick)));
  CalcOut(region1, FirstGAP, kasaHeight-(realFirst+kasathick));
  CalcOut(region2, FirstGAP, okGAP);
  CalcOutCam(kasaWidth-(realFirst+kasathick), kasaHeight-(realFirst+kasathick));
end;

procedure TQCrossWindow.MusteriHesabi;
begin
  totalPVC := (kasaWidth*3)+(kasaHeight*3);
  if region1>0 then CalcMusteriPenc(FirstGAP,kasaHeight-okGAP);
  if region2>0 then CalcMusteriPenc(FirstGAP,okGAP);
  AddMusteriCam(kasaHeight);
end;

{---}
procedure TFruko.Load;
begin
  inherited Load(T);
  T.Read(region4,SizeOf(region4));
  T.Read(region5,SizeOf(region5));
  T.Read(region6,SizeOf(region6));
  T.Read(firstHeight,SizeOf(firstHeight));
end;

procedure TFruko.Store;
begin
  inherited Store(T);
  T.Write(region4,SizeOf(region4));
  T.Write(region5,SizeOf(region5));
  T.Write(region6,SizeOf(region6));
  T.Write(firstHeight,SizeOf(firstHeight));
end;

function TFruko.GetRegionList:PRegion;
begin
  GetRegionList :=
    NewRegion(2,2,8,3,@region1,
    NewRegion(10,2,20,6,@region2,
    NewRegion(22,2,29,3,@region3,
    NewRegion(2,5,8,9,@region4,
    NEwRegion(10,8,20,9,@region5,
    NewRegion(22,5,29,9,@region6,
    NIL))))));
end;

procedure TFruko.Draw;
begin
  inherited Draw; {9 - 21}
  DrawHLine(2,8,4);
  DrawHLine(10,20,7);
  DrawHLine(22,xsize-1,4);
end;

procedure TFruko.ReadData;
begin
  NRegInput('Yatay kayçt yÅkseklißi (mm)',1,5,1,ysize,firstHeight);
  AskGen(region1 or region4,1);
  AskGen(region2 or region5,2);
  AskGen(region3 or region6,3);
end;

procedure TFruko.KesimHesabi;
var
  okGAP:comp;
begin
  CalcOutKasa;
  AdjustWidths(true);
  okGAP := kasaHeight-((kasathick*2)+(firstHeight)+(setup.okThick));
  CalcOutKayit(2,kasaHeight-(kasathick*2));
  CalcOutKayit(1,rw^[1]);
  CalcOutKayit(1,rw^[2]);
  CalcOutKayit(1,rw^[3]);
  CalcOut(region1,rw^[1],okGAP);
  CalcOut(region2,rw^[2],firstHeight);
  CalcOut(region3,rw^[3],okGAP);
  CalcOut(region4,rw^[1],firstHeight);
  CalcOut(region5,rw^[2],okGAP);
  CalcOut(region6,rw^[3],firstHeight);
end;

procedure TFruko.MusteriHesabi;
var
  okGAP:comp;
begin
  totalPVC := (kasaWidth*3)+(kasaHeight*4);
  AdjustWidths(false);
  okGAP := kasaHeight-firstHeight;
  if region1>0 then CalcMusteriPenc(rw^[1],okGAP);
  if region2>0 then CalcMusteriPenc(rw^[2],firstHeight);
  if region3>0 then CalcMusteriPenc(rw^[3],okGAP);
  if region4>0 then CalcMusteriPenc(rw^[1],firstHeight);
  if region5>0 then CalcMusteriPenc(rw^[2],okGAP);
  if region6>0 then CalcMusteriPenc(rw^[3],firstHeight);
  AddMusteriCam(kasaHeight);
end;


{---}
procedure TDWingWindow.Store;
begin
  inherited Store(T);
  T.Write(region2,SizeOf(region2));
  T.Write(region3,SizeOf(region3));
end;

procedure TDwingWindow.Load;
begin
  inherited Load(T);
  T.Read(region2,SizeOf(region2));
  T.Read(region3,SizeOf(region3));
end;

constructor TDwingWIndow.INit;
begin
  inherited Init;
  InitWidths(3);
end;

procedure TDwingWindow.OutModel;
begin
  TBasicWindow.OutModel;
  OutRegions;
end;

procedure TDWingWindow.Draw;
begin
  inherited Draw;
  DrawVLine(9,2,ysize-1);
  DrawVLine(21,2,ysize-1);
end;

procedure TDWingWindow.ReadData;
begin
  AskGen(region1,1);
  AskGen(region2,2);
  AskGen(region3,3);
end;

function TDwingWindow.GetRegionList;
begin
  GetRegionList :=
    NewRegion(2,2,8,9,@region1,
    NewRegion(10,2,20,9,@region2,
    NewRegion(22,2,29,9,@region3,
    NIL)));
end;

procedure TDWingWindow.KesimHesabi;
var
  ickasa:comp;
begin
  CalcOutKasa;
  AdjustWidths(true);
  ickasa := kasaHeight-(kasathick*2);
  CalcOutKayit(2,ickasa);
  CalcOut(region1, rw^[1], ickasa);
  CalcOut(region2, rw^[2], ickasa);
  CalcOut(region3, rw^[3], ickasa);
end;

procedure TDWingWindow.MusteriHesabi;
begin
  totalPVC := (kasaWidth*2)+(kasaHeight*4);
  AdjustWidths(false);
  if region1>0 then CalcMusteriPenc(rw^[1],kasaHeight);
  if region2>0 then CalcMusteriPenc(rw^[2],kasaHeight);
  if region3>0 then CalcMusteriPenc(rw^[3],kasaHeight);
  AddMusteriCam(kasaHeight);
end;

{---}
constructor TSWingWindow.Init;
begin
  TBasicWindow.Init;
  xsize := 21;
end;

procedure TSWingWindow.Store;
begin
  inherited Store(T);
  T.Write(FirstGAP,SizeOf(FirstGAP));
end;

procedure TSWingWIndow.Load;
begin
  inherited Load(T);
  T.Read(FirstGAP,SizeOf(FirstGAP));
end;

procedure TSWingWindow.OutModel;
begin
  TBasicWindow.OutModel;
  mOut(7,ysize+2,c2s(FirstGAP));
end;

procedure TSWingWindow.Draw;
begin
  DrawBox(1,1,xsize,ysize);
  DrawVLine(9,2,ysize-1);
end;

procedure TSWingWindow.ReadData;
begin
  NRegInput('1. bîlge geniülißi (mm)',1,1,9,1,FirstGAP);
end;

function TSWingWindow.GetRegionList;
begin
  GetRegionList := NewRegion(2,2,8,9,@region1,NIL);
end;

procedure TSWingWindow.KesimHesabi;
begin
  CalcOutKasa;
  CalcOutKayit(1,(kasaHeight-(kasathick*2)));
  CalcOutCam(kasaWidth-((kasaThick*2)+setup.okThick+FirstGAP),kasaHeight-(kasathick*2));
  CalcOut(region1,FirstGAP,kasaHeight-(kasathick*2));
end;

procedure TSWingWindow.MusteriHesabi;
begin
  totalPVC := (kasaWidth*2)+(kasaHeight*3);
  if region1>0 then CalcMusteriPenc(FirstGAP,kasaHeight);
  AddMusteriCam(kasaHeight);
end;

{---}
procedure THQuadWindow.Store;
begin
  inherited Store(T);
  T.Write(okGAP,SizeOf(okGAP));
end;

procedure THQuadWindow.Load;
begin
  inherited Load(T);
  T.Read(okGAP,SizeOf(okGAP));
end;

procedure THQuadWindow.OutModel;
begin
  TDWingWindow.OutModel;
  mOut(1,3,c2s(okGAP));
end;

procedure THQuadWindow.KesimHesabi;
var
  realGAP:comp;
  ickasa:comp;
begin
  CalcOutKasa;
  AdjustWidths(true);
  realGAP   := okGAP + kasathick + Setup.okthick;
  ickasa := kasaHeight-(kasathick*2);
  CalcOutKayit(2,ickasa);
  CalcOutKayit(1,rw^[2]);
  CalcOutCam(rw^[2],kasaHeight-(realGAP+kasathick));
  CalcOut(region1, rw^[1], ickasa);
  CalcOut(region2, rw^[2], okGAP);
  CalcOut(region3, rw^[3], ickasa);
end;

procedure THQuadWindow.MusteriHesabi;
begin
  AdjustWIdths(false);
  totalPVC := (kasaWidth*2)+(kasaHeight*4)+rw^[2];
  if region1>0 then CalcMusteriPenc(rw^[1],kasaHeight);
  if region2>0 then CalcMusteriPenc(rw^[2],okGAP);
  if region3>0 then CalcMusteriPenc(rw^[3],kasaHeight);
  AddMusteriCam(kasaHeight);
end;

procedure THQuadWindow.ReadData;
begin
  NRegInput('Yatay orta kayçt mesafesi (mm)',9,1,9,4,okGAP);
  AskGen(region1,1);
  AskGen(region2,2);
  AskGen(region3,3);
end;

function THQuadWindow.GetRegionList;
begin
  GetRegionList :=
    NewRegion(2,2,8,9,@region1,
    NewRegion(10,2,20,3,@region2,
    NewRegion(22,2,29,9,@region3,
    NIL)));
end;

procedure THQuadWindow.Draw;
begin
  inherited Draw;
  DrawHLine(10,20,4);
end;

{---}
procedure THReverseWindow.Store;
begin
  inherited Store(T);
  T.Write(region4,SizeOf(region4));
  T.Write(region5,SizeOf(region5));
end;

procedure THReverseWindow.Load;
begin
  inherited Load(T);
  T.Read(region4,SizeOf(region4));
  T.Read(region5,SizeOf(region5));
end;

procedure THReverseWindow.KesimHesabi;
var
  realGAP:comp;
  ickasa:comp;
begin
  CalcOutKasa;
  AdjustWidths(true);
  ickasa := kasaheight-(kasathick*2);
  realGAP   := okGAP + kasathick + Setup.okthick;
  CalcOutKayit(2,ickasa);
  CalcOutKayit(2,rw^[1]);
  CalcOut(region1, rw^[1], okGAP);
  CalcOut(region2, rw^[2], ickasa);
  CalcOut(region3, rw^[3], okGAP);
  CalcOut(region4, rw^[1], kasaHeight-(realGAP+kasathick));
  CalcOut(region5, rw^[3], kasaHeight-(realGAP+kasathick));
end;

procedure THReverseWindow.MusteriHesabi;
begin
  AdjustWidths(false);
  totalPVC := (kasaWidth*2)+(kasaHeight*4)+(rw^[1]+rw^[3]);
  if region1>0 then CalcMusteriPenc(rw^[1],okGAP);
  if region2>0 then CalcMusteriPenc(rw^[2],kasaHeight);
  if region3>0 then CalcMusteriPenc(rw^[3],okGAP);
  if region4>0 then CalcMusteriPenc(rw^[1],kasaHeight-okGAP);
  if region5>0 then CalcMusteriPenc(rw^[3],kasaHeight-okGAP);
  AddMusteriCam(kasaHeight);
end;

procedure THReverseWindow.ReadData;
begin
  NRegInput('Yatay orta kayçt mesafesi (mm)',9,1,9,4,okGAP);
  AskGen(region1 or region4,1);
  AskGen(region2,2);
  AskGen(region3 or region5,3);
end;

function THReverseWIndow.GetRegionList;
begin
  GetRegionList :=
    NewRegion(2,2,8,3,@region1,
    NewRegion(10,2,20,ysize-1,@region2,
    NewRegion(22,2,29,3,@region3,
    NewRegion(2,5,8,9,@region4,
    NewRegion(22,5,29,9,@region5,
    NIL)))));
end;

procedure THReverseWindow.Draw;
begin
  TDwingWindow.Draw;
  DrawHLine(2,8,4);
  DrawHLine(22,29,4);
end;

procedure TLambri.Draw;
begin
  inherited Draw;
  DrawSolidBox(2,2,xsize-1,ysize-1);
end;

procedure TLambri.MusteriHesabi;
begin
  totalPVC := (kasaWidth*2)+(kasaHeight*2);
  AddMusteriLambri(kasaWIdth,kasaHeight);
end;

procedure TLambri.KesimHesabi;
begin
  CalcOutKasa;
  CalcOutLambri(kasaWidth-(kasaThick*2),kasaHeight-(kasathick*2));
end;

{---}
procedure TBasicWindow.Store;
begin
  T.Write(clone^,rn*SizeOf(comp));
  T.Write(kasaWidth,SizeOf(comp));
  T.Write(kasaHeight,SizeOf(comp));
  T.Write(kasathick,Sizeof(comp));
  T.Write(superKasa,SizeOf(boolean));
  T.Write(region1,SizeOf(byte));
  T.Write(kind,SizeOf(kind));
end;

procedure TBasicWindow.Load;
begin
  T.Read(clone^,rn*SizeOf(comp));
  T.Read(kasaWidth,SizeOf(comp));
  T.Read(kasaHeight,SizeOf(comp));
  T.Read(kasathick,Sizeof(comp));
  T.Read(superKasa,SizeOf(boolean));
  T.Read(region1,SizeOf(byte));
  T.Read(kind,SizeOf(kind));
end;

procedure TBasicWindow.OutRegions;
var
  b:byte;
begin
  AdjustWidths(true);
  for b:=1 to rn do if rw^[b] > 0 then mOut(((b-1)*(xsize div rn))+7,ysize+2,c2s(rw^[b]));
end;

procedure TBasicWIndow.AdjustWidths(kesim:boolean);
var
  total:byte;
  totalWidth:comp;
  delta:comp;
  other:byte;
  n:byte;
begin
  if rw = NIL then Error('TBasicWindow.AdjustWidths','rw = NIL');
  Move(clone^,rw^,rn*SizeOf(comp));
  totalWidth := 0;
  total := 0;
  for n:=1 to rn do if clone^[n] > 0 then totalWidth := totalWidth + clone^[n]
                                    else inc(total);
  if total = 0 then exit;
  if kesim then totalWidth := kasaWidth-(totalWidth+(kasathick*2)+(setup.okThick*(rn-1)))
           else totalWidth := kasaWidth-totalWidth;
  delta := totalWidth/total;
  other := 0;
  for n:=1 to rn do if clone^[n] = 0 then begin
    inc(other);
    if other = total then break;
    rw^[n] := delta;
  end;
  other := n;
  if kesim then totalWidth := (kasathick*2)+(setup.okThick*(rn-1))
           else totalWidth := 0;
  for n:=1 to rn do begin
    totalWidth := totalWidth + clone^[n];
  end;
  totalWidth := totalWidth + ((total-1)*delta);
  rw^[other] := kasaWidth-totalWidth;
end;

procedure TBasicWindow.mOut;
var
  b:byte;
begin
  for b:=1 to length(s) do PrinterBuffer[x+(b-1),y] := s[b];
end;

procedure TBasicWindow.FlushModel;
var
  s:string;
  x,y:byte;
begin
  for y:=1 to 66 do begin
    s := '';
    for x:=1 to 80 do s := s + PrinterBuffer[x,y];
    for x:=1 to length(s) do if s[x] <> #32 then begin
      WritePrn(s);
      Break;
    end;
  end;
  WritePrn('');
end;

procedure TBasicWindow.OutModel;
var
  s:string;
  y:byte;
begin
  mOut(1,1,Kind+l2s(currentModel));
  mOut(((xsize-4) div 2)+6,1,c2s(kasaWidth));
  mOut(xsize+8,(ysize div 2)+2,c2s(kasaHeight));
  for y:=1 to ysize do mOut(6,y+1,CopyLine(1,y,xsize));
end;

procedure TBasicWindow.InitWidths(regn:byte);
begin
  if rw <> NIL then begin
    FreeMem(rw,SizeOf(comp)*rn);
    FreeMem(clone,SizeOf(comp)*rn);
  end;
  rn := regn;
  GetMem(rw,SizeOf(comp)*rn);
  GetMem(clone,SizeOf(comp)*rn);
  FillChar(rw^,SizeOf(comp)*rn,0);
  FillChar(clone^,SizeOf(comp)*rn,0);
end;

procedure TBasicWindow.DoneWidths;
begin
  if rw <> NIL then begin
    FreeMem(rw,SizeOf(comp)*rn);
    FreeMem(clone,SizeOf(comp)*rn);
    rw := NIL;
  end;
end;

function SameMeasure(p1,p2:PMeasure):boolean;
begin
  SameMeasure := false;
  if (p1^.MeasureType = p2^.MeasureType) and (p1^.What=p2^.What) then begin
    case p1^.MeasureType of
      mtSquare : SameMeasure := (p1^.Width=p2^.Width) and (p1^.height=p2^.Height);
      mtLong   : SameMeasure := (p1^.Length = p2^.Length);
      mtItem   : SameMeasure := true;
    end; {case}
  end;
end;

procedure TBasicWindow.AddMeasure;
var
  P:PMeasure;
  rec:TMeasure;
  n:integer;
begin
  if qty = 0 then exit;
  rec.What := what;
  rec.PVC  := PVC;
  rec.Width := x1;
  rec.Height := x2;
  rec.Qty    := Qty;
  rec.MeasureType := MeasureType;
  rec.Price := price;
  for n:=0 to Measures^.Count-1 do begin
    P := Measures^.At(n);
    if SameMeasure(p,@rec) then begin
      P^.Qty := P^.qty + qty;
      P^.Price := P^.Price + price;
      exit;
    end;
  end;
  New(P);
  Move(rec,P^,SizeOf(TMeasure));
  Measures^.Insert(P);
end;

procedure TBasicWindow.CalcOutKasa;
var
  kasaName:string;
begin
  if superKasa then kasaName := skStr
               else kasaName := ekStr;
  CalcOutPVC(2,kasaWidth+Setup.kaynakFire,kasaName);
  CalcOutPVC(2,kasaHeight+Setup.kaynakFire,kasaName);
end;

{---}
procedure TTuranjWindow.Load;
begin
  inherited Load(T);
  T.Read(region2,SizeOf(region2));
  T.Read(okGAP,SizeOf(okGAP));
end;

procedure TTuranjWindow.Store;
begin
  inherited Store(T);
  T.Write(region2,SizeOf(region2));
  T.Write(okGAP,SizeOf(okGAP));
end;

procedure TTuranjWindow.Draw;
begin
  inherited Draw;
  DrawHLine(2,xsize-1,4);
end;

function TTuranjWindow.GetRegionList:PRegion;
begin
  GetRegionList :=
    NewRegion(2,2,xsize-1,3,@region1,
    NewRegion(2,5,xsize-1,ysize-1,@region2,
    NIL));
end;

procedure TTuranjWindow.ReadData;
begin
  NRegInput('Yatay kayçt mesafesi (mm)',1,1,1,4,okGAP);
end;

procedure TTuranjWindow.KesimHesabi;
var
  icWidth:comp;
begin
  CalcOutKasa;
  icWidth := kasaWidth-(kasaThick*2);
  CalcOutKayit(1,icWidth);
  CalcOut(region1,icWidth,okGAP);
  CalcOut(region2,icWidth,kasaHeight-((kasathick*2)+okGAP+Setup.okThick));
end;

procedure TTuranjWindow.MusteriHesabi;
begin
  totalPVC := (kasaWidth*3)+(kasaHeight*2);
  if region1>0 then CalcMusteriPenc(kasaWidth,okGAP);
  if region2>0 then CalcMusteriPenc(kasaWidth,kasaHeight-okGAP);
  AddMusteriCam(kasaHeight);
end;

{---}
constructor TEmptyWindow.Init;
begin
  inherited Init;
  xsize := xsize div 2;
end;

function TEmptyWindow.GetRegionList;
begin
  GetRegionList :=
    NewRegion(2,2,xsize-1,9,@region1,
    NIL);
end;

constructor TBasicWindow.Init;
begin
  inherited init;
  xsize := 30;
  ysize := 10;
end;

destructor TBasicWindow.Done;
begin
  DoneWidths;
  inherited DOne;
end;

procedure TBasicWindow.AddMusteriLambri;
begin
  totalLambri := totalLambri + (width*height);
end;

procedure TBasicWIndow.AddMusteriCam;
begin
  totalCAM := totalCAM + (kasaWidth*Height);
end;

procedure TBasicWindow.FinalizeMusteri;
  function CalcPrice(pvcm,kapim,lam2,kopuk,pencaksesuar,kapiaksesuar,cam2:comp; var kdv:comp):comp;
  var
    totalPrice:comp;
  begin
    totalPrice := ((totalPVC/1000)*PVCM)+
                  ((totalKAPI/1000)*KAPIM)+
                  ((totalLambri/1000000)*Lam2)+
                  Kopuk+(totalAksesuar*PencAksesuar);
    if Kind = 'K' then totalPrice := totalPrice + KapiAksesuar;
    KDV := (totalPrice*15)/100;
    totalPrice := totalPrice+KDV+((totalCam/1000000)*cam2);
  end;
begin
  with Setup do begin
    totalPesin := CalcPrice(PVCM,KapiM,LAM2,Kopuk,PencAksesuar,KapiAksesuar,CAM2,PesinKDV);
    totalVade  := CalcPrice(vPVCM,vKapiM,vLAM2,vKopuk,vPencAksesuar,vKapiAksesuar,vCAM2,VadeKDV);
  end;
end;

function GetNearestIspanyolet(aheight:comp):PIspanyolet;
var
  P:PIspanyolet;
  n:integer;
  minval:comp;
  best:PIspanyolet;
begin
  aheight := aheight-(setup.ISPFark);
  best := NIL;
  minval := 0;
  for n:=0 to ISPList^.Count-1 do begin
    P := ISPList^.At(n);
    if best = NIL then begin
      best := P;
      minval := abs(aheight-P^.Length);
    end else if abs(aheight-P^.Length) < minval then begin
      best := P;
      minval := abs(aheight-P^.Length);
    end;
  end;
  GetNearestIspanyolet := best;
end;

procedure TBasicWindow.CalcOut;
var
  P:PIspanyolet;
begin
  if penc>0 then begin
    P := GetNearestIspanyolet(height);
    if P <> NIL then AddMeasure(mtLong,false,'òspanyolet',1,P^.Length,0,P^.Price);
    totalAksesuar := totalAksesuar + 1;
    width := width + Setup.pencFire;
    height := height + setup.PencFire;
    CalcOutCam(width-(Setup.pencthick*2),height-(Setup.pencthick*2));
    width := width + Setup.kaynakFire;
    height := height + Setup.kaynakFire;
    AddMeasure(mtLong,true,pkStr,2,width,0,2*(Width/1000)*Setup.mPVCM);
    AddMeasure(mtLong,true,pkStr,2,height,0,2*(Height/1000)*Setup.mPVCM);
    TotalPVC := totalPVC + (width*2)+(height*2);
  end else CalcOutCam(width,height);
end;

procedure TBasicWindow.CalcOutCam;
begin
  width := width - Setup.camFire;
  Height := height - Setup.camFire;
  totalCam := totalCam + (width*height);
  AddMeasure(mtLong,false,ccStr,2,width,0,2*(width/1000)*Setup.mCamcM);
  AddMeasure(mtLong,false,ccStr,2,height,0,2*(height/1000)*Setup.mCamcM);
  AddMeasure(mtSquare, false,'Cam',1,width, height,((width*height)/1000000)*Setup.mCAM2);
end;

procedure TBasicWindow.CalcOutLambri;
begin
  width := width - Setup.camFire;
  Height := height - Setup.camFire;
  totalLambri := totalLambri + (width*height);
  AddMeasure(mtSquare, true,'Lambri',1,width, height,((width*height)/1000000)*Setup.mLAM2);
end;

procedure TBasicWindow.CalcOutPVC;
begin
  AddMeasure(mtLong, true,what, qty, length,0,qty*(length/1000)*Setup.mPVCM);
  totalPVC := totalPVC + (length*qty);
end;

procedure TBasicWindow.CalcOutKapi;
begin
  CalcOutPVC(2,Width+Setup.pencFire+Setup.kaynakFire,kkStr);
  CalcOutPVC(2,Height+Setup.pencFire+Setup.kaynakFire,kkStr);
end;

procedure TBasicWindow.CalcOutKayit;
begin
  length := length + Setup.kayitFire;
  AddMeasure(mtLong, true,okStr, qty, length,0,qty*(length/1000)*Setup.mPVCM);
  totalPVC := totalPVC + (length*qty);
  totalZivana := totalZivana + (2*qty);
end;

procedure TBasicWindow.Draw;
begin
  DrawBox(1,1,xsize,ysize);
end;

procedure TBasicWindow.ReadData;
begin
end;

function TBasicWindow.GetRegionList;
begin
  GetRegionList := NIL;
end;

procedure TBasicWindow.KesimHesabi;
begin
  CalcOutKasa;
  CalcOut(region1,kasaWidth-(kasaThick*2),kasaHeight-(kasaThick*2));
end;

procedure TBasicWindow.MusteriHesabi;
begin
  totalPVC := (kasaWidth*2)+(kasaHeight*2);
  CalcMusteriPenc(kasaWidth,kasaHeight);
  AddMusteriCam(kasaHeight);
end;

procedure TBasicWindow.CalcMusteriPenc;
begin
  totalPVC := totalPVC + (width*2) + (height*2);
  totalAksesuar := totalAksesuar + 1;
end;

procedure TBasicWindow.PrintModel;
begin
  FillChar(PrinterBuffer,SizeOf(PrinterBuffer),#32);
  OutModel;
  FlushModel;
end;

procedure TBasicWindow.AskGen;
var
  sx:byte;
begin
  sx := ((regn-1)*(xsize div rn))+1;
  if ask>0 then NRegInput(l2s(regn)+'. bîlge geniülißi (mm)',sx,1,sx+((xsize div rn)-2),1,rw^[regn])
           else rw^[regn] := 0;
end;

procedure TBasicWindow.initMusteriHesabi;
begin
  ResetVars;
end;

procedure TBasicWindow.DoneMusteriHesabi;
var
  length:comp;
begin
  FinalizeMusteri;
  AddPrice(x2s(totalPVC/1000,3,2)+'mtÅl PVC',(totalPVC/1000)*setup.PVCM,(totalPVC/1000)*setup.vPVCM,true);
  AddPrice(x2s(totalKAPI/1000,3,2)+'mtÅl Kapç',(totalKAPI/1000)*setup.KAPIM,(totalKAPI/1000)*setup.vKAPIM,true);
  AddPrice(x2s(totalCAM/1000000,3,2)+'m˝ áift cam',(totalCAM/1000000)*setup.CAM2,(totalCAM/1000000)*setup.vCAM2,true);
  AddPrice(x2s(totalLambri/1000000,3,2)+'m˝ Lambri',(totalLambri/1000000)*setup.Lam2,(totalLambri/1000000)*setup.vLAM2,true);
  AddPrice(c2s(totalAksesuar)+' x Aksesuar',totalAksesuar*setup.PencAksesuar,totalAksesuar*Setup.vPencAksesuar,true);
  AddPrice('KîpÅk',setup.Kopuk,setup.vKopuk,true);
  if Kind='K' then AddPrice('Kapç aksesuarç',Setup.KapiAksesuar,Setup.vKapiAksesuar,true);
  AddPrice('KDV',PesinKDV,VadeKDV,true);
  length := (kasaWidth*2)+(kasaHeight*2);
  AddPrice(x2s(length/1000,3,2)+'mtÅl Kîr kasa',(length/1000)*setup.KorKasaM,(length/1000)*setup.vKorKasaM,false);
  AddPrice(x2s(totalCAM/1000000,3,2)+'m˝ tek cam',(totalCAM/1000000)*setup.TekCAM2,(totalCAM/1000000)*setup.vTekCAM2,false);
  UpdatePriceTotals;
end;

procedure TBasicWIndow.ResetVars;
begin
  TotalPVC      := 0;
  TotalPesin    := 0;
  TotalVade     := 0;
  totalCam      := 0;
  totalLambri   := 0;
  totalKAPI     := 0;
  totalAksesuar := 0;
  PesinKDV      := 0;
  VadeKDV       := 0;
  TotalZivana   := 0;
  if rw <> NIL then FillChar(rw^,SizeOf(comp)*rn,0);
end;

procedure TBasicWIndow.InitKesimHesabi;
begin
  ResetVars;
  Measures^.FreeAll;
end;

procedure TBasicWIndow.DoneKesimHesabi;
var
  vidaCOunt:comp;
  procedure PVCOran(what:string; pvcoran,unitprice:comp);
  begin
    AddMeasure(mtLong,false,what,1,(pvcoran*(totalPVC/1000)),0,unitprice*((pvcoran*(totalPVC/1000))/1000));
  end;
begin
  PVCOran(dsStr,Setup.DesteksM,Setup.mDesteksM);
  PVCOran(cStr,Setup.ContaM,Setup.mContaM);
  AddMeasure(mtItem,false,mStr,Setup.MenteseA*totalAksesuar,0,0,Setup.MenteseA*totalAksesuar*Setup.mMentese);
  AddMeasure(mtItem,false,akStr,totalAksesuar,0,0,totalAksesuar*Setup.mKOL);
  AddMeasure(mtItem,false,zStr,totalZivana,0,0,totalZivana*Setup.mZivana);
  vidaCount := (totalZivana*setup.Vidaz)+
               (totalAksesuar*setup.MenteseA*setup.VidaM);
  if Kind='K' then vidaCount := vidaCount + (setup.MenteseA*setup.VidaK);
  AddMeasure(mtItem,false,vStr,vidaCount,0,0,vidaCount*Setup.mVida);
end;

procedure SaveSetup;
var
  T:TDosStream;
begin
  T.Init(wkdir+setupFile,stCreate);
  T.Write(Setup,Sizeof(Setup));
  T.Done;
end;

procedure AddObject(what:char; vmt:word; loadptr:pointer);
var
  P:PBasicWIndow;
begin
  P := CastObject(vmt,loadptr);
  P^.LoadPtr := loadPtr;
  P^.Kind := what;
  ObjList^.Insert(P);
  P^.index := ObjList^.IndexOf(P);
  if P^.index = -1 then Error('AddObject','p^.index=-1');
end;

procedure InitObjects;
begin
  New(ObjList,Init(10,10));
  AddObject('P', word(TypeOf(TEmptyWindow)),@TEmptyWindow.Init);
  AddObject('P', word(TypeOf(TLambri)),@TLambri.Init);
  AddObject('P', word(TypeOf(TSWingWindow)),@TSWingWIndow.Init);
  AddObject('P', word(TypeOf(TDWingWindow)),@TDWingWindow.Init);
  AddObject('P', word(TypeOf(THQuadWindow)),@THQuadWindow.Init);
  AddObject('P', word(TypeOf(THReverseWindow)),@THReverseWindow.Init);
  AddObject('P', word(TypeOf(TQCrossWindow)),@TQCrossWindow.init);
  AddObject('P', word(TypeOf(THexWindow)), @THexWindow.Init);
  AddObject('P', word(TypeOf(TQSliceWindow)), @TQSliceWindow.Init);
  AddObject('P', word(TypeOf(TCiftAcilir)), @TCiftAcilir.Init);
  AddObject('P', word(TypeOf(TFruko)), @TFruko.Init);
  AddObject('P', word(TypeOf(TTuranjWindow)), @TTuranjWindow.Init);
  AddObject('P', word(TypeOf(TDortluWindow)), @TDortluWindow.Init);
  AddObject('P', word(TypeOf(TBesliWindow)), @TBesliWindow.Init);

  AddObject('K', word(TypeOf(TCamDoor)), @TCamDoor.Init);
  AddObject('K', word(TypeOf(TSCamDoor)), @TSCamDoor.Init);
  AddObject('K', word(TypeOf(TSUstDoor)), @TSUstDoor.Init);

  AddObject('B', word(TypeOf(T1Balkon)), @T1Balkon.Init);
  AddObject('B', word(TypeOf(T2Balkon)), @T2Balkon.Init);
  AddObject('B', word(TypeOf(T3Balkon)), @T3Balkon.Init);
  AddObject('B', word(TypeOf(T4Balkon)), @T4Balkon.Init);
  AddObject('B', word(TypeOf(T5Balkon)), @T5Balkon.Init);
  AddObject('B', word(TypeOf(T1SBalkon)), @T1SBalkon.Init);
  AddObject('B', word(TypeOf(T2SBalkon)), @T2SBalkon.Init);
  AddObject('B', word(TypeOf(T3SBalkon)), @T3SBalkon.Init);
  AddObject('B', word(TypeOf(T4SBalkon)), @T4SBalkon.Init);
  AddObject('B', word(TypeOf(T5SBalkon)), @T5SBalkon.Init);
end;

end.
*** End of File ***