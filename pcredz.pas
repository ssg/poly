{
 WASTED YEARS / Iron Maiden

From the coast of gold, across the seven seas,
I'm travellin on for and wide
But now it seems, I'm just a stranger to myself
And all the things I sometimes do, it isn't me but someone else

I close my eyes, and think of home
Another city goes by in the night
Ain't it funny how it is, you never miss it 'til its gone away
And my heart is lying there and will be 'til my dying day

So understand
Don't waste your time always searching for those wasted years
Face up... make your stand
And realise you're living in the golden years

Too much time on my hands, I got you on my mind
Can't ease this pain, so easily
When you can't find the words to say it's hard to make it through another day
And it just makes me wanna cry and throw my hands up to the sky
}

unit PCredz;

interface

procedure ShowCredits;
procedure Sync;

implementation

uses

  XGfx,PProcs,Xbuf,XKey;

type

  pbyte = ^byte;

  TPeople = record
    Pic   : pointer;
    Text  : pointer;
  end;

procedure P1;external;
{$L p1.obj}

procedure P2;external;
{$L p2.obj}

procedure P3;external;
{$L p3.obj}

procedure P4;external;
{$L p4.obj}

procedure t1;external;
{$L t1.obj}

procedure t2;external;
{$L t2.obj}

procedure t3;external;
{$L t3.obj}

procedure t4;external;
{$L t4.obj}

const

  imgWidth  = 66;
  imgHeight = 71;

  maxpeople = 4;

  people : array[1..maxpeople] of TPeople =
  (
    (Pic:@p1; Text:@t1),
    (Pic:@p2; Text:@t2),
    (Pic:@p3; Text:@t3),
    (Pic:@p4; Text:@t4)
  );

  outColor = 200;
  outOffs  = 80;

  MurderIntentions : boolean = false;

var

  NullPalette : array[1..256*3] of byte;

procedure Pal;external;
{$L pal.obj}

procedure BIOSFntProc;external;
{$L polyfnt.obj}

function IHaveToSayTheWords:boolean;
begin
  if keypressed then MurderIntentions := true;
  IHaveToSayTheWords := MurderIntentions;
end;

procedure putchar(x,y:word; c:char);
var
  ix,iy:word;
  p:pbyte;
  color:byte;
begin
  p := @biosfntproc;
  inc(word(P),byte(c)*8);
  for iy:=0 to 7 do begin
    for ix:=0 to 7 do begin
      if (p^ and (1 shl (7-ix))) > 0 then color := outColor
                                 else color := 0;
      mem[segA000:((iy+y)*320)+(ix+x)] := color;
    end;
    inc(word(P));
  end;
end;

procedure putstr(x,y:word; s:string);
var
  b:byte;
begin
  for b:=1 to length(s) do putchar(x+((b-1)*8),y,s[b]);
end;

procedure putimg(p:pointer);assembler;
asm
  cld
  push  ds
  mov   ax,SegA000
  mov   es,ax
  xor   di,di
  lds   si,p
  lodsw
  mov   bx,ax
  mov   dx,320
  sub   dx,bx
  lodsw
  mov   cx,ax
@loop:
  push  cx
  mov   cx,bx
  rep   movsb
  add   di,dx
  pop   cx
  loop  @loop
  pop   ds
end;

procedure SetPalette(Pal:pointer);assembler;
asm
  cld
  mov     dx,$3C8
  mov     cx,256*3
  push    ds
  lds     si,Pal
  xor     al,al
  out     dx,al
  inc     dx
  repz    outsb
  pop     ds
end;

procedure GetPalette(P:Pointer); assembler;
asm
               cld
               mov     dx,$3C7
               mov     cx,256*3
               les     di,P
               xor     al,al
               out     dx,al
               inc     dl
               inc     dl
               repz    insb
end;

procedure SmoothPalette(P:Pointer);
var
  CP    : array[1..256*3] of byte;
  b     : boolean;
begin
  GetPalette(@CP);
  b := false;
  repeat
    if b then asm
      mov  dx,3dah
    @1:
      in   al,dx
      test al,8
      jne   @1
    @2:
      in   al,dx
      test al,8
      je  @2

      xor al,al
      mov b,al
    end else b := true;
    asm
      les  di,P
      push ds
      mov  ax,ss
      mov  ds,ax
      lea  si,cp
      mov  cx,768
    @loop:
      mov  al,byte ptr [si]
      cmp  al,es:[di]
      je   @continue
      ja   @dec
      inc  byte ptr [si]
      jmp  @continue
    @dec:
      dec  byte ptr [si]
    @continue:
      inc  di
      inc  si
      loop @loop
      pop  ds
    end;
    SetPalette(@CP);
  until BufCmp(CP,P^,768);
end;

procedure Sync;assembler;
asm
  mov dx,3dah
@1:
  in  al,dx
  test al,8
  jne @1
@2:
  in  al,dx
  test al,8
  je   @1
end;

type

  PWord = ^word;

procedure tty(p:PChar);
var
  pw:PWord;
  w:word;
  x,y:word;
  timer:pword;
  start:word;
begin
  timer := Ptr(Seg0040,$6c);
  x := outOffs;
  y := 0;
  repeat
    if IhaveToSayTheWords then exit;
    putchar(x,y,'_');
    case p[0] of
      #27 : exit;
      #13 : begin
        putchar(x,y,' ');
        inc(y,8);
        x := outOffs;
        putchar(x,y,'_');
      end;
      #8 : begin
        putchar(x,y,' ');
        dec(x,8);
        putchar(x,y,'_');
      end;
      else begin
        putchar(x,y,p[0]);
        inc(x,8);
        putchar(x,y,'_');
      end;
    end; {case}
    inc(word(P));
    pw := pword(P);
    w := pw^;
    if w > 3 then w := 3;
    start := timer^;
    while timer^-start < w do ;
    inc(word(P),2);
  until false;
end;

procedure ShowCredits;
var
  b:byte;
  w:word;
begin
  asm
    mov ax,13h
    int 10h
  end;
  MurderIntentions := false;
  SetPalette(@nullpalette);
  repeat
    for b:=1 to maxpeople do begin
      putimg(people[b].pic);
      SmoothPalette(@Pal);
      smoothpalette(@pal);
      tty(people[b].text);
      if IHaveToSayTheWords then break;
      for w:=1 to 100 do Sync;
      SmoothPalette(@NullPalette);
      FillChar(Mem[SegA000:0],64000,0);
    end;
    if IHaveToSayTheWords then break;
  until false;
end;

begin
  FillChar(nullpalette,SizeOf(nullpalette),0);
end.