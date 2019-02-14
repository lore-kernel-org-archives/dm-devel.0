From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 3/4] dm: move dm_table to dm-core.h
Date: Thu, 14 Feb 2019 16:00:05 +0100
Message-ID: <20190214150105.428581200@debian-a64.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=move-dm_table-to-dm-core.patch
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

Move the definition of struct dm_table from dm-table.c to dm-core.h - so,
that it can be used by dm.c.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-core.h  |   45 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-table.c |   44 --------------------------------------------
 2 files changed, 45 insertions(+), 44 deletions(-)

Index: linux-2.6/drivers/md/dm-core.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-core.h	2019-02-12 15:26:19.000000000 +0100
+++ linux-2.6/drivers/md/dm-core.h	2019-02-12 15:32:24.000000000 +0100
@@ -115,6 +115,51 @@ struct mapped_device {
 	struct srcu_struct io_barrier;
 };
 
+#define MAX_DEPTH 16
+#define NODE_SIZE L1_CACHE_BYTES
+#define KEYS_PER_NODE (NODE_SIZE / sizeof(sector_t))
+#define CHILDREN_PER_NODE (KEYS_PER_NODE + 1)
+
+struct dm_table {
+	struct mapped_device *md;
+	enum dm_queue_mode type;
+
+	/* btree table */
+	unsigned int depth;
+	unsigned int counts[MAX_DEPTH];	/* in nodes */
+	sector_t *index[MAX_DEPTH];
+
+	unsigned int num_targets;
+	unsigned int num_allocated;
+	sector_t *highs;
+	struct dm_target *targets;
+
+	struct target_type *immutable_target_type;
+
+	bool integrity_supported:1;
+	bool singleton:1;
+	unsigned integrity_added:1;
+
+	/*
+	 * Indicates the rw permissions for the new logical
+	 * device.  This should be a combination of FMODE_READ
+	 * and FMODE_WRITE.
+	 */
+	fmode_t mode;
+
+	/* a list of devices used by this table */
+	struct list_head devices;
+
+	/* events get handed up using this callback */
+	void (*event_fn)(void *);
+	void *event_context;
+
+	struct dm_md_mempools *mempools;
+
+	struct list_head target_callbacks;
+};
+
+
 void disable_write_same(struct mapped_device *md);
 void disable_write_zeroes(struct mapped_device *md);
 
Index: linux-2.6/drivers/md/dm-table.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-table.c	2019-02-12 15:26:19.000000000 +0100
+++ linux-2.6/drivers/md/dm-table.c	2019-02-12 15:32:24.000000000 +0100
@@ -24,50 +24,6 @@
 
 #define DM_MSG_PREFIX "table"
 
-#define MAX_DEPTH 16
-#define NODE_SIZE L1_CACHE_BYTES
-#define KEYS_PER_NODE (NODE_SIZE / sizeof(sector_t))
-#define CHILDREN_PER_NODE (KEYS_PER_NODE + 1)
-
-struct dm_table {
-	struct mapped_device *md;
-	enum dm_queue_mode type;
-
-	/* btree table */
-	unsigned int depth;
-	unsigned int counts[MAX_DEPTH];	/* in nodes */
-	sector_t *index[MAX_DEPTH];
-
-	unsigned int num_targets;
-	unsigned int num_allocated;
-	sector_t *highs;
-	struct dm_target *targets;
-
-	struct target_type *immutable_target_type;
-
-	bool integrity_supported:1;
-	bool singleton:1;
-	unsigned integrity_added:1;
-
-	/*
-	 * Indicates the rw permissions for the new logical
-	 * device.  This should be a combination of FMODE_READ
-	 * and FMODE_WRITE.
-	 */
-	fmode_t mode;
-
-	/* a list of devices used by this table */
-	struct list_head devices;
-
-	/* events get handed up using this callback */
-	void (*event_fn)(void *);
-	void *event_context;
-
-	struct dm_md_mempools *mempools;
-
-	struct list_head target_callbacks;
-};
-
 /*
  * Similar to ceiling(log_size(n))
  */
