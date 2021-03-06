unit BaseSystemAdministrationFormControllerEvents;

interface

uses

  FormEvents,
  Event,
  SysUtils,
  Classes;

type

  TSystemAdministrationPrivilegeFormRequestedEvent = class (TSectionFormRequestedEvent)

    private

      function GetPrivilegeId: Variant;
      
    public

      constructor Create(const PrivilegeId: Variant);

      property PrivilegeId: Variant
      read GetPrivilegeId;
    
  end;

implementation

{ TSystemAdministrationPrivilegeFormRequestedEvent }

constructor TSystemAdministrationPrivilegeFormRequestedEvent.Create(
  const PrivilegeId: Variant);
begin

  inherited;
  
end;

function TSystemAdministrationPrivilegeFormRequestedEvent.GetPrivilegeId: Variant;
begin

  Result := SectionId;
  
end;

end.
