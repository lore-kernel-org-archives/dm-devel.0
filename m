From: dongmao zhang <dmzhang@suse.com>
Subject: [PATCH 2/2] change API of dm-log-userspace to support
	delay flush
Date: Thu, 26 Sep 2013 18:50:18 +0800
Message-ID: <4b545cb9f39e04507b824834b4816dbc493dc8a6.1380191502.git.dmzhang@suse.com>
References: <cover.1380191501.git.dmzhang@suse.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cover.1380191501.git.dmzhang@suse.com>
In-Reply-To: <cover.1380191501.git.dmzhang@suse.com>
References: <cover.1380191501.git.dmzhang@suse.com>
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
Cc: dongmao zhang <dmzhang@suse.com>, agk@redhat.com
List-Id: dm-devel.ids

Signed-off-by: dongmao zhang <dmzhang@suse.com>
---
 drivers/md/dm-log-userspace-base.c    |   80 ++++++++++++++++++++++++---------
 include/uapi/linux/dm-log-userspace.h |    2 +-
 2 files changed, 59 insertions(+), 23 deletions(-)

diff --git a/drivers/md/dm-log-userspace-base.c b/drivers/md/dm-log-userspace-base.c
index d5f4a1c..f455d95 100644
--- a/drivers/md/dm-log-userspace-base.c
+++ b/drivers/md/dm-log-userspace-base.c
@@ -14,7 +14,7 @@
 #include <linux/workqueue.h>
 #include "dm-log-userspace-transfer.h"
 
-#define DM_LOG_USERSPACE_VSN "1.1.0"
+#define DM_LOG_USERSPACE_VSN "1.2.0"
 
 struct flush_entry {
 	int type;
@@ -30,6 +30,8 @@ struct flush_entry {
  */
 #define MAX_FLUSH_GROUP_COUNT 32
 
+#define SUPPORT_DELAY_FLUSH "support_delay_flush"
+
 struct log_c {
 	struct dm_target *ti;
 	struct dm_dev *log_dev;
@@ -64,6 +66,7 @@ struct log_c {
 	struct workqueue_struct *dmlog_wq;
 	struct delayed_work flush_log_work;
 	atomic_t sched_flush;
+	uint32_t support_delay_flush;
 };
 
 static mempool_t *flush_entry_pool;
@@ -158,6 +161,8 @@ static void do_flush(struct delayed_work *work)
 		dm_table_event(lc->ti->table);
 }
 
+
+
 /*
  * userspace_ctr
  *
@@ -181,7 +186,11 @@ static int userspace_ctr(struct dm_dirty_log *log, struct dm_target *ti,
 	uint64_t rdata;
 	size_t rdata_size = sizeof(rdata);
 	char *devices_rdata = NULL;
-	size_t devices_rdata_size = DM_NAME_LEN;
+
+	char *logdev = NULL;
+	char *delay_flush_string = NULL;
+
+	size_t devices_rdata_size = DM_NAME_LEN + sizeof(SUPPORT_DELAY_FLUSH);
 
 	if (argc < 3) {
 		DMWARN("Too few arguments to userspace dirty log");
@@ -251,16 +260,8 @@ static int userspace_ctr(struct dm_dirty_log *log, struct dm_target *ti,
 	lc->region_size = (uint32_t)rdata;
 	lc->region_count = dm_sector_div_up(ti->len, lc->region_size);
 
-	lc->dmlog_wq =  alloc_workqueue("dmlogd",
-			WQ_NON_REENTRANT | WQ_MEM_RECLAIM, 0);
-	if (!lc->dmlog_wq) {
-		DMERR("couldn't start dmlogd");
-		r = -ENOMEM;
-		goto out;
-	}
 
-	INIT_DELAYED_WORK(&lc->flush_log_work, do_flush);
-	atomic_set(&lc->sched_flush, 0);
+	lc->support_delay_flush = 0;
 
 	if (devices_rdata_size) {
 		if (devices_rdata[devices_rdata_size - 1] != '\0') {
@@ -268,12 +269,34 @@ static int userspace_ctr(struct dm_dirty_log *log, struct dm_target *ti,
 			r = -EINVAL;
 			goto out;
 		}
-		r = dm_get_device(ti, devices_rdata,
+
+		logdev = strsep(&devices_rdata, " ");
+		delay_flush_string = strsep(&devices_rdata, " ");
+
+		if (delay_flush_string &&
+			!strcmp(delay_flush_string, SUPPORT_DELAY_FLUSH))
+			lc->support_delay_flush = 1;
+
+		r = dm_get_device(ti, logdev,
 				  dm_table_get_mode(ti->table), &lc->log_dev);
 		if (r)
 			DMERR("Failed to register %s with device-mapper",
-			      devices_rdata);
+			      logdev);
 	}
+
+	if (lc->support_delay_flush) {
+		lc->dmlog_wq =  alloc_workqueue("dmlogd",
+				WQ_NON_REENTRANT | WQ_MEM_RECLAIM, 0);
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
@@ -292,12 +315,14 @@ static void userspace_dtr(struct dm_dirty_log *log)
 {
 	struct log_c *lc = log->context;
 
-	/*flush workqueue*/
-	if (atomic_read(&lc->sched_flush))
-		flush_delayed_work(&lc->flush_log_work);
+	if (lc->support_delay_flush) {
+		/*flush workqueue*/
+		if (atomic_read(&lc->sched_flush))
+			flush_delayed_work(&lc->flush_log_work);
 
-	flush_workqueue(lc->dmlog_wq);
-	destroy_workqueue(lc->dmlog_wq);
+		flush_workqueue(lc->dmlog_wq);
+		destroy_workqueue(lc->dmlog_wq);
+	}
 
 	(void) dm_consult_userspace(lc->uuid, lc->luid, DM_ULOG_DTR,
 				 NULL, 0,
@@ -329,8 +354,8 @@ static int userspace_postsuspend(struct dm_dirty_log *log)
 	int r;
 	struct log_c *lc = log->context;
 
-	/*run planed flush*/
-	if (atomic_read(&lc->sched_flush))
+	/*run planed flush earlier*/
+	if (lc->support_delay_flush && atomic_read(&lc->sched_flush))
 		flush_delayed_work(&lc->flush_log_work);
 
 	r = dm_consult_userspace(lc->uuid, lc->luid, DM_ULOG_POSTSUSPEND,
@@ -539,13 +564,24 @@ static int userspace_flush(struct dm_dirty_log *log)
 	if (r)
 		goto fail;
 
+	/* If we do not support delay flush, just contact
+	 * userspace immediately.
+	 * If we support delay flush and only has clear region,
+	 * we could postpone * the flush command
+	 */
+	if (!lc->support_delay_flush) {
+		r = userspace_do_request(lc, lc->uuid, DM_ULOG_FLUSH,
+				NULL, 0, NULL, NULL);
+		goto fail;
+	}
+
+	/* when only has clear region,we plan a flush in the furture*/
 	if (!is_clear_list_empty && is_mark_list_empty
 				 && !atomic_read(&lc->sched_flush)) {
-		/* plan a flush */
 		queue_delayed_work(lc->dmlog_wq, &lc->flush_log_work , 3 * HZ);
 		atomic_set(&lc->sched_flush, 1);
+	/* cancel pending flush because we have already flushed in mark_region*/
 	} else {
-		/* cancel pending flush because already flushed in mark_region*/
 		cancel_delayed_work(&lc->flush_log_work);
 		atomic_set(&lc->sched_flush, 0);
 	}
diff --git a/include/uapi/linux/dm-log-userspace.h b/include/uapi/linux/dm-log-userspace.h
index 0678c2a..5fbeb2c 100644
--- a/include/uapi/linux/dm-log-userspace.h
+++ b/include/uapi/linux/dm-log-userspace.h
@@ -386,7 +386,7 @@
  *	            device name that is to be registered with DM via
  *	            'dm_get_device'.
  */
-#define DM_ULOG_REQUEST_VERSION 2
+#define DM_ULOG_REQUEST_VERSION 3
 
 struct dm_ulog_request {
 	/*
-- 
1.7.3.4
