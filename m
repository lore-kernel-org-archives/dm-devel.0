From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 8/8 v2] dm: impose configurable deadline for
 dm_request_fn's merge heuristic
Date: Fri, 6 Mar 2015 10:30:09 -0500
Message-ID: <20150306153009.GA91786@redhat.com>
References: <1425430031-78140-1-git-send-email-snitzer@redhat.com>
	<1425430031-78140-9-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1425430031-78140-9-git-send-email-snitzer@redhat.com>
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

Otherwise, for sequential workloads, the dm_request_fn can allow
excessive request merging at the expense of increased service time.

Add a per-device sysfs attribute to allow the user to control how long a
request, that is a reasonable merge candidate, can be queued on the
request queue.  The resolution of this request dispatch deadline is in
microseconds (ranging from 1 to 100000 usecs), to set a 20us deadline:
  echo 20 > /sys/block/dm-7/dm/rq_based_seq_io_merge_deadline

The dm_request_fn's merge heuristic and associated extra accounting is
disabled by default (rq_based_seq_io_merge_deadline is 0).

This sysfs attribute is not applicable to bio-based DM devices so it
will only ever report 0 for them.

By allowing a request to remain on the queue it will block others
requests on the queue.  But introducing a short dequeue delay has proven
very effective at enabling certain sequential IO workloads on really
fast, yet IOPS constrained, devices to build up slightly larger IOs --
yielding 90+% throughput improvements.  Having precise control over the
time taken to wait for larger requests to build affords control beyond
that of waiting for certain IO sizes to accumulate (which would require
a deadline anyway).  This knob will only ever make sense with sequential
IO workloads and the particular value used is storage configuration
specific.

Given the expected niche use-case for when this knob is useful it has
been deemed acceptable to expose this relatively crude method for
crafting optimal IO on specific storage -- especially given the solution
is simple yet effective.  In the context of DM multipath, it is
advisable to tune this sysfs attribute to a value that offers the best
performance for the common case (e.g. if 4 paths are expected active,
tune for that; if paths fail then performance may be slightly reduced).

Alternatives were explored to have request-based DM autotune this value
(e.g. if/when paths fail) but they were quickly deemed too fragile and
complex to warrant further design and development time.  If this problem
proves more common as faster storage emerges we'll have to look at
elevating a generic solution into the block core.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 Documentation/ABI/testing/sysfs-block-dm | 14 ++++++++
 drivers/md/dm-sysfs.c                    |  2 ++
 drivers/md/dm.c                          | 57 +++++++++++++++++++++++++++++---
 drivers/md/dm.h                          |  4 +++
 4 files changed, 73 insertions(+), 4 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-block-dm b/Documentation/ABI/testing/sysfs-block-dm
index 87ca569..1becc94 100644
--- a/Documentation/ABI/testing/sysfs-block-dm
+++ b/Documentation/ABI/testing/sysfs-block-dm
@@ -23,3 +23,17 @@ Description:	Device-mapper device suspend state.
 		Contains the value 1 while the device is suspended.
 		Otherwise it contains 0. Read-only attribute.
 Users:		util-linux, device-mapper udev rules
+
+What:		/sys/block/dm-<num>/dm/rq_based_seq_io_merge_deadline
+Date:		March 2015
+KernelVersion:	4.0
+Contact:	dm-devel@redhat.com
+Description:	Allow control over how long a request that is a
+		reasonable merge candidate can be queued on the request
+		queue.  The resolution of this deadline is in
+		microseconds (ranging from 1 to 100000 usecs).
+		Setting this attribute to 0 (the default) will disable
+		request-based DM's merge heuristic and associated extra
+		accounting.  This attribute is not applicable to
+		bio-based DM devices so it will only ever report 0 for
+		them.
diff --git a/drivers/md/dm-sysfs.c b/drivers/md/dm-sysfs.c
index 1271c31..f5bb394 100644
--- a/drivers/md/dm-sysfs.c
+++ b/drivers/md/dm-sysfs.c
@@ -92,11 +92,13 @@ static ssize_t dm_attr_suspended_show(struct mapped_device *md, char *buf)
 static DM_ATTR_RO(name);
 static DM_ATTR_RO(uuid);
 static DM_ATTR_RO(suspended);
+static DM_ATTR_RW(rq_based_seq_io_merge_deadline);
 
 static struct attribute *dm_attrs[] = {
 	&dm_attr_name.attr,
 	&dm_attr_uuid.attr,
 	&dm_attr_suspended.attr,
+	&dm_attr_rq_based_seq_io_merge_deadline.attr,
 	NULL,
 };
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 6efac0c..0c51c01 100644
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
+	unsigned seq_rq_merge_deadline_usecs;
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
+	if (md->seq_rq_merge_deadline_usecs) {
+		md->last_rq_pos = rq_end_sector(orig);
+		md->last_rq_rw = rq_data_dir(orig);
+		md->last_rq_start_time = ktime_get();
+	}
 
 	/*
 	 * Hold the md reference here for the in-flight I/O.
@@ -1945,6 +1951,45 @@ static void dm_start_request(struct mapped_device *md, struct request *orig)
 	dm_get(md);
 }
 
+#define MAX_SEQ_RQ_MERGE_DEADLINE_USECS 100000
+
+ssize_t dm_attr_rq_based_seq_io_merge_deadline_show(struct mapped_device *md, char *buf)
+{
+	return sprintf(buf, "%u\n", md->seq_rq_merge_deadline_usecs);
+}
+
+ssize_t dm_attr_rq_based_seq_io_merge_deadline_store(struct mapped_device *md,
+						     const char *buf, size_t count)
+{
+	unsigned deadline;
+
+	if (!dm_request_based(md))
+		return count;
+
+	if (kstrtouint(buf, 10, &deadline))
+		return -EINVAL;
+
+	if (deadline > MAX_SEQ_RQ_MERGE_DEADLINE_USECS)
+		deadline = MAX_SEQ_RQ_MERGE_DEADLINE_USECS;
+
+	md->seq_rq_merge_deadline_usecs = deadline;
+
+	return count;
+}
+
+static bool dm_request_peeked_before_merge_deadline(struct mapped_device *md)
+{
+	ktime_t kt_deadline;
+
+	if (!md->seq_rq_merge_deadline_usecs)
+		return false;
+
+	kt_deadline = ns_to_ktime((u64)md->seq_rq_merge_deadline_usecs * NSEC_PER_USEC);
+	kt_deadline = ktime_add_safe(md->last_rq_start_time, kt_deadline);
+
+	return !ktime_after(ktime_get(), kt_deadline);
+}
+
 /*
  * q->request_fn for request-based dm.
  * Called with the queue lock held.
@@ -1987,7 +2032,8 @@ static void dm_request_fn(struct request_queue *q)
 			continue;
 		}
 
-		if (md_in_flight(md) && rq->bio && rq->bio->bi_vcnt == 1 &&
+		if (dm_request_peeked_before_merge_deadline(md) &&
+		    md_in_flight(md) && rq->bio && rq->bio->bi_vcnt == 1 &&
 		    md->last_rq_pos == pos && md->last_rq_rw == rq_data_dir(rq))
 			goto delay_and_out;
 
@@ -2527,6 +2573,9 @@ static int dm_init_request_based_queue(struct mapped_device *md)
 	if (!q)
 		return 0;
 
+	/* disable dm_request_fn's merge heuristic by default */
+	md->seq_rq_merge_deadline_usecs = 0;
+
 	md->queue = q;
 	dm_init_md_queue(md);
 	blk_queue_softirq_done(md->queue, dm_softirq_done);
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index db49586..5522422 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -234,4 +234,8 @@ static inline bool dm_message_test_buffer_overflow(char *result, unsigned maxlen
 	return !maxlen || strlen(result) + 1 >= maxlen;
 }
 
+ssize_t dm_attr_rq_based_seq_io_merge_deadline_show(struct mapped_device *md, char *buf);
+ssize_t dm_attr_rq_based_seq_io_merge_deadline_store(struct mapped_device *md,
+						     const char *buf, size_t count);
+
 #endif
-- 
1.9.3 (Apple Git-50)
