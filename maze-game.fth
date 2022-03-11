\ A simple maze game written in forth
\ Copyright (C) 2022 Lior Stern

\ This program is free software: you can redistribute it and/or modify
\ it under the terms of the GNU General Public License as published by
\ the Free Software Foundation, either version 3 of the License, or
\ any later version.

\ This program is distributed in the hope that it will be useful,
\ but WITHOUT ANY WARRANTY; without even the implied warranty of
\ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
\ GNU General Public License for more details.

\ You should have received a copy of the GNU General Public License
\ along with this program.  If not, see <https://www.gnu.org/licenses/>.

\ Controls
char w constant direction.up
char s constant direction.down
char a constant direction.left
char d constant direction.right

begin-structure location
  1 cells +field location.x
  1 cells +field location.y
end-structure

: location= ( a a -- f )
  location swap location compare
  0 =
;

: location! { x y location-pointer }
	       x location-pointer location.x !
	       y location-pointer location.y !
;

: location.to-xy { location-pointer -- n n }
		 location-pointer location.x @
		 location-pointer location.y @
;

char @ constant player.glyph
create player location allot

char # constant maze-exit.glyph
create maze-exit location allot

\ char _ constant maze-empty-space
char * constant maze-wall.glyph

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

		 \ Assumes that latest word is dedicated to store the maze
		 maze-row-width allot
		 text-buffer here maze-row-width - maze-row-width cmove

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

create maze

maze-row: ************
maze-row: *@___*_____*
maze-row: *____*__*__*
maze-row: ****_*__*__*
maze-row: *____*__*__*
maze-row: *____*__*__*
maze-row: *_****__*__*
maze-row: *____*__*__*
maze-row: *_______*_#*
maze-row: ************

: maze@ { x y }
	y maze-row-width *
	x +
	maze +
	c@
;

: maze.width ( -- n )
  maze-row-width
;

: maze.height ( -- n )
  maze-builder-row @
;

\ render the maze
: .maze ( -- )
  0 0 at-xy
  maze.height 0 do
    0 i at-xy
    maze.width 0 do
      i j maze@ dup maze-wall.glyph = if else drop bl then
      emit
    loop
  loop
;


: emit-at-location ( c a -- )
  location.to-xy at-xy emit
;

: render ( -- )
  .maze
  player.glyph player emit-at-location
  maze-exit.glyph maze-exit emit-at-location
;

\ Used for collision detection
create tmp-player location allot

: player->tmp-player ( -- )
  player tmp-player location move
;

: tmp-player->player ( -- )
  tmp-player player location move
;

: handle-input ( -- )
  player->tmp-player

  key case
    direction.up of
      -1 tmp-player location.y +!
    endof

    direction.down of
      1 tmp-player location.y +!
    endof

    direction.left of
      -1 tmp-player location.x +!
    endof

    direction.right of
      1 tmp-player location.x +!
    endof
  endcase

  tmp-player location.to-xy maze@ maze-wall.glyph = if
  else
    tmp-player->player
  then
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
