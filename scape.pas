{Programmed by Marques Johansson - PWAC 96 - pwac@flinet.com}
{ This program may be distributed so long as my name is kept here...
  If you add your own stuff- note it... I take no responsibility
  for any damage :<   bla blah blarr....

  Ok- i made this quick source use a paramline so that you can try
  it w/ different pal files... if you don't have a good- FAST palette
  writing program- try 256 paint- shareware written in pascal..
  This prog. works very nice w/ red/blacks and sky colors- i also include
  a landform palette- this would be good for a c&c type game for at
  least one reason: instead of having grass and dirt icons to place
  on the screen you use a landscape bg, it is quicker and will always
  be the same... like point a  .       . and B
   If a is altitude 10
   and B is 30, than the middle will increment based on the space available.
   if you zoom on this you will notice- especially if the difference in
   altitude is great- more colors on more zooms- i should probably add
   that feature to this demo- but then again- it is free, do it yourself.

   If you would like me to try changing or adding something- go ahead
   tell me- i'll probably try it...
   there is one known bug- i haven't looked for it really hard though:
    i think the corners of the screen bleed in artificial counts for
    the averaging- when a random page 0-63 is made it should wind up
    dithering somewhere about 32- well this seems to go straight to zero,
    multiplication maybe? I don't care- i looks cool as is, if you
    find the bug please let me know...}


uses dos;
{Procedure Scape;}
var x:integer;
    y:byte;
    h:byte;
    scr:array [0..63999] of byte absolute $a000:0000;
    i,j,scans:integer;
    a:char;
    xvar,yvar:integer;
    ytemp,jtemp:word;
    palfile:string[13];
const vseg = $a000;
      ysize=199;{detail controls}
      xsize=319;
      xmax=320;
      xn=30;yn=30;{blocks across and down}
      scanreq=10;{number of dithers}
procedure GiveHelp;
 begin
     Writeln('Generates random landscape type screens.');writeln;
     Writeln('SCAPE [drive:][path][filename]');writeln;
     writeln('      [drive:][path][filename]   Specifies drive/directory/file to load.');
     writeln('                                 Filename must include Extension.');
     writeln('');
     writeln('Written by Marques Johansson - PWAC 96 - FreeWare');
     writeln(' Mail to pwac@flinet.com or Visit http://www.flinet.com/~pwac');
     halt(1);
 end;

procedure setvideo(m : integer); assembler; asm
  mov ax,m; int 10h end;
procedure setpal(c,r,g,b : byte); assembler; asm
  mov dx,03c8h; mov al,c; out dx,al; inc dx; mov al,r
  out dx,al; mov al,g; out dx,al; mov al,b; out dx,al end;

Procedure LoadPal(fn:string);
 type paltype=record r,g,b:byte end;
 var  f:file of paltype;i:byte;
      curpal:paltype;
 begin;
  {$I-}assign(f,fn);reset(f);{$I+}close(f);
  If IORESULT<>0 then GiveHelp;
  assign(f,fn);reset(f);
  for i:=0 to 255 do begin read(f,curpal);
      setpal(i,curpal.r,curpal.g,curpal.b);end;
  close(f);
 end;

Procedure retrace; assembler; asm
  mov dx,03dah; @l1: in al,dx; test al,8; jnz @l1;@l2: in al,dx; test al,8; jz @l2 end;

function avg(x,y:integer):byte;
 var tmp:byte;
 begin
  if ((x>0) and (x<xsize)) and ((y>0) and (y<ysize)) then
   tmp:=(scr[x-1+(y+1)*xmax]+scr[x+(y+1)*xmax]+scr[x+1+(y+1)*xmax]+
        scr[x-1+y*xmax]+                    scr[x+1+y*xmax]+
        scr[x-1+(y-1)*xmax]+ scr[x+(y-1)*xmax]+scr[x+1+(y-1)*xmax])div 8;

  if (x=0) and (y>0) and (y<ysize) then
   tmp:=(scr[x+(y-1)*xmax]+scr[x+1+(y-1)*xmax]+
                          scr[x+1+y*xmax]+
        scr[x+(y+1)*xmax]+scr[x+1+(y+1)*xmax]) div 5;

  if (x=xsize) and ((y>0) and (y<ysize)) then
   tmp:= (scr[x-1+(y-1)*xmax]+scr[x+(y-1)*xmax]+
         scr[x-1+y*xmax]+
         scr[x-1+(y+1)*xmax]+scr[x+(y+1)*xmax]) div 5;

  if (y=0) and ((x>0) and (x<xsize)) then
   tmp:= (scr[x-1+y*xmax]                      +scr[x+1+y*xmax]
        +scr[x-1+(y+1)*xmax]+scr[x+(y+1)*xmax]+scr[x+1+(y+1)*xmax]) div 5;

  if (y=ysize) and ((x>0) and (x<xsize)) then
   tmp:= (scr[x-1+(y-1)*xmax]+scr[x+(y-1)*xmax]+scr[x+1+(y-1)*xmax]+
        scr[x-1+y*xmax] +                       scr[x+1+y*xmax]) div 5;
  avg:=tmp;
end;

begin;
  if paramcount=0 then GiveHelp;
  h:=0;Palfile:=paramstr(1);
  setvideo($13);
  Loadpal(PalFile);
  for i:=0 to 255 do scr[i+xsize*170]:=i;
  xvar:=xsize div (xn-1);
  yvar:=ysize div (yn-1);
  randomize;{$Q-}
  for j:=0 to yn-1 do
   for i:=0 to xn-1 do scr[(j*yvar)*xmax+i*xvar]:=random(254);{$Q+}
                           {6*320*20+0*33}
{If you have a reason for using colors on something other than BG-
 lower this!! try random(64) plenty left...
 For the game.pal included use 64...the other colors are for the rest
   you can make it up to 255 obviously....}
{$Q-}  for y:= 0 to yn-1 do begin
   ytemp:=y*xmax*yvar;
   for j:= 0 to xn-2 do begin
    jtemp:=j*xvar;
    for i:=1 to xvar-1 do
     scr[i+jtemp+ytemp]:=
     scr[ytemp+jtemp]+(((scr[(j+1)*xvar+ytemp]-scr[jtemp+ytemp])div xvar)*i);
    end;
  end;
  for x:= 0 to xsize do begin
   for j:= 0 to yn-2 do begin
    jtemp:=yvar*xmax;
    for i:=1 to yvar-1 do
     scr[(j*yvar+i)*xmax+x]:=
     scr[x+j*jtemp]+(((scr[(j+1)*jtemp+x]-scr[j*jtemp+x]) div yvar)*i);
   end;
  end;{$Q-}
  scans:=0;
  repeat begin
   for y:=0 to ysize do for x:=0 to xsize do scr[y*xmax+x]:=avg(x,y);
   inc(scans); end; until scans=scanreq;
 setvideo($3);  {better remove this one to use as a sub}
end.
{Begin
 Scape;
End.}
 {put the rest here- a whole game...or palette rotation...or both}
