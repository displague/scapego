# Scape - A simple 2d overhead landscape generator

Here is the nostalgic comment header from the original `scape.pas`.  The revised license 
>
> Programmed by Marques Johansson - PWAC 96 - pwac@flinet.com
> This program may be distributed so long as my name is kept here...
>  If you add your own stuff- note it... I take no responsibility
>  for any damage :<   bla blah blarr....
>
>  Ok- i made this quick source use a paramline so that you can try
>  it w/ different pal files... if you don't have a good- FAST palette
>  writing program- try 256 paint- shareware written in pascal..
>  This prog. works very nice w/ red/blacks and sky colors- i also include
>  a landform palette- this would be good for a c&c type game for at
>  least one reason: instead of having grass and dirt icons to place
>  on the screen you use a landscape bg, it is quicker and will always
>  be the same... like point a  .       . and B
>  If a is altitude 10 and B is 30, than the middle will increment based on 
>  the space available.
>  if you zoom on this you will notice- especially if the difference in
>  altitude is great- more colors on more zooms- i should probably add
>  that feature to this demo- but then again- it is free, do it yourself.
>
>  If you would like me to try changing or adding something- go ahead
>  tell me- i'll probably try it...
>  there is one known bug- i haven't looked for it really hard though:
>  
>  i think the corners of the screen bleed in artificial counts for
>  the averaging- when a random page 0-63 is made it should wind up
>  dithering somewhere about 32- well this seems to go straight to zero,
>  multiplication maybe? I don't care- i looks cool as is, if you
>  find the bug please let me know...}

## Usage

    SCAPE [path][filename]

## Palette Files

Palette files are expected to contain 256 blocks of 3 bytes of color data (Red (0-255), Green (0-255), and Blue (0-225)).

## Copyright and License

Code and documentation copyright 1996-2014 Marques Johansson.  
Code released under [the MIT license](https://github.com/twbs/bootstrap/blob/master/LICENSE).
Documentation released into the public domain.
