From: devzero@web.de
Subject: Re: [PATCH 2.6.20] updated dm-loop patch
Date: Thu, 15 Feb 2007 23:30:57 +0100
Message-ID: <1629339771@web.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable
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
To: "Bryn M. Reeves" <breeves@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

hi again,=20

just wondering - would it make sense to have dm-loop supporting partition=
s "out of the box" ?

i gave it a try, but the appropriate ioctls seem to be missing.

Command (m for help): p

Disk /dev/mapper/loop0: 104 MB, 104857600 bytes
255 heads, 63 sectors/track, 12 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

             Device Boot      Start         End      Blocks   Id  System
/dev/mapper/loop0p1               1           6       48163+  83  Linux
/dev/mapper/loop0p2               7          12       48195   83  Linux

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.

WARNING: Re-reading the partition table failed with error 22: Invalid arg=
ument.
The kernel still uses the old table.
The new table will be used at the next reboot.
Syncing disks.


fdisk providing wrong information here, because removing and re-adding lo=
op0 doesn`t make loop0p1 or loop0p2 appear.

there is some nice script at http://www.ussg.iu.edu/hypermail/linux/kerne=
l/0307.2/0935.html which makes those partitions available by creating add=
itional devices, but i`m just wondering if this could work automa(t|g)ica=
lly.

regards
roland




> -----Urspr=FCngliche Nachricht-----
> Von: "Bryn M. Reeves" <breeves@redhat.com>
> Gesendet: 15.02.07 13:28:24
> An: devzero@web.de
> CC: device-mapper development <dm-devel@redhat.com>
> Betreff: Re: [dm-devel] [PATCH 2.6.20] updated dm-loop patch


> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>=20
> devzero@web.de wrote:
> > Hi Bryn,=20
> >=20
> > with this patch and also with 0.415 i have the following problem when=
 compiling it with stock 2.6.20 :
> >=20
> >   Building modules, stage 2.
> >   MODPOST 1 modules
> > WARNING: "invalidate_mapping_pages" [drivers/md/dm-loop.ko] undefined=
!
> > make[1]: *** [__modpost] Error 1
> > make: *** [modules] Error 2
> >=20
> > i found , that this was due to missing=20
> >=20
> > EXPORT_SYMBOL(invalidate_mapping_pages);
> >=20
> > in mm/truncate.c=20
> >=20
> > i found=20
> > http://lkml.org/lkml/2007/1/3/154
> >=20
> > it looks that this didn`t go into 2.6.20 and we need at least 2.6.20-=
git11 ?
> > changelog at http://www.kernel.org/pub/linux/kernel/v2.6/snapshots/pa=
tch-2.6.20-git11.log telling that it had just had been merged on 10th of =
february:
> >=20
>=20
> Hi Roland,
>=20
> That's right - I keep my git tree fairly close to upstream, so as soon
> as the patch that deprecated invalidate_inode_pages was merged, I
> converted dm-loop to use invalidate_mapping_pages instead.
>=20
> This means that dm-loop will build without warnings on the latest
> kernel.org tree but it does mean that you will need the additional patc=
h
> you referenced if you want to apply it to a plain 2.6.20 kernel.
>=20
> Kind regards,
>=20
> Bryn.
>=20
>=20
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.6 (GNU/Linux)
> Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org
>=20
> iD8DBQFF1FHa6YSQoMYUY94RAl2iAKDAlrTqxDCNP7i/bhexl6JJGW1rNwCgksXz
> 5limiJOmDRoBKdHDUsU0pFE=3D
> =3DHwdH
> -----END PGP SIGNATURE-----
>=20


_______________________________________________________________________
Viren-Scan f=FCr Ihren PC! Jetzt f=FCr jeden. Sofort, online und kostenlo=
s.
Gleich testen! http://www.pc-sicherheit.web.de/freescan/?mc=3D022222
