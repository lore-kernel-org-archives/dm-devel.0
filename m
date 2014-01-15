From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH v2] dm-log-userspace: Allow mark requests to
 piggyback on flush requests
Date: Wed, 15 Jan 2014 15:44:37 -0600
Message-ID: <1389822277.3247.1.camel@f16>
Reply-To: jbrassow@redhat.com, device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com
Cc: msnitzer@redhat.com, dmzhang@suse.com
List-Id: dm-devel.ids

In the cluster evironment, cluster write has poor performance.
Because userspace_flush has to contact a userspace program (cmirrord)
in clear/mark/flush requests.  But both mark and flush requests
require cmirrord to communicate the message to all the cluster nodes for
each flush call.  This behaviour is realy slow.  So the idea is to merge
mark and flush requests together to reduce the kernel-userspace-kernel
time.  We allow a new directive, "integrated_flush" that can be used to
instruct the kernel log code to combine flush and mark requests when
directed by userspace.  If not directed by userspace (due to an older
version of the userspace code perhaps), the kernel will function as it
did previously - preserving backwards compatibility.  Additionlly, flush
requests are performed lazily when only clear requests exist.

Signed-off-by: dongmao zhang <dmzhang@suse.com>
Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/dm-log-userspace-base.c
===================================================================
--- linux-upstream.orig/drivers/md/dm-log-userspace-base.c
+++ linux-upstream/drivers/md/dm-log-userspace-base.c
@@ -11,9 +11,10 @@
 #include <linux/dm-log-userspace.h>
 #include <linux/module.h>
 
+#include <linux/workqueue.h>
 #include "dm-log-userspace-transfer.h"
 
-#define DM_LOG_USERSPACE_VSN "1.1.0"
+#define DM_LOG_USERSPACE_VSN "1.3.0"
 
 struct flush_entry {
 	int type;
@@ -58,6 +59,12 @@ struct log_c {
 	spinlock_t flush_lock;
 	struct list_head mark_list;
 	struct list_head clear_list;
+
+	/* workqueue for flush of clear region requests */
+	struct workqueue_struct *dmlog_wq;
+	struct delayed_work flush_log_work;
+	atomic_t sched_flush;
+	uint32_t integrated_flush;
 };
 
 static mempool_t *flush_entry_pool;
@@ -141,6 +148,17 @@ static int build_constructor_string(stru
 	return str_size;
 }
 
+static void do_flush(struct work_struct *work)
+{
+	int r;
+	struct log_c *lc = container_of(work, struct log_c, flush_log_work.work);
+	r = userspace_do_request(lc, lc->uuid, DM_ULOG_FLUSH,
+				 NULL, 0, NULL, NULL);
+	atomic_set(&lc->sched_flush, 0);
+	if (r)
+		dm_table_event(lc->ti->table);
+}
+
 /*
  * userspace_ctr
  *
@@ -199,6 +217,10 @@ static int userspace_ctr(struct dm_dirty
 		return str_size;
 	}
 
+	lc->integrated_flush = 0;
+	if (strstr(ctr_str, "integrated_flush"))
+		lc->integrated_flush = 1;
+
 	devices_rdata = kzalloc(devices_rdata_size, GFP_KERNEL);
 	if (!devices_rdata) {
 		DMERR("Failed to allocate memory for device information");
@@ -246,6 +268,19 @@ static int userspace_ctr(struct dm_dirty
 			DMERR("Failed to register %s with device-mapper",
 			      devices_rdata);
 	}
+
+	if (lc->integrated_flush) {
+		lc->dmlog_wq = alloc_workqueue("dmlogd", WQ_MEM_RECLAIM, 0);
+		if (!lc->dmlog_wq) {
+			DMERR("couldn't start dmlogd");
+			r = -ENOMEM;
+			goto out;
+		}
+
+		INIT_DELAYED_WORK(&lc->flush_log_work, do_flush);
+		atomic_set(&lc->sched_flush, 0);
+	}
+
 out:
 	kfree(devices_rdata);
 	if (r) {
@@ -264,6 +299,14 @@ static void userspace_dtr(struct dm_dirt
 {
 	struct log_c *lc = log->context;
 
+	if (lc->integrated_flush) {
+		/* flush workqueue */
+		if (atomic_read(&lc->sched_flush))
+			flush_delayed_work(&lc->flush_log_work);
+
+		destroy_workqueue(lc->dmlog_wq);
+	}
+
 	(void) dm_consult_userspace(lc->uuid, lc->luid, DM_ULOG_DTR,
 				 NULL, 0,
 				 NULL, NULL);
@@ -294,6 +337,10 @@ static int userspace_postsuspend(struct
 	int r;
 	struct log_c *lc = log->context;
 
+	/* run planned flush earlier */
+	if (lc->integrated_flush && atomic_read(&lc->sched_flush))
+		flush_delayed_work(&lc->flush_log_work);
+
 	r = dm_consult_userspace(lc->uuid, lc->luid, DM_ULOG_POSTSUSPEND,
 				 NULL, 0,
 				 NULL, NULL);
@@ -405,7 +452,8 @@ static int flush_one_by_one(struct log_c
 	return r;
 }
 
-static int flush_by_group(struct log_c *lc, struct list_head *flush_list)
+static int flush_by_group(struct log_c *lc, struct list_head *flush_list,
+			  int flush_with_payload)
 {
 	int r = 0;
 	int count;
@@ -431,15 +479,25 @@ static int flush_by_group(struct log_c *
 				break;
 		}
 
-		r = userspace_do_request(lc, lc->uuid, type,
-					 (char *)(group),
-					 count * sizeof(uint64_t),
-					 NULL, NULL);
-		if (r) {
-			/* Group send failed.  Attempt one-by-one. */
-			list_splice_init(&tmp_list, flush_list);
-			r = flush_one_by_one(lc, flush_list);
-			break;
+		if (flush_with_payload) {
+			r = userspace_do_request(lc, lc->uuid, DM_ULOG_FLUSH,
+						 (char *)(group),
+						 count * sizeof(uint64_t),
+						 NULL, NULL);
+			/* integrated flush failed */
+			if (r)
+				break;
+		} else {
+			r = userspace_do_request(lc, lc->uuid, type,
+						 (char *)(group),
+						 count * sizeof(uint64_t),
+						 NULL, NULL);
+			if (r) {
+				/* Group send failed.  Attempt one-by-one. */
+				list_splice_init(&tmp_list, flush_list);
+				r = flush_one_by_one(lc, flush_list);
+				break;
+			}
 		}
 	}
 
@@ -474,6 +532,8 @@ static int userspace_flush(struct dm_dir
 	int r = 0;
 	unsigned long flags;
 	struct log_c *lc = log->context;
+	int is_mark_list_empty;
+	int is_clear_list_empty;
 	LIST_HEAD(mark_list);
 	LIST_HEAD(clear_list);
 	struct flush_entry *fe, *tmp_fe;
@@ -483,19 +543,46 @@ static int userspace_flush(struct dm_dir
 	list_splice_init(&lc->clear_list, &clear_list);
 	spin_unlock_irqrestore(&lc->flush_lock, flags);
 
-	if (list_empty(&mark_list) && list_empty(&clear_list))
+	is_mark_list_empty = list_empty(&mark_list);
+	is_clear_list_empty = list_empty(&clear_list);
+
+	if (is_mark_list_empty && is_clear_list_empty)
 		return 0;
 
-	r = flush_by_group(lc, &mark_list);
-	if (r)
-		goto fail;
+	r = flush_by_group(lc, &clear_list, 0);
 
-	r = flush_by_group(lc, &clear_list);
 	if (r)
 		goto fail;
 
-	r = userspace_do_request(lc, lc->uuid, DM_ULOG_FLUSH,
-				 NULL, 0, NULL, NULL);
+	if (lc->integrated_flush) {
+		/* send flush request with mark_list as payload*/
+		r = flush_by_group(lc, &mark_list, 1);
+		if (r)
+			goto fail;
+
+		if (is_mark_list_empty && !atomic_read(&lc->sched_flush)) {
+			/*
+			 * When there is only clear region requests,
+			 * we plan a flush in the future.
+			 */
+			queue_delayed_work(lc->dmlog_wq,
+					   &lc->flush_log_work, 3 * HZ);
+			atomic_set(&lc->sched_flush, 1);
+		} else {
+			/*
+			 * Cancel pending flush because we
+			 * have already flushed in mark_region
+			 */
+			cancel_delayed_work(&lc->flush_log_work);
+			atomic_set(&lc->sched_flush, 0);
+		}
+	} else {
+		r = flush_by_group(lc, &mark_list, 0);
+		if (r)
+			goto fail;
+		r = userspace_do_request(lc, lc->uuid, DM_ULOG_FLUSH,
+					 NULL, 0, NULL, NULL);
+	}
 
 fail:
 	/*
Index: linux-upstream/include/uapi/linux/dm-log-userspace.h
===================================================================
--- linux-upstream.orig/include/uapi/linux/dm-log-userspace.h
+++ linux-upstream/include/uapi/linux/dm-log-userspace.h
@@ -201,11 +201,18 @@
  * int (*flush)(struct dm_dirty_log *log);
  *
  * Payload-to-userspace:
- *	None.
+ *	If the 'integrated_flush' directive is present in the constructor
+ *	table, the payload is as same as DM_ULOG_MARK_REGION:
+ *		uint64_t [] - region(s) to mark
+ *	else
+ *		None
  * Payload-to-kernel:
  *	None.
  *
- * No incoming or outgoing payload.  Simply flush log state to disk.
+ * If the 'integrated_flush' option was used during the creation of the
+ * log, mark region requests are carried as payload in the flush request.
+ * Piggybacking the mark requests in this way allows for fewer communications
+ * between kernel and userspace.
  *
  * When the request has been processed, user-space must return the
  * dm_ulog_request to the kernel - setting the 'error' field and clearing
@@ -385,8 +392,15 @@
  *	version 2:  DM_ULOG_CTR allowed to return a string containing a
  *	            device name that is to be registered with DM via
  *	            'dm_get_device'.
+ *	version 3:  DM_ULOG_FLUSH is capable of carrying payload for marking
+ *	            regions.  This "integrated flush" reduces the number of
+ *                  requests between the kernel and userspace by effectively
+ *                  merging 'mark' and 'flush' requests.  A constructor table
+ *                  argument ('integrated_flush') is required to turn this
+ *                  feature on, so it is backwards compatible with older
+ *                  userspace versions.
  */
-#define DM_ULOG_REQUEST_VERSION 2
+#define DM_ULOG_REQUEST_VERSION 3
 
 struct dm_ulog_request {
 	/*
