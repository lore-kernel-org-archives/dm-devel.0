From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [patch 5/5] block: use a driver-specific handler for the
	"inflight" value
Date: Tue, 06 Nov 2018 22:35:03 +0100
Message-ID: <20181106213858.391264280@debian-a64.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-inflight.patch
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

Device mapper was converted to percpu inflight counters. In order to
display the correct values in the "inflight" sysfs file, we need a custom
callback that sums the percpu counters.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 block/blk-settings.c   |    6 ++++++
 block/genhd.c          |    5 +++++
 drivers/md/dm.c        |   18 ++++++++++++++++++
 include/linux/blkdev.h |    4 ++++
 4 files changed, 33 insertions(+)

Index: linux-2.6/block/genhd.c
===================================================================
--- linux-2.6.orig/block/genhd.c	2018-11-06 22:31:46.350000000 +0100
+++ linux-2.6/block/genhd.c	2018-11-06 22:31:46.350000000 +0100
@@ -85,6 +85,11 @@ void part_in_flight(struct request_queue
 void part_in_flight_rw(struct request_queue *q, struct hd_struct *part,
 		       unsigned int inflight[2])
 {
+	if (q->get_inflight_fn) {
+		q->get_inflight_fn(q, inflight);
+		return;
+	}
+
 	if (q->mq_ops) {
 		blk_mq_in_flight_rw(q, part, inflight);
 		return;
Index: linux-2.6/include/linux/blkdev.h
===================================================================
--- linux-2.6.orig/include/linux/blkdev.h	2018-11-06 22:31:46.350000000 +0100
+++ linux-2.6/include/linux/blkdev.h	2018-11-06 22:31:46.350000000 +0100
@@ -324,6 +324,7 @@ typedef int (lld_busy_fn) (struct reques
 typedef int (bsg_job_fn) (struct bsg_job *);
 typedef int (init_rq_fn)(struct request_queue *, struct request *, gfp_t);
 typedef void (exit_rq_fn)(struct request_queue *, struct request *);
+typedef void (get_inflight_fn)(struct request_queue *, unsigned int [2]);
 
 enum blk_eh_timer_return {
 	BLK_EH_DONE,		/* drivers has completed the command */
@@ -466,6 +467,8 @@ struct request_queue {
 	exit_rq_fn		*exit_rq_fn;
 	/* Called from inside blk_get_request() */
 	void (*initialize_rq_fn)(struct request *rq);
+	/* Called to get the "inflight" values */
+	get_inflight_fn		*get_inflight_fn;
 
 	const struct blk_mq_ops	*mq_ops;
 
@@ -1232,6 +1235,7 @@ extern int blk_queue_dma_drain(struct re
 			       dma_drain_needed_fn *dma_drain_needed,
 			       void *buf, unsigned int size);
 extern void blk_queue_lld_busy(struct request_queue *q, lld_busy_fn *fn);
+extern void blk_queue_get_inflight(struct request_queue *q, get_inflight_fn *fn);
 extern void blk_queue_segment_boundary(struct request_queue *, unsigned long);
 extern void blk_queue_virt_boundary(struct request_queue *, unsigned long);
 extern void blk_queue_prep_rq(struct request_queue *, prep_rq_fn *pfn);
Index: linux-2.6/block/blk-settings.c
===================================================================
--- linux-2.6.orig/block/blk-settings.c	2018-11-06 22:31:46.350000000 +0100
+++ linux-2.6/block/blk-settings.c	2018-11-06 22:31:46.350000000 +0100
@@ -79,6 +79,12 @@ void blk_queue_lld_busy(struct request_q
 }
 EXPORT_SYMBOL_GPL(blk_queue_lld_busy);
 
+void blk_queue_get_inflight(struct request_queue *q, get_inflight_fn *fn)
+{
+	q->get_inflight_fn = fn;
+}
+EXPORT_SYMBOL_GPL(blk_queue_get_inflight);
+
 /**
  * blk_set_default_limits - reset limits to default values
  * @lim:  the queue_limits structure to reset
Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c	2018-11-06 22:31:46.350000000 +0100
+++ linux-2.6/drivers/md/dm.c	2018-11-06 22:31:46.350000000 +0100
@@ -662,6 +662,23 @@ static void end_io_acct(struct dm_io *io
 	}
 }
 
+static void dm_get_inflight(struct request_queue *q, unsigned int inflight[2])
+{
+	struct mapped_device *md = q->queuedata;
+	int cpu;
+
+	inflight[READ] = inflight[WRITE] = 0;
+	for_each_possible_cpu(cpu) {
+		struct dm_percpu *p = per_cpu_ptr(md->counters, cpu);
+		inflight[READ] += p->inflight[READ];
+		inflight[WRITE] += p->inflight[WRITE];
+	}
+	if ((int)inflight[READ] < 0)
+		inflight[READ] = 0;
+	if ((int)inflight[WRITE] < 0)
+		inflight[WRITE] = 0;
+}
+
 /*
  * Add the bio to the list of deferred io.
  */
@@ -2242,6 +2259,7 @@ int dm_setup_md_queue(struct mapped_devi
 	case DM_TYPE_NVME_BIO_BASED:
 		dm_init_normal_md_queue(md);
 		blk_queue_make_request(md->queue, dm_make_request);
+		blk_queue_get_inflight(md->queue, dm_get_inflight);
 		break;
 	case DM_TYPE_NONE:
 		WARN_ON_ONCE(true);
