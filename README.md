Groupe AO; Projet oz 2020 par Gauthier Rubbers et Antoine Demblon 
Dans le cadre du cour d'oz, il nous a été demandé de concevoir un programme qui, si on lui donne deux mots en entrée, renvoie une suggestion de 3eme mot.
Notre programme est décomposé en deux fichiers:

-Reader.oz: il contient toutes les fonctions utiles au bon fonctionnement du code. Il est divisé en trois sous parties: File handeling, Line processing et Dictionary.

  -Dictionary: partie du code qui contient la classe Dictio2, c'est là que les données brutes sont stockées avant d'être filtrées.
  -File handeling: contient les fonctions liées à l'ouverture des différents fichiers text et à la distribution des fichiers entre les différents Threads. C'est aussi là que sont écrites les fonctions qui lancent les Threads.
  -Line processing: contient les fonctions liées à la découpe des lignes des tweets en mots exploitables par la classe Dictio2, 
                    ainsi que l'implémentation de l'objet actif qui va être utilisé sur Dictio2 pour que celui-ci soit utilisable sans problème en multithreading.

-Main.oz: il contient le code de l'interface, ainsi que quelques fonctions liées aux Thread et non définie dans file handeling.

