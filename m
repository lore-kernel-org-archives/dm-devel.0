From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: release 0.4.4 ?
Date: Wed, 20 Apr 2005 22:12:49 +0200
Message-ID: <20050420201249.GS29071@marowsky-bree.de>
References: <1113731446.24817.4.camel@zezette>
	<1113953571.24817.97.camel@zezette>
	<20050420133116.GW29071@marowsky-bree.de>
	<1114006824.24817.108.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1114006824.24817.108.camel@zezette>
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

On 2005-04-20T16:20:23, christophe varoqui <christophe.varoqui@free.fr> w=
rote:

> I guess I'll setup the OSDL environment now, for testing and debugging.
> Hope to be able to diagnose in a few hours.

Something else is strange.

This is what /sbin/multipath creates:

0 267249280 multipath 0 1 emc 2 1 round-robin 0 2 1 66:208 1000 8:240 100=
0 round-robin 0 2 1 65:224 1000 8:0 1000
action preset to 0
action set to 4
create: 3600601607cf30e00164589a37a31d911
[size=3D127 GB][features=3D"0"][hwhandler=3D"1 emc"]
\_ round-robin 0 [first]
  \_ 1:0:1:0 sdat 66:208  [ready ]
  \_ 0:0:1:0 sdp  8:240   [ready ]
\_ round-robin 0=20
  \_ 1:0:0:0 sdae 65:224  [ready ]
  \_ 0:0:0:0 sda  8:0     [ready ]

multipathd however:
...
Apr 20 22:09:11 chip multipathd: getprio =3D /sbin/pp_emc /dev/%n (contro=
ler setting)
Apr 20 22:09:11 chip multipathd: error calling out /sbin/pp_emc /dev/sdp

Resulting in a flat map:
3600601607cf30e0070af8bb37a31d911
[size=3D133 GB][features=3D"0"][hwhandler=3D"1 emc"]
\_ round-robin 0 [active][first]
  \_ 0:0:1:12 sdab 65:176  [ready ][active]
  \_ 1:0:0:12 sdaq 66:160  [ready ][active]
  \_ 1:0:1:12 sdbf 67:144  [ready ][active]
  \_ 0:0:0:12 sdm  8:192   [ready ][active]

Which is broken and actually causes the system to misbehave quite
spectacularly.

What is multipathd doing differently from multipath? The two parts being
distinct in behaviour is really one of the worst design decisions in the
entire setup, in my not so humble opinion.

Second, if a callout _fails_, it ought to refuse to create the map IMHO,
rather than risk creating a broken one.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business
