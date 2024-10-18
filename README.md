# dreaddon-pilotage

Cet addon crée les schémas suivants:
* `schema_ins_piste` à partir de `mongo_piste_inscription`
* `schema_pilotage` utilisable avec l'univers BO distribué par l'UPHF

Pour utiliser cet addon, rajouter ceci dans la configuration:
~~~sh
ADDON_URLS="
...
PC-Scol/dreaddon-pilotage.git
...
"
~~~

-*- coding: utf-8 mode: markdown -*- vim:sw=4:sts=4:et:ai:si:sta:fenc=utf-8:noeol:binary