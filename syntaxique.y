%{
     #include <stddef.h>
	#include <stdio.h>
	#include <string.h>
	#include <stdlib.h>

	#define YYPARSE_PARAM scanner
    #define YYLEX_PARAM   scanner
    
	
	int yylex(void);
    int yyerror(char* s);
	
	int nbr_col = 0;
	int nb_ligne = 1;

	int current_indentation = 0;
	int indentation_min = 0;

	char sauvidf[20];
	char sauvtype[20];
	char sauvstring[100];
	char sauvstring_two[100];
	int n=0,j=0,t=0,y=0,oper[20];
	float val,x,f;
	char idf_array[30][20];
	char type_declaration[20];
	char list_idf[20][20];
	char val_str[30];
	int qc=0;

	float *val_general = 0;
	char result_final[30];
%}

%union {
	char* str;
	int entier;
	float floa;
}

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
entier_signe_negatif
reel_non_signe
reel_signe
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


%type<entier> entier_non_signe entier_signe entier_signe_negatif
%type<floa> reel_non_signe reel_signe reel_signe_negatif
%type<str> LIST_IDF idf carac boolean LIST_TYPES

%left op_different op_div op_egal op_et op_modulo op_moins op_multip op_non op_ou op_plus op_plus_grand op_plus_grand_egal op_plus_petit op_plus_petit_egal
%start DEBUT
%%

// Lister les possibilites
DEBUT: S 
S :      DEC_CST RETOUR_LIGNE
		| DEC_VAR RETOUR_LIGNE
		| DEC_TAB RETOUR_LIGNE 
		| LIST_INST RETOUR_LIGNE
		| OPERATION_LOGIQUE RETOUR_LIGNE

RETOUR_LIGNE: retour_ligne S 			{current_indentation = 0;}
		| retour_ligne END_FILE 		
		| retour_ligne INDENTATION S 	
		| 

END_FILE: retour_ligne END_FILE
		| espace END_FILE 	
		| 

// Indentation
INDENTATION: espace espace espace espace 		 {current_indentation += 1;}
		| espace espace espace espace INDENTATION {current_indentation += 1;}


DEC_CST: LIST_TYPES LIST_IDF affect CST {

										if (strcmp(type_declaration,sauvtype) == 0) {
												while(n != 0) {
													n--;
													quadr("=",sauvstring_two,"vide",list_idf[n]);
													x= declarationidf(list_idf[n],sauvtype,1,val_str,sauvstring);
													if(x == 1) {printf(" \n Error : Double déclaration de l'IDF, ligne %d,col %d, entité: %s  \n",nb_ligne,nbr_col,list_idf[n]); exit (0);};
												}
											} else {
												if (strcmp(type_declaration,"FLOAT") == 0) {
												    if (strcmp(sauvtype,"INTEGER") == 0) {
														while(n != 0) {
														n--;
														quadr("=",sauvstring_two,"vide",list_idf[n]);
														x= declarationidf(list_idf[n],sauvtype,1,val_str,sauvstring);
														if(x == 1) {printf(" \n Error : Double déclaration de l'IDF, ligne %d,col %d, entité: %s  \n",nb_ligne,nbr_col,list_idf[n]); exit (0);};
														}
													} else {
														printf(" \n Error : Type déclaré incorrect, ligne %d,col %d, entité: %s  \n",nb_ligne,nbr_col,$1); exit (0);
													}
												} else if (strcmp(type_declaration,"BOOLEAN") == 0) {
													if ((atof(val_str) == 1) || (atof(val_str) == 0)) {
														while(n != 0) {
															n--;
															quadr("=",sauvstring_two,"vide",list_idf[n]);
															x= declarationidf(list_idf[n],type_declaration,1,val_str,sauvstring);
															if(x == 1) {printf(" \n Error : Double déclaration de l'IDF, ligne %d,col %d, entité: %s  \n",nb_ligne,nbr_col,list_idf[n]); exit (0);};
														}
													} else {
															printf(" \n Error : Type déclaré incorrect, ligne %d,col %d, entité: %s  \n",nb_ligne,nbr_col,$1); exit (0);
													}
												} else {
													printf(" \n Error : Type déclaré incorrect, ligne %d,col %d, entité: %s  \n",nb_ligne,nbr_col,$1); exit (0);
												
												}
											}
										}


CST: reel_signe  		{strcpy(sauvtype,"FLOAT");val=$1;strcpy(sauvstring,"-");sprintf(val_str,"%f",val);}
	 | reel_non_signe 	{strcpy(sauvtype,"FLOAT");val=$1;strcpy(sauvstring,"-");sprintf(val_str,"%f",val);}
	 | entier_signe		{strcpy(sauvtype,"INTEGER");val=$1;strcpy(sauvstring,"-");sprintf(val_str,"%f",val);}
	 | entier_non_signe {strcpy(sauvtype,"INTEGER");val=$1;strcpy(sauvstring,"-");sprintf(val_str,"%f",val);}
	 | carac			{strcpy(sauvtype,"CHAR");val=0;strcpy(sauvstring,$1);}
	 | boolean			{if (strcmp($1,"true") == 0) {strcpy(sauvtype,"BOOLEAN");val=1;strcpy(sauvstring,"true");sprintf(val_str,"%f",val);
						 } else {strcpy(sauvtype,"BOOLEAN");val=0;strcpy(sauvstring,"false");sprintf(val_str,"%f",val);};}
	 

LIST_IDF: idf 							{ strcpy(list_idf[n],$1); n=1;}
	    | idf virgule LIST_IDF			{ strcpy(list_idf[n], $1); n=n+1; }	


LIST_TYPES: type_bool { strcpy(type_declaration,"BOOLEAN"); }
		| type_car	  { strcpy(type_declaration,"CHAR"); }
		| type_int	  { strcpy(type_declaration,"INTEGER"); }	
		| type_reel	  { strcpy(type_declaration,"FLOAT"); }




 
// Déclaration Tableau
DEC_TAB: LIST_TYPES crochet_ouv entier_non_signe crochet_ferm affect TAB_CONTENU {printf(" Déclaration d'un Tableau \n");}

TAB_CONTENU: accol_ouv LIST_TAB accol_ferm 
		| idf

LIST_TAB: CST virgule LIST_TAB
		| CST


// Déclaration Variable 
DEC_VAR:  LIST_TYPES LIST_IDF affect EXPR  	{

										if (strcmp(type_declaration,sauvtype) == 0) {
												while(n != 0) {
													n--;
													quadr("=",val_str,"vide",list_idf[n]);
													x= declarationidf(list_idf[n],sauvtype,1,val_str,sauvstring);
													if(x == 1) {printf(" \n Error : Double déclaration de l'IDF, ligne %d,col %d, entité: %s  \n",nb_ligne,nbr_col,list_idf[n]); exit (0);};
												}
											} else {
												 if (strcmp(type_declaration,"BOOLEAN") == 0) {
													if ((atof(val_str) == 1) || (atof(val_str) == 0)) {
														while(n != 0) {
															n--;
															quadr("=",val_str,"vide",list_idf[n]);
															x= declarationidf(list_idf[n],type_declaration,1,val_str,sauvstring);
															if(x == 1) {printf(" \n Error : Double déclaration de l'IDF, ligne %d,col %d, entité: %s  \n",nb_ligne,nbr_col,list_idf[n]); exit (0);};
														}
													} else {
															printf(" \n Error : Type déclaré incorrect, ligne %d,col %d, entité: %s  \n",nb_ligne,nbr_col,$1); exit (0);
													}
												} else {
													printf(" \n Error : Type déclaré incorrect, ligne %d,col %d, entité: %s  \n",nb_ligne,nbr_col,$1); exit (0);
												
												}
											}
										}


// Non Terminaux pour les variables
EXPR:   AFFECT_SIMPLE { strcpy(result_final,val_str);}
		| PARENTHESE_ET_CONTENU ENTRE_LES_PARANTHESES PARENTHESE_ET_CONTENU  // ( A+b) + ( a+  ((Y+b)))   (A+b) or (T+c)
		| PARENTHESE_ET_CONTENU ENTRE_LES_PARANTHESES PARENTHESE_ET_CONTENU ENTRE_LES_PARANTHESES EXPR // (A+b) or ()
		| PARENTHESE_ET_CONTENU ENTRE_LES_PARANTHESES NON PARENTHESE_ET_CONTENU ENTRE_LES_PARANTHESES EXPR
		| PARENTHESE_ET_CONTENU {}
		

AFFECT_SIMPLE: idf  {   strcpy(sauvidf,$1); x=idfused(sauvidf);
						if(x == 0){printf(" \n Erreur: IDF non déclaré: Line %d ,Col %d Entité: %s  \n",nb_ligne, nbr_col,sauvidf); exit (0);};
						if(x == 1){printf(" \n Erreur: IDF non initialisé: Line %d ,Col %d Entité: %s  \n",nb_ligne, nbr_col,sauvidf); exit (0);};
						if(x == 2){val = getValueIDF(sauvidf,&val_general); sprintf(val_str,"%f",*val_general);strcpy(sauvtype,"FLOAT");};
					}
			  | CST 


PARENTHESE_ET_CONTENU: EXPR_EXTREME  // idf ou Constante
		|	parenth_ouv EXPR parenth_ferm 	 // ( EXPR )	


EXPR_EXTREME: idf  	
		| CST 



NON: op_non
		| op_non NON 

ENTRE_LES_PARANTHESES: 
		| OPERATEURS_AJOUT_CONDITION
		| OPERATEURS_CALCUL
		| OPERATEURS_COMPARAISON


OPERATEURS_AJOUT_CONDITION: op_et
		| op_ou 


OPERATEURS_CALCUL: op_plus
		| op_div
		| op_moins
		| op_multip


OPERATEURS_COMPARAISON: op_plus_grand
		|  op_plus_petit
		|  op_egal
		|  op_plus_petit_egal
		|  op_plus_grand_egal
		|  op_different

      

TYPE_SIGNED: reel_signe
		| reel_signe_negatif
		| entier_signe
		| entier_signe_negatif


// Différentes Instructions 
OPERATION_LOGIQUE: idf affect EXPR


LIST_INST: CONDITION_IF
		| FOR_LOOP
		| WHILE_LOOP


CONDITION_IF: mot_cle_if parenth_ouv EXPR parenth_ferm deux_points RETOUR_LIGNE CONDITION_ELSE
		| mot_cle_if parenth_ouv EXPR parenth_ferm deux_points RETOUR_LIGNE

CONDITION_ELSE: mot_cle_else deux_points RETOUR_LIGNE



FOR_LOOP: mot_cle_for idf mot_cle_in mot_cle_range parenth_ouv BORNE virgule BORNE parenth_ferm deux_points
			 RETOUR_LIGNE 
		|	mot_cle_for idf mot_cle_in idf deux_points
			 RETOUR_LIGNE 


BORNE: reel_non_signe
		| entier_non_signe




WHILE_LOOP: mot_cle_while parenth_ouv EXPR parenth_ferm deux_points RETOUR_LIGNE


//CONDITION_ELSE: mot_cle_else deux_points retour_ligne CONTENU_CONDITION

//CONTENU_CONDITION: 


%%

int yyerror (char *s)
{
  fprintf (stderr, "%s\n", s);
  return 1;
}

int main () 
{
initialisation();
yyparse();
afficher();
}
int yywrap() {}