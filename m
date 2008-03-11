From: Simone Gotti <simone.gotti@email.it>
Subject: Re: Missing path
Date: Tue, 11 Mar 2008 15:10:42 +0100
Message-ID: <1205244642.3123.31.camel@localhost>
References: <000501c8837f$53f835c0$cf42e3c1@pitagora.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1678036109=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <000501c8837f$53f835c0$cf42e3c1@pitagora.it>
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


--===============1678036109==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-O7fW71y5RUP7i+8u8WB6"


--=-O7fW71y5RUP7i+8u8WB6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, 2008-03-11 at 14:53 +0100, Domenico Viggiani wrote:
> After adding a LUN from a EMC Clariion CX700 to a system with already man=
y
> of these, I noticed that multipath doesn't see a path:
>=20
> 360060160eb241700284f88a159efdc11
> [size=3D450 GB][features=3D"1 queue_if_no_path"][hwhandler=3D"1 emc"]
> \_ round-robin 0 [prio=3D1][enabled]
>  \_ 1:0:0:70  sdbo 68:32  [active][ready]
> \_ round-robin 0 [enabled]
>  \_ 0:0:3:70  sdbn 68:16  [active][ready]
>  \_ 1:0:1:70  sdbp 68:48  [active][ready]
>=20
> >From SCSI layer, it is OK:
>=20
> Host: scsi0 Channel: 00 Id: 02 Lun: 70
>   Vendor: DGC      Model: RAID 5           Rev: 0219
>   Type:   Direct-Access                    ANSI SCSI revision: 04
> Host: scsi0 Channel: 00 Id: 03 Lun: 70
>   Vendor: DGC      Model: RAID 5           Rev: 0219
>   Type:   Direct-Access                    ANSI SCSI revision: 04
> Host: scsi1 Channel: 00 Id: 00 Lun: 70
>   Vendor: DGC      Model: RAID 5           Rev: 0219
>   Type:   Direct-Access                    ANSI SCSI revision: 04
> Host: scsi1 Channel: 00 Id: 01 Lun: 70
>   Vendor: DGC      Model: RAID 5           Rev: 0219
>   Type:   Direct-Access                    ANSI SCSI revision: 04
>=20
> but one device is missing under /dev:
>=20
> brw-rw----  1 root disk 68,  16 Mar 11 14:44 /dev/sdbn
> brw-rw----  1 root disk 68,  32 Mar 11 14:45 /dev/sdbo
> brw-rw----  1 root disk 68,  48 Mar 11 14:45 /dev/sdbp
>=20
> How can I fix this?


In RHEL4 until U5 there was a bug which caused the device with
major:minor=3D68:0 to be missing due to a too strong wrong udev rule for
capi devices:

https://bugzilla.redhat.com/show_bug.cgi?id=3D234170
duplicate of
https://bugzilla.redhat.com/show_bug.cgi?id=3D202792

http://rhn.redhat.com/errata/RHBA-2007-0784.html

Looking at your device names looks like the same.

I hope this helps.

Bye!

>=20
> Thanks in advance
--=20
Simone Gotti

--=-O7fW71y5RUP7i+8u8WB6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBH1pLgl0ZU7uYHW3kRAsDeAJ9MNdBqts+sEP7+4yFJuzd8xYiC+gCfRun4
jOGm09bLRRqhezjfLC2srf4=
=+Gbm
-----END PGP SIGNATURE-----

--=-O7fW71y5RUP7i+8u8WB6--


--===============1678036109==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1678036109==--
