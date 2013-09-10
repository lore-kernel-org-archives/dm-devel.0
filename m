From: dongmao zhang <dmzhang@suse.com>
Subject: [PATCH 1/1] improve the performance of dm-log-userspace
Date: Tue, 10 Sep 2013 17:25:12 +0800
Message-ID: <eedc507aeecd6c4e21e6a67867662e3dd7c2e443.1378804287.git.dmzhang@suse.com>
References: <yes>
 <cover.1378804287.git.dmzhang@suse.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cover.1378804287.git.dmzhang@suse.com>
In-Reply-To: <cover.1378804287.git.dmzhang@suse.com>
References: <cover.1378804287.git.dmzhang@suse.com>
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
Cc: dongmao zhang <dmzhang@suse.com>
List-Id: dm-devel.ids

In the cluster evironment, cluster write has poor performance.
Because userspace_flush has to access userspace program(cmirrord)
for clear/mark/flush request. But the mark and flush requests
require cmirrord send message to  all the cluster nodes. This behave
is realy slow. So the idea is merging mark and flush
request together and to reduce the kernel-userspace-kernel time.
Moreover, when only sending clear request, the flush request could
be delayed. Added a workqueue to run delayed flush request.

Signed-off-by: dongmao zhang <dmzhang@suse.com>
---
 drivers/md/dm-log-userspace-base.c |   57 ++++++++++++++++++++++++++++++++---
 1 files changed, 52 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-log-userspace-base.c b/drivers/md/dm-log-userspace-base.c
index 9429159..d9dcfac 100644
--- a/drivers/md/dm-log-userspace-base.c
+++ b/drivers/md/dm-log-userspace-base.c
@@ -11,6 +11,7 @@
 #include <linux/dm-log-userspace.h>
 #include <linux/module.h>
 
+#include <linux/workqueue.h>
 #include "dm-log-userspace-transfer.h"
 
 #define DM_LOG_USERSPACE_VSN "1.1.0"
@@ -58,6 +59,11 @@ struct log_c {
 	spinlock_t flush_lock;
 	struct list_head mark_list;
 	struct list_head clear_list;
+
+	/*work queue for flush clear region*/
+	struct workqueue_struct *dmlog_wq;
+	struct delayed_work flush_log_work;
+	atomic_t sched_flush;
 };
 
 static mempool_t *flush_entry_pool;
@@ -234,6 +240,17 @@ static int userspace_ctr(struct dm_dirty_log *log, struct dm_target *ti,
 	lc->region_size = (uint32_t)rdata;
 	lc->region_count = dm_sector_div_up(ti->len, lc->region_size);
 
+	lc->dmlog_wq =  alloc_workqueue("dmlogd",
+			WQ_NON_REENTRANT | WQ_MEM_RECLAIM, 0);
+	if (!lc->dmlog_wq) {
+		DMERR("couldn't start dmlogd");
+		r = -ENOMEM;
+		goto out;
+	}
+
+	INIT_DELAYED_WORK(&lc->flush_log_work, do_flush);
+	atomic_set(&lc->sched_flush, 0);
+
 	if (devices_rdata_size) {
 		if (devices_rdata[devices_rdata_size - 1] != '\0') {
 			DMERR("DM_ULOG_CTR device return string not properly terminated");
@@ -264,6 +281,13 @@ static void userspace_dtr(struct dm_dirty_log *log)
 {
 	struct log_c *lc = log->context;
 
+	/*flush workqueue*/
+	if (atomic_read(&lc->sched_flush))
+		flush_delayed_work(&lc->flush_log_work);
+
+	flush_workqueue(lc->dmlog_wq);
+	destroy_workqueue(lc->dmlog_wq);
+
 	(void) dm_consult_userspace(lc->uuid, lc->luid, DM_ULOG_DTR,
 				 NULL, 0,
 				 NULL, NULL);
@@ -282,6 +306,10 @@ static int userspace_presuspend(struct dm_dirty_log *log)
 	int r;
 	struct log_c *lc = log->context;
 
+	/*run planed flush*/
+	if (atomic_read(&lc->sched_flush))
+		flush_delayed_work(&lc->flush_log_work);
+
 	r = dm_consult_userspace(lc->uuid, lc->luid, DM_ULOG_PRESUSPEND,
 				 NULL, 0,
 				 NULL, NULL);
@@ -294,6 +322,9 @@ static int userspace_postsuspend(struct dm_dirty_log *log)
 	int r;
 	struct log_c *lc = log->context;
 
+	if (atomic_read(&lc->sched_flush))
+		flush_delayed_work(&lc->flush_log_work);
+
 	r = dm_consult_userspace(lc->uuid, lc->luid, DM_ULOG_POSTSUSPEND,
 				 NULL, 0,
 				 NULL, NULL);
@@ -474,6 +505,8 @@ static int userspace_flush(struct dm_dirty_log *log)
 	int r = 0;
 	unsigned long flags;
 	struct log_c *lc = log->context;
+	int is_mark_list_empty;
+	int is_clear_list_empty;
 	LIST_HEAD(mark_list);
 	LIST_HEAD(clear_list);
 	struct flush_entry *fe, *tmp_fe;
@@ -483,19 +516,33 @@ static int userspace_flush(struct dm_dirty_log *log)
 	list_splice_init(&lc->clear_list, &clear_list);
 	spin_unlock_irqrestore(&lc->flush_lock, flags);
 
-	if (list_empty(&mark_list) && list_empty(&clear_list))
+	is_mark_list_empty = list_empty(&mark_list);
+	is_clear_list_empty = list_empty(&clear_list);
+
+	if (is_mark_list_empty && is_clear_list_empty)
 		return 0;
 
-	r = flush_by_group(lc, &mark_list);
+
+	r = flush_by_group(lc, &clear_list);
 	if (r)
 		goto fail;
 
-	r = flush_by_group(lc, &clear_list);
+	r = flush_by_group(lc, &mark_list);
 	if (r)
 		goto fail;
 
-	r = userspace_do_request(lc, lc->uuid, DM_ULOG_FLUSH,
-				 NULL, 0, NULL, NULL);
+	if (!is_clear_list_empty && is_mark_list_empty
+				 && !atomic_read(&lc->sched_flush)) {
+		/* plan a flush */
+		queue_delayed_work(lc->dmlog_wq, &lc->flush_log_work , 3 * HZ);
+		atomic_set(&lc->sched_flush, 1);
+	} else {
+		/* cancel pending flush because already flushed in mark_region*/
+		cancel_delayed_work(&lc->flush_log_work);
+		atomic_set(&lc->sched_flush, 0);
+	}
+
+
 
 fail:
 	/*
-- 
1.7.3.4
