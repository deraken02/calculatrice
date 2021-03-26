#Author:
========
	
	* Delacroix Louis

#Explication:
=============

Ce projet s'inscrit dans le cadre de mes études. Il a pour but de nous faire découvrir la programmation en assembleur sur Intel 64.
La calculatrice est suffixée donc l'opérateur est à la fin de l'opération. Et elle ne fait que des calculs sur des nombres entiers.
Les opérations possibles sont la division, la multiplication, l'addition et la soustraction.
#Versions:
==========

##Version 1:
============

Cette version est simple, le programme ne comporte pas de fonction seulement des parties interconnectées

##Version 2:
============

Cette version est plus complexe, c'est quasiment le même programme sauf qu'à la place de parties inteconnectées on fait appelle à des fonctions assembleurs

##Version 3:
============

Dans cette version, on mélange un programme asssembleur et C, les fonctions sont écrites en C et les programme principale (main) est écrit en assemblrur

#Utilisation :
==============

Chaque version a son propre Makefile il suffit de taper la commande make dans la version voulu puis de taper ./calc

Il ne reste plus qu'à ecrire le calcule.

Exemple:
On veut réaliser l'opération suivante (((1+2)*3)/9)-1
 ~./calc
1 2 + 3 * 9 / 1 -
0
 
