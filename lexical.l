%{
#include <stdio.h>
#include "syntaxique.tab.h"
#include "TS.h"
int nbr_indentation=0;
int nbr_espace=0;
int nbr_col_fin_ligne=0;
int i=0;
char value[0x100];

extern int nbr_col;
extern int nb_ligne;
%}
lettre [a-zA-Z]
lettre_maj [A-Z]
chiffre [0-9]
IDF {lettre_maj}({lettre}|{chiffre})*
boolean (true|false)
cmnt #.*


entier_non_signe ([1-9]{chiffre}*|0)
entier_non_signe_negatif (-[1-9]{chiffre}*|0)
entier_signe (\({entier_non_signe}\))
entier_signe_negatif (\({entier_non_signe_negatif}\))

reel_non_signe ({entier_non_signe}"."{chiffre}+|0)
reel_non_signe_negatif (-{entier_non_signe}"."{chiffre}+|0)
reel_signe (\({reel_non_signe}\))
reel_signe_negatif (\({reel_non_signe_negatif}\))

car (\'|\")[^'](\'|\")
espace [ ]
%%
{cmnt}                          {nbr_col += yyleng;}

{IDF}                           {if (yyleng > 8) { printf("Erreur lexical a la ligne %d colonne %d entite %s: Identificateur trop long",nb_ligne,nbr_col,yytext); } else {
                                      recherche (yytext,"IDF","-","0","-",0);
                                      nbr_col += yyleng;
                                      yylval.str=strdup(yytext);
                                      return idf;
                                    }
                                    nbr_col += yyleng; };

{entier_non_signe}              {recherche (yytext,"CONST","INTEGER",yytext,"-",0);
                                 i = atoi(yytext);
                                 if (i >= 0  && i < 65536) {
                                    yylval.entier = i;
                                    return entier_non_signe;    
                                 } else {
                                    printf("Erreur Lexical Ligne %d colonne %d entite %s : INTEGER is too big \n",nb_ligne, nbr_col, yytext);    
                                 };  nbr_col += yyleng;}

{entier_signe}                  {strcpy(value,getIntFromSigned(yytext,yyleng,1));yyleng -= 1;recherche (value,"CONST","INTEGER",value,"-",0);
                                 i = atoi(value);
                                 if (i >= -32767  && i <= 32767) {
                                    yylval.entier = i;
                                    return entier_signe;    
                                 } else {
                                    printf("Erreur Lexical Ligne %d colonne %d entite %s : INTEGER is too big  \n",nb_ligne, nbr_col, yytext);    
                                 };  nbr_col += yyleng;}

{entier_non_signe_negatif}      {printf("Erreur Lexical Ligne %d colonne %d entite %s : UNSIGNED INTEGER can't be negative  \n",nb_ligne, nbr_col, yytext);  nbr_col += yyleng;}
{entier_signe_negatif}          {printf("test");strcpy(value,getIntFromSigned(yytext,yyleng,1));yyleng -= 1; yylval.entier = atoi(value); recherche (value,"CONST","INTEGER",value,"-",0);
                                i = atoi(value);
                                 if (i >= -32767  && i <= 32767) {
                                    yylval.entier = i;
                                    return entier_signe_negatif;    
                                 } else {
                                    printf("Erreur Lexical Ligne %d colonne %d entite %s : INTEGER is too big  \n",nb_ligne, nbr_col, yytext);    
                                 }; nbr_col += yyleng;return entier_signe_negatif;}

{reel_non_signe}                {recherche (yytext,"CONST","FLOAT",yytext,"-",0); yylval.floa = atof(yytext);   nbr_col += yyleng;return reel_non_signe;}
{reel_signe}                    {strcpy(value,getIntFromSigned(yytext,yyleng,1));yyleng -= 1;recherche (value,"CONST","FLOAT",value,"-",0);   yylval.floa = atof(value); nbr_col += yyleng;return reel_signe;}

{reel_non_signe_negatif}        {printf("Erreur Lexical Ligne %d colonne %d entite %s : UNSIGNED INTEGER can't be negative  \n",nb_ligne, nbr_col, yytext);nbr_col += yyleng;}
{reel_signe_negatif}            {strcpy(value,getIntFromSigned(yytext,yyleng,1));yyleng -= 1;recherche (value,"CONST","FLOAT",value,"-",0);   yylval.floa = atof(value); nbr_col += yyleng;return reel_signe_negatif;}

{car}                           {recherche (yytext,"CONST","CHAR",yytext,"-",0);    yylval.str=strdup(yytext); nbr_col += yyleng;return carac;}
{boolean}                       {recherche (yytext,"CONST","BOOLEAN",yytext,"-",0); yylval.str=strdup(yytext); nbr_col += yyleng;return boolean;}

"="                             {recherche (yytext,"sep","-","0","-",2); nbr_col += yyleng;return affect;}
"+="                            {recherche (yytext,"sep","-","0","-",2); nbr_col += yyleng;return affect_plus;}
"-="                            {recherche (yytext,"sep","-","0","-",2); nbr_col += yyleng;return affect_moins;}
"+"                             {recherche (yytext,"sep","-","0","-",2); nbr_col += yyleng;return op_plus;}
"-"                             {recherche (yytext,"sep","-","0","-",2); nbr_col += yyleng;return op_moins;}
"*"                             {recherche (yytext,"sep","-","0","-",2); nbr_col += yyleng;return op_multip;}
"/"                             {recherche (yytext,"sep","-","0","-",2); nbr_col += yyleng;return op_div;}

">"                             {recherche (yytext,"sep","-","0","-",2); nbr_col += yyleng;return op_plus_grand;}
"<"                             {recherche (yytext,"sep","-","0","-",2); nbr_col += yyleng;return op_plus_petit;}
"=="                            {recherche (yytext,"sep","-","0","-",2); nbr_col += yyleng;return op_egal;}
"<="                            {recherche (yytext,"sep","-","0","-",2); nbr_col += yyleng;return op_plus_petit_egal;}
">="                            {recherche (yytext,"sep","-","0","-",2); nbr_col += yyleng;return op_plus_grand_egal;}
"!="                            {recherche (yytext,"sep","-","0","-",2); nbr_col += yyleng;return op_different;}

":"                             {recherche (yytext,"sep","-","0","-",2); nbr_col += yyleng;return deux_points;}
","                             {recherche (yytext,"sep","-","0","-",2); nbr_col += yyleng;return virgule;}
"("                             {recherche (yytext,"sep","-","0","-",2); nbr_col += yyleng;return parenth_ouv;}
")"                             {recherche (yytext,"sep","-","0","-",2); nbr_col += yyleng;return parenth_ferm;}
"["                             {recherche (yytext,"sep","-","0","-",2); nbr_col += yyleng;return crochet_ouv;}
"]"                             {recherche (yytext,"sep","-","0","-",2); nbr_col += yyleng;return crochet_ferm;}
"{"                             {recherche (yytext,"sep","-","0","-",2); nbr_col += yyleng;return accol_ouv;}
"}"                             {recherche (yytext,"sep","-","0","-",2); nbr_col += yyleng;return accol_ferm;}

"not"                           {recherche (yytext,"mot cle","-","0","-",1); nbr_col += yyleng;return op_non;}
"and"                           {recherche (yytext,"mot cle","-","0","-",1); nbr_col += yyleng;return op_et;}
"or"                            {recherche (yytext,"mot cle","-","0","-",1); nbr_col += yyleng;return op_ou;}

"int"                           {recherche (yytext,"mot cle","-","0","-",1); yylval.str=strdup("INTEGER"); nbr_col += yyleng;return type_int;}
"float"                         {recherche (yytext,"mot cle","-","0","-",1); yylval.str=strdup("FLOAT"); nbr_col += yyleng;return type_reel;}
"char"                          {recherche (yytext,"mot cle","-","0","-",1); yylval.str=strdup("CHAR"); nbr_col += yyleng;return type_car;}
"bool"                          {recherche (yytext,"mot cle","-","0","-",1); yylval.str=strdup("BOOLEAN"); nbr_col += yyleng;return type_bool;}

"if"                            {recherche (yytext,"mot cle","-","0","-",1); nbr_col += yyleng;return mot_cle_if;}
"else"                          {recherche (yytext,"mot cle","-","0","-",1); nbr_col += yyleng;return mot_cle_else;}
"while"                         {recherche (yytext,"mot cle","-","0","-",1); nbr_col += yyleng;return mot_cle_while;}
"for"                           {recherche (yytext,"mot cle","-","0","-",1); nbr_col += yyleng;return mot_cle_for;}
"in"                            {recherche (yytext,"mot cle","-","0","-",1); nbr_col += yyleng;return mot_cle_in;}
"range"                         {recherche (yytext,"mot cle","-","0","-",1); nbr_col += yyleng;return mot_cle_range;}

\n                              {nbr_col += yyleng;nb_ligne++;nbr_col_fin_ligne=nbr_col;return retour_ligne;}
{espace}                        {if (nbr_col_fin_ligne == nbr_col) {return espace; nbr_col += 1;};}
.                               {printf("Erreur lexicale ligne %d , colonne %d sur l'entite %s \n",nb_ligne,nbr_col,yytext);}
%%
