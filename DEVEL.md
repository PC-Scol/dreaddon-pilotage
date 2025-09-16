# Développement

Le développement se fait sur la branche develop. Cela permet aussi le cas
échéant de livrer "en test" des modifications avant la distribution générale

Il ne faut fusionner les modifications dans la branche master que quand elle
sont prêtes pour la diffusion à tous

Voici une description du workflow pour la livraison des fonctionnalités.
(les commandes listées sont pour utilisation dans un terminal. si vous utilisez
un éditeur moderne, vous pouvez adapter les instructions pour utiliser les
menus de l'éditeur)
~~~
# avant de travailler, il faut récupérer les modifications distantes
git pull

# toujours faire les modifications sur la branche develop
# la commande suivante s'assure que la branche courante est develop
git checkout develop

# puis faire les modifications
#...

# commit les modifications
git commit -am "description des modifications"

# pousser vers le dépôt github
git push
~~~

Les instructions ci-dessus ne mettent à jour que la branche develop, et
nécessitent que la configuration des addons soit de la forme
~~~
ADDON_URLS="
PC-Scol/dreaddon-pilotage.git#develop
"
~~~
Cela permet de tester en condition réelles pour certaines modifications
importantes

En temps normal, pour des modifications mineures, vous pouvez basculer
directement sur la branche master
~~~
# on part du principe que la branche develop a été mise à jour précédemment

# basculer sur la branche master
git checkout master

# fusionner les modifications de la branche develop
git merge develop --no-ff -m "description de la livraison"

# rebasculer sur la branche develop
git checkout develop

# pousser toutes les modifications
git push --all
~~~

-*- coding: utf-8 mode: markdown -*- vim:sw=4:sts=4:et:ai:si:sta:fenc=utf-8:noeol:binary