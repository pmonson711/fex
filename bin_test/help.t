Has expected help
  $ fex --help
  FEX(1)                            Fex Manual                            FEX(1)
  
  
  
  NNAAMMEE
         fex - Filter JSON via the fex expression
  
  SSYYNNOOPPSSIISS
         ffeexx [_O_P_T_I_O_N]... [_F_E_X] [_J_S_O_N]
  
  AARRGGUUMMEENNTTSS
         _F_E_X Filter string to predicate
  
         _J_S_O_N (absent=[])
             JSON string to filter
  
  OOPPTTIIOONNSS
         ----hheellpp[=_F_M_T] (default=auto)
             Show this help in format _F_M_T. The value _F_M_T must be one of `auto',
             `pager', `groff' or `plain'. With `auto', the format is `pager` or
             `plain' whenever the TTEERRMM env var is `dumb' or undefined.
  
         ----vveerrssiioonn
             Show version information.
  
  EEXXIITT SSTTAATTUUSS
         ffeexx exits with the following status:
  
         0   on success.
  
         124 on command line parsing errors.
  
         125 on unexpected internal errors (bugs).
  
  BBUUGGSS
         Email bug reports to <pmonson711@gmail.com>.
  
  
  
  Fex 11VERSION11                                                         FEX(1)
