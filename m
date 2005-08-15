From: Lars Marowsky-Bree <lmb@suse.de>
Subject: bdclaim reversal in DM for EVMS2
Date: Mon, 15 Aug 2005 12:53:01 +0200
Message-ID: <20050815105301.GJ4997@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0262383771=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids


--===============0262383771==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H+4ONPRPur6+Ovig"
Content-Disposition: inline


--H+4ONPRPur6+Ovig
Content-Type: multipart/mixed; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

EVMS2 users keep complaining about the fact that DM bdclaim()s the whole
disk, which makes it impossible to mix EVMS2 use with regular mounts on
the same disk. The EVMS2 folks suggest the attached patch.

Alasdair, do you have any comments on that? This is being requested for
inclusion into openSUSE
(https://bugzilla.novell.com/show_bug.cgi?id=3D104046 - there's some
confusion in the bugzilla as always ;-), and I'd like to get upstream
agreement on where to go first.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="bd-claim.patch"
Content-Transfer-Encoding: quoted-printable

bd-claim

A patch was merged between 2.6.0-test3 and -test4 that breaks EVMS on many
systems by not allowing Device-Mapper to activate DM devices on top of disks
that also contain mounted partitions.

More specifically, the kernel has its own partitioning code that runs when =
the
kernel boots, and provides the traditional partition devices (e.g. /dev/hda=
1).
When a filesystem mounts one of these partitions, the filesystem "claims" t=
hat
partition and no one else can claim it. When this happens, the kernel's
partitioning code (not the filesystem code) also claims the underlying disk,
meaning that disk is only available for use by the kernel's built-in
partitions on that disk. Other filesystems may mount other partitions on th=
at
disk, but the disk itself is "owned" by the partitioning code.

However, in order to allow easy management of partitions, EVMS does its own
partition detection, and creates devices to represent those partitions using
Device-Mapper (not the kernel's built-in partitioning code). When DM create=
s a
device, it also attempts to claim the underlying devices (in this case the
disk that holds the partition). But, if the user has already mounted one of
the kernel's built-in partitions on that same disk, then the disk will alre=
ady
have been claimed. DM will be unable to claim it, and the DM device activat=
ion
will fail.

The end result is that a single disk cannot be used both for EVMS and for
mounting the kernel's built-in partitions.=20

There are three solutions to this problem.

1. Switch to using EVMS for *all* your volumes and partitions. If none of t=
he
   kernel's built-in partitions are mounted, then there won't be any confli=
cts
   when DM tries to claim the disks. This is, of course, the preferred
   solution, but also requires some extra work on your part to convert to
   mounting your root filesystem using an EVMS volume. Please see
   http://evms.sf.net/install/root.html and http://evms.sf.net/convert.html
   for more details on this option.

2. Tell EVMS to exclude any disks that contain partitions that you are going
   to mount using the kernel's built-in partitions. You can do this by addi=
ng
   the names of these disks to the "sysfs_devices.exclude" line in your
   /etc/evms.conf file. If you choose this option, EVMS will completely ign=
ore
   the specified disks and not discover any of the partitions or volumes on
   those disks.

3. Apply this patch, which will is a reversal of the patch that prevents
   Device-Mapper and the kernel's built-in partitions from using the same d=
isk
   at the same time. This patch is not supported by the kernel community, a=
nd
   in fact removes functionality that they specifically added. However, it
   will allow you to share your disks between EVMS and the kernel's built-in
   partitioning code, if that's the choice you wish to make for your system.

   cd /usr/src/linux-2.6.10/
   patch -p1 < bd_claim.patch


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
Current devices can be 'claimed' by filesystems (when mounting) or
md/raid (when being included in an array) or 'raw' or ....
This stop concurrent access by these systems.

However it is still possible for one system to claim the whole device
and a second system to claim one partition, which is not good.

With this patch, when a partition is claimed, the whole device is
claimed for partitioning.  So you cannot have a partition and the
whole devices claimed at the same time (except if the whole device
is claimed for partitioning).

--- diff/fs/block_dev.c	2005-02-28 08:36:45.603361144 -0600
+++ source/fs/block_dev.c	2005-02-28 09:30:13.347709880 -0600
@@ -445,34 +445,12 @@
=20
 int bd_claim(struct block_device *bdev, void *holder)
 {
-	int res;
+	int res =3D -EBUSY;
 	spin_lock(&bdev_lock);
-
-	/* first decide result */
-	if (bdev->bd_holder =3D=3D holder)
-		res =3D 0;	 /* already a holder */
-	else if (bdev->bd_holder !=3D NULL)
-		res =3D -EBUSY; 	 /* held by someone else */
-	else if (bdev->bd_contains =3D=3D bdev)
-		res =3D 0;  	 /* is a whole device which isn't held */
-
-	else if (bdev->bd_contains->bd_holder =3D=3D bd_claim)
-		res =3D 0; 	 /* is a partition of a device that is being partitioned */
-	else if (bdev->bd_contains->bd_holder !=3D NULL)
-		res =3D -EBUSY;	 /* is a partition of a held device */
-	else
-		res =3D 0;	 /* is a partition of an un-held device */
-
-	/* now impose change */
-	if (res=3D=3D0) {
-		/* note that for a whole device bd_holders
-		 * will be incremented twice, and bd_holder will
-		 * be set to bd_claim before being set to holder
-		 */
-		bdev->bd_contains->bd_holders ++;
-		bdev->bd_contains->bd_holder =3D bd_claim;
-		bdev->bd_holders++;
+	if (!bdev->bd_holder || bdev->bd_holder =3D=3D holder) {
 		bdev->bd_holder =3D holder;
+		bdev->bd_holders++;
+		res =3D 0;
 	}
 	spin_unlock(&bdev_lock);
 	return res;
@@ -483,8 +461,6 @@
 void bd_release(struct block_device *bdev)
 {
 	spin_lock(&bdev_lock);
-	if (!--bdev->bd_contains->bd_holders)
-		bdev->bd_contains->bd_holder =3D NULL;
 	if (!--bdev->bd_holders)
 		bdev->bd_holder =3D NULL;
 	spin_unlock(&bdev_lock);

--ReaqsoxgOBHFXBhH--

--H+4ONPRPur6+Ovig
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFDAHQNudf3XQV4S2cRAuR9AJ4hYGgIvyUV150Jzil0GTwaNPlrwACdGTVx
v2hCb9acIcIvKBZQYpuzTb0=
=zHwH
-----END PGP SIGNATURE-----

--H+4ONPRPur6+Ovig--


--===============0262383771==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0262383771==--
