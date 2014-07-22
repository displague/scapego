{Program Scape}
{$linklib gcc}
{$linklib SDLmain}
Uses dos,
     sdl;
{$asmmode intel}
{Procedure Scape;}

Var x:   integer;
    y:   byte;
    h:   byte;
    scr:   PSDL_Surface;
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
    {setvideo($13);}
    if SDL_Init( SDL_INIT_VIDEO ) < 0 then HALT;
    scr:=SDL_SetVideoMode(320,200,24, SDL_SWSURFACE);
    {sdlWindow1 := SDL_CreateWindow( 'Window1', 50, 50, 500, 500, SDL_WINDOW_SHOWN );
        if sdlWindow1 = nil then HALT;}

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
    {SDL_DestroyWindow ( sdlWindow1 );}
    SDL_Quit;
    {setvideo($3);}  {better remove this one to use as a sub}
End.
{Begin
 Scape;
End.}
 {put the rest here- a whole game...or palette rotation...or both}
