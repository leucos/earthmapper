EarthMapper
===========

[Home][3]

This software interfaces GoogleEarth with some geographic portals.

## Choosing a version

The standalone/pure branch is targetted to non-developpers. Performance is
pretty low and this branch is manily unmaintained, but it should be easy to 
install with the instructions below

## Installation

- Install Ruby 1.9.3+ (for Windows, use [RubyInstaller][1])
- Uncompress earthmapper in a directory (or better : use git)
- Execute `rake` (or double click `earthmapper.bat` under windows).

At this point its running but it does nothing until backends are configured.

Note : It runs under Ruby 1.8.7, but it's significantly slower.

### Backend for France

#### Installation 

- Ask an API key on the [developper site at IGN][2]
(sign-up, then create a contract with key type : Web)
- Navigate [5][http://localhost:7000/france/index] and enter the key, click "Save"
- Navigate [4][http://localhost:7000/] and enter the requierd Referrer
- Click on "Network Link" (upper right in navbar).
- GoogleEarth should open and you should have fun

#### Note

For the french portal, you are suposed to clean the cache after every session.

The cache is located in ~/.earthmapper/cache/france/ (or wherever you set it to 
be in the [5][configuration page]), '~'' being your home directory.

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