uses

  XTypes,XIO,Objects,Dos;

var
  T:TDosStream;
  l:longint;
  D:DateTime;
  dow:word;
  h:TEXEHeader;
begin
  if ParamCount <> 1 then XAbort('Usage: PEXE filename');
  T.Init(paramStr(1),stOpen);
  if T.Status <> stOK then XAbort(#7'open error'#7);
  GetDate(D.Year,D.Month,D.Day,dow);
  PackTime(D,l);
  T.Read(h,SizeOf(h));
  h.Unused1 := LongRec(l).Hi;
  h.Unused2 := LongRec(l).Hi xor $FFFF;
  T.Seek(0);
  T.Write(h,SizeOf(h));
  if T.Status <> stOK then XAbort(#7'write error'#7);
  T.Done;
end.