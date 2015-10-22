From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-persistent-data: eliminate unneeded return
	values
Date: Thu, 22 Oct 2015 16:46:59 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1510221646080.12773@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: Edward Thornber <thornber@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Some functions, such as dm_bm_unlock, dm_tm_unlock return an integer
value, but the returned value is always 0. The calling code sometimes
checks the return value and sometimes doesn't.

This patch eliminates the unneeded return valus and also eliminates checks
for them.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-cache-metadata.c                      |    8 +++-
 drivers/md/dm-era-target.c                          |   15 ++++----
 drivers/md/dm-thin-metadata.c                       |   16 +++++++--
 drivers/md/persistent-data/dm-array.c               |    4 +-
 drivers/md/persistent-data/dm-block-manager.c       |    4 --
 drivers/md/persistent-data/dm-block-manager.h       |    2 -
 drivers/md/persistent-data/dm-btree-internal.h      |    2 -
 drivers/md/persistent-data/dm-btree-remove.c        |   34 +++++---------------
 drivers/md/persistent-data/dm-btree-spine.c         |   20 +++--------
 drivers/md/persistent-data/dm-btree.c               |    4 +-
 drivers/md/persistent-data/dm-space-map-common.c    |   32 +++++++++---------
 drivers/md/persistent-data/dm-transaction-manager.c |    4 +-
 drivers/md/persistent-data/dm-transaction-manager.h |    2 -
 13 files changed, 67 insertions(+), 80 deletions(-)

Index: linux-4.3-rc6/drivers/md/dm-cache-metadata.c
===================================================================
--- linux-4.3-rc6.orig/drivers/md/dm-cache-metadata.c	2015-10-22 19:03:21.000000000 +0200
+++ linux-4.3-rc6/drivers/md/dm-cache-metadata.c	2015-10-22 19:03:40.000000000 +0200
@@ -260,7 +260,9 @@ static int __superblock_all_zeroes(struc
 		}
 	}
 
-	return dm_bm_unlock(b);
+	dm_bm_unlock(b);
+
+	return 0;
 }
 
 static void __setup_mapping_info(struct dm_cache_metadata *cmd)
@@ -465,7 +467,9 @@ static int __open_metadata(struct dm_cac
 	dm_disk_bitset_init(cmd->tm, &cmd->discard_info);
 	sb_flags = le32_to_cpu(disk_super->flags);
 	cmd->clean_when_opened = test_bit(CLEAN_SHUTDOWN, &sb_flags);
-	return dm_bm_unlock(sblock);
+	dm_bm_unlock(sblock);
+
+	return 0;
 
 bad:
 	dm_bm_unlock(sblock);
Index: linux-4.3-rc6/drivers/md/dm-era-target.c
===================================================================
--- linux-4.3-rc6.orig/drivers/md/dm-era-target.c	2015-10-22 19:04:04.000000000 +0200
+++ linux-4.3-rc6/drivers/md/dm-era-target.c	2015-10-22 19:07:04.000000000 +0200
@@ -343,7 +343,9 @@ static int superblock_all_zeroes(struct 
 		}
 	}
 
-	return dm_bm_unlock(b);
+	dm_bm_unlock(b);
+
+	return 0;
 }
 
 /*----------------------------------------------------------------*/
@@ -582,7 +584,9 @@ static int open_metadata(struct era_meta
 	md->metadata_snap = le64_to_cpu(disk->metadata_snap);
 	md->archived_writesets = true;
 
-	return dm_bm_unlock(sblock);
+	dm_bm_unlock(sblock);
+
+	return 0;
 
 bad:
 	dm_bm_unlock(sblock);
@@ -1046,12 +1050,7 @@ static int metadata_take_snap(struct era
 
 	md->metadata_snap = dm_block_location(clone);
 
-	r = dm_tm_unlock(md->tm, clone);
-	if (r) {
-		DMERR("%s: couldn't unlock clone", __func__);
-		md->metadata_snap = SUPERBLOCK_LOCATION;
-		return r;
-	}
+	dm_tm_unlock(md->tm, clone);
 
 	return 0;
 }
Index: linux-4.3-rc6/drivers/md/dm-thin-metadata.c
===================================================================
--- linux-4.3-rc6.orig/drivers/md/dm-thin-metadata.c	2015-10-22 19:02:10.000000000 +0200
+++ linux-4.3-rc6/drivers/md/dm-thin-metadata.c	2015-10-22 19:05:43.000000000 +0200
@@ -396,7 +396,9 @@ static int __superblock_all_zeroes(struc
 		}
 	}
 
-	return dm_bm_unlock(b);
+	dm_bm_unlock(b);
+
+	return 0;
 }
 
 static void __setup_btree_details(struct dm_pool_metadata *pmd)
@@ -650,7 +652,9 @@ static int __open_metadata(struct dm_poo
 	}
 
 	__setup_btree_details(pmd);
-	return dm_bm_unlock(sblock);
+	dm_bm_unlock(sblock);
+
+	return 0;
 
 bad_cleanup_data_sm:
 	dm_sm_destroy(pmd->data_sm);
@@ -1297,7 +1301,9 @@ static int __release_metadata_snap(struc
 	dm_btree_del(&pmd->details_info, le64_to_cpu(disk_super->device_details_root));
 	dm_sm_dec_block(pmd->metadata_sm, held_root);
 
-	return dm_tm_unlock(pmd->tm, copy);
+	dm_tm_unlock(pmd->tm, copy);
+
+	return 0;
 }
 
 int dm_pool_release_metadata_snap(struct dm_pool_metadata *pmd)
@@ -1327,7 +1333,9 @@ static int __get_metadata_snap(struct dm
 	disk_super = dm_block_data(sblock);
 	*result = le64_to_cpu(disk_super->held_root);
 
-	return dm_bm_unlock(sblock);
+	dm_bm_unlock(sblock);
+
+	return 0;
 }
 
 int dm_pool_get_metadata_snap(struct dm_pool_metadata *pmd,
Index: linux-4.3-rc6/drivers/md/persistent-data/dm-array.c
===================================================================
--- linux-4.3-rc6.orig/drivers/md/persistent-data/dm-array.c	2015-10-22 19:06:06.000000000 +0200
+++ linux-4.3-rc6/drivers/md/persistent-data/dm-array.c	2015-10-22 19:06:33.000000000 +0200
@@ -233,9 +233,9 @@ static int get_ablock(struct dm_array_in
 /*
  * Unlocks an array block.
  */
-static int unlock_ablock(struct dm_array_info *info, struct dm_block *block)
+static void unlock_ablock(struct dm_array_info *info, struct dm_block *block)
 {
-	return dm_tm_unlock(info->btree_info.tm, block);
+	dm_tm_unlock(info->btree_info.tm, block);
 }
 
 /*----------------------------------------------------------------*/
Index: linux-4.3-rc6/drivers/md/persistent-data/dm-block-manager.c
===================================================================
--- linux-4.3-rc6.orig/drivers/md/persistent-data/dm-block-manager.c	2015-10-22 18:25:45.000000000 +0200
+++ linux-4.3-rc6/drivers/md/persistent-data/dm-block-manager.c	2015-10-22 18:25:52.000000000 +0200
@@ -578,7 +578,7 @@ int dm_bm_write_lock_zero(struct dm_bloc
 }
 EXPORT_SYMBOL_GPL(dm_bm_write_lock_zero);
 
-int dm_bm_unlock(struct dm_block *b)
+void dm_bm_unlock(struct dm_block *b)
 {
 	struct buffer_aux *aux;
 	aux = dm_bufio_get_aux_data(to_buffer(b));
@@ -590,8 +590,6 @@ int dm_bm_unlock(struct dm_block *b)
 		bl_up_read(&aux->lock);
 
 	dm_bufio_release(to_buffer(b));
-
-	return 0;
 }
 EXPORT_SYMBOL_GPL(dm_bm_unlock);
 
Index: linux-4.3-rc6/drivers/md/persistent-data/dm-block-manager.h
===================================================================
--- linux-4.3-rc6.orig/drivers/md/persistent-data/dm-block-manager.h	2015-10-22 18:25:54.000000000 +0200
+++ linux-4.3-rc6/drivers/md/persistent-data/dm-block-manager.h	2015-10-22 18:25:59.000000000 +0200
@@ -94,7 +94,7 @@ int dm_bm_write_lock_zero(struct dm_bloc
 			  struct dm_block_validator *v,
 			  struct dm_block **result);
 
-int dm_bm_unlock(struct dm_block *b);
+void dm_bm_unlock(struct dm_block *b);
 
 /*
  * It's a common idiom to have a superblock that should be committed last.
Index: linux-4.3-rc6/drivers/md/persistent-data/dm-btree-internal.h
===================================================================
--- linux-4.3-rc6.orig/drivers/md/persistent-data/dm-btree-internal.h	2015-10-22 19:09:52.000000000 +0200
+++ linux-4.3-rc6/drivers/md/persistent-data/dm-btree-internal.h	2015-10-22 19:10:00.000000000 +0200
@@ -52,7 +52,7 @@ void inc_children(struct dm_transaction_
 		  struct dm_btree_value_type *vt);
 
 int new_block(struct dm_btree_info *info, struct dm_block **result);
-int unlock_block(struct dm_btree_info *info, struct dm_block *b);
+void unlock_block(struct dm_btree_info *info, struct dm_block *b);
 
 /*
  * Spines keep track of the rolling locks.  There are 2 variants, read-only
Index: linux-4.3-rc6/drivers/md/persistent-data/dm-btree-remove.c
===================================================================
--- linux-4.3-rc6.orig/drivers/md/persistent-data/dm-btree-remove.c	2015-10-22 19:08:31.000000000 +0200
+++ linux-4.3-rc6/drivers/md/persistent-data/dm-btree-remove.c	2015-10-22 19:10:15.000000000 +0200
@@ -165,9 +165,9 @@ static int init_child(struct dm_btree_in
 	return 0;
 }
 
-static int exit_child(struct dm_btree_info *info, struct child *c)
+static void exit_child(struct dm_btree_info *info, struct child *c)
 {
-	return dm_tm_unlock(info->tm, c->block);
+	dm_tm_unlock(info->tm, c->block);
 }
 
 static void shift(struct btree_node *left, struct btree_node *right, int count)
@@ -249,13 +249,10 @@ static int rebalance2(struct shadow_spin
 
 	__rebalance2(info, parent, &left, &right);
 
-	r = exit_child(info, &left);
-	if (r) {
-		exit_child(info, &right);
-		return r;
-	}
+	exit_child(info, &left);
+	exit_child(info, &right);
 
-	return exit_child(info, &right);
+	return 0;
 }
 
 /*
@@ -389,22 +386,11 @@ static int rebalance3(struct shadow_spin
 
 	__rebalance3(info, parent, &left, &center, &right);
 
-	r = exit_child(info, &left);
-	if (r) {
-		exit_child(info, &center);
-		exit_child(info, &right);
-		return r;
-	}
+	exit_child(info, &left);
 
-	r = exit_child(info, &center);
-	if (r) {
-		exit_child(info, &right);
-		return r;
-	}
+	exit_child(info, &center);
 
-	r = exit_child(info, &right);
-	if (r)
-		return r;
+	exit_child(info, &right);
 
 	return 0;
 }
@@ -428,9 +414,7 @@ static int rebalance_children(struct sha
 
 		memcpy(n, dm_block_data(child),
 		       dm_bm_block_size(dm_tm_get_bm(info->tm)));
-		r = dm_tm_unlock(info->tm, child);
-		if (r)
-			return r;
+		dm_tm_unlock(info->tm, child);
 
 		dm_tm_dec(info->tm, dm_block_location(child));
 		return 0;
Index: linux-4.3-rc6/drivers/md/persistent-data/dm-btree-spine.c
===================================================================
--- linux-4.3-rc6.orig/drivers/md/persistent-data/dm-btree-spine.c	2015-10-22 19:09:27.000000000 +0200
+++ linux-4.3-rc6/drivers/md/persistent-data/dm-btree-spine.c	2015-10-22 19:11:24.000000000 +0200
@@ -117,9 +117,9 @@ int new_block(struct dm_btree_info *info
 	return dm_tm_new_block(info->tm, &btree_node_validator, result);
 }
 
-int unlock_block(struct dm_btree_info *info, struct dm_block *b)
+void unlock_block(struct dm_btree_info *info, struct dm_block *b)
 {
-	return dm_tm_unlock(info->tm, b);
+	dm_tm_unlock(info->tm, b);
 }
 
 /*----------------------------------------------------------------*/
@@ -137,9 +137,7 @@ int exit_ro_spine(struct ro_spine *s)
 	int r = 0, i;
 
 	for (i = 0; i < s->count; i++) {
-		int r2 = unlock_block(s->info, s->nodes[i]);
-		if (r2 < 0)
-			r = r2;
+		unlock_block(s->info, s->nodes[i]);
 	}
 
 	return r;
@@ -150,9 +148,7 @@ int ro_step(struct ro_spine *s, dm_block
 	int r;
 
 	if (s->count == 2) {
-		r = unlock_block(s->info, s->nodes[0]);
-		if (r < 0)
-			return r;
+		unlock_block(s->info, s->nodes[0]);
 		s->nodes[0] = s->nodes[1];
 		s->count--;
 	}
@@ -194,9 +190,7 @@ int exit_shadow_spine(struct shadow_spin
 	int r = 0, i;
 
 	for (i = 0; i < s->count; i++) {
-		int r2 = unlock_block(s->info, s->nodes[i]);
-		if (r2 < 0)
-			r = r2;
+		unlock_block(s->info, s->nodes[i]);
 	}
 
 	return r;
@@ -208,9 +202,7 @@ int shadow_step(struct shadow_spine *s, 
 	int r;
 
 	if (s->count == 2) {
-		r = unlock_block(s->info, s->nodes[0]);
-		if (r < 0)
-			return r;
+		unlock_block(s->info, s->nodes[0]);
 		s->nodes[0] = s->nodes[1];
 		s->count--;
 	}
Index: linux-4.3-rc6/drivers/md/persistent-data/dm-space-map-common.c
===================================================================
--- linux-4.3-rc6.orig/drivers/md/persistent-data/dm-space-map-common.c	2015-10-22 19:07:11.000000000 +0200
+++ linux-4.3-rc6/drivers/md/persistent-data/dm-space-map-common.c	2015-10-22 19:08:05.000000000 +0200
@@ -259,9 +259,7 @@ int sm_ll_extend(struct ll_disk *ll, dm_
 
 		idx.blocknr = cpu_to_le64(dm_block_location(b));
 
-		r = dm_tm_unlock(ll->tm, b);
-		if (r < 0)
-			return r;
+		dm_tm_unlock(ll->tm, b);
 
 		idx.nr_free = cpu_to_le32(ll->entries_per_block);
 		idx.none_free_before = 0;
@@ -293,7 +291,9 @@ int sm_ll_lookup_bitmap(struct ll_disk *
 
 	*result = sm_lookup_bitmap(dm_bitmap_data(blk), b);
 
-	return dm_tm_unlock(ll->tm, blk);
+	dm_tm_unlock(ll->tm, blk);
+
+	return 0;
 }
 
 static int sm_ll_lookup_big_ref_count(struct ll_disk *ll, dm_block_t b,
@@ -373,9 +373,7 @@ int sm_ll_find_free_block(struct ll_disk
 			return r;
 		}
 
-		r = dm_tm_unlock(ll->tm, blk);
-		if (r < 0)
-			return r;
+		dm_tm_unlock(ll->tm, blk);
 
 		*result = i * ll->entries_per_block + (dm_block_t) position;
 		return 0;
@@ -429,9 +427,7 @@ static int sm_ll_mutate(struct ll_disk *
 	if (ref_count <= 2) {
 		sm_set_bitmap(bm_le, bit, ref_count);
 
-		r = dm_tm_unlock(ll->tm, nb);
-		if (r < 0)
-			return r;
+		dm_tm_unlock(ll->tm, nb);
 
 		if (old > 2) {
 			r = dm_btree_remove(&ll->ref_count_info,
@@ -445,9 +441,7 @@ static int sm_ll_mutate(struct ll_disk *
 		__le32 le_rc = cpu_to_le32(ref_count);
 
 		sm_set_bitmap(bm_le, bit, 3);
-		r = dm_tm_unlock(ll->tm, nb);
-		if (r < 0)
-			return r;
+		dm_tm_unlock(ll->tm, nb);
 
 		__dm_bless_for_disk(&le_rc);
 		r = dm_btree_insert(&ll->ref_count_info, ll->ref_count_root,
@@ -556,7 +550,9 @@ static int metadata_ll_init_index(struct
 	memcpy(dm_block_data(b), &ll->mi_le, sizeof(ll->mi_le));
 	ll->bitmap_root = dm_block_location(b);
 
-	return dm_tm_unlock(ll->tm, b);
+	dm_tm_unlock(ll->tm, b);
+
+	return 0;
 }
 
 static int metadata_ll_open(struct ll_disk *ll)
@@ -570,7 +566,9 @@ static int metadata_ll_open(struct ll_di
 		return r;
 
 	memcpy(&ll->mi_le, dm_block_data(block), sizeof(ll->mi_le));
-	return dm_tm_unlock(ll->tm, block);
+	dm_tm_unlock(ll->tm, block);
+
+	return 0;
 }
 
 static dm_block_t metadata_ll_max_entries(struct ll_disk *ll)
@@ -590,7 +588,9 @@ static int metadata_ll_commit(struct ll_
 	memcpy(dm_block_data(b), &ll->mi_le, sizeof(ll->mi_le));
 	ll->bitmap_root = dm_block_location(b);
 
-	return dm_tm_unlock(ll->tm, b);
+	dm_tm_unlock(ll->tm, b);
+
+	return 0;
 }
 
 int sm_ll_new_metadata(struct ll_disk *ll, struct dm_transaction_manager *tm)
Index: linux-4.3-rc6/drivers/md/persistent-data/dm-transaction-manager.c
===================================================================
--- linux-4.3-rc6.orig/drivers/md/persistent-data/dm-transaction-manager.c	2015-10-22 19:04:42.000000000 +0200
+++ linux-4.3-rc6/drivers/md/persistent-data/dm-transaction-manager.c	2015-10-22 19:04:59.000000000 +0200
@@ -342,9 +342,9 @@ int dm_tm_read_lock(struct dm_transactio
 }
 EXPORT_SYMBOL_GPL(dm_tm_read_lock);
 
-int dm_tm_unlock(struct dm_transaction_manager *tm, struct dm_block *b)
+void dm_tm_unlock(struct dm_transaction_manager *tm, struct dm_block *b)
 {
-	return dm_bm_unlock(b);
+	dm_bm_unlock(b);
 }
 EXPORT_SYMBOL_GPL(dm_tm_unlock);
 
Index: linux-4.3-rc6/drivers/md/persistent-data/dm-transaction-manager.h
===================================================================
--- linux-4.3-rc6.orig/drivers/md/persistent-data/dm-transaction-manager.h	2015-10-22 19:05:01.000000000 +0200
+++ linux-4.3-rc6/drivers/md/persistent-data/dm-transaction-manager.h	2015-10-22 19:05:08.000000000 +0200
@@ -94,7 +94,7 @@ int dm_tm_read_lock(struct dm_transactio
 		    struct dm_block_validator *v,
 		    struct dm_block **result);
 
-int dm_tm_unlock(struct dm_transaction_manager *tm, struct dm_block *b);
+void dm_tm_unlock(struct dm_transaction_manager *tm, struct dm_block *b);
 
 /*
  * Functions for altering the reference count of a block directly.
Index: linux-4.3-rc6/drivers/md/persistent-data/dm-btree.c
===================================================================
--- linux-4.3-rc6.orig/drivers/md/persistent-data/dm-btree.c	2015-10-22 19:11:29.000000000 +0200
+++ linux-4.3-rc6/drivers/md/persistent-data/dm-btree.c	2015-10-22 19:11:37.000000000 +0200
@@ -141,7 +141,9 @@ int dm_btree_empty(struct dm_btree_info 
 	n->header.value_size = cpu_to_le32(info->value_type.size);
 
 	*root = dm_block_location(b);
-	return unlock_block(info, b);
+	unlock_block(info, b);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(dm_btree_empty);
 
