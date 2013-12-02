From: Helge Deller <deller@gmx.de>
Subject: [PATCH] md: fix compiler warning: large integer implicitly truncated
 to unsigned type
Date: Mon, 2 Dec 2013 20:12:20 +0100
Message-ID: <20131202191220.GA2314@ls3530.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-parisc-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-parisc-owner@vger.kernel.org
To: dm-devel@redhat.com, linux-parisc@vger.kernel.org
List-Id: dm-devel.ids

Compiling a 32bit kernel with CONFIG_LBDAF=3Dn gives this compiler warn=
ing:
/drivers/md/md.c: In function =E2=80=98super_90_load=E2=80=99:
/drivers/md/md.c:1068:3: warning: large integer implicitly truncated to=
 unsigned type [-Woverflow]

=46ix it by casting the calculated value to a sector_t type.

Signed-off-by: Helge Deller <deller@gmx.de>

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e60cebf..b56f1c7 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1065,7 +1065,7 @@ static int super_90_load(struct md_rdev *rdev, st=
ruct md_rdev *refdev, int minor
 	 * record this size)
 	 */
 	if (rdev->sectors >=3D (2ULL << 32) && sb->level >=3D 1)
-		rdev->sectors =3D (2ULL << 32) - 2;
+		rdev->sectors =3D (sector_t) ((2ULL << 32) - 2);
=20
 	if (rdev->sectors < ((sector_t)sb->size) * 2 && sb->level >=3D 1)
 		/* "this cannot possibly happen" ... */
@@ -1356,7 +1356,7 @@ super_90_rdev_size_change(struct md_rdev *rdev, s=
ector_t num_sectors)
 	 * 4TB =3D=3D 2^32 KB, or 2*2^32 sectors.
 	 */
 	if (num_sectors >=3D (2ULL << 32) && rdev->mddev->level >=3D 1)
-		num_sectors =3D (2ULL << 32) - 2;
+		num_sectors =3D (sector_t) ((2ULL << 32) - 2);
 	md_super_write(rdev->mddev, rdev, rdev->sb_start, rdev->sb_size,
 		       rdev->sb_page);
 	md_super_wait(rdev->mddev);
--
To unsubscribe from this list: send the line "unsubscribe linux-parisc"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
