 Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,math,Dialogs,parsemath;

type
  matriz = array of array of string;
  TMetodoAbiertos = class
    private

    public
      function Derivar(h,x :real) : real;
      function PuntoFijo(X0,es:real;imax: Integer;funcion:string;gx:string) : matriz;
      function Newton(X0,EX:real;MAXIT: Integer;funcion:string) : matriz;
      function Secante(X0,EX:real;MAXIT: Integer;funcion:string) : matriz;
      function DF(h,x :real) : real;
      constructor create();
      destructor Destroy(); override;

  end;

implementation

constructor TMetodoAbiertos.create();
begin

end;

destructor TMetodoAbiertos.Destroy();
begin
end;

function TMetodoAbiertos.Derivar(h,x:real) : real;
begin
  Result := (Fx(x+h)-Fx(x-h))/(2*h);
end;

function TMetodoAbiertos.Newton(X0,TOL,EX:real;MAXIT: Integer;funcion:string) : matriz;
var
  cont,i : Integer;
  x,xn,vdr, e,e1,e2,ant,temp,temp1,temp2: real;
  M : matriz;
  funtion : TParseMath;
begin
  ant := X0;
  SetLength(M,MAXIT,5);
  funtion := TParseMath.create();
  funtion.Expression := funcion;
  funtion.AddVariable('x',0);

   cont := 1;
   i := 1;
   x := 0;

    M[0,0] := FloatToStr(X0);
    M[0,1] := FloatToStr(ant);
    M[0,2] := '-';
    M[0,3] := '-';
    M[0,4] := '-';

   funtion.NewValue('x',X0); temp := funtion.Evaluate();
   if(temp = 0) then
   begin
        M[i,0] := FloatToStr(X0);
        M[i,1] := FloatToStr(X0);
        result := M;
        ShowMessage('RESULTADO: '+FloatToStr(X0));
        exit();
   end;
  while(cont<MAXIT) do
  begin
    xn := x;

    funtion.NewValue('x',(X0+0.0001)); temp1 := funtion.Evaluate();
    funtion.NewValue('x',(X0-0.0001)); temp2 := funtion.Evaluate();
    vdr := ((temp1-temp2)/(2*0.0001));
    {vdr := DF(0.0001,X0);}

    if(vdr = 0) then
    begin
         X0 := X0-EX;
         funtion.NewValue('x',(X0+0.0001)); temp1 := funtion.Evaluate();
         funtion.NewValue('x',(X0-0.0001)); temp2 := funtion.Evaluate();
         vdr := ((temp1-temp2)/(2*0.0001))
         {vdr := DF(0.00001,X0);}
    end;
    funtion.NewValue('x',X0); temp := funtion.Evaluate();
    x := X0-(temp/vdr);

    e := Abs(xn-x);
    e1 := Abs((xn-x)/x);
    e2 := Abs((xn-x)/x*100);

    M[i,0] := FloatToStr(xn);
    M[i,1] := FloatToStr(x);
    M[i,2] := FloatToStr(e);
    M[i,3] := FloatToStr(e1);
    M[i,4] := FloatToStr(e2);
    i := i + 1;
    {if(Abs(x-X0)<TOL) then
    begin
      M[i,0] := xn;
      M[i,1] := x;
      Result := M;
    end;}
    funtion.NewValue('x',x); temp := funtion.Evaluate();
    if(Abs(e)<EX) then
    begin

      {M[i,0] := FloatToStr(xn);
      M[i,1] := FloatToStr(x);}
      Result := M;
      exit();

    end;
  X0 := x;
  cont := cont+1;
  end;
  Result := M;
end;

function TMetodoAbiertos.Secante(X0,TOL,EX:real;MAXIT: Integer;funcion :string) : matriz;
var
  cont,i : Integer;
  x,xn,h,di, e,e1,e2,ant,temp,temp1,temp2,temp3: real;
  M : matriz;
  funtion : TParseMath;
begin
  SetLength(M,MAXIT,5);
  funtion := TParseMath.create();
  funtion.Expression := funcion;
  funtion.AddVariable('x',0);
  ant := X0;
  h := 0.00000001;
  x := 0;
  cont := 1;
  i := 1;

  M[0,0] := FloatToStr(X0);
  M[0,1] := FloatToStr(ant);
  M[0,2] := '-';
  M[0,3] := '-';
  M[0,4] := '-';

  funtion.NewValue('x',X0); temp:= funtion.Evaluate();
  if(temp = 0) then
  begin
        M[i,0] := FloatToStr(X0);
        M[i,1] := FloatToStr(X0);
        Result := M;
        showMessage('RESULTADO  '+FloatToStr(X0));
        exit();
  end;

  while(cont<MAXIT) do
  begin
    xn := x;

    funtion.NewValue('x',(X0+h)); temp1 := funtion.Evaluate();
    funtion.NewValue('x',(X0-h)); temp2 := funtion.Evaluate();
    di := (temp1-temp2);
    if(di = 0) then
    begin
         di := di + 0.00001;
    end;
    funtion.NewValue('x',X0); temp := funtion.Evaluate();
    x := X0-((2*h*temp)/di);

    e := Abs(xn-x);
    e1 := Abs((xn-x)/x);
    e2 := Abs((xn-x)/x*100);

    M[i,0] := FloatToStr(xn);
    M[i,1] := FloatToStr(x);
    M[i,2] := FloatToStr(e);
    M[i,3] := FloatToStr(e1);
    M[i,4] := FloatToStr(e2);
    i := i + 1;

    {if(Abs(x-X0)<TOL) then
    begin
      showMessage(FloatToStr(x));
      exit();
    end;}
    funtion.NewValue('x',x); temp3 := funtion.Evaluate();
    if(ABS(e)<EX) then
    begin
         {showMessage(FloatToStr(x));}
         Result := M;
         exit();
    end;
  X0 := x;
  cont := cont+1;
  end;
  Result := M;
end;
end.





type
  TInterseccion=class
    public


  end;

implementation

end.

