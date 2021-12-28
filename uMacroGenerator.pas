{*******************************************************
* Project: MgMySQL
* Unit: uMacroGenerator.pas
* Description: Class for macros expand
*
* Created: 27.12.2021 22:38:21
* Copyright (C) 2021 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit uMacroGenerator;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils, uGeneratorData, uNamingHelper,
  Uni, Data.DB;

type
  TMacroGenerator = class
  strict private
    procedure ExpandClassDeclaration;
    procedure ExpandClassImplementations;
    procedure ExpandForwardDeclarations;
    procedure ExpandTableForwardDeclaration(AStrings: TStrings);
    procedure ExpandUnitName;
    procedure ExpandTablesMacros(ATableProc: TProc<TStrings>; AMacroName,
      AOperationName: string);
    function GetResultUnitName: string;
    function ReplaceMacro(AMacro, AText: string): string;
    procedure SayDone(AOperationName: string);
    procedure SayStarted(AOperationName: string);
  private
    FData: TGeneratorData;
    FNamingHelper: TNamingHelper;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ExpandMacroses(AData: TGeneratorData);
  end;

implementation

constructor TMacroGenerator.Create;
begin
  inherited Create;
  FNamingHelper := TNamingHelper.Create('', [TUniQuery, TUniConnection, TField,
    TFieldDef]);
end;

destructor TMacroGenerator.Destroy;
begin
  FNamingHelper.Free;
  inherited Destroy;
end;

procedure TMacroGenerator.ExpandClassDeclaration;
begin
  // TODO -cMM: TMacroGenerator.ExpandClassDeclaration default body inserted
end;

procedure TMacroGenerator.ExpandClassImplementations;
begin
  // TODO -cMM: TMacroGenerator.ExpandClassImplementations default body inserted
end;

procedure TMacroGenerator.ExpandForwardDeclarations;
begin
  ExpandTablesMacros(ExpandTableForwardDeclaration,
    '{ForwardDeclarations}', 'Generate forward declaration defenitions');
end;

procedure TMacroGenerator.ExpandMacroses(AData: TGeneratorData);
begin
  FData := AData;
  ExpandUnitName();
  ExpandForwardDeclarations();
  ExpandClassDeclaration();
  ExpandClassImplementations();
end;

procedure TMacroGenerator.ExpandTableForwardDeclaration(AStrings: TStrings);
begin
  // TODO -cMM: TMacroGenerator.ExpandTableForwardDeclaration default body inserted
end;

procedure TMacroGenerator.ExpandUnitName;
begin
  ReplaceMacro('UnitName', GetResultUnitName);
end;

procedure TMacroGenerator.ExpandTablesMacros(ATableProc: TProc<TStrings>;
  AMacroName, AOperationName: string);
var
  vMacroStrings: TStrings;
begin
  SayStarted(AOperationName);
  vMacroStrings := TStringList.Create;
  try
    with FData.qryTables do
    begin
      while not Eof do
      begin
        ATableProc(vMacroStrings);
        Next;
      end;
    end;
    ReplaceMacro(AMacroName, vMacroStrings.Text);
  finally
    vMacroStrings.Free;
  end;
  SayDone(AOperationName);
end;

function TMacroGenerator.GetResultUnitName: string;
begin
  Result := TPath.GetFileNameWithoutExtension(FData.Params.ResultFileName);
end;

function TMacroGenerator.ReplaceMacro(AMacro, AText: string): string;
begin
  Result := StringReplace(FData.ResultString, '{' + AMacro + '}', AText, [rfReplaceAll,
    rfIgnoreCase]);
end;

procedure TMacroGenerator.SayDone(AOperationName: string);
begin
  FData.Params.Indicator.ShowTextFmt('"%s" completed', [AOperationName])
end;

procedure TMacroGenerator.SayStarted(AOperationName: string);
begin
  FData.Params.Indicator.ShowTextFmt('"%s" started', [AOperationName])
end;

end.

