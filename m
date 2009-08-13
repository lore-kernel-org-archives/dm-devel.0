From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: rdac path failure - Sun 6140
Date: Thu, 13 Aug 2009 13:42:54 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF474AEB7FC@cosmail01.lsi.com>
References: <f7500f4e0908131150r54b21a0dr9cb7d4a8456e69e8@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <f7500f4e0908131150r54b21a0dr9cb7d4a8456e69e8@mail.gmail.com>
Content-Language: en-US
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

Do you have /var/log/messages file for this problem?

Thanks
Babu Moger=20

> -----Original Message-----
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] =
On
> Behalf Of Stewart Smith
> Sent: Thursday, August 13, 2009 1:51 PM
> To: dm-devel@redhat.com
> Subject: [dm-devel] rdac path failure - Sun 6140
>=20
> Hello All,
>=20
> I am seeing many of these messages when my Sun 6140 array is under heav=
y
> I/O
> device-mapper: multipath: Failing path 8:208.
> device-mapper: multipath: Failing path 8:208.
> device-mapper: multipath: Failing path 8:208.
> device-mapper: multipath: Failing path 8:208.
> device-mapper: multipath: Failing path 8:208.
>=20
>=20
> I am running a Fedora 10 server, with two fiber connections to two
> different switches.=A0=A0Both=A0controllers on the 6140 have one connec=
tion
> to each switch as well. =A0The end result is that I see four paths to
> each LUN.
>=20
> When the volume is mounted and under significant load I see the
> messages above every few seconds.  They seem to appear every
> "no_path_retry" seconds.
>=20
> The 6140 controller firmware is up to date at version 07.50.08.10 and
> I have installed the latest firmware for my Emulex LPe11002 cards.  I
> have reproduced the problem using both Cisco MDS and Brocade fiber
> channel switches as well.
>=20
> Using CAM, I have set the initiator Host Type to "Linux" at the
> moment.  I have tried other options as well without success.
>=20
> I have NOT installed the RDAC drivers from either Sun or LSI -
> primarily because they do not seem to build on my Fedora 10 kernel.
>=20
> Any ideas would be greatly appreciated!!!
>=20
> configs and debugging multipathd output is below.
>=20
>=20
>=20
>=20
>=20
> Kernel: 2.6.27.24-170.2.68.fc10.x86_64
>=20
> # multipath -lll
> vol1 (3600a0b800048335200001e5d48b68a9b) dm-1 SUN,CSM200_R
> [size=3D12T][features=3D1 queue_if_no_path][hwhandler=3D1 rdac][rw]
> \_ round-robin 0 [prio=3D6][active]
> =A0\_ 5:0:1:2 sdj 8:144 [active][ready]
> =A0\_ 2:0:1:2 sdn 8:208 [active][ready]
> \_ round-robin 0 [prio=3D0][enabled]
> =A0\_ 2:0:0:2 sdb 8:16 =A0[active][ghost]
> =A0\_ 5:0:0:2 sdd 8:48 =A0[active][ghost]
>=20
>=20
> # cat /etc/multipath.conf
>=20
> blacklist {
>         devnode "^sd[a-z][[0-9]*]"
>         devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
>         devnode "^hd[a-z][0-9]*"
>         devnode "^cciss!c[0-9]d[0-9](p[0-9]*)*"
> }
>=20
> defaults {
>         udev_dir                /dev
>         polling_interval        10
>         selector                "round-robin 0"
>         path_grouping_policy    multibus
>         getuid_callout          "/sbin/scsi_id --whitelisted /dev/%n"
>         prio                    alua
>         path_checker            readsector0
>         rr_min_io               100
>         max_fds                 8192
>         rr_weight               priorities
>         failback                immediate
>         no_path_retry           fail
>         user_friendly_names     yes
> }
> devices {
>         device {
>                 vendor                  "SUN"
>                 product                 "CSM200_R"
>                 product_blacklist       "Universal Xport"
>                 getuid_callout          "/sbin/scsi_id --whitelisted
> /dev/%n"
>                 features                "0"
>                 hardware_handler        "1 rdac"
>                 path_selector           "round-robin 0"
>                 path_grouping_policy    group_by_prio
>                 failback                immediate
>                 rr_weight               uniform
>                 no_path_retry           queue
>                 rr_min_io               1000
>                 path_checker            rdac
>                 prio                    rdac
>         }
> }
>=20
> multipaths {
>         multipath {
>                 wwid                    3600a0b800048335200001e5d48b68a=
9b
>                 alias                   vol1
>                 rr_weight               priorities
>                 no_path_retry           5
>                 rr_min_io               100
>         }
> }
>=20
>=20
>=20
> # multipathd -d v3
>=20
>=20
> Aug 13 14:48:53 | sdb: ownership set to vol1
> Aug 13 14:48:53 | sdb: not found in pathvec
> Aug 13 14:48:53 | sdb: mask =3D 0xc
> Aug 13 14:48:53 | sdb: path checker =3D rdac (controller setting)
> Aug 13 14:48:53 | sdb: state =3D 4
> Aug 13 14:48:53 | sdb: rdac prio =3D 0
> Aug 13 14:48:53 | sdd: ownership set to vol1
> Aug 13 14:48:53 | sdd: not found in pathvec
> Aug 13 14:48:53 | sdd: mask =3D 0xc
> Aug 13 14:48:53 | sdd: path checker =3D rdac (controller setting)
> Aug 13 14:48:53 | sdd: state =3D 4
> Aug 13 14:48:53 | sdd: rdac prio =3D 0
> Aug 13 14:48:53 | sdj: ownership set to vol1
> Aug 13 14:48:53 | sdj: not found in pathvec
> Aug 13 14:48:53 | sdj: mask =3D 0xc
> Aug 13 14:48:53 | sdj: path checker =3D rdac (controller setting)
> Aug 13 14:48:53 | sdj: state =3D 2
> Aug 13 14:48:53 | sdj: rdac prio =3D 3
> Aug 13 14:48:53 | sdn: ownership set to vol1
> Aug 13 14:48:53 | sdn: not found in pathvec
> Aug 13 14:48:53 | sdn: mask =3D 0xc
> Aug 13 14:48:53 | sdn: path checker =3D rdac (controller setting)
> Aug 13 14:48:53 | sdn: state =3D 2
> Aug 13 14:48:53 | sdn: rdac prio =3D 3
> Aug 13 14:48:53 | vol1: pgfailback =3D -2 (controller setting)
> Aug 13 14:48:53 | vol1: pgpolicy =3D group_by_prio (controller setting)
> Aug 13 14:48:53 | vol1: selector =3D round-robin 0 (controller setting)
> Aug 13 14:48:53 | vol1: features =3D 0 (controller setting)
> Aug 13 14:48:53 | vol1: hwhandler =3D 1 rdac (controller setting)
> Aug 13 14:48:53 | vol1: rr_weight =3D 2 (LUN setting)
> Aug 13 14:48:53 | vol1: minio =3D 100 (LUN setting)
> Aug 13 14:48:53 | vol1: no_path_retry =3D 5 (multipath setting)
> Aug 13 14:48:53 | pg_timeout =3D NONE (internal default)
> Aug 13 14:48:53 | vol1: set ACT_CREATE (map does not exist)
> create: vol1 (3600a0b800048335200001e5d48b68a9b) n/a SUN,CSM200_R
> [size=3D12T][features=3D0][hwhandler=3D1 rdac][n/a]
> \_ round-robin 0 [prio=3D6][undef]
>  \_ 5:0:1:2 sdj 8:144 [undef][ready]
>  \_ 2:0:1:2 sdn 8:208 [undef][ready]
> \_ round-robin 0 [prio=3D0][undef]
>  \_ 2:0:0:2 sdb 8:16 [undef][ghost]
>  \_ 5:0:0:2 sdd 8:48 [undef][ghost]
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
