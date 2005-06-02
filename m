From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: latest multipath-tools from git breaks EMC CX
Date: Thu, 02 Jun 2005 23:42:45 +0200
Message-ID: <1117748565.15294.106.camel@zezette>
References: <20050602204630.GK22633@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050602204630.GK22633@marowsky-bree.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Most certainly the 8af5a2b1b5e4d3a457f5bb477214356385087eae commit is
the culprit : I did a bit of spliting in path discovery, and introduced
a new fn to get the sysfs bus that I use as a switch to choose a
discovery template.

Reading your output, I would say the bus fetching went wrong.

Well, revert it or debug it :/

Strange it didn't blew on me ...

On jeu, 2005-06-02 at 22:46 +0200, Lars Marowsky-Bree wrote:
> More specifically, it fails to detect the vendor correctly, and uses th=
e
> most basic internal defaults:
>=20
> ...
> =3D=3D=3D=3D=3D path sdz =3D=3D=3D=3D=3D
> bus =3D 0
> dev_t =3D 65:144
> size =3D 280278656
> path checker =3D readsector0 (internal default)
> #
> # all paths :
> #
> #:#:#:# sdaa 65:160  []
> #:#:#:# sdab 65:176  []
> #:#:#:# sdac 65:192  []
> #:#:#:# sdad 65:208  []
> #:#:#:# sdae 65:224  []
> #:#:#:# sdaf 65:240  []
> #:#:#:# sdag 66:0    []
> #:#:#:# sdah 66:16   []
> #:#:#:# sdai 66:32   []
> #:#:#:# sdaj 66:48   []
>=20
> ...
> params =3D 0 0 4 2 round-robin 0 1 1 65:240 1000 round-robin 0 1 1 66:2=
24 1000 round-robin 0 1 1 8:16 1000 round-robin 0 1 1 65
> :0 1000=20
> status =3D 1 0 0 4 2 E 0 1 0 65:240 F 1 A 0 1 0 66:224 A 0 E 0 1 0 8:16=
 F 1 E 0 1 0 65:0 A 0=20
> 3600601607cf30e00174589a37a31d911
> [size=3D127 GB][features=3D"0"][hwhandler=3D"0"]
> \_ round-robin 0 [enabled]
>   \_ #:#:#:# sdaf 65:240  [failed]
> \_ round-robin 0 [active][best]
>   \_ #:#:#:# sdau 66:224  [active]
> \_ round-robin 0 [enabled]
>   \_ #:#:#:# sdb  8:16    [failed]
> \_ round-robin 0 [enabled]
>   \_ #:#:#:# sdq  65:0    [active]
>=20
> ...
>=20
> Just what the heck is going on there? ;-)
>=20
> I don't get any more output than that, sorry.
>=20
>=20
> Sincerely,
>     Lars Marowsky-Br=C3=A9e <lmb@suse.de>
>=20
--=20
christophe varoqui <christophe.varoqui@free.fr>
