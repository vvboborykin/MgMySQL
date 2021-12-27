{*******************************************************
* Project: MgMySQL
* Unit: uNamingHelper.pas
* Description: Helper class for conversation database names to Delphi valid names
*
* Created: 27.12.2021 22:55:05
* Copyright (C) 2021 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit uNamingHelper;

interface

uses
  System.Classes, System.SysUtils, System.Rtti, System.RegularExpressions;

type
  TNamingHelper = class
  strict private
    FTablePrefix: string;
    FReservedWords: TArray<string>;
    procedure AppendClassMembersToReservedWords(AClass: TClass; ARtti:
        TRttiContext);
    procedure RegisterReservedWords(AExcludeMembersOf: array of TClass);
    function ReplaceInvalidCharacters(ATableName: string): string;
    procedure SetTablePrefix(const Value: string);
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

constructor TNamingHelper.Create(const APrefix: string; AExcludeMembersOf: array of TClass);
begin
  inherited Create;
  FTablePrefix := APrefix;
  RegisterReservedWords(AExcludeMembersOf);
end;

procedure TNamingHelper.AppendClassMembersToReservedWords(AClass: TClass;
    ARtti: TRttiContext);
begin
  var vInstanceRtti := TRttiInstanceType(ARtti.GetType(AClass));

  for var vPropInfo in vInstanceRtti.GetProperties() do
    FReservedWords := FReservedWords + [vPropInfo.Name];

  for var vMethodInfo in vInstanceRtti.GetMethods() do
    FReservedWords := FReservedWords + [vMethodInfo.Name];
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
  Result := FTablePrefix + ReplaceInvalidCharacters(ATableName);
end;

end.

