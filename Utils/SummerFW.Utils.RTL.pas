{
  Summer Framework for Delphi http://github.com/jcangas/SummerFW4D
  SummerFW4D by Jorge L. Cangas <jorge.cangas@gmail.com>
  SummerFW4D - Copyright(c) Jorge L. Cangas, Some rights reserved.
  Your reuse is governed by the Creative Commons Attribution 3.0 License
}

unit SummerFW.Utils.RTL;

interface
uses SysUtils, Classes, Controls;

type
  TOpenEnum = record
  type
    Code = Integer;
    CodeSet = array of Code;
  public  // So we can declare initialized const
    FValue: Code;
    FID: string;
  public
    constructor Create(AValue: Code; AID: string);
    class operator Equal(A: TOpenEnum; B: TOpenEnum): Boolean;
    class operator NotEqual(A: TOpenEnum; B: TOpenEnum): Boolean;
    class operator GreaterThan(A: TOpenEnum; B: TOpenEnum): Boolean;
    class operator GreaterThanOrEqual(A: TOpenEnum; B: TOpenEnum): Boolean;
    class operator LessThan(A: TOpenEnum; B: TOpenEnum): Boolean;
    class operator LessThanOrEqual(A: TOpenEnum; B: TOpenEnum): Boolean;
    class operator Implicit(Enum: TOpenEnum): string;
    class operator Implicit(Enum: TOpenEnum): Integer;
    function ToString: string;
    function MemberOf(Codes: CodeSet): Boolean;
    property Value: Code read FValue;
    property ID: string read FID;
  end;

  Sync = class
  public
    class procedure Lock(obj: TObject; P: TProc);overload;static;
    class function Lock<T>(obj: TObject; F: TFunc<T>): T;overload;static;
  end;

  TUnprotectControl = class(Controls.TControl)
  public
    property Color;
    property Caption;
    property Text;
  end;


  TFreeNotifier = class(TComponent)
  private
    FOnfree: TNotifyEvent;
  published
  public
    constructor Create(AOwner: TObject); reintroduce;
    property OnFree: TNotifyEvent read FOnfree write FOnFree;
    destructor Destroy; override;
  end;


function &Set(Values: array of TOpenEnum): TIntegerSet;
function InterlockedIncrement(var Addend: Integer): Integer;
function InterlockedDecrement(var Addend: Integer): Integer;

implementation

// copied from System Unit
function InterlockedAdd(var Addend: Integer; Increment: Integer): Integer;
asm
      MOV   ECX,EAX
      MOV   EAX,EDX
 LOCK XADD  [ECX],EAX
      ADD   EAX,EDX
end;

function InterlockedIncrement(var Addend: Integer): Integer;
asm
      MOV   EDX,1
      JMP   InterlockedAdd
end;

function InterlockedDecrement(var Addend: Integer): Integer;
asm
      MOV   EDX,-1
      JMP   InterlockedAdd
end;

{ Sync }

class procedure Sync.Lock(obj: TObject; P: TProc);
begin
  TMonitor.Enter(obj);
  try
    P;
  finally
    TMonitor.Exit(obj);
  end;
end;

class function Sync.Lock<T>(obj: TObject; F: TFunc<T>): T;
begin
  TMonitor.Enter(obj);
  try
    Result := F;
  finally
    TMonitor.Exit(obj);
  end;
end;


{ TFreeNotifier }

constructor TFreeNotifier.Create(AOwner: TObject);
begin
  inherited Create(AOwner as TComponent);
end;

destructor TFreeNotifier.Destroy;
begin
  if Assigned(FOnFree) then
    FOnfree(Self);
  inherited;
end;

{ TEnumerated}

constructor TOpenEnum.Create(AValue: TOpenEnum.Code; AID: string);
begin
  FValue := AValue;
  FID := AID;
end;

class operator TOpenEnum.Equal(A, B: TOpenEnum): Boolean;
begin
  Result := A.FValue = B.FValue;
end;

class operator TOpenEnum.NotEqual(A, B: TOpenEnum): Boolean;
begin
  Result := A.FValue <> B.FValue;
end;

function TOpenEnum.ToString: string;
begin
  Result := FID;
end;

function TOpenEnum.MemberOf(Codes: TOpenEnum.CodeSet): Boolean;
var
  I: Integer;
begin
  for I := Low(Codes) to High(Codes) do
    if (Value = Codes[I]) then Exit(True);
  Result := False;
end;
class operator TOpenEnum.GreaterThan(A, B: TOpenEnum): Boolean;
begin
  Result := A.FValue > B.FValue;
end;

class operator TOpenEnum.GreaterThanOrEqual(A, B: TOpenEnum): Boolean;
begin
  Result := A.FValue >= B.FValue;
end;

class operator TOpenEnum.LessThan(A, B: TOpenEnum): Boolean;
begin
  Result := A.FValue < B.FValue;
end;

class operator TOpenEnum.LessThanOrEqual(A, B: TOpenEnum): Boolean;
begin
  Result := A.FValue <= B.FValue;
end;

class operator TOpenEnum.Implicit(Enum: TOpenEnum): Integer;
begin
  Result := Enum.FValue;
end;

class operator TOpenEnum.Implicit(Enum: TOpenEnum): string;
begin
  Result := Enum.ToString;
end;

function &Set(Values: array of TOpenEnum): TIntegerSet;
var
  V: TOpenEnum;
begin
  Result := [];
  for V in Values do
    Include(Result, Ord(V));
end;

end.
