{
  þ seems ok...
}

uses

  XStr,Crt,XIO,PKey;

var
  code:string;
  verify:string;
  drive:byte;
  datelimit:boolean;
begin
  if paramcount = 1 then drive := s2l(ParamStr(1)) else drive := 0;
  repeat
    write('Enter code (end with ! to indicate time limit):');
    readln(code);
    if pos(' ',code) > 0 then writeln(#7'Code cannot contain spaces!');
  until pos(' ',code) = 0;
  datelimit := code[length(code)] = '!';
  if datelimit then dec(byte(code[0]));
  asm
    mov ax,1704h
    mov dl,drive
    int 13h
  end;
  repeat
    write('preparing '+code+'...');
    if PrepKeyDisk(drive,code,datelimit) then writeln('done') else writeln('failed!');
    write(#13#10'Enter Y to create another with this code, other key to quit');
    if upcase(readkey) <> 'Y' then break;
    writeln(#13#10);
  until false;
  writeln(#13#10'finished');
end.