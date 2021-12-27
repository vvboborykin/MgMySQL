{*******************************************************
* Project: MgMySQL
* Unit: uGenerationTask.pas
* Description: Codegenerator task launcher
*
* Created: 27.12.2021 22:24:22
* Copyright (C) 2021 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit uGenerationTask;

interface

uses
  System.Classes, System.SysUtils, System.Threading, uTaskIndicator,
  uGenerationParameters;

type
  TGenerationTask = class
  public
    /// <summary>TGenerationTask.Generate
    /// Launch generation task
    /// </summary>
    /// <returns> ITask
    /// </returns>
    /// <param name="AParams"> (TGenerationParameters) Generation parameters</param>
    function Generate(AParams: TGenerationParameters): ITask;
  end;

implementation

uses
  uGeneratorData;

function TGenerationTask.Generate(AParams: TGenerationParameters): ITask;
begin
  var vParams: TGenerationParameters := AParams;
  Result := TTask.Run(
    procedure
    var
      vGenerator: TGeneratorData;
    begin
      vGenerator := TGeneratorData.Create(nil);
      try
        vGenerator.Generate(vParams);
      finally
        vGenerator.Free;
      end;
    end);
end;

end.

