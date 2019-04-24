From: Yufen Yu <yuyufen@huawei.com>
Subject: [PATCH v2] dm mpath: fix missing call of path selector
	type->end_io
Date: Wed, 24 Apr 2019 23:19:05 +0800
Message-ID: <20190424151905.22615-1-yuyufen@huawei.com>
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
To: snitzer@redhat.com, dm-devel@redhat.com
Cc: yuyufen@huawei.com, yi.zhang@huawei.com, ming.lei@redhat.com, mpatocka@redhat.com, houtao1@huawei.com, mwilck@suse.com
List-Id: dm-devel.ids

After commit 396eaf21ee17 ("blk-mq: improve DM's blk-mq IO merging via
blk_insert_cloned_request feedback"), map_request() will requeue the tio
when issued clone request return BLK_STS_RESOURCE or BLK_STS_DEV_RESOURCE.

Thus, if device drive status is error, a tio may be requeued multiple times
until the return value is not DM_MAPIO_REQUEUE. That means type->start_io
may be called multiple tims, while type->end_io just be called when IO
complete.

In fact, even without the commit, setup_clone() fail also can make the
tio requeue and miss call type->end_io.

As servicer-time path selector for example, it selects path based on
in_flight_size, which is increased by st_start_io() and decreased by
st_end_io(). Missing call of end_io can lead to in_flight_size count
error and let the selector make the wrong choice. In addition,
queue-length path selector will also be affected.

To fix the problem, we call type->end_io in ->release_clone_rq before
tio requeue. It pass map_info to ->release_clone_rq() for requeue path,
and pass NULL for the others path.

Fixes: 396eaf21ee17 ("blk-mq: improve DM's blk-mq IO merging via blk_insert_cloned_request feedback")
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Hou Tao <houtao1@huawei.com>
Signed-off-by: Yufen Yu <yuyufen@huawei.com>

---
V2:
 - remove the new added interface ->end_stat() in V1
 - use ->release_clone_rq() to call path selector ->end_io
 - add dm_rq_status to show clone status

V1:
 - https://www.redhat.com/archives/dm-devel/2019-April/msg00148.html
---
 drivers/md/dm-mpath.c         | 20 +++++++++++++++++++-
 drivers/md/dm-rq.c            | 19 ++++++++++++++-----
 drivers/md/dm-target.c        |  4 +++-
 include/linux/device-mapper.h | 13 ++++++++++++-
 4 files changed, 48 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 2ee5e357a0a7..e2f6e9c9363f 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -544,8 +544,26 @@ static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
 	return DM_MAPIO_REMAPPED;
 }
 
-static void multipath_release_clone(struct request *clone)
+static void multipath_release_clone(struct request *clone,
+				union map_info *map_context
+				enum dm_rq_status clone_status)
 {
+	struct dm_mpath_io *mpio;
+	struct pgpath *pgpath;
+
+	if (clone_status != DM_CLONE_RQ_OK && !map_context) {
+		mpio = get_mpio(map_context);
+		pgpath = mpio->pgpath;
+
+		if (pgpath) {
+			struct path_selector *ps = &pgpath->pg->ps;
+
+			if (ps->type->end_io)
+				ps->type->end_io(ps, &pgpath->path,
+						mpio->nr_bytes);
+		}
+	}
+
 	blk_put_request(clone);
 }
 
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index b66745bd08bb..4cf309775d2c 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -168,7 +168,7 @@ static void dm_end_request(struct request *clone, blk_status_t error)
 	struct request *rq = tio->orig;
 
 	blk_rq_unprep_clone(clone);
-	tio->ti->type->release_clone_rq(clone);
+	tio->ti->type->release_clone_rq(clone, NULL, DM_CLONE_RQ_OK);
 
 	rq_end_stats(md, rq);
 	blk_mq_end_request(rq, error);
@@ -201,7 +201,7 @@ static void dm_requeue_original_request(struct dm_rq_target_io *tio, bool delay_
 	rq_end_stats(md, rq);
 	if (tio->clone) {
 		blk_rq_unprep_clone(tio->clone);
-		tio->ti->type->release_clone_rq(tio->clone);
+		tio->ti->type->release_clone_rq(tio->clone, NULL, DM_CLONE_RQ_OK);
 	}
 
 	dm_mq_delay_requeue_request(rq, delay_ms);
@@ -397,8 +397,12 @@ static int map_request(struct dm_rq_target_io *tio)
 		break;
 	case DM_MAPIO_REMAPPED:
 		if (setup_clone(clone, rq, tio, GFP_ATOMIC)) {
-			/* -ENOMEM */
-			ti->type->release_clone_rq(clone);
+			/* -ENOMEM
+			 * For multipath, before requeue, we need to pass tio->info
+			 * to release_clone_rq, avoiding missing call of path sector
+			 * ->end_io.
+			 */
+			ti->type->release_clone_rq(clone, &tio->info, DM_CLONE_RQ_CANCAL);
 			return DM_MAPIO_REQUEUE;
 		}
 
@@ -408,7 +412,12 @@ static int map_request(struct dm_rq_target_io *tio)
 		ret = dm_dispatch_clone_request(clone, rq);
 		if (ret == BLK_STS_RESOURCE || ret == BLK_STS_DEV_RESOURCE) {
 			blk_rq_unprep_clone(clone);
-			tio->ti->type->release_clone_rq(clone);
+			/*
+			 * For multipath, before requeue, we need to pass tio->info
+			 * to release_clone_rq, avoiding missing call of path sector
+			 * ->end_io.
+			 */
+			tio->ti->type->release_clone_rq(clone, &tio->info, DM_CLONE_RQ_CANCAL);
 			tio->clone = NULL;
 			return DM_MAPIO_REQUEUE;
 		}
diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
index 314d17ca6466..fd0962a24a54 100644
--- a/drivers/md/dm-target.c
+++ b/drivers/md/dm-target.c
@@ -136,7 +136,9 @@ static int io_err_clone_and_map_rq(struct dm_target *ti, struct request *rq,
 	return DM_MAPIO_KILL;
 }
 
-static void io_err_release_clone_rq(struct request *clone)
+static void io_err_release_clone_rq(struct request *clone,
+				union map_info *map_context,
+				enum dm_rq_status clone_status)
 {
 }
 
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index b0672756d056..9b9ab762a992 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -31,6 +31,15 @@ enum dm_queue_mode {
 	DM_TYPE_NVME_BIO_BASED	 = 4,
 };
 
+/*
+ * clone request status
+ */
+enum dm_rq_status {
+	DM_CLONE_RQ_OK,
+	DM_CLONE_RQ_CANCAL,
+	DM_CLONE_RQ_MAX,
+};
+
 typedef enum { STATUSTYPE_INFO, STATUSTYPE_TABLE } status_type_t;
 
 union map_info {
@@ -62,7 +71,9 @@ typedef int (*dm_clone_and_map_request_fn) (struct dm_target *ti,
 					    struct request *rq,
 					    union map_info *map_context,
 					    struct request **clone);
-typedef void (*dm_release_clone_request_fn) (struct request *clone);
+typedef void (*dm_release_clone_request_fn) (struct request *clone,
+						union map_info *map_context,
+						enum dm_rq_status clone_status);
 
 /*
  * Returns:
-- 
2.16.2.dirty
