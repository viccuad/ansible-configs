set confirm off
set verbose off
set history filename ~/.gdb_history
set history save

set output-radix 0x10
set input-radix 0x10

# These make gdb never pause in its output
set height 0
set width 0

# go support
add-auto-load-safe-path /usr/share/go/src/runtime/runtime-gdb.py
