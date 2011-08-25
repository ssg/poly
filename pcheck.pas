{
  þ perfect...
}

uses

  Objects,Debris,XStr,XIO,PKey;

var
  code:string;
  date:word;
  drive:byte;
  l:longint;
begin
  if paramcount=1 then drive := s2l(paramStr(1)) else drive := 0;
  write('reading...');
  code := '';
  if ReadCode(drive,code,date) then writeln('ok') else XAbort('failed!');
  writeln('keydisk code is: ',code);
  Longrec(l).Hi := date;
  if date <> 0 then writeln('time limit start: ',Date2Str(l,true))
               else writeln('keydisk has no time limit');
end.