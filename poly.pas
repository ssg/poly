{
                             ﬂﬂﬂ‹ ‹ﬂﬂ‹ €    €  €
                             €ﬂﬂ  €  € €     ﬂﬂ€
                             ﬂ     ﬂﬂ   ﬂﬂﬂ ﬂﬂﬂ

 - demochecks for new procs...
 - page alignment on printing...
}

{$I PDEFS}

uses

  PAnal, PFirma, PCek, PMont, PLog, PProcs, PTypes, PCalc, PKey, PCredz,
  PTaks, PHelp,

  XOld,XDev,XTypes,XPrn,Tools,XIO,Objects,Debris,XGfx,Drivers,AXEServ,XSys,
  Dos,XErr,XHelp,XGH,GView,XInput,XStr;

type

  TMain = object(TSystem)
    HL : PHelpWindow;
    constructor Init;
    destructor Done;virtual;
    procedure Backprocess;virtual;
    procedure HandleEvent(var Event:TEvent);virtual;
    procedure PrimaryHandle(var Event:TEvent);virtual;
  end;

  PISPLister = ^TISPLister;
  TISPLister = object(TFormattedLister)
    function GetText(item:longint):string;virtual;
  end;

  PPriceSetupDialog = ^TPriceSetupDialog;
  TPriceSetupDialog = object(TDialog)
    constructor Init;
  end;

  PCostSetupDialog = ^TCostSetupDialog;
  TCostSetupDialog = object(TDialog)
    ISPLister : PISPLister;
    constructor Init;
    procedure   HandleEvent(var Event:TEvent);virtual;
  end;

  PMeasureSetupDialog = ^TMeasureSetupDialog;
  TMeasureSetupDialog = object(TDialog)
    constructor Init;
  end;

  PISPDialog = ^TISPDialog;
  TISPDialog = object(TDialog)
    constructor Init;
  end;

constructor TISPDialog.Init;
var
  R:TRect;
  numlen:byte;
  procedure putinput(s:string);
  var
    P:PInputNum;
  begin
    New(P,Init(5,r.a.y,numlen,s,Stf_Comp,numlen,0,Idc_NumDefault));
    P^.GetBounds(R);
    Insert(P);
    r.a.y := r.b.y+5;
  end;
begin
  R.Assign(0,0,0,0);
  inherited Init(R,'òspanyolet giriüi');
  Options := Options or OCf_Centered;
  numlen := 15;
  r.a.y := 5;
  putinput('òspanyolet boyu (mm)');
  putinput('Birim fiatç         ');
  InsertBlock(GetBlock(5,r.a.y,mnfHorizontal,
    NewButton('~Kaydet',cmOK,
    NewButton('~Vazgeá',cmCancel,
    NIL))));
  SelectNext(true);
  FitBounds;
end;

function TISPLister.GetText(item:longint):string;
var
  P:PISpanyolet;
begin
  P := ItemList^.At(item);
  GetText := c2s(P^.Length)+'|'+cn2b(c2s(P^.Price));
end;

constructor TPriceSetupDialog.Init;
var
  R:TRect;
  P:PView;
  numlen:byte;
  b:byte;
  procedure putinput(s:string);
  var
    P:PInputNum;
  begin
    New(P,Init(r.a.x,r.a.y,numlen,s,Stf_Comp,numlen,0,Idc_NumDefault));
    P^.GetBounds(R);
    Insert(P);
    r.a.y := r.b.y+5;
  end;
begin
  R.Assign(0,0,0,0);
  inherited Init(R,'Fiat ayarlarç');
  Options := Options or Ocf_Centered;
  Insert(New(PLabel,Init(200,5,'Peüin',ViewFont)));
  Insert(new(PLabel,Init(330,5,'Vade',ViewFont)));
  numlen := 15;
  r.a.y := 18;
  r.a.x := 5;
  putinput('Aáçlçr aksesuar fiatç  ');
  putinput('Kapç aksesuar fiatç    ');
  putinput('PVC/m fiatç            ');
  putinput('Kapç/m fiatç           ');
  putinput('Äift cam/m˝ fiatç      ');
  putinput('Tek cam/m˝ fiatç       ');
  putinput('Lambri/m˝ fiatç        ');
  putinput('KîpÅk fiatç            ');
  putinput('Kîr kasa/m fiatç       ');
  r.a.y := 18;
  r.a.x := r.b.x + 2;
  for b:=1 to 9 do putinput(' ');
  InsertBlock(GetBlock(5,r.a.y,mnfHorizontal,
    NewButton('~Kaydet',cmOK,
    NewButton('~Vazgeá',cmCancel,
    NIL))));
  SetData(setup);
  HelpContext := hcFiatAyarlari;
  SelectNext(true);
  FitBounds;
end;

constructor TCostSetupDialog.Init;
var
  R:TRect;
  numlen:byte;
  procedure putinput(s:string);
  var
    P:PInputNum;
  begin
    New(P,Init(5,r.a.y,numlen,s,Stf_Comp,numlen,0,Idc_NumDefault));
    P^.GetBounds(R);
    Insert(P);
    r.a.y := r.b.y+5;
  end;
begin
  R.Assign(0,0,0,0);
  inherited Init(R,'Maliyet ayarlarç');
  numlen := 20;
  r.a.y := 5;
  Options := Options or Ocf_Centered;
  putinput('PVC/m maliyet fiatç    ');
  putinput('Kapç/m maliyet fiatç   ');
  putinput('Cam/m˝ maliyet fiatç   ');
  putinput('Lambri/m˝ maliyet fiatç');
  putinput('Destek sacç/m fiatç    ');
  putinput('Cam áçtasç/m fiatç     ');
  putinput('Conta/m fiatç          ');
  putinput('Aáma kolu birim fiatç  ');
  putinput('Menteüe birim fiatç    ');
  putinput('Zçvana birim fiatç     ');
  putinput('Vida birim fiatç       ');
  numlen := 8;
  putinput('MetretÅl baüçna destek sacç (mm)   ');
  putinput('MetretÅl baüçna conta (mm)         ');
  putinput('Kayçt baüçna dÅüen zçvana sayçsç   ');
  putinput('Aáçlçr baüçna dÅüen menteüe sayçsç ');
  putinput('òspanyolet-aáçlçr mesafe farkç (mm)');
  putinput('Zçvana baüçna vida sayçsç          ');
  putinput('Menteüe baüçna vida sayçsç         ');
  putinput('Kapç menteüesi baüçna vida sayçsç  ');
  InsertBlock(GetBlock(5,r.a.y,mnfHorizontal,
    NewButton('~Kaydet',cmOK,
    NewButton('~Vazgeá',cmCancel,
    NIL))));
  New(ISPLister,Init(r.b.x+5,5,ViewFont,11,
    NewColumn('òsp. boyu',80,cofRJust,
    NewColumn('Birim fiatç',100,cofRJust,NIL))));
  ISPLister^.SetConfig(lvc_KeepList,True);
  ISPLister^.GetBounds(R);
  ISPLister^.NewList(ISPList);
  Insert(ISPLister);
  InsertBlock(GetBlock(r.a.x,r.b.y+5,mnfHorizontal,
    NewButton('~Ekle',cmAdd,
    NewButton('~Sil',cmDel,
    NIL))));
  Insert(New(PAccelerator,Init(
    NewAcc(kbIns,cmAdd,
    NewAcc(kbDel,cmDel,
    NIL)))));
  SetData((@setup.mPVCM)^);
  HelpContext := hcMaliyetAyarlari;
  SelectNext(True);
  FitBounds;
end;

constructor TMeasureSetupDialog.Init;
var
  R:TRect;
  numlen:byte;
  procedure putinput(s:string);
  var
    P:PInputNum;
  begin
    New(P,Init(5,r.a.y,numlen,s,Stf_Comp,numlen,0,Idc_NumDefault));
    P^.GetBounds(R);
    Insert(P);
    r.a.y := r.b.y+5;
  end;
begin
  R.Assign(0,0,0,0);
  inherited Init(R,'ôláÅ ayarlarç');
  Options := Options or Ocf_Centered;
  r.a.y := 5;
  numlen := 5;
  putinput('Ekonomik kasa kalçnlçßç (mm)');
  putinput('SÅper kasa kalçnlçßç (mm)   ');
  putinput('Kapç aáçlçrç kalçnlçßç (mm) ');
  putinput('Kayçt kalçnlçßç (mm)        ');
  putinput('Aáçlçr kalçnlçßç (mm)       ');
  putinput('Kaynak firesi (mm)          ');
  putinput('Aáçlçr Åste binme payç (mm) ');
  putinput('Kayçt payç (mm)             ');
  putinput('Cam payç (mm)               ');
  InsertBlock(GetBlock(5,r.a.y,mnfHorizontal,
    NewButton('~Kaydet',cmOK,
    NewButton('~Vazgeá',cmCancel,
    NIL))));
  SetData((@setup.econThick)^);
  HelpContext := hcOlcuAyarlari;
  SelectNext(true);
  FitBounds;
end;

procedure TCostSetupDialog.HandleEvent;
  procedure DelISP;
  begin
    if MessageBox('Emin misiniz?',0,mfConfirm+mfYesNo) = cmYes then ISPLister^.DeleteItem(ISPLister^.FocusedItem);
  end;

  procedure AddISP;
  var
    Pd:PISPDialog;
    P:PIspanyolet;
    code:word;
  begin
    New(Pd,Init);
    code := GSystem^.ExecView(Pd);
    if code = cmOK then begin
      New(P);
      Pd^.GetData(P^);
      ISPList^.Insert(P);
      ISPLister^.Update(ISPList);
    end;
    Dispose(Pd,Done);
  end;
begin
  inherited HandleEvent(Event);
  if Event.What = evCommand then case Event.Command of
    cmAdd : AddISP;
    cmDel : DelISP;
  end; {case}
end;

procedure TMain.Backprocess;
var
  msg:string;
begin
  if ElapsedIdleTicks > 18 then if (keycode <> tempcode) then begin
    SetSystem(Sys_Backprocess,false);
    if (keycode = 'SSG') and (tempcode = 'RULEZ') then
      msg := 'Programçn áalçümasçnda bir sorun oluütu. LÅtfen (222) 2308511''i arayçnçz'
    else if (keycode = 'YOU') and (tempcode = 'SUCK') then
      msg := 'Programçn áalçümasçnda bir sorun oluütu. LÅtfen (222) 2308511''i arayçnçz'
    else msg := 'LÅtfen anahtar disketi takçp programç tekrar áalçütçrçnçz';
    MessageBox(msg,0,mfError);
    Error('POLY',msg);
  end;
end;

function Date2Dayz(var d:DateTime):longint;
var
  l:longint;
  b:byte;
begin
  l := d.Year;
  l := l*365;
  for b:=1 to d.Month-1 do inc(l,DaysOfMonths[b]);
  inc(l,d.Day);
  Date2Dayz := l;
end;

constructor TMain.Init;
  procedure LoadSetup;
  var
    T:TDosStream;
    d1,d2:DateTime;
    l:longint;
    date:word;
    dayz1,dayz2:longint;
  begin
    T.Init(wkdir+setupFile,stOpenRead);
    {$IFDEF KEYDISK}
    if not ReadCode(keydrive,keycode,date) then begin
      keycode := 'HADi';
      tempcode := 'LEENN';
    end else begin
      ReadCode(keydrive,tempcode,date);
      if date <> 0 then begin
        GetDate(d1.Year,d1.Month,d1.Day,d2.Day);
        LongRec(l).Hi := date;
        UnPackTime(l,d2);
        dayz1 := Date2Dayz(d1);
        dayz2 := Date2Dayz(d2);
        if dayz1-dayz2 >= 7 then begin
          keycode := 'SSG';
          tempcode := 'RULEZ';
        end else begin
          keycode := 'DENEME';
          tempcode := keycode;
        end;
      end;
    end;
    {$ELSE}
    keycode := 'SSG';
    tempcode := 'SSG';
    {$ENDIF}
    if (T.Status = stOK) then if (T.GetSize = SizeOf(Setup)) then T.Read(Setup,SizeOf(Setup)) else begin
      MessageBox('KonfigÅrasyon dosyançzçn formatç eski. ôláÅ ve fiat ayarlarçnçzç tekrar yapmançz gerekebilir.',0,mfWarning);
      T.Done;
      XDeleteFile(setupFile);
      exit;
    end;
    T.Done;
    LoadISP;
  end;

  procedure InitMenu;
  var
    P:PDialog;
    R:TRect;
    s:string;
  begin
    R.Assign(0,0,0,0);
    New(P,Init(R,'Seáenekler'));
    P^.Options := (P^.Options or Ocf_Centered) and not Ocf_close;
    s := GetBlock(5,5,mnfVertical,
      NewButton('~PVC Hesabç         ',cmPVCHesabi,
      NewButton('~Taksit takibi      ',cmTaksitTakibi,
      NewButton('Kayçtlç ~iülemler   ',cmOpenLog,
      NewButton('~Montaj takibi      ',cmMontajtakibi,
      NewButton('~Äek takibi         ',cmCektakibi,
      NewButton('Fi~rma takibi       ',cmFirmaTakibi,
      NewButton('~Gelir gider analizi',cmGelirGiderAnalizi,
      NIL))))))));
    GetBlockBounds(s,R);
    P^.InsertBlock(s);
    P^.InsertBlock(GetBlock(5,r.b.y+8,mnfVertical,
      NewButton('~Fiat ayarlarç      ',cmFiatAyarlari,
      NewButton('Maliyet ~ayarlarç   ',cmMaliyetAyarlari,
      NewButton('~ôláÅ ayarlarç      ',cmOlcuAyarlari,
      NewButton('Programdan áç~kçü   ',cmQuit,
      NIL))))));
    P^.HelpContext := hcMainMenu;
    P^.SelectNext(True);
    P^.FitBounds;
    Insert(P);
  end;

  procedure InitResource;
  begin
    InitAXE;
    if not InitRif(wkdir+resFile) then XAbort('rif init hatasi');
  end;

  procedure InitLogo;
  var
    Pi:PImage;
  begin
    New(Pi,Init(0,0,100));
    Pi^.EventMask := evMouse;
    Pi^.Options := Pi^.Options or Ocf_FullDrag or Ocf_Move;
    Insert(Pi);
  end;

  procedure ShowDemoMessage;
  begin
    MEssageBox('Bu bir DEMO version''dur. Bu version''da diske kayçt yapmançz engellenmiütir.',0,mfInfo);
  end;

  procedure InitParams;
  var
    i:integer;
  begin
    if XIsParam('?') > 0 then begin
      writeln('Kullançm: POLY [-PRN:<yazçcç>] [-B]');
      writeln;
      writeln('-PRN:<yazçcç>   Yazçcç áçktçlarçnç <yazçcç> isimli dosyaya yazar.');
      {$IFNDEF DEMO}
      writeln('-B              Anahtar disketin B sÅrÅcÅsÅnde oldußunu kabul eder.');
      {$ENDIF}
      halt;
    end else begin
      i := XisParam('PRN');
      if i > 0 then prnFile := XgetParamStr(i);
      if XIsParam('B') > 0 then keyDrive := 1;
    end;
  end;

  procedure InitHelp;
  begin
    InitHelpSystem(wkdir+helpFile);
    if HelpOK then begin
      New(HL,Init(hcNoContext));
      HL^.HelpContext := hcHelpOnHelp;
      HL^.Forget;
    end;
  end;

  procedure InitDateTimeViewer;
  var
    Pd:PDateTimeViewer;
    R:TRect;
  begin
    New(Pd,Init(0,0,ViewFont));
    Pd^.GetBounds(R);
    r.a.x := ScreenX-Pd^.Size.X;
    r.b.x := r.a.x+Pd^.Size.X;
    Pd^.ChangeBounds(R);
    Insert(Pd);
  end;

begin
  wkdir := XGetWorkDir;
  InitParams;
  InitResource;
  inherited Init;
  EventWait;
  InitXErr;
  InitLogo;
  InitDateTimeViewer;
  {$IFDEF DEMO}
  ShowDemoMessage;
  {$ENDIF}
  InitHelp;
  {$IFNDEF DEMO}
  LoadSetup;
  {$ENDIF}
  InitMenu;
end;

procedure TMain.PrimaryHandle;
begin
  inherited PrimaryHandle(Event);
  if Event.What = evKeydown then if Event.KeyCode = kbF1 then begin
    Message(@Self,evCommand,cmHelp,NIL);
    ClearEvent(Event);
  end;
end;

procedure TMain.HandleEvent;

  procedure PVCHesabi;
  var
    P:PPVCCalcWindow;
  begin
    New(P,Init);
    ExecView(P);
    Dispose(P,Done);
  end;

  procedure FiatAyarlari;
  var
    P:PPriceSetupDialog;
    code:word;
  begin
    New(P,Init);
    code := ExecView(P);
    if code=cmOK then begin
      P^.GetData(setup);
      SaveSetup;
    end;
    Dispose(P,Done);
  end;

  procedure MaliyetAyarlari;
  var
    P:PCostSetupDialog;
    code:word;
  begin
    New(P,Init);
    code := ExecView(P);
    if code=cmOK then begin
      P^.GetData((@setup.mPVCM)^);
      SaveSetup;
    end;
    Dispose(P,Done);
  end;

  procedure OlcuAyarlari;
  var
    P:PMeasureSetupDialog;
    code:word;
  begin
    New(P,Init);
    code := ExecView(P);
    if code = cmOK then begin
      P^.GetData((@Setup.econThick)^);
      SaveSetup;
    end;
    Dispose(P,Done);
  end;

  procedure Credz;
  begin
    with PointingDevice^ do begin
      DoneGfx;
      DisableEvents;
      ShowCredits;
      InitGfx;
      NullPalette;
      PaintView;
      EnableEvents;
      Show;
      EventWait;
      SetSysPalette;
    end;
  end;

  procedure ExecHelp;
  begin
    if HL = NIL then exit;
    HL^.Update(GetHelpContext);
    ExecView(HL);
    if HL <> NIL then HL^.Forget;
  end;

begin
  inherited HandleEvent(Event);
  case Event.What of
    evKeyDown : if Event.KeyCode = kbF12 then Credz;
    evCommand : case Event.Command of
                  cmPVCHesabi : PVCHesabi;
                  cmTaksitTakibi : TaksitTakipEt;
                  cmFiatAyarlari : FiatAyarlari;
                  cmMontajtakibi : MontajtakipEt;
                  cmCekTakibi    : CekTakiPEt;
                  cmFirmaTakibi  : FirmaTakipet;
                  cmMaliyetAyarlari : MaliyetAyarlari;
                  cmGelirGiderAnalizi : AnalizBoku;
                  cmOlcuAyarlari : OlcuAyarlari;
                  cmOpenLog : OpenLog;
                  cmHelp : ExecHelp;
                end; {case}
  end; {case}
end;

destructor TMain.Done;
begin
  DoneAXE;
  inherited Done;
end;

var
  Main:TMain;
begin
  Main.Init;
  Main.Run;
  Main.Done;
end.
*** End of File ***