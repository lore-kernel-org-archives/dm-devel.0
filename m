From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 23/24] dm cache: add cache block invalidation API
Date: Thu, 24 Oct 2013 14:30:36 -0400
Message-ID: <1382639437-27007-24-git-send-email-snitzer@redhat.com>
References: <1382639437-27007-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1382639437-27007-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Morgan Mears <morgan.mears@netapp.com>, Heinz Mauelshagen <heinzm@redhat.com>, Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

This commit introduces an invalidation API to dm-cache in order to allow
for full functionality of the stackable "era" policy shim.

It adds:
- a core target worker function, invalidate_mappings(), to invalidate a
  range of blocks being requested by a message
- a respective policy_invalidate_mapping() function to carry out a cache
  block invalidation

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-cache-policy-cleaner.c  |   8 +-
 drivers/md/dm-cache-policy-internal.h |  16 ++--
 drivers/md/dm-cache-policy-mq.c       |  85 ++++++++++++------
 drivers/md/dm-cache-policy-trc.c      |  16 +++-
 drivers/md/dm-cache-policy.h          |  46 +++++++++-
 drivers/md/dm-cache-shim-utils.c      |  15 +++-
 drivers/md/dm-cache-target.c          | 165 ++++++++++++++++++++++++++++++++--
 7 files changed, 297 insertions(+), 54 deletions(-)

diff --git a/drivers/md/dm-cache-policy-cleaner.c b/drivers/md/dm-cache-policy-cleaner.c
index 7e5983c..e6273bb 100644
--- a/drivers/md/dm-cache-policy-cleaner.c
+++ b/drivers/md/dm-cache-policy-cleaner.c
@@ -243,7 +243,7 @@ static void __set_clear_dirty(struct dm_cache_policy *pe, dm_oblock_t oblock, bo
 	}
 }
 
-static void wb_set_dirty(struct dm_cache_policy *pe, dm_oblock_t oblock)
+static int wb_set_dirty(struct dm_cache_policy *pe, dm_oblock_t oblock)
 {
 	struct policy *p = to_policy(pe);
 	unsigned long flags;
@@ -251,9 +251,11 @@ static void wb_set_dirty(struct dm_cache_policy *pe, dm_oblock_t oblock)
 	spin_lock_irqsave(&p->lock, flags);
 	__set_clear_dirty(pe, oblock, true);
 	spin_unlock_irqrestore(&p->lock, flags);
+
+	return 0;
 }
 
-static void wb_clear_dirty(struct dm_cache_policy *pe, dm_oblock_t oblock)
+static int wb_clear_dirty(struct dm_cache_policy *pe, dm_oblock_t oblock)
 {
 	struct policy *p = to_policy(pe);
 	unsigned long flags;
@@ -261,6 +263,8 @@ static void wb_clear_dirty(struct dm_cache_policy *pe, dm_oblock_t oblock)
 	spin_lock_irqsave(&p->lock, flags);
 	__set_clear_dirty(pe, oblock, false);
 	spin_unlock_irqrestore(&p->lock, flags);
+
+	return 0;
 }
 
 static void add_cache_entry(struct policy *p, struct wb_cache_entry *e)
diff --git a/drivers/md/dm-cache-policy-internal.h b/drivers/md/dm-cache-policy-internal.h
index 996b2b5..4245a38 100644
--- a/drivers/md/dm-cache-policy-internal.h
+++ b/drivers/md/dm-cache-policy-internal.h
@@ -27,16 +27,14 @@ static inline int policy_lookup(struct dm_cache_policy *p, dm_oblock_t oblock, d
 	return p->lookup(p, oblock, cblock);
 }
 
-static inline void policy_set_dirty(struct dm_cache_policy *p, dm_oblock_t oblock)
+static inline int policy_set_dirty(struct dm_cache_policy *p, dm_oblock_t oblock)
 {
-	if (p->set_dirty)
-		p->set_dirty(p, oblock);
+	return p->set_dirty ? p->set_dirty(p, oblock) : -EINVAL;
 }
 
-static inline void policy_clear_dirty(struct dm_cache_policy *p, dm_oblock_t oblock)
+static inline int policy_clear_dirty(struct dm_cache_policy *p, dm_oblock_t oblock)
 {
-	if (p->clear_dirty)
-		p->clear_dirty(p, oblock);
+	return p->clear_dirty ? p->clear_dirty(p, oblock) : -EINVAL;
 }
 
 static inline int policy_load_mapping(struct dm_cache_policy *p,
@@ -70,6 +68,12 @@ static inline void policy_force_mapping(struct dm_cache_policy *p,
 	return p->force_mapping(p, current_oblock, new_oblock);
 }
 
+static inline int policy_invalidate_mapping(struct dm_cache_policy *p,
+					    dm_oblock_t *oblock, dm_cblock_t *cblock)
+{
+	return p->invalidate_mapping ? p->invalidate_mapping(p, oblock, cblock) : -EINVAL;
+}
+
 static inline dm_cblock_t policy_residency(struct dm_cache_policy *p)
 {
 	return p->residency(p);
diff --git a/drivers/md/dm-cache-policy-mq.c b/drivers/md/dm-cache-policy-mq.c
index 9f2589e..88f3bc0e 100644
--- a/drivers/md/dm-cache-policy-mq.c
+++ b/drivers/md/dm-cache-policy-mq.c
@@ -994,16 +994,18 @@ static int mq_lookup(struct dm_cache_policy *p, dm_oblock_t oblock, dm_cblock_t
 }
 
 // FIXME: can __mq_set_clear_dirty block?
-static void __mq_set_clear_dirty(struct dm_cache_policy *p, dm_oblock_t oblock, bool set)
+static int __mq_set_clear_dirty(struct dm_cache_policy *p, dm_oblock_t oblock, bool set)
 {
+	int r = 0;
 	struct mq_policy *mq = to_mq_policy(p);
 	struct entry *e;
 
 	mutex_lock(&mq->lock);
 	e = hash_lookup(mq, oblock);
-	if (!e)
+	if (!e) {
+		r = -ENOENT;
 		DMWARN("__mq_set_clear_dirty called for a block that isn't in the cache");
-	else {
+	} else {
 		BUG_ON(!e->in_cache);
 
 		del(mq, e);
@@ -1011,16 +1013,18 @@ static void __mq_set_clear_dirty(struct dm_cache_policy *p, dm_oblock_t oblock,
 		push(mq, e);
 	}
 	mutex_unlock(&mq->lock);
+
+	return r;
 }
 
-static void mq_set_dirty(struct dm_cache_policy *p, dm_oblock_t oblock)
+static int mq_set_dirty(struct dm_cache_policy *p, dm_oblock_t oblock)
 {
-	__mq_set_clear_dirty(p, oblock, true);
+	return __mq_set_clear_dirty(p, oblock, true);
 }
 
-static void mq_clear_dirty(struct dm_cache_policy *p, dm_oblock_t oblock)
+static int mq_clear_dirty(struct dm_cache_policy *p, dm_oblock_t oblock)
 {
-	__mq_set_clear_dirty(p, oblock, false);
+	return __mq_set_clear_dirty(p, oblock, false);
 }
 
 static int mq_load_mapping(struct dm_cache_policy *p,
@@ -1082,23 +1086,40 @@ static int mq_walk_mappings(struct dm_cache_policy *p, policy_walk_fn fn,
 	return r;
 }
 
-static void mq_remove_mapping(struct dm_cache_policy *p, dm_oblock_t oblock)
+static int __remove_mapping(struct mq_policy *mq,
+			    dm_oblock_t oblock, dm_cblock_t *cblock)
 {
-	struct mq_policy *mq = to_mq_policy(p);
 	struct entry *e;
 
-	mutex_lock(&mq->lock);
-
 	e = hash_lookup(mq, oblock);
 
-	BUG_ON(!e || !e->in_cache);
+	if (e && e->in_cache) {
+		del(mq, e);
+		e->in_cache = false;
+		e->dirty = false;
 
-	del(mq, e);
-	e->in_cache = false;
-	e->dirty = false;
-	push(mq, e);
+		if (cblock) {
+			*cblock = e->cblock;
+			list_add(&e->list, &mq->free);
+		} else
+			push(mq, e);
+
+		return 0;
+	}
+
+	return -ENOENT;
+}
+
+static void mq_remove_mapping(struct dm_cache_policy *p, dm_oblock_t oblock)
+{
+	int r;
+	struct mq_policy *mq = to_mq_policy(p);
 
+	mutex_lock(&mq->lock);
+	r = __remove_mapping(mq, oblock, NULL);
 	mutex_unlock(&mq->lock);
+
+	BUG_ON(r);
 }
 
 static int __mq_writeback_work(struct mq_policy *mq, dm_oblock_t *oblock,
@@ -1130,17 +1151,17 @@ static int mq_writeback_work(struct dm_cache_policy *p, dm_oblock_t *oblock,
 	return r;
 }
 
-static void force_mapping(struct mq_policy *mq,
-			  dm_oblock_t current_oblock, dm_oblock_t new_oblock)
+static void __force_mapping(struct mq_policy *mq,
+			    dm_oblock_t current_oblock, dm_oblock_t new_oblock)
 {
 	struct entry *e = hash_lookup(mq, current_oblock);
 
-	BUG_ON(!e || !e->in_cache);
-
-	del(mq, e);
-	e->oblock = new_oblock;
-	e->dirty = true;
-	push(mq, e);
+	if (e && e->in_cache) {
+		del(mq, e);
+		e->oblock = new_oblock;
+		e->dirty = true;
+		push(mq, e);
+	}
 }
 
 static void mq_force_mapping(struct dm_cache_policy *p,
@@ -1149,10 +1170,23 @@ static void mq_force_mapping(struct dm_cache_policy *p,
 	struct mq_policy *mq = to_mq_policy(p);
 
 	mutex_lock(&mq->lock);
-	force_mapping(mq, current_oblock, new_oblock);
+	__force_mapping(mq, current_oblock, new_oblock);
 	mutex_unlock(&mq->lock);
 }
 
+static int mq_invalidate_mapping(struct dm_cache_policy *p,
+				 dm_oblock_t *oblock, dm_cblock_t *cblock)
+{
+	int r;
+	struct mq_policy *mq = to_mq_policy(p);
+
+	mutex_lock(&mq->lock);
+	r = __remove_mapping(mq, *oblock, cblock);
+	mutex_unlock(&mq->lock);
+
+	return r;
+}
+
 static dm_cblock_t mq_residency(struct dm_cache_policy *p)
 {
 	struct mq_policy *mq = to_mq_policy(p);
@@ -1218,6 +1252,7 @@ static void init_policy_functions(struct mq_policy *mq)
 	mq->policy.remove_mapping = mq_remove_mapping;
 	mq->policy.writeback_work = mq_writeback_work;
 	mq->policy.force_mapping = mq_force_mapping;
+	mq->policy.invalidate_mapping = mq_invalidate_mapping;
 	mq->policy.residency = mq_residency;
 	mq->policy.tick = mq_tick;
 	mq->policy.emit_config_values = mq_emit_config_values;
diff --git a/drivers/md/dm-cache-policy-trc.c b/drivers/md/dm-cache-policy-trc.c
index 8b16061..83bc8c3 100644
--- a/drivers/md/dm-cache-policy-trc.c
+++ b/drivers/md/dm-cache-policy-trc.c
@@ -87,16 +87,16 @@ static int trc_lookup(struct dm_cache_policy *p, dm_oblock_t oblock,
 	return policy_lookup(p->child, oblock, cblock);
 }
 
-static void trc_set_dirty(struct dm_cache_policy *p, dm_oblock_t oblock)
+static int trc_set_dirty(struct dm_cache_policy *p, dm_oblock_t oblock)
 {
 	DM_TRC_OUT(DM_TRC_LEV_NORMAL, p, "%p %llu", p, oblock);
-	policy_set_dirty(p->child, oblock);
+	return policy_set_dirty(p->child, oblock);
 }
 
-static void trc_clear_dirty(struct dm_cache_policy *p, dm_oblock_t oblock)
+static int trc_clear_dirty(struct dm_cache_policy *p, dm_oblock_t oblock)
 {
 	DM_TRC_OUT(DM_TRC_LEV_NORMAL, p, "%p %llu", p, oblock);
-	policy_clear_dirty(p->child, oblock);
+	return policy_clear_dirty(p->child, oblock);
 }
 
 static int trc_load_mapping(struct dm_cache_policy *p,
@@ -137,6 +137,13 @@ static void trc_force_mapping(struct dm_cache_policy *p,
 	policy_force_mapping(p->child, old_oblock, new_oblock);
 }
 
+static int trc_invalidate_mapping(struct dm_cache_policy *p,
+				  dm_oblock_t *oblock, dm_cblock_t *cblock)
+{
+	DM_TRC_OUT(DM_TRC_LEV_NORMAL, p, "%p %llu %u", p, from_oblock(*oblock), from_cblock(*cblock));
+	return policy_invalidate_mapping(p->child, oblock, cblock);
+}
+
 static dm_cblock_t trc_residency(struct dm_cache_policy *p)
 {
 	DM_TRC_OUT(DM_TRC_LEV_NORMAL, p, "%p", p);
@@ -191,6 +198,7 @@ static void init_policy_functions(struct trc_policy *trc)
 	trc->policy.remove_mapping = trc_remove_mapping;
 	trc->policy.writeback_work = trc_writeback_work;
 	trc->policy.force_mapping = trc_force_mapping;
+	trc->policy.invalidate_mapping = trc_invalidate_mapping;
 	trc->policy.residency = trc_residency;
 	trc->policy.tick = trc_tick;
 	trc->policy.emit_config_values = trc_emit_config_values;
diff --git a/drivers/md/dm-cache-policy.h b/drivers/md/dm-cache-policy.h
index 83ec775..33ddb69 100644
--- a/drivers/md/dm-cache-policy.h
+++ b/drivers/md/dm-cache-policy.h
@@ -138,10 +138,21 @@ struct dm_cache_policy {
 	int (*lookup)(struct dm_cache_policy *p, dm_oblock_t oblock, dm_cblock_t *cblock);
 
 	/*
-	 * oblock must be a mapped block.  Must not block.
+	 * set/clear a blocks dirty state.
+	 *
+	 * oblock is the block we want to change state for.  Must not block.
+	 *
+	 * Returns:
+	 *
+	 * 0       if block is in cache _and_ set/clear respectively succeded
+	 *
+	 * -EINVAL if block is in cache _but_ block was already set to dirty
+	 *  	   on a set call / clean on a clean call
+	 *
+	 * -ENOENT if block is not in cache
 	 */
-	void (*set_dirty)(struct dm_cache_policy *p, dm_oblock_t oblock);
-	void (*clear_dirty)(struct dm_cache_policy *p, dm_oblock_t oblock);
+	int (*set_dirty)(struct dm_cache_policy *p, dm_oblock_t oblock);
+	int (*clear_dirty)(struct dm_cache_policy *p, dm_oblock_t oblock);
 
 	/*
 	 * Called when a cache target is first created.  Used to load a
@@ -161,8 +172,35 @@ struct dm_cache_policy {
 	void (*force_mapping)(struct dm_cache_policy *p, dm_oblock_t current_oblock,
 			      dm_oblock_t new_oblock);
 
-	int (*writeback_work)(struct dm_cache_policy *p, dm_oblock_t *oblock, dm_cblock_t *cblock);
+	/*
+	 * Invalidate mapping for an origin block.
+	 *
+	 * Returns:
+	 *
+	 * 0 and @cblock,@oblock: if mapped, the policy returns the cache block
+	 *			  and optionally changes the original block (e.g. era)
+	 *
+	 * -EINVAL: invalidation not supported
+	 *
+	 * -ENOENT: no entry for @oblock in the cache
+	 *
+	 * -ENODATA: all possible invalidation requests processed
+	 *
+	 * May return a _different_ oblock than the requested one
+	 * to allow the policy to rule which block to invalidate (e.g. era).
+	 */
+	int (*invalidate_mapping)(struct dm_cache_policy *p, dm_oblock_t *oblock, dm_cblock_t *cblock);
 
+	/*
+	 * Provide a dirty block to be written back by the core target.
+	 *
+	 * Returns:
+	 *
+	 * 0 and @cblock,@oblock: block to write back provided
+	 *
+	 * -ENODATA: no dirty blocks available
+	 */
+	int (*writeback_work)(struct dm_cache_policy *p, dm_oblock_t *oblock, dm_cblock_t *cblock);
 
 	/*
 	 * How full is the cache?
diff --git a/drivers/md/dm-cache-shim-utils.c b/drivers/md/dm-cache-shim-utils.c
index 4151883..8b8d5d5 100644
--- a/drivers/md/dm-cache-shim-utils.c
+++ b/drivers/md/dm-cache-shim-utils.c
@@ -76,14 +76,14 @@ static int shim_lookup(struct dm_cache_policy *p, dm_oblock_t oblock,
 	return policy_lookup(p->child, oblock, cblock);
 }
 
-static void shim_set_dirty(struct dm_cache_policy *p, dm_oblock_t oblock)
+static int shim_set_dirty(struct dm_cache_policy *p, dm_oblock_t oblock)
 {
-	policy_set_dirty(p->child, oblock);
+	return policy_set_dirty(p->child, oblock);
 }
 
-static void shim_clear_dirty(struct dm_cache_policy *p, dm_oblock_t oblock)
+static int shim_clear_dirty(struct dm_cache_policy *p, dm_oblock_t oblock)
 {
-	policy_clear_dirty(p->child, oblock);
+	return policy_clear_dirty(p->child, oblock);
 }
 
 static int shim_load_mapping(struct dm_cache_policy *p,
@@ -130,6 +130,12 @@ static void shim_force_mapping(struct dm_cache_policy *p,
 	policy_force_mapping(p->child, current_oblock, new_oblock);
 }
 
+static int shim_invalidate_mapping(struct dm_cache_policy *p,
+				   dm_oblock_t *oblock, dm_cblock_t *cblock)
+{
+	return policy_invalidate_mapping(p->child, oblock, cblock);
+}
+
 static dm_cblock_t shim_residency(struct dm_cache_policy *p)
 {
 	return policy_residency(p->child);
@@ -164,6 +170,7 @@ void dm_cache_shim_utils_init_shim_policy(struct dm_cache_policy *p)
 	p->remove_mapping = shim_remove_mapping;
 	p->writeback_work = shim_writeback_work;
 	p->force_mapping = shim_force_mapping;
+	p->invalidate_mapping = shim_invalidate_mapping;
 	p->residency = shim_residency;
 	p->tick = shim_tick;
 	p->emit_config_values = shim_emit_config_values;
diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 502ae64..e3f474a 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -155,6 +155,12 @@ struct cache {
 	dm_cblock_t cache_size;
 
 	/*
+	 * Original block begin/end range to invalidate any mapped cache entries for.
+	 */
+	dm_oblock_t begin_invalidate;
+	dm_oblock_t end_invalidate;
+
+	/*
 	 * Fields for converting from sectors to blocks.
 	 */
 	uint32_t sectors_per_block;
@@ -210,6 +216,7 @@ struct cache {
 	bool need_tick_bio:1;
 	bool sized:1;
 	bool quiescing:1;
+	bool invalidate:1;
 	bool commit_requested:1;
 	bool loaded_mappings:1;
 	bool loaded_discards:1;
@@ -251,6 +258,7 @@ struct dm_cache_migration {
 	bool writeback:1;
 	bool demote:1;
 	bool promote:1;
+	bool invalidate:1;
 
 	struct dm_bio_prison_cell *old_ocell;
 	struct dm_bio_prison_cell *new_ocell;
@@ -841,6 +849,7 @@ static void migration_success_pre_commit(struct dm_cache_migration *mg)
 			cleanup_migration(mg);
 			return;
 		}
+
 	} else {
 		if (dm_cache_insert_mapping(cache->cmd, mg->cblock, mg->new_oblock)) {
 			DMWARN_LIMIT("promotion failed; couldn't update on disk metadata");
@@ -875,8 +884,11 @@ static void migration_success_post_commit(struct dm_cache_migration *mg)
 			list_add_tail(&mg->list, &cache->quiesced_migrations);
 			spin_unlock_irqrestore(&cache->lock, flags);
 
-		} else
+		} else {
+			if (mg->invalidate)
+				policy_remove_mapping(cache->policy, mg->old_oblock);
 			cleanup_migration(mg);
+		}
 
 	} else {
 		cell_defer(cache, mg->new_ocell, true);
@@ -1036,6 +1048,7 @@ static void promote(struct cache *cache, struct prealloc *structs,
 	mg->writeback = false;
 	mg->demote = false;
 	mg->promote = true;
+	mg->invalidate = false;
 	mg->cache = cache;
 	mg->new_oblock = oblock;
 	mg->cblock = cblock;
@@ -1057,6 +1070,7 @@ static void writeback(struct cache *cache, struct prealloc *structs,
 	mg->writeback = true;
 	mg->demote = false;
 	mg->promote = false;
+	mg->invalidate = false;
 	mg->cache = cache;
 	mg->old_oblock = oblock;
 	mg->cblock = cblock;
@@ -1080,6 +1094,7 @@ static void demote_then_promote(struct cache *cache, struct prealloc *structs,
 	mg->writeback = false;
 	mg->demote = true;
 	mg->promote = true;
+	mg->invalidate = false;
 	mg->cache = cache;
 	mg->old_oblock = old_oblock;
 	mg->new_oblock = new_oblock;
@@ -1106,6 +1121,7 @@ static void invalidate(struct cache *cache, struct prealloc *structs,
 	mg->writeback = false;
 	mg->demote = true;
 	mg->promote = false;
+	mg->invalidate = true;
 	mg->cache = cache;
 	mg->old_oblock = oblock;
 	mg->cblock = cblock;
@@ -1324,15 +1340,17 @@ static int need_commit_due_to_time(struct cache *cache)
 
 static int commit_if_needed(struct cache *cache)
 {
+	int r = 0;
+
 	if ((cache->commit_requested || need_commit_due_to_time(cache)) &&
 	    dm_cache_changed_this_transaction(cache->cmd)) {
 		atomic_inc(&cache->stats.commit_count);
-		cache->last_commit_jiffies = jiffies;
 		cache->commit_requested = false;
-		return dm_cache_commit(cache->cmd, false);
+		r = dm_cache_commit(cache->cmd, false);
+		cache->last_commit_jiffies = jiffies;
 	}
 
-	return 0;
+	return r;
 }
 
 static void process_deferred_bios(struct cache *cache)
@@ -1497,6 +1515,60 @@ static void requeue_deferred_io(struct cache *cache)
 		bio_endio(bio, DM_ENDIO_REQUEUE);
 }
 
+static void invalidate_mappings(struct cache *cache)
+{
+	dm_oblock_t oblock, end;
+	unsigned long long count = 0;
+
+	smp_rmb();
+
+	if (!cache->invalidate)
+		return;
+
+	oblock = cache->begin_invalidate;
+	end    = to_oblock(from_oblock(cache->end_invalidate) + 1);
+
+	while (oblock != end) {
+		int r;
+		dm_cblock_t cblock;
+		dm_oblock_t given_oblock = oblock;
+
+		r = policy_invalidate_mapping(cache->policy, &given_oblock, &cblock);
+		/*
+		 * Policy either doesn't suport invalidation (yet) or
+		 * doesn't offer any more blocks to invalidate (e.g. era).
+		  */
+		if (r == -EINVAL) {
+			DMWARN("policy doesn't support invalidation (yet).");
+			break;
+		}
+
+		if (r == -ENODATA)
+			break;
+
+		else if (!r) {
+			if (dm_cache_remove_mapping(cache->cmd, cblock)) {
+				DMWARN_LIMIT("invalidation failed; couldn't update on disk metadata");
+				r = policy_load_mapping(cache->policy, given_oblock, cblock, NULL, false);
+				BUG_ON(r);
+
+			} else {
+				/*
+				 * FIXME: we are cautious and keep this even though all
+				 *        blocks _should_ be clean in passthrough mode.
+				 */
+				clear_dirty(cache, given_oblock, cblock);
+				cache->commit_requested = true;
+				count++;
+			}
+		}
+
+		oblock = to_oblock(from_oblock(oblock) + 1);
+	}
+
+	cache->invalidate = false;
+}
+
 static int more_work(struct cache *cache)
 {
 	if (is_quiescing(cache))
@@ -1509,7 +1581,8 @@ static int more_work(struct cache *cache)
 			!bio_list_empty(&cache->deferred_writethrough_bios) ||
 			!list_empty(&cache->quiesced_migrations) ||
 			!list_empty(&cache->completed_migrations) ||
-			!list_empty(&cache->need_commit_migrations);
+			!list_empty(&cache->need_commit_migrations) ||
+			cache->invalidate;
 }
 
 static void do_worker(struct work_struct *ws)
@@ -1527,6 +1600,8 @@ static void do_worker(struct work_struct *ws)
 
 		process_deferred_writethrough_bios(cache);
 
+		invalidate_mappings(cache);
+
 		if (commit_if_needed(cache)) {
 			process_deferred_flush_bios(cache, false);
 
@@ -2181,6 +2256,7 @@ static int cache_create(struct cache_args *ca, struct cache **result)
 	cache->need_tick_bio = true;
 	cache->sized = false;
 	cache->quiescing = false;
+	cache->invalidate = false;
 	cache->commit_requested = false;
 	cache->loaded_mappings = false;
 	cache->loaded_discards = false;
@@ -2702,8 +2778,73 @@ err:
 	DMEMIT("Error");
 }
 
+static int get_origin_block(struct cache *cache, const char *what,
+			    char *arg, unsigned long long *val)
+{
+	unsigned long long last_block = from_oblock(cache->origin_blocks) - 1;
+
+	if (!strcmp(arg, "begin"))
+		*val = 0;
+
+	else if (!strcmp(arg, "end"))
+		*val = last_block;
+
+	else if (kstrtoull(arg, 10, val)) {
+		DMERR("%s origin block invalid", what);
+		return -EINVAL;
+
+	} else if (*val > last_block) {
+		*val = last_block;
+		DMERR("%s origin block adjusted to EOD=%llu", what, *val);
+	}
+
+	return 0;
+}
+
+static int set_invalidate_mappings(struct cache *cache, char **argv)
+{
+	unsigned long long begin, end;
+
+	if (strcasecmp(argv[0], "invalidate_mappings"))
+		return -EINVAL;
+
+	if (!passthrough_mode(&cache->features)) {
+		DMERR("cache has to be in passthrough mode for invalidation!");
+		return -EPERM;
+	}
+
+	if (cache->invalidate) {
+		DMERR("cache is processing invalidation");
+		return -EPERM;
+	}
+
+	if (get_origin_block(cache, "begin", argv[1], &begin) ||
+	    get_origin_block(cache, "end", argv[2], &end))
+		return -EINVAL;
+
+	if (begin > end) {
+		DMERR("begin origin block > end origin block");
+		return -EINVAL;
+	}
+
+	/*
+	 * Pass begin and end origin blocks to the worker and wake it.
+	 */
+	cache->begin_invalidate = to_oblock(begin);
+	cache->end_invalidate = to_oblock(end);
+	cache->invalidate = true;
+	smp_wmb();
+
+	wake_worker(cache);
+
+	return 0;
+}
+
 /*
- * Supports <key> <value>.
+ * Supports
+ *	"<key> <value>"
+ * and
+ *     "invalidate_mappings <begin_origin_block> <end_origin_block>".
  *
  * The key migration_threshold is supported by the cache target core.
  */
@@ -2711,10 +2852,16 @@ static int cache_message(struct dm_target *ti, unsigned argc, char **argv)
 {
 	struct cache *cache = ti->private;
 
-	if (argc != 2)
-		return -EINVAL;
+	switch (argc) {
+	case 2:
+		return set_config_value(cache, argv[0], argv[1]);
 
-	return set_config_value(cache, argv[0], argv[1]);
+	case 3:
+		return set_invalidate_mappings(cache, argv);
+
+	default:
+		return -EINVAL;
+	}
 }
 
 static int cache_iterate_devices(struct dm_target *ti,
-- 
1.8.1.4
