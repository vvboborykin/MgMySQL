{*******************************************************
* Project: MgMySQL
* Unit: uTaskIndicator.pas
* Description: Background Task status indicator
*
* Created: 27.12.2021 22:21:46
* Copyright (C) 2021 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit uTaskIndicator;

interface

type
  ITaskIndicator = interface
  ['{EA8F83B8-C253-42A1-AAA6-C898AD562AC5}']
    procedure ShowDonePercent(ADonePercent: Double); stdcall;
    procedure ShowText(AText: string); stdcall;
    procedure ShowTextFmt(AText: string; AParams: array of const); stdcall;
  end;

implementation

end.

