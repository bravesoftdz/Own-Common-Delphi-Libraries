unit DatabaseServerAuthentificationService;

interface

uses

  SystemAuthentificationService,
  ClientAccount,
  ClientLogOnInfo,
  AuthentificationData,
  ServiceInfo,
  QueryExecutor,
  DataReader,
  ConnectionInfo,
  QueryExecutorFactory,
  SysUtils,
  Classes;

type

  TUserAccountDbSchemaData = class

    TableName: String;

    UserIdColumnName: String;
    UserLoginColumnName: String;
    UserPasswordColumnName: String;
    UserFriendlyNameColumnName: String;
    
  end;

  IDatabaseServerAuthentificationService =
    interface (ISystemAuthentificationService)
    ['{7A5829F1-B3AC-427B-9A03-5C4B6BACBDCF}']
    
    end;
    
  TDatabaseServerAuthentificationService =
    class (
      TInterfacedObject,
      IDatabaseServerAuthentificationService
    )

      private

        FQueryExecutorFactory: IQueryExecutorFactory;
        FUserAccountDbSchemaData: TUserAccountDbSchemaData;
        FFetchingUserAccountInfoQueryPattern: String;
        
        procedure SetUserAccountDbSchemaData(const Value: TUserAccountDbSchemaData);
        
      protected

        function CreateQueryExecutorFor(
          UserLogOnInfo: TUserLogOnInfo;
          DatabaseServerInfo: TDatabaseServerInfo
        ): IQueryExecutor; virtual;

        function PrepareFetchingUserAccountInfoQuery(
          UserAccountDbSchemaData: TUserAccountDbSchemaData
        ): String; virtual;

        function ExecuteFetchingUserAccountInfoQuery(
          const QueryPattern: String;
          UserLogOnInfo: TUserLogOnInfo;
          QueryExecutor: IQueryExecutor;
          UserAccountDbSchemaData: TUserAccountDbSchemaData
        ): IDataReader; virtual;
        
        function CreateUserAccountFrom(
          DataReader: IDataReader;
          UserAccountDbSchemaData: TUserAccountDbSchemaData
        ): TUserAccount; virtual;

        function GetUserAccountClass: TUserAccountClass; virtual;

        procedure FillUserAccount(
          UserAccount: TUserAccount;
          DataReader: IDataReader;
          UserAccountDbSchemaData: TUserAccountDbSchemaData
        ); virtual;
        
      public

        destructor Destroy; override;
        
        constructor Create(
          UserAccountDbSchemaData: TUserAccountDbSchemaData;
          QueryExecutorFactory: IQueryExecutorFactory
        );

        function Authentificate(
          AuthentificationData: TClientServiceAuthentificationData
        ): TClientAccount;

      public

        property UserAccountDbSchemaData: TUserAccountDbSchemaData
        read FUserAccountDbSchemaData write SetUserAccountDbSchemaData;
        
    end;
    
implementation


{ TDatabaseServerAuthentificationService }

function TDatabaseServerAuthentificationService.Authentificate(
  AuthentificationData: TClientServiceAuthentificationData
): TClientAccount;
var QueryExecutor: IQueryExecutor;
    DataReader: IDataReader;
begin

  QueryExecutor :=
    CreateQueryExecutorFor(
      AuthentificationData.ClientLogOnInfo as TUserLogOnInfo,
      AuthentificationData.ServiceInfo as TDatabaseServerInfo
    );

  DataReader :=
    ExecuteFetchingUserAccountInfoQuery(
      FFetchingUserAccountInfoQueryPattern,
      AuthentificationData.ClientLogOnInfo as TUserLogOnInfo,
      QueryExecutor,
      FUserAccountDbSchemaData
    );

  Result :=
    CreateUserAccountFrom(
      DataReader,
      FUserAccountDbSchemaData
    );
  
end;

constructor TDatabaseServerAuthentificationService.Create(
  UserAccountDbSchemaData: TUserAccountDbSchemaData;
  QueryExecutorFactory: IQueryExecutorFactory
);
begin

  inherited Create;

  FQueryExecutorFactory := QueryExecutorFactory;
  
  FUserAccountDbSchemaData := UserAccountDbSchemaData;

  FFetchingUserAccountInfoQueryPattern :=
    PrepareFetchingUserAccountInfoQuery(UserAccountDbSchemaData);
  
end;

function TDatabaseServerAuthentificationService.CreateQueryExecutorFor(
  UserLogOnInfo: TUserLogOnInfo;
  DatabaseServerInfo: TDatabaseServerInfo
): IQueryExecutor;
var ConnectionInfo: TConnectionInfo;
begin

  ConnectionInfo.HostName := DatabaseServerInfo.Host;
  ConnectionInfo.Port := DatabaseServerInfo.Port;
  ConnectionInfo.DatabaseName := DatabaseServerInfo.Database;
  ConnectionInfo.UserName := UserLogOnInfo.UserName;
  ConnectionInfo.Password := UserLogOnInfo.Password;
  
  Result := FQueryExecutorFactory.CreateQueryExecutor(ConnectionInfo);

end;

function TDatabaseServerAuthentificationService.CreateUserAccountFrom(
  DataReader: IDataReader;
  UserAccountDbSchemaData: TUserAccountDbSchemaData
): TUserAccount;
begin

  Result := GetUserAccountClass.Create;

  try

    FillUserAccount(Result, DataReader, UserAccountDbSchemaData);
    
  except

    on e: Exception do begin

      FreeAndNil(Result);

      raise;
      
    end;

  end;

end;

destructor TDatabaseServerAuthentificationService.Destroy;
begin

  FreeAndNil(FUserAccountDbSchemaData);
  
  inherited;
  
end;

function TDatabaseServerAuthentificationService.
  ExecuteFetchingUserAccountInfoQuery(
    const QueryPattern: String;
    UserLogOnInfo: TUserLogOnInfo;
    QueryExecutor: IQueryExecutor;
    UserAccountDbSchemaData: TUserAccountDbSchemaData
  ): IDataReader;
var QueryParams: TQueryParams;
begin

  QueryParams := TQueryParams.Create;

  try

    QueryParams.Add(
      'p' + UserAccountDbSchemaData.UserLoginColumnName,
      UserLogOnInfo.UserName
    );

    Result :=
      QueryExecutor.ExecuteSelectionQuery(QueryPattern, QueryParams);

    if (Result.RecordCount = 0) or
       (Result.RecordCount > 1)
    then begin

      raise Exception.CreateFmt(
        '������������ "%s" �� ������ ' +
        '�������� �����������',
        [
          UserLogOnInfo.UserName
        ]
      );
      
    end;

  finally

    FreeAndNil(QueryParams);
    
  end;

end;

procedure TDatabaseServerAuthentificationService.FillUserAccount(
  UserAccount: TUserAccount;
  DataReader: IDataReader;
  UserAccountDbSchemaData: TUserAccountDbSchemaData
);
begin

  UserAccount.Identity :=
    DataReader[UserAccountDbSchemaData.UserIdColumnName];

  UserAccount.UserName :=
    DataReader[UserAccountDbSchemaData.UserLoginColumnName];

  UserAccount.UserFriendlyName :=
    DataReader[UserAccountDbSchemaData.UserFriendlyNameColumnName];

end;

function TDatabaseServerAuthentificationService.GetUserAccountClass: TUserAccountClass;
begin

  Result := TUserAccount;
  
end;

function TDatabaseServerAuthentificationService.
  PrepareFetchingUserAccountInfoQuery(
    UserAccountDbSchemaData: TUserAccountDbSchemaData
  ): String;
begin

  Result :=
    Format(
      'SELECT %s,%s,%s FROM %s WHERE %s=:p%s AND %s=:p%s',
      [
        UserAccountDbSchemaData.UserIdColumnName,
        UserAccountDbSchemaData.UserLoginColumnName,
        UserAccountDbSchemaData.UserFriendlyNameColumnName,

        UserAccountDbSchemaData.TableName,

        UserAccountDbSchemaData.UserLoginColumnName,
        UserAccountDbSchemaData.UserLoginColumnName,

        UserAccountDbSchemaData.UserPasswordColumnName,
        UserAccountDbSchemaData.UserPasswordColumnName
      ]
    );

end;

procedure TDatabaseServerAuthentificationService.SetUserAccountDbSchemaData(
  const Value: TUserAccountDbSchemaData);
begin

  FreeAndNil(FUserAccountDbSchemaData);

  FUserAccountDbSchemaData := Value;

end;

end.
