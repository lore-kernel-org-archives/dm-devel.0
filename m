From: NeilBrown <neilb@suse.de>
Subject: [PATCH 04/24] md: be more careful setting MD_CHANGE_CLEAN
Date: Tue, 01 Jun 2010 19:56:19 +1000
Message-ID: <20100601095618.565.67698.stgit@notabene.brown>
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

When MD_CHANGE_CLEAN is set we might block in md_write_start.
So we should only set it when fairly sure that something will clear
it.

There are two places where it is set so as to encourage a metadata
update to record the progress of resync/recovery.  This should only
be done if the internal metadata update mechanisms are in use, which
can be tested by by inspecting '->persistent'.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/bitmap.c |    3 ++-
 drivers/md/md.c     |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 1742435..4518994 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1526,7 +1526,8 @@ void bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector)
 		   atomic_read(&bitmap->mddev->recovery_active) == 0);
 
 	bitmap->mddev->curr_resync_completed = bitmap->mddev->curr_resync;
-	set_bit(MD_CHANGE_CLEAN, &bitmap->mddev->flags);
+	if (bitmap->mddev->persistent)
+		set_bit(MD_CHANGE_CLEAN, &bitmap->mddev->flags);
 	sector &= ~((1ULL << CHUNK_BLOCK_SHIFT(bitmap)) - 1);
 	s = 0;
 	while (s < sector && s < bitmap->mddev->resync_max_sectors) {
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6fbd1c7..2337cb2 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6726,7 +6726,8 @@ void md_do_sync(mddev_t *mddev)
 				   atomic_read(&mddev->recovery_active) == 0);
 			mddev->curr_resync_completed =
 				mddev->curr_resync;
-			set_bit(MD_CHANGE_CLEAN, &mddev->flags);
+			if (mddev->persistent)
+				set_bit(MD_CHANGE_CLEAN, &mddev->flags);
 			sysfs_notify(&mddev->kobj, NULL, "sync_completed");
 		}
 


