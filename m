From: NeilBrown <neilb@suse.de>
Subject: [PATCH 18/24] md/bitmap: reduce dependence on sysfs.
Date: Tue, 01 Jun 2010 19:56:20 +1000
Message-ID: <20100601095620.565.35504.stgit@notabene.brown>
References: <20100601094414.565.3638.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100601094414.565.3638.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Heinz Mauelshagen <heinzm@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

For dm-raid45 we will want to use bitmaps in dm-targets which don't
have entries in sysfs, so cope with the mddev not living in sysfs.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/bitmap.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 67fb32d..8af4d65 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1358,7 +1358,7 @@ void bitmap_endwrite(struct bitmap *bitmap, sector_t offset, unsigned long secto
 		    bitmap->events_cleared < bitmap->mddev->events) {
 			bitmap->events_cleared = bitmap->mddev->events;
 			bitmap->need_sync = 1;
-			sysfs_notify_dirent(bitmap->sysfs_can_clear);
+			sysfs_notify_dirent_safe(bitmap->sysfs_can_clear);
 		}
 
 		if (!success && ! (*bmc & NEEDED_MASK))
@@ -1643,7 +1643,7 @@ int bitmap_create(mddev_t *mddev)
 	struct file *file = mddev->bitmap_info.file;
 	int err;
 	sector_t start;
-	struct sysfs_dirent *bm;
+	struct sysfs_dirent *bm = NULL;
 
 	BUILD_BUG_ON(sizeof(bitmap_super_t) != 256);
 
@@ -1664,7 +1664,8 @@ int bitmap_create(mddev_t *mddev)
 
 	bitmap->mddev = mddev;
 
-	bm = sysfs_get_dirent(mddev->kobj.sd, NULL, "bitmap");
+	if (mddev->kobj.sd)
+		bm = sysfs_get_dirent(mddev->kobj.sd, NULL, "bitmap");
 	if (bm) {
 		bitmap->sysfs_can_clear = sysfs_get_dirent(bm, NULL, "can_clear");
 		sysfs_put(bm);


