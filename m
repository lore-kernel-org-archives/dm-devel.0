From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: Follow-up on your AIC-79xx Linux Patch...
Date: Mon, 15 May 2006 12:25:56 -0700
Message-ID: <4468D5C4.4050303@us.ibm.com>
References: <44651D75.8060209@mat.puc.cl>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1862654488=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <44651D75.8060209@mat.puc.cl>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: =?ISO-8859-1?Q?=22Jos=E9_Miguel_Morales_F=2E=22?= <jmmf@mat.puc.cl>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--===============1862654488==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigE23EC14E8180E43767AF29AC"

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE23EC14E8180E43767AF29AC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Actually, there are two ways that I know of to deal with this.  I'm
assuming that you're using Adaptec HostRAID on that 7901 controller:

1) Deactivate HostRAID.  Set up a small /boot at the beginning of sda,
make a md-based RAID0 out of the rest of the two drives for /, and
(generally speaking) things should just work.

2) md doesn't know how to interpret HostRAID arrays correctly--what you
want is a program called dmraid because it _does_ know how to interpret
HostRAID arrays and set up the device-mapper driver correctly.  You'll
need to get the latest copy (1.0.0rc10) from Heinz Mauelshagen
(http://people.redhat.com/~heinzm/sw/dmraid/), build it, and then modify
your initrd to include /sbin/dmraid and call "dmraid -ay" prior to
mounting the root filesystem.

Neither approach requires the attach_HostRAID patch.  Incidentally, the
a320raid driver is a binary module from Adaptec.  You're not losing much
by using an open-source solution, because a320raid, md and dmraid are
all software RAID drivers.

--D

Jos=E9 Miguel Morales F. wrote:
> Hello Mr. Darrick. My name is Jos=E9 Miguel Morales, System Manager at
> Mining Center, P. Catholic University of Chile.
>=20
>    I'm writing to you (in hope this IS your right address) about a
> thread you started on December 1st, 2005, at ussg.iu.edu
>=20
>    Is about your "rejected" patch for "aic79xx_osm_pci.c" under kernel
> 2.6.14.
>=20
>    I have a couple of Dell Precision 670n, with nice AIC-7901 on-board =
+
> 2 73 GiB. SCSI-3 10.000 RPM H.D.s, built as RAID-0 for QUITE A GOOD
> speed...
>=20
>    Well, of course I had trouble installing Linux on that configuration=
=2E
> The driver ("aic79xx_osm_pci.c" of kernel 2.6.15, IDENTICAL to the
> 2.6.14 one) just recognized my two disks as /dev/sda & /dev/sdb, and NO=

> RAID support.
>=20
>    With your patch (and using "attach_HostRAID=3D1"), I finally made a
> /dev/md/0 visible, then wrote a SIMPLE /etc/raidtab (included below) an=
d
> started it with "raid0run /dev/md/0".
>=20
>    That way "fdisk /dev/md/0" was able to see the partitions, and WITH
> apropriate device names for each partition, but such devices don't exis=
t
> under /dev/md/...
>=20
>    Looking at /var/log/messages I found raidtools complaining about
> "errors with the superblock of the array", and I was unable to perform
> further actions without risking to destroy the array. (Which already ha=
s
> 2 partitions with a complete WinXP installation.)
>=20
>    I noticed that you talk about an "a320raid" drier module, but I can'=
t
> find any "direct" reference to it. Could it be possible to you to
> enlighten me a bit more on this issue, please?
>=20
>    Sorry for bugging you, but as I read the whole thread I know I'll ge=
t
> no "official" help from Linux people, and I don't want to give up the
> array...
>=20
>     Thank you very much in advance...    Jos=E9 Miguel Morales F.
>=20
> P.D.: Here is my "simple" /etc/raidtab:
>=20
>  - + - + - + -   Cut Here    - + - + - + -   Cut Here    - + - + - + -
>=20
> raiddev /dev/md/0
>     raid-level        0
>     nr-raid-disks        2
>     persistent-superblock    0
>     chunk-size        16
>=20
>     device            /dev/sda
>     raid-disk        0
>     device                  /dev/sdb
>     raid-disk        1
>=20
>  - + - + - + -   Cut Here    - + - + - + -   Cut Here    - + - + - + -
>=20
>    ... I really don't know, but the "persistent-superblock" statement
> always gives me problems, no matter how do I use (or don't use) it...  =
=20
> Regards !!!
>=20


--------------enigE23EC14E8180E43767AF29AC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQFEaNXEa6vRYYgWQuURAgHQAKCl8Nqk9crQOxf2sd+aB5Prvb6k8ACgplzo
LBcOizYtBBpTkxgXo06wh78=
=OuNj
-----END PGP SIGNATURE-----

--------------enigE23EC14E8180E43767AF29AC--


--===============1862654488==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1862654488==--
