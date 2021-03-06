unit ReferenceFormViewModel;

interface

uses

  ReferenceFormDataSetHolder,
  SysUtils,
  Classes;
  
type

  TReferenceFormViewModel = class

    private
    
    protected

      FDataSetHolder: TReferenceFormDataSetHolder;

      procedure SetDataSetHolder(const Value: TReferenceFormDataSetHolder);

    public

      ViewRecordsAllowed: Boolean;
      AddingRecordAllowed: Boolean;
      EditingRecordAllowed: Boolean;
      RemovingRecordAllowed: Boolean;

    public

      destructor Destroy; override;

      property DataSetHolder: TReferenceFormDataSetHolder
      read FDataSetHolder write SetDataSetHolder;
    
  end;

  TReferenceFormViewModelClass = class of TReferenceFormViewModel;
  
implementation

{ TReferenceFormViewModel }

destructor TReferenceFormViewModel.Destroy;
begin

  DataSetHolder := nil;
  
  inherited;

end;

procedure TReferenceFormViewModel.SetDataSetHolder(
  const Value: TReferenceFormDataSetHolder);
begin

  if FDataSetHolder = Value then
    Exit;

  FreeAndNil(FDataSetHolder);

  FDataSetHolder := Value;

end;

end.
