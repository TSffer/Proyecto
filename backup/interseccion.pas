unit Interseccion;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, MetodosAbiertos, ParseMath, Dialogs;

type
  vector = array of array of real;
  TInterseccion=class
    public
      rows:Integer;
      presicion:real;
      function Bolzano(x,xn:real):boolean;
      function execute(a1,b1:real;funtion:string):vector;
      constructor create();
      destructor Destroy(); override;
    private
  end;

implementation
constructor TInterseccion.create();
begin

end;

destructor TInterseccion.Destroy();
begin
end;

function TInterseccion.Bolzano(x,xn:real):boolean;
begin
   if(x*xn<0) then
   begin
     Result:=True;
   end
   else
   begin
     Result:=False;
   end;
end;

function TInterseccion.execute(a1,b1:real;funtion:string):vector;
var
  cont,i:Integer;
  h:real;
  Ia,Ib,temp1,temp2:real;
  Puntos,Interseccion:vector;
  MetodoAbierto:TMetodoAbiertos;
  fx:TParseMath;
begin
   MetodoAbierto:=TMetodoAbiertos.create();
   h := 0.3;
   fx := TParseMath.create();
   fx.Expression := funtion;
   fx.AddVariable('x',0);
   SetLength(puntos,50,2);
   SetLength(Interseccion,50,2);
   i:=0;
   cont:=0;
   Ia:=a1;
   Ib:=a1+h;
   while(Ib<=b1) do
   begin
     fx.NewValue('x',Ia);
     temp1:=fx.Evaluate();
     fx.NewValue('x',Ib);
     temp2:=fx.Evaluate();

     if(Bolzano(temp1,temp2)=True) then
     begin
       Puntos[i,0]:=Ia;
       i:=i+1;
       cont:=cont+1;
     end;
     Ia:=Ib;
     Ib:=Ib+h;
   end;

   for i:=0 to cont-1 do
   begin
     Interseccion[i,0]:=MetodoAbierto.Secante(Puntos[i,0],presicion,100,funtion);
     fx.NewValue('x',Interseccion[i,0]);
     Interseccion[i,1]:=fx.Evaluate();
     rows:=i;
   end;
   Result:=Interseccion;
end;

end.

