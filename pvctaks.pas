unit PVCtaks;

interface

procedure TaksitTakipEt;

implementation

uses

  Debris,XStr,Dos,Crt,XIntl,Objects,PVCProcs;

const

  taksFile : string[12] = 'poly.tak';
  listTop  : longint = 0;

type

  TAyRec = record
    Year  : word;
    Month : byte;
    Paid  : boolean;
    Cost  : comp;
  end;

  PTaksRec = ^TTaksRec;
  TTaksRec = record
    Deleted  : boolean;
    Name     : string[40];
    Addr1    : string[40];
    Addr2    : string[40];
    Addr3    : string[40];
    Tel      : string[40];
    Ays      : byte;
    Ay       : array[1..24] of TAyRec;
  end;

procedure AppendFile(var rec:TTaksRec);
var
  T:TDosStream;
begin
  T.Init(taksFile,stOpen);
  if T.Status <> stOK then begin
    T.Done;
    T.Init(taksFile,stCreate);
    if T.Status <> stOK then Abort(taksFile+' dosyasi olu$turulamadi');
  end;
  T.Seek(T.GetSize);
  T.Write(rec,SizeOf(rec));
  T.Done;
end;

function Outln(towhere:char; s:String):boolean;
begin
  Outln := false;
  if towhere = 'Y' then Writeln(Printer,s) else begin
    Writeln(s);
    if Wherey = 24 then Outln := true;
  end;
end;

procedure AylikBorclular;
var
  y,m,d,dow:word;
  towhere:char;
  b:byte;
  T:TDosStream;
  rec:TTaksRec;
  procedure WriteHeader;
  begin
    TextColor(Yellow);
    Outln(towhere,Fix('ADI SOYADI',30)+' '+Fix('TELEFONU',20)+' '+Fix('BORCU',20));
    Outln(towhere,Duplicate(#196,30)+' '+Duplicate(#196,20)+' '+Duplicate(#196,20));
  end;
begin
  ResetScreen;
  TextColor(Cyan);
  writeln('Aylik borclular listesi'#13#10);
  GetDate(y,m,d,dow);
  if not WInput('YIL',y,y) then exit;
  if not WInput('AY ',m,m) then exit;
  towhere := GetKey('Cikti nereye? (Ekrana/Yaziciya)',['E','Y'],'E');
  if towhere = #27 then exit;
  writeln;
  T.Init(taksFile,stOpenRead);
  if T.Status <> stOK then begin
    T.Done;
    exit;
  end;
  WriteHeader;
  while T.GetPos < T.GetSize do begin
    T.Read(rec,SizeOf(rec));
    if T.Status <> stOK then begin
      T.Done;
      exit;
    end;
    if not rec.Deleted then begin
      for b:=1 to rec.Ays do if (rec.Ay[b].Month = m) and (rec.Ay[b].Year=y) and (not rec.Ay[b].Paid) then begin
        if Outln(towhere,Fix(rec.Name,30)+' '+Fix(rec.Tel,20)+' '+RFix(cn2b(c2s(rec.Ay[b].Cost)),20)) then
          if readkey = #27 then exit else begin
            ResetScreen;
            WriteHeader;
          end;
        break;
      end;
    end;
  end;
  T.Done;
  readkey;
end;

procedure MusteriBilgi;
var
  s:String;
  T:TDosStream;
  rec:TTaksRec;
  b:byte;
begin
  ResetScreen;
  TextColor(Cyan);
  Writeln('Mu$teri bilgi istemi'#13#10);
  if not Input('Adi soyadi',s,'') then exit;
  XIntlFastUpper(s);
  T.Init(taksFile,stOpen);
  while T.GetPos < T.GetSize do begin
    T.Read(rec,SizeOf(rec));
    if not rec.Deleted then if rec.Name = s then begin
      writeln('Adres        : ',rec.Addr1);
      writeln('               ',rec.Addr2);
      writeln('               ',rec.Addr3);
      writeln('Telefon      : ',rec.Tel);
      writeln;
      for b:=1 to rec.Ays do begin
        write(b,'. taksit ('+l2s(rec.Ay[b].Month)+'/'+l2s(rec.Ay[b].Year)+') '+cn2b(c2s(rec.Ay[b].Cost))+'TL ');
        if rec.Ay[b].Paid then writeln('*** ODENDi ***') else writeln;
      end;
      writeln;
      TextCOlor(Cyan);
      T.Done;
      write('Geri donmek icin bir tu$a basiniz');
      readkey;
      exit;
    end;
  end;
  T.Done;
end;

procedure TumListe;
var
  towhere:char;
  b:byte;
  total:comp;
  T:TDosStream;
  rec:TTaksRec;
  procedure WriteHeader;
  begin
    TextColor(Yellow);
    Outln(towhere,Fix('ADI SOYADI',30)+' '+Fix('TELEFONU',20)+' '+Fix('TOPLAM BORCU',20));
    Outln(towhere,Duplicate(#196,30)+' '+Duplicate(#196,20)+' '+Duplicate(#196,20));
  end;
begin
  ResetScreen;
  TextColor(Cyan);
  writeln('Tum mu$terilerin listesi'#13#10);
  towhere := GetKey('Cikti nereye? (Ekrana/Yaziciya)',['E','Y'],'E');
  if towhere = #27 then exit;
  writeln;
  T.Init(taksFile,stOpenRead);
  if T.Status <> stOK then begin
    T.Done;
    exit;
  end;
  WriteHeader;
  while T.GetPos < T.GetSize do begin
    T.Read(rec,SizeOf(rec));
    if T.Status <> stOK then begin
      T.Done;
      exit;
    end;
    if not rec.Deleted then begin
      total := 0;
      for b:=1 to rec.Ays do if (not rec.Ay[b].Paid) then total := total + rec.Ay[b].Cost;
      if Outln(towhere,Fix(rec.Name,30)+' '+Fix(rec.Tel,20)+' '+RFix(cn2b(c2s(total)),20)) then
        if readkey = #27 then exit else begin
          ResetScreen;
          WriteHeader;
        end;
    end;
  end;
  T.Done;
  writeln;
  TextColor(Cyan);
  write('Cikti sona erdi. Devam etmek icin bir tu$a basiniz');
  readkey;
end;

procedure KayitSil;
var
  s:String;
  T:TDosStream;
  offs:longint;
  b:byte;
  rec:TTaksRec;
begin
  ResetScreen;
  TextColor(Cyan);
  Writeln('Mu$teri kaydi silme'#13#10);
  if not Input('Adi soyadi',s,'') then exit;
  XIntlFastUpper(s);
  T.Init(taksFile,stOpen);
  while T.GetPos < T.GetSize do begin
    offs := T.GetPos;
    T.Read(rec,SizeOf(rec));
    if not rec.Deleted then if rec.Name = s then begin
      TextColor(White);
      writeln;
      for b:=1 to rec.Ays do if not rec.Ay[b].Paid then
        if GetKey('Bu ki$inin henuz odemedigi taksitler var. Israrli misiniz? (E/H)',['E','H'],'H') <> 'E' then exit
           else break;
      rec.Deleted := true;
      T.Seek(offs);
      T.Write(rec,SizeOf(rec));
      T.Done;
      writeln;
      TextColor(Cyan);
      writeln('Mu$teri hakkindaki tum bilgiler silindi. Bir tu$a basiniz');
      readkey;
      exit;
    end;
  end;
  T.Done;
end;

procedure Tahsilat;
var
  s:String;
  T:TDosStream;
  offs:longint;
  rec:TTaksRec;
  w:word;
  b:byte;
begin
  ResetScreen;
  TextColor(Cyan);
  Writeln('Taksit tahsilati'#13#10);
  if not Input('Adi soyadi',s,'') then exit;
  XIntlFastUpper(s);
  T.Init(taksFile,stOpen);
  while T.GetPos < T.GetSize do begin
    offs := T.GetPos;
    T.Read(rec,SizeOf(rec));
    if not rec.Deleted then if rec.Name = s then begin
      TextColor(White);
      writeln;
      for b:=1 to rec.Ays do if not rec.Ay[b].Paid then begin
        writeln(l2s(b)+'. taksit ('+l2s(rec.Ay[b].Month)+'/'+
                l2s(rec.Ay[b].Year)+') '+cn2b(c2s(rec.Ay[b].Cost))+'TL ');
      end;
      writeln;
      repeat
        if not WInput('Tahsil edilecek taksit numarasi',w,1) then exit;
      until (w >= 1) and (w <= rec.Ays);
      rec.Ay[w].Paid := true;
      T.Seek(offs);
      T.Write(rec,SizeOf(rec));
      T.Done;
      writeln;
      TextColor(Cyan);
      writeln('Tahsilat bilgisi kaydedildi. Devam etmek icin bir tu$a basiniz');
      readkey;
      exit;
    end;
  end;
  T.Done;
end;

procedure AddMusteri;
var
  rec:TTaksrec;
  b:byte;
  y,m,d,dow:word;
  cost:comp;
begin
  ResetScreen;
  TextColor(Cyan);
  Writeln('Yeni mu$teri kaydi'#13#10);
  FillChar(rec,SizeOf(rec),0);
  if not Input('Mu$teri adi   ',rec.Name,'') then exit;
  if not Input('Adres         ',rec.Addr1,'-') then exit;
  if not Input('              ',rec.Addr2,'-') then exit;
  if not Input('              ',rec.Addr3,'-') then exit;
  if not Input('Telefon       ',rec.Tel,'-') then exit;
  XIntlFastUpper(rec.Name);
  GetDate(y,m,d,dow);
  writeln;
  if not WInput('Ba$langic yili',y,y) then exit;
  if not WInput('Ba$langic ayi ',m,m) then exit;
  repeat
    if not WInput('Taksit sayisi ',dow,0) then exit;
  until dow < 25;
  rec.Ays := dow;
  writeln;
  cost := 0;
  for b:=1 to dow do begin
    rec.Ay[b].Year := y;
    rec.Ay[b].Month := m;
    rec.Ay[b].Paid := false;
    if not NInput(l2s(b)+'. taksit tutari',cost,cost) then exit;
    rec.Ay[b].Cost := cost;
    inc(m);
    if m > 12 then begin
      m := 1;
      inc(y);
    end;
  end;
  AppendFile(rec);
end;

function GetMenu:byte;
var
  x:byte;
  n:byte;
  c:char;
  y:integer;
  procedure putchoice(s:string);
  begin
    gotoxy(30,6+((n-1)*2));
    TextColor(LightRed);
    write(n,') ');
    TextColor(Yellow);
    write(s);
    inc(n);
  end;
begin
  ResetScreen;
  ArmeLogo;
  DrawLogo((80-19) div 2,1);
  TextColor(LightGreen);
  n := 1;
  putchoice('Yeni mÅ$teri');
  putchoice('Mu$teri bilgi istemi');
  putchoice('Aylik borclular listesi');
  putchoice('Tum mu$teri listesi');
  putchoice('Taksit tahsilati');
  putchoice('Mu$teri kaydi sil');
  putchoice('Geri don');
  dec(n);
  repeat
    c := readkey;
    case c of
      #13 : begin
        GetMenu := 1;
        exit;
      end;
      '1'..'7' : begin
        GetMenu := byte(c)-48;
        exit;
      end;
      #27 : begin
        GetMenu := n;
        exit;
      end;
    end; {Case}
  until false;
end;

procedure TaksitTakipEt;
begin
  repeat
     case GetMenu of
       1 : AddMusteri;
       2 : MusteriBilgi;
       3 : AylikBorclular;
       4 : TumListe;
       5 : Tahsilat;
       6 : KayitSil;
       7 : exit;
     end; {case}
  until false;
end;

end.
