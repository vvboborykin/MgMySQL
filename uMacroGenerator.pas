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
  System.SysUtils, System.Classes, System.IOUtils, uGeneratorData;

type
  TMacroGenerator = class
  strict private
    procedure ExpandClassDeclaration;
    procedure ExpandClassImplementations;
    procedure ExpandForwardDeclarations;
    procedure ExpandUnitName;
    function GetResultUnitName: string;
    function ReplaceMacro(AMacro, AText: string): String;
  private
    FData: TGeneratorData;
  public
    procedure ExpandMacroses(AData: TGeneratorData);
  end;

implementation

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
  // TODO -cMM: TMacroGenerator.ExpandForwardDeclarations default body inserted
end;

procedure TMacroGenerator.ExpandMacroses(AData: TGeneratorData);
begin
  FData := AData;
  ExpandUnitName();
  ExpandForwardDeclarations();
  ExpandClassDeclaration();
  ExpandClassImplementations();
end;

procedure TMacroGenerator.ExpandUnitName;
begin
  ReplaceMacro('UnitName', GetResultUnitName);
end;

function TMacroGenerator.GetResultUnitName: string;
begin
  Result := TPath.GetFileNameWithoutExtension(FData.Params.ResultFileName);
end;

function TMacroGenerator.ReplaceMacro(AMacro, AText: string): String;
begin
  Result := StringReplace(FData.ResultString, '{' + AMacro + '}', AText,
    [rfReplaceAll, rfIgnoreCase]);
end;

end.

