unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, Forms, Controls, Graphics, Dialogs,
  StdCtrls, LCLType, ExtCtrls, ColorBox, ComCtrls, Grids, ValEdit, ParseMath,
  TASeries, TAFuncSeries, TARadialSeries, TATools, TAChartExtentLink, Types,
  Interseccion, math;

type
  vector=array [0..5] of String;

  { TForm1 }
  TForm1 = class(TForm)
    bDetener: TButton;
    bReset: TButton;
    Button1: TButton;
    Button2: TButton;
    Carro: TPanel;
    Chart1: TChart;
    Aceleracion: TLineSeries;
    Label10: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Vector: TCheckBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Panel6: TPanel;
    Panel7: TPanel;
    Flecha: TPanel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    valorX: TLabel;
    valorV: TLabel;
    ValorA: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    x0: TEdit;
    v0: TEdit;
    ac: TEdit;
    Velocidad: TLineSeries;
    Posicion: TLineSeries;
    Chart2: TChart;
    Chart3: TChart;
    Chart4: TChart;
    lineX: TConstantLine;
    ChartToolset1: TChartToolset;
    ChartToolset1DataPointClickTool1: TDataPointClickTool;
    ChartToolset1ZoomMouseWheelTool1: TZoomMouseWheelTool;
    ListBox1: TListBox;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Timer1: TTimer;
    trbarVisible: TTrackBar;
    procedure bComenzarClick(Sender: TObject);
    procedure bDetenerClick(Sender: TObject);
    procedure bResetClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Label6Click(Sender: TObject);
    procedure Panel4Click(Sender: TObject);
    procedure VectorChange(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure v0Change(Sender: TObject);
  private
    pre : vector;
    contador:Integer;
    mov:Integer;
    min,
    max: Real;
    Parse  : TparseMath;
    State : Boolean;
    idPregunta : Integer;
    function f( x: Real ): Real;
    function Fposicion(vx0,vv0,vac,t:real):Real;
    function Fvelocidad(vv0,vac,t:Real):Real;
    function Faceleracion(x:Real):Real;
    procedure Graphic2D(x,vx0,vv0,vac,t:Real);

  public

  end;

var
  Form1: TForm1;

implementation


procedure TForm1.FormCreate(Sender: TObject);
var
  i : Integer;
begin

  for i:=0 to 4 do
  begin
      pre[i] := 'pregunta' +IntToStr(i) +'.txt';
  end;

  min:= -5.0;
  max:= 5.0;
  Parse:= TParseMath.create();
  Parse.AddVariable('x', min);
  mov:=0;
  lineX.Pen.Width := 2;
  Flecha.Visible:= Vector.Checked;
  ListBox1.Items.LoadFromFile(pre[0]);
  idPregunta := 1;
end;

procedure TForm1.Image1Click(Sender: TObject);
begin

end;

procedure TForm1.Image2Click(Sender: TObject);
begin

end;

procedure TForm1.Label6Click(Sender: TObject);
begin

end;

procedure TForm1.Panel4Click(Sender: TObject);
begin

end;

procedure TForm1.VectorChange(Sender: TObject);
begin

end;



procedure TForm1.Timer1Timer(Sender: TObject);
begin
  contador := contador+1;
  Label6.Caption:=IntToStr(contador);
end;

procedure TForm1.v0Change(Sender: TObject);
begin

end;


function TForm1.f( x: Real ): Real;
begin
  Parse.NewValue('x', x);
  Result:= Parse.Evaluate();
end;

function TForm1.Fposicion(vx0,vv0,vac,t:real):Real;
begin
  {fun[0].NewValue('x0',x0);
  fun[0].NewValue('v0',v0);
  fun[0].NewValue('a',ac);
  fun[0].NewValue('t',t);}

  Result:= vx0+vv0*t+(1/2)*vac*power(t,2);
end;

function TForm1.Fvelocidad(vv0,vac,t:Real):Real;
begin
  {fun[1].NewValue('v0',v0);
  fun[1].NewValue('a',ac);
  fun[1].NewValue('t',t);}

  Result:= vv0+vac*t;
end;

function TForm1.Faceleracion(x:Real):Real;
begin
  Result:= x;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Parse.destroy;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i,posf:Integer;
  vx0,vv0,vac,x, h: Real;
  textoUsuario: string;

begin
  Posicion.Clear;
  Velocidad.Clear;
  Aceleracion.Clear;
  posf := 0;
  h:= 0.001;
  min:= 0;
  max:= 5;
  vx0 := StrToFloat(x0.Text);
  vv0 := StrToFloat(v0.Text);
  vac := StrToFloat(ac.Text);
  x:=min;

  Posicion.LinePen.Color:= clLime;
  Posicion.LinePen.Width:= 2;

  Velocidad.LinePen.Color:= clBlue;
  Velocidad.LinePen.Width:= 2;

  Aceleracion.LinePen.Color:= clRed;
  Aceleracion.LinePen.Width:= 2;

  Timer1.Enabled:=True;
  Chart4.Extent.XMin := vx0;
  Chart4.Extent.UseXMin := True;
  i:=10;

  State := True;

  while State do
  begin
      sleep(50);
      Application.ProcessMessages;
      Carro.Left := i;


      if  Vector.Checked then
      begin
          Flecha.Visible:= True;
          Flecha.Left:= i;
      end
      else
          Flecha.Visible := False;

      Posicion.AddXY(contador,Fposicion(vx0,vv0,vac,contador));
      valorX.Caption := FloatToStr(Fposicion(vx0,vv0,vac,contador));
      Chart4.Extent.XMax := Fposicion(vx0,vv0,vac,contador);
      Chart4.Extent.UseXMax := True;
      Velocidad.AddXY(contador,Fvelocidad(vv0,vac,contador));
      ValorV.Caption := FloatToStr(Fvelocidad(vv0,vac,contador));
      Aceleracion.AddXY(contador,vac);
      ValorA.Caption := 'a = ' + FloatToStr(vac) + ' m/s^2';

      i:=i+Round(Fposicion(vx0,vv0,vac,contador));
      if i >= 1250 then
      begin
           i := 1250;
      end;
      if i<= 10 then
      begin
           i := 10;
      end;
      x := x+h;

  end;
  Timer1.Enabled:=False;

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
   ListBox1.Items.Clear;

   ListBox1.Items.LoadFromFile(pre[idPregunta]);
   idPregunta := idPregunta + 1;
   if idPregunta > 4 then
   begin
        idPregunta := 0;
   end;

end;



procedure TForm1.bComenzarClick(Sender: TObject);
begin
  Timer1.Enabled:=True;
  State := True;
end;

procedure TForm1.bDetenerClick(Sender: TObject);
var
  res1, res2 : real;
begin
  Timer1.Enabled:=False;
  State := False;

  res1 := StrToFloat(Edit1.Text);
  res2 := StrToFloat(Edit2.Text);

  if((res1 = StrToFloat(valorX.Caption)) and (res2 = StrToFloat(valorV.Caption)) ) then
  begin
       ShowMessage('Correcto !');
  end
  else
      ShowMessage('Fallaste !');

end;

procedure TForm1.bResetClick(Sender: TObject);
begin
  contador:=0;
  Label6.Caption:=IntToStr(contador);

end;


procedure TForm1.Graphic2D(x,vx0,vv0,vac,t:Real);
begin
  Posicion.AddXY(x,Fposicion(vx0,vv0,vac,t));
  Velocidad.AddXY(x,Fvelocidad(vv0,vac,t));
  Aceleracion.AddXY(x,vac);

  {x := min;
  repeat
    t:=x;
    Posicion.AddXY(x,Fposicion(vx0,vv0,vac,t));
    x := x + h;
  until (x>=max);

  t:=0;
  min:= StrToFloat( ediMin.Text );
  x := min;
  repeat
    t:=x;
    Velocidad.AddXY(x,Fvelocidad(vv0,vac,t));
    x := x + h;
  until (x>=max);

  min:= StrToFloat( ediMin.Text);
  x := min;
  repeat
    Aceleracion.AddXY(x,vac);
    x := x + h;
  until (x>=max);}
end;






{$R *.lfm}

end.


