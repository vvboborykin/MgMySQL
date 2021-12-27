{*******************************************************
* Project: MgMySQL
* Unit: uGeneratorData.pas
* Description: Generation data unit
*
* Created: 27.12.2021 22:01:37
* Copyright (C) 2021 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit uGeneratorData;

interface

uses
  System.SysUtils, System.Classes, uGenerationParameters, System.Threading,
  System.IOUtils, System.StrUtils, UniProvider, MySQLUniProvider, Data.DB,
  DBAccess, Uni, MemDS;

type
  TGeneratorData = class(TDataModule)
    conMain: TUniConnection;
    MySQLUniProvider: TMySQLUniProvider;
    qryTables: TUniQuery;
    qryColumns: TUniQuery;
    qryRelations: TUniQuery;
    procedure qryTablesBeforeOpen(DataSet: TDataSet);
  private
    FParams: TGenerationParameters;
    FResultString: string;
    FTask: ITask;
  protected
  strict private
    procedure LoadTemplate;
    procedure OpenConnection;
    procedure OpenData;
    procedure OpenMetadataDatasets;
    procedure ReplaceMacrosesInTemplate;
    procedure SaveResultFile;
    procedure SayGenerationFinished;
    procedure SayGenerationStarted;
    procedure SayMetadataOpened;
    procedure SayOpeningMetadata;
    procedure SayWritingResultToFile;
    procedure SetupConnectionOptions;
  public
    /// <summary>TGeneratorData.Generate
    /// Generate model classes from database structure
    /// </summary>
    /// <param name="AParams"> (TGenerationParameters) </param>
    procedure Generate(AParams: TGenerationParameters);
    property Params: TGenerationParameters read FParams write FParams;
    property ResultString: string read FResultString write FResultString;
    property Task: ITask read FTask write FTask;
  end;

implementation

uses
  uMacroGenerator;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TGeneratorData.Generate(AParams: TGenerationParameters);
begin
  FParams := AParams;
  FTask := TTask.CurrentTask;
  SayGenerationStarted();
  try
    OpenData();
    LoadTemplate();
    ReplaceMacrosesInTemplate();
    SaveResultFile();
  finally
    SayGenerationFinished();
  end;
end;

procedure TGeneratorData.LoadTemplate;
begin
  FResultString := TFile.ReadAllText(FParams.TemplateFileName);
end;

procedure TGeneratorData.OpenConnection;
begin
  conMain.Open;
end;

procedure TGeneratorData.OpenData;
begin
  SetupConnectionOptions();
  OpenConnection();
  OpenMetadataDatasets();
end;

procedure TGeneratorData.OpenMetadataDatasets;
begin
  SayOpeningMetadata();

  qryTables.Open;
  qryColumns.Open;
  qryRelations.Open;

  SayMetadataOpened();
end;

procedure TGeneratorData.qryTablesBeforeOpen(DataSet: TDataSet);
begin
  (DataSet as TUniQuery).ParamByName('DatabaseName').Value := conMain.Database;
end;

procedure TGeneratorData.ReplaceMacrosesInTemplate;
var
  vMacroGen: TMacroGenerator;
begin
  vMacroGen := TMacroGenerator.Create;
  try
    vMacroGen.ExpandMacroses(Self);
  finally
    vMacroGen.Free;
  end;
end;

procedure TGeneratorData.SaveResultFile;
begin
  SayWritingResultToFile();
  TFile.WriteAllText(FParams.ResultFileName, FResultString);
end;

procedure TGeneratorData.SayGenerationFinished;
begin
  var vMessageText: string := 'Generation ';
  var vSuffix := 'completed successfully';
  case FTask.Status of
    TTaskStatus.Canceled:
      vSuffix := 'cancelled by user';
    TTaskStatus.Exception:
      vSuffix := 'failed on exception';
  end;
  vMessageText := vMessageText + vSuffix;
  FParams.Indicator.ShowText(vMessageText);
end;

procedure TGeneratorData.SayGenerationStarted;
begin
  FParams.Indicator.ShowText('Model classes generation started');
end;

procedure TGeneratorData.SayMetadataOpened;
begin
  FParams.Indicator.ShowText('Metadata opened')
end;

procedure TGeneratorData.SayOpeningMetadata;
begin
  FParams.Indicator.ShowText('Opening metadata ...')
end;

procedure TGeneratorData.SayWritingResultToFile;
begin
  FParams.Indicator.ShowText('Writing result to file ' + FParams.ResultFileName);
end;

procedure TGeneratorData.SetupConnectionOptions;
begin
  conMain.ConnectString := FParams.ConnectString;
end;

end.

