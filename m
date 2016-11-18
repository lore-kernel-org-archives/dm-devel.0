From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 14/14] dm,
 dm-mpath: Make it easier to detect unintended I/O request flushes
Date: Fri, 18 Nov 2016 14:30:29 -0800
Message-ID: <98a99f41-e2c5-e65f-d298-1b56403910c1@sandisk.com>
References: <32edbd52-5b1a-b093-0195-2ec6fa73cd6f@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <32edbd52-5b1a-b093-0195-2ec6fa73cd6f@sandisk.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

I/O errors triggered by multipathd incorrectly not enabling the
no-flush flag for DM_DEVICE_SUSPEND or DM_DEVICE_RESUME are hard to
debug. Add more logging to make it easier to debug this.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 drivers/md/dm-mpath.c | 25 +++++++++++++++++++++----
 drivers/md/dm.c       |  3 +++
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 4a3afec..c3d7e3e 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -489,6 +489,23 @@ static struct pgpath *choose_pgpath(struct multipath *m, size_t nr_bytes)
 }
 
 /*
+ * Note: dm_report_eio() is a macro instead of a function to make pr_debug()
+ * report the function name and line number of the function from which it has
+ * been invoked.
+ */
+#define dm_report_eio(m)						\
+({									\
+	struct mapped_device *md = dm_table_get_md((m)->ti->table);	\
+									\
+	pr_debug("%s: returning EIO; QIFNP = %d; SQIFNP = %d; DNFS = %d\n", \
+		 dm_device_name(md),					\
+		 test_bit(MPATHF_QUEUE_IF_NO_PATH, &(m)->flags),	\
+		 test_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &(m)->flags),	\
+		 dm_noflush_suspending((m)->ti));			\
+	-EIO;								\
+})
+
+/*
  * Map cloned requests (request-based multipath)
  */
 static int __multipath_map(struct dm_target *ti, struct request *clone,
@@ -510,7 +527,7 @@ static int __multipath_map(struct dm_target *ti, struct request *clone,
 	if (!pgpath) {
 		if (test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags))
 			return DM_MAPIO_DELAY_REQUEUE;
-		return -EIO;	/* Failed */
+		return dm_report_eio(m);	/* Failed */
 	} else if (test_bit(MPATHF_QUEUE_IO, &m->flags) ||
 		   test_bit(MPATHF_PG_INIT_REQUIRED, &m->flags)) {
 		pg_init_all_paths(m);
@@ -612,7 +629,7 @@ static int __multipath_map_bio(struct multipath *m, struct bio *bio, struct dm_m
 	if (!pgpath) {
 		if (test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags))
 			return DM_MAPIO_REQUEUE;
-		return -EIO;
+		return dm_report_eio(m);
 	}
 
 	mpio->pgpath = pgpath;
@@ -1536,7 +1553,7 @@ static int do_end_io(struct multipath *m, struct request *clone,
 
 	if (atomic_read(&m->nr_valid_paths) == 0 &&
 	    !test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags))
-		r = -EIO;
+		r = dm_report_eio(m);
 
 	return r;
 }
@@ -1580,7 +1597,7 @@ static int do_end_io_bio(struct multipath *m, struct bio *clone,
 
 	if (atomic_read(&m->nr_valid_paths) == 0 &&
 	    !test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags))
-		return -EIO;
+		return dm_report_eio(m);
 
 	/* Queue for the daemon to resubmit */
 	dm_bio_restore(get_bio_details_from_bio(clone), clone);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index d19c372..08a21d1 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2098,6 +2098,9 @@ static int __dm_suspend(struct mapped_device *md, struct dm_table *map,
 	 */
 	if (noflush)
 		set_bit(DMF_NOFLUSH_SUSPENDING, &md->flags);
+	else
+		pr_debug("%s: suspending without no-flush flag\n",
+			 dm_device_name(md));
 
 	/*
 	 * This gets reverted if there's an error later and the targets
-- 
2.10.1
