{
p01y - taksit takip rutinleri
}

{$I PDEFS}

unit PStok;

interface

type

  PStokGroupRec = ^TStokGroupRec;
  TStokGroupRec = record
    GroupName   : string[39];
    Offset      : longint;
    Items       : longint;
  end;

  PStokItemRec = ^TStokItemRec;
  TStokItemRec = record
    ItemName   : string[79];

  end;

implementation

end.