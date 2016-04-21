unit Unit1;
interface
uses
  jpeg, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Mmsystem, ShellAPI, DBCtrls;

const nmax = 24;     //24

const timeconst = 8;

const vfall = 6;


type
  TForm1 = class(TForm)
    Timer1: TTimer;
    Button1: TButton;
    Label1: TLabel;
    procedure povtor(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
type
  massiv = array[1..500] of record
    x, y : integer;
    a, time : real;
    exist : boolean;
    f : integer;
  end;


var
 // procedure resetgame;
  Form1 : TForm1;
  a,b,c : massiv;
  x0, y0, x, y, x1, y1, per, per1, per2, vopros, zn0 : integer;
  t, k, i, j, q, v1, m, count1, u, sch, zn, uscorenie : integer;
  g, v, vn, vmin, vmax : real;
  s:string;

  planka, fon, fon1, hat, fallhat, doodle1, doodle2, doodle3, doodle4,
   doodle5, snaryad, plank2, plankw, plankb, plankd, planky, plankr,
    prug1, prug2, rocket, rock, spring, pausebut, gift : TBitMap;

  h,z,w, vopr, padenie : boolean;
  f:TPoint;


implementation

uses Unit2;


{$R *.dfm}


{********************************************************************************************************************
*************************************** USEFUL PROCEDURES & FUNCTIONS ***********************************************
********************************************************************************************************************}

procedure nolostplat;
var vopros, vopros2 : integer;
begin
      vopros:=round(random(24 + (u div 1000)));
      if (sch<=3) then
      begin
          if (vopros>=20) then
          begin
            A[nmax].exist:=false;
            sch:=sch+1;
          end
          else
          begin
            A[nmax].exist:=true;
            if (A[nmax].f<>13) then sch:=0 else sch:=sch+1;
          end;
      end
      else
      begin
          A[nmax].exist:=true;
          sch:=0;
          vopros2:=random(3);
            case vopros2 of
              0: A[nmax].f:=0;
              1: begin
                     A[nmax].f:=0;
                     A[nmax].a:= vn + (round(sqrt(u div 7000)));
                 end;
              2: A[nmax].f:=10;
            end;
     //       if (A[nmax].f<>13) then sch:=0 else sch:=sch+1;
      end;
end;
//---------------------------------------

procedure prov(var A : massiv; i : integer);
begin
     if ((A[i].a > 0) and (A[i].x >= Form1.Width - 35 - vn - 10)) then A[i].a:= (-1)*(vn+(round(sqrt(u div 7000))));
     if (A[i].x <= 0) then A[i].a:= vn + (round(sqrt(u div 7000)));
end;

//---------------------------------------

procedure timerforred;
var i:integer;
    j:boolean;
begin
     for i:=1 to nmax do
     begin
         if ((A[i].f=12) and (A[i].time<=0) and (A[i].exist=true)) then
         begin
             A[i].exist:=false;
             if (g<>0) then PlaySound('sound\explodingplatform.wav', 0, SND_ASYNC);
         end;

           if ((A[i].f=11) and ((A[i].y-y)>(-50))) then                         {(50 - n) n - distance to platform}
           begin
               A[i].time:=A[i].time - 0.1;
               A[i].f:=12;
           end;

           if ((A[i].f=12) and (A[i].time>0)) then A[i].time:=A[i].time - 0.1;

     end;
end;

//--------------------------------------

procedure timerforblue;
var i:integer;
begin
    for i:=1 to nmax do
    begin
      if ((A[i].a <> 0) and (A[i].f<10)) then
      begin
          A[i].x:= A[i].x + round(A[i].a);
          prov(A,i);
      end;
    end;
end;

//----------------------------------------

procedure timerforbrown;
var i:integer;
begin
    for i:=1 to nmax do
    begin
      if (A[i].f=14) then
      begin
          A[i].y:= A[i].y + vfall;
      end;
    end;
end;



//----------------------------------------

procedure snariad;   //:integer;
var i:integer;
begin
  if w then
  begin
    B[m].x:=x+10;
    B[m].y:=y-25;
    w:=false;
  end;
    for i:=1 to m do B[i].y:=B[i].y - v1;
    if ((B[1].y<-100) or (B[1].y>400)) then
    begin
       for i:=2 to m do B[i-1]:=B[i];
       m:=m-1;
    end;

 end;

 //-----------------------------------------------------------------------------------------------------------------

 procedure drawing;
 var k:integer;
 begin
     k:=1;
    // Form1.Canvas.Draw(0, 0, fon);
     Form1.Canvas.Draw(0, 500-63, fon1);
     for i:=1 to nmax do
     begin
        if ((i<16) and (i div 2>=k)) then
        begin
            Form1.Canvas.Draw(0, 500-63*((i div 2)+1), fon1);
            k:=k+1;
        end;

        if (A[i].exist=true) then
        begin
           if ((A[i].a = 0) and ((A[i].f=0) or (A[i].f=1) or (A[i].f=2) or (A[i].f=3) or (A[i].f=4) or (A[i].f=5))) then
           form1.Canvas.Draw(A[i].x, A[i].y, planka)
        else
           if ((A[i].f=0) or (A[i].f=1) or (A[i].f=2) or (A[i].f=3) or (A[i].f=4) or (A[i].f=5)) then
             form1.Canvas.Draw(A[i].x, A[i].y, plank2)
        else
         case A[i].f of
          10: form1.Canvas.Draw(A[i].x, A[i].y, plankw);
          11: form1.Canvas.Draw(A[i].x, A[i].y, planky);
          12: form1.Canvas.Draw(A[i].x, A[i].y, plankr);
          13: form1.Canvas.Draw(A[i].x, A[i].y, plankb);
          14: form1.Canvas.Draw(A[i].x, A[i].y, plankd);           // cracked here needed!!
               end;

   //      if (uscorenie=0) then
         case A[i].f of
         1: form1.Canvas.Draw(A[i].x+10, A[i].y-5, prug1);
         2: form1.Canvas.Draw(A[i].x+10, A[i].y-18, prug2);
         3: if (uscorenie<>1) then form1.Canvas.Draw(A[i].x+6, A[i].y-20, hat);
         4: if (uscorenie<>2) then form1.Canvas.Draw(A[i].x+7, A[i].y-30, rocket);
         5: form1.Canvas.Draw(A[i].x+7, A[i].y-18, spring);
               end;
    end;
    if (A[nmax+1].exist) then
    case A[nmax+1].f of
      6: begin
            if (A[nmax+1].a>0) then form1.Canvas.Draw(A[nmax+1].x+10, A[nmax+1].y-90+(u-zn0), hat) else
                                    form1.Canvas.Draw(A[nmax+1].x-5, A[nmax+1].y-90+(u-zn0), hat);
         end;
      7: begin
            if (A[nmax+1].a>0) then form1.Canvas.Draw(A[nmax+1].x+15, A[nmax+1].y-70+(u-zn0), rock) else
                                   form1.Canvas.Draw(A[nmax+1].x-30, A[nmax+1].y-70+(u-zn0), rock);
         end;
      8: begin
            if (A[nmax+1].a>0) then form1.Canvas.Draw(A[nmax+1].x+15, A[nmax+1].y-10+(u-zn0), spring) else
                                   form1.Canvas.Draw(A[nmax+1].x+15, A[nmax+1].y-10+(u-zn0), spring);
         end;
     end;
  end;
 { if (z) then begin
    Form1.Canvas.Draw(x, y-40, doodle3);
    y:=y-10;
  end
  else
  begin
    if (uscorenie=0) then                                               //??????????
    begin                //uscorenie then
      if (h) then
        Form1.Canvas.Draw(x, y-30, doodle2)
      else
        Form1.Canvas.Draw(x, y-30, doodle1);
    end else
  //  if (g=0) then
    begin
     if (h) then
        Form1.Canvas.Draw(x, y-30, doodle5)
      else
        Form1.Canvas.Draw(x, y-30, doodle4);
    end;
  end;

  for i:=1 to m do
  begin
    Form1.Canvas.Draw(B[i].x,B[i].y, snaryad);
  end;}
end;

 procedure pause(b:boolean);
 begin
      if not(b) then
      begin
    //      Form1.Edit1.Text:=inttostr(u);
       //   Form1.Edit1.Visible:=true;
          form1.Canvas.Draw(0, 0, pausebut);
          form1.Label1.Caption:='Score: '+inttostr(u);
          Form1.Label1.Visible:=true;
      end else
      begin
           Form1.Label1.Visible:=false;
    //      Form1.Edit1.Visible:=false;
      end;

 end;

procedure clear;
var i,j:integer;
begin
    with Form1.Canvas do
    begin
        pen.Color:=clwhite;
        brush.color:=clwhite;
        Rectangle(0,0,Form1.width,Form1.height);
    end;
end;

{******************************** END OF LIST OF USEFUL FUNCTIONS **********************************************}



// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -



{********************************************************************************************************************
*************************************** MAIN PROCEDURES & FUNCTIONS ************************************************
********************************************************************************************************************}

function prigok : integer;
begin
     y := round(y0 - v*t + g*t*t/2);
     t := t + 1;

  {   if (y > 700) then
     begin
        t := 2;
        y0 := 500;
        x0 := 150;                                                                                                            // ??????????
        u:=0;
     end;     }

     if (y>700) then
     begin

          Form2.visible:=true;
      //    Form1.Visible:=false;                       // ??
      //    Form2.Edit1.Text:=inttostr(u);
          Form2.Label8.Caption:=inttostr(u);
          Form2.Label8.Width:=Form2.Label1.Width+5;
          Form2.Image1.Canvas.Draw(0, 0, gift);
        //  form2.Canvas.Draw(50, 400, gift);

          padenie:=true;
          form1.Timer1.Enabled:=false;
          PlaySound('sound\falldown.wav', 0, SND_ASYNC);
     end;

     prigok := y;
end;

//-----------------------------------------------------------------------------------------------------------------

function peremesh : integer;
var
  x2,y2:integer;
begin
  GetCursorPos(f);
  x2 := f.x - form1.Left-25;
  y2 := f.y - form1.top;

  if (x0 < x2) then
  begin
    h := true;
    if (x0 + (x2 - x0) div 20 + 1 > 300-37) then
      x0 := 300-37
    else x0 := x0 + (x2 - x0) div 20 + 1;
  end;


  if (x0 > x2) then
  begin
    if (x0 + (x2 - x0) div 20 - 1 < 0) then
      x0 := 0
    else
      x0 := x0 + (x2 - x0) div 20 - 1;
    h := false;
  end;
  peremesh := x0;
end;

//-----------------------------------------------------------------------------------------------------------------

procedure proverka;
var
  i,j:integer;
begin
    for i:=1 to nmax do
      if (((A[i].x - 30 < x) and (x < A[i].x + 30) and (A[i].y - y > 0) and (A[i].y - y < g*t-v) and (v - g*t < 0)) AND (A[i].exist=true)) then
      begin
         if not((A[i].f=13) or (A[i].f=14)) then
         begin
              t := 2;
              y0 := A[i].y;
         end;
         if ((A[i].f=1) and (A[i].x - 15 < x) and (x < A[i].x + 15)) then
         begin
             v:=0.9*vmax;
             A[i].f:=2;
             PlaySound('sound\feder.wav', 0, SND_ASYNC);      // feder = spring
         end;
   //      else
         if ((A[i].f=3) and (A[i].x - 20 < x) and (x < A[i].x + 20)) then
         begin
            PlaySound('sound\propeller.wav', 0, SND_ASYNC);
            uscorenie:=1;
            g:=0;
            v:=0.53*vmax;
            zn:=u;
           // A[i].f:=0;                                                     //        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
         end;
       // else
         if ((A[i].f=4) and (A[i].x - 20 < x) and (x < A[i].x + 20)) then
          begin
             PlaySound('sound\jetpack.wav', 0, SND_ASYNC);
             uscorenie:=2;
             g:=0;
             v:=1.6*vmax;
             zn:=u;
         //    A[i].f:=0;
           end;
         if ((A[i].f=5) and (A[i].x - 20 < x) and (x < A[i].x + 20)) then
         begin
            PlaySound('sound\feder.wav', 0, SND_ASYNC);
            uscorenie:=3;
            per2:=1;
            zn:=u;
            count1:=0;
            A[i].f:=0;                                                         //        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
         end;

         if (not((A[i].f=13) or (A[i].f=14) or ((A[i].f<=5) and (A[i].f>0)))) then
         begin
            if not(uscorenie=3) then
            begin
               v:=vmin;
               PlaySound('sound\jump.wav', 0, SND_ASYNC);
            end else
            begin
               v:=0.85*vmax;
               PlaySound('sound\feder.wav', 0, SND_ASYNC);
               per2:=1;
               if (count1<=7) then count1:=count1+1 else
               begin
                     uscorenie:=0;
                     zn0:=u;
                     A[nmax+1].exist:=true;
                     A[nmax+1].f:=8;
                     A[nmax+1].x:=x;
                     if h then A[nmax+1].a:=-1 else A[nmax+1].a:=1;
                     A[nmax+1].y:=y;
                     count1:=0;
               end;
            end;
         end;

         if (A[i].f=10) then
         begin
             A[i].exist:=false;         // for clouds
         end;

         if (A[i].f=13) then
         begin
             A[i].f:=14;
             PlaySound('sound\crack.wav', 0, SND_ASYNC);
         end;

      end;

      if (y<200) then
      begin
         for i:=1 to nmax do A[i].y:= A[i].y + (200-y) div 3;
         y0:=y0 + (200-y) div 3;
         u:=u + (200-y) div 3;
      end;

      if (A[nmax+1].exist) then                                           // for falling rockets
         if (A[nmax+1].y>500) then A[nmax+1].exist:=false else
         begin
             A[nmax+1].x:=A[nmax+1].x+round(A[nmax+1].a);
             A[nmax+1].y:=A[nmax+1].y+round(g*(t-2));
         end;

      if A[1].y>500 then
      begin
         for i:=1 to (nmax-1) do
         begin
            A[i].y:=A[i+1].y;
            A[i].x:=A[i+1].x;
            A[i].a:=A[i+1].a;
            A[i].exist:=A[i+1].exist;
            A[i].f:=A[i+1].f;
         end;
      A[nmax].y:=A[nmax-1].y-29;
      A[nmax].x:=25*round(random(11));

      vopros:=random(20);
      if (vopros=0) then A[nmax].f:=1
                        else A[nmax].f:=0;            { random for springs }

      vopros:=random(5);
      if (vopros=1) then A[nmax].f:=10;
   {   if (vopros=2) then
      begin
           A[nmax].f:=11;
           A[nmax].time:=8;                                                                 //timeconst;
      end;           }
       vopros:=random(6);

       if (vopros=1) then A[nmax].f:=13;

      vopr:=true;
      for i:=1 to nmax do
      if  A[i].f=3 then vopr:=false;

      vopros:=random(20);
      if ((vopros=1) and (g<>0) and vopr) then A[nmax].f:=3;

      vopr:=true;
      for i:=1 to nmax do
      if  (A[i].f=4) then vopr:=false;

      vopros:=random(100);
      if ((vopros=1) and (g<>0) and vopr) then A[nmax].f:=4;

      vopros:= round(random((u div 1000) + 9)+1);
      if (vopros<=6) then A[nmax].a:=0
      else
      begin
          vopros:=round(random(2));
          if (vopros = 0) then A[nmax].a:=vn + (round(sqrt(u div 7000)))
          else A[nmax].a:=(-1)*(vn+(round(sqrt(u div 7000))));
      end;

      vopros:=random(200);
      if (vopros=1) then A[nmax].f:=5;

      nolostplat;

    end;
end;

//---------------------------------------------------------------------------------------

procedure TForm1.povtor(Sender: TObject);
var
  i,k : integer;
  stroka : string;
begin
 //  stroka:= inttostr(m);
 //  form1.text:=stroka;
 { if (uscorenie=1) then
   if (per=1) or(per=2) then
   begin
    doodle4.LoadFromFile('pic\dood21.bmp');
    doodle5.LoadFromFile('pic\dood11.bmp');
   end
   else
   begin
    doodle4.LoadFromFile('pic\dood22.bmp');
    doodle5.LoadFromFile('pic\dood12.bmp');
   end;
   if (uscorenie=2) then
   begin
    if (per1=1) or (per1=2) then
    begin
     doodle4.LoadFromFile('pic\dood31.bmp');
     doodle5.LoadFromFile('pic\dood41.bmp');
    end;
    if (per1=3) or (per1=4) then
    begin
     doodle4.LoadFromFile('pic\dood32.bmp');
     doodle5.LoadFromFile('pic\dood42.bmp');
    end;
    if (per1=5) or (per1=6) then
    begin
     doodle4.LoadFromFile('pic\dood33.bmp');
     doodle5.LoadFromFile('pic\dood43.bmp');
    end;
   end;
   if (uscorenie=3) then
   if (per2=1) then
   begin
    doodle4.LoadFromFile('pic\dood61.bmp');
    doodle5.LoadFromFile('pic\dood51.bmp');
   end
   else
   begin
    doodle4.LoadFromFile('pic\dood62.bmp');
    doodle5.LoadFromFile('pic\dood52.bmp');
   end;
  if (uscorenie=1) then if per=4 then per:=1
           else per:=per+1;
  if (uscorenie=2) then if per1=6 then per1:=1
           else per1:=per1+1;
  if (uscorenie=3) then if ((per2=1) and (t>10)) then per2:=2;
  doodle4.Transparent:=true;
  doodle5.Transparent:=true;
  if (((u-zn)>1500) and (uscorenie=1)) or ((uscorenie=2) and ((u-zn)>4500)) then
  begin
    g:=0.2;
    y0:=y;
    t:=2;
    v:=vmin;
    case uscorenie of
    1:   begin
            zn0:=u;
            A[nmax+1].exist:=true;
            A[nmax+1].f:=6;
            A[nmax+1].x:=x;
            if h then A[nmax+1].a:=-2 else A[nmax+1].a:=2;
            A[nmax+1].y:=y;
         end;
    2:   begin
            zn0:=u;
            A[nmax+1].exist:=true;
            A[nmax+1].f:=7;
            A[nmax+1].x:=x;
            if h then A[nmax+1].a:=-2 else A[nmax+1].a:=2;
            A[nmax+1].y:=y;
         end;
    end;
    uscorenie:=0;
    count1:=0;
  end;   }
  
 // form1.Width:=284;
 // form1.Height:=489;


  x := peremesh;
  y := prigok;

  timerforred;

  timerforblue;

  timerforbrown;

  proverka;
  if (m<>0) then snariad;

  //for k:=1 to 5 do                            { PROBLEM HERE !!! }
  //Form1.Canvas.Draw(0, 0, fon);
  drawing;

  //clear;

 {***************}

   if (uscorenie=1) then
   if (per=1) or(per=2) then
   begin
    doodle4.LoadFromFile('pic\dood21.bmp');
    doodle5.LoadFromFile('pic\dood11.bmp');
   end
   else
   begin
    doodle4.LoadFromFile('pic\dood22.bmp');
    doodle5.LoadFromFile('pic\dood12.bmp');
   end;
   if (uscorenie=2) then
   begin
    if (per1=1) or (per1=2) then
    begin
     doodle4.LoadFromFile('pic\dood31.bmp');
     doodle5.LoadFromFile('pic\dood41.bmp');
    end;
    if (per1=3) or (per1=4) then
    begin
     doodle4.LoadFromFile('pic\dood32.bmp');
     doodle5.LoadFromFile('pic\dood42.bmp');
    end;
    if (per1=5) or (per1=6) then
    begin
     doodle4.LoadFromFile('pic\dood33.bmp');
     doodle5.LoadFromFile('pic\dood43.bmp');
    end;
   end;
   if (uscorenie=3) then
   if (per2=1) then
   begin
    doodle4.LoadFromFile('pic\dood61.bmp');
    doodle5.LoadFromFile('pic\dood51.bmp');
   end
   else
   begin
    doodle4.LoadFromFile('pic\dood62.bmp');
    doodle5.LoadFromFile('pic\dood52.bmp');
   end;
  if (uscorenie=1) then if per=4 then per:=1
           else per:=per+1;
  if (uscorenie=2) then if per1=6 then per1:=1
           else per1:=per1+1;
  if (uscorenie=3) then if ((per2=1) and (t>10)) then per2:=2;
  doodle4.Transparent:=true;
  doodle5.Transparent:=true;
  if (((u-zn)>1500) and (uscorenie=1)) or ((uscorenie=2) and ((u-zn)>4500)) then
  begin
    g:=0.2;
    y0:=y;
    t:=0;
    v:=vmin;
    case uscorenie of
    1:   begin
            zn0:=u;
            A[nmax+1].exist:=true;
            A[nmax+1].f:=6;
            A[nmax+1].x:=x;
            if h then A[nmax+1].a:=-2 else A[nmax+1].a:=2;
            A[nmax+1].y:=y;
         end;
    2:   begin
            zn0:=u;
            A[nmax+1].exist:=true;
            A[nmax+1].f:=7;
            A[nmax+1].x:=x;
            if h then A[nmax+1].a:=-2 else A[nmax+1].a:=2;
            A[nmax+1].y:=y;
         end;
    end;
    uscorenie:=0;
    count1:=0;
  end;



  if (z) then begin
    Form1.Canvas.Draw(x, y-40, doodle3);
    y:=y-10;
  end
  else
  begin
    if (uscorenie=0) then                                               //??????????
    begin                //uscorenie then
      if (h) then
        Form1.Canvas.Draw(x, y-30, doodle2)
      else
        Form1.Canvas.Draw(x, y-30, doodle1);
    end else
  //  if (g=0) then
    begin
     if (h) then
        Form1.Canvas.Draw(x, y-30, doodle5)
      else
        Form1.Canvas.Draw(x, y-30, doodle4);
    end;
  end;

  for i:=1 to m do
  begin
    Form1.Canvas.Draw(B[i].x,B[i].y, snaryad);
  end;

  str(u,s);
  //form1.Edit1.Text:=s;
  inc(q);
  if (q>15) then z:=false;
end;

//-----------------------------------------------------------------------------------------------------------------

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if ((g<>0) and (button=mbleft) and (Form1.Timer1.Enabled)) then //uscorenie then
  begin
    z:=true;
  //  x10:=x;
  //  y10:=y;
    q:=0;
    m:=m+1;
    w:=true;
    PlaySound('sound\strelba.wav', 0, SND_ASYNC);
  end;
  if (button=mbright) then
  begin
      if (Form1.Timer1.Enabled) then Form1.Timer1.Enabled:=false else
                                     Form1.Timer1.Enabled:=true;
      pause(Form1.Timer1.Enabled);
  end;
end;

//*****************************************************************************************

//*****************************************************************************************

procedure resetgame;
begin
  form1.TransparentColor:=true;
  form1.TransparentColorValue:=1;
  form1.doublebuffered := true;
  fon := TBitMap.Create;
  fon1 := TBitMap.Create;
  doodle1 := TBitMap.Create;
  doodle2 := TBitMap.Create;
  doodle3 := TBitMap.Create;
  doodle4 := TBitMap.Create;
  doodle5 := TBitMap.Create;
  planka := TBitMap.Create;
  snaryad := TBitMap.Create;
  plank2 := TBitMap.Create;
  planky := TBitMap.Create;
  plankr := TBitMap.Create;
  prug1 := TBitMap.Create;
  prug2 := TBitMap.Create;
  plankw := TBitMap.Create;
  plankb := TBitMap.Create;
  hat := TBitMap.Create;
  rocket := TBitMap.Create;
  spring := TBitMap.Create;
  plankd := TBitMap.Create;
  pausebut := TBitMap.Create;
  rock := TBitMap.Create;
  gift := TBitMap.Create;
  fallhat := TBitMap.Create;

  gift.LoadFromFile('pic\present-icon.bmp');
  doodle1.LoadFromFile('pic\dood2.bmp');
  //ShellExecute(0, 'open', 'pic\coffee.exe', '', '', SW_SHOWNORMAL);
  doodle2.LoadFromFile('pic\dood1.bmp');
  doodle3.LoadFromFile('pic\strelba.bmp');
  fon.LoadFromFile('pic\test2.bmp');
  fon1.LoadFromFile('pic\wall\1.bmp');
  planka.LoadFromFile('pic\green.bmp');
  snaryad.LoadFromFile('pic\snaryad.bmp');
  plank2.LoadFromFile('pic\blue.bmp');
  planky.LoadFromFile('pic\yellow.bmp');
  plankr.LoadFromFile('pic\red.bmp');
  prug1.LoadFromFile('pic\prujina.bmp');
  prug2.LoadFromFile('pic\prujinar.bmp');
  hat.LoadFromFile('pic\hat.bmp');
  plankw.LoadFromFile('pic\white.bmp');
  plankb.LoadFromFile('pic\brown.bmp');
  rocket.LoadFromFile('pic\rocket.bmp');
  spring.LoadFromFile('pic\feder.bmp');
  plankd.LoadFromFile('pic\brownd.bmp');
  pausebut.LoadFromFile('pic\pause.bmp');
  rock.LoadFromFile('pic\rock.bmp');
  //fallhat.LoadFromFile('pic\fhat.bmp');
  doodle1.Transparent:=true;
  doodle2.Transparent:=true;
  doodle3.Transparent:=true;
  planka.Transparent:=true;
  plank2.Transparent:=true;
  planky.Transparent:=true;
  plankr.Transparent:=true;
  plankw.Transparent:=true;
  plankb.Transparent:=true;
  plankd.Transparent:=true;
  //plankb1.Transparent:=true;
  prug1.Transparent:=true;
  prug2.Transparent:=true;
  rocket.Transparent:=true;
  hat.Transparent:=true;
  doodle4.Transparent:=true;
  doodle5.Transparent:=true;
  spring.Transparent:=true;
  rock.Transparent:=true;
  //doodle6.Transparent:=true;
  //doodle7.Transparent:=true;
  snaryad.Transparent:=true;
 // gift.Transparent:=true;
  //prug3.Transparent:=true;     

  randomize;
  vopros:=0;
  x0 := 150;
  y0 := 500;
  u:=0;

  A[1].x:=25*round(random(11));
  A[1].y:=450;
  A[1].exist:=true;
  A[nmax+1].exist:=false;

  uscorenie:=0;

  sch:=0;

  vn := 1;

  for i:=2 to nmax do
  begin
    A[i].y:=A[i-1].y-29;                                             //                   !!!!!!!!!!!!!!!!!!!!!   (50 -> 25)
    A[i].exist:=true;

    vopros:= round(random(9)+1);
    if (vopros<=6) then A[i].a:=0
    else
    A[i].a:=vn;

    A[i].x:=25*round(random(11));
  end;

  t := 2;
  vmin := 8;
  vmax := 15;
  v:=vmin;
  padenie:=false;

  g := 0.2;
  z:=false;
  v1:=10;
  m:=0;
  form1.Timer1.Enabled:=true;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i : integer;
begin
    resetgame;
end;

//-----------------------------------------------------------------------------------------------------------------


procedure TForm1.Button1Click(Sender: TObject);
begin
    resetgame;
end;

end.

