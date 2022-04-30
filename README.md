# clightning4j-node

![Docker Pulls](https://img.shields.io/docker/pulls/vincenzopalazzo/clightning4j-node?style=flat-square)

## Table of Content

- Introductions
- How to use
- Support
- License

## Introductions

A c-lightning node that ran on clightning4j to enable a easy access to c-lightning node.

This docker image is powered by clightning4j tools, to give an addition method to ran [c-lightning](https://github.com/ElementsProject/lightning)
node with 0 or less configuration process.

The following list contains what the image contains for each version:

- v0.10.0 clightning4j-node
    - [btcli4j](https://github.com/clightning4j/btcli4j): A plugin to support the Rest API with [esplora]() and Bitcoin Core 0.21.0.
    - [lightning-rest](https://github.com/clightning4j/lightning-rest): Enable a experimental Rest API of c-lightning node.
- v0.10.1 clightning4j-node
    - [btcli4j](https://github.com/clightning4j/btcli4j): A plugin to support the Rest API with [esplora]() and Bitcoin Core 0.21.0.
    - [lightning-rest](https://github.com/clightning4j/lightning-rest): Enable a experimental Rest API of c-lightning node.
    - [ln-dashboard](https://github.com/clightning4j/ln-dashboard): Enable a experimental dashboard to see basic information of c-lightning node.

## How to Use

To use the image is possible use the docker or docker compose.

### Docker Compose

- v0.10.0 clightning4j-node
    - [Example: pruning mode](https://github.com/clightning4j/clightning4j-node/blob/main/0.10.0/prune-mode-docker-compose.yml)
    - [Example: Esplora rest](https://github.com/clightning4j/clightning4j-node/blob/main/0.10.0/rest-mode-docker-compose.yml)
- v0.10.1 clightning4j-node
    - [Example: pruning mode](https://github.com/clightning4j/clightning4j-node/blob/main/0.10.1/prune-mode-docker-compose.yml)
    - [Example: Esplora rest](https://github.com/clightning4j/clightning4j-node/blob/main/0.10.1/rest-mode-docker-compose.yml)
    - [Example: Esplora rest with UI dashboard](https://github.com/clightning4j/clightning4j-node/blob/main/0.10.1/ui-rest-mode-docker-compose.yml)


To enable the rest service you can run the following commands

```bash
docker-compose run -T lightningd lightning-cli restserver start
```

### Docker image

TODO

## Support

<div align="center">
  <img src="https://brink.dev/assets/images/brink_logo.png" width="150"/>

  <p>
    <strong>Supported by a Brink grant.</strong>
  </p>
</div>

If you like the architecture developer and want to support it, please considerer to donate with the following system

- [3BQ8qbn8hLdmBKEjt1Hj1Z6SiDsnjJurfU](bitcoin:3BQ8qbn8hLdmBKEjt1Hj1Z6SiDsnjJurfU)
- [liberapay.com/vincenzopalazzo](https://liberapay.com/vincenzopalazzo)
- [Github support](https://github.com/sponsors/vincenzopalazzo)
- [buymeacoffee](https://www.buymeacoffee.com/vincenzopalazzo)

## License

<div align="center">
  <img src="https://opensource.org/files/osi_keyhole_300X300_90ppi_0.png" width="150" height="150"/>
</div>

A c-lightning node that ran on clightning4j to enable a easy access to c-lightning node.

 Copyright (C) 2021 Vincenzo Palazzo vincenzopalazzodev@gmail.com
 
 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 2 of the License.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License along
 with this program; if not, write to the Free Software Foundation, Inc.,
 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
