# RRFRaptor
Le RRFRaptor analyse le trafic sur le réseau [RRF](https://f5nlg.wordpress.com/2015/12/28/nouveau-reseau-french-repeater-network/) (Réseau des Répéteurs Francophones) et gère automatiquement les QSY de votre Spotnik afin de lui faire rejoindre automatiquement le salon sur lequel il y a de l'activité.  Attention, __il n'est pas recommandé de l'installer sur un relais__. Il est surtout adapté à un usage personnel. 

# Principe de fonctionnement
Une fois le RRFRaptor lancé, tant qu'il y a de l'activité sur le salon sur lequel vous êtes, rien ne se passe. Le RRFRaptor reste en sommeil.

Si l'activité retombe, au bout d'une certaine temporisation paramétrable, le RRFRaptor va s'activer et commencer à analyser le trafic sur l'ensemble du réseau RRF à la recherche de QSO sur les autres salons.

Si le trafic reprend entre temps sur le salon sur lequel vous étiez, évidemment, la temporisation redémarre à zéro et le RRFRaptor retombe en sommeil.

Par contre, si le trafic ne reprend pas et que le RRFRaptor détecte de l'activité sur un autre salon, alors il va automatiquement faire basculer votre Spotnik sur celui ci.

# Installation

## Installation du RRFRaptor

Commencez par ouvrir une connexion SSH sur votre Spotnik.

### Etape 1 - Récupération du code

Depuis votre connexion SSH, lancez les commandes suivantes :

`cd /opt`

Puis, 

`git clone https://github.com/armel/RRFRaptor.git`

### Etape 2 - Installation des dépendances

Si nécessaire, il faut également procéder à l'installation de quelques paquets complémentaires. Rassurez-vous, ce sera rapide. Toujours depuis votre connexion SSH, lancez les commandes suivantes :

`sudo apt-get install python-pip`

`sudo pip install requests`

### Etape 3 - Ajout des codes DTMF

Il est possible d'activer et de désactiver le RRFRaptor par un simple code DTMF.

Si vous n'êtes pas familier avec les fichiers de paramétrages de __SvxLink__, il vous suffit de copier le fichier `Logic.tcl` que j'ai déjà modifié pour vous. Donc, depuis votre connexion SSH, lancer les commandes suivantes :

`mv /usr/share/svxlink/events.d/local/Logic.tcl /usr/share/svxlink/events.d/local/Logic.tcl.bak`


`cp /opt/RRFRaptor/Logic.tcl /usr/share/svxlink/events.d/local/Logic.tcl`

La première va faire une sauvegarde de votre fichier `Logic.tcl` (renommé en `Logic.tcl.bak` au cas ou). Et la seconde va copier le fichier `Logic.tcl` modifié afin de prendre en charge le RRFRaptor. 

Le RRFRaptor pourra désormais être activé ou désactivé en envoyant le code DTMF __200__.

### Etape 4 - Redémarrage de SvxLink

Enfin, pour finir, redémarrez __SvxLink__ à l'aide de la commande suivante :

`/etc/spotnik/restart`

Et voilà, c'est tout ;) Vous êtes pret à utiliser le RRFRaptor !

## Lancement du RRFRaptor

Le plus simple est de lancer le RRFRaptor en CLI (ligne de commande). Toujours depuis une connexion SSH, 

- pour activer le RRFRaptor : `/opt/RRFRaptor/RRFRaptor.sh start`
- pour désactiver le RRFRaptor : `/opt/RRFRaptor/RRFRaptor.sh stop`

Sinon, vous pouvez également activer ou désactiver le RRFRaptor à l'aide du DTMF __200__.

Dans tous les cas, une annonce vocale vous informera de l'activation ou de la désactivation du RRFRaptor.

Une fois activé, en l'absence d'activité durant 1 minute (par défaut), le RRFRaptor va commencer à analyser le trafic sur l'ensemble du réseau RRF à la recherche de QSO sur les autres salons et gérer lui même les QSY.
 

# Paramétrages fins

## Changer les paramétrages par défaut

Vous pouvez évidemment éditer le fichier `/opt/RRFRaptor/RRFRaptor.sh` afin de changer la durée de la temporisation par défaut (option `--sleep`). 

>L'option `--debug` présente juste un intérêt en phase de développement. Inutile de l'activer. 

## Ne pas prendre en compte certains salons

Vous pouvez éditer le fichier `/opt/RRFRaptor/settings.py` et modifier la variable `valid_room` (ligne 20) avec la liste des salons que vous voulez surveiller.

## Mettre à jour la version du RRFRaptor

Depuis votre connexion SSH, lancez les commandes suivantes :

`cd /opt/RRFRaptor`

Puis, 

`git pull`


## Modifier le code DTMF par défaut

Si vous le souhaitez, vous pouvez modifier le code DTMF par défaut et l'adapter suivant vos besoins. Pour se faire, éditer le fichier `/usr/share/svxlink/events.d/local/Logic.tcl` à l'aide de votre éditeur préféré. Recherchez les blocs concernant les codes DTMF (vers les lignes 600...). Ajoutez et modifiez les 3 nouveaux blocs ci dessous en les adaptant à votre convenance :

```
# 200 Raptor start and stop
  if {$cmd == "200"} {
    puts "Executing external command"
    exec nohup /opt/RRFRaptor/RRFRaptor.sh &
    return 1
  }

# 201 Raptor start sound
  if {$cmd == "201"} {
    puts "Executing external command"
    playSilence 1500
    playFile /opt/RRFRaptor/sounds/active.wav
    return 1
  }

# 202 Raptor stop sound
  if {$cmd == "202"} {
    puts "Executing external command"
    playSilence 1500
    playFile /opt/RRFRaptor/sounds/desactive.wav
    return 1
  }
```

>Attention, si vous modifiez également les codes __201__ et __202__ qui servent aux annonces vocales, vous devrez les modifiez également dans le script `/opt/RRFRaptor/RRFRaptor.sh`. Ce changement n'est pas recommandé.

# That's all

Bon trafic à tous, 88 & 73 de Armel F4HWN !