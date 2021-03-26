// Louis Delacroix 
// Etienne Dhaussy
.data
Retour:
	.string "\n"
Erreur:
	.string "Mauvais nombre d'operande\n"
Ecrit:
	.int 0
Buffer:
	.string ""
.globl _start
.text
_start:
	movq $0,%r13 	/*Initialisation du registre contenant la valeur courante*/
        movq $0,%r12    /*Nombre d'opérande dans la pile*/
        movq $0,%rax    /* 0 is the read instruction*/
        movq $0, %rdi   /*0 indicate that the input is the keyboard*/
        movq $50, %rdx          /*rdx contains the 1 octet to read*/
        movq $Buffer, %rsi      /*rsi contains the adress of where to put the data*/
        syscall

        movq $Buffer,%r9 /*On stocke l'adresse du caractère*/
lecture:
        movb (%r9),%r10b/* On récupère le caractère*/   
        inc %r9         /* On pointe le caractère suivant*/
        cmp $32,%r10    /* On regarde si c'est un espace*/
	je espace
	cmp $43,%r10 /* On regarde si c'est le signe + */
	je plus
	cmp $45,%r10 /* On regarde si c'est le signe - */
	je moins
	cmp $47,%r10 /*On regarde si c'est le signe / */
	je diviser
	cmp $42,%r10 	/* On regarde si c'est le signe * */
	je fois
	cmp $10,%r10 	/* On regarde si c'est un retour a la ligne*/
	je resultat
	cmp $0,%r13 	/*On observer si r13 est vide*/
	jne decaleAGauche
valeur:
	sub $48,%r10 /*On recupere le chiffre en soustrayant le décalage entre le code ascii et le chiffre réel*/
	add %r10,%r13	/*On ajoute*/
	jmp lecture

decaleAGauche:
	mov %r13, %rax  /*On prepare a multiplier*/
        mov $10,%rbx    /* On va multiplier par 10*/
        imul %rbx       /*On multiplie*/
	movq %rax,%r13 	/*On modifie r13*/
	jmp valeur
espace:
	push %r13	/*ajoute le nombre courant dans la pile*/
	mov $0,%r13	/*reinitialise r13*/
	inc %r12	/*incrémente le compteur d'operande de 1*/
	movb (%r9),%r10b/*regarde le caractere suivant*/
	cmp $10,%r10	/*Compare le caractere suivant avec l'espace*/
	je resultat	/*Si c'est un espace imprime le resultat car fin de chaine*/
	jmp lecture	/*sinon continue la lecture*/

plus:
	cmp $2,%r12	/*Regarde si le nombre d'opérande est supérieur à 2*/
	jl errorQuit	/*Si mauvais nombre d'opérande imprime ErrorQuit*/ 
	pop %r10	/* Stock la premiere operande dans r10*/
	pop %r11	/* Stock la seconde  operande dans r11*/
	add %r10,%r11	/* addition des operande*/
	push %r11	/* met le resultat dans la pile*/
	dec %r12	/* la pile a donc perdu un operande */
	movb (%r9),%r10b /* regarde le caractere suivant */
	cmp $43,%r10	/* compare le caractere suivant avec le signe +*/
	je resultat	/* si egale fin de ligne renvoie le resultat*/
	cmp $10,%r10    /* On regarde si c'est un retour a la ligne*/
        je resultat
	inc %r9         /* On pointe le caractère suivant*/
	jmp lecture	/* sinon continue la lecture*/

moins:
	cmp $2,%r12     /*Regarde si le nombre d'opérande est supérieur à 2*/
        jl errorQuit    /*Si mauvais nombre d'opérande imprime ErrorQuit*/ 

	pop %r10        /* Stock la premiere operande dans r10*/
        pop %r11        /* Stock la seconde  operande dans r11*/
	sub %r10,%r11	/* Soustrait les operandes*/
	push %r11	/* ajoute le resultat à la pile*/
	dec %r12        /* la pile a donc perdu un operande */
        movb (%r9),%r10b /* regarde le caractere suivant */
        cmp $45,%r10    /* compare le caractere suivant avec le signe -*/
        je resultat     /* si egale fin de ligne renvoie le resultat*/
	cmp $10,%r10    /* On regarde si c'est un retour a la ligne*/
        je resultat
	inc %r9         /* On pointe le caractère suivant*/
	jmp lecture	/* sinon continue la lecture*/

diviser:
	cmp $2,%r12     /* On verifie que le nombre d'operande est suffisant*/
        jl errorQuit    /* Lance le message Erreur et quit le programe*/

	movq $0,%rdx	/* Initialise rdx le stockage du reste*/
	pop %rcx        /* Stock le diviseur dans rbx*/
        pop %rax        /* Stock le divise dans rax*/
	div %rcx	/* Fait la division*/
	push %rax	/* Ajoute le resultat à la pile*/
	dec %r12        /* la pile a donc perdu un operande */
        movb (%r9),%r10b /* regarde le caractere suivant */
        cmp $47,%r10    /* compare le caractere suivant avec le signe / */
        je resultat     /* si egale fin de ligne renvoie le resultat*/
	cmp $10,%r10    /* On regarde si c'est un retour a la ligne*/
        je resultat
        inc %r9         /* On pointe le caractère suivant*/
	jmp lecture     /* sinon continue la lecture*/

fois:
	cmp $2,%r12     /* On verifie que le nombre d'operande est suffisant*/
        jl errorQuit    /* Lance le message Erreur et quit le programe*/

	pop %rbx        /* Stock le premier facteur dans rbx*/
        pop %rax        /* Stock le second facteur dans rax*/
        imul %rbx       /* Fait la multiplication*/
        push %rax       /* Ajoute le resultat à la pile*/
	dec %r12	/* La pile a perdu une opérande*/
        movb (%r9),%r10b /* regarde le caractere suivant */
        cmp $42,%r10    /* compare le caractere suivant avec le signe * */
        je resultat     /* si egale fin de ligne renvoie le resultat*/
	cmp $10,%r10    /* On regarde si c'est un retour a la ligne*/
        je resultat
	inc %r9         /* On pointe le caractère suivant*/
	jmp lecture     /* sinon continue la lecture*/

errorQuit:
	movq $1,%rax
	movq $1,%rdi
	movq $Erreur,%rsi
	movq $26,%rdx
	syscall
	jmp exit
/* Traitement à l'impression des nombres de plus de un chiffre*/

decaleADroite:
	movq %rax,%r13	/*Stocke l'ancien résultat de la division dans %r13*/
	inc %r12	/*Incrémente le compteur de chiffre de 1*/
	movq $0,%rdx    /* Initialise rdx le stockage du reste*/
        movq %r13,%rax  /*Initialise le stockage du divise*/
        movq $10,%rcx   /*Initialise le stockage du diviseur*/
	div %rcx	/* On divise*/
	cmp $0,%rax	/* Compare le resultat de la division et 0*/
	jne decaleADroite /*Si different de zero recommence l'operation*/
	inc %r12	/* Incremente %r12 pour permettre un decalage*/ 

separeChiffre:
	movq $1,%rax 	/*prepare la separe la separation*/
	dec %r12	/*decremente r12*/
	movq %r12,%r13	/* Prepare la separation des chiffres*/
decale:
	movq $10,%rbx	/*prepare la multiplication*/
	imul %rbx	/* multiplie*/
	dec %r13	/*On decremente r13*/
	cmp $0,%r13	/*on comprare r13 et zero*/
	jne decale	/*si different de zero on recommence*/
	movq %rax,%rcx	/* Intialise le diviseur*/
	movq $0,%rdx    /* Initialise rdx le stockage du reste*/
        pop %r11	/*Stocke la valeur dans r11*/
	movq %r11,%rax  /*Initialise le stockage du divise*/
        div %rcx	/* On divise*/
	movq %rcx,%rbx	/*Prépare à retrancher*/
	movq %rax,%r14	/*On stocke le resultat dans r14*/
	movq %rdx,%r15	/*On stocke le reste dans r15*/
	imul %rbx	/*Prepare à retrancher*/
	sub %rax,%r11	/*Retranche*/
	push %r11	/*Stocke la valeur dans la pile*/
	jmp imprime	/*Imprime le chiffre*/

resultat:
	cmp $0,%r12	/* Verifie qu'il y a quelque chose dans la pile*/
	je errorQuit	/* Sinon lance le message d'erreur*/
	cmp $1,%r12	/* Verifie que la pile n'a qu'un element*/
	jne errorQuit	/* Sinon lance un message d'erreur*/
	movq $0,%r12	/* Initialise le compteur de chiffre composant le nombre*/
	pop %r11	/*Recupere le resultat*/
	movq $0,%rdx    /* Initialise rdx le stockage du reste*/
	movq %r11,%rax	/*Initialise le stockage du divise*/
	push %r11	/* Remet la valeur dans la pile*/
	movq $10,%rcx	/*Initialise le stockage du diviseur*/
        div %rcx        /* Fait la division*/
	cmp $0,%rax	/* Compare zero et le resultat de la division*/
	jne decaleADroite/*Si different de zero le nombre est compose de plusieur chiffre*/
	movq %r11,%r15	/*Sinon stocke dans %r15 le chiffre */
	jmp imprimeReste/*On l'imprime*/ 
	
imprime :
	add $48,%r14
	movq %r14,Ecrit
	movq $1, %rax
	movq $1, %rdi
	movq $Ecrit,%rsi
	movq $8, %rdx
	syscall
	cmp $1,%r12
	je imprimeReste 	/*Si r12 est egale a 1 il n y a plus que le reste a imprimer*/
	cmp $0,%r12		/*Compare 0 et le nombre de chiffre*/
	jne separeChiffre	/*si different de zero separe le prochain chiffre*/
	
imprimeReste:
	add $48,%r15	/*On ajoute 48 (le decalage ascii) au resultat*/
	movq %r15, Ecrit/*On deplace le resultat a Ecrit*/
	movq $1, %rax
        movq $1, %rdi
	movq $Ecrit,%rsi/* On prepare l'impression*/
	movq $8,%rdx	/*Taille de l'object à imprimer*/
	syscall	/*imprime*/
	movq $1, %rax
        movq $1, %rdi
	movq $Retour,%rsi 	/*Ecrit retour a la ligne*/
	movq $1,%rdx		/*Taille de retour a la ligne*/
	syscall			/*Imprime retour a la ligne*/
	
exit:
	movq $60, %rax	/*Terminaison Linux*/
	xorq %rdi, %rdi
	syscall
