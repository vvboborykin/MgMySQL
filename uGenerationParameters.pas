{*******************************************************
* Project: MgMySQL
* Unit: uGenerationParameters.pas
* Description: Codegeneration parameters
*
* Created: 27.12.2021 22:25:41
* Copyright (C) 2021 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit uGenerationParameters;

interface

uses
  System.Classes, System.SysUtils, uTaskIndicator;

type
  TGenerationParameters = class
  private
    FConnectString: string;
    FIndicator: ITaskIndicator;
    FResultFileName: string;
    FTemplateFileName: string;
    procedure SetConnectString(const Value: string);
    procedure SetIndicator(const Value: ITaskIndicator);
    procedure SetResultFileName(const Value: string);
    procedure SetTemplateFileName(const Value: string);
  public
    property ConnectString: string read FConnectString write SetConnectString;
    property Indicator: ITaskIndicator read FIndicator write SetIndicator;
    property ResultFileName: string read FResultFileName write SetResultFileName;
    property TemplateFileName: string read FTemplateFileName write
        SetTemplateFileName;
  end;

implementation

procedure TGenerationParameters.SetConnectString(const Value: string);
begin
  FConnectString := Value;
end;

procedure TGenerationParameters.SetIndicator(const Value: ITaskIndicator);
begin
  FIndicator := Value;
end;

procedure TGenerationParameters.SetResultFileName(const Value: string);
begin
  FResultFileName := Value;
end;

procedure TGenerationParameters.SetTemplateFileName(const Value: string);
begin
  FTemplateFileName := Value;
end;

end.
