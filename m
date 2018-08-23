From: John Pittman <jpittman@redhat.com>
Subject: [PATCH 2/3] dm zoned: metadata: use refcount_t for dm
	zoned reference counters
Date: Thu, 23 Aug 2018 13:35:56 -0400
Message-ID: <20180823173557.19665-3-jpittman@redhat.com>
References: <20180823173557.19665-1-jpittman@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180823173557.19665-1-jpittman@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: snitzer@redhat.com
Cc: dm-devel@redhat.com, John Pittman <jpittman@redhat.com>
List-Id: dm-devel.ids

The API surrounding refcount_t should be used in place of atomic_t
when variables are being used as reference counters.  This API can
prevent issues such as counter overflows and use-after-free
conditions.  Within the dm zoned metadata stack, the atomic_t API
is used for mblk->ref and zone->refcount.  Change these to use
refcount_t, avoiding the issues mentioned.

Signed-off-by: John Pittman <jpittman@redhat.com>
---
 drivers/md/dm-zoned-metadata.c | 25 +++++++++++++------------
 drivers/md/dm-zoned.h          |  2 +-
 2 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index 969954915566..92e635749414 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -99,7 +99,7 @@ struct dmz_mblock {
 	struct rb_node		node;
 	struct list_head	link;
 	sector_t		no;
-	atomic_t		ref;
+	refcount_t		ref;
 	unsigned long		state;
 	struct page		*page;
 	void			*data;
@@ -296,7 +296,7 @@ static struct dmz_mblock *dmz_alloc_mblock(struct dmz_metadata *zmd,
 
 	RB_CLEAR_NODE(&mblk->node);
 	INIT_LIST_HEAD(&mblk->link);
-	atomic_set(&mblk->ref, 0);
+	refcount_set(&mblk->ref, 0);
 	mblk->state = 0;
 	mblk->no = mblk_no;
 	mblk->data = page_address(mblk->page);
@@ -397,7 +397,7 @@ static struct dmz_mblock *dmz_fetch_mblock(struct dmz_metadata *zmd,
 		return NULL;
 
 	spin_lock(&zmd->mblk_lock);
-	atomic_inc(&mblk->ref);
+	refcount_inc(&mblk->ref);
 	set_bit(DMZ_META_READING, &mblk->state);
 	dmz_insert_mblock(zmd, mblk);
 	spin_unlock(&zmd->mblk_lock);
@@ -484,7 +484,7 @@ static void dmz_release_mblock(struct dmz_metadata *zmd,
 
 	spin_lock(&zmd->mblk_lock);
 
-	if (atomic_dec_and_test(&mblk->ref)) {
+	if (refcount_dec_and_test(&mblk->ref)) {
 		if (test_bit(DMZ_META_ERROR, &mblk->state)) {
 			rb_erase(&mblk->node, &zmd->mblk_rbtree);
 			dmz_free_mblock(zmd, mblk);
@@ -511,7 +511,8 @@ static struct dmz_mblock *dmz_get_mblock(struct dmz_metadata *zmd,
 	mblk = dmz_lookup_mblock(zmd, mblk_no);
 	if (mblk) {
 		/* Cache hit: remove block from LRU list */
-		if (atomic_inc_return(&mblk->ref) == 1 &&
+		refcount_inc(&mblk->ref);
+		if (refcount_read(&mblk->ref) == 1 &&
 		    !test_bit(DMZ_META_DIRTY, &mblk->state))
 			list_del_init(&mblk->link);
 	}
@@ -753,7 +754,7 @@ int dmz_flush_metadata(struct dmz_metadata *zmd)
 
 		spin_lock(&zmd->mblk_lock);
 		clear_bit(DMZ_META_DIRTY, &mblk->state);
-		if (atomic_read(&mblk->ref) == 0)
+		if (refcount_read(&mblk->ref) == 0)
 			list_add_tail(&mblk->link, &zmd->mblk_lru_list);
 		spin_unlock(&zmd->mblk_lock);
 	}
@@ -1048,7 +1049,7 @@ static int dmz_init_zone(struct dmz_metadata *zmd, struct dm_zone *zone,
 	}
 
 	INIT_LIST_HEAD(&zone->link);
-	atomic_set(&zone->refcount, 0);
+	refcount_set(&zone->refcount, 0);
 	zone->chunk = DMZ_MAP_UNMAPPED;
 
 	if (blkz->type == BLK_ZONE_TYPE_CONVENTIONAL) {
@@ -1574,7 +1575,7 @@ struct dm_zone *dmz_get_zone_for_reclaim(struct dmz_metadata *zmd)
 void dmz_activate_zone(struct dm_zone *zone)
 {
 	set_bit(DMZ_ACTIVE, &zone->flags);
-	atomic_inc(&zone->refcount);
+	refcount_inc(&zone->refcount);
 }
 
 /*
@@ -1585,7 +1586,7 @@ void dmz_activate_zone(struct dm_zone *zone)
  */
 void dmz_deactivate_zone(struct dm_zone *zone)
 {
-	if (atomic_dec_and_test(&zone->refcount)) {
+	if (refcount_dec_and_test(&zone->refcount)) {
 		WARN_ON(!test_bit(DMZ_ACTIVE, &zone->flags));
 		clear_bit_unlock(DMZ_ACTIVE, &zone->flags);
 		smp_mb__after_atomic();
@@ -2308,7 +2309,7 @@ static void dmz_cleanup_metadata(struct dmz_metadata *zmd)
 		mblk = list_first_entry(&zmd->mblk_dirty_list,
 					struct dmz_mblock, link);
 		dmz_dev_warn(zmd->dev, "mblock %llu still in dirty list (ref %u)",
-			     (u64)mblk->no, atomic_read(&mblk->ref));
+			     (u64)mblk->no, refcount_read(&mblk->ref));
 		list_del_init(&mblk->link);
 		rb_erase(&mblk->node, &zmd->mblk_rbtree);
 		dmz_free_mblock(zmd, mblk);
@@ -2326,8 +2327,8 @@ static void dmz_cleanup_metadata(struct dmz_metadata *zmd)
 	root = &zmd->mblk_rbtree;
 	rbtree_postorder_for_each_entry_safe(mblk, next, root, node) {
 		dmz_dev_warn(zmd->dev, "mblock %llu ref %u still in rbtree",
-			     (u64)mblk->no, atomic_read(&mblk->ref));
-		atomic_set(&mblk->ref, 0);
+			     (u64)mblk->no, refcount_read(&mblk->ref));
+		refcount_set(&mblk->ref, 0);
 		dmz_free_mblock(zmd, mblk);
 	}
 
diff --git a/drivers/md/dm-zoned.h b/drivers/md/dm-zoned.h
index 12419f0bfe78..b7829a615d26 100644
--- a/drivers/md/dm-zoned.h
+++ b/drivers/md/dm-zoned.h
@@ -78,7 +78,7 @@ struct dm_zone {
 	unsigned long		flags;
 
 	/* Zone activation reference count */
-	atomic_t		refcount;
+	refcount_t		refcount;
 
 	/* Zone write pointer block (relative to the zone start block) */
 	unsigned int		wp_block;
-- 
2.17.1
