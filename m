From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH/RFC] Problems with pvmoving large device
Date: Wed, 11 Nov 2009 15:08:17 +0100
Message-ID: <20091111140817.GT21495@skl-net.de>
References: <20091110144631.GL5174@skl-net.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1223174645=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091110144631.GL5174@skl-net.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <mbroz@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


--===============1223174645==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mgIE+9cwyCTt+85Z"
Content-Disposition: inline


--mgIE+9cwyCTt+85Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[resend to dm-devel as this didn't seem to make it to the linux-lvm list]

Hi

I'm having trouble with moving an 11T PV on an x86_64 system.
The command fails with

	Using reduced mirror region size of 0 sectors
	Creating dieder-pvmove0
	Loading dieder-pvmove0 table (253:3)
	device-mapper: reload ioctl failed: Invalid argument
	Temporary pvmove mirror activation failed.

This is linux-2.6.31.5 and current lvm/dm userspace tools from
cvs. I've also tried other kernel/lvm/dm versions to no avail,
details below.

AFAICT the mirror region size is reduced to zero because region_max
is is being truncated to a 32 bit value in _mirrored_add_target_line()
of lib/mirror/mirrored.c.

I'm not familiar with the LVM code, but I could imagine the patch
below against current CVS aims towards the right direction. However,
as this machine is our production server, I did not have the guts to
try it out.

So please have a look at the patch. If it makes sense, feel free to
include it. If it doesn't, what could be the reason for the pvmove
to fail? And what can I do to make it succeed?

If you need more information in order to debug this issue, don't
hesitate to ask.

Thanks
Andre
---
Index: lib/mirror/mirrored.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
RCS file: /cvs/lvm2/LVM2/lib/mirror/mirrored.c,v
retrieving revision 1.64
diff -u -r1.64 mirrored.c
--- lib/mirror/mirrored.c	1 Oct 2009 00:35:30 -0000	1.64
+++ lib/mirror/mirrored.c	10 Nov 2009 14:23:30 -0000
@@ -290,7 +290,7 @@
 	uint32_t area_count =3D seg->area_count;
 	unsigned start_area =3D 0u;
 	int mirror_status =3D MIRR_RUNNING;
-	uint32_t region_size, region_max;
+	uint32_t region_size;
 	int r;
=20
 	if (!*target_state)
@@ -335,11 +335,11 @@
 		region_size =3D seg->region_size;
 	} else {
 		/* Find largest power of 2 region size unit we can use */
-		region_max =3D (1 << (ffs((int)seg->area_len) - 1)) *
-		      seg->lv->vg->extent_size;
+		uint64_t region_max =3D (1 << (ffs((int)seg->area_len) - 1)) *
+			(uint64_t)seg->lv->vg->extent_size;
=20
 		region_size =3D mirr_state->default_region_size;
-		if (region_max < region_size) {
+		if (region_max < UINT32_MAX && region_size > region_max) {
 			region_size =3D region_max;
 			log_verbose("Using reduced mirror region size of %u sectors",
 				    region_size);

---
# uname -a; lsscsi; pvs; vgs; pvmove /dev/sdg

Linux huangho3 2.6.31.5 #9 SMP Mon Nov 9 15:11:29 CET 2009 x86_64 GNU/Linux
[2:0:0:0]    disk    ADVUNI   OXYGENRAID 424F  347A  /dev/sda
[2:0:0:1]    disk    ADVUNI   OXYGENRAID 424F  347A  /dev/sdb
[2:0:0:2]    disk    ADVUNI   OXYGENRAID 424F  347A  /dev/sdc
[2:0:0:3]    disk    ADVUNI   OXYGENRAID 424F  347A  /dev/sdd
[2:0:0:4]    disk    ADVUNI   OXYGENRAID 424F  347A  /dev/sde
[2:0:1:0]    disk    IFT      A24F-G2430       364R  /dev/sdf
[2:0:2:0]    disk    ADVUNI   OXYGENRAID 416F4 347B  /dev/sdg
    Logging initialised at Tue Nov 10 15:33:54 2009
    Set umask to 0077
    Scanning for physical volume names
    Wiping internal VG cache
  PV         VG     Fmt  Attr PSize  PFree=20
  /dev/sda   dieder lvm2 a-    1.82t     0=20
  /dev/sdb   dieder lvm2 a-    1.82t     0=20
  /dev/sdc   dieder lvm2 a-    1.82t     0=20
  /dev/sdd   dieder lvm2 a-    1.82t     0=20
  /dev/sde   dieder lvm2 a-    1.82t     0=20
  /dev/sdf   dieder lvm2 a-   10.91t 10.91t
  /dev/sdg   dieder lvm2 a-   10.91t  1.91t
    Logging initialised at Tue Nov 10 15:33:54 2009
    Set umask to 0077
    Finding all volume groups
    Finding volume group "dieder"
    Wiping internal VG cache
  VG     #PV #LV #SN Attr   VSize  VFree=20
  dieder   7   3   0 wz--n- 30.92t 12.83t
    Logging initialised at Tue Nov 10 15:33:54 2009
    Set umask to 0077
    Finding volume group "dieder"
    Archiving volume group "dieder" metadata (seqno 62).
    Creating logical volume pvmove0
    Moving 1572864 extents of logical volume dieder/nobackup
    Moving 786432 extents of logical volume dieder/abt6bds
    Found volume group "dieder"
    Found volume group "dieder"
    Updating volume group metadata
    Found volume group "dieder"
    Found volume group "dieder"
    Suspending dieder-nobackup (253:1) with device flush
    Found volume group "dieder"
    Found volume group "dieder"
    Suspending dieder-abt6bds (253:2) with device flush
    Found volume group "dieder"
    Using reduced mirror region size of 0 sectors
    Creating dieder-pvmove0
    Loading dieder-pvmove0 table (253:3)
  device-mapper: reload ioctl failed: Invalid argument
  Temporary pvmove mirror activation failed.
    Found volume group "dieder"
    Found volume group "dieder"
    Found volume group "dieder"
    Found volume group "dieder"
    Found volume group "dieder"
    Found volume group "dieder"
    Suspending dieder-pvmove0 (253:3) with device flush
    Found volume group "dieder"
    Resuming dieder-pvmove0 (253:3)
  device-mapper: resume ioctl failed: Invalid argument
  Unable to resume dieder-pvmove0 (253:3)
    Found volume group "dieder"
    Loading dieder-nobackup table (253:1)
    Suppressed dieder-nobackup identical table reload.
    Resuming dieder-nobackup (253:1)
    Found volume group "dieder"
    Loading dieder-abt6bds table (253:2)
    Suppressed dieder-abt6bds identical table reload.
    Resuming dieder-abt6bds (253:2)
    Found volume group "dieder"
    Removing dieder-pvmove0 (253:3)
    Found volume group "dieder"
    Removing temporary pvmove LV
    Writing out final volume group after pvmove
    Creating volume group backup "/etc/lvm/backup/dieder" (seqno 65).
    Creating volume group backup "/etc/lvm/backup/dieder" (seqno 65).
    Wiping internal VG cache
--=20
The only person who always got his work done by Friday was Robinson Crusoe



=20
The only person who always got his work done by Friday was Robinson Crusoe

--mgIE+9cwyCTt+85Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFK+sVRWto1QDEAkw8RAjr7AKCrJ8DgWsdRw0ORDQIYJ5yh94hWMgCeOsx2
QkwXAoBytayNc9hB1YviQPo=
=b6Zp
-----END PGP SIGNATURE-----

--mgIE+9cwyCTt+85Z--


--===============1223174645==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1223174645==--
