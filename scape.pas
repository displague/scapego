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


Uses dos;
{$asmmode intel}
{Procedure Scape;}

Var x:   integer;
    y:   byte;
    h:   byte;
    scr:   array [0..63999] Of byte absolute $a000;
    i,j,scans:   integer;
    a:   char;
    xvar,yvar:   integer;
    ytemp,jtemp:   word;
    palfile:   string[13];

Const vseg =   $a000;
    ysize =   199;{detail controls}
    xsize =   319;
    xmax =   320;
    xn =   30;
    yn =   30;{blocks across and down}
    scanreq =   10;{number of dithers}
Procedure GiveHelp;
Begin
    Writeln('Generates random landscape type screens.');
    writeln;
    Writeln('SCAPE [drive:][path][filename]');
    writeln;
    writeln(
      '      [drive:][path][filename]   Specifies drive/directory/file to load.'
    );
    writeln('                                 Filename must include Extension.')
    ;
    writeln('');
    writeln('Written by Marques Johansson - PWAC 96 - FreeWare');
    writeln(' Mail to pwac@flinet.com or Visit http://www.flinet.com/~pwac');
    halt(1);
End;

Procedure setvideo(m : integer);
assembler;
asm
mov ax,m;
int 10h
End;
Procedure setpal(c,r,g,b : byte);
assembler;
asm
mov dx,03c8h;
mov al,c;
out dx,al;
inc dx;
mov al,r
out dx,al;
mov al,g;
out dx,al;
mov al,b;
out dx,al
End;

Procedure GrayPal;

Type paltype =   Record
    r,g,b:   byte
End;

Var i:   byte;
Begin;
    For i:=0 To 255 Do
        Begin
            setpal(i,i,i,i);
        End;
End;

Procedure LoadPal(fn:String);

Type paltype =   Record
    r,g,b:   byte
End;

Var  f:   file Of paltype;
    i:   byte;
    curpal:   paltype;
Begin;
  {$I-}
    assign(f,fn);
    reset(f);{$I+}
    close(f);
    If IORESULT<>0 Then GiveHelp;
    assign(f,fn);
    reset(f);
    For i:=0 To 255 Do
        Begin
            read(f,curpal);
            setpal(i,curpal.r,curpal.g,curpal.b);
        End;
    close(f);
End;

Procedure retrace;
assembler;
asm
mov dx,03dah;
@l1:   in al,dx;
test al,8;
jnz @l1;
@l2:   in al,dx;
test al,8;
jz @l2
End;

Function avg(x,y:integer):   byte;

Var tmp:   byte;
Begin
    If ((x>0) And (x<xsize)) And ((y>0) And (y<ysize)) Then
        tmp := (scr[x-1+(y+1)*xmax]+scr[x+(y+1)*xmax]+scr[x+1+(y+1)*xmax]+
               scr[x-1+y*xmax]+                    scr[x+1+y*xmax]+
               scr[x-1+(y-1)*xmax]+ scr[x+(y-1)*xmax]+scr[x+1+(y-1)*xmax])Div 8;

    If (x=0) And (y>0) And (y<ysize) Then
        tmp := (scr[x+(y-1)*xmax]+scr[x+1+(y-1)*xmax]+
               scr[x+1+y*xmax]+
               scr[x+(y+1)*xmax]+scr[x+1+(y+1)*xmax]) Div 5;

    If (x=xsize) And ((y>0) And (y<ysize)) Then
        tmp := (scr[x-1+(y-1)*xmax]+scr[x+(y-1)*xmax]+
               scr[x-1+y*xmax]+
               scr[x-1+(y+1)*xmax]+scr[x+(y+1)*xmax]) Div 5;

    If (y=0) And ((x>0) And (x<xsize)) Then
        tmp := (scr[x-1+y*xmax]                      +scr[x+1+y*xmax]
               +scr[x-1+(y+1)*xmax]+scr[x+(y+1)*xmax]+scr[x+1+(y+1)*xmax]) Div 5
    ;

    If (y=ysize) And ((x>0) And (x<xsize)) Then
        tmp := (scr[x-1+(y-1)*xmax]+scr[x+(y-1)*xmax]+scr[x+1+(y-1)*xmax]+
               scr[x-1+y*xmax] +                       scr[x+1+y*xmax]) Div 5;
    avg := tmp;
End;

Begin;
{if paramcount=0 then GiveHelp;}
    h := 0;
    Palfile := paramstr(1);
    setvideo($13);
    GrayPal();
  {Loadpal(PalFile);}
    For i:=0 To 255 Do
        scr[i+xsize*170] := i;
    xvar := xsize Div (xn-1);
    yvar := ysize Div (yn-1);
    randomize;{$Q-}
    For j:=0 To yn-1 Do
        For i:=0 To xn-1 Do
            scr[(j*yvar)*xmax+i*xvar] := random(254);{$Q+}
                           {6*320*20+0*33}

{If you have a reason for using colors on something other than BG-
 lower this!! try random(64) plenty left...
 For the game.pal included use 64...the other colors are for the rest
   you can make it up to 255 obviously....}
{$Q-}
    For y:= 0 To yn-1 Do
        Begin
            ytemp := y*xmax*yvar;
            For j:= 0 To xn-2 Do
                Begin
                    jtemp := j*xvar;
                    For i:=1 To xvar-1 Do
                        scr[i+jtemp+ytemp] := 
                                              scr[ytemp+jtemp]+(((scr[(j+1)*xvar
                                              +ytemp]-scr[jtemp+ytemp])Div xvar)
                                              *i);
                End;
        End;
    For x:= 0 To xsize Do
        Begin
            For j:= 0 To yn-2 Do
                Begin
                    jtemp := yvar*xmax;
                    For i:=1 To yvar-1 Do
                        scr[(j*yvar+i)*xmax+x] := 
                                                  scr[x+j*jtemp]+(((scr[(j+1)*
                                                  jtemp+x]-scr[j*jtemp+x]) Div
                                                  yvar)*i);
                End;
        End;{$Q-}
    scans := 0;
    Repeat
        Begin
            For y:=0 To ysize Do
                For x:=0 To xsize Do
                    scr[y*xmax+x] := avg(x,y);
            inc(scans);
        End;
    Until scans=scanreq;
    setvideo($3);  {better remove this one to use as a sub}
End.
{Begin
 Scape;
End.}
 {put the rest here- a whole game...or palette rotation...or both}
