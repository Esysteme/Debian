
## global

Tout les nom doivent être en français sans accent

Si il y a la présence de verbe ces derniers doivent être à l'infinitif.


## nom des tables & des champs

Tout au singulier (nom des tables, des champs)
Pas d'accents 
Tout en minuscule séparer pas des souligner (snake_case)


## Nom des champs


Les clefs étrangères doivent commencer par id_ et être suivie par le nom de la table référencé.


Toutes les tables doivent être avoir un champs id autoincrémenté en clef principale.
La vrai clef principale doit être en index unique (si besoin)


les tables de liens entre 2 tables (n to n) doivent être nommer avec le nom des 2 tables séparer par 2 souligner, dans l'ordre alphabétique.


exemple :

* entrepot
* produit

la table liant les 2 pour le stock sera :

entrepot__produit


## nomenclature des noms d'index et des clefs étrangère


### les index


le nom doit commencer par idx_ suivi du nom du champs

Si ce dernier est sur plusieurs champs, il faut les séparer par 2 sougligner dans l'ordre alphabétique comme pour les tables en liant 2 autres.


### les clef étrangères


le nom doit commencer par fk_ suivis par le nom de la table puis de 2 souligner et du nom du champs.
Si c'est sur 2 champs ou plus les triers par ordre alphabétique et les séparer par 2 souligner.

