%{
    #include <stddef.h>
	#include <stdio.h>
	#include <string.h>

	int yylex(void);
    int yyerror(char* s);
	int nbr_col = 0;
	int nb_ligne = 1;
%}
%token cmnt
idf
affect 
affect_plus 
affect_moins 
op_plus
op_moins
op_multip
op_div
op_modulo
op_plus_grand
op_plus_petit
op_egal
op_plus_petit_egal
op_plus_grand_egal
op_different
op_non
op_et
op_ou
type_int
type_reel
type_car
type_bool
entier_non_signe
entier_signe
entier_non_signe_negatif
entier_signe_negatif
reel_non_signe
reel_signe
reel_non_signe_negatif
reel_signe_negatif
boolean
carac
deux_points
virgule
parenth_ouv
parenth_ferm
crochet_ouv
crochet_ferm
accol_ouv
accol_ferm
mot_cle_if
mot_cle_else
mot_cle_while
mot_cle_for
mot_cle_in
mot_cle_range
tab
retour_ligne
espace

%left op_different op_div op_egal op_et op_modulo op_moins op_multip op_non op_ou op_plus op_plus_grand op_plus_grand_egal op_plus_petit op_plus_petit_egal
%start DEBUT
%%

// Lister les possibilites
DEBUT: S {printf("\n Fin de Programme - Success \n \n");}
S :     DEC_VAR RETOUR_LIGNE	
		| DEC_TAB RETOUR_LIGNE 
		| LIST_INST RETOUR_LIGNE
		| OPERATION_LOGIQUE RETOUR_LIGNE
		

RETOUR_LIGNE: retour_ligne S 
		| retour_ligne END_FILE 
		| retour_ligne INDENTATION S 
		| 

END_FILE: retour_ligne END_FILE
		| espace END_FILE 	
		| 

// Indentation
INDENTATION: espace espace espace espace 
		| espace espace espace espace INDENTATION




// Déclaration Variable 
DEC_VAR:  LIST_TYPES LIST_IDF affect EXPR  	{printf("Déclaration d'une Variable \n");}

 
// Déclaration Tableau
DEC_TAB: LIST_TYPES crochet_ouv entier_non_signe crochet_ferm affect TAB_CONTENU {printf(" Déclaration d'un Tableau \n");}

TAB_CONTENU: accol_ouv LIST_TAB accol_ferm 
		| idf

LIST_TAB: TYPE_CST virgule LIST_TAB
		| TYPE_CST


// Non Terminaux pour les variables


EXPR:    PARENTHESE_ET_CONTENU ENTRE_LES_PARANTHESES PARENTHESE_ET_CONTENU
		| PARENTHESE_ET_CONTENU ENTRE_LES_PARANTHESES PARENTHESE_ET_CONTENU ENTRE_LES_PARANTHESES EXPR
		| PARENTHESE_ET_CONTENU ENTRE_LES_PARANTHESES NON PARENTHESE_ET_CONTENU ENTRE_LES_PARANTHESES EXPR
		| PARENTHESE_ET_CONTENU 
		 	

NON: op_non
		| op_non NON

ENTRE_LES_PARANTHESES: 
		| OPERATEURS_AJOUT_CONDITION
		| OPERATEURS_CALCUL
		| OPERATEURS_COMPARAISON

PARENTHESE_ET_CONTENU: EXPR_EXTREME 
		|	parenth_ouv EXPR parenth_ferm 
		|   TYPE_SIGNED


EXPR_EXTREME: idf 
		| TYPE_CST

TYPE_SIGNED: reel_signe
		| reel_signe_negatif
		| entier_signe
		| entier_signe_negatif

TYPE_CST: boolean
		| carac
		| TYPE_NUMERIQUE

TYPE_NUMERIQUE: reel_non_signe
		| entier_non_signe
		| entier_non_signe_negatif
		| reel_non_signe_negatif


OPERATEURS_CALCUL: op_plus
		| op_div
		| op_moins
		| op_multip






LIST_TYPES: type_bool
		| type_car
		| type_int
		| type_reel


LIST_IDF: idf 
	    | idf virgule LIST_IDF





// Différentes Instructions 

OPERATION_LOGIQUE: idf affect EXPR


LIST_INST: CONDITION_IF
		| FOR_LOOP
		| WHILE_LOOP


CONDITION_IF: mot_cle_if parenth_ouv EXPR parenth_ferm deux_points RETOUR_LIGNE CONDITION_ELSE
		| mot_cle_if parenth_ouv EXPR parenth_ferm deux_points RETOUR_LIGNE

CONDITION_ELSE: mot_cle_else deux_points RETOUR_LIGNE

OPERATEURS_AJOUT_CONDITION: op_et
		| op_ou

FOR_LOOP: mot_cle_for idf mot_cle_in mot_cle_range parenth_ouv BORNE virgule BORNE parenth_ferm deux_points
			 RETOUR_LIGNE 
		|	mot_cle_for idf mot_cle_in idf deux_points
			 RETOUR_LIGNE 


BORNE: reel_non_signe
		| entier_non_signe

OPERATEURS_COMPARAISON: op_plus_grand
		|  op_plus_petit
		|  op_egal
		|  op_plus_petit_egal
		|  op_plus_grand_egal
		|  op_different


WHILE_LOOP: mot_cle_while parenth_ouv EXPR parenth_ferm deux_points RETOUR_LIGNE


//CONDITION_ELSE: mot_cle_else deux_points retour_ligne CONTENU_CONDITION

//CONTENU_CONDITION: 


%%

int yyerror(char *msg){ printf("Erreur Syntaxique"); }

int main () 
{
initialisation();
yyparse();
afficher();
}
int yywrap()
{}
