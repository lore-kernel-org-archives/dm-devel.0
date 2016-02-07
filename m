From: Mike Snitzer <snitzer@redhat.com>
Subject: [dm-4.6 PATCH v2 12/15] dm mpath: cleanup 'struct
	dm_mpath_io' management code
Date: Sun,  7 Feb 2016 10:53:34 -0500
Message-ID: <1454860417-3203-13-git-send-email-snitzer@redhat.com>
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

Refactor and rename existing interfaces to be more specific and
self-documenting.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-mpath.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 021ea39..612ec57 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -228,30 +228,35 @@ static void free_multipath(struct multipath *m)
 	kfree(m);
 }
 
-static int set_mapinfo(struct multipath *m, union map_info *info)
+static struct dm_mpath_io *get_mpio(union map_info *info)
+{
+	return info->ptr;
+}
+
+static struct dm_mpath_io *set_mpio(struct multipath *m, union map_info *info)
 {
 	struct dm_mpath_io *mpio;
 
 	if (!m->mpio_pool) {
 		/* Use blk-mq pdu memory requested via per_io_data_size */
-		mpio = info->ptr;
+		mpio = get_mpio(info);
 		memset(mpio, 0, sizeof(*mpio));
 		return mpio;
 	}
 
 	mpio = mempool_alloc(m->mpio_pool, GFP_ATOMIC);
 	if (!mpio)
-		return -ENOMEM;
+		return NULL;
 
 	memset(mpio, 0, sizeof(*mpio));
 	info->ptr = mpio;
 
-	return 0;
+	return mpio;
 }
 
-static void clear_mapinfo(struct multipath *m, union map_info *info)
+static void clear_request_fn_mpio(struct multipath *m, union map_info *info)
 {
-	/* Only needed for non blk-mq */
+	/* Only needed for non blk-mq (.request_fn) multipath */
 	if (m->mpio_pool) {
 		struct dm_mpath_io *mpio = info->ptr;
 
@@ -421,11 +426,11 @@ static int __multipath_map(struct dm_target *ti, struct request *clone,
 		goto out_unlock;
 	}
 
-	if (set_mapinfo(m, map_context) < 0)
+	mpio = set_mpio(m, map_context);
+	if (!mpio)
 		/* ENOMEM, requeue */
 		goto out_unlock;
 
-	mpio = map_context->ptr;
 	mpio->pgpath = pgpath;
 	mpio->nr_bytes = nr_bytes;
 
@@ -1309,21 +1314,21 @@ static int multipath_end_io(struct dm_target *ti, struct request *clone,
 			    int error, union map_info *map_context)
 {
 	struct multipath *m = ti->private;
-	struct dm_mpath_io *mpio = map_context->ptr;
+	struct dm_mpath_io *mpio = get_mpio(map_context);
 	struct pgpath *pgpath;
 	struct path_selector *ps;
 	int r;
 
 	BUG_ON(!mpio);
 
-	r  = do_end_io(m, clone, error, mpio);
+	r = do_end_io(m, clone, error, mpio);
 	pgpath = mpio->pgpath;
 	if (pgpath) {
 		ps = &pgpath->pg->ps;
 		if (ps->type->end_io)
 			ps->type->end_io(ps, &pgpath->path, mpio->nr_bytes);
 	}
-	clear_mapinfo(m, map_context);
+	clear_request_fn_mpio(m, map_context);
 
 	return r;
 }
-- 
2.5.4 (Apple Git-61)
