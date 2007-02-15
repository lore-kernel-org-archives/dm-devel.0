From: devzero@web.de
Subject: Re: [PATCH 2.6.20] updated dm-loop patch
Date: Thu, 15 Feb 2007 12:45:14 +0100
Message-ID: <1628079706@web.de>
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
To: "Bryn M. Reeves" <breeves@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Bryn,=20

with this patch and also with 0.415 i have the following problem when com=
piling it with stock 2.6.20 :

  Building modules, stage 2.
  MODPOST 1 modules
WARNING: "invalidate_mapping_pages" [drivers/md/dm-loop.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

i found , that this was due to missing=20

EXPORT_SYMBOL(invalidate_mapping_pages);

in mm/truncate.c=20

i found=20
http://lkml.org/lkml/2007/1/3/154

it looks that this didn`t go into 2.6.20 and we need at least 2.6.20-git1=
1 ?
changelog at http://www.kernel.org/pub/linux/kernel/v2.6/snapshots/patch-=
2.6.20-git11.log telling that it had just had been merged on 10th of febr=
uary:


commit 54bc485522afdac33de5504da2ea8cdcc690674e
Author: Anton Altaparmakov <aia21@cam.ac.uk>
Date:   Sat Feb 10 01:45:38 2007 -0800

    [PATCH] Export invalidate_mapping_pages() to modules
   =20
    It makes no sense to me to export invalidate_inode_pages() and not
    invalidate_mapping_pages() and I actually need invalidate_mapping_pag=
es()
    because of its range specification ability...
   =20
    akpm: also remove the export of invalidate_inode_pages() by making it=
 an
    inlined wrapper.
   =20

so, we need 2.6.20-git11 for dm-loop or we would need to modify mm/trunca=
te.c manually !?

regards
roland




> -----Urspr=FCngliche Nachricht-----
> Von: "Bryn M. Reeves" <breeves@redhat.com>
> Gesendet: 15.02.07 01:52:12
> An: device-mapper development <dm-devel@redhat.com>
> Betreff: Re: [dm-devel] [PATCH 2.6.20] updated dm-loop patch


> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>=20
> Bryn M. Reeves wrote:
> > This version of the patch fixes a couple of problems that Roland foun=
d
> > with file offsets & the use of some conversion routines from dm.h:
>=20
> Unfortunately, it also added a new bug: in backing out some other
> changes I'd accidentally reverted to a version of the patch with some
> experimental changes to the file I/O workqueue. This was incomplete and
> harms performance for file mapped loop devices.
>=20
> The attached version changes this back to the previous per-loop device
> workqueue.
>=20
> Apologies for the confusion.
>=20
> Kind regards,
>=20
> Bryn.
>=20
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.5 (GNU/Linux)
> Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org
>=20
> iD8DBQFF066R6YSQoMYUY94RArhtAJ9J0Cc5o+Hg3NjzX8iikrIli9UlYgCggLaE
> /hJdDhTkiybsmfxz8SdLVko=3D
> =3D4pK0
> -----END PGP SIGNATURE-----
>=20
>=20


_____________________________________________________________________
Der WEB.DE SmartSurfer hilft bis zu 70% Ihrer Onlinekosten zu sparen!
http://smartsurfer.web.de/?mc=3D100071&distributionid=3D000000000066
