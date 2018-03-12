From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH] Revert "dm mpath: remove unnecessary NVMe
	branching in favor of scsi_dh checks"
Date: Mon, 12 Mar 2018 13:28:08 -0700
Message-ID: <20180312202808.3556-1-bart.vanassche@wdc.com>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: Bart Van Assche <bart.vanassche@wdc.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

This patch fixes the following kernel crash:

INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
CPU: 1 PID: 155 Comm: kworker/1:1H Not tainted 4.16.0-rc5-dbg+ #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
Workqueue: kblockd blk_mq_run_work_fn
Call Trace:
 dump_stack+0x85/0xc7
 register_lock_class+0x82a/0x830
 __lock_acquire+0x141/0x1b10
 lock_acquire+0xc9/0x260
 _raw_spin_lock_irqsave+0x41/0x50
 __wake_up_common_lock+0x9e/0x100
 pg_init_done+0x100/0x240 [dm_multipath]
 multipath_clone_and_map+0x32c/0x340 [dm_multipath]
 map_request+0xc1/0x550 [dm_mod]
 dm_mq_queue_rq+0xf9/0x1a0 [dm_mod]
 blk_mq_dispatch_rq_list+0x143/0xac0
 blk_mq_sched_dispatch_requests+0x23d/0x2f0
 __blk_mq_run_hw_queue+0xdb/0x160
 process_one_work+0x441/0xa50
 worker_thread+0x76/0x6c0
 kthread+0x1b2/0x1d0
 ret_from_fork+0x24/0x30
==================================================================
BUG: KASAN: null-ptr-deref in __wake_up_common+0x60/0x230
Read of size 8 at addr 0000000000000000 by task kworker/1:1H/155

CPU: 1 PID: 155 Comm: kworker/1:1H Not tainted 4.16.0-rc5-dbg+ #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
Workqueue: kblockd blk_mq_run_work_fn
Call Trace:
 dump_stack+0x85/0xc7
 kasan_report+0x139/0x350
 __wake_up_common+0x60/0x230
 __wake_up_common_lock+0xb9/0x100
 pg_init_done+0x100/0x240 [dm_multipath]
 multipath_clone_and_map+0x32c/0x340 [dm_multipath]
 map_request+0xc1/0x550 [dm_mod]
 dm_mq_queue_rq+0xf9/0x1a0 [dm_mod]
 blk_mq_dispatch_rq_list+0x143/0xac0
 blk_mq_sched_dispatch_requests+0x23d/0x2f0
 __blk_mq_run_hw_queue+0xdb/0x160
 process_one_work+0x441/0xa50
 worker_thread+0x76/0x6c0
 kthread+0x1b2/0x1d0
 ret_from_fork+0x24/0x30
==================================================================

Fixes: 8d47e65948dd ("dm mpath: remove unnecessary NVMe branching in favor of scsi_dh checks")
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
---
 drivers/md/dm-mpath.c | 66 +++++++++++++++++++++++++++++----------------------
 1 file changed, 37 insertions(+), 29 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 3fde9e9faddd..7d3e572072f5 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -22,7 +22,6 @@
 #include <linux/time.h>
 #include <linux/workqueue.h>
 #include <linux/delay.h>
-#include <scsi/scsi_device.h>
 #include <scsi/scsi_dh.h>
 #include <linux/atomic.h>
 #include <linux/blk-mq.h>
@@ -212,13 +211,25 @@ static int alloc_multipath_stage2(struct dm_target *ti, struct multipath *m)
 		else
 			m->queue_mode = DM_TYPE_REQUEST_BASED;
 
-	} else if (m->queue_mode == DM_TYPE_BIO_BASED) {
+	} else if (m->queue_mode == DM_TYPE_BIO_BASED ||
+		   m->queue_mode == DM_TYPE_NVME_BIO_BASED) {
 		INIT_WORK(&m->process_queued_bios, process_queued_bios);
-		/*
-		 * bio-based doesn't support any direct scsi_dh management;
-		 * it just discovers if a scsi_dh is attached.
-		 */
-		set_bit(MPATHF_RETAIN_ATTACHED_HW_HANDLER, &m->flags);
+
+		if (m->queue_mode == DM_TYPE_BIO_BASED) {
+			/*
+			 * bio-based doesn't support any direct scsi_dh management;
+			 * it just discovers if a scsi_dh is attached.
+			 */
+			set_bit(MPATHF_RETAIN_ATTACHED_HW_HANDLER, &m->flags);
+		}
+	}
+
+	if (m->queue_mode != DM_TYPE_NVME_BIO_BASED) {
+		set_bit(MPATHF_QUEUE_IO, &m->flags);
+		atomic_set(&m->pg_init_in_progress, 0);
+		atomic_set(&m->pg_init_count, 0);
+		m->pg_init_delay_msecs = DM_PG_INIT_DELAY_DEFAULT;
+		init_waitqueue_head(&m->pg_init_wait);
 	}
 
 	dm_table_set_type(ti->table, m->queue_mode);
@@ -326,12 +337,14 @@ static void __switch_pg(struct multipath *m, struct priority_group *pg)
 {
 	m->current_pg = pg;
 
+	if (m->queue_mode == DM_TYPE_NVME_BIO_BASED)
+		return;
+
 	/* Must we initialise the PG first, and queue I/O till it's ready? */
 	if (m->hw_handler_name) {
 		set_bit(MPATHF_PG_INIT_REQUIRED, &m->flags);
 		set_bit(MPATHF_QUEUE_IO, &m->flags);
 	} else {
-		/* FIXME: not needed if no scsi_dh is attached */
 		clear_bit(MPATHF_PG_INIT_REQUIRED, &m->flags);
 		clear_bit(MPATHF_QUEUE_IO, &m->flags);
 	}
@@ -372,7 +385,8 @@ static struct pgpath *choose_pgpath(struct multipath *m, size_t nr_bytes)
 	unsigned bypassed = 1;
 
 	if (!atomic_read(&m->nr_valid_paths)) {
-		clear_bit(MPATHF_QUEUE_IO, &m->flags);
+		if (m->queue_mode != DM_TYPE_NVME_BIO_BASED)
+			clear_bit(MPATHF_QUEUE_IO, &m->flags);
 		goto failed;
 	}
 
@@ -585,7 +599,7 @@ static struct pgpath *__map_bio(struct multipath *m, struct bio *bio)
 	return pgpath;
 }
 
-static struct pgpath *__map_bio_fast(struct multipath *m, struct bio *bio)
+static struct pgpath *__map_bio_nvme(struct multipath *m, struct bio *bio)
 {
 	struct pgpath *pgpath;
 	unsigned long flags;
@@ -620,8 +634,8 @@ static int __multipath_map_bio(struct multipath *m, struct bio *bio,
 {
 	struct pgpath *pgpath;
 
-	if (!m->hw_handler_name)
-		pgpath = __map_bio_fast(m, bio);
+	if (m->queue_mode == DM_TYPE_NVME_BIO_BASED)
+		pgpath = __map_bio_nvme(m, bio);
 	else
 		pgpath = __map_bio(m, bio);
 
@@ -661,7 +675,8 @@ static void process_queued_io_list(struct multipath *m)
 {
 	if (m->queue_mode == DM_TYPE_MQ_REQUEST_BASED)
 		dm_mq_kick_requeue_list(dm_table_get_md(m->ti->table));
-	else if (m->queue_mode == DM_TYPE_BIO_BASED)
+	else if (m->queue_mode == DM_TYPE_BIO_BASED ||
+		 m->queue_mode == DM_TYPE_NVME_BIO_BASED)
 		queue_work(kmultipathd, &m->process_queued_bios);
 }
 
@@ -823,16 +838,6 @@ static int setup_scsi_dh(struct block_device *bdev, struct multipath *m, char **
 			 */
 			kfree(m->hw_handler_name);
 			m->hw_handler_name = attached_handler_name;
-
-			/*
-			 * Init fields that are only used when a scsi_dh is attached
-			 */
-			if (!test_and_set_bit(MPATHF_QUEUE_IO, &m->flags)) {
-				atomic_set(&m->pg_init_in_progress, 0);
-				atomic_set(&m->pg_init_count, 0);
-				m->pg_init_delay_msecs = DM_PG_INIT_DELAY_DEFAULT;
-				init_waitqueue_head(&m->pg_init_wait);
-			}
 		}
 	}
 
@@ -868,7 +873,6 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 	int r;
 	struct pgpath *p;
 	struct multipath *m = ti->private;
-	struct scsi_device *sdev;
 
 	/* we need at least a path arg */
 	if (as->argc < 1) {
@@ -887,9 +891,7 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 		goto bad;
 	}
 
-	sdev = scsi_device_from_queue(bdev_get_queue(p->path.dev->bdev));
-	if (sdev) {
-		put_device(&sdev->sdev_gendev);
+	if (m->queue_mode != DM_TYPE_NVME_BIO_BASED) {
 		INIT_DELAYED_WORK(&p->activate_path, activate_path_work);
 		r = setup_scsi_dh(p->path.dev->bdev, m, &ti->error);
 		if (r) {
@@ -999,7 +1001,8 @@ static int parse_hw_handler(struct dm_arg_set *as, struct multipath *m)
 	if (!hw_argc)
 		return 0;
 
-	if (m->queue_mode == DM_TYPE_BIO_BASED) {
+	if (m->queue_mode == DM_TYPE_BIO_BASED ||
+	    m->queue_mode == DM_TYPE_NVME_BIO_BASED) {
 		dm_consume_args(as, hw_argc);
 		DMERR("bio-based multipath doesn't allow hardware handler args");
 		return 0;
@@ -1088,6 +1091,8 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
 
 			if (!strcasecmp(queue_mode_name, "bio"))
 				m->queue_mode = DM_TYPE_BIO_BASED;
+			else if (!strcasecmp(queue_mode_name, "nvme"))
+				m->queue_mode = DM_TYPE_NVME_BIO_BASED;
 			else if (!strcasecmp(queue_mode_name, "rq"))
 				m->queue_mode = DM_TYPE_REQUEST_BASED;
 			else if (!strcasecmp(queue_mode_name, "mq"))
@@ -1188,7 +1193,7 @@ static int multipath_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	ti->num_discard_bios = 1;
 	ti->num_write_same_bios = 1;
 	ti->num_write_zeroes_bios = 1;
-	if (m->queue_mode == DM_TYPE_BIO_BASED)
+	if (m->queue_mode == DM_TYPE_BIO_BASED || m->queue_mode == DM_TYPE_NVME_BIO_BASED)
 		ti->per_io_data_size = multipath_per_bio_data_size();
 	else
 		ti->per_io_data_size = sizeof(struct dm_mpath_io);
@@ -1725,6 +1730,9 @@ static void multipath_status(struct dm_target *ti, status_type_t type,
 			case DM_TYPE_BIO_BASED:
 				DMEMIT("queue_mode bio ");
 				break;
+			case DM_TYPE_NVME_BIO_BASED:
+				DMEMIT("queue_mode nvme ");
+				break;
 			case DM_TYPE_MQ_REQUEST_BASED:
 				DMEMIT("queue_mode mq ");
 				break;
-- 
2.16.2
