 #!/bin/bash

 #chemin de phpMyAdmin : à modifier
 PATH_PMA="/data/www/phpmyadmin"
 #ne rien modifier sous cette ligne

 #on recupere le numero de la version actuelle dans le README
 LOCAL_VERSION=$(head -4 "$PATH_PMA/README" | tail -1)
 LOCAL_VERSION=${LOCAL_VERSION:8}

 #on recupere le numero de version dispo en ligne
 ONLINE_VERSION=$(wget -o /dev/null -O - http://phpmyadmin.net/home_page/version.php | head -1)

 if [[ $ONLINE_VERSION != $LOCAL_VERSION ]]
 then
 echo "Nouvelle version disponible $ONLINE_VERSION ! (version actuelle : $LOCAL_VERSION)"
 #echo 'Souhaitez-vous mettre a jour ? (O/N)'
 #read REPONSE

 #if [[ $REPONSE == 'O' || $REPONSE == 'o' ]]
 #then
 echo 'Telechargement en cours...'

 #on deplace la version actuelle
 DATE="$(date +"%Y%m%d%S")"
 OLD_VERSION="$PATH_PMA-${DATE}"
 mv $PATH_PMA $OLD_VERSION

 #creation du nouveau dossier
 mkdir $PATH_PMA

 #telechargement de la derniere version
 URL=$(wget -o /dev/null -O - http://phpmyadmin.net/home_page/version.php | head -4 | tail -1)
 wget $URL -o /dev/null --output-document=/tmp/nouvelleversion.tar.gz

 #decompression
 tar -C $PATH_PMA -xf /tmp/nouvelleversion.tar.gz --strip-components 1
 rm /tmp/nouvelleversion.tar.gz

 #copie de la config
 cp "${OLD_VERSION}/config.inc.php" $PATH_PMA

 echo "Mise a jour effectuee avec succes ! Version actuelle : $ONLINE_VERSION"
 #else
 #echo 'Mise a jour annulee'
 #fi

 else echo "Vous avez deja la derniere version : $LOCAL_VERSION"
 fi
