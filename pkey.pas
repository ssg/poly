{
KeyDisk routines for POLY
}

unit PKey;

interface

function  PrepKeyDisk(drive:byte; code:string; datelimit:boolean):boolean;
function  ReadCode(drive:byte; var s:string; var date:word):boolean;
procedure InitCodes;
procedure XORBuf(var buf; size:word; const code:string);

implementation

uses

{$IFDEF DPMI}
  WinAPI,XDPMI,
{$ENDIF}

  Debris,Objects,XBuf,Dos,Disk;

const

  stdSPT   = 11;
  stdGAP   = 2;
  stdBPS   = 2;
  stdHead  = 1;
  stdTrack = 81;

const

  maxtries = 5;

const

  CodeCounter : byte = 1;
  OldExitProc : pointer = NIL;

procedure InitCodes;
begin
  CodeCounter := 1;
end;

procedure XORBuf;
type
  PXArray = ^TXArray;
  TXArray = array[0..65500] of byte;
var
  P:PXArray;
  w:word;
begin
  if size = 0 then exit;
  P := @buf;
  for w:=0 to size-1 do begin
    P^[w] := P^[w] xor byte(code[CodeCounter]);
    inc(CodeCounter);
    if CodeCounter > length(code) then CodeCounter := 1;
  end;
end;

type

  TBuf = record
    Key  : string;
    Date : longint;
    CRC  : longint;
    padding:array[1..248] of byte;
  end;

var
  DPT    : PDPT absolute 0:$78;
  OrigDPT : TDPT;
  safeBuf : TBuf;
  safeBuf1: TBuf;

procedure PrepDPT(SPT:byte);
begin
  with DPT^ do begin
    SectorsPerTrack := SPT;
  end;
end;

function FormatTrack(drive:byte; SPT,GAP,BPS,Head:Byte; Track:word):boolean;
var
  tries:byte;
  exitcode:byte;
begin
  FormatTrack := false;
  PrepDPT(SPT);
  ResetDisk(drive);
  for tries := 1 to maxtries do begin
    exitcode := FormatCylinder(drive,Head,SPT,BPS,2,Track);
    if exitcode = 0 then begin
      FormatTrack := true;
      break;
    end else ResetDisk(drive);
  end;
end;

procedure SaveDPT;
begin
  Move(DPT^,OrigDPT,SizeOf(TDPT));
end;

procedure RestoreDPT;
begin
  Move(OrigDPT,DPT^,SizeOf(TDPT));
end;

function DWrite(drive:byte; var buf:TBuf):boolean;
var
  tries:byte;
  exitcode:byte;
begin
  PrepDPT(stdSPT);
  safeBuf := buf;
  exitcode := SafeWrite(safeBuf,drive,stdHead,1,1,stdTrack);
  if exitcode <> 0 then begin
    safeBuf1 := buf;
    exitcode := SafeWrite(safeBuf1,drive,stdHead,1,1,stdTrack);
  end;
  DWrite := exitcode =0;
end;

function DRead(drive:byte; var buf:TBuf):boolean;
var
  tries:byte;
  exitcode:byte;
begin
  PrepDPT(stdSPT);
  exitcode := SafeRead(safeBuf,drive,stdHead,1,1,stdTrack);
  if exitcode <> 0 then begin
    exitcode := SafeRead(safeBuf1,drive,stdHead,1,1,stdTrack);
    if exitcode = 0 then buf := safeBuf1;
  end else buf := safeBuf;
  DRead := exitcode = 0;
end;

function PrepKeyDisk;
var
  buf:TBuf;
begin
  PrepKeyDisk := false;
  SaveDPT;
  if FormatTrack(drive,stdSPT,stdGAP,stdBPS,stdHead,stdTrack) then begin
    Buf.Key := code;
    if datelimit then Buf.Date := GetSysMoment else Buf.Date := 0;
    Buf.CRC := GetCheckSum32(buf.key[0],length(Buf.key)+1);
    InitCodes;
    XORBuf(buf,SizeOf(TBuf),'SSG');
    Move(buf,safeBuf,SizeOf(TBuf));
    if DWrite(drive,safeBuf) then
      if DRead(drive,safeBuf) then
        if BufCmp(buf,safeBuf,SizeOf(TBuf)) then PrepKeyDisk := true;
  end;
  RestoreDPT;
end;

function ReadCode;
var
  buf:TBuf;
  b:byte;
  sub:longint;
  sbb:byte;
begin
  ReadCode := false;
  s := '';
  SaveDPT;
  ResetDisk(drive);
  if not DRead(drive,safeBuf) then exit;
  InitCodes;
  XORbuf(safeBuf,SizeOf(TBuf),'SSG');
  move(safeBuf,buf,SizeOf(TBuf));
  s := buf.key;
  date := LongRec(buf.date).Hi;
  sub := GetCheckSum32(buf.key[0],length(buf.key)+1)-buf.CRC;
  sbb := sub;
  for b:=1 to length(s) do s[b] := char(byte(s[b])+(sbb*random(3)));
  ReadCode := sub=0;
  RestoreDPT;
end;

end.