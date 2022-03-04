\ Controls
char w constant direction.up
char s constant direction.down
char a constant direction.left
char d constant direction.right

char @ constant player.glyph
variable player.x
variable player.y

: render ( -- )
  player.x @ player.y @ at-xy
  player.glyph emit
;

: handle-input ( -- )
  key case
    direction.up of
      -1 player.y +!
    endof

    direction.down of
      1 player.y +!
    endof

    direction.left of
      -1 player.x +!
    endof

    direction.right of
      1 player.x +!
    endof
  endcase
;

: game ( -- )
  begin
    page
    render
    handle-input
  again
;

game
