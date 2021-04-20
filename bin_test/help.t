  $ fex --help=plain
  NAME
         fex - Filter JSON via the fex expression
  
  SYNOPSIS
         fex [OPTION]... [FEX] [JSON]
  
  ARGUMENTS
         FEX Filter string to predicate
  
         JSON (absent=[])
             JSON string to filter
  
  OPTIONS
         --help[=FMT] (default=auto)
             Show this help in format FMT. The value FMT must be one of `auto',
             `pager', `groff' or `plain'. With `auto', the format is `pager` or
             `plain' whenever the TERM env var is `dumb' or undefined.
  
         --version
             Show version information.
  
  EXIT STATUS
         fex exits with the following status:
  
         0   on success.
  
         124 on command line parsing errors.
  
         125 on unexpected internal errors (bugs).
  
  BUGS
         Email bug reports to <pmonson711@gmail.com>.
  
