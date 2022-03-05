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

: location! { x y location-pointer }
	       x location-pointer location.x !
	       y location-pointer location.y !
;

char @ constant player.glyph
create player location allot

char # constant maze-exit.glyph
create maze-exit location allot

\ char _ constant maze-empty-space

12 constant maze-row-width
variable maze-builder-row

: location-from-glyph ( c -- addr )
  case
    player.glyph of
      player
    endof

    maze-exit.glyph of
      maze-exit
    endof

    \ default
    >r 0 r>
  endcase
;

: parse-maze-row { text-buffer text-buffer-byte-count }
		 \ TODO: Verify buffer size
		 maze-row-width 0 do
		   text-buffer i + c@ location-from-glyph dup
		   0 = if
		     drop
		   else
		     i maze-builder-row @ rot location!
		   then
		 loop
;

: maze-row:
  -1 parse parse-maze-row
  1 maze-builder-row +!
;

maze-row: ____________
maze-row: _@__________
maze-row: ____________
maze-row: ____________
maze-row: ____________
maze-row: ____________
maze-row: ____________
maze-row: ____________
maze-row: __________#_
maze-row: ____________

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
