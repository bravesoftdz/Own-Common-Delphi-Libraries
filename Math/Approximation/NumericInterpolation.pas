unit NumericInterpolation;

interface

uses

  SysUtils;

type

  TNumericInterpolation = class sealed

    public

      class function LinearlyInterpolateY(
        const LowerX, LowerY: Double;
        const UpperX, UpperY: Double;
        const Arg: Double
      ): Double; static;
     
  end;

implementation

{ TNumericInterpolation }

class function TNumericInterpolation.LinearlyInterpolateY(
  const LowerX, LowerY: Double;
  const UpperX, UpperY: DOuble;
  const Arg: Double
): Double;
begin

  Result :=
    LowerY +
    ((UpperY - LowerY) / (UpperX - LowerX)) *
    (Arg - LowerX);

end;

end.
