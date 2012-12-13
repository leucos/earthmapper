EarthMapper
===========

[Home][3]

Ce logiciel permet d'interfacer GoogleEarth aux portails cartographiques.
En lui-même, earthmapper ne fait rien : il est nécessaire d'ajouter le module 
correspondant au(x) portail(s) géographique(s) voulu(s) dans le répertoire 
`modules/`

## Installation

- Installez Ruby 1.9.3+ (pour Windows, utilisez [RubyInstaller][1])
- Décompressez l'archive dans un répertoire
- Exécutez `rake` (ou lancer `earthmapper.bat` sous windows).

Ca devrait marcher sous Ruby 1.8.7, mais bien plus lentement.

C'est installé, mais ça ne fait rien tant que les backends (portails disons) ne
sont pas configurés.

### Portail France

#### Installation

- Demandez une clef d'API sur le [site développeur de l'IGN][2]
(s'inscrire, puis créer un contrat, type de clef : Web)
- Naviguez sur "http://localhost:7000/france/index" et entrez la clef, puis 
cliquer sur "Save"
- Cliquez sur "Network Link" en haut à droite, dans la barre de navigation.
- A ce stade, Google Earth devrait s'ouvrir. 

#### Note

Pour la partie france, le contrat IGN impose que vous vidiez le cache après
chaque session. Le cache se situe dans ~/.earthmapper/cache/france/
(~ étant votre répertoire personnel).

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
