From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 10/13] dm: Introduce enum dm_queue_mode
Date: Wed, 26 Apr 2017 11:37:25 -0700
Message-ID: <20170426183728.10821-11-bart.vanassche@sandisk.com>
References: <20170426183728.10821-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170426183728.10821-1-bart.vanassche@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, dm-devel@redhat.com, Hannes Reinecke <hare@suse.com>
List-Id: dm-devel.ids

Introduce an enumeration type for the queue mode. This patch does
not change any functionality but makes the dm code easier to read.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Hannes Reinecke <hare@suse.com>
---
 drivers/md/dm-core.h          |  2 +-
 drivers/md/dm-ioctl.c         |  2 +-
 drivers/md/dm-mpath.c         |  5 ++++-
 drivers/md/dm-table.c         | 14 +++++++-------
 drivers/md/dm.c               | 14 +++++++++-----
 drivers/md/dm.h               | 12 +++++++-----
 include/linux/device-mapper.h | 14 ++++++++------
 7 files changed, 37 insertions(+), 26 deletions(-)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 136fda3ff9e5..b92f74d9a982 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -47,7 +47,7 @@ struct mapped_device {
 	struct request_queue *queue;
 	int numa_node_id;
 
-	unsigned type;
+	enum dm_queue_mode type;
 	/* Protect queue and type against concurrent access. */
 	struct mutex type_lock;
 
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 4da6fc6b1ffd..9b1ce440fc70 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1268,7 +1268,7 @@ static int populate_table(struct dm_table *table,
 	return dm_table_complete(table);
 }
 
-static bool is_valid_type(unsigned cur, unsigned new)
+static bool is_valid_type(enum dm_queue_mode cur, enum dm_queue_mode new)
 {
 	if (cur == new ||
 	    (cur == DM_TYPE_BIO_BASED && new == DM_TYPE_DAX_BIO_BASED))
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 312d4fc34430..adde8a51e020 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -90,7 +90,7 @@ struct multipath {
 	atomic_t pg_init_in_progress;	/* Only one pg_init allowed at once */
 	atomic_t pg_init_count;		/* Number of times pg_init called */
 
-	unsigned queue_mode;
+	enum dm_queue_mode queue_mode;
 
 	struct mutex work_mutex;
 	struct work_struct trigger_event;
@@ -1704,6 +1704,9 @@ static void multipath_status(struct dm_target *ti, status_type_t type,
 			case DM_TYPE_MQ_REQUEST_BASED:
 				DMEMIT("queue_mode mq ");
 				break;
+			default:
+				WARN_ON_ONCE(true);
+				break;
 			}
 		}
 	}
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 92dbc85af53a..6692571336c7 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -30,7 +30,7 @@
 
 struct dm_table {
 	struct mapped_device *md;
-	unsigned type;
+	enum dm_queue_mode type;
 
 	/* btree table */
 	unsigned int depth;
@@ -821,19 +821,19 @@ void dm_consume_args(struct dm_arg_set *as, unsigned num_args)
 }
 EXPORT_SYMBOL(dm_consume_args);
 
-static bool __table_type_bio_based(unsigned table_type)
+static bool __table_type_bio_based(enum dm_queue_mode table_type)
 {
 	return (table_type == DM_TYPE_BIO_BASED ||
 		table_type == DM_TYPE_DAX_BIO_BASED);
 }
 
-static bool __table_type_request_based(unsigned table_type)
+static bool __table_type_request_based(enum dm_queue_mode table_type)
 {
 	return (table_type == DM_TYPE_REQUEST_BASED ||
 		table_type == DM_TYPE_MQ_REQUEST_BASED);
 }
 
-void dm_table_set_type(struct dm_table *t, unsigned type)
+void dm_table_set_type(struct dm_table *t, enum dm_queue_mode type)
 {
 	t->type = type;
 }
@@ -875,7 +875,7 @@ static int dm_table_determine_type(struct dm_table *t)
 	struct dm_target *tgt;
 	struct dm_dev_internal *dd;
 	struct list_head *devices = dm_table_get_devices(t);
-	unsigned live_md_type = dm_get_md_type(t->md);
+	enum dm_queue_mode live_md_type = dm_get_md_type(t->md);
 
 	if (t->type != DM_TYPE_NONE) {
 		/* target already set the table's type */
@@ -984,7 +984,7 @@ static int dm_table_determine_type(struct dm_table *t)
 	return 0;
 }
 
-unsigned dm_table_get_type(struct dm_table *t)
+enum dm_queue_mode dm_table_get_type(struct dm_table *t)
 {
 	return t->type;
 }
@@ -1035,7 +1035,7 @@ bool dm_table_all_blk_mq_devices(struct dm_table *t)
 
 static int dm_table_alloc_md_mempools(struct dm_table *t, struct mapped_device *md)
 {
-	unsigned type = dm_table_get_type(t);
+	enum dm_queue_mode type = dm_table_get_type(t);
 	unsigned per_io_data_size = 0;
 	struct dm_target *tgt;
 	unsigned i;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 78706a04bab4..7161c7804363 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1797,13 +1797,13 @@ void dm_unlock_md_type(struct mapped_device *md)
 	mutex_unlock(&md->type_lock);
 }
 
-void dm_set_md_type(struct mapped_device *md, unsigned type)
+void dm_set_md_type(struct mapped_device *md, enum dm_queue_mode type)
 {
 	BUG_ON(!mutex_is_locked(&md->type_lock));
 	md->type = type;
 }
 
-unsigned dm_get_md_type(struct mapped_device *md)
+enum dm_queue_mode dm_get_md_type(struct mapped_device *md)
 {
 	return md->type;
 }
@@ -1830,7 +1830,7 @@ EXPORT_SYMBOL_GPL(dm_get_queue_limits);
 int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
 {
 	int r;
-	unsigned type = dm_get_md_type(md);
+	enum dm_queue_mode type = dm_get_md_type(md);
 
 	switch (type) {
 	case DM_TYPE_REQUEST_BASED:
@@ -1861,6 +1861,8 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
 		if (type == DM_TYPE_DAX_BIO_BASED)
 			queue_flag_set_unlocked(QUEUE_FLAG_DAX, md->queue);
 		break;
+	case DM_TYPE_NONE:
+		WARN_ON_ONCE(true);
 	}
 
 	return 0;
@@ -2546,8 +2548,10 @@ int dm_noflush_suspending(struct dm_target *ti)
 }
 EXPORT_SYMBOL_GPL(dm_noflush_suspending);
 
-struct dm_md_mempools *dm_alloc_md_mempools(struct mapped_device *md, unsigned type,
-					    unsigned integrity, unsigned per_io_data_size)
+struct dm_md_mempools *dm_alloc_md_mempools(struct mapped_device *md,
+					    enum dm_queue_mode type,
+					    unsigned integrity,
+					    unsigned per_io_data_size)
 {
 	struct dm_md_mempools *pools = kzalloc_node(sizeof(*pools), GFP_KERNEL, md->numa_node_id);
 	unsigned int pool_size = 0;
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index f298b01f7ab3..4b3b8587cb72 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -64,7 +64,7 @@ void dm_table_presuspend_undo_targets(struct dm_table *t);
 void dm_table_postsuspend_targets(struct dm_table *t);
 int dm_table_resume_targets(struct dm_table *t);
 int dm_table_any_congested(struct dm_table *t, int bdi_bits);
-unsigned dm_table_get_type(struct dm_table *t);
+enum dm_queue_mode dm_table_get_type(struct dm_table *t);
 struct target_type *dm_table_get_immutable_target_type(struct dm_table *t);
 struct dm_target *dm_table_get_immutable_target(struct dm_table *t);
 struct dm_target *dm_table_get_wildcard_target(struct dm_table *t);
@@ -76,8 +76,8 @@ struct dm_md_mempools *dm_table_get_md_mempools(struct dm_table *t);
 
 void dm_lock_md_type(struct mapped_device *md);
 void dm_unlock_md_type(struct mapped_device *md);
-void dm_set_md_type(struct mapped_device *md, unsigned type);
-unsigned dm_get_md_type(struct mapped_device *md);
+void dm_set_md_type(struct mapped_device *md, enum dm_queue_mode type);
+enum dm_queue_mode dm_get_md_type(struct mapped_device *md);
 struct target_type *dm_get_immutable_target_type(struct mapped_device *md);
 
 int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t);
@@ -204,8 +204,10 @@ void dm_kcopyd_exit(void);
 /*
  * Mempool operations
  */
-struct dm_md_mempools *dm_alloc_md_mempools(struct mapped_device *md, unsigned type,
-					    unsigned integrity, unsigned per_bio_data_size);
+struct dm_md_mempools *dm_alloc_md_mempools(struct mapped_device *md,
+					    enum dm_queue_mode type,
+					    unsigned integrity,
+					    unsigned per_bio_data_size);
 void dm_free_md_mempools(struct dm_md_mempools *pools);
 
 /*
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index a7e6903866fd..9df51dcdcf2a 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -22,11 +22,13 @@ struct bio_vec;
 /*
  * Type of table, mapped_device's mempool and request_queue
  */
-#define DM_TYPE_NONE			0
-#define DM_TYPE_BIO_BASED		1
-#define DM_TYPE_REQUEST_BASED		2
-#define DM_TYPE_MQ_REQUEST_BASED	3
-#define DM_TYPE_DAX_BIO_BASED		4
+enum dm_queue_mode {
+	DM_TYPE_NONE		 = 0,
+	DM_TYPE_BIO_BASED	 = 1,
+	DM_TYPE_REQUEST_BASED	 = 2,
+	DM_TYPE_MQ_REQUEST_BASED = 3,
+	DM_TYPE_DAX_BIO_BASED	 = 4,
+};
 
 typedef enum { STATUSTYPE_INFO, STATUSTYPE_TABLE } status_type_t;
 
@@ -464,7 +466,7 @@ void dm_table_add_target_callbacks(struct dm_table *t, struct dm_target_callback
  * Useful for "hybrid" target (supports both bio-based
  * and request-based).
  */
-void dm_table_set_type(struct dm_table *t, unsigned type);
+void dm_table_set_type(struct dm_table *t, enum dm_queue_mode type);
 
 /*
  * Finally call this to make the table ready for use.
-- 
2.12.2
