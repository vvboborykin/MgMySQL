program MgMySQL;

uses
  Vcl.Forms,
  uMainForm in 'uMainForm.pas' {MainForm},
  uTaskIndicator in 'uTaskIndicator.pas',
  uGenerationTask in 'uGenerationTask.pas',
  uGeneratorData in 'uGeneratorData.pas' {GeneratorData: TDataModule},
  uGenerationParameters in 'uGenerationParameters.pas',
  uMacroGenerator in 'uMacroGenerator.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
