EarthMapper
===========

[Home][3]

Ce logiciel permet d'interfacer GoogleEarth aux portails cartographiques.

## Choisir une version

La branche standalone/pure est destinée aux non-developpers. Ses performances 
sont plutôt faibles et cette branche n'est plus vraiment maintenue, mais cette 
version est facile à installer avec les instruction ci-dessous.

## Installation

- Installez Ruby 1.9.3+ (pour Windows, utilisez [RubyInstaller][1])
- Téléchargez [l'archive][6] et décompressez la dans un répertoire
- Exécutez `rake` (si vous êtes sous windows, vous pouvez ouvrir le répertoire
 dans l'explorateur de fichiers et cliquer sur `earthmapper`).

A ce stade, c'est installé, mais il reste à configurer les portails.

Note : EarthMapper _devrait_ marcher sous Ruby 1.8.7, mais bien plus lentement.

### Portail France

#### Installation

- Demandez une clef d'API sur le [site développeur de l'IGN][2]
(s'inscrire, puis créer un contrat, type de clef : Web)
- Naviguez sur [http://localhost:7000/france/index][5] et entrez la clef, puis 
cliquer sur "Save"
- Naviguez [http://localhost:7000/][4] and entrez le Referrer
- Cliquez sur "Network Link" en haut à droite, dans la barre de navigation.
- Normalement, Google Earth devrait s'ouvrir; dans le cas contraire, 
enregistrez le fichier KML produit et ouvrez le dans GoogleEarth.

#### Note

Pour la partie france, le contrat IGN impose que vous vidiez le cache après
chaque session. Le cache se situe dans ~/.earthmapper/cache/france/
(~ étant votre répertoire personnel). Vous pouvez vérifier l'endroit dans les 
paramètes accessibles sur la [page de configuration][4].

## Licence

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>
    
  [1]: http://rubyinstaller.org/
  [2]: http://api.ign.fr/moncompte/login
  [3]: https://github.com/leucos/earthmapper/
  [4]: http://localhost:7000/
  [5]: http://localhost:7000/france/index
  [6]: https://github.com/leucos/earthmapper/archive/master.zip