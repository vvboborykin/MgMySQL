{*******************************************************
* Project: MgMySQL
* Unit: uNamingHelper.pas
* Description: Helper class for conversation database names to Delphi valid names
*
* Created: 27.12.2021 22:55:05
* Copyright (C) 2021 Áîáîðûêèí Â.Â. (bpost@yandex.ru)
*******************************************************}
unit uNamingHelper;

interface

uses
  System.Classes, System.SysUtils, System.Rtti, System.StrUtils,
  System.RegularExpressions;

type
  TNamingHelper = class
  strict private
    FTablePrefix: string;
    FReservedWords: TArray<string>;
    procedure AppendClassMembersToReservedWords(AClass: TClass; ARtti:
      TRttiContext);
    procedure AppendClassNamesToReservedWords(AClass: TClass);
    function IsReservedWord(AText: string): Boolean;
    function ToNotReservedWord(AText: string): string;
    procedure RegisterReservedWords(AExcludeMembersOf: array of TClass);
    function ReplaceInvalidCharacters(ATableName: string): string;
    procedure SetTablePrefix(const Value: string);
    function ToUpperFirstChar(AText: string): string;
  private
  public
    constructor Create(const APrefix: string; AExcludeMembersOf: array of TClass);
    function TableNameToClassName(ATableName: string): string;
    function TableNameToInterfaceName(ATableName: string): string;
    function TableNameToObjectName(ATableName: string): string;
    //
    property TablePrefix: string read FTablePrefix write SetTablePrefix;
  end;

implementation

const
  cDelphiLanguageReservedWords: array of string = ['and', 'end', 'interface',
    'record', 'var', 'array', 'except', 'is', 'repeat', 'while', 'as', 'exports',
    'label', 'resourcestring', 'with', 'asm', 'file', 'library', 'set', 'xor',
    'begin', 'finalization   ', 'mod', 'shl', 'case', 'finally', 'nil', 'shr',
    'class', 'for', 'not', 'string', 'const', 'function', 'object', 'then',
    'constructor', 'goto', 'of', 'threadvar', 'destructor', 'if', 'or', 'to',
    'dispinterface     ', 'implementation    ', 'packed', 'try', 'div', 'in',
    'procedure', 'type', 'do', 'inherited', 'program', 'unit', 'downto',
    'initialization', 'property', 'until', 'else', 'inline', 'raise', 'uses',
    'absolute', 'export12', 'name', 'public', 'stdcall', 'abstract', 'external',
    'near1', 'published', 'strict', 'assembler', 'far', 'nodefault', 'read',
    'stored', 'automated', 'final', 'operator', 'readonly', 'unsafe', 'cdecl',
    'forward', 'out', 'reference', 'varargs', 'contains', 'helper', 'overload',
    'register', 'virtual', 'default', 'implements', 'override', 'reintroduce',
    'winapi', 'delayed', 'index', 'package', 'requires', 'write', 'deprecated11',
    'inline', 'pascal', 'resident1', 'writeonly', 'dispid', 'library',
    'platform11', 'safecall', 'dynamic', 'local', 'private', 'sealed',
    'experimental11', 'message', 'protected', 'static'];
  cDelphiScalarDataTypes: array of string = ['string', 'integer', 'boolean',
    'decimal', 'float', 'double', 'longint', 'int64', 'short', 'byte', 'variant',
    'tvarrec', 'olevariant', 'widestring', 'wchar', 'char'];

constructor TNamingHelper.Create(const APrefix: string; AExcludeMembersOf: array
  of TClass);
begin
  inherited Create;
  FTablePrefix := APrefix;
  FReservedWords := nil;
  RegisterReservedWords(AExcludeMembersOf);
end;

procedure TNamingHelper.AppendClassMembersToReservedWords(AClass: TClass; ARtti:
  TRttiContext);
begin
  AppendClassNamesToReservedWords(AClass);

  var vInstanceRtti := TRttiInstanceType(ARtti.GetType(AClass));

  for var vPropInfo in vInstanceRtti.GetProperties() do
    FReservedWords := FReservedWords + [vPropInfo.Name];

  for var vMethodInfo in vInstanceRtti.GetMethods() do
    FReservedWords := FReservedWords + [vMethodInfo.Name];
end;

procedure TNamingHelper.AppendClassNamesToReservedWords(AClass: TClass);
begin
  FReservedWords := FReservedWords + [AClass.ClassName];
  if AClass <> TObject then
    AppendClassNamesToReservedWords(AClass.ClassParent);
end;

function TNamingHelper.IsReservedWord(AText: string): Boolean;
begin
  Result := (AnsiIndexText(AText, FReservedWords) >= 0) or (AnsiIndexText(AText,
    cDelphiLanguageReservedWords) >= 0) or (AnsiIndexText(AText,
    cDelphiScalarDataTypes) >= 0);
end;

function TNamingHelper.ToNotReservedWord(AText: string): string;
begin
  Result := AText;
  if IsReservedWord(AText) then
    AText := AText + '_';
end;

procedure TNamingHelper.RegisterReservedWords(AExcludeMembersOf: array of TClass);
begin
  var vRtti := TRttiContext.Create;
  try
    for var vClass: TClass in AExcludeMembersOf do
    begin
      AppendClassMembersToReservedWords(vClass, vRtti);
    end;
  finally
    vRtti.Free;
  end;
end;

function TNamingHelper.ReplaceInvalidCharacters(ATableName: string): string;
begin
  Result := TRegEx.Replace(ATableName, '[^\w|\d|\_]', '_');
end;

procedure TNamingHelper.SetTablePrefix(const Value: string);
begin
  FTablePrefix := Value;
end;

function TNamingHelper.TableNameToClassName(ATableName: string): string;
begin
  Result := 'T' + TableNameToObjectName(ATableName);
end;

function TNamingHelper.TableNameToInterfaceName(ATableName: string): string;
begin
  Result := 'I' + TableNameToObjectName(ATableName);
end;

function TNamingHelper.TableNameToObjectName(ATableName: string): string;
begin
  Result := ToUpperFirstChar(ToNotReservedWord(FTablePrefix +
    ReplaceInvalidCharacters(ATableName)));
end;

function TNamingHelper.ToUpperFirstChar(AText: string): string;
begin
  if AText = '' then
    Result := ''
  else
    Result := AnsiUpperCase(AText[1]) + RightStr(AText, Length(AText) - 1);
end;

end.

