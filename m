From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 8/8] dm: impose configurable deadline for
	dm_request_fn's merge heuristic
Date: Tue,  3 Mar 2015 19:47:11 -0500
Message-ID: <1425430031-78140-9-git-send-email-snitzer@redhat.com>
References: <1425430031-78140-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1425430031-78140-1-git-send-email-snitzer@redhat.com>
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
Cc: axboe@kernel.dk, jmoyer@redhat.com
List-Id: dm-devel.ids

Otherwise, for sequential workloads, the dm_request_fn can perform
excessive request merging at the expense of increased service time.

Add a per-device sysfs parameter to allow the user to control how long a
request that is a reasonable merge candidate can be queued on the
request queue.  The resolution of this request dispatch deadline is in
microseconds (ranging from 1 to 100000 usecs), to set a 0.3ms deadline:
  echo 300 > /sys/block/dm-7/dm/rq_based_queue_deadline

The dm_request_fn's merge heuristic and associated extra accounting is
disabled by default (rq_based_queue_deadline is 0).

This parameter is not applicable to bio-based DM devices so it will only
ever report 0 for them.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-sysfs.c |  2 ++
 drivers/md/dm.c       | 58 +++++++++++++++++++++++++++++++++++++++++++++++----
 drivers/md/dm.h       |  4 ++++
 3 files changed, 60 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-sysfs.c b/drivers/md/dm-sysfs.c
index 1271c31..cf5f83b 100644
--- a/drivers/md/dm-sysfs.c
+++ b/drivers/md/dm-sysfs.c
@@ -92,11 +92,13 @@ static ssize_t dm_attr_suspended_show(struct mapped_device *md, char *buf)
 static DM_ATTR_RO(name);
 static DM_ATTR_RO(uuid);
 static DM_ATTR_RO(suspended);
+static DM_ATTR_RW(rq_based_queue_deadline);
 
 static struct attribute *dm_attrs[] = {
 	&dm_attr_name.attr,
 	&dm_attr_uuid.attr,
 	&dm_attr_suspended.attr,
+	&dm_attr_rq_based_queue_deadline.attr,
 	NULL,
 };
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 3242f4c..b38361c 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -21,6 +21,7 @@
 #include <linux/delay.h>
 #include <linux/wait.h>
 #include <linux/kthread.h>
+#include <linux/ktime.h>
 #include <linux/elevator.h> /* for rq_end_sector() */
 
 #include <trace/events/block.h>
@@ -219,8 +220,10 @@ struct mapped_device {
 	struct task_struct *kworker_task;
 
 	/* for request-based merge heuristic in dm_request_fn() */
-	sector_t last_rq_pos;
+	unsigned rq_based_queue_deadline_usecs;
 	int last_rq_rw;
+	sector_t last_rq_pos;
+	ktime_t last_rq_start_time;
 };
 
 /*
@@ -1932,8 +1935,11 @@ static void dm_start_request(struct mapped_device *md, struct request *orig)
 	blk_start_request(orig);
 	atomic_inc(&md->pending[rq_data_dir(orig)]);
 
-	md->last_rq_pos = rq_end_sector(orig);
-	md->last_rq_rw = rq_data_dir(orig);
+	if (md->rq_based_queue_deadline_usecs) {
+		md->last_rq_pos = rq_end_sector(orig);
+		md->last_rq_rw = rq_data_dir(orig);
+		md->last_rq_start_time = ktime_get();
+	}
 
 	/*
 	 * Hold the md reference here for the in-flight I/O.
@@ -1945,6 +1951,46 @@ static void dm_start_request(struct mapped_device *md, struct request *orig)
 	dm_get(md);
 }
 
+#define MAX_QUEUE_DEADLINE_USECS 100000 /* 100 ms */
+
+ssize_t dm_attr_rq_based_queue_deadline_show(struct mapped_device *md, char *buf)
+{
+	return sprintf(buf, "%u\n", md->rq_based_queue_deadline_usecs);
+}
+
+ssize_t dm_attr_rq_based_queue_deadline_store(struct mapped_device *md,
+					      const char *buf, size_t count)
+{
+	unsigned deadline;
+
+	if (!dm_request_based(md))
+		return count;
+
+	if (kstrtouint(buf, 10, &deadline))
+		return -EINVAL;
+
+	if (deadline > MAX_QUEUE_DEADLINE_USECS)
+		deadline = MAX_QUEUE_DEADLINE_USECS;
+
+	md->rq_based_queue_deadline_usecs = deadline;
+
+	return count;
+}
+
+static bool dm_request_dispatched_before_queue_deadline(struct mapped_device *md)
+{
+	ktime_t kt_now, kt_deadline;
+
+	if (!md->rq_based_queue_deadline_usecs)
+		return false;
+
+	kt_now = ktime_get();
+	kt_deadline = ns_to_ktime((u64)md->rq_based_queue_deadline_usecs * NSEC_PER_USEC);
+	kt_deadline = ktime_add_safe(md->last_rq_start_time, kt_deadline);
+
+	return !ktime_after(kt_now, kt_deadline);
+}
+
 /*
  * q->request_fn for request-based dm.
  * Called with the queue lock held.
@@ -1987,7 +2033,8 @@ static void dm_request_fn(struct request_queue *q)
 			continue;
 		}
 
-		if (md_in_flight(md) && rq->bio && rq->bio->bi_vcnt == 1 &&
+		if (dm_request_dispatched_before_queue_deadline(md) &&
+		    md_in_flight(md) && rq->bio && rq->bio->bi_vcnt == 1 &&
 		    md->last_rq_pos == pos && md->last_rq_rw == rq_data_dir(rq))
 			goto delay_and_out;
 
@@ -2527,6 +2574,9 @@ static int dm_init_request_based_queue(struct mapped_device *md)
 	if (!q)
 		return 0;
 
+	/* disable dm_request_fn's merge heuristic by default */
+	md->rq_based_queue_deadline_usecs = 0;
+
 	md->queue = q;
 	dm_init_md_queue(md);
 	blk_queue_softirq_done(md->queue, dm_softirq_done);
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index db49586..722fc0f 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -234,4 +234,8 @@ static inline bool dm_message_test_buffer_overflow(char *result, unsigned maxlen
 	return !maxlen || strlen(result) + 1 >= maxlen;
 }
 
+ssize_t dm_attr_rq_based_queue_deadline_show(struct mapped_device *md, char *buf);
+ssize_t dm_attr_rq_based_queue_deadline_store(struct mapped_device *md,
+					      const char *buf, size_t count);
+
 #endif
-- 
1.9.3 (Apple Git-50)
