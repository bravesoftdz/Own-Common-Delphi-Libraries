unit SimpleDateRangePanelUnit;

interface

uses SysUtils, Classes, Controls, ComCtrls, ExtCtrls, Cloneable;

type

  TDateTimeRange = class;

  TSimpleDateRangePanel = class (TPanel)

    private

      FLeftDateTimePicker, FRightDateTimePicker: TDateTimePicker;

      function GetLeftDateTime: TDateTime;
      function GetRightDateTime: TDateTime;

      procedure SetLeftDateTime(const LeftDateTime: TDateTime);
      procedure SetRightDateTime(const RightDateTime: TDateTime);

    public

      constructor Create(AOwner: TComponent); overload; override;
      constructor Create(
        LeftDateTimePicker, RightDateTimePicker: TDateTimePicker;
        AOwner: TComponent
      ); overload;

      function GetCurrentDateTimeRange: TDateTimeRange;

      procedure AssignFromDateTimeRange(
        const DateTimeRange: TDateTimeRange
      );

      property LeftDateTime: TDateTime
      read GetLeftDateTime write SetLeftDateTime;

      property RightDateTime: TDateTime
      read GetRightDateTime write SetRightDateTime;

      property LeftDateTimePicker: TDateTimePicker
      read FLeftDateTimePicker write FLeftDateTimePicker;

      property RightDateTimePicker: TDateTimePicker
      read FRightDateTimePicker write FRightDateTimePicker;

      function GetLeftFormattedDateTimeString(const Format: String): String;
      function GetRightFormattedDateTimeString(const Format: String): String;

  end;

  TDateTimeRange = class (TCloneable)

    public

      LeftDateTime: TDateTime;
      RightDateTime: TDateTime;

      constructor Create; overload;
      constructor Create(const ALeftDateTime, ARightDateTime: TDateTime); overload;

      function Clone: TObject; override;
      
  end;

implementation

{ TSimpleDateRangePanel }

constructor TSimpleDateRangePanel.Create(AOwner: TComponent);
begin

  inherited;

end;

procedure TSimpleDateRangePanel.AssignFromDateTimeRange(
  const DateTimeRange: TDateTimeRange);
begin

  LeftDateTime := DateTimeRange.LeftDateTime;
  RightDateTime := DateTimeRange.RightDateTime;
  
end;

constructor TSimpleDateRangePanel.Create(LeftDateTimePicker,
  RightDateTimePicker: TDateTimePicker; AOwner: TComponent);
begin

  inherited Create(AOwner);

  Self.LeftDateTimePicker := LeftDateTimePicker;
  Self.RightDateTimePicker := RightDateTimePicker;

end;

function TSimpleDateRangePanel.GetCurrentDateTimeRange: TDateTimeRange;
begin

  Result := TDateTimeRange.Create(LeftDateTime, RightDateTime);
  
end;

function TSimpleDateRangePanel.GetLeftDateTime: TDateTime;
begin

  Result := FLeftDateTimePicker.DateTime;

end;

function TSimpleDateRangePanel.GetRightDateTime: TDateTime;
begin

  Result := FRightDateTimePicker.DateTime;

end;

procedure TSimpleDateRangePanel.SetLeftDateTime(const LeftDateTime: TDateTime);
begin

  FLeftDateTimePicker.DateTime := LeftDateTime;

end;

procedure TSimpleDateRangePanel.SetRightDateTime(const RightDateTime: TDateTime);
begin

  FRightDateTimePicker.DateTime := RightDateTime;
  
end;

function TSimpleDateRangePanel.GetLeftFormattedDateTimeString(const Format: String): String;
begin

  Result :=
    FormatDateTime(
      Format,
      FLeftDateTimePicker.DateTime
    );

end;

function TSimpleDateRangePanel.GetRightFormattedDateTimeString(const Format: String): String;
begin

  Result :=
    FormatDateTime(
      Format,
      FRightDateTimePicker.DateTime
    );

end;

{ TDateTimeRange }

constructor TDateTimeRange.Create;
begin

  inherited;
  
end;

function TDateTimeRange.Clone: TObject;
begin

  Result := TDateTimeRange.Create(LeftDateTime, RightDateTime);
  
end;

constructor TDateTimeRange.Create(const ALeftDateTime,
  ARightDateTime: TDateTime);
begin

  inherited Create;

  LeftDateTime := ALeftDateTime;
  RightDateTime := ARightDateTime;
  
end;

end.
