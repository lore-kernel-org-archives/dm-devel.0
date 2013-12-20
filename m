From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-3.14 07/20] dm thin: use bool rather than
	unsigned for flags in structures
Date: Fri, 20 Dec 2013 18:37:20 -0500
Message-ID: <1387582653-13647-8-git-send-email-snitzer@redhat.com>
References: <1387582653-13647-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1387582653-13647-1-git-send-email-snitzer@redhat.com>
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
List-Id: dm-devel.ids

Also, move 'err' member in dm_thin_new_mapping structure to eliminate 4
byte hole (reduces size from 88 bytes to 80).

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin-metadata.h |  2 +-
 drivers/md/dm-thin.c          | 26 +++++++++++++++-----------
 2 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm-thin-metadata.h b/drivers/md/dm-thin-metadata.h
index 2edf5db..9a36856 100644
--- a/drivers/md/dm-thin-metadata.h
+++ b/drivers/md/dm-thin-metadata.h
@@ -131,7 +131,7 @@ dm_thin_id dm_thin_dev_id(struct dm_thin_device *td);
 
 struct dm_thin_lookup_result {
 	dm_block_t block;
-	unsigned shared:1;
+	bool shared:1;
 };
 
 /*
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 51e656a..70b02fd 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -509,16 +509,16 @@ static void remap_and_issue(struct thin_c *tc, struct bio *bio,
 struct dm_thin_new_mapping {
 	struct list_head list;
 
-	unsigned quiesced:1;
-	unsigned prepared:1;
-	unsigned pass_discard:1;
-	unsigned definitely_not_shared:1;
+	bool quiesced:1;
+	bool prepared:1;
+	bool pass_discard:1;
+	bool definitely_not_shared:1;
 
+	int err;
 	struct thin_c *tc;
 	dm_block_t virt_block;
 	dm_block_t data_block;
 	struct dm_bio_prison_cell *cell, *cell2;
-	int err;
 
 	/*
 	 * If the bio covers the whole area of a block then we can avoid
@@ -549,7 +549,7 @@ static void copy_complete(int read_err, unsigned long write_err, void *context)
 	m->err = read_err || write_err ? -EIO : 0;
 
 	spin_lock_irqsave(&pool->lock, flags);
-	m->prepared = 1;
+	m->prepared = true;
 	__maybe_add_mapping(m);
 	spin_unlock_irqrestore(&pool->lock, flags);
 }
@@ -564,7 +564,7 @@ static void overwrite_endio(struct bio *bio, int err)
 	m->err = err;
 
 	spin_lock_irqsave(&pool->lock, flags);
-	m->prepared = 1;
+	m->prepared = true;
 	__maybe_add_mapping(m);
 	spin_unlock_irqrestore(&pool->lock, flags);
 }
@@ -766,6 +766,10 @@ static struct dm_thin_new_mapping *get_next_mapping(struct pool *pool)
 
 	memset(m, 0, sizeof(struct dm_thin_new_mapping));
 	INIT_LIST_HEAD(&m->list);
+	m->quiesced = false;
+	m->prepared = false;
+	m->pass_discard = false;
+	m->definitely_not_shared = false;
 	m->bio = NULL;
 
 	pool->next_mapping = NULL;
@@ -788,7 +792,7 @@ static void schedule_copy(struct thin_c *tc, dm_block_t virt_block,
 	m->cell = cell;
 
 	if (!dm_deferred_set_add_work(pool->shared_read_ds, &m->list))
-		m->quiesced = 1;
+		m->quiesced = true;
 
 	/*
 	 * IO to pool_dev remaps to the pool target's data_dev.
@@ -848,8 +852,8 @@ static void schedule_zero(struct thin_c *tc, dm_block_t virt_block,
 	struct pool *pool = tc->pool;
 	struct dm_thin_new_mapping *m = get_next_mapping(pool);
 
-	m->quiesced = 1;
-	m->prepared = 0;
+	m->quiesced = true;
+	m->prepared = false;
 	m->tc = tc;
 	m->virt_block = virt_block;
 	m->data_block = data_block;
@@ -2904,7 +2908,7 @@ static int thin_endio(struct dm_target *ti, struct bio *bio, int err)
 		spin_lock_irqsave(&pool->lock, flags);
 		list_for_each_entry_safe(m, tmp, &work, list) {
 			list_del(&m->list);
-			m->quiesced = 1;
+			m->quiesced = true;
 			__maybe_add_mapping(m);
 		}
 		spin_unlock_irqrestore(&pool->lock, flags);
-- 
1.8.1.4
