
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>  
#include <stddef.h>
#include <string.h>


typedef struct Quad_Element
    {   int qc;
        char operateur[20];
        char op_1[20];
        char op_2[20];
        char temp[20];

        struct Quad_Element *svt; 
    } Quad;

Quad *pilequad;
int qc = 0;





void modifierQuad(int qc, int col, char val [])
{
		
}



/* Inisialiser la pile */
int initpileQuad(Quad **s)
{
    *s=NULL;
}


/* Verifier si la pile est vide */
int pile_videQuad(Quad *s)
{
if(s==NULL)return 1;else return 0;
}



void ajouterQuad(char operateur[], char op_1[], char op_2[], char temp[]) {
        
        Quad *z;
		initpileQuad(&z);
		z=(Quad*)malloc(sizeof(Quad));
        qc = qc +1;

        z->qc = qc;
		strcpy(z->operateur,operateur);
		strcpy(z->op_1,op_1);
		strcpy(z->op_2,op_2);
		strcpy(z->temp,temp);

        qc = qc +1;

		z->svt= pilequad;
		pilequad = z;
}


void updateQuad(int qc,int col,char *val) {
        Quad *z;
		initpileQuad(&z);


        while (!pile_videQuad(pilequad))
		{
			empilerQuad(&z,pilequad->qc,pilequad->operateur,pilequad->op_1,pilequad->op_2,pilequad->temp);
			depilerQuad(&pilequad);

			if (z->qc == qc) {
				switch (col)
				{
				case 0:
					strcpy(z->operateur,val);
					break;
				case 1:
					strcpy(z->op_1,val);
					break;
				case 2:
					strcpy(z->op_2,val);
					break;

				default:
					strcpy(z->temp,val);
					break;
				}
			}
		}

		while (!pile_videQuad(&z))
		{
			empilerQuad(&pilequad,z->qc,z->operateur,z->op_1,z->op_2,z->temp);
			depilerQuad(&z);
		}
		
		
}

/* empilerQuad (ajouter) un élément dans la pile */
void empilerQuad(Quad **l ,int qc,char operateur[], char op_1[], char op_2[], char temp[])
{
		Quad *z;
		initpileQuad(&z);
		z=(Quad*)malloc(sizeof(Quad));
		
		z->qc = qc;
        

		strcpy(z->operateur,operateur);
		strcpy(z->op_1,op_1);
		strcpy(z->op_2,op_2);
		strcpy(z->temp,temp);

		z->svt=*l;
		*l=z;
}


/* depilerQuad (retirer) un élément dans la pile */
void depilerQuad(Quad **s)
{
        Quad *p=*s;
        *s=(*s)->svt; 
        p=NULL;
}


/* affichage de la pile */
void affichageQuad(Quad *s)
{
	Quad *p;
	initpileQuad(&p);

     while(!pile_videQuad(s)){
		
        printf("| %5s      | %18s   | %21s   | %29s    | \n",s->operateur,s->op_1,s->op_2,s->temp);
        

	   empilerQuad(&p,s->qc,s->operateur,s->op_1,s->op_2,s->temp);
	   depilerQuad(&s);
	}

while(!pile_videQuad(p)){

		empilerQuad(&s,p->qc,p->operateur,p->op_1,p->op_2,p->temp);
		depilerQuad(&p);
}

}


void afficherQuad()
{
printf("\n\n\n");
printf("                              LISTE DES QUADRUPLÉS\n");
printf("--------------------------------------------------------------------------------------------------\n");
printf("| Operateur  |       Opérande       |         Opérande        |         Resultat                 |\n");
printf("--------------------------------------------------------------------------------------------------\n");
if(!pile_videQuad(pilequad)){
	affichageQuad (pilequad);
}
}


/*initialisation de l'état des cases des tables des symbloles
0: libre
1:occupée
*/
void initialisationQuad()
{ 
  Quad *p; 
  initpileQuad(&p);

  if(!pile_videQuad(pilequad))
  {
     
	 while(!pile_videQuad(pilequad)){

		empilerQuad(&p,pilequad->qc,pilequad->operateur,pilequad->op_1,pilequad->op_2,pilequad->temp);
		depilerQuad(&pilequad);
	 }

    
	 while(!pile_videQuad(p)){
		empilerQuad(&pilequad,p->qc,p->operateur,p->op_1,p->op_2,p->temp);
		depilerQuad(&p);
	 }
  }  else  {
	  initpile(&pilequad);
  }

  
}

