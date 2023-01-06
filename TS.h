#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>  
#include <stddef.h>
#include <string.h>
typedef struct Element
    {   int state;
		int cst;
		char name[20];
		char type[20];
		char code[20];
		char valstr[20];
		float val;
        struct Element *svt;
        } Pile;

Pile* pileidf;
Pile* pilemc ;
Pile* pilesep ;
char val_array[50][50],val_cal[50][50];
int q=0,b=0,typeidf=0,r=0,cst = 0;
char valstatic[20];
char valstr[20];
char valstatic_res[20];
char valstatic_msg[20];


/* Inisialiser la pile */
int initpile(Pile **s)
{
    *s=NULL;
}


/* Verifier si la pile est vide */
int pile_vide(Pile *s)
{
if(s==NULL)return 1;else return 0;
}



/* empiler (ajouter) un élément dans la pile */
void empiler(Pile **s, int x ,char entite[], char code[], char type[],int cst, float val, char valstr[])
{
		Pile *p;
		initpile(&p);
		p=(Pile*)malloc(sizeof(Pile));
		p->state=x;
		p->cst=cst;
		strcpy(p->name,entite);
		strcpy(p->code,code);
		strcpy(p->type,type);
		strcpy(p->valstr,valstr);
		p->val=val;
		p->svt=*s;
		*s=p;
}


/* depiler (retirer) un élément dans la pile */
void depiler(Pile **s)
{
        Pile *p=*s;
        *s=(*s)->svt; 
        p=NULL;
}


/* affichage de la pile */
void affichage(Pile *s)
{
	int valeurint;
	Pile *p;
	initpile(&p);

     while(!pile_vide(s)){

		if(s->state==1) {

			if(strcmp(s->type,"FLOAT")==0 && (strcmp(s->code,"CONST")!=0)){
				printf("| %d      | %15s   | %17s   | %13s    | %f \n",s->state,s->name,s->code,s->type,s->val);
			}
			if(strcmp(s->type,"INTEGER")==0 && (strcmp(s->code,"CONST")!=0)){
						valeurint=(int)s->val;
						printf("| %d      | %15s   | %17s   | %13s    | %d\n",s->state,s->name,s->code,s->type,valeurint);
			}
			if(strcmp(s->code,"IDF")==0)
			{
				printf("| %d      | %15s   | %17s   | %13s    | %s\n",s->state,s->name,s->code,s->type,s->valstr);
			}
			if((strcmp(s->code,"CONST")==0)){
				printf("| %d      | %15s   | %17s   | %13s    | %s\n",s->state,s->name,s->code,s->type,s->name);
			}
			if((strcmp(s->code,"mot cle")==0) || (strcmp(s->code,"sep")==0))
			{
				printf("| %d      | %15s   | %17s   | %13s    | \n",s->state,s->name,s->code,s->type);
			}
			
        }
	   empiler(&p,s->state,s->name,s->code,s->type,s->cst,s->val,s->valstr);
	   depiler(&s);
	}

while(!pile_vide(p)){

		empiler(&s,p->state,p->name,p->code,p->type,p->cst,p->val,p->valstr);
		depiler(&p);
}

}


/*initialisation de l'état des cases des tables des symbloles
0: libre
1:occupée*/

void initialisation()
{ 
  Pile *p; 
  initpile(&p);
	
  if(!pile_vide(pileidf))
  {
	 while(!pile_vide(pileidf)){
		empiler(&p,0,pileidf->name,pileidf->code,pileidf->type,pileidf->cst,pileidf->val,pileidf->valstr);
		depiler(&pileidf);
	 }
	 while(!pile_vide(p)){
		empiler(&pileidf,p->state,p->name,p->code,p->type,p->cst,p->val,p->valstr);
		depiler(&p);
	 }
  }else
  {
	  initpile(&pileidf);
  }

  if(!pile_vide(pilemc))
  {
	 while(!pile_vide(pilemc)){
		empiler(&p,0,pilemc->name,pilemc->code,pilemc->type,pilemc->cst,pilemc->val,pilemc->valstr);
		depiler(&pilemc);
	 }
	 while(!pile_vide(p)){
		empiler(&pilemc,p->state,p->name,p->code,p->type,p->cst,p->val,p->valstr);
		depiler(&p);
	 }
  }
  else
  {
	  initpile(&pilemc);
  }
 
  if(!pile_vide(pilesep))
  {
	 while(!pile_vide(pilesep)){
		empiler(&p,0,pilesep->name,pilesep->code,pilesep->type,pilesep->cst,pilesep->val,pilesep->valstr);
		depiler(&pilesep);
	 }
	 while(!pile_vide(p)){
		empiler(&pilesep,p->state,p->name,p->code,p->type,p->cst,p->val,p->valstr);
		depiler(&p);
	 }
  }
  else
  {
	  initpile(&pilesep);
  }
}



/* insertion des entititées lexicales dans les tables des symboles*/
void inserer (char entite[], char code[], char type[],int cst,char val[],char valstr[],int y)
{	
	float value;
	value = atof(val);
	
  switch (y)
 { 
   case 0:/*insertion dans la table des IDF et CONST*/
       empiler(&pileidf,1,entite,code,type,cst,value,valstr);
       break;

   case 1:/*insertion dans la table des mots clés*/
       empiler(&pilemc,1,entite,code,type,cst,value,valstr);
       break; 
    
   case 2:/*insertion dans la table des séparateurs*/
      empiler(&pilesep,1,entite,code,type,cst,value,valstr);
      break;
 }

}



/**************************chercher si l'entité existe dèja dans la table*/
void recherche (char entite[], char code[],char type[],char val[],char valstr[],int y)	
{
	Pile *p; initpile(&p);
	bool trouv = false;
	bool utiliser = false;
switch(y) 
  {
   case 0:/*verifier si la case dans la tables des IDF et CONST est libre*/
        
		
        if(!pile_vide(pileidf))
		{ 
		while (!pile_vide(pileidf) && trouv == false && utiliser == false)
		{
			if(strcmp(entite,pileidf->name)!=0){
                
				empiler(&p,pileidf->state,pileidf->name,pileidf->code,pileidf->type,pileidf->cst,pileidf->val,pileidf->valstr);
				depiler(&pileidf);	
			}else{
				if(pileidf->state == 0){
				trouv = true;
				depiler(&pileidf);
				}
				else{
					utiliser = true;
				}
			}
		}
        if(trouv == true)
		{	
          

          inserer(entite,code,type,0,val,valstr,0);
		  while(!pile_vide(p)){
			empiler(&pileidf,p->state,p->name,p->code,p->type,p->cst,p->val,p->valstr);
			depiler(&p);
		  }
		}
		if(pile_vide(pileidf) && utiliser == false)
		{	
          inserer(entite,code,type,0,val,valstr,0);
		  while(!pile_vide(p)){
			empiler(&pileidf,p->state,p->name,p->code,p->type,p->cst,p->val,p->valstr);
			depiler(&p);
		  }
		}
        else{
		  while(!pile_vide(p)){
			empiler(&pileidf,p->state,p->name,p->code,p->type,p->cst,p->val,p->valstr);
			depiler(&p);
		  }
		}
		}else{
			inserer(entite,code,type,0,val,valstr,0);
		}
        break;

   case 1:/*verifier si la case dans la tables des mots clés est libre*/
		if(!pile_vide(pilemc))
		{ 
		while (!pile_vide(pilemc) && trouv == false)
		{
			if(strcmp(entite,pilemc->name)!=0){
				empiler(&p,pilemc->state,pilemc->name,pilemc->code,pilemc->type,pilemc->cst,pilemc->val,pilemc->valstr);
				depiler(&pilemc);	
			}else{
				trouv = true;
				depiler(&pilemc);
			}
		}
        if(trouv == true)
		{	
          inserer(entite,code,type,0,val,valstr,1);
		  while(!pile_vide(p)){
			empiler(&pilemc,p->state,p->name,p->code,p->type,p->cst,p->val,p->valstr);
			depiler(&p);
		  }
		}
		if(pile_vide(pilemc))
		{	
          inserer(entite,code,type,0,val,valstr,1);
		  while(!pile_vide(p)){
			empiler(&pilemc,p->state,p->name,p->code,p->type,p->cst,p->val,p->valstr);
			depiler(&p);
		  }
		}
		}else{
			inserer(entite,code,type,0,val,valstr,1);
		}
        break; 
    
   case 2:/*verifier si la case dans la tables des séparateurs est libre*/
        if(!pile_vide(pilesep))
		{ 
		while (!pile_vide(pilesep) && trouv == false)
		{
			if(strcmp(entite,pilesep->name)!=0){
				empiler(&p,pilesep->state,pilesep->name,pilesep->code,pilesep->type,pilesep->cst,pilesep->val,pilesep->valstr);
				depiler(&pilesep);	
			}else{
				trouv = true;
				depiler(&pilesep);
			}
		}
        if(trouv == true)
		{	
          inserer(entite,code,type,0,val,valstr,2);
		  while(!pile_vide(p)){
			empiler(&pilesep,p->state,p->name,p->code,p->type,p->cst,p->val,p->valstr);
			depiler(&p);
		  }
		}
		if(pile_vide(pilesep))
		{	
          inserer(entite,code,type,0,val,valstr,2);
		  while(!pile_vide(p)){
			empiler(&pilesep,p->state,p->name,p->code,p->type,p->cst,p->val,p->valstr);
			depiler(&p);
		  }
		}
		}else{
			inserer(entite,code,type,0,val,valstr,2);
		}
        break; 
  }
}


/***************** Récuperer une partie du Strig ( Utilisé pour les Valeurs Signés)*/

char *getIntFromSigned(char *variable,int size,int value) {
    
    size_t len = size - value + 1;
    char *var = NULL;
    int cmpt = 0;
    bool ouv,ferm = false;
    char *arr = (char *)malloc(len + 1);
    if (arr)
    {
        size_t i;
        for (i = 0; i < len; ++i) {
            char c = (char)variable[(value + i)];
            if (c != '(' && c != ')') {
                arr[cmpt] = (char)variable[(value + i)];
                cmpt +=1;
            }
        }    
        arr[len] = '\0';
    }
    return arr;
}

/****************affichage*******************/


void afficher()
{
printf("\n\n\n");
printf("                              Table des symboles IDF et CONST\n");
printf("--------------------------------------------------------------------------------------------------\n");
printf("| State  |          Entite   |              code   |           type   |              Valeur       |\n");
printf("--------------------------------------------------------------------------------------------------\n");
if(!pile_vide(pileidf)){
	affichage (pileidf);
}
printf("--------------------------------------------------------------------------------------------------\n");
printf("\n\n\n");
printf("                              Table des symboles mots cles\n");
printf("--------------------------------------------------------------------------------------------------\n");
printf("| State  |          Entite   |              code   |           type   |              Valeur       |\n");
printf("--------------------------------------------------------------------------------------------------\n");
if(!pile_vide(pilemc)){
	affichage (pilemc);
}
printf("--------------------------------------------------------------------------------------------------\n");
printf("\n\n\n");
printf("                              Table des symboles separateurs\n");
printf("--------------------------------------------------------------------------------------------------\n");
printf("| State  |          Entite   |              code   |           type   |              Valeur       |\n");
printf("--------------------------------------------------------------------------------------------------\n");
if(!pile_vide(pilesep)){
	affichage (pilesep);
}
printf("--------------------------------------------------------------------------------------------------\n");
}