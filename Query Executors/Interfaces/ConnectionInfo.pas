unit ConnectionInfo;

interface

type

  TConnectionInfo = record

    HostName: String;
    Port: Integer;
    DatabaseName: String;
    UserName: String;
    Password: String;

    constructor Create(
      HostName: String;
      Port: Integer;
      DatabaseName: String;
      UserName: String;
      Password: String
    );
    
  end;

implementation

{ TConnectionInfo }

constructor TConnectionInfo.Create(HostName: String; Port: Integer;
  DatabaseName, UserName, Password: String);
begin

  Self.HostName := HostName;
  Self.Port := Port;
  Self.DatabaseName := DatabaseName;
  Self.UserName := UserName;
  Self.Password := Password;

end;

end.
