From: NeilBrown <neilb@suse.de>
Subject: [PATCH 19/24] md/bitmap: clean up plugging calls.
Date: Tue, 01 Jun 2010 19:56:20 +1000
Message-ID: <20100601095620.565.81802.stgit@notabene.brown>
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

1/ use md_unplug in bitmap.c as we will soon be using bitmaps under
  arrays with no queue attached.

2/ Don't bother plugging the queue when we set a bit in the bitmap.
   The reason for this was to encourage as many bits as possible to
   get set before we unplug and write stuff out.
   However every personality already plugs the queue after
   bitmap_startwrite either directly (raid1/raid10) or be setting
   STRIPE_BIT_DELAY which causes the queue to be plugged later
   (raid5).

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/bitmap.c |    3 +--
 drivers/md/md.c     |    2 +-
 drivers/md/md.h     |    1 +
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 8af4d65..3f04699 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1296,7 +1296,7 @@ int bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long sect
 			prepare_to_wait(&bitmap->overflow_wait, &__wait,
 					TASK_UNINTERRUPTIBLE);
 			spin_unlock_irq(&bitmap->lock);
-			blk_unplug(bitmap->mddev->queue);
+			md_unplug(bitmap->mddev);
 			schedule();
 			finish_wait(&bitmap->overflow_wait, &__wait);
 			continue;
@@ -1306,7 +1306,6 @@ int bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long sect
 		case 0:
 			bitmap_file_set_bit(bitmap, offset);
 			bitmap_count_page(bitmap, offset, 1);
-			blk_plug_device_unlocked(bitmap->mddev->queue);
 			/* fall through */
 		case 1:
 			*bmc = 2;
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 21f3c35..f24efd2 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6600,7 +6600,7 @@ int md_allow_write(mddev_t *mddev)
 }
 EXPORT_SYMBOL_GPL(md_allow_write);
 
-static void md_unplug(mddev_t *mddev)
+void md_unplug(mddev_t *mddev)
 {
 	if (mddev->queue)
 		blk_unplug(mddev->queue);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 6f2c568..a97e4b0 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -506,6 +506,7 @@ extern int md_integrity_register(mddev_t *mddev);
 extern void md_integrity_add_rdev(mdk_rdev_t *rdev, mddev_t *mddev);
 extern int strict_strtoul_scaled(const char *cp, unsigned long *res, int scale);
 extern void restore_bitmap_write_access(struct file *file);
+extern void md_unplug(mddev_t *mddev);
 
 extern void mddev_init(mddev_t *mddev);
 extern int md_run(mddev_t *mddev);


