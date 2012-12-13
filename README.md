EarthMapper
===========

This software interfaces GoogleEarth with some geographic portals.

## Installation

- Instal Ruby 1.9.3+[^1] (for Windows, use [RubyInstaller][1])
- Uncompress earthmapper in a directory (or better : use git)
- Execute `rake` (or double click `earthmapper.bat` under windows).

Its running but it does nothin until backends are configured.

### Backend for France

#### Installation 

- Ask an API on the [developper site at IGN][2]
(sign-up, then create a contract with key type : Web)
- Navigate "http://localhost:7000/france/index" and enter the key, click "Save"
- Click on "Network Link" (upper right in navbar).
- GoogleEarth should open and you should have fun

#### Note

For the french portal, you are suposed to cleanr cache after every sessions.
The cache is located in ~/.earthmapper/cache/france/

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

    
  [^1]: Marche aussi sur 1.8.7, mais plus lentement...
  [1]: http://rubyinstaller.org/
  [2]: http://api.ign.fr/moncompte/login