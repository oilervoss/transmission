
[10.5281/zenodo.1050424](https://doi.org/10.5281/zenodo.1050424)

## Intro
This (addtracker) is a bash script to add public trackers to Torrents being downloaded in the hope of getting more peers.

The public trackers are retrieved from a dynamically list ([ngosang](https://github.com/ngosang/trackerslist)). If the dynamic list is offline, it will use a static one.

## Usage

> ```./addtracker```
>
> Show current Torrents

> ```./addtracker $somenumber```
>
> Add public trackers to the Torrent of number *$somenumber*


> ```./addtracker $anyword```
>
> Add public trackers to the all the Torrents found with *$anyword* in the name (case insensitive)

>```./addtracker .```
>
> Add public trackers to all the Torrents found


## More scripts

[Transmission custom scripts](../../tree/transmission) for [Openwrt](http://www.openwrt.org).

[OpenVPN custom scripts](../../tree/nordvpn/) for [NordVPN](https://ref.nordvpn.com/?id=69780735) in OpenWRT


## Tips

> Show only Torrent number and name:
>
> ```transmission-remote -l | sed -n 's/\(^.\{4\}\).\{64\}/\1/p'```

> Show only Torrent number of the first file with the $name:
>
> ```transmission-remote -l | grep -i $name | sed -n 's/ *\([0-9]\+\).*/\1/p'```

> Blocklist
>
> ```http://john.bitsurge.net/public/biglist.p2p.gz```
