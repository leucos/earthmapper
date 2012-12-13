EarthMapper
===========

Ce logiciel permet d'interfacer GoogleEarth aux portails cartographiques.
En lui-même, earthmapper ne fait rien : il est nécessaire d'ajouter le module 
correspondant au(x) portail(s) géographique(s) voulu(s) dans le répertoire 
`modules/`

# Installation

- Installez Ruby 1.9.3+ (pour Windows : http://rubyinstaller.org/)
- Décompressez l'archive dans un répertoire
- Copiez les modules voulus dans le répertoire `modules/` et si nécessaire 
  configurez le selon les instructions fournies dans sa documentation
- Renommez le fichier `config/settings.rb.sample` en `config/settings.rb` et 
  modifiez si nécessaire (en ajoutant les modules dans backend par exemple)
- Exécutez `rake` (ou lancer `earthmapper.bat` sous windows).
- Ajoutez un lien réseau dans GoogleEarth, en utilisant 'http://localhost:7000'
  comme adresse

