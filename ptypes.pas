{
poly - types
}

unit PTypes;

interface

uses

  Objects;

const

  mvXSize        = 30;
  mvYSize        = 15;
  mvBufSize      = mvXsize*mvYSize*2;

  keycode  : string = '';

type

  PCompArray = ^TCompArray;
  TCompArray = array[1..255] of comp;

  PPriceRec = ^TPriceRec;
  TPriceRec = object
    What    : string[15];
    Pesin   : comp;
    Vade    : comp;
    Include : boolean;
  end;

  TCharSet = set of char;
  TOutputLocation = (toprinter,toscreen);

  PFiatHeader = ^TFiatHeader;
  TFiatHeader = record
    Name     : string[39];
    Date     : longint;
    Items    : integer;
    Offs     : longint; {used in mem}
    Size     : longint;
  end;

  TFiatRec = record
    What : string[15];
    ObjIndex : integer;
    Image    : array[1..mvBufSize] of char;
    Pesin : comp;
    Vade  : comp;
    Qty : comp;
    Kal1,Kal2 : byte;
    CamC      : byte;
    Cift : boolean;
    Include : boolean;
  end;

  TPrice = record
    Pesin : comp;
    Vade  : comp;
  end;

  TKasaInfo = record
    Thick : comp;
    Name  : string[19];
  end;

  PIspanyolet = ^TIspanyolet;
  TIspanyolet = record
    Length : comp;
    Price  : comp;
  end;

  PISPCollection = ^TISPCollection;
  TISPCollection = object(TSortedCollection)
    function Compare(k1,k2:pointer):integer;virtual;
    procedure FreeItem(item:pointer);virtual;
  end;

  TEntryType = (etComp,etChar);

  PRegion = ^TRegion;
  TRegion = record
    Next        : PRegion;
    Data        : pointer;
    x1,y1,x2,y2 : byte;
  end;

  TMeasureType = (mtLong, mtSquare, mtItem);

  PMeasure = ^TMeasure;
  TMeasure = record
    MeasureType : TMeasureType;
    PVC         : boolean;
    What   : string[15];
    Qty    : comp;
    Price  : comp;
    case boolean of
      False : (Length : comp);
      True  : (Width:comp;
               Height:comp);
  end;

  PLogRec = ^TLogRec;
  TLogRec = record
    What       : string[19];
    Year       : word;
    Month      : byte;
    Day        : byte;
    NumEntries : longint;
    Offs       : longint;
  end;

  TSetupRec = record
    PencAksesuar  : comp;
    KapiAksesuar  : comp;
    PVCM          : comp;
    KapiM         : comp;
    CAM2          : comp;
    TekCAM2       : comp;
    LAM2          : comp;
    Kopuk         : comp;
    KorKasaM      : comp;

    vPencAksesuar : comp;
    vKapiAksesuar : comp;
    vPVCM         : comp;
    vKapiM        : comp;
    vCAM2         : comp;
    vTekCAM2      : comp;
    vLAM2         : comp;
    vKopuk        : comp;
    vKorKasaM     : comp;

    mPVCM        : comp;
    mKapiM       : comp;
    mCAM2        : comp;
    mLAM2        : comp;
    mDesteksM    : comp;
    mCamcM       : comp;
    mContaM      : comp;
    mKOL         : comp;
    mMentese     : comp;
    mZivana      : comp;
    mVida        : comp;
    DesteksM     : comp;
    ContaM       : comp;
    ZivanaK      : comp;
    MenteseA     : comp;
    ISPFark      : comp;
    VidaZ        : comp;
    VidaM        : comp;
    VidaK        : comp;

    econThick    : comp;
    superThick   : comp;
    kapiThick    : comp;
    okThick      : comp;
    pencThick    : comp;
    kaynakFire   : comp;
    pencFire     : comp;
    kayitFire    : comp;
    camFire      : comp;
  end;

const

  rdNone  = 0;
  rdLeft  = 1;
  rdRight = 2;
  rdUp    = 3;
  rdDown  = 4;

  pVersion : string[5] = '1.5a';
  wkdir    : string = '';

  keyDrive : byte = 0;

  setupFile : string[12] = 'poly.cfg';
  resFile   : string[12] = 'poly.rif';
  helpFile  : string[12] = 'poly.hlp';
  tempFile  : string[12] = 'poly.tmp';

  ispFile   : string[12] = 'isp.pda';
  takFile   : string[12] = 'taksit.pda';
  logFile   : string[12] = 'kayit.pda';
  priceFile : string[12] = 'musteri.pda';
  montFile  : string[12] = 'montaj.pda';
  vcekFile  : string[12] = 'cek.pda';
  acekFile  : string[12] = 'acek.pda';

  okStr : string[15] = 'Orta kayt';
  kkStr : string[15] = 'Kap kanad';
  skStr : string[15] = 'Sper kasa';
  ekStr : string[15] = 'Ekonomik kasa';
  pkStr : string[15] = 'Pencere kanad';
  ccStr : string[15] = 'Cam ‡tas';
  dsStr : string[15] = 'Destek sac';
  akStr : string[15] = 'A‡lr kolu';
  cStr  : string[15] = 'Conta';
  mStr  : string[15] = 'MenteŸe';
  zStr  : string[15] = 'Zvana';
  vStr  : string[15] = 'Vida';

  cmPVCHesabi    = 63000; {cms}
  cmTaksitTakibi = 63001;
  cmFiatAyarlari = 63002;
  cmOlcuAyarlari = 63003;
  cmCredz        = 63004;
  cmSelPencere   = 63005;
  cmSelKapi      = 63006;
  cmSelBalkon    = 63007;
  cmMaliyetAyarlari = 63008;
  cmReadMeasureData = 63009;
  cmClearMemory     = 63010;
  cmKesimHesabi     = 63011;
  cmOpenLog         = 63012;
  cmAddMemory       = 63013;
  cmModify          = 63014;
  cmSavePrice       = 63015;
  cmPesinPrice      = 63016;
  cmVadePrice       = 63017;
  cmUpdateLogDetail = 63018;
  cmPriceTotalChanged = 63019;
  cmMaliyetHesabi     = 63020;
  cmCamHesabi         = 63021;
  cmFocusModel        = 63022;
  cmTeklif            = 63023;
  cmYok               = 63024;
  cmLeft              = 63025;
  cmRight             = 63026;
  cmUp                = 63027;
  cmDown              = 63028;
  cmLoadPrice         = 63029;
  cmSaveFiats         = 63030;
  cmLoadFiats         = 63031;
  cmMontajtakibi      = 63032;
  cmCekTakibi         = 63033;
  cmVAdd              = 63034;
  cmVDel              = 63035;
  cmAAdd              = 63036;
  cmADel              = 63037;
  cmFirmaTakibi       = 63038;
  cmGelirGiderAnalizi = 63039;
  cmEbeninAMI         = 63040;
  cmVPrint            = 63041;

  gidButtons = 3;

  ispList : PISPCollection = NIL;

  cLU = #201;
  cLD = #200;
  cRU = #187;
  cRD = #188;
  cHZ = #205;
  cVT = #186;

  outx:byte=1;
  outy:byte=1;

  Setup : TSetupRec = (
    PencAksesuar  : 850000;
    KapiAksesuar  : 2500000;
    PVCM          : 800000;
    KapiM         : 1150000;
    CAM2          : 3000000;
    TekCAM2       : 1500000;
    LAM2          : 2750000;
    Kopuk         : 1000000;
    KorKasaM      : 500000;

    vPencAksesuar : 850000;
    vKapiAksesuar : 2500000;
    vPVCM         : 800000;
    vKapiM        : 1150000;
    vCAM2         : 3000000;
    vTekCAM2      : 1500000;
    vLAM2         : 2750000;
    vKopuk        : 1000000;
    vKorKasaM     : 500000;

    mPVCM        : 400000;
    mKapiM       : 400000;
    mCAM2        : 400000;
    mLAM2        : 400000;
    mDesteksM    : 50000;
    mCamcM       : 50000;
    mContaM      : 50000;
    mKOL         : 250000;
    mMentese     : 75000;
    mZivana      : 75000;
    mVida        : 1000;
    DesteksM     : 800;
    ContaM       : 600;
    ZivanaK      : 2;
    MenteseA     : 3;
    ISPFark      : 200;
    VidaZ        : 3;
    VidaM        : 4;
    VidaK        : 6;

    econThick    : 36;
    superThick   : 48;
    kapiThick    : 91;
    okThick      : 36;
    pencThick    : 56;
    kaynakFire   : 5;
    pencFire     : 20;
    kayitFire    : 8;
    camFire      : 10
  );

function  s2c(s:string):comp;
function  c2s(c:comp):string;

implementation

uses

  XStr;

function c2s;
var
  s:string;
begin
  Str(c:20:0,s);
  Strip(s);
  c2s := s;
end;

function s2c;
var
  c:comp;
  code:integer;
begin
  Val(s,c,code);
  s2c := c;
end;

function TISPCollection.Compare(k1,k2:pointer):integer;
var
  p1,p2:PIspanyolet;
begin
  p1 := k1;
  p2 := k2;
  if p1^.Length > p2^.Length then Compare := 1 else Compare := -1;
end;

procedure TISPCollection.FreeItem(item:pointer);
begin
  Dispose(PIspanyolet(item));
end;

end.
*** End of File ***