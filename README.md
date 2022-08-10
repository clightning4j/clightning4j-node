# clightning4j-node

![Docker Pulls](https://img.shields.io/docker/pulls/vincenzopalazzo/clightning4j-node?style=flat-square)

## Table of Content

- Introductions
- How to use
- Support
- License

## Introductions

A c-lightning node that ran on clightning4j to enable a easy access to c-lightning node.

This docker image is powered by clightning4j tools, to give an addition method to ran [core lightning](https://github.com/ElementsProject/lightning)
node with 0 or less configuration process.

The following list contains what the image contains for each version:

The docker image support a couple of plugin with it:

- grpc plugin: Powered by core lightning.
- [btcli4j](https://github.com/clightning4j/btcli4j): core lightning plugin to override Bitcoin backend plugin with esplora by Blockstream and give the possibility to make the running process with bitcoind in pruning mode more solid.
- [lnmetrics](https://github.com/LNOpenMetrics/go-lnmetrics.reporter): core lightning plugin to collect and report of the lightning node metrics.

## How to Use

```bash
docker-compose up
```

### Docker Compose Example

In the `example` directory you can find a couple of example on how to run the docker compose, and after it is up and running you can query the node with the
following command
```bash
docker-compose run -T lightningd lightning-cli --testnet getinfo
```

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

A core lightning node that ran on clightning4j to enable a easy access to lightning node.

 Copyright (C) 2021-2022 Vincenzo Palazzo vincenzopalazzodev@gmail.com

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
