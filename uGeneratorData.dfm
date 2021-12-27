object GeneratorData: TGeneratorData
  OldCreateOrder = False
  Height = 295
  Width = 317
  object conMain: TUniConnection
    ProviderName = 'MySQL'
    Database = 's11'
    SpecificOptions.Strings = (
      'MySQL.UseUnicode=True')
    Options.AllowImplicitConnect = False
    Options.KeepDesignConnected = False
    Username = 'dbuser'
    Server = 'localhost'
    Connected = True
    LoginPrompt = False
    Left = 40
    Top = 16
    EncryptedPassword = '9BFF9DFF8FFF9EFF8CFF8CFF88FF90FF8DFF9BFF'
  end
  object MySQLUniProvider: TMySQLUniProvider
    Left = 40
    Top = 72
  end
  object qryTables: TUniQuery
    Connection = conMain
    SQL.Strings = (
      
        'SELECT * FROM information_schema.TABLES t WHERE t.TABLE_SCHEMA =' +
        ' :DatabaseName AND t.TABLE_TYPE = '#39'BASE TABLE'#39)
    BeforeOpen = qryTablesBeforeOpen
    Left = 144
    Top = 16
    ParamData = <
      item
        DataType = ftString
        Name = 'DatabaseName'
        Value = 's11'
      end>
  end
  object qryColumns: TUniQuery
    Connection = conMain
    SQL.Strings = (
      
        'SELECT * FROM information_schema.COLUMNS c WHERE c.TABLE_SCHEMA ' +
        '= :DatabaseName')
    BeforeOpen = qryTablesBeforeOpen
    Left = 144
    Top = 72
    ParamData = <
      item
        DataType = ftString
        Name = 'DatabaseName'
        Value = 's11'
      end>
  end
  object qryRelations: TUniQuery
    Connection = conMain
    SQL.Strings = (
      
        'SELECT * FROM information_schema.KEY_COLUMN_USAGE kcu WHERE kcu.' +
        'TABLE_SCHEMA = :DatabaseName')
    BeforeOpen = qryTablesBeforeOpen
    Left = 144
    Top = 128
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'DatabaseName'
        Value = nil
      end>
  end
end
