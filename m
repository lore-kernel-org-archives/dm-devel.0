From: Eckebrecht von Pappenheim <evp@heise.de>
Subject: Re: Question about dm-multipath and Sun StorageTek 6140
Date: Wed, 14 Feb 2007 11:14:05 +0100
Message-ID: <AF2D2B62FD3A3EDB492DEDAA@sigh.heise.de>
References: <45CC4540.7020707@informatik.uni-stuttgart.de>
	<744db6db0702112336r4d83ed3eucaa590975e5f0b52@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <744db6db0702112336r4d83ed3eucaa590975e5f0b52@mail.gmail.com>
Content-Disposition: inline
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

Hi Yury,

thanks for Your hints, I had the same problem an figured it out now.

>> - is it true that I need a hardware-specific handler for arrays runnin=
g
>>   with active/passive controllers (like the Sun StorageTek 6140) to
>>   get the the LUN trespassing working?
>=20
> It's true only for non-AVT mode (set host type to Linux to turn AVT mod=
e on)

at least for the 6140 this is not correct. It sets the mode to RDAC for t=
he
Sun-RDAC-Driver ( http://www.sun.com/download/products.xml?id=3D44d12115 =
).

You have to choose 'Solaris (with Veritas DMP or other)' (named SOLAVT in=
 the
CLI) to enable AVT.
=20
>> - did someone get the Sun StorageTek 6140 configured for dm-multipath?
>>   (so that the LUN trespassing works)
>=20
> It should work as it does for other boxes with LSILogic controllers.
>=20
> path_grouping_policy    group_by_prio
> path_checker            tur
> prio_callout            "/sbin/mpath_prio_tpc /dev/%n"

Correct, with this setup and AVT enabled LUN trespassing works as designe=
d:

multipathd> show maps topo
reload: Raid5_for_IMAP-Volume (3600a0b800026851e000014e245bf1906) dm-0
SUN,CSM200_R
[size=3D1.4T][features=3D0][hwhandler=3D0]
\_ round-robin 0 [prio=3D12][active]
 \_ 7:0:2:1 sdah 66:16  [active][ready]
 \_ 6:0:0:1 sdd  8:48   [active][ready]
\_ round-robin 0 [prio=3D2][enabled]
 \_ 6:0:2:1 sdn  8:208  [active][ready]
 \_ 7:0:0:1 sdx  65:112 [active][ready]

and after failure of preferred controller:

multipathd> show maps topo
reload: Raid5_for_IMAP-Volume (3600a0b800026851e000014e245bf1906) dm-0
SUN,CSM200_R
[size=3D1.4T][features=3D0][hwhandler=3D0]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 7:0:2:1 sdah 66:16  [failed][faulty]
 \_ 6:0:0:1 sdd  8:48   [failed][faulty]
\_ round-robin 0 [prio=3D6][active]
 \_ 6:0:2:1 sdn  8:208  [active][ready]=20
 \_ 7:0:0:1 sdx  65:112 [active][ready]=20

Great software!

Regards,
Eckebrecht

--=20
Eckebrecht von Pappenheim, network administration=20
Heise Zeitschriften Verlag GmbH & Co KG
Helstorferstr. 7, D-30625 Hannover, FRG
E-Mail: evp@heise.de  - Tel: +49 511 5352 242  -  Fax: +49 511 5352 479
http://www.heise.de/

Registergericht: Amtsgericht Hannover HRA 26709
=20
Pers=F6nlich haftende Gesellschafterin: =20
Heise Zeitschriften Verlag Gesch=E4ftsf=FChrung GmbH
Registergericht: Amtsgericht Hannover, HRB 60405
Gesch=E4ftsf=FChrer: Ansgar Heise, Steven P. Steinkraus, Dr. Alfons Schr=E4=
der
