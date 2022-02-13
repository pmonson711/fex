  $ fex --help=plain
  NAME
         fex - Filter JSON via the fex expression
  
  SYNOPSIS
         fex [--fex-string=fex] [--json-file=./json_file.json] [OPTION]…
         [fex] [./json_file.json]
  
  ARGUMENTS
         ./json_file.json
             json file to filter
  
         fex Filter string to predicate
  
  OPTIONS
         -f fex, --fex-string=fex
             Filter string to predicate
  
         -j ./json_file.json, --json-file=./json_file.json
             json file to filter
  
  COMMON OPTIONS
         --help[=FMT] (default=auto)
             Show this help in format FMT. The value FMT must be one of auto,
             pager, groff or plain. With auto, the format is pager or plain
             whenever the TERM env var is dumb or undefined.
  
         --version
             Show version information.
  
  EXIT STATUS
         fex exits with the following status:
  
         0   on success.
  
         123 on indiscriminate errors reported on standard error.
  
         124 on command line parsing errors.
  
         125 on unexpected internal errors (bugs).
  
  BUGS
         Email bug reports to <pmonson711@gmail.com>.
  
