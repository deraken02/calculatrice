// Louis Delacroix 
// Etienne Dhaussy
.data

Ecrit:
	.int 0	
Erreur:
        .string "Mauvais nombre d'operande\n"
Buffer:
        .string ""

.globl main
.text
main:
	movq $0,%r13    /*Initialisation du registre contenant la valeur courante*/
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
        cmp $42,%r10    /* On regarde si c'est le signe * */
        je fois
        cmp $10,%r10    /* On regarde si c'est un retour a la ligne*/
        je resultat
        cmp $0,%r13     /*On observer si r13 est vide*/
        jne decaleAGauche
valeur:
        sub $48,%r10 /*On recupere le chiffre en soustrayant le décalage entre le code ascii et le chiffre réel*/
        add %r10,%r13   /*On ajoute*/
        jmp lecture

decaleAGauche:
        mov %r13, %rax  /*On prepare a multiplier*/
        mov $10,%rbx    /* On va multiplier par 10*/
        imul %rbx       /*On multiplie*/
        movq %rax,%r13  /*On modifie r13*/
        jmp valeur
espace:
        push %r13       /*ajoute le nombre courant dans la pile*/
        mov $0,%r13     /*reinitialise r13*/
        inc %r12        /*incrémente le compteur d'operande de 1*/
        movb (%r9),%r10b/*regarde le caractere suivant*/
        cmp $10,%r10    /*Compare le caractere suivant avec l'espace*/
        je resultat     /*Si c'est un espace imprime le resultat car fin de chaine*/
        jmp lecture     /*sinon continue la lecture*/

plus:
        cmp $2,%r12     /*Regarde si le nombre d'opérande est supérieur à 2*/
        jl errorQuit    /*Si mauvais nombre d'opérande imprime ErrorQuit*/
        pop %rsi        /* On tire le premier parametre de la pile*/
        pop %rdi        /* On tire le second parametre de la pile*/
        call addition   /*On appelle la fonction addition*/
        push %rax       /* On ajoute le résultat a la pile*/
        dec %r12        /* la pile a donc perdu un operande */
        movb (%r9),%r10b /* regarde le caractere suivant */
        cmp $43,%r10    /* compare le caractere suivant avec le signe +*/
        je resultat     /* si egale fin de ligne renvoie le resultat*/
        cmp $10,%r10    /* On regarde si c'est un retour a la ligne*/
        je resultat
        inc %r9         /* On pointe le caractère suivant*/
        jmp lecture     /* sinon continue la lecture*/


moins:
        cmp $2,%r12     /*Regarde si le nombre d'opérande est supérieur à 2*/
        jl errorQuit    /*Si mauvais nombre d'opérande imprime ErrorQuit*/
        pop %rsi        /* On tire le premier parametre de la pile*/
        pop %rdi        /* On tire le second parametre de la pile*/
        call soustraction       /*On appelle la fonction soustraction*/
        push %rax       /* On ajoute le résultat a la pile*/
        dec %r12        /* Retire l'operande perdu dans le compteur de pile*/
        movb (%r9),%r10b /* regarde le caractere suivant */
        cmp $45,%r10    /* compare le caractere suivant avec le signe -*/
        je resultat     /* si egale fin de ligne renvoie le resultat*/
        cmp $10,%r10    /* On regarde si c'est un retour a la ligne*/
        je resultat
        inc %r9         /* On pointe le caractère suivant*/
        jmp lecture     /* sinon continue la lecture*/

diviser:
        cmp $2,%r12     /* On verifie que le nombre d'operande est suffisant*/
        jl errorQuit    /* Lance le message Erreur et quit le programe*/
        pop %rsi        /* On tire le premier parametre de la pile dividende*/
        pop %rdi        /* On tire le second parametre de la pile le diviseur*/
        call division   /*On appelle la fonction division*/
        push %rax       /* On ajoute le résultat a la pile*/
        dec %r12        /* On ne perd qu'une seul opérande dans la pile*/
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
        pop %rsi        /* On tire le premier parametre de la pile*/
        pop %rdi        /* On tire le second parametre de la pile*/
        call multiplication     /*On appelle la fonction multiplication*/
        push %rax       /* Ajoute le resultat à la pile*/
        dec %r12        /* La pile a perdu une opérande*/
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
resultat:
        cmp $0,%r12     /* Verifie qu'il y a quelque chose dans la pile*/
        je errorQuit    /* Sinon lance le message d'erreur*/
        cmp $1,%r12     /* Verifie que la pile n'a qu'un element*/
        jne errorQuit   /* Sinon lance un message d'erreur*/
        movq $0,%r12    /* Initialise le compteur de chiffre composant le nombre*/
        pop %r11        /*Recupere le resultat*/
        movq %r11,%rdi	/*Prepare l'impression */
	call imprime	/* Imprime*/

exit:
	movq $60, %rax
	xorq %rdi, %rdi
	syscall
