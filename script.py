import os
import sys

if (len(sys.argv) < 2):
    os.system("flex lexical.l && bison -d syntaxique.y -Wcounterexamples && gcc lex.yy.c syntaxique.tab.c -o TP  && ./TP<exemple.txt")
else:
    if (sys.argv[1] == 1):
        os.system("flex lexical.l && bison -d syntaxique.y && gcc lex.yy.c syntaxique.tab.c -Wno-format -Wno-implicit-function-declaration   -o TP  && ./TP<exemple.txt")
    else:
        os.system("flex lexical.l && bison -d syntaxique.y -Wconflicts-sr && gcc lex.yy.c syntaxique.tab.c -Wno-format -Wno-implicit-function-declaration  -o TP  && ./TP<exemple.txt")
        