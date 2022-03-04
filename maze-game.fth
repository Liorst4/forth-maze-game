\ Controls
char w constant direction.up
char s constant direction.down
char a constant direction.left
char d constant direction.right

begin-structure location
  1 cells +field location.x
  1 cells +field location.y
end-structure

: location= { location-pointer-a location-pointer-b }
	    location-pointer-a location.x @
	    location-pointer-b location.x @ =

	    location-pointer-a location.y @
	    location-pointer-b location.y @ =

	    and
;
char @ constant player.glyph
create player location allot

0 player location.x !
0 player location.y !

char # constant maze-exit.glyph
create maze-exit location allot

10 maze-exit location.x !
10 maze-exit location.y !

: emit-at-location { glyph location-pointer }
		  location-pointer location.x @
		  location-pointer location.y @
		  at-xy
		  glyph emit
;

: render ( -- )
  player.glyph player emit-at-location
  maze-exit.glyph maze-exit emit-at-location
;

: handle-input ( -- )
  key case
    direction.up of
      -1 player location.y +!
    endof

    direction.down of
      1 player location.y +!
    endof

    direction.left of
      -1 player location.x +!
    endof

    direction.right of
      1 player location.x +!
    endof
  endcase
;

: game ( -- )
  begin
    page
    render
    handle-input
    player maze-exit location= until
;

game
bye
