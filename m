From: Bryan Gurney <bgurney@redhat.com>
Subject: [PATCH] dm dust: convert irqsave spinlocks to mutex locks
Date: Wed, 25 Sep 2019 13:56:39 -0400
Message-ID: <1569434199-31642-1-git-send-email-bgurney@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, snitzer@redhat.com, agk@redhat.com
Cc: Bryan Gurney <bgurney@redhat.com>
List-Id: dm-devel.ids

Since the dm-dust calls that need locking do not occur from an
interrupt context, switch to a mutex lock.

Additionally, move some DMERR() calls to be after the unlock, and
in dust_add_block(), move a "bblock->bb" assignment before the lock.

Suggested-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Bryan Gurney <bgurney@redhat.com>
---
 drivers/md/dm-dust.c | 44 ++++++++++++++++++--------------------------
 1 file changed, 18 insertions(+), 26 deletions(-)

diff --git a/drivers/md/dm-dust.c b/drivers/md/dm-dust.c
index 8288887b7f94..9a6c041cc711 100644
--- a/drivers/md/dm-dust.c
+++ b/drivers/md/dm-dust.c
@@ -23,7 +23,7 @@ struct dust_device {
 	struct dm_dev *dev;
 	struct rb_root badblocklist;
 	unsigned long long badblock_count;
-	spinlock_t dust_lock;
+	struct mutex dust_lock;
 	unsigned int blksz;
 	int sect_per_block_shift;
 	unsigned int sect_per_block;
@@ -77,26 +77,25 @@ static bool dust_rb_insert(struct rb_root *root, struct badblock *new)
 static int dust_remove_block(struct dust_device *dd, unsigned long long block)
 {
 	struct badblock *bblock;
-	unsigned long flags;
 
-	spin_lock_irqsave(&dd->dust_lock, flags);
+	mutex_lock(&dd->dust_lock);
 	bblock = dust_rb_search(&dd->badblocklist, block);
 
 	if (bblock == NULL) {
+		mutex_unlock(&dd->dust_lock);
 		if (!dd->quiet_mode) {
 			DMERR("%s: block %llu not found in badblocklist",
 			      __func__, block);
 		}
-		spin_unlock_irqrestore(&dd->dust_lock, flags);
 		return -EINVAL;
 	}
 
 	rb_erase(&bblock->node, &dd->badblocklist);
 	dd->badblock_count--;
+	mutex_unlock(&dd->dust_lock);
 	if (!dd->quiet_mode)
 		DMINFO("%s: badblock removed at block %llu", __func__, block);
 	kfree(bblock);
-	spin_unlock_irqrestore(&dd->dust_lock, flags);
 
 	return 0;
 }
@@ -104,7 +103,6 @@ static int dust_remove_block(struct dust_device *dd, unsigned long long block)
 static int dust_add_block(struct dust_device *dd, unsigned long long block)
 {
 	struct badblock *bblock;
-	unsigned long flags;
 
 	bblock = kmalloc(sizeof(*bblock), GFP_KERNEL);
 	if (bblock == NULL) {
@@ -113,22 +111,22 @@ static int dust_add_block(struct dust_device *dd, unsigned long long block)
 		return -ENOMEM;
 	}
 
-	spin_lock_irqsave(&dd->dust_lock, flags);
 	bblock->bb = block;
+	mutex_lock(&dd->dust_lock);
 	if (!dust_rb_insert(&dd->badblocklist, bblock)) {
+		mutex_unlock(&dd->dust_lock);
 		if (!dd->quiet_mode) {
 			DMERR("%s: block %llu already in badblocklist",
 			      __func__, block);
 		}
-		spin_unlock_irqrestore(&dd->dust_lock, flags);
 		kfree(bblock);
 		return -EINVAL;
 	}
 
 	dd->badblock_count++;
+	mutex_unlock(&dd->dust_lock);
 	if (!dd->quiet_mode)
 		DMINFO("%s: badblock added at block %llu", __func__, block);
-	spin_unlock_irqrestore(&dd->dust_lock, flags);
 
 	return 0;
 }
@@ -136,15 +134,14 @@ static int dust_add_block(struct dust_device *dd, unsigned long long block)
 static int dust_query_block(struct dust_device *dd, unsigned long long block)
 {
 	struct badblock *bblock;
-	unsigned long flags;
 
-	spin_lock_irqsave(&dd->dust_lock, flags);
+	mutex_lock(&dd->dust_lock);
 	bblock = dust_rb_search(&dd->badblocklist, block);
 	if (bblock != NULL)
 		DMINFO("%s: block %llu found in badblocklist", __func__, block);
 	else
 		DMINFO("%s: block %llu not found in badblocklist", __func__, block);
-	spin_unlock_irqrestore(&dd->dust_lock, flags);
+	mutex_unlock(&dd->dust_lock);
 
 	return 0;
 }
@@ -162,14 +159,13 @@ static int __dust_map_read(struct dust_device *dd, sector_t thisblock)
 static int dust_map_read(struct dust_device *dd, sector_t thisblock,
 			 bool fail_read_on_bb)
 {
-	unsigned long flags;
 	int ret = DM_MAPIO_REMAPPED;
 
 	if (fail_read_on_bb) {
 		thisblock >>= dd->sect_per_block_shift;
-		spin_lock_irqsave(&dd->dust_lock, flags);
+		mutex_lock(&dd->dust_lock);
 		ret = __dust_map_read(dd, thisblock);
-		spin_unlock_irqrestore(&dd->dust_lock, flags);
+		mutex_unlock(&dd->dust_lock);
 	}
 
 	return ret;
@@ -194,13 +190,11 @@ static void __dust_map_write(struct dust_device *dd, sector_t thisblock)
 static int dust_map_write(struct dust_device *dd, sector_t thisblock,
 			  bool fail_read_on_bb)
 {
-	unsigned long flags;
-
 	if (fail_read_on_bb) {
 		thisblock >>= dd->sect_per_block_shift;
-		spin_lock_irqsave(&dd->dust_lock, flags);
+		mutex_lock(&dd->dust_lock);
 		__dust_map_write(dd, thisblock);
-		spin_unlock_irqrestore(&dd->dust_lock, flags);
+		mutex_unlock(&dd->dust_lock);
 	}
 
 	return DM_MAPIO_REMAPPED;
@@ -248,16 +242,15 @@ static bool __dust_clear_badblocks(struct rb_root *tree,
 
 static int dust_clear_badblocks(struct dust_device *dd)
 {
-	unsigned long flags;
 	struct rb_root badblocklist;
 	unsigned long long badblock_count;
 
-	spin_lock_irqsave(&dd->dust_lock, flags);
+	mutex_lock(&dd->dust_lock);
 	badblocklist = dd->badblocklist;
 	badblock_count = dd->badblock_count;
 	dd->badblocklist = RB_ROOT;
 	dd->badblock_count = 0;
-	spin_unlock_irqrestore(&dd->dust_lock, flags);
+	mutex_unlock(&dd->dust_lock);
 
 	if (!__dust_clear_badblocks(&badblocklist, badblock_count))
 		DMINFO("%s: no badblocks found", __func__);
@@ -347,7 +340,7 @@ static int dust_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	 */
 	dd->badblocklist = RB_ROOT;
 	dd->badblock_count = 0;
-	spin_lock_init(&dd->dust_lock);
+	mutex_init(&dd->dust_lock);
 
 	dd->quiet_mode = false;
 
@@ -377,7 +370,6 @@ static int dust_message(struct dm_target *ti, unsigned int argc, char **argv,
 	bool invalid_msg = false;
 	int result = -EINVAL;
 	unsigned long long tmp, block;
-	unsigned long flags;
 	char dummy;
 
 	if (argc == 1) {
@@ -394,10 +386,10 @@ static int dust_message(struct dm_target *ti, unsigned int argc, char **argv,
 			dd->fail_read_on_bb = true;
 			result = 0;
 		} else if (!strcasecmp(argv[0], "countbadblocks")) {
-			spin_lock_irqsave(&dd->dust_lock, flags);
+			mutex_lock(&dd->dust_lock);
 			DMINFO("countbadblocks: %llu badblock(s) found",
 			       dd->badblock_count);
-			spin_unlock_irqrestore(&dd->dust_lock, flags);
+			mutex_unlock(&dd->dust_lock);
 			result = 0;
 		} else if (!strcasecmp(argv[0], "clearbadblocks")) {
 			result = dust_clear_badblocks(dd);
-- 
2.21.0
