From: Mike Snitzer <snitzer@redhat.com>
Subject: [dm-4.6 PATCH v2 11/15] dm mpath: use blk-mq pdu for
	per-request 'struct dm_mpath_io'
Date: Sun,  7 Feb 2016 10:53:33 -0500
Message-ID: <1454860417-3203-12-git-send-email-snitzer@redhat.com>
References: <1454860417-3203-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1454860417-3203-1-git-send-email-snitzer@redhat.com>
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
Cc: Mike Snitzer <snitzer@redhat.com>, Sagi Grimberg <sagig@dev.mellanox.co.il>
List-Id: dm-devel.ids

Allow the multipath target to avoid making small allocations for each
'struct dm_mpath_io' that is needed for each request.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-mpath.c | 40 +++++++++++++++++++++++++++++-----------
 1 file changed, 29 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 3ddaa11..021ea39 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -181,10 +181,9 @@ static void free_priority_group(struct priority_group *pg,
 	kfree(pg);
 }
 
-static struct multipath *alloc_multipath(struct dm_target *ti)
+static struct multipath *alloc_multipath(struct dm_target *ti, bool use_blk_mq)
 {
 	struct multipath *m;
-	unsigned min_ios = dm_get_reserved_rq_based_ios();
 
 	m = kzalloc(sizeof(*m), GFP_KERNEL);
 	if (m) {
@@ -195,11 +194,18 @@ static struct multipath *alloc_multipath(struct dm_target *ti)
 		INIT_WORK(&m->trigger_event, trigger_event);
 		init_waitqueue_head(&m->pg_init_wait);
 		mutex_init(&m->work_mutex);
-		m->mpio_pool = mempool_create_slab_pool(min_ios, _mpio_cache);
-		if (!m->mpio_pool) {
-			kfree(m);
-			return NULL;
+
+		m->mpio_pool = NULL;
+		if (!use_blk_mq) {
+			unsigned min_ios = dm_get_reserved_rq_based_ios();
+
+			m->mpio_pool = mempool_create_slab_pool(min_ios, _mpio_cache);
+			if (!m->mpio_pool) {
+				kfree(m);
+				return NULL;
+			}
 		}
+
 		m->ti = ti;
 		ti->private = m;
 	}
@@ -226,6 +232,13 @@ static int set_mapinfo(struct multipath *m, union map_info *info)
 {
 	struct dm_mpath_io *mpio;
 
+	if (!m->mpio_pool) {
+		/* Use blk-mq pdu memory requested via per_io_data_size */
+		mpio = info->ptr;
+		memset(mpio, 0, sizeof(*mpio));
+		return mpio;
+	}
+
 	mpio = mempool_alloc(m->mpio_pool, GFP_ATOMIC);
 	if (!mpio)
 		return -ENOMEM;
@@ -238,10 +251,13 @@ static int set_mapinfo(struct multipath *m, union map_info *info)
 
 static void clear_mapinfo(struct multipath *m, union map_info *info)
 {
-	struct dm_mpath_io *mpio = info->ptr;
+	/* Only needed for non blk-mq */
+	if (m->mpio_pool) {
+		struct dm_mpath_io *mpio = info->ptr;
 
-	info->ptr = NULL;
-	mempool_free(mpio, m->mpio_pool);
+		info->ptr = NULL;
+		mempool_free(mpio, m->mpio_pool);
+	}
 }
 
 /*-----------------------------------------------
@@ -428,7 +444,6 @@ static int __multipath_map(struct dm_target *ti, struct request *clone,
 					   rq_data_dir(rq), GFP_ATOMIC);
 		if (IS_ERR(*__clone)) {
 			/* ENOMEM, requeue */
-			clear_mapinfo(m, map_context);
 			return r;
 		}
 		(*__clone)->bio = (*__clone)->biotail = NULL;
@@ -820,11 +835,12 @@ static int multipath_ctr(struct dm_target *ti, unsigned int argc,
 	struct dm_arg_set as;
 	unsigned pg_count = 0;
 	unsigned next_pg_num;
+	bool use_blk_mq = dm_use_blk_mq(dm_table_get_md(ti->table));
 
 	as.argc = argc;
 	as.argv = argv;
 
-	m = alloc_multipath(ti);
+	m = alloc_multipath(ti, use_blk_mq);
 	if (!m) {
 		ti->error = "can't allocate multipath";
 		return -EINVAL;
@@ -880,6 +896,8 @@ static int multipath_ctr(struct dm_target *ti, unsigned int argc,
 	ti->num_flush_bios = 1;
 	ti->num_discard_bios = 1;
 	ti->num_write_same_bios = 1;
+	if (use_blk_mq)
+		ti->per_io_data_size = sizeof(struct dm_mpath_io);
 
 	return 0;
 
-- 
2.5.4 (Apple Git-61)
