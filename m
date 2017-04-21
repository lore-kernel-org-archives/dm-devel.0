From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-4.12] block, dm: use __blk_integrity_register to properly setup integrity profile
Date: Fri, 21 Apr 2017 18:28:15 -0400
Message-ID: <20170421222815.45663-1-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

From: Mikulas Patocka <mpatocka@redhat.com>

When registering integrity profile on a DM device, the logical block
size of the underlying device with integrity support must be used, not
the logical block size of the stacked device we are creating.

Introduce __blk_integrity_register() to allow users more precise control
over the logical block size used to register the integrity profile.
blk_integrity_register() now calls __blk_integrity_register().

DM core's use of __blk_integrity_register() fixes a long-standing DM
linear target bug where it cannot pass integrity data to the underlying
device if its logical block size conflicts with the underlying device's
logical block size.

Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-integrity.c  | 14 +++++++++++---
 drivers/md/dm-table.c  |  6 ++++--
 include/linux/blkdev.h |  2 ++
 3 files changed, 17 insertions(+), 5 deletions(-)

NOTE: Jens, I'd like to get this staged in linux-dm.git for 4.12
because the dm-inegrity target depends on it, doing so would avoid
some awkward coordination between block and DM trees.  SO if you're OK
with this patch, and with me sending it to Linus as part of the DM
pull, please provide your Ack. Thanks!

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 9f0ff5b..d2a36e3 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -396,9 +396,10 @@ static struct blk_integrity_profile nop_profile = {
 };
 
 /**
- * blk_integrity_register - Register a gendisk as being integrity-capable
+ * __blk_integrity_register - Register a gendisk as being integrity-capable
  * @disk:	struct gendisk pointer to make integrity-aware
  * @template:	block integrity profile to register
+ * @logical_block_size:	block size - integrity tag exists for each block
  *
  * Description: When a device needs to advertise itself as being able to
  * send/receive integrity metadata it must use this function to register
@@ -406,19 +407,26 @@ static struct blk_integrity_profile nop_profile = {
  * struct with values appropriate for the underlying hardware. See
  * Documentation/block/data-integrity.txt.
  */
-void blk_integrity_register(struct gendisk *disk, struct blk_integrity *template)
+void __blk_integrity_register(struct gendisk *disk, struct blk_integrity *template,
+			      unsigned logical_block_size)
 {
 	struct blk_integrity *bi = &disk->queue->integrity;
 
 	bi->flags = BLK_INTEGRITY_VERIFY | BLK_INTEGRITY_GENERATE |
 		template->flags;
-	bi->interval_exp = ilog2(queue_logical_block_size(disk->queue));
+	bi->interval_exp = ilog2(logical_block_size);
 	bi->profile = template->profile ? template->profile : &nop_profile;
 	bi->tuple_size = template->tuple_size;
 	bi->tag_size = template->tag_size;
 
 	blk_integrity_revalidate(disk);
 }
+EXPORT_SYMBOL(__blk_integrity_register);
+
+void blk_integrity_register(struct gendisk *disk, struct blk_integrity *template)
+{
+	__blk_integrity_register(disk, template, queue_logical_block_size(disk->queue));
+}
 EXPORT_SYMBOL(blk_integrity_register);
 
 /**
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index b060084..b7a5843 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1181,13 +1181,15 @@ static int dm_table_register_integrity(struct dm_table *t)
 		return 0;
 
 	if (!integrity_profile_exists(dm_disk(md))) {
+		struct blk_integrity *integrity = blk_get_integrity(template_disk);
+
 		t->integrity_supported = true;
 		/*
 		 * Register integrity profile during table load; we can do
 		 * this because the final profile must match during resume.
 		 */
-		blk_integrity_register(dm_disk(md),
-				       blk_get_integrity(template_disk));
+		__blk_integrity_register(dm_disk(md), integrity,
+					 1U << integrity->interval_exp);
 		return 0;
 	}
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 796016e..353400c 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1778,6 +1778,8 @@ struct blk_integrity_profile {
 	const char			*name;
 };
 
+extern void __blk_integrity_register(struct gendisk *, struct blk_integrity *,
+				     unsigned);
 extern void blk_integrity_register(struct gendisk *, struct blk_integrity *);
 extern void blk_integrity_unregister(struct gendisk *);
 extern int blk_integrity_compare(struct gendisk *, struct gendisk *);
-- 
2.10.1
