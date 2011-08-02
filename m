From: Joe Thornber <ejt@redhat.com>
Subject: [PATCH 4/4] Track errored blocks
Date: Tue,  2 Aug 2011 15:36:48 +0100
Message-ID: <1312295808-4323-4-git-send-email-ejt@redhat.com>
References: <Pine.LNX.4.64.1108011620590.9983@hs20-bc2-1.build.redhat.com>
	<1312295808-4323-1-git-send-email-ejt@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1312295808-4323-1-git-send-email-ejt@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: mpatocka@redhat.com
Cc: dm-devel@redhat.com, Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

i) Keep track of how many blocks are in the error state.

ii) Make the client pass in the max number of held locks by a thread
at any one time.

iii) Change recycle_block to give up if there are too many in error
state.
---
 drivers/md/dm-thin-metadata.c                 |    2 +-
 drivers/md/persistent-data/dm-block-manager.c |   24 +++++++++++++++++++++---
 drivers/md/persistent-data/dm-block-manager.h |    9 ++++++++-
 3 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index f3b8825..4c9470a 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -561,7 +561,7 @@ struct dm_pool_metadata *dm_pool_metadata_open(struct block_device *bdev,
 	int create;
 
 	bm = dm_block_manager_create(bdev, THIN_METADATA_BLOCK_SIZE,
-				     THIN_METADATA_CACHE_SIZE);
+				     THIN_METADATA_CACHE_SIZE, 3);
 	if (!bm) {
 		DMERR("could not create block manager");
 		return ERR_PTR(-ENOMEM);
diff --git a/drivers/md/persistent-data/dm-block-manager.c b/drivers/md/persistent-data/dm-block-manager.c
index d27ab6e..dd22ef2 100644
--- a/drivers/md/persistent-data/dm-block-manager.c
+++ b/drivers/md/persistent-data/dm-block-manager.c
@@ -58,7 +58,8 @@ struct dm_block {
 
 struct dm_block_manager {
 	struct block_device *bdev;
-	unsigned cache_size;	/* In bytes */
+	unsigned cache_size;
+	unsigned max_held_per_thread;
 	unsigned block_size;	/* In bytes */
 	dm_block_t nr_blocks;
 
@@ -74,6 +75,7 @@ struct dm_block_manager {
 	 */
 	spinlock_t lock;
 
+	unsigned error_count;
 	unsigned available_count;
 	unsigned reading_count;
 	unsigned writing_count;
@@ -161,8 +163,10 @@ static void __transition(struct dm_block *b, enum dm_block_state new_state)
 		b->io_flags = 0;
 		b->validator = NULL;
 
-		if (b->state == BS_ERROR)
+		if (b->state == BS_ERROR) {
+			bm->error_count--;
 			bm->available_count++;
+		}
 		break;
 
 	case BS_CLEAN:
@@ -244,6 +248,7 @@ static void __transition(struct dm_block *b, enum dm_block_state new_state)
 		/* DOT: reading -> error */
 		BUG_ON(!((b->state == BS_WRITING) ||
 			 (b->state == BS_READING)));
+		bm->error_count++;
 		list_add_tail(&b->list, &bm->error_list);
 		break;
 	}
@@ -450,6 +455,16 @@ static int recycle_block(struct dm_block_manager *bm, dm_block_t where,
 retry:
 	while (1) {
 		/*
+		 * The calling thread may hold some locks on blocks, and
+		 * the rest be errored.  In which case we're never going to
+		 * succeed here.
+		 */
+		if (bm->error_count == bm->cache_size - bm->max_held_per_thread) {
+			spin_unlock_irqrestore(&bm->lock, flags);
+			return -ENOMEM;
+		}
+
+		/*
 		 * Once we can lock and do io concurrently then we should
 		 * probably flush at bm->cache_size / 2 and write _all_
 		 * dirty blocks.
@@ -599,7 +614,8 @@ static unsigned calc_hash_size(unsigned cache_size)
 
 struct dm_block_manager *dm_block_manager_create(struct block_device *bdev,
 						 unsigned block_size,
-						 unsigned cache_size)
+						 unsigned cache_size,
+						 unsigned max_held_per_thread)
 {
 	unsigned i;
 	unsigned hash_size = calc_hash_size(cache_size);
@@ -613,6 +629,7 @@ struct dm_block_manager *dm_block_manager_create(struct block_device *bdev,
 
 	bm->bdev = bdev;
 	bm->cache_size = max(MAX_CACHE_SIZE, cache_size);
+	bm->max_held_per_thread = max_held_per_thread;
 	bm->block_size = block_size;
 	bm->nr_blocks = i_size_read(bdev->bd_inode);
 	do_div(bm->nr_blocks, block_size);
@@ -623,6 +640,7 @@ struct dm_block_manager *dm_block_manager_create(struct block_device *bdev,
 	INIT_LIST_HEAD(&bm->clean_list);
 	INIT_LIST_HEAD(&bm->dirty_list);
 	INIT_LIST_HEAD(&bm->error_list);
+	bm->error_count = 0;
 	bm->available_count = 0;
 	bm->reading_count = 0;
 	bm->writing_count = 0;
diff --git a/drivers/md/persistent-data/dm-block-manager.h b/drivers/md/persistent-data/dm-block-manager.h
index ebea2d5..38c49c7 100644
--- a/drivers/md/persistent-data/dm-block-manager.h
+++ b/drivers/md/persistent-data/dm-block-manager.h
@@ -37,7 +37,14 @@ static inline uint32_t dm_block_csum_data(const void *data_le, unsigned length)
 /*----------------------------------------------------------------*/
 
 struct dm_block_manager;
-struct dm_block_manager *dm_block_manager_create(struct block_device *bdev, unsigned block_size, unsigned cache_size);
+
+/*
+ * @max_held_per_thread should be the maximum number of locks, read or
+ * write, that an individual thread holds at any one time.
+ */
+struct dm_block_manager *dm_block_manager_create(
+	struct block_device *bdev, unsigned block_size,
+	unsigned cache_size, unsigned max_held_per_thread);
 void dm_block_manager_destroy(struct dm_block_manager *bm);
 
 unsigned dm_bm_block_size(struct dm_block_manager *bm);
-- 
1.7.4.1
