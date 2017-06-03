From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/13] block: introduce new block status code type
Date: Sat,  3 Jun 2017 09:38:04 +0200
Message-ID: <20170603073806.2046-12-hch@lst.de>
References: <20170603073806.2046-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170603073806.2046-1-hch@lst.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, linux-btrfs@vger.kernel.org
List-Id: dm-devel.ids

Currently we use nornal Linux errno values in the block layer, and while
we accept any error a few have overloaded magic meanings.  This patch
instead introduces a new  blk_status_t value that holds block layer specific
status codes and explicitly explains their meaning.  Helpers to convert from
and to the previous special meanings are provided for now, but I suspect
we want to get rid of them in the long run - those drivers that have a
errno input (e.g. networking) usually get errnos that don't know about
the special block layer overloads, and similarly returning them to userspace
will usually return somethings that strictly speaking isn't correct
for file system operations, but that's left as an exercise for later.

For now the set of errors is a very limited set that closely corresponds
to the previous overloaded errno values, but there is some low hanging
fruite to improve it.

blk_status_t (ab)uses the sparse __bitwise annotations to allow for sparse
typechecking, so that we can easily catch places passing the wrong values.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/s390/include/asm/eadm.h        |   6 +-
 arch/um/drivers/ubd_kern.c          |   2 +-
 block/blk-core.c                    | 156 +++++++++++++++++++++---------------
 block/blk-exec.c                    |   4 +-
 block/blk-flush.c                   |   8 +-
 block/blk-mq.c                      |   8 +-
 block/bsg-lib.c                     |   4 +-
 block/bsg.c                         |   6 +-
 drivers/block/DAC960.c              |   2 +-
 drivers/block/amiflop.c             |  10 +--
 drivers/block/aoe/aoecmd.c          |   2 +-
 drivers/block/ataflop.c             |  16 ++--
 drivers/block/cciss.c               |   3 +-
 drivers/block/floppy.c              |   4 +-
 drivers/block/loop.c                |   2 +-
 drivers/block/mtip32xx/mtip32xx.c   |  16 ++--
 drivers/block/mtip32xx/mtip32xx.h   |   2 +-
 drivers/block/nbd.c                 |  14 ++--
 drivers/block/null_blk.c            |   9 ++-
 drivers/block/paride/pcd.c          |   8 +-
 drivers/block/paride/pd.c           |   2 +-
 drivers/block/paride/pf.c           |  18 ++---
 drivers/block/ps3disk.c             |  11 +--
 drivers/block/rbd.c                 |   8 +-
 drivers/block/skd_main.c            |  31 ++++---
 drivers/block/sunvdc.c              |   4 +-
 drivers/block/swim.c                |   6 +-
 drivers/block/swim3.c               |  26 +++---
 drivers/block/sx8.c                 |  20 ++---
 drivers/block/virtio_blk.c          |  10 +--
 drivers/block/xen-blkfront.c        |  16 ++--
 drivers/block/xsysace.c             |   8 +-
 drivers/block/z2ram.c               |   4 +-
 drivers/cdrom/gdrom.c               |   9 ++-
 drivers/ide/ide-atapi.c             |   9 ++-
 drivers/ide/ide-cd.c                |  10 +--
 drivers/ide/ide-dma.c               |   2 +-
 drivers/ide/ide-eh.c                |  16 ++--
 drivers/ide/ide-floppy.c            |   6 +-
 drivers/ide/ide-io.c                |  10 +--
 drivers/ide/ide-pm.c                |   6 +-
 drivers/ide/ide-tape.c              |   2 +-
 drivers/ide/ide-taskfile.c          |   6 +-
 drivers/ide/siimage.c               |   6 +-
 drivers/md/dm-mpath.c               |  27 +++----
 drivers/md/dm-rq.c                  |  20 ++---
 drivers/md/dm-rq.h                  |   2 +-
 drivers/memstick/core/ms_block.c    |   7 +-
 drivers/memstick/core/mspro_block.c |   8 +-
 drivers/mmc/core/block.c            |  37 +++++----
 drivers/mmc/core/queue.c            |   2 +-
 drivers/mtd/mtd_blkdevs.c           |  30 ++++---
 drivers/mtd/ubi/block.c             |   2 +-
 drivers/nvme/host/core.c            |  29 +++----
 drivers/nvme/host/lightnvm.c        |   2 +-
 drivers/nvme/host/pci.c             |   8 +-
 drivers/s390/block/dasd.c           |  36 +++++----
 drivers/s390/block/scm_blk.c        |   8 +-
 drivers/s390/block/scm_blk.h        |   4 +-
 drivers/s390/cio/eadm_sch.c         |   6 +-
 drivers/s390/cio/scm.c              |   2 +-
 drivers/sbus/char/jsflash.c         |   4 +-
 drivers/scsi/osd/osd_initiator.c    |  20 ++---
 drivers/scsi/osst.c                 |   2 +-
 drivers/scsi/scsi_error.c           |   2 +-
 drivers/scsi/scsi_lib.c             |  51 ++++--------
 drivers/scsi/scsi_transport_sas.c   |   2 +-
 drivers/scsi/sg.c                   |   6 +-
 drivers/scsi/st.c                   |   2 +-
 drivers/target/target_core_pscsi.c  |   4 +-
 include/linux/blk-mq.h              |   4 +-
 include/linux/blk_types.h           |  16 ++++
 include/linux/blkdev.h              |  21 ++---
 include/linux/device-mapper.h       |   2 +-
 include/linux/ide.h                 |   6 +-
 include/scsi/osd_initiator.h        |   2 +-
 76 files changed, 474 insertions(+), 428 deletions(-)

diff --git a/arch/s390/include/asm/eadm.h b/arch/s390/include/asm/eadm.h
index 67026300c88e..144809a3f4f6 100644
--- a/arch/s390/include/asm/eadm.h
+++ b/arch/s390/include/asm/eadm.h
@@ -3,6 +3,7 @@
 
 #include <linux/types.h>
 #include <linux/device.h>
+#include <linux/blkdev.h>
 
 struct arqb {
 	u64 data;
@@ -105,13 +106,14 @@ struct scm_driver {
 	int (*probe) (struct scm_device *scmdev);
 	int (*remove) (struct scm_device *scmdev);
 	void (*notify) (struct scm_device *scmdev, enum scm_event event);
-	void (*handler) (struct scm_device *scmdev, void *data, int error);
+	void (*handler) (struct scm_device *scmdev, void *data,
+			blk_status_t error);
 };
 
 int scm_driver_register(struct scm_driver *scmdrv);
 void scm_driver_unregister(struct scm_driver *scmdrv);
 
 int eadm_start_aob(struct aob *aob);
-void scm_irq_handler(struct aob *aob, int error);
+void scm_irq_handler(struct aob *aob, blk_status_t error);
 
 #endif /* _ASM_S390_EADM_H */
diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index 85410279beab..b55fe9bf5d3e 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -534,7 +534,7 @@ static void ubd_handler(void)
 		for (count = 0; count < n/sizeof(struct io_thread_req *); count++) {
 			blk_end_request(
 				(*irq_req_buffer)[count]->req,
-				0,
+				BLK_STS_OK,
 				(*irq_req_buffer)[count]->length
 			);
 			kfree((*irq_req_buffer)[count]);
diff --git a/block/blk-core.c b/block/blk-core.c
index c7068520794b..e942a9f814c7 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -129,11 +129,66 @@ void blk_rq_init(struct request_queue *q, struct request *rq)
 }
 EXPORT_SYMBOL(blk_rq_init);
 
+static const struct {
+	int		errno;
+	const char	*name;
+} blk_errors[] = {
+	[BLK_STS_OK]		= { 0,		"" },
+	[BLK_STS_NOTSUPP]	= { -EOPNOTSUPP, "operation not supported" },
+	[BLK_STS_TIMEOUT]	= { -ETIMEDOUT,	"timeout" },
+	[BLK_STS_NOSPC]		= { -ENOSPC,	"critical space allocation" },
+	[BLK_STS_TRANSPORT]	= { -ENOLINK,	"recoverable transport" },
+	[BLK_STS_TARGET]	= { -EREMOTEIO,	"critical target" },
+	[BLK_STS_NEXUS]		= { -EBADE,	"critical nexus" },
+	[BLK_STS_MEDIUM]	= { -ENODATA,	"critical medium" },
+	[BLK_STS_PROTECTION]	= { -EILSEQ,	"protection" },
+	[BLK_STS_RESOURCE]	= { -ENOMEM,	"kernel resource" },
+
+	/* everything else not covered above: */
+	[BLK_STS_IOERR]		= { -EIO,	"I/O" },
+};
+
+blk_status_t errno_to_blk_status(int errno)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(blk_errors); i++) {
+		if (blk_errors[i].errno == errno)
+			return (__force blk_status_t)i;
+	}
+
+	return BLK_STS_IOERR;
+}
+EXPORT_SYMBOL_GPL(errno_to_blk_status);
+
+int blk_status_to_errno(blk_status_t status)
+{
+	int idx = (__force int)status;
+
+	if (WARN_ON_ONCE(idx > ARRAY_SIZE(blk_errors)))
+		return -EIO;
+	return blk_errors[idx].errno;
+}
+EXPORT_SYMBOL_GPL(blk_status_to_errno);
+
+static void print_req_error(struct request *req, blk_status_t status)
+{
+	int idx = (__force int)status;
+
+	if (WARN_ON_ONCE(idx > ARRAY_SIZE(blk_errors)))
+		return;
+
+	printk_ratelimited(KERN_ERR "%s: %s error, dev %s, sector %llu\n",
+			   __func__, blk_errors[idx].name, req->rq_disk ?
+			   req->rq_disk->disk_name : "?",
+			   (unsigned long long)blk_rq_pos(req));
+}
+
 static void req_bio_endio(struct request *rq, struct bio *bio,
-			  unsigned int nbytes, int error)
+			  unsigned int nbytes, blk_status_t error)
 {
 	if (error)
-		bio->bi_error = error;
+		bio->bi_error = blk_status_to_errno(error);
 
 	if (unlikely(rq->rq_flags & RQF_QUIET))
 		bio_set_flag(bio, BIO_QUIET);
@@ -2177,29 +2232,29 @@ static int blk_cloned_rq_check_limits(struct request_queue *q,
  * @q:  the queue to submit the request
  * @rq: the request being queued
  */
-int blk_insert_cloned_request(struct request_queue *q, struct request *rq)
+blk_status_t blk_insert_cloned_request(struct request_queue *q, struct request *rq)
 {
 	unsigned long flags;
 	int where = ELEVATOR_INSERT_BACK;
 
 	if (blk_cloned_rq_check_limits(q, rq))
-		return -EIO;
+		return BLK_STS_IOERR;
 
 	if (rq->rq_disk &&
 	    should_fail_request(&rq->rq_disk->part0, blk_rq_bytes(rq)))
-		return -EIO;
+		return BLK_STS_IOERR;
 
 	if (q->mq_ops) {
 		if (blk_queue_io_stat(q))
 			blk_account_io_start(rq, true);
 		blk_mq_sched_insert_request(rq, false, true, false, false);
-		return 0;
+		return BLK_STS_OK;
 	}
 
 	spin_lock_irqsave(q->queue_lock, flags);
 	if (unlikely(blk_queue_dying(q))) {
 		spin_unlock_irqrestore(q->queue_lock, flags);
-		return -ENODEV;
+		return BLK_STS_IOERR;
 	}
 
 	/*
@@ -2216,7 +2271,7 @@ int blk_insert_cloned_request(struct request_queue *q, struct request *rq)
 		__blk_run_queue(q);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
-	return 0;
+	return BLK_STS_OK;
 }
 EXPORT_SYMBOL_GPL(blk_insert_cloned_request);
 
@@ -2450,15 +2505,14 @@ struct request *blk_peek_request(struct request_queue *q)
 			rq = NULL;
 			break;
 		} else if (ret == BLKPREP_KILL || ret == BLKPREP_INVALID) {
-			int err = (ret == BLKPREP_INVALID) ? -EREMOTEIO : -EIO;
-
 			rq->rq_flags |= RQF_QUIET;
 			/*
 			 * Mark this request as started so we don't trigger
 			 * any debug logic in the end I/O path.
 			 */
 			blk_start_request(rq);
-			__blk_end_request_all(rq, err);
+			__blk_end_request_all(rq, ret == BLKPREP_INVALID ?
+					BLK_STS_TARGET : BLK_STS_IOERR);
 		} else {
 			printk(KERN_ERR "%s: bad return=%d\n", __func__, ret);
 			break;
@@ -2547,7 +2601,7 @@ EXPORT_SYMBOL(blk_fetch_request);
 /**
  * blk_update_request - Special helper function for request stacking drivers
  * @req:      the request being processed
- * @error:    %0 for success, < %0 for error
+ * @error:    block status code
  * @nr_bytes: number of bytes to complete @req
  *
  * Description:
@@ -2566,49 +2620,19 @@ EXPORT_SYMBOL(blk_fetch_request);
  *     %false - this request doesn't have any more data
  *     %true  - this request has more data
  **/
-bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
+bool blk_update_request(struct request *req, blk_status_t error,
+		unsigned int nr_bytes)
 {
 	int total_bytes;
 
-	trace_block_rq_complete(req, error, nr_bytes);
+	trace_block_rq_complete(req, blk_status_to_errno(error), nr_bytes);
 
 	if (!req->bio)
 		return false;
 
-	if (error && !blk_rq_is_passthrough(req) &&
-	    !(req->rq_flags & RQF_QUIET)) {
-		char *error_type;
-
-		switch (error) {
-		case -ENOLINK:
-			error_type = "recoverable transport";
-			break;
-		case -EREMOTEIO:
-			error_type = "critical target";
-			break;
-		case -EBADE:
-			error_type = "critical nexus";
-			break;
-		case -ETIMEDOUT:
-			error_type = "timeout";
-			break;
-		case -ENOSPC:
-			error_type = "critical space allocation";
-			break;
-		case -ENODATA:
-			error_type = "critical medium";
-			break;
-		case -EIO:
-		default:
-			error_type = "I/O";
-			break;
-		}
-		printk_ratelimited(KERN_ERR "%s: %s error, dev %s, sector %llu\n",
-				   __func__, error_type, req->rq_disk ?
-				   req->rq_disk->disk_name : "?",
-				   (unsigned long long)blk_rq_pos(req));
-
-	}
+	if (unlikely(error && !blk_rq_is_passthrough(req) &&
+		     !(req->rq_flags & RQF_QUIET)))
+		print_req_error(req, error);
 
 	blk_account_io_completion(req, nr_bytes);
 
@@ -2674,7 +2698,7 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 }
 EXPORT_SYMBOL_GPL(blk_update_request);
 
-static bool blk_update_bidi_request(struct request *rq, int error,
+static bool blk_update_bidi_request(struct request *rq, blk_status_t error,
 				    unsigned int nr_bytes,
 				    unsigned int bidi_bytes)
 {
@@ -2715,7 +2739,7 @@ EXPORT_SYMBOL_GPL(blk_unprep_request);
 /*
  * queue lock must be held
  */
-void blk_finish_request(struct request *req, int error)
+void blk_finish_request(struct request *req, blk_status_t error)
 {
 	struct request_queue *q = req->q;
 
@@ -2752,7 +2776,7 @@ EXPORT_SYMBOL(blk_finish_request);
 /**
  * blk_end_bidi_request - Complete a bidi request
  * @rq:         the request to complete
- * @error:      %0 for success, < %0 for error
+ * @error:      block status code
  * @nr_bytes:   number of bytes to complete @rq
  * @bidi_bytes: number of bytes to complete @rq->next_rq
  *
@@ -2766,7 +2790,7 @@ EXPORT_SYMBOL(blk_finish_request);
  *     %false - we are done with this request
  *     %true  - still buffers pending for this request
  **/
-static bool blk_end_bidi_request(struct request *rq, int error,
+static bool blk_end_bidi_request(struct request *rq, blk_status_t error,
 				 unsigned int nr_bytes, unsigned int bidi_bytes)
 {
 	struct request_queue *q = rq->q;
@@ -2785,7 +2809,7 @@ static bool blk_end_bidi_request(struct request *rq, int error,
 /**
  * __blk_end_bidi_request - Complete a bidi request with queue lock held
  * @rq:         the request to complete
- * @error:      %0 for success, < %0 for error
+ * @error:      block status code
  * @nr_bytes:   number of bytes to complete @rq
  * @bidi_bytes: number of bytes to complete @rq->next_rq
  *
@@ -2797,7 +2821,7 @@ static bool blk_end_bidi_request(struct request *rq, int error,
  *     %false - we are done with this request
  *     %true  - still buffers pending for this request
  **/
-static bool __blk_end_bidi_request(struct request *rq, int error,
+static bool __blk_end_bidi_request(struct request *rq, blk_status_t error,
 				   unsigned int nr_bytes, unsigned int bidi_bytes)
 {
 	if (blk_update_bidi_request(rq, error, nr_bytes, bidi_bytes))
@@ -2811,7 +2835,7 @@ static bool __blk_end_bidi_request(struct request *rq, int error,
 /**
  * blk_end_request - Helper function for drivers to complete the request.
  * @rq:       the request being processed
- * @error:    %0 for success, < %0 for error
+ * @error:    block status code
  * @nr_bytes: number of bytes to complete
  *
  * Description:
@@ -2822,7 +2846,8 @@ static bool __blk_end_bidi_request(struct request *rq, int error,
  *     %false - we are done with this request
  *     %true  - still buffers pending for this request
  **/
-bool blk_end_request(struct request *rq, int error, unsigned int nr_bytes)
+bool blk_end_request(struct request *rq, blk_status_t error,
+		unsigned int nr_bytes)
 {
 	return blk_end_bidi_request(rq, error, nr_bytes, 0);
 }
@@ -2831,12 +2856,12 @@ EXPORT_SYMBOL(blk_end_request);
 /**
  * blk_end_request_all - Helper function for drives to finish the request.
  * @rq: the request to finish
- * @error: %0 for success, < %0 for error
+ * @error: block status code
  *
  * Description:
  *     Completely finish @rq.
  */
-void blk_end_request_all(struct request *rq, int error)
+void blk_end_request_all(struct request *rq, blk_status_t error)
 {
 	bool pending;
 	unsigned int bidi_bytes = 0;
@@ -2852,7 +2877,7 @@ EXPORT_SYMBOL(blk_end_request_all);
 /**
  * __blk_end_request - Helper function for drivers to complete the request.
  * @rq:       the request being processed
- * @error:    %0 for success, < %0 for error
+ * @error:    block status code
  * @nr_bytes: number of bytes to complete
  *
  * Description:
@@ -2862,7 +2887,8 @@ EXPORT_SYMBOL(blk_end_request_all);
  *     %false - we are done with this request
  *     %true  - still buffers pending for this request
  **/
-bool __blk_end_request(struct request *rq, int error, unsigned int nr_bytes)
+bool __blk_end_request(struct request *rq, blk_status_t error,
+		unsigned int nr_bytes)
 {
 	return __blk_end_bidi_request(rq, error, nr_bytes, 0);
 }
@@ -2871,12 +2897,12 @@ EXPORT_SYMBOL(__blk_end_request);
 /**
  * __blk_end_request_all - Helper function for drives to finish the request.
  * @rq: the request to finish
- * @error: %0 for success, < %0 for error
+ * @error:    block status code
  *
  * Description:
  *     Completely finish @rq.  Must be called with queue lock held.
  */
-void __blk_end_request_all(struct request *rq, int error)
+void __blk_end_request_all(struct request *rq, blk_status_t error)
 {
 	bool pending;
 	unsigned int bidi_bytes = 0;
@@ -2892,7 +2918,7 @@ EXPORT_SYMBOL(__blk_end_request_all);
 /**
  * __blk_end_request_cur - Helper function to finish the current request chunk.
  * @rq: the request to finish the current chunk for
- * @error: %0 for success, < %0 for error
+ * @error:    block status code
  *
  * Description:
  *     Complete the current consecutively mapped chunk from @rq.  Must
@@ -2902,7 +2928,7 @@ EXPORT_SYMBOL(__blk_end_request_all);
  *     %false - we are done with this request
  *     %true  - still buffers pending for this request
  */
-bool __blk_end_request_cur(struct request *rq, int error)
+bool __blk_end_request_cur(struct request *rq, blk_status_t error)
 {
 	return __blk_end_request(rq, error, blk_rq_cur_bytes(rq));
 }
@@ -3243,7 +3269,7 @@ void blk_flush_plug_list(struct blk_plug *plug, bool from_schedule)
 		 * Short-circuit if @q is dead
 		 */
 		if (unlikely(blk_queue_dying(q))) {
-			__blk_end_request_all(rq, -ENODEV);
+			__blk_end_request_all(rq, BLK_STS_IOERR);
 			continue;
 		}
 
diff --git a/block/blk-exec.c b/block/blk-exec.c
index a9451e3b8587..5c0f3dc446dc 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -16,7 +16,7 @@
  * @rq: request to complete
  * @error: end I/O status of the request
  */
-static void blk_end_sync_rq(struct request *rq, int error)
+static void blk_end_sync_rq(struct request *rq, blk_status_t error)
 {
 	struct completion *waiting = rq->end_io_data;
 
@@ -69,7 +69,7 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 
 	if (unlikely(blk_queue_dying(q))) {
 		rq->rq_flags |= RQF_QUIET;
-		__blk_end_request_all(rq, -ENXIO);
+		__blk_end_request_all(rq, BLK_STS_IOERR);
 		spin_unlock_irq(q->queue_lock);
 		return;
 	}
diff --git a/block/blk-flush.c b/block/blk-flush.c
index c4e0880b54bb..a572b47fa059 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -164,7 +164,7 @@ static bool blk_flush_queue_rq(struct request *rq, bool add_front)
  */
 static bool blk_flush_complete_seq(struct request *rq,
 				   struct blk_flush_queue *fq,
-				   unsigned int seq, int error)
+				   unsigned int seq, blk_status_t error)
 {
 	struct request_queue *q = rq->q;
 	struct list_head *pending = &fq->flush_queue[fq->flush_pending_idx];
@@ -216,7 +216,7 @@ static bool blk_flush_complete_seq(struct request *rq,
 	return kicked | queued;
 }
 
-static void flush_end_io(struct request *flush_rq, int error)
+static void flush_end_io(struct request *flush_rq, blk_status_t error)
 {
 	struct request_queue *q = flush_rq->q;
 	struct list_head *running;
@@ -341,7 +341,7 @@ static bool blk_kick_flush(struct request_queue *q, struct blk_flush_queue *fq)
 	return blk_flush_queue_rq(flush_rq, false);
 }
 
-static void flush_data_end_io(struct request *rq, int error)
+static void flush_data_end_io(struct request *rq, blk_status_t error)
 {
 	struct request_queue *q = rq->q;
 	struct blk_flush_queue *fq = blk_get_flush_queue(q, NULL);
@@ -382,7 +382,7 @@ static void flush_data_end_io(struct request *rq, int error)
 		blk_run_queue_async(q);
 }
 
-static void mq_flush_data_end_io(struct request *rq, int error)
+static void mq_flush_data_end_io(struct request *rq, blk_status_t error)
 {
 	struct request_queue *q = rq->q;
 	struct blk_mq_hw_ctx *hctx;
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 22438d5036a3..adcc1c0dce6e 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -394,7 +394,7 @@ void blk_mq_free_request(struct request *rq)
 }
 EXPORT_SYMBOL_GPL(blk_mq_free_request);
 
-inline void __blk_mq_end_request(struct request *rq, int error)
+inline void __blk_mq_end_request(struct request *rq, blk_status_t error)
 {
 	blk_account_io_done(rq);
 
@@ -409,7 +409,7 @@ inline void __blk_mq_end_request(struct request *rq, int error)
 }
 EXPORT_SYMBOL(__blk_mq_end_request);
 
-void blk_mq_end_request(struct request *rq, int error)
+void blk_mq_end_request(struct request *rq, blk_status_t error)
 {
 	if (blk_update_request(rq, error, blk_rq_bytes(rq)))
 		BUG();
@@ -988,7 +988,7 @@ bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list)
 			pr_err("blk-mq: bad return on queue: %d\n", ret);
 		case BLK_MQ_RQ_QUEUE_ERROR:
 			errors++;
-			blk_mq_end_request(rq, -EIO);
+			blk_mq_end_request(rq, BLK_STS_IOERR);
 			break;
 		}
 
@@ -1433,7 +1433,7 @@ static void __blk_mq_try_issue_directly(struct request *rq, blk_qc_t *cookie,
 
 	if (ret == BLK_MQ_RQ_QUEUE_ERROR) {
 		*cookie = BLK_QC_T_NONE;
-		blk_mq_end_request(rq, -EIO);
+		blk_mq_end_request(rq, BLK_STS_IOERR);
 		return;
 	}
 
diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index 9b91daefcd9b..c4513b23f57a 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -37,7 +37,7 @@ static void bsg_destroy_job(struct kref *kref)
 	struct bsg_job *job = container_of(kref, struct bsg_job, kref);
 	struct request *rq = job->req;
 
-	blk_end_request_all(rq, scsi_req(rq)->result);
+	blk_end_request_all(rq, BLK_STS_OK);
 
 	put_device(job->dev);	/* release reference for the request */
 
@@ -202,7 +202,7 @@ static void bsg_request_fn(struct request_queue *q)
 		ret = bsg_create_job(dev, req);
 		if (ret) {
 			scsi_req(req)->result = ret;
-			blk_end_request_all(req, ret);
+			blk_end_request_all(req, BLK_STS_OK);
 			spin_lock_irq(q->queue_lock);
 			continue;
 		}
diff --git a/block/bsg.c b/block/bsg.c
index 40db8ff4c618..59d02dd31b0c 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -294,14 +294,14 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm)
  * async completion call-back from the block layer, when scsi/ide/whatever
  * calls end_that_request_last() on a request
  */
-static void bsg_rq_end_io(struct request *rq, int uptodate)
+static void bsg_rq_end_io(struct request *rq, blk_status_t status)
 {
 	struct bsg_command *bc = rq->end_io_data;
 	struct bsg_device *bd = bc->bd;
 	unsigned long flags;
 
-	dprintk("%s: finished rq %p bc %p, bio %p stat %d\n",
-		bd->name, rq, bc, bc->bio, uptodate);
+	dprintk("%s: finished rq %p bc %p, bio %p\n",
+		bd->name, rq, bc, bc->bio);
 
 	bc->hdr.duration = jiffies_to_msecs(jiffies - bc->hdr.duration);
 
diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
index 26a51be77227..245a879b036e 100644
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -3464,7 +3464,7 @@ static inline bool DAC960_ProcessCompletedRequest(DAC960_Command_T *Command,
 						 bool SuccessfulIO)
 {
 	struct request *Request = Command->Request;
-	int Error = SuccessfulIO ? 0 : -EIO;
+	blk_status_t Error = SuccessfulIO ? BLK_STS_OK : BLK_STS_IOERR;
 
 	pci_unmap_sg(Command->Controller->PCIDevice, Command->cmd_sglist,
 		Command->SegmentCount, Command->DmaDirection);
diff --git a/drivers/block/amiflop.c b/drivers/block/amiflop.c
index a328f673adfe..49908c74bfcb 100644
--- a/drivers/block/amiflop.c
+++ b/drivers/block/amiflop.c
@@ -1378,7 +1378,7 @@ static void redo_fd_request(void)
 	struct amiga_floppy_struct *floppy;
 	char *data;
 	unsigned long flags;
-	int err;
+	blk_status_t err;
 
 next_req:
 	rq = set_next_request();
@@ -1392,7 +1392,7 @@ static void redo_fd_request(void)
 
 next_segment:
 	/* Here someone could investigate to be more efficient */
-	for (cnt = 0, err = 0; cnt < blk_rq_cur_sectors(rq); cnt++) {
+	for (cnt = 0, err = BLK_STS_OK; cnt < blk_rq_cur_sectors(rq); cnt++) {
 #ifdef DEBUG
 		printk("fd: sector %ld + %d requested for %s\n",
 		       blk_rq_pos(rq), cnt,
@@ -1400,7 +1400,7 @@ static void redo_fd_request(void)
 #endif
 		block = blk_rq_pos(rq) + cnt;
 		if ((int)block > floppy->blocks) {
-			err = -EIO;
+			err = BLK_STS_IOERR;
 			break;
 		}
 
@@ -1413,7 +1413,7 @@ static void redo_fd_request(void)
 #endif
 
 		if (get_track(drive, track) == -1) {
-			err = -EIO;
+			err = BLK_STS_IOERR;
 			break;
 		}
 
@@ -1424,7 +1424,7 @@ static void redo_fd_request(void)
 
 			/* keep the drive spinning while writes are scheduled */
 			if (!fd_motor_on(drive)) {
-				err = -EIO;
+				err = BLK_STS_IOERR;
 				break;
 			}
 			/*
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 3c606c09fd5a..5bf0c9d21fc1 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -1071,7 +1071,7 @@ aoe_end_request(struct aoedev *d, struct request *rq, int fastfail)
 	do {
 		bio = rq->bio;
 		bok = !fastfail && !bio->bi_error;
-	} while (__blk_end_request(rq, bok ? 0 : -EIO, bio->bi_iter.bi_size));
+	} while (__blk_end_request(rq, bok ? BLK_STS_OK : BLK_STS_IOERR, bio->bi_iter.bi_size));
 
 	/* cf. http://lkml.org/lkml/2006/10/31/28 */
 	if (!fastfail)
diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
index fa69ecd52cb5..92da886180aa 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -378,7 +378,7 @@ static DEFINE_TIMER(readtrack_timer, fd_readtrack_check, 0, 0);
 static DEFINE_TIMER(timeout_timer, fd_times_out, 0, 0);
 static DEFINE_TIMER(fd_timer, check_change, 0, 0);
 	
-static void fd_end_request_cur(int err)
+static void fd_end_request_cur(blk_status_t err)
 {
 	if (!__blk_end_request_cur(fd_request, err))
 		fd_request = NULL;
@@ -620,7 +620,7 @@ static void fd_error( void )
 	fd_request->error_count++;
 	if (fd_request->error_count >= MAX_ERRORS) {
 		printk(KERN_ERR "fd%d: too many errors.\n", SelectedDrive );
-		fd_end_request_cur(-EIO);
+		fd_end_request_cur(BLK_STS_IOERR);
 	}
 	else if (fd_request->error_count == RECALIBRATE_ERRORS) {
 		printk(KERN_WARNING "fd%d: recalibrating\n", SelectedDrive );
@@ -739,7 +739,7 @@ static void do_fd_action( int drive )
 		    }
 		    else {
 			/* all sectors finished */
-			fd_end_request_cur(0);
+			fd_end_request_cur(BLK_STS_OK);
 			redo_fd_request();
 			return;
 		    }
@@ -1144,7 +1144,7 @@ static void fd_rwsec_done1(int status)
 	}
 	else {
 		/* all sectors finished */
-		fd_end_request_cur(0);
+		fd_end_request_cur(BLK_STS_OK);
 		redo_fd_request();
 	}
 	return;
@@ -1445,7 +1445,7 @@ static void redo_fd_request(void)
 	if (!UD.connected) {
 		/* drive not connected */
 		printk(KERN_ERR "Unknown Device: fd%d\n", drive );
-		fd_end_request_cur(-EIO);
+		fd_end_request_cur(BLK_STS_IOERR);
 		goto repeat;
 	}
 		
@@ -1461,12 +1461,12 @@ static void redo_fd_request(void)
 		/* user supplied disk type */
 		if (--type >= NUM_DISK_MINORS) {
 			printk(KERN_WARNING "fd%d: invalid disk format", drive );
-			fd_end_request_cur(-EIO);
+			fd_end_request_cur(BLK_STS_IOERR);
 			goto repeat;
 		}
 		if (minor2disktype[type].drive_types > DriveType)  {
 			printk(KERN_WARNING "fd%d: unsupported disk format", drive );
-			fd_end_request_cur(-EIO);
+			fd_end_request_cur(BLK_STS_IOERR);
 			goto repeat;
 		}
 		type = minor2disktype[type].index;
@@ -1476,7 +1476,7 @@ static void redo_fd_request(void)
 	}
 	
 	if (blk_rq_pos(fd_request) + 1 > UDT->blocks) {
-		fd_end_request_cur(-EIO);
+		fd_end_request_cur(BLK_STS_IOERR);
 		goto repeat;
 	}
 
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 3761066fe89d..02a611993bb4 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1864,7 +1864,8 @@ static void cciss_softirq_done(struct request *rq)
 	/* set the residual count for pc requests */
 	if (blk_rq_is_passthrough(rq))
 		scsi_req(rq)->resid_len = c->err_info->ResidualCnt;
-	blk_end_request_all(rq, scsi_req(rq)->result ? -EIO : 0);
+	blk_end_request_all(rq, scsi_req(rq)->result ?
+			BLK_STS_IOERR : BLK_STS_OK);
 
 	spin_lock_irqsave(&h->lock, flags);
 	cmd_free(h, c);
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 60d4c7653178..cc75a5176057 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -2202,7 +2202,7 @@ static int do_format(int drive, struct format_descr *tmp_format_req)
  * =============================
  */
 
-static void floppy_end_request(struct request *req, int error)
+static void floppy_end_request(struct request *req, blk_status_t error)
 {
 	unsigned int nr_sectors = current_count_sectors;
 	unsigned int drive = (unsigned long)req->rq_disk->private_data;
@@ -2263,7 +2263,7 @@ static void request_done(int uptodate)
 			DRWE->last_error_generation = DRS->generation;
 		}
 		spin_lock_irqsave(q->queue_lock, flags);
-		floppy_end_request(req, -EIO);
+		floppy_end_request(req, BLK_STS_IOERR);
 		spin_unlock_irqrestore(q->queue_lock, flags);
 	}
 }
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 28d932906f24..183597053ce5 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -457,7 +457,7 @@ static void lo_complete_rq(struct request *rq)
 		zero_fill_bio(bio);
 	}
 
-	blk_mq_end_request(rq, cmd->ret < 0 ? -EIO : 0);
+	blk_mq_end_request(rq, cmd->ret < 0 ? BLK_STS_IOERR : BLK_STS_OK);
 }
 
 static void lo_rw_aio_complete(struct kiocb *iocb, long ret, long ret2)
diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 3a779a4f5653..ee6f66bb50c7 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -532,7 +532,7 @@ static int mtip_read_log_page(struct mtip_port *port, u8 page, u16 *buffer,
 static int mtip_get_smart_attr(struct mtip_port *port, unsigned int id,
 						struct smart_attr *attrib);
 
-static void mtip_complete_command(struct mtip_cmd *cmd, int status)
+static void mtip_complete_command(struct mtip_cmd *cmd, blk_status_t status)
 {
 	struct request *req = blk_mq_rq_from_pdu(cmd);
 
@@ -568,7 +568,7 @@ static void mtip_handle_tfe(struct driver_data *dd)
 	if (test_bit(MTIP_PF_IC_ACTIVE_BIT, &port->flags)) {
 		cmd = mtip_cmd_from_tag(dd, MTIP_TAG_INTERNAL);
 		dbg_printk(MTIP_DRV_NAME " TFE for the internal command\n");
-		mtip_complete_command(cmd, -EIO);
+		mtip_complete_command(cmd, BLK_STS_IOERR);
 		return;
 	}
 
@@ -667,7 +667,7 @@ static void mtip_handle_tfe(struct driver_data *dd)
 					tag,
 					fail_reason != NULL ?
 						fail_reason : "unknown");
-					mtip_complete_command(cmd, -ENODATA);
+					mtip_complete_command(cmd, BLK_STS_MEDIUM);
 					continue;
 				}
 			}
@@ -690,7 +690,7 @@ static void mtip_handle_tfe(struct driver_data *dd)
 			dev_warn(&port->dd->pdev->dev,
 				"retiring tag %d\n", tag);
 
-			mtip_complete_command(cmd, -EIO);
+			mtip_complete_command(cmd, BLK_STS_IOERR);
 		}
 	}
 	print_tags(dd, "reissued (TFE)", tagaccum, cmd_cnt);
@@ -2753,7 +2753,7 @@ static void mtip_abort_cmd(struct request *req, void *data,
 	dbg_printk(MTIP_DRV_NAME " Aborting request, tag = %d\n", req->tag);
 
 	clear_bit(req->tag, dd->port->cmds_to_issue);
-	cmd->status = -EIO;
+	cmd->status = BLK_STS_IOERR;
 	mtip_softirq_done_fn(req);
 }
 
@@ -3597,7 +3597,7 @@ static int mtip_submit_request(struct blk_mq_hw_ctx *hctx, struct request *rq)
 		int err;
 
 		err = mtip_send_trim(dd, blk_rq_pos(rq), blk_rq_sectors(rq));
-		blk_mq_end_request(rq, err);
+		blk_mq_end_request(rq, err ? BLK_STS_IOERR : BLK_STS_OK);
 		return 0;
 	}
 
@@ -3730,7 +3730,7 @@ static enum blk_eh_timer_return mtip_cmd_timeout(struct request *req,
 	if (reserved) {
 		struct mtip_cmd *cmd = blk_mq_rq_to_pdu(req);
 
-		cmd->status = -ETIME;
+		cmd->status = BLK_STS_TIMEOUT;
 		return BLK_EH_HANDLED;
 	}
 
@@ -3961,7 +3961,7 @@ static void mtip_no_dev_cleanup(struct request *rq, void *data, bool reserv)
 {
 	struct mtip_cmd *cmd = blk_mq_rq_to_pdu(rq);
 
-	cmd->status = -ENODEV;
+	cmd->status = BLK_STS_IOERR;
 	blk_mq_complete_request(rq);
 }
 
diff --git a/drivers/block/mtip32xx/mtip32xx.h b/drivers/block/mtip32xx/mtip32xx.h
index 37b8e3e0bb78..e8286af50e16 100644
--- a/drivers/block/mtip32xx/mtip32xx.h
+++ b/drivers/block/mtip32xx/mtip32xx.h
@@ -342,7 +342,7 @@ struct mtip_cmd {
 	int retries; /* The number of retries left for this command. */
 
 	int direction; /* Data transfer direction */
-	int status;
+	blk_status_t status;
 };
 
 /* Structure used to describe a port. */
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index c5e52f66d3d4..b2e5c15fcb4d 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -116,7 +116,7 @@ struct nbd_cmd {
 	int index;
 	int cookie;
 	struct completion send_complete;
-	int status;
+	blk_status_t status;
 };
 
 #if IS_ENABLED(CONFIG_DEBUG_FS)
@@ -286,7 +286,7 @@ static enum blk_eh_timer_return nbd_xmit_timeout(struct request *req,
 	struct nbd_config *config;
 
 	if (!refcount_inc_not_zero(&nbd->config_refs)) {
-		cmd->status = -EIO;
+		cmd->status = BLK_STS_TIMEOUT;
 		return BLK_EH_HANDLED;
 	}
 
@@ -331,7 +331,7 @@ static enum blk_eh_timer_return nbd_xmit_timeout(struct request *req,
 				    "Connection timed out\n");
 	}
 	set_bit(NBD_TIMEDOUT, &config->runtime_flags);
-	cmd->status = -EIO;
+	cmd->status = BLK_STS_IOERR;
 	sock_shutdown(nbd);
 	nbd_config_put(nbd);
 
@@ -578,7 +578,7 @@ static struct nbd_cmd *nbd_read_stat(struct nbd_device *nbd, int index)
 	if (ntohl(reply.error)) {
 		dev_err(disk_to_dev(nbd->disk), "Other side returned error (%d)\n",
 			ntohl(reply.error));
-		cmd->status = -EIO;
+		cmd->status = BLK_STS_IOERR;
 		return cmd;
 	}
 
@@ -603,7 +603,7 @@ static struct nbd_cmd *nbd_read_stat(struct nbd_device *nbd, int index)
 				 */
 				if (nbd_disconnected(config) ||
 				    config->num_connections <= 1) {
-					cmd->status = -EIO;
+					cmd->status = BLK_STS_IOERR;
 					return cmd;
 				}
 				return ERR_PTR(-EIO);
@@ -655,7 +655,7 @@ static void nbd_clear_req(struct request *req, void *data, bool reserved)
 	if (!blk_mq_request_started(req))
 		return;
 	cmd = blk_mq_rq_to_pdu(req);
-	cmd->status = -EIO;
+	cmd->status = BLK_STS_IOERR;
 	blk_mq_complete_request(req);
 }
 
@@ -744,7 +744,7 @@ static int nbd_handle_cmd(struct nbd_cmd *cmd, int index)
 		nbd_config_put(nbd);
 		return -EINVAL;
 	}
-	cmd->status = 0;
+	cmd->status = BLK_STS_OK;
 again:
 	nsock = config->socks[index];
 	mutex_lock(&nsock->tx_lock);
diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
index d946e1eeac8e..e6b81d370882 100644
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -229,11 +229,11 @@ static void end_cmd(struct nullb_cmd *cmd)
 
 	switch (queue_mode)  {
 	case NULL_Q_MQ:
-		blk_mq_end_request(cmd->rq, 0);
+		blk_mq_end_request(cmd->rq, BLK_STS_OK);
 		return;
 	case NULL_Q_RQ:
 		INIT_LIST_HEAD(&cmd->rq->queuelist);
-		blk_end_request_all(cmd->rq, 0);
+		blk_end_request_all(cmd->rq, BLK_STS_OK);
 		break;
 	case NULL_Q_BIO:
 		bio_endio(cmd->bio);
@@ -422,11 +422,12 @@ static void cleanup_queues(struct nullb *nullb)
 
 #ifdef CONFIG_NVM
 
-static void null_lnvm_end_io(struct request *rq, int error)
+static void null_lnvm_end_io(struct request *rq, blk_status_t status)
 {
 	struct nvm_rq *rqd = rq->end_io_data;
 
-	rqd->error = error;
+	/* XXX: lighnvm core seems to expect NVM_RSP_* values here.. */
+	rqd->error = status ? -EIO : 0;
 	nvm_end_io(rqd);
 
 	blk_put_request(rq);
diff --git a/drivers/block/paride/pcd.c b/drivers/block/paride/pcd.c
index b1267ef34d5a..cffe42d80ce9 100644
--- a/drivers/block/paride/pcd.c
+++ b/drivers/block/paride/pcd.c
@@ -783,7 +783,7 @@ static void pcd_request(void)
 			ps_set_intr(do_pcd_read, NULL, 0, nice);
 			return;
 		} else {
-			__blk_end_request_all(pcd_req, -EIO);
+			__blk_end_request_all(pcd_req, BLK_STS_IOERR);
 			pcd_req = NULL;
 		}
 	}
@@ -794,7 +794,7 @@ static void do_pcd_request(struct request_queue *q)
 	pcd_request();
 }
 
-static inline void next_request(int err)
+static inline void next_request(blk_status_t err)
 {
 	unsigned long saved_flags;
 
@@ -837,7 +837,7 @@ static void pcd_start(void)
 
 	if (pcd_command(pcd_current, rd_cmd, 2048, "read block")) {
 		pcd_bufblk = -1;
-		next_request(-EIO);
+		next_request(BLK_STS_IOERR);
 		return;
 	}
 
@@ -871,7 +871,7 @@ static void do_pcd_read_drq(void)
 			return;
 		}
 		pcd_bufblk = -1;
-		next_request(-EIO);
+		next_request(BLK_STS_IOERR);
 		return;
 	}
 
diff --git a/drivers/block/paride/pd.c b/drivers/block/paride/pd.c
index 7d2402f90978..c98983be4f9c 100644
--- a/drivers/block/paride/pd.c
+++ b/drivers/block/paride/pd.c
@@ -438,7 +438,7 @@ static void run_fsm(void)
 				phase = NULL;
 				spin_lock_irqsave(&pd_lock, saved_flags);
 				if (!__blk_end_request_cur(pd_req,
-						res == Ok ? 0 : -EIO)) {
+						res == Ok ? 0 : BLK_STS_IOERR)) {
 					if (!set_next_request())
 						stop = 1;
 				}
diff --git a/drivers/block/paride/pf.c b/drivers/block/paride/pf.c
index f24ca7315ddc..5f46da8d05cd 100644
--- a/drivers/block/paride/pf.c
+++ b/drivers/block/paride/pf.c
@@ -801,7 +801,7 @@ static int set_next_request(void)
 	return pf_req != NULL;
 }
 
-static void pf_end_request(int err)
+static void pf_end_request(blk_status_t err)
 {
 	if (pf_req && !__blk_end_request_cur(pf_req, err))
 		pf_req = NULL;
@@ -821,7 +821,7 @@ static void pf_request(void)
 	pf_count = blk_rq_cur_sectors(pf_req);
 
 	if (pf_block + pf_count > get_capacity(pf_req->rq_disk)) {
-		pf_end_request(-EIO);
+		pf_end_request(BLK_STS_IOERR);
 		goto repeat;
 	}
 
@@ -836,7 +836,7 @@ static void pf_request(void)
 		pi_do_claimed(pf_current->pi, do_pf_write);
 	else {
 		pf_busy = 0;
-		pf_end_request(-EIO);
+		pf_end_request(BLK_STS_IOERR);
 		goto repeat;
 	}
 }
@@ -868,7 +868,7 @@ static int pf_next_buf(void)
 	return 0;
 }
 
-static inline void next_request(int err)
+static inline void next_request(blk_status_t err)
 {
 	unsigned long saved_flags;
 
@@ -896,7 +896,7 @@ static void do_pf_read_start(void)
 			pi_do_claimed(pf_current->pi, do_pf_read_start);
 			return;
 		}
-		next_request(-EIO);
+		next_request(BLK_STS_IOERR);
 		return;
 	}
 	pf_mask = STAT_DRQ;
@@ -915,7 +915,7 @@ static void do_pf_read_drq(void)
 				pi_do_claimed(pf_current->pi, do_pf_read_start);
 				return;
 			}
-			next_request(-EIO);
+			next_request(BLK_STS_IOERR);
 			return;
 		}
 		pi_read_block(pf_current->pi, pf_buf, 512);
@@ -942,7 +942,7 @@ static void do_pf_write_start(void)
 			pi_do_claimed(pf_current->pi, do_pf_write_start);
 			return;
 		}
-		next_request(-EIO);
+		next_request(BLK_STS_IOERR);
 		return;
 	}
 
@@ -955,7 +955,7 @@ static void do_pf_write_start(void)
 				pi_do_claimed(pf_current->pi, do_pf_write_start);
 				return;
 			}
-			next_request(-EIO);
+			next_request(BLK_STS_IOERR);
 			return;
 		}
 		pi_write_block(pf_current->pi, pf_buf, 512);
@@ -975,7 +975,7 @@ static void do_pf_write_done(void)
 			pi_do_claimed(pf_current->pi, do_pf_write_start);
 			return;
 		}
-		next_request(-EIO);
+		next_request(BLK_STS_IOERR);
 		return;
 	}
 	pi_disconnect(pf_current->pi);
diff --git a/drivers/block/ps3disk.c b/drivers/block/ps3disk.c
index a809e3e9feb8..075662f2cf46 100644
--- a/drivers/block/ps3disk.c
+++ b/drivers/block/ps3disk.c
@@ -158,7 +158,7 @@ static int ps3disk_submit_request_sg(struct ps3_storage_device *dev,
 	if (res) {
 		dev_err(&dev->sbd.core, "%s:%u: %s failed %d\n", __func__,
 			__LINE__, op, res);
-		__blk_end_request_all(req, -EIO);
+		__blk_end_request_all(req, BLK_STS_IOERR);
 		return 0;
 	}
 
@@ -180,7 +180,7 @@ static int ps3disk_submit_flush_request(struct ps3_storage_device *dev,
 	if (res) {
 		dev_err(&dev->sbd.core, "%s:%u: sync cache failed 0x%llx\n",
 			__func__, __LINE__, res);
-		__blk_end_request_all(req, -EIO);
+		__blk_end_request_all(req, BLK_STS_IOERR);
 		return 0;
 	}
 
@@ -208,7 +208,7 @@ static void ps3disk_do_request(struct ps3_storage_device *dev,
 			break;
 		default:
 			blk_dump_rq_flags(req, DEVICE_NAME " bad request");
-			__blk_end_request_all(req, -EIO);
+			__blk_end_request_all(req, BLK_STS_IOERR);
 		}
 	}
 }
@@ -231,7 +231,8 @@ static irqreturn_t ps3disk_interrupt(int irq, void *data)
 	struct ps3_storage_device *dev = data;
 	struct ps3disk_private *priv;
 	struct request *req;
-	int res, read, error;
+	int res, read;
+	blk_status_t error;
 	u64 tag, status;
 	const char *op;
 
@@ -269,7 +270,7 @@ static irqreturn_t ps3disk_interrupt(int irq, void *data)
 	if (status) {
 		dev_dbg(&dev->sbd.core, "%s:%u: %s failed 0x%llx\n", __func__,
 			__LINE__, op, status);
-		error = -EIO;
+		error = BLK_STS_IOERR;
 	} else {
 		dev_dbg(&dev->sbd.core, "%s:%u: %s completed\n", __func__,
 			__LINE__, op);
diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 454bf9c34882..3e8b43d792c2 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -2293,11 +2293,13 @@ static bool rbd_img_obj_end_request(struct rbd_obj_request *obj_request)
 		rbd_assert(img_request->obj_request != NULL);
 		more = obj_request->which < img_request->obj_request_count - 1;
 	} else {
+		blk_status_t status = errno_to_blk_status(result);
+
 		rbd_assert(img_request->rq != NULL);
 
-		more = blk_update_request(img_request->rq, result, xferred);
+		more = blk_update_request(img_request->rq, status, xferred);
 		if (!more)
-			__blk_mq_end_request(img_request->rq, result);
+			__blk_mq_end_request(img_request->rq, status);
 	}
 
 	return more;
@@ -4149,7 +4151,7 @@ static void rbd_queue_workfn(struct work_struct *work)
 			 obj_op_name(op_type), length, offset, result);
 	ceph_put_snap_context(snapc);
 err:
-	blk_mq_end_request(rq, result);
+	blk_mq_end_request(rq, errno_to_blk_status(result));
 }
 
 static int rbd_queue_rq(struct blk_mq_hw_ctx *hctx,
diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 27833e4dae2a..e6c526861703 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -451,8 +451,8 @@ static void skd_send_special_fitmsg(struct skd_device *skdev,
 				    struct skd_special_context *skspcl);
 static void skd_request_fn(struct request_queue *rq);
 static void skd_end_request(struct skd_device *skdev,
-			    struct skd_request_context *skreq, int error);
-static int skd_preop_sg_list(struct skd_device *skdev,
+		struct skd_request_context *skreq, blk_status_t status);
+static bool skd_preop_sg_list(struct skd_device *skdev,
 			     struct skd_request_context *skreq);
 static void skd_postop_sg_list(struct skd_device *skdev,
 			       struct skd_request_context *skreq);
@@ -491,7 +491,7 @@ static void skd_fail_all_pending(struct skd_device *skdev)
 		if (req == NULL)
 			break;
 		blk_start_request(req);
-		__blk_end_request_all(req, -EIO);
+		__blk_end_request_all(req, BLK_STS_IOERR);
 	}
 }
 
@@ -545,7 +545,6 @@ static void skd_request_fn(struct request_queue *q)
 	struct request *req = NULL;
 	struct skd_scsi_request *scsi_req;
 	unsigned long io_flags;
-	int error;
 	u32 lba;
 	u32 count;
 	int data_dir;
@@ -716,9 +715,7 @@ static void skd_request_fn(struct request_queue *q)
 		if (!req->bio)
 			goto skip_sg;
 
-		error = skd_preop_sg_list(skdev, skreq);
-
-		if (error != 0) {
+		if (!skd_preop_sg_list(skdev, skreq)) {
 			/*
 			 * Complete the native request with error.
 			 * Note that the request context is still at the
@@ -730,7 +727,7 @@ static void skd_request_fn(struct request_queue *q)
 			 */
 			pr_debug("%s:%s:%d error Out\n",
 				 skdev->name, __func__, __LINE__);
-			skd_end_request(skdev, skreq, error);
+			skd_end_request(skdev, skreq, BLK_STS_RESOURCE);
 			continue;
 		}
 
@@ -805,7 +802,7 @@ static void skd_request_fn(struct request_queue *q)
 }
 
 static void skd_end_request(struct skd_device *skdev,
-			    struct skd_request_context *skreq, int error)
+		struct skd_request_context *skreq, blk_status_t error)
 {
 	if (unlikely(error)) {
 		struct request *req = skreq->req;
@@ -822,7 +819,7 @@ static void skd_end_request(struct skd_device *skdev,
 	__blk_end_request_all(skreq->req, error);
 }
 
-static int skd_preop_sg_list(struct skd_device *skdev,
+static bool skd_preop_sg_list(struct skd_device *skdev,
 			     struct skd_request_context *skreq)
 {
 	struct request *req = skreq->req;
@@ -839,7 +836,7 @@ static int skd_preop_sg_list(struct skd_device *skdev,
 
 	n_sg = blk_rq_map_sg(skdev->queue, req, sg);
 	if (n_sg <= 0)
-		return -EINVAL;
+		return false;
 
 	/*
 	 * Map scatterlist to PCI bus addresses.
@@ -847,7 +844,7 @@ static int skd_preop_sg_list(struct skd_device *skdev,
 	 */
 	n_sg = pci_map_sg(skdev->pdev, sg, n_sg, pci_dir);
 	if (n_sg <= 0)
-		return -EINVAL;
+		return false;
 
 	SKD_ASSERT(n_sg <= skdev->sgs_per_request);
 
@@ -882,7 +879,7 @@ static int skd_preop_sg_list(struct skd_device *skdev,
 		}
 	}
 
-	return 0;
+	return true;
 }
 
 static void skd_postop_sg_list(struct skd_device *skdev,
@@ -2333,7 +2330,7 @@ static void skd_resolve_req_exception(struct skd_device *skdev,
 	switch (skd_check_status(skdev, cmp_status, &skreq->err_info)) {
 	case SKD_CHECK_STATUS_REPORT_GOOD:
 	case SKD_CHECK_STATUS_REPORT_SMART_ALERT:
-		skd_end_request(skdev, skreq, 0);
+		skd_end_request(skdev, skreq, BLK_STS_OK);
 		break;
 
 	case SKD_CHECK_STATUS_BUSY_IMMINENT:
@@ -2355,7 +2352,7 @@ static void skd_resolve_req_exception(struct skd_device *skdev,
 
 	case SKD_CHECK_STATUS_REPORT_ERROR:
 	default:
-		skd_end_request(skdev, skreq, -EIO);
+		skd_end_request(skdev, skreq, BLK_STS_IOERR);
 		break;
 	}
 }
@@ -2748,7 +2745,7 @@ static int skd_isr_completion_posted(struct skd_device *skdev,
 			 * native request.
 			 */
 			if (likely(cmp_status == SAM_STAT_GOOD))
-				skd_end_request(skdev, skreq, 0);
+				skd_end_request(skdev, skreq, BLK_STS_OK);
 			else
 				skd_resolve_req_exception(skdev, skreq);
 		}
@@ -3190,7 +3187,7 @@ static void skd_recover_requests(struct skd_device *skdev, int requeue)
 			    SKD_MAX_RETRIES)
 				blk_requeue_request(skdev->queue, skreq->req);
 			else
-				skd_end_request(skdev, skreq, -EIO);
+				skd_end_request(skdev, skreq, BLK_STS_IOERR);
 
 			skreq->req = NULL;
 
diff --git a/drivers/block/sunvdc.c b/drivers/block/sunvdc.c
index 3f3a3ab3d50a..6b16ead1da58 100644
--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -316,7 +316,7 @@ static void vdc_end_one(struct vdc_port *port, struct vio_dring_state *dr,
 
 	rqe->req = NULL;
 
-	__blk_end_request(req, (desc->status ? -EIO : 0), desc->size);
+	__blk_end_request(req, (desc->status ? BLK_STS_IOERR : 0), desc->size);
 
 	vdc_blk_queue_start(port);
 }
@@ -1023,7 +1023,7 @@ static void vdc_queue_drain(struct vdc_port *port)
 	struct request *req;
 
 	while ((req = blk_fetch_request(port->disk->queue)) != NULL)
-		__blk_end_request_all(req, -EIO);
+		__blk_end_request_all(req, BLK_STS_IOERR);
 }
 
 static void vdc_ldc_reset_timer(unsigned long _arg)
diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index 3064be6cf375..1633aaf24060 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -493,7 +493,7 @@ static inline int swim_read_sector(struct floppy_state *fs,
 	return ret;
 }
 
-static int floppy_read_sectors(struct floppy_state *fs,
+static blk_status_t floppy_read_sectors(struct floppy_state *fs,
 			       int req_sector, int sectors_nb,
 			       unsigned char *buffer)
 {
@@ -516,7 +516,7 @@ static int floppy_read_sectors(struct floppy_state *fs,
 			ret = swim_read_sector(fs, side, track, sector,
 						buffer);
 			if (try-- == 0)
-				return -EIO;
+				return BLK_STS_IOERR;
 		} while (ret != 512);
 
 		buffer += ret;
@@ -553,7 +553,7 @@ static void do_fd_request(struct request_queue *q)
 
 	req = swim_next_request(swd);
 	while (req) {
-		int err = -EIO;
+		blk_status_t err = BLK_STS_IOERR;
 
 		fs = req->rq_disk->private_data;
 		if (blk_rq_pos(req) >= fs->total_secs)
diff --git a/drivers/block/swim3.c b/drivers/block/swim3.c
index ba4809c9bdba..c7953860ce91 100644
--- a/drivers/block/swim3.c
+++ b/drivers/block/swim3.c
@@ -257,7 +257,7 @@ static unsigned int floppy_check_events(struct gendisk *disk,
 					unsigned int clearing);
 static int floppy_revalidate(struct gendisk *disk);
 
-static bool swim3_end_request(struct floppy_state *fs, int err, unsigned int nr_bytes)
+static bool swim3_end_request(struct floppy_state *fs, blk_status_t err, unsigned int nr_bytes)
 {
 	struct request *req = fs->cur_req;
 	int rc;
@@ -334,7 +334,7 @@ static void start_request(struct floppy_state *fs)
 		if (fs->mdev->media_bay &&
 		    check_media_bay(fs->mdev->media_bay) != MB_FD) {
 			swim3_dbg("%s", "  media bay absent, dropping req\n");
-			swim3_end_request(fs, -ENODEV, 0);
+			swim3_end_request(fs, BLK_STS_IOERR, 0);
 			continue;
 		}
 
@@ -350,12 +350,12 @@ static void start_request(struct floppy_state *fs)
 		if (blk_rq_pos(req) >= fs->total_secs) {
 			swim3_dbg("  pos out of bounds (%ld, max is %ld)\n",
 				  (long)blk_rq_pos(req), (long)fs->total_secs);
-			swim3_end_request(fs, -EIO, 0);
+			swim3_end_request(fs, BLK_STS_IOERR, 0);
 			continue;
 		}
 		if (fs->ejected) {
 			swim3_dbg("%s", "  disk ejected\n");
-			swim3_end_request(fs, -EIO, 0);
+			swim3_end_request(fs, BLK_STS_IOERR, 0);
 			continue;
 		}
 
@@ -364,7 +364,7 @@ static void start_request(struct floppy_state *fs)
 				fs->write_prot = swim3_readbit(fs, WRITE_PROT);
 			if (fs->write_prot) {
 				swim3_dbg("%s", "  try to write, disk write protected\n");
-				swim3_end_request(fs, -EIO, 0);
+				swim3_end_request(fs, BLK_STS_IOERR, 0);
 				continue;
 			}
 		}
@@ -548,7 +548,7 @@ static void act(struct floppy_state *fs)
 				if (fs->retries > 5) {
 					swim3_err("Wrong cylinder in transfer, want: %d got %d\n",
 						  fs->req_cyl, fs->cur_cyl);
-					swim3_end_request(fs, -EIO, 0);
+					swim3_end_request(fs, BLK_STS_IOERR, 0);
 					fs->state = idle;
 					return;
 				}
@@ -584,7 +584,7 @@ static void scan_timeout(unsigned long data)
 	out_8(&sw->intr_enable, 0);
 	fs->cur_cyl = -1;
 	if (fs->retries > 5) {
-		swim3_end_request(fs, -EIO, 0);
+		swim3_end_request(fs, BLK_STS_IOERR, 0);
 		fs->state = idle;
 		start_request(fs);
 	} else {
@@ -608,7 +608,7 @@ static void seek_timeout(unsigned long data)
 	out_8(&sw->select, RELAX);
 	out_8(&sw->intr_enable, 0);
 	swim3_err("%s", "Seek timeout\n");
-	swim3_end_request(fs, -EIO, 0);
+	swim3_end_request(fs, BLK_STS_IOERR, 0);
 	fs->state = idle;
 	start_request(fs);
 	spin_unlock_irqrestore(&swim3_lock, flags);
@@ -637,7 +637,7 @@ static void settle_timeout(unsigned long data)
 		goto unlock;
 	}
 	swim3_err("%s", "Seek settle timeout\n");
-	swim3_end_request(fs, -EIO, 0);
+	swim3_end_request(fs, BLK_STS_IOERR, 0);
 	fs->state = idle;
 	start_request(fs);
  unlock:
@@ -666,7 +666,7 @@ static void xfer_timeout(unsigned long data)
 	swim3_err("Timeout %sing sector %ld\n",
 	       (rq_data_dir(fs->cur_req)==WRITE? "writ": "read"),
 	       (long)blk_rq_pos(fs->cur_req));
-	swim3_end_request(fs, -EIO, 0);
+	swim3_end_request(fs, BLK_STS_IOERR, 0);
 	fs->state = idle;
 	start_request(fs);
 	spin_unlock_irqrestore(&swim3_lock, flags);
@@ -703,7 +703,7 @@ static irqreturn_t swim3_interrupt(int irq, void *dev_id)
 				swim3_err("%s", "Seen sector but cyl=ff?\n");
 				fs->cur_cyl = -1;
 				if (fs->retries > 5) {
-					swim3_end_request(fs, -EIO, 0);
+					swim3_end_request(fs, BLK_STS_IOERR, 0);
 					fs->state = idle;
 					start_request(fs);
 				} else {
@@ -786,7 +786,7 @@ static irqreturn_t swim3_interrupt(int irq, void *dev_id)
 				swim3_err("Error %sing block %ld (err=%x)\n",
 				       rq_data_dir(req) == WRITE? "writ": "read",
 				       (long)blk_rq_pos(req), err);
-				swim3_end_request(fs, -EIO, 0);
+				swim3_end_request(fs, BLK_STS_IOERR, 0);
 				fs->state = idle;
 			}
 		} else {
@@ -795,7 +795,7 @@ static irqreturn_t swim3_interrupt(int irq, void *dev_id)
 				swim3_err("fd dma error: stat=%x resid=%d\n", stat, resid);
 				swim3_err("  state=%d, dir=%x, intr=%x, err=%x\n",
 					  fs->state, rq_data_dir(req), intr, err);
-				swim3_end_request(fs, -EIO, 0);
+				swim3_end_request(fs, BLK_STS_IOERR, 0);
 				fs->state = idle;
 				start_request(fs);
 				break;
diff --git a/drivers/block/sx8.c b/drivers/block/sx8.c
index c8e072caf56f..08586dc14e85 100644
--- a/drivers/block/sx8.c
+++ b/drivers/block/sx8.c
@@ -745,7 +745,7 @@ static unsigned int carm_fill_get_fw_ver(struct carm_host *host,
 
 static inline void carm_end_request_queued(struct carm_host *host,
 					   struct carm_request *crq,
-					   int error)
+					   blk_status_t error)
 {
 	struct request *req = crq->rq;
 	int rc;
@@ -791,7 +791,7 @@ static inline void carm_round_robin(struct carm_host *host)
 }
 
 static inline void carm_end_rq(struct carm_host *host, struct carm_request *crq,
-			       int error)
+			       blk_status_t error)
 {
 	carm_end_request_queued(host, crq, error);
 	if (max_queue == 1)
@@ -869,14 +869,14 @@ static void carm_rq_fn(struct request_queue *q)
 	sg = &crq->sg[0];
 	n_elem = blk_rq_map_sg(q, rq, sg);
 	if (n_elem <= 0) {
-		carm_end_rq(host, crq, -EIO);
+		carm_end_rq(host, crq, BLK_STS_IOERR);
 		return;		/* request with no s/g entries? */
 	}
 
 	/* map scatterlist to PCI bus addresses */
 	n_elem = pci_map_sg(host->pdev, sg, n_elem, pci_dir);
 	if (n_elem <= 0) {
-		carm_end_rq(host, crq, -EIO);
+		carm_end_rq(host, crq, BLK_STS_IOERR);
 		return;		/* request with no s/g entries? */
 	}
 	crq->n_elem = n_elem;
@@ -937,7 +937,7 @@ static void carm_rq_fn(struct request_queue *q)
 
 static void carm_handle_array_info(struct carm_host *host,
 				   struct carm_request *crq, u8 *mem,
-				   int error)
+				   blk_status_t error)
 {
 	struct carm_port *port;
 	u8 *msg_data = mem + sizeof(struct carm_array_info);
@@ -997,7 +997,7 @@ static void carm_handle_array_info(struct carm_host *host,
 
 static void carm_handle_scan_chan(struct carm_host *host,
 				  struct carm_request *crq, u8 *mem,
-				  int error)
+				  blk_status_t error)
 {
 	u8 *msg_data = mem + IOC_SCAN_CHAN_OFFSET;
 	unsigned int i, dev_count = 0;
@@ -1029,7 +1029,7 @@ static void carm_handle_scan_chan(struct carm_host *host,
 }
 
 static void carm_handle_generic(struct carm_host *host,
-				struct carm_request *crq, int error,
+				struct carm_request *crq, blk_status_t error,
 				int cur_state, int next_state)
 {
 	DPRINTK("ENTER\n");
@@ -1045,7 +1045,7 @@ static void carm_handle_generic(struct carm_host *host,
 }
 
 static inline void carm_handle_rw(struct carm_host *host,
-				  struct carm_request *crq, int error)
+				  struct carm_request *crq, blk_status_t error)
 {
 	int pci_dir;
 
@@ -1067,7 +1067,7 @@ static inline void carm_handle_resp(struct carm_host *host,
 	u32 handle = le32_to_cpu(ret_handle_le);
 	unsigned int msg_idx;
 	struct carm_request *crq;
-	int error = (status == RMSG_OK) ? 0 : -EIO;
+	blk_status_t error = (status == RMSG_OK) ? 0 : BLK_STS_IOERR;
 	u8 *mem;
 
 	VPRINTK("ENTER, handle == 0x%x\n", handle);
@@ -1155,7 +1155,7 @@ static inline void carm_handle_resp(struct carm_host *host,
 err_out:
 	printk(KERN_WARNING DRV_NAME "(%s): BUG: unhandled message type %d/%d\n",
 	       pci_name(host->pdev), crq->msg_type, crq->msg_subtype);
-	carm_end_rq(host, crq, -EIO);
+	carm_end_rq(host, crq, BLK_STS_IOERR);
 }
 
 static inline void carm_handle_responses(struct carm_host *host)
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 553cc4c542b4..205b74d70efc 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -64,15 +64,15 @@ struct virtblk_req {
 	struct scatterlist sg[];
 };
 
-static inline int virtblk_result(struct virtblk_req *vbr)
+static inline blk_status_t virtblk_result(struct virtblk_req *vbr)
 {
 	switch (vbr->status) {
 	case VIRTIO_BLK_S_OK:
-		return 0;
+		return BLK_STS_OK;
 	case VIRTIO_BLK_S_UNSUPP:
-		return -ENOTTY;
+		return BLK_STS_NOTSUPP;
 	default:
-		return -EIO;
+		return BLK_STS_IOERR;
 	}
 }
 
@@ -307,7 +307,7 @@ static int virtblk_get_id(struct gendisk *disk, char *id_str)
 		goto out;
 
 	blk_execute_rq(vblk->disk->queue, vblk->disk, req, false);
-	err = virtblk_result(blk_mq_rq_to_pdu(req));
+	err = blk_status_to_errno(virtblk_result(blk_mq_rq_to_pdu(req)));
 out:
 	blk_put_request(req);
 	return err;
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 39459631667c..aedc3c759273 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1601,14 +1601,18 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 			continue;
 		}
 
-		blkif_req(req)->error = (bret->status == BLKIF_RSP_OKAY) ? 0 : -EIO;
+		if (bret->status == BLKIF_RSP_OKAY)
+			blkif_req(req)->error = BLK_STS_OK;
+		else
+			blkif_req(req)->error = BLK_STS_IOERR;
+
 		switch (bret->operation) {
 		case BLKIF_OP_DISCARD:
 			if (unlikely(bret->status == BLKIF_RSP_EOPNOTSUPP)) {
 				struct request_queue *rq = info->rq;
 				printk(KERN_WARNING "blkfront: %s: %s op failed\n",
 					   info->gd->disk_name, op_name(bret->operation));
-				blkif_req(req)->error = -EOPNOTSUPP;
+				blkif_req(req)->error = BLK_STS_NOTSUPP;
 				info->feature_discard = 0;
 				info->feature_secdiscard = 0;
 				queue_flag_clear(QUEUE_FLAG_DISCARD, rq);
@@ -1626,11 +1630,11 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 				     rinfo->shadow[id].req.u.rw.nr_segments == 0)) {
 				printk(KERN_WARNING "blkfront: %s: empty %s op failed\n",
 				       info->gd->disk_name, op_name(bret->operation));
-				blkif_req(req)->error = -EOPNOTSUPP;
+				blkif_req(req)->error = BLK_STS_NOTSUPP;
 			}
 			if (unlikely(blkif_req(req)->error)) {
-				if (blkif_req(req)->error == -EOPNOTSUPP)
-					blkif_req(req)->error = 0;
+				if (blkif_req(req)->error == BLK_STS_NOTSUPP)
+					blkif_req(req)->error = BLK_STS_OK;
 				info->feature_fua = 0;
 				info->feature_flush = 0;
 				xlvbd_flush(info);
@@ -2137,7 +2141,7 @@ static int blkfront_resume(struct xenbus_device *dev)
 			merge_bio.tail = shadow[j].request->biotail;
 			bio_list_merge(&info->bio_list, &merge_bio);
 			shadow[j].request->bio = NULL;
-			blk_mq_end_request(shadow[j].request, 0);
+			blk_mq_end_request(shadow[j].request, BLK_STS_OK);
 		}
 	}
 
diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index 757dce2147e0..977fdf066017 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -471,7 +471,7 @@ static struct request *ace_get_next_request(struct request_queue *q)
 		if (!blk_rq_is_passthrough(req))
 			break;
 		blk_start_request(req);
-		__blk_end_request_all(req, -EIO);
+		__blk_end_request_all(req, BLK_STS_IOERR);
 	}
 	return req;
 }
@@ -499,11 +499,11 @@ static void ace_fsm_dostate(struct ace_device *ace)
 
 		/* Drop all in-flight and pending requests */
 		if (ace->req) {
-			__blk_end_request_all(ace->req, -EIO);
+			__blk_end_request_all(ace->req, BLK_STS_IOERR);
 			ace->req = NULL;
 		}
 		while ((req = blk_fetch_request(ace->queue)) != NULL)
-			__blk_end_request_all(req, -EIO);
+			__blk_end_request_all(req, BLK_STS_IOERR);
 
 		/* Drop back to IDLE state and notify waiters */
 		ace->fsm_state = ACE_FSM_STATE_IDLE;
@@ -728,7 +728,7 @@ static void ace_fsm_dostate(struct ace_device *ace)
 		}
 
 		/* bio finished; is there another one? */
-		if (__blk_end_request_cur(ace->req, 0)) {
+		if (__blk_end_request_cur(ace->req, BLK_STS_OK)) {
 			/* dev_dbg(ace->dev, "next block; h=%u c=%u\n",
 			 *      blk_rq_sectors(ace->req),
 			 *      blk_rq_cur_sectors(ace->req));
diff --git a/drivers/block/z2ram.c b/drivers/block/z2ram.c
index 968f9e52effa..41c95c9b2ab4 100644
--- a/drivers/block/z2ram.c
+++ b/drivers/block/z2ram.c
@@ -74,14 +74,14 @@ static void do_z2_request(struct request_queue *q)
 	while (req) {
 		unsigned long start = blk_rq_pos(req) << 9;
 		unsigned long len  = blk_rq_cur_bytes(req);
-		int err = 0;
+		blk_status_t err = BLK_STS_OK;
 
 		if (start + len > z2ram_size) {
 			pr_err(DEVICE_NAME ": bad access: block=%llu, "
 			       "count=%u\n",
 			       (unsigned long long)blk_rq_pos(req),
 			       blk_rq_cur_sectors(req));
-			err = -EIO;
+			err = BLK_STS_IOERR;
 			goto done;
 		}
 		while (len) {
diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index 1372763a948f..53f8278e66f7 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -583,7 +583,8 @@ static int gdrom_set_interrupt_handlers(void)
  */
 static void gdrom_readdisk_dma(struct work_struct *work)
 {
-	int err, block, block_cnt;
+	int block, block_cnt;
+	blk_status_t err;
 	struct packet_command *read_command;
 	struct list_head *elem, *next;
 	struct request *req;
@@ -641,7 +642,7 @@ static void gdrom_readdisk_dma(struct work_struct *work)
 		__raw_writeb(1, GDROM_DMA_STATUS_REG);
 		wait_event_interruptible_timeout(request_queue,
 			gd.transfer == 0, GDROM_DEFAULT_TIMEOUT);
-		err = gd.transfer ? -EIO : 0;
+		err = gd.transfer ? BLK_STS_IOERR : BLK_STS_OK;
 		gd.transfer = 0;
 		gd.pending = 0;
 		/* now seek to take the request spinlock
@@ -670,11 +671,11 @@ static void gdrom_request(struct request_queue *rq)
 			break;
 		case REQ_OP_WRITE:
 			pr_notice("Read only device - write request ignored\n");
-			__blk_end_request_all(req, -EIO);
+			__blk_end_request_all(req, BLK_STS_IOERR);
 			break;
 		default:
 			printk(KERN_DEBUG "gdrom: Non-fs request ignored\n");
-			__blk_end_request_all(req, -EIO);
+			__blk_end_request_all(req, BLK_STS_IOERR);
 			break;
 		}
 	}
diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 5901937284e7..d7a49dcfa85e 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -273,7 +273,7 @@ void ide_retry_pc(ide_drive_t *drive)
 	ide_requeue_and_plug(drive, failed_rq);
 	if (ide_queue_sense_rq(drive, pc)) {
 		blk_start_request(failed_rq);
-		ide_complete_rq(drive, -EIO, blk_rq_bytes(failed_rq));
+		ide_complete_rq(drive, BLK_STS_IOERR, blk_rq_bytes(failed_rq));
 	}
 }
 EXPORT_SYMBOL_GPL(ide_retry_pc);
@@ -437,7 +437,8 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 
 	/* No more interrupts */
 	if ((stat & ATA_DRQ) == 0) {
-		int uptodate, error;
+		int uptodate;
+		blk_status_t error;
 
 		debug_log("Packet command completed, %d bytes transferred\n",
 			  blk_rq_bytes(rq));
@@ -490,7 +491,7 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 
 		if (ata_misc_request(rq)) {
 			scsi_req(rq)->result = 0;
-			error = 0;
+			error = BLK_STS_OK;
 		} else {
 
 			if (blk_rq_is_passthrough(rq) && uptodate <= 0) {
@@ -498,7 +499,7 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 					scsi_req(rq)->result = -EIO;
 			}
 
-			error = uptodate ? 0 : -EIO;
+			error = uptodate ? BLK_STS_OK : BLK_STS_IOERR;
 		}
 
 		ide_complete_rq(drive, error, blk_rq_bytes(rq));
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 07e5ff3a64c3..d55e44ed82b5 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -228,7 +228,7 @@ static void ide_cd_complete_failed_rq(ide_drive_t *drive, struct request *rq)
 		scsi_req(failed)->sense_len = scsi_req(rq)->sense_len;
 		cdrom_analyze_sense_data(drive, failed);
 
-		if (ide_end_rq(drive, failed, -EIO, blk_rq_bytes(failed)))
+		if (ide_end_rq(drive, failed, BLK_STS_IOERR, blk_rq_bytes(failed)))
 			BUG();
 	} else
 		cdrom_analyze_sense_data(drive, NULL);
@@ -508,7 +508,7 @@ static bool ide_cd_error_cmd(ide_drive_t *drive, struct ide_cmd *cmd)
 		nr_bytes -= cmd->last_xfer_len;
 
 	if (nr_bytes > 0) {
-		ide_complete_rq(drive, 0, nr_bytes);
+		ide_complete_rq(drive, BLK_STS_OK, nr_bytes);
 		return true;
 	}
 
@@ -674,7 +674,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 out_end:
 	if (blk_rq_is_scsi(rq) && rc == 0) {
 		scsi_req(rq)->resid_len = 0;
-		blk_end_request_all(rq, 0);
+		blk_end_request_all(rq, BLK_STS_OK);
 		hwif->rq = NULL;
 	} else {
 		if (sense && uptodate)
@@ -699,7 +699,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 				scsi_req(rq)->resid_len += cmd->last_xfer_len;
 		}
 
-		ide_complete_rq(drive, uptodate ? 0 : -EIO, blk_rq_bytes(rq));
+		ide_complete_rq(drive, uptodate ? BLK_STS_OK : BLK_STS_IOERR, blk_rq_bytes(rq));
 
 		if (sense && rc == 2)
 			ide_error(drive, "request sense failure", stat);
@@ -844,7 +844,7 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 	if (nsectors == 0)
 		nsectors = 1;
 
-	ide_complete_rq(drive, uptodate ? 0 : -EIO, nsectors << 9);
+	ide_complete_rq(drive, uptodate ? BLK_STS_OK : BLK_STS_IOERR, nsectors << 9);
 
 	return ide_stopped;
 }
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index 51c81223e56d..54d4d78ca46a 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -104,7 +104,7 @@ ide_startstop_t ide_dma_intr(ide_drive_t *drive)
 			if ((cmd->tf_flags & IDE_TFLAG_FS) == 0)
 				ide_finish_cmd(drive, cmd, stat);
 			else
-				ide_complete_rq(drive, 0,
+				ide_complete_rq(drive, BLK_STS_OK,
 						blk_rq_sectors(cmd->rq) << 9);
 			return ide_stopped;
 		}
diff --git a/drivers/ide/ide-eh.c b/drivers/ide/ide-eh.c
index 4b7ffd7d158d..47d5f3379748 100644
--- a/drivers/ide/ide-eh.c
+++ b/drivers/ide/ide-eh.c
@@ -135,7 +135,7 @@ ide_startstop_t ide_error(ide_drive_t *drive, const char *msg, u8 stat)
 			return ide_stopped;
 		}
 		scsi_req(rq)->result = err;
-		ide_complete_rq(drive, err ? -EIO : 0, blk_rq_bytes(rq));
+		ide_complete_rq(drive, err ? BLK_STS_IOERR : BLK_STS_OK, blk_rq_bytes(rq));
 		return ide_stopped;
 	}
 
@@ -143,7 +143,7 @@ ide_startstop_t ide_error(ide_drive_t *drive, const char *msg, u8 stat)
 }
 EXPORT_SYMBOL_GPL(ide_error);
 
-static inline void ide_complete_drive_reset(ide_drive_t *drive, int err)
+static inline void ide_complete_drive_reset(ide_drive_t *drive, blk_status_t err)
 {
 	struct request *rq = drive->hwif->rq;
 
@@ -151,7 +151,7 @@ static inline void ide_complete_drive_reset(ide_drive_t *drive, int err)
 	    scsi_req(rq)->cmd[0] == REQ_DRIVE_RESET) {
 		if (err <= 0 && scsi_req(rq)->result == 0)
 			scsi_req(rq)->result = -EIO;
-		ide_complete_rq(drive, err ? err : 0, blk_rq_bytes(rq));
+		ide_complete_rq(drive, err, blk_rq_bytes(rq));
 	}
 }
 
@@ -191,7 +191,7 @@ static ide_startstop_t atapi_reset_pollfunc(ide_drive_t *drive)
 	}
 	/* done polling */
 	hwif->polling = 0;
-	ide_complete_drive_reset(drive, 0);
+	ide_complete_drive_reset(drive, BLK_STS_OK);
 	return ide_stopped;
 }
 
@@ -225,7 +225,7 @@ static ide_startstop_t reset_pollfunc(ide_drive_t *drive)
 	ide_hwif_t *hwif = drive->hwif;
 	const struct ide_port_ops *port_ops = hwif->port_ops;
 	u8 tmp;
-	int err = 0;
+	blk_status_t err = BLK_STS_OK;
 
 	if (port_ops && port_ops->reset_poll) {
 		err = port_ops->reset_poll(drive);
@@ -247,7 +247,7 @@ static ide_startstop_t reset_pollfunc(ide_drive_t *drive)
 		printk(KERN_ERR "%s: reset timed-out, status=0x%02x\n",
 			hwif->name, tmp);
 		drive->failures++;
-		err = -EIO;
+		err = BLK_STS_IOERR;
 	} else  {
 		tmp = ide_read_error(drive);
 
@@ -257,7 +257,7 @@ static ide_startstop_t reset_pollfunc(ide_drive_t *drive)
 		} else {
 			ide_reset_report_error(hwif, tmp);
 			drive->failures++;
-			err = -EIO;
+			err = BLK_STS_IOERR;
 		}
 	}
 out:
@@ -392,7 +392,7 @@ static ide_startstop_t do_reset1(ide_drive_t *drive, int do_not_try_atapi)
 
 	if (io_ports->ctl_addr == 0) {
 		spin_unlock_irqrestore(&hwif->lock, flags);
-		ide_complete_drive_reset(drive, -ENXIO);
+		ide_complete_drive_reset(drive, BLK_STS_IOERR);
 		return ide_stopped;
 	}
 
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 8ac6048cd2df..627b1f62a749 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -143,7 +143,7 @@ static ide_startstop_t ide_floppy_issue_pc(ide_drive_t *drive,
 
 		drive->failed_pc = NULL;
 		drive->pc_callback(drive, 0);
-		ide_complete_rq(drive, -EIO, done);
+		ide_complete_rq(drive, BLK_STS_IOERR, done);
 		return ide_stopped;
 	}
 
@@ -248,7 +248,7 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
 
 		if (ata_misc_request(rq)) {
 			scsi_req(rq)->result = 0;
-			ide_complete_rq(drive, 0, blk_rq_bytes(rq));
+			ide_complete_rq(drive, BLK_STS_OK, blk_rq_bytes(rq));
 			return ide_stopped;
 		} else
 			goto out_end;
@@ -303,7 +303,7 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
 	drive->failed_pc = NULL;
 	if (blk_rq_is_passthrough(rq) && scsi_req(rq)->result == 0)
 		scsi_req(rq)->result = -EIO;
-	ide_complete_rq(drive, -EIO, blk_rq_bytes(rq));
+	ide_complete_rq(drive, BLK_STS_IOERR, blk_rq_bytes(rq));
 	return ide_stopped;
 }
 
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 323af721f8cb..3a234701d92c 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -54,7 +54,7 @@
 #include <linux/uaccess.h>
 #include <asm/io.h>
 
-int ide_end_rq(ide_drive_t *drive, struct request *rq, int error,
+int ide_end_rq(ide_drive_t *drive, struct request *rq, blk_status_t error,
 	       unsigned int nr_bytes)
 {
 	/*
@@ -112,7 +112,7 @@ void ide_complete_cmd(ide_drive_t *drive, struct ide_cmd *cmd, u8 stat, u8 err)
 	}
 }
 
-int ide_complete_rq(ide_drive_t *drive, int error, unsigned int nr_bytes)
+int ide_complete_rq(ide_drive_t *drive, blk_status_t error, unsigned int nr_bytes)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq = hwif->rq;
@@ -122,7 +122,7 @@ int ide_complete_rq(ide_drive_t *drive, int error, unsigned int nr_bytes)
 	 * if failfast is set on a request, override number of sectors
 	 * and complete the whole request right now
 	 */
-	if (blk_noretry_request(rq) && error <= 0)
+	if (blk_noretry_request(rq) && error)
 		nr_bytes = blk_rq_sectors(rq) << 9;
 
 	rc = ide_end_rq(drive, rq, error, nr_bytes);
@@ -149,7 +149,7 @@ void ide_kill_rq(ide_drive_t *drive, struct request *rq)
 			scsi_req(rq)->result = -EIO;
 	}
 
-	ide_complete_rq(drive, -EIO, blk_rq_bytes(rq));
+	ide_complete_rq(drive, BLK_STS_IOERR, blk_rq_bytes(rq));
 }
 
 static void ide_tf_set_specify_cmd(ide_drive_t *drive, struct ide_taskfile *tf)
@@ -272,7 +272,7 @@ static ide_startstop_t execute_drive_cmd (ide_drive_t *drive,
  	printk("%s: DRIVE_CMD (null)\n", drive->name);
 #endif
 	scsi_req(rq)->result = 0;
-	ide_complete_rq(drive, 0, blk_rq_bytes(rq));
+	ide_complete_rq(drive, BLK_STS_OK, blk_rq_bytes(rq));
 
  	return ide_stopped;
 }
diff --git a/drivers/ide/ide-pm.c b/drivers/ide/ide-pm.c
index 0977fc1f40ce..08b54bb3b705 100644
--- a/drivers/ide/ide-pm.c
+++ b/drivers/ide/ide-pm.c
@@ -40,7 +40,7 @@ int generic_ide_suspend(struct device *dev, pm_message_t mesg)
 	return ret;
 }
 
-static void ide_end_sync_rq(struct request *rq, int error)
+static void ide_end_sync_rq(struct request *rq, blk_status_t error)
 {
 	complete(rq->end_io_data);
 }
@@ -57,7 +57,7 @@ static int ide_pm_execute_rq(struct request *rq)
 	if (unlikely(blk_queue_dying(q))) {
 		rq->rq_flags |= RQF_QUIET;
 		scsi_req(rq)->result = -ENXIO;
-		__blk_end_request_all(rq, 0);
+		__blk_end_request_all(rq, BLK_STS_OK);
 		spin_unlock_irq(q->queue_lock);
 		return -ENXIO;
 	}
@@ -235,7 +235,7 @@ void ide_complete_pm_rq(ide_drive_t *drive, struct request *rq)
 
 	drive->hwif->rq = NULL;
 
-	if (blk_end_request(rq, 0, 0))
+	if (blk_end_request(rq, BLK_STS_OK, 0))
 		BUG();
 }
 
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index a0651f948b76..4d062c568777 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -474,7 +474,7 @@ static ide_startstop_t ide_tape_issue_pc(ide_drive_t *drive,
 
 		drive->failed_pc = NULL;
 		drive->pc_callback(drive, 0);
-		ide_complete_rq(drive, -EIO, blk_rq_bytes(rq));
+		ide_complete_rq(drive, BLK_STS_IOERR, blk_rq_bytes(rq));
 		return ide_stopped;
 	}
 	ide_debug_log(IDE_DBG_SENSE, "retry #%d, cmd: 0x%02x", pc->retries,
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index d71199d23c9e..ab1a32cdcb0a 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -318,7 +318,7 @@ static void ide_error_cmd(ide_drive_t *drive, struct ide_cmd *cmd)
 		}
 
 		if (nr_bytes > 0)
-			ide_complete_rq(drive, 0, nr_bytes);
+			ide_complete_rq(drive, BLK_STS_OK, nr_bytes);
 	}
 }
 
@@ -336,7 +336,7 @@ void ide_finish_cmd(ide_drive_t *drive, struct ide_cmd *cmd, u8 stat)
 		ide_driveid_update(drive);
 	}
 
-	ide_complete_rq(drive, err ? -EIO : 0, blk_rq_bytes(rq));
+	ide_complete_rq(drive, err ? BLK_STS_IOERR : BLK_STS_OK, blk_rq_bytes(rq));
 }
 
 /*
@@ -394,7 +394,7 @@ static ide_startstop_t task_pio_intr(ide_drive_t *drive)
 	if ((cmd->tf_flags & IDE_TFLAG_FS) == 0)
 		ide_finish_cmd(drive, cmd, stat);
 	else
-		ide_complete_rq(drive, 0, blk_rq_sectors(cmd->rq) << 9);
+		ide_complete_rq(drive, BLK_STS_OK, blk_rq_sectors(cmd->rq) << 9);
 	return ide_stopped;
 out_err:
 	ide_error_cmd(drive, cmd);
diff --git a/drivers/ide/siimage.c b/drivers/ide/siimage.c
index 6a1849bb476c..57eea5a9047f 100644
--- a/drivers/ide/siimage.c
+++ b/drivers/ide/siimage.c
@@ -406,7 +406,7 @@ static int siimage_dma_test_irq(ide_drive_t *drive)
  *	yet.
  */
 
-static int sil_sata_reset_poll(ide_drive_t *drive)
+static blk_status_t sil_sata_reset_poll(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	void __iomem *sata_status_addr
@@ -419,11 +419,11 @@ static int sil_sata_reset_poll(ide_drive_t *drive)
 		if ((sata_stat & 0x03) != 0x03) {
 			printk(KERN_WARNING "%s: reset phy dead, status=0x%08x\n",
 					    hwif->name, sata_stat);
-			return -ENXIO;
+			return BLK_STS_IOERR;
 		}
 	}
 
-	return 0;
+	return BLK_STS_OK;
 }
 
 /**
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index ceeeb495d01c..39262e344ae1 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1449,22 +1449,15 @@ static void activate_path_work(struct work_struct *work)
 	activate_or_offline_path(pgpath);
 }
 
-static int noretry_error(int error)
+static int noretry_error(blk_status_t error)
 {
 	switch (error) {
-	case -EBADE:
-		/*
-		 * EBADE signals an reservation conflict.
-		 * We shouldn't fail the path here as we can communicate with
-		 * the target.  We should failover to the next path, but in
-		 * doing so we might be causing a ping-pong between paths.
-		 * So just return the reservation conflict error.
-		 */
-	case -EOPNOTSUPP:
-	case -EREMOTEIO:
-	case -EILSEQ:
-	case -ENODATA:
-	case -ENOSPC:
+	case BLK_STS_NOTSUPP:
+	case BLK_STS_NOSPC:
+	case BLK_STS_TARGET:
+	case BLK_STS_NEXUS:
+	case BLK_STS_MEDIUM:
+	case BLK_STS_RESOURCE:
 		return 1;
 	}
 
@@ -1473,7 +1466,7 @@ static int noretry_error(int error)
 }
 
 static int multipath_end_io(struct dm_target *ti, struct request *clone,
-			    int error, union map_info *map_context)
+			    blk_status_t error, union map_info *map_context)
 {
 	struct dm_mpath_io *mpio = get_mpio(map_context);
 	struct pgpath *pgpath = mpio->pgpath;
@@ -1500,7 +1493,7 @@ static int multipath_end_io(struct dm_target *ti, struct request *clone,
 
 		if (atomic_read(&m->nr_valid_paths) == 0 &&
 		    !test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags)) {
-			if (error == -EIO)
+			if (error == BLK_STS_IOERR)
 				dm_report_EIO(m);
 			/* complete with the original error */
 			r = DM_ENDIO_DONE;
@@ -1525,7 +1518,7 @@ static int multipath_end_io_bio(struct dm_target *ti, struct bio *clone, int *er
 	unsigned long flags;
 	int r = DM_ENDIO_DONE;
 
-	if (!*error || noretry_error(*error))
+	if (!*error || noretry_error(errno_to_blk_status(*error)))
 		goto done;
 
 	if (pgpath)
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index b639fa7246ee..bee334389173 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -119,7 +119,7 @@ static void end_clone_bio(struct bio *clone)
 	struct dm_rq_target_io *tio = info->tio;
 	struct bio *bio = info->orig;
 	unsigned int nr_bytes = info->orig->bi_iter.bi_size;
-	int error = clone->bi_error;
+	blk_status_t error = errno_to_blk_status(clone->bi_error);
 
 	bio_put(clone);
 
@@ -158,7 +158,7 @@ static void end_clone_bio(struct bio *clone)
 	 * Do not use blk_end_request() here, because it may complete
 	 * the original request before the clone, and break the ordering.
 	 */
-	blk_update_request(tio->orig, 0, nr_bytes);
+	blk_update_request(tio->orig, BLK_STS_OK, nr_bytes);
 }
 
 static struct dm_rq_target_io *tio_from_request(struct request *rq)
@@ -216,7 +216,7 @@ static void rq_completed(struct mapped_device *md, int rw, bool run_queue)
  * Must be called without clone's queue lock held,
  * see end_clone_request() for more details.
  */
-static void dm_end_request(struct request *clone, int error)
+static void dm_end_request(struct request *clone, blk_status_t error)
 {
 	int rw = rq_data_dir(clone);
 	struct dm_rq_target_io *tio = clone->end_io_data;
@@ -285,7 +285,7 @@ static void dm_requeue_original_request(struct dm_rq_target_io *tio, bool delay_
 	rq_completed(md, rw, false);
 }
 
-static void dm_done(struct request *clone, int error, bool mapped)
+static void dm_done(struct request *clone, blk_status_t error, bool mapped)
 {
 	int r = DM_ENDIO_DONE;
 	struct dm_rq_target_io *tio = clone->end_io_data;
@@ -298,7 +298,7 @@ static void dm_done(struct request *clone, int error, bool mapped)
 			r = rq_end_io(tio->ti, clone, error, &tio->info);
 	}
 
-	if (unlikely(error == -EREMOTEIO)) {
+	if (unlikely(error == BLK_STS_TARGET)) {
 		if (req_op(clone) == REQ_OP_WRITE_SAME &&
 		    !clone->q->limits.max_write_same_sectors)
 			disable_write_same(tio->md);
@@ -358,7 +358,7 @@ static void dm_softirq_done(struct request *rq)
  * Complete the clone and the original request with the error status
  * through softirq context.
  */
-static void dm_complete_request(struct request *rq, int error)
+static void dm_complete_request(struct request *rq, blk_status_t error)
 {
 	struct dm_rq_target_io *tio = tio_from_request(rq);
 
@@ -375,7 +375,7 @@ static void dm_complete_request(struct request *rq, int error)
  * Target's rq_end_io() function isn't called.
  * This may be used when the target's map_rq() or clone_and_map_rq() functions fail.
  */
-static void dm_kill_unmapped_request(struct request *rq, int error)
+static void dm_kill_unmapped_request(struct request *rq, blk_status_t error)
 {
 	rq->rq_flags |= RQF_FAILED;
 	dm_complete_request(rq, error);
@@ -384,7 +384,7 @@ static void dm_kill_unmapped_request(struct request *rq, int error)
 /*
  * Called with the clone's queue lock held (in the case of .request_fn)
  */
-static void end_clone_request(struct request *clone, int error)
+static void end_clone_request(struct request *clone, blk_status_t error)
 {
 	struct dm_rq_target_io *tio = clone->end_io_data;
 
@@ -401,7 +401,7 @@ static void end_clone_request(struct request *clone, int error)
 
 static void dm_dispatch_clone_request(struct request *clone, struct request *rq)
 {
-	int r;
+	blk_status_t r;
 
 	if (blk_queue_io_stat(clone->q))
 		clone->rq_flags |= RQF_IO_STAT;
@@ -506,7 +506,7 @@ static int map_request(struct dm_rq_target_io *tio)
 		break;
 	case DM_MAPIO_KILL:
 		/* The target wants to complete the I/O */
-		dm_kill_unmapped_request(rq, -EIO);
+		dm_kill_unmapped_request(rq, BLK_STS_IOERR);
 		break;
 	default:
 		DMWARN("unimplemented target map return value: %d", r);
diff --git a/drivers/md/dm-rq.h b/drivers/md/dm-rq.h
index f0020d21b95f..9813922e4fe5 100644
--- a/drivers/md/dm-rq.h
+++ b/drivers/md/dm-rq.h
@@ -24,7 +24,7 @@ struct dm_rq_target_io {
 	struct dm_target *ti;
 	struct request *orig, *clone;
 	struct kthread_work work;
-	int error;
+	blk_status_t error;
 	union map_info info;
 	struct dm_stats_aux stats_aux;
 	unsigned long duration_jiffies;
diff --git a/drivers/memstick/core/ms_block.c b/drivers/memstick/core/ms_block.c
index 99e651c27fb7..22de7f5ed032 100644
--- a/drivers/memstick/core/ms_block.c
+++ b/drivers/memstick/core/ms_block.c
@@ -1921,12 +1921,13 @@ static void msb_io_work(struct work_struct *work)
 		spin_lock_irqsave(&msb->q_lock, flags);
 
 		if (len)
-			if (!__blk_end_request(msb->req, 0, len))
+			if (!__blk_end_request(msb->req, BLK_STS_OK, len))
 				msb->req = NULL;
 
 		if (error && msb->req) {
+			blk_status_t ret = errno_to_blk_status(error);
 			dbg_verbose("IO: ending one sector of the request with error");
-			if (!__blk_end_request(msb->req, error, msb->page_size))
+			if (!__blk_end_request(msb->req, ret, msb->page_size))
 				msb->req = NULL;
 		}
 
@@ -2014,7 +2015,7 @@ static void msb_submit_req(struct request_queue *q)
 		WARN_ON(!msb->io_queue_stopped);
 
 		while ((req = blk_fetch_request(q)) != NULL)
-			__blk_end_request_all(req, -ENODEV);
+			__blk_end_request_all(req, BLK_STS_IOERR);
 		return;
 	}
 
diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index c00d8a266878..8897962781bb 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -709,7 +709,8 @@ static int mspro_block_issue_req(struct memstick_dev *card, int chunk)
 					       msb->req_sg);
 
 		if (!msb->seg_count) {
-			chunk = __blk_end_request_cur(msb->block_req, -ENOMEM);
+			chunk = __blk_end_request_cur(msb->block_req,
+					BLK_STS_RESOURCE);
 			continue;
 		}
 
@@ -776,7 +777,8 @@ static int mspro_block_complete_req(struct memstick_dev *card, int error)
 		if (error && !t_len)
 			t_len = blk_rq_cur_bytes(msb->block_req);
 
-		chunk = __blk_end_request(msb->block_req, error, t_len);
+		chunk = __blk_end_request(msb->block_req,
+				errno_to_blk_status(error), t_len);
 
 		error = mspro_block_issue_req(card, chunk);
 
@@ -838,7 +840,7 @@ static void mspro_block_submit_req(struct request_queue *q)
 
 	if (msb->eject) {
 		while ((req = blk_fetch_request(q)) != NULL)
-			__blk_end_request_all(req, -ENODEV);
+			__blk_end_request_all(req, BLK_STS_IOERR);
 
 		return;
 	}
diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index 8273b078686d..6ff94a948a4b 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -1184,9 +1184,10 @@ static void mmc_blk_issue_discard_rq(struct mmc_queue *mq, struct request *req)
 	struct mmc_card *card = md->queue.card;
 	unsigned int from, nr, arg;
 	int err = 0, type = MMC_BLK_DISCARD;
+	blk_status_t status = BLK_STS_OK;
 
 	if (!mmc_can_erase(card)) {
-		err = -EOPNOTSUPP;
+		status = BLK_STS_NOTSUPP;
 		goto fail;
 	}
 
@@ -1212,10 +1213,12 @@ static void mmc_blk_issue_discard_rq(struct mmc_queue *mq, struct request *req)
 		if (!err)
 			err = mmc_erase(card, from, nr, arg);
 	} while (err == -EIO && !mmc_blk_reset(md, card->host, type));
-	if (!err)
+	if (err)
+		status = BLK_STS_IOERR;
+	else
 		mmc_blk_reset_success(md, type);
 fail:
-	blk_end_request(req, err, blk_rq_bytes(req));
+	blk_end_request(req, status, blk_rq_bytes(req));
 }
 
 static void mmc_blk_issue_secdiscard_rq(struct mmc_queue *mq,
@@ -1225,9 +1228,10 @@ static void mmc_blk_issue_secdiscard_rq(struct mmc_queue *mq,
 	struct mmc_card *card = md->queue.card;
 	unsigned int from, nr, arg;
 	int err = 0, type = MMC_BLK_SECDISCARD;
+	blk_status_t status = BLK_STS_OK;
 
 	if (!(mmc_can_secure_erase_trim(card))) {
-		err = -EOPNOTSUPP;
+		status = BLK_STS_NOTSUPP;
 		goto out;
 	}
 
@@ -1254,8 +1258,10 @@ static void mmc_blk_issue_secdiscard_rq(struct mmc_queue *mq,
 	err = mmc_erase(card, from, nr, arg);
 	if (err == -EIO)
 		goto out_retry;
-	if (err)
+	if (err) {
+		status = BLK_STS_IOERR;
 		goto out;
+	}
 
 	if (arg == MMC_SECURE_TRIM1_ARG) {
 		if (card->quirks & MMC_QUIRK_INAND_CMD38) {
@@ -1270,8 +1276,10 @@ static void mmc_blk_issue_secdiscard_rq(struct mmc_queue *mq,
 		err = mmc_erase(card, from, nr, MMC_SECURE_TRIM2_ARG);
 		if (err == -EIO)
 			goto out_retry;
-		if (err)
+		if (err) {
+			status = BLK_STS_IOERR;
 			goto out;
+		}
 	}
 
 out_retry:
@@ -1280,7 +1288,7 @@ static void mmc_blk_issue_secdiscard_rq(struct mmc_queue *mq,
 	if (!err)
 		mmc_blk_reset_success(md, type);
 out:
-	blk_end_request(req, err, blk_rq_bytes(req));
+	blk_end_request(req, status, blk_rq_bytes(req));
 }
 
 static void mmc_blk_issue_flush(struct mmc_queue *mq, struct request *req)
@@ -1290,10 +1298,7 @@ static void mmc_blk_issue_flush(struct mmc_queue *mq, struct request *req)
 	int ret = 0;
 
 	ret = mmc_flush_cache(card);
-	if (ret)
-		ret = -EIO;
-
-	blk_end_request_all(req, ret);
+	blk_end_request_all(req, ret ? BLK_STS_IOERR : BLK_STS_OK);
 }
 
 /*
@@ -1641,7 +1646,7 @@ static void mmc_blk_rw_cmd_abort(struct mmc_queue *mq, struct mmc_card *card,
 {
 	if (mmc_card_removed(card))
 		req->rq_flags |= RQF_QUIET;
-	while (blk_end_request(req, -EIO, blk_rq_cur_bytes(req)));
+	while (blk_end_request(req, BLK_STS_IOERR, blk_rq_cur_bytes(req)));
 	mmc_queue_req_free(mq, mqrq);
 }
 
@@ -1661,7 +1666,7 @@ static void mmc_blk_rw_try_restart(struct mmc_queue *mq, struct request *req,
 	 */
 	if (mmc_card_removed(mq->card)) {
 		req->rq_flags |= RQF_QUIET;
-		blk_end_request_all(req, -EIO);
+		blk_end_request_all(req, BLK_STS_IOERR);
 		mmc_queue_req_free(mq, mqrq);
 		return;
 	}
@@ -1743,7 +1748,7 @@ static void mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *new_req)
 			 */
 			mmc_blk_reset_success(md, type);
 
-			req_pending = blk_end_request(old_req, 0,
+			req_pending = blk_end_request(old_req, BLK_STS_OK,
 						      brq->data.bytes_xfered);
 			/*
 			 * If the blk_end_request function returns non-zero even
@@ -1811,7 +1816,7 @@ static void mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *new_req)
 			 * time, so we only reach here after trying to
 			 * read a single sector.
 			 */
-			req_pending = blk_end_request(old_req, -EIO,
+			req_pending = blk_end_request(old_req, BLK_STS_IOERR,
 						      brq->data.blksz);
 			if (!req_pending) {
 				mmc_queue_req_free(mq, mq_rq);
@@ -1860,7 +1865,7 @@ void mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 	ret = mmc_blk_part_switch(card, md);
 	if (ret) {
 		if (req) {
-			blk_end_request_all(req, -EIO);
+			blk_end_request_all(req, BLK_STS_IOERR);
 		}
 		goto out;
 	}
diff --git a/drivers/mmc/core/queue.c b/drivers/mmc/core/queue.c
index 5c37b6be3e7b..7f20298d892b 100644
--- a/drivers/mmc/core/queue.c
+++ b/drivers/mmc/core/queue.c
@@ -133,7 +133,7 @@ static void mmc_request_fn(struct request_queue *q)
 	if (!mq) {
 		while ((req = blk_fetch_request(q)) != NULL) {
 			req->rq_flags |= RQF_QUIET;
-			__blk_end_request_all(req, -EIO);
+			__blk_end_request_all(req, BLK_STS_IOERR);
 		}
 		return;
 	}
diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 6b8d5cd7dbf6..91c17fba7659 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -73,7 +73,7 @@ static void blktrans_dev_put(struct mtd_blktrans_dev *dev)
 }
 
 
-static int do_blktrans_request(struct mtd_blktrans_ops *tr,
+static blk_status_t do_blktrans_request(struct mtd_blktrans_ops *tr,
 			       struct mtd_blktrans_dev *dev,
 			       struct request *req)
 {
@@ -84,33 +84,37 @@ static int do_blktrans_request(struct mtd_blktrans_ops *tr,
 	nsect = blk_rq_cur_bytes(req) >> tr->blkshift;
 	buf = bio_data(req->bio);
 
-	if (req_op(req) == REQ_OP_FLUSH)
-		return tr->flush(dev);
+	if (req_op(req) == REQ_OP_FLUSH) {
+		if (tr->flush(dev))
+			return BLK_STS_IOERR;
+		return BLK_STS_OK;
+	}
 
 	if (blk_rq_pos(req) + blk_rq_cur_sectors(req) >
 	    get_capacity(req->rq_disk))
-		return -EIO;
+		return BLK_STS_IOERR;
 
 	switch (req_op(req)) {
 	case REQ_OP_DISCARD:
-		return tr->discard(dev, block, nsect);
+		if (tr->discard(dev, block, nsect))
+			return BLK_STS_IOERR;
+		return BLK_STS_OK;
 	case REQ_OP_READ:
 		for (; nsect > 0; nsect--, block++, buf += tr->blksize)
 			if (tr->readsect(dev, block, buf))
-				return -EIO;
+				return BLK_STS_IOERR;
 		rq_flush_dcache_pages(req);
-		return 0;
+		return BLK_STS_OK;
 	case REQ_OP_WRITE:
 		if (!tr->writesect)
-			return -EIO;
+			return BLK_STS_IOERR;
 
 		rq_flush_dcache_pages(req);
 		for (; nsect > 0; nsect--, block++, buf += tr->blksize)
 			if (tr->writesect(dev, block, buf))
-				return -EIO;
-		return 0;
+				return BLK_STS_IOERR;
 	default:
-		return -EIO;
+		return BLK_STS_IOERR;
 	}
 }
 
@@ -132,7 +136,7 @@ static void mtd_blktrans_work(struct work_struct *work)
 	spin_lock_irq(rq->queue_lock);
 
 	while (1) {
-		int res;
+		blk_status_t res;
 
 		dev->bg_stop = false;
 		if (!req && !(req = blk_fetch_request(rq))) {
@@ -178,7 +182,7 @@ static void mtd_blktrans_request(struct request_queue *rq)
 
 	if (!dev)
 		while ((req = blk_fetch_request(rq)) != NULL)
-			__blk_end_request_all(req, -ENODEV);
+			__blk_end_request_all(req, BLK_STS_IOERR);
 	else
 		queue_work(dev->wq, &dev->work);
 }
diff --git a/drivers/mtd/ubi/block.c b/drivers/mtd/ubi/block.c
index 5497e65439df..3ecdb39d1985 100644
--- a/drivers/mtd/ubi/block.c
+++ b/drivers/mtd/ubi/block.c
@@ -313,7 +313,7 @@ static void ubiblock_do_work(struct work_struct *work)
 	ret = ubiblock_read(pdu);
 	rq_flush_dcache_pages(req);
 
-	blk_mq_end_request(req, ret);
+	blk_mq_end_request(req, errno_to_blk_status(ret));
 }
 
 static int ubiblock_queue_rq(struct blk_mq_hw_ctx *hctx,
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index a60926410438..07e95c7d837a 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -70,29 +70,21 @@ static DEFINE_SPINLOCK(dev_list_lock);
 
 static struct class *nvme_class;
 
-static int nvme_error_status(struct request *req)
+static blk_status_t nvme_error_status(struct request *req)
 {
 	switch (nvme_req(req)->status & 0x7ff) {
 	case NVME_SC_SUCCESS:
-		return 0;
+		return BLK_STS_OK;
 	case NVME_SC_CAP_EXCEEDED:
-		return -ENOSPC;
-	default:
-		return -EIO;
-
-	/*
-	 * XXX: these errors are a nasty side-band protocol to
-	 * drivers/md/dm-mpath.c:noretry_error() that aren't documented
-	 * anywhere..
-	 */
-	case NVME_SC_CMD_SEQ_ERROR:
-		return -EILSEQ;
+		return BLK_STS_NOSPC;
 	case NVME_SC_ONCS_NOT_SUPPORTED:
-		return -EOPNOTSUPP;
+		return BLK_STS_NOTSUPP;
 	case NVME_SC_WRITE_FAULT:
 	case NVME_SC_READ_ERROR:
 	case NVME_SC_UNWRITTEN_BLOCK:
-		return -ENODATA;
+		return BLK_STS_MEDIUM;
+	default:
+		return BLK_STS_IOERR;
 	}
 }
 
@@ -555,15 +547,16 @@ int nvme_submit_user_cmd(struct request_queue *q, struct nvme_command *cmd,
 			result, timeout);
 }
 
-static void nvme_keep_alive_end_io(struct request *rq, int error)
+static void nvme_keep_alive_end_io(struct request *rq, blk_status_t status)
 {
 	struct nvme_ctrl *ctrl = rq->end_io_data;
 
 	blk_mq_free_request(rq);
 
-	if (error) {
+	if (status) {
 		dev_err(ctrl->device,
-			"failed nvme_keep_alive_end_io error=%d\n", error);
+			"failed nvme_keep_alive_end_io error=%d\n",
+				status);
 		return;
 	}
 
diff --git a/drivers/nvme/host/lightnvm.c b/drivers/nvme/host/lightnvm.c
index f3885b5e56bd..2d7a2889866f 100644
--- a/drivers/nvme/host/lightnvm.c
+++ b/drivers/nvme/host/lightnvm.c
@@ -480,7 +480,7 @@ static inline void nvme_nvm_rqtocmd(struct nvm_rq *rqd, struct nvme_ns *ns,
 					rqd->bio->bi_iter.bi_sector));
 }
 
-static void nvme_nvm_end_io(struct request *rq, int error)
+static void nvme_nvm_end_io(struct request *rq, blk_status_t status)
 {
 	struct nvm_rq *rqd = rq->end_io_data;
 
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index d52701df7245..819898428763 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -706,7 +706,7 @@ static int nvme_queue_rq(struct blk_mq_hw_ctx *hctx,
 	if (ns && ns->ms && !blk_integrity_rq(req)) {
 		if (!(ns->pi_type && ns->ms == 8) &&
 		    !blk_rq_is_passthrough(req)) {
-			blk_mq_end_request(req, -EFAULT);
+			blk_mq_end_request(req, BLK_STS_NOTSUPP);
 			return BLK_MQ_RQ_QUEUE_OK;
 		}
 	}
@@ -939,7 +939,7 @@ static int adapter_delete_sq(struct nvme_dev *dev, u16 sqid)
 	return adapter_delete_queue(dev, nvme_admin_delete_sq, sqid);
 }
 
-static void abort_endio(struct request *req, int error)
+static void abort_endio(struct request *req, blk_status_t error)
 {
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
 	struct nvme_queue *nvmeq = iod->nvmeq;
@@ -1586,7 +1586,7 @@ static int nvme_setup_io_queues(struct nvme_dev *dev)
 	return nvme_create_io_queues(dev);
 }
 
-static void nvme_del_queue_end(struct request *req, int error)
+static void nvme_del_queue_end(struct request *req, blk_status_t error)
 {
 	struct nvme_queue *nvmeq = req->end_io_data;
 
@@ -1594,7 +1594,7 @@ static void nvme_del_queue_end(struct request *req, int error)
 	complete(&nvmeq->dev->ioq_wait);
 }
 
-static void nvme_del_cq_end(struct request *req, int error)
+static void nvme_del_cq_end(struct request *req, blk_status_t error)
 {
 	struct nvme_queue *nvmeq = req->end_io_data;
 
diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index 6fb3fd5efc11..b7cbd5d2cdea 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -2672,7 +2672,7 @@ static void __dasd_process_request_queue(struct dasd_block *block)
 	 */
 	if (basedev->state < DASD_STATE_READY) {
 		while ((req = blk_fetch_request(block->request_queue)))
-			__blk_end_request_all(req, -EIO);
+			__blk_end_request_all(req, BLK_STS_IOERR);
 		return;
 	}
 
@@ -2692,7 +2692,7 @@ static void __dasd_process_request_queue(struct dasd_block *block)
 				      "Rejecting write request %p",
 				      req);
 			blk_start_request(req);
-			__blk_end_request_all(req, -EIO);
+			__blk_end_request_all(req, BLK_STS_IOERR);
 			continue;
 		}
 		if (test_bit(DASD_FLAG_ABORTALL, &basedev->flags) &&
@@ -2702,7 +2702,7 @@ static void __dasd_process_request_queue(struct dasd_block *block)
 				      "Rejecting failfast request %p",
 				      req);
 			blk_start_request(req);
-			__blk_end_request_all(req, -ETIMEDOUT);
+			__blk_end_request_all(req, BLK_STS_TIMEOUT);
 			continue;
 		}
 		cqr = basedev->discipline->build_cp(basedev, block, req);
@@ -2734,7 +2734,7 @@ static void __dasd_process_request_queue(struct dasd_block *block)
 				      "on request %p",
 				      PTR_ERR(cqr), req);
 			blk_start_request(req);
-			__blk_end_request_all(req, -EIO);
+			__blk_end_request_all(req, BLK_STS_IOERR);
 			continue;
 		}
 		/*
@@ -2755,21 +2755,29 @@ static void __dasd_cleanup_cqr(struct dasd_ccw_req *cqr)
 {
 	struct request *req;
 	int status;
-	int error = 0;
+	blk_status_t error = BLK_STS_OK;
 
 	req = (struct request *) cqr->callback_data;
 	dasd_profile_end(cqr->block, cqr, req);
+
 	status = cqr->block->base->discipline->free_cp(cqr, req);
 	if (status < 0)
-		error = status;
+		error = errno_to_blk_status(status);
 	else if (status == 0) {
-		if (cqr->intrc == -EPERM)
-			error = -EBADE;
-		else if (cqr->intrc == -ENOLINK ||
-			 cqr->intrc == -ETIMEDOUT)
-			error = cqr->intrc;
-		else
-			error = -EIO;
+		switch (cqr->intrc) {
+		case -EPERM:
+			error = BLK_STS_NEXUS;
+			break;
+		case -ENOLINK:
+			error = BLK_STS_TRANSPORT;
+			break;
+		case -ETIMEDOUT:
+			error = BLK_STS_TIMEOUT;
+			break;
+		default:
+			error = BLK_STS_IOERR;
+			break;
+		}
 	}
 	__blk_end_request_all(req, error);
 }
@@ -3190,7 +3198,7 @@ static void dasd_flush_request_queue(struct dasd_block *block)
 
 	spin_lock_irq(&block->request_queue_lock);
 	while ((req = blk_fetch_request(block->request_queue)))
-		__blk_end_request_all(req, -EIO);
+		__blk_end_request_all(req, BLK_STS_IOERR);
 	spin_unlock_irq(&block->request_queue_lock);
 }
 
diff --git a/drivers/s390/block/scm_blk.c b/drivers/s390/block/scm_blk.c
index 152de6817875..3c2c84b72877 100644
--- a/drivers/s390/block/scm_blk.c
+++ b/drivers/s390/block/scm_blk.c
@@ -231,7 +231,7 @@ static inline void scm_request_init(struct scm_blk_dev *bdev,
 	aob->request.data = (u64) aobrq;
 	scmrq->bdev = bdev;
 	scmrq->retries = 4;
-	scmrq->error = 0;
+	scmrq->error = BLK_STS_OK;
 	/* We don't use all msbs - place aidaws at the end of the aob page. */
 	scmrq->next_aidaw = (void *) &aob->msb[nr_requests_per_io];
 	scm_request_cluster_init(scmrq);
@@ -364,7 +364,7 @@ static void __scmrq_log_error(struct scm_request *scmrq)
 {
 	struct aob *aob = scmrq->aob;
 
-	if (scmrq->error == -ETIMEDOUT)
+	if (scmrq->error == BLK_STS_TIMEOUT)
 		SCM_LOG(1, "Request timeout");
 	else {
 		SCM_LOG(1, "Request error");
@@ -377,7 +377,7 @@ static void __scmrq_log_error(struct scm_request *scmrq)
 		       scmrq->error);
 }
 
-void scm_blk_irq(struct scm_device *scmdev, void *data, int error)
+void scm_blk_irq(struct scm_device *scmdev, void *data, blk_status_t error)
 {
 	struct scm_request *scmrq = data;
 	struct scm_blk_dev *bdev = scmrq->bdev;
@@ -397,7 +397,7 @@ static void scm_blk_handle_error(struct scm_request *scmrq)
 	struct scm_blk_dev *bdev = scmrq->bdev;
 	unsigned long flags;
 
-	if (scmrq->error != -EIO)
+	if (scmrq->error != BLK_STS_IOERR)
 		goto restart;
 
 	/* For -EIO the response block is valid. */
diff --git a/drivers/s390/block/scm_blk.h b/drivers/s390/block/scm_blk.h
index 09218cdc5129..cd598d1a4eae 100644
--- a/drivers/s390/block/scm_blk.h
+++ b/drivers/s390/block/scm_blk.h
@@ -35,7 +35,7 @@ struct scm_request {
 	struct aob *aob;
 	struct list_head list;
 	u8 retries;
-	int error;
+	blk_status_t error;
 #ifdef CONFIG_SCM_BLOCK_CLUSTER_WRITE
 	struct {
 		enum {CLUSTER_NONE, CLUSTER_READ, CLUSTER_WRITE} state;
@@ -50,7 +50,7 @@ struct scm_request {
 int scm_blk_dev_setup(struct scm_blk_dev *, struct scm_device *);
 void scm_blk_dev_cleanup(struct scm_blk_dev *);
 void scm_blk_set_available(struct scm_blk_dev *);
-void scm_blk_irq(struct scm_device *, void *, int);
+void scm_blk_irq(struct scm_device *, void *, blk_status_t);
 
 void scm_request_finish(struct scm_request *);
 void scm_request_requeue(struct scm_request *);
diff --git a/drivers/s390/cio/eadm_sch.c b/drivers/s390/cio/eadm_sch.c
index b3f44bc7f644..0f11f3bcac82 100644
--- a/drivers/s390/cio/eadm_sch.c
+++ b/drivers/s390/cio/eadm_sch.c
@@ -135,7 +135,7 @@ static void eadm_subchannel_irq(struct subchannel *sch)
 	struct eadm_private *private = get_eadm_private(sch);
 	struct eadm_scsw *scsw = &sch->schib.scsw.eadm;
 	struct irb *irb = this_cpu_ptr(&cio_irb);
-	int error = 0;
+	blk_status_t error = BLK_STS_OK;
 
 	EADM_LOG(6, "irq");
 	EADM_LOG_HEX(6, irb, sizeof(*irb));
@@ -144,10 +144,10 @@ static void eadm_subchannel_irq(struct subchannel *sch)
 
 	if ((scsw->stctl & (SCSW_STCTL_ALERT_STATUS | SCSW_STCTL_STATUS_PEND))
 	    && scsw->eswf == 1 && irb->esw.eadm.erw.r)
-		error = -EIO;
+		error = BLK_STS_IOERR;
 
 	if (scsw->fctl & SCSW_FCTL_CLEAR_FUNC)
-		error = -ETIMEDOUT;
+		error = BLK_STS_TIMEOUT;
 
 	eadm_subchannel_set_timeout(sch, 0);
 
diff --git a/drivers/s390/cio/scm.c b/drivers/s390/cio/scm.c
index 15268edc54ae..1fa53ecdc2aa 100644
--- a/drivers/s390/cio/scm.c
+++ b/drivers/s390/cio/scm.c
@@ -71,7 +71,7 @@ void scm_driver_unregister(struct scm_driver *scmdrv)
 }
 EXPORT_SYMBOL_GPL(scm_driver_unregister);
 
-void scm_irq_handler(struct aob *aob, int error)
+void scm_irq_handler(struct aob *aob, blk_status_t error)
 {
 	struct aob_rq_header *aobrq = (void *) aob->request.data;
 	struct scm_device *scmdev = aobrq->scmdev;
diff --git a/drivers/sbus/char/jsflash.c b/drivers/sbus/char/jsflash.c
index 62fed9dc893e..35a69949f92d 100644
--- a/drivers/sbus/char/jsflash.c
+++ b/drivers/sbus/char/jsflash.c
@@ -214,7 +214,7 @@ static void jsfd_request(void)
 		struct jsfd_part *jdp = req->rq_disk->private_data;
 		unsigned long offset = blk_rq_pos(req) << 9;
 		size_t len = blk_rq_cur_bytes(req);
-		int err = -EIO;
+		blk_status_t err = BLK_STS_IOERR;
 
 		if ((offset + len) > jdp->dsize)
 			goto end;
@@ -230,7 +230,7 @@ static void jsfd_request(void)
 		}
 
 		jsfd_read(bio_data(req->bio), jdp->dbase + offset, len);
-		err = 0;
+		err = BLK_STS_OK;
 	end:
 		if (!__blk_end_request_cur(req, err))
 			req = jsfd_next_request();
diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 14785177ce7b..1e69a43b279d 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -446,7 +446,7 @@ static void _put_request(struct request *rq)
 	 *       code paths.
 	 */
 	if (unlikely(rq->bio))
-		blk_end_request(rq, -ENOMEM, blk_rq_bytes(rq));
+		blk_end_request(rq, BLK_STS_IOERR, blk_rq_bytes(rq));
 	else
 		blk_put_request(rq);
 }
@@ -474,7 +474,7 @@ void osd_end_request(struct osd_request *or)
 EXPORT_SYMBOL(osd_end_request);
 
 static void _set_error_resid(struct osd_request *or, struct request *req,
-			     int error)
+			     blk_status_t error)
 {
 	or->async_error = error;
 	or->req_errors = scsi_req(req)->result;
@@ -489,17 +489,19 @@ static void _set_error_resid(struct osd_request *or, struct request *req,
 
 int osd_execute_request(struct osd_request *or)
 {
-	int error;
-
 	blk_execute_rq(or->request->q, NULL, or->request, 0);
-	error = scsi_req(or->request)->result ? -EIO : 0;
 
-	_set_error_resid(or, or->request, error);
-	return error;
+	if (scsi_req(or->request)->result) {
+		_set_error_resid(or, or->request, BLK_STS_IOERR);
+		return -EIO;
+	}
+
+	_set_error_resid(or, or->request, BLK_STS_OK);
+	return 0;
 }
 EXPORT_SYMBOL(osd_execute_request);
 
-static void osd_request_async_done(struct request *req, int error)
+static void osd_request_async_done(struct request *req, blk_status_t error)
 {
 	struct osd_request *or = req->end_io_data;
 
@@ -1914,7 +1916,7 @@ int osd_req_decode_sense_full(struct osd_request *or,
 		/* scsi sense is Empty, the request was never issued to target
 		 * linux return code might tell us what happened.
 		 */
-		if (or->async_error == -ENOMEM)
+		if (or->async_error == BLK_STS_RESOURCE)
 			osi->osd_err_pri = OSD_ERR_PRI_RESOURCE;
 		else
 			osi->osd_err_pri = OSD_ERR_PRI_UNREACHABLE;
diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 67cbed92f07d..d54689c9216e 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -320,7 +320,7 @@ static int osst_chk_result(struct osst_tape * STp, struct osst_request * SRpnt)
 
 
 /* Wakeup from interrupt */
-static void osst_end_async(struct request *req, int update)
+static void osst_end_async(struct request *req, blk_status_t status)
 {
 	struct scsi_request *rq = scsi_req(req);
 	struct osst_request *SRpnt = req->end_io_data;
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index ecc07dab893d..44904f41924c 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1874,7 +1874,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 	}
 }
 
-static void eh_lock_door_done(struct request *req, int uptodate)
+static void eh_lock_door_done(struct request *req, blk_status_t status)
 {
 	__blk_put_request(req->q, req);
 }
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 884aaa84c2dd..67a67191520f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -635,7 +635,7 @@ static void scsi_release_bidi_buffers(struct scsi_cmnd *cmd)
 	cmd->request->next_rq->special = NULL;
 }
 
-static bool scsi_end_request(struct request *req, int error,
+static bool scsi_end_request(struct request *req, blk_status_t error,
 		unsigned int bytes, unsigned int bidi_bytes)
 {
 	struct scsi_cmnd *cmd = req->special;
@@ -694,45 +694,28 @@ static bool scsi_end_request(struct request *req, int error,
  * @cmd:	SCSI command (unused)
  * @result:	scsi error code
  *
- * Translate SCSI error code into standard UNIX errno.
- * Return values:
- * -ENOLINK	temporary transport failure
- * -EREMOTEIO	permanent target failure, do not retry
- * -EBADE	permanent nexus failure, retry on other path
- * -ENOSPC	No write space available
- * -ENODATA	Medium error
- * -EIO		unspecified I/O error
+ * Translate SCSI error code into block errors.
  */
-static int __scsi_error_from_host_byte(struct scsi_cmnd *cmd, int result)
+static blk_status_t __scsi_error_from_host_byte(struct scsi_cmnd *cmd,
+		int result)
 {
-	int error = 0;
-
-	switch(host_byte(result)) {
+	switch (host_byte(result)) {
 	case DID_TRANSPORT_FAILFAST:
-		error = -ENOLINK;
-		break;
+		return BLK_STS_TRANSPORT;
 	case DID_TARGET_FAILURE:
 		set_host_byte(cmd, DID_OK);
-		error = -EREMOTEIO;
-		break;
+		return BLK_STS_TARGET;
 	case DID_NEXUS_FAILURE:
-		set_host_byte(cmd, DID_OK);
-		error = -EBADE;
-		break;
+		return BLK_STS_NEXUS;
 	case DID_ALLOC_FAILURE:
 		set_host_byte(cmd, DID_OK);
-		error = -ENOSPC;
-		break;
+		return BLK_STS_NOSPC;
 	case DID_MEDIUM_ERROR:
 		set_host_byte(cmd, DID_OK);
-		error = -ENODATA;
-		break;
+		return BLK_STS_MEDIUM;
 	default:
-		error = -EIO;
-		break;
+		return BLK_STS_IOERR;
 	}
-
-	return error;
 }
 
 /*
@@ -769,7 +752,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	int result = cmd->result;
 	struct request_queue *q = cmd->device->request_queue;
 	struct request *req = cmd->request;
-	int error = 0;
+	blk_status_t error = BLK_STS_OK;
 	struct scsi_sense_hdr sshdr;
 	bool sense_valid = false;
 	int sense_deferred = 0, level = 0;
@@ -808,7 +791,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 			 * both sides at once.
 			 */
 			scsi_req(req->next_rq)->resid_len = scsi_in(cmd)->resid;
-			if (scsi_end_request(req, 0, blk_rq_bytes(req),
+			if (scsi_end_request(req, BLK_STS_OK, blk_rq_bytes(req),
 					blk_rq_bytes(req->next_rq)))
 				BUG();
 			return;
@@ -850,7 +833,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 			scsi_print_sense(cmd);
 		result = 0;
 		/* for passthrough error may be set */
-		error = 0;
+		error = BLK_STS_OK;
 	}
 
 	/*
@@ -922,18 +905,18 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 				action = ACTION_REPREP;
 			} else if (sshdr.asc == 0x10) /* DIX */ {
 				action = ACTION_FAIL;
-				error = -EILSEQ;
+				error = BLK_STS_PROTECTION;
 			/* INVALID COMMAND OPCODE or INVALID FIELD IN CDB */
 			} else if (sshdr.asc == 0x20 || sshdr.asc == 0x24) {
 				action = ACTION_FAIL;
-				error = -EREMOTEIO;
+				error = BLK_STS_TARGET;
 			} else
 				action = ACTION_FAIL;
 			break;
 		case ABORTED_COMMAND:
 			action = ACTION_FAIL;
 			if (sshdr.asc == 0x10) /* DIF */
-				error = -EILSEQ;
+				error = BLK_STS_PROTECTION;
 			break;
 		case NOT_READY:
 			/* If the device is in the process of becoming
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index d16414bfe2ef..cc970c811bcb 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -172,7 +172,7 @@ static void sas_smp_request(struct request_queue *q, struct Scsi_Host *shost,
 			    struct sas_rphy *rphy)
 {
 	struct request *req;
-	int ret;
+	blk_status_t ret;
 	int (*handler)(struct Scsi_Host *, struct sas_rphy *, struct request *);
 
 	while ((req = blk_fetch_request(q)) != NULL) {
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 82c33a6edbea..f3387c6089c5 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -177,7 +177,7 @@ typedef struct sg_device { /* holds the state of each scsi generic device */
 } Sg_device;
 
 /* tasklet or soft irq callback */
-static void sg_rq_end_io(struct request *rq, int uptodate);
+static void sg_rq_end_io(struct request *rq, blk_status_t status);
 static int sg_start_req(Sg_request *srp, unsigned char *cmd);
 static int sg_finish_rem_req(Sg_request * srp);
 static int sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size);
@@ -808,7 +808,7 @@ sg_common_write(Sg_fd * sfp, Sg_request * srp,
 	if (atomic_read(&sdp->detaching)) {
 		if (srp->bio) {
 			scsi_req_free_cmd(scsi_req(srp->rq));
-			blk_end_request_all(srp->rq, -EIO);
+			blk_end_request_all(srp->rq, BLK_STS_IOERR);
 			srp->rq = NULL;
 		}
 
@@ -1300,7 +1300,7 @@ sg_rq_end_io_usercontext(struct work_struct *work)
  * level when a command is completed (or has failed).
  */
 static void
-sg_rq_end_io(struct request *rq, int uptodate)
+sg_rq_end_io(struct request *rq, blk_status_t status)
 {
 	struct sg_request *srp = rq->end_io_data;
 	struct scsi_request *req = scsi_req(rq);
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 1ea34d6f5437..6b1c4ac54e66 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -511,7 +511,7 @@ static void st_do_stats(struct scsi_tape *STp, struct request *req)
 	atomic64_dec(&STp->stats->in_flight);
 }
 
-static void st_scsi_execute_end(struct request *req, int uptodate)
+static void st_scsi_execute_end(struct request *req, blk_status_t status)
 {
 	struct st_request *SRpnt = req->end_io_data;
 	struct scsi_request *rq = scsi_req(req);
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 3e4abb13f8ea..323ab47645d0 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -55,7 +55,7 @@ static inline struct pscsi_dev_virt *PSCSI_DEV(struct se_device *dev)
 }
 
 static sense_reason_t pscsi_execute_cmd(struct se_cmd *cmd);
-static void pscsi_req_done(struct request *, int);
+static void pscsi_req_done(struct request *, blk_status_t);
 
 /*	pscsi_attach_hba():
  *
@@ -1045,7 +1045,7 @@ static sector_t pscsi_get_blocks(struct se_device *dev)
 	return 0;
 }
 
-static void pscsi_req_done(struct request *req, int uptodate)
+static void pscsi_req_done(struct request *req, blk_status_t status)
 {
 	struct se_cmd *cmd = req->end_io_data;
 	struct pscsi_plugin_task *pt = cmd->priv;
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index fcd641032f8d..0cf6735046d3 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -230,8 +230,8 @@ static inline u16 blk_mq_unique_tag_to_tag(u32 unique_tag)
 
 int blk_mq_request_started(struct request *rq);
 void blk_mq_start_request(struct request *rq);
-void blk_mq_end_request(struct request *rq, int error);
-void __blk_mq_end_request(struct request *rq, int error);
+void blk_mq_end_request(struct request *rq, blk_status_t error);
+void __blk_mq_end_request(struct request *rq, blk_status_t error);
 
 void blk_mq_requeue_request(struct request *rq, bool kick_requeue_list);
 void blk_mq_add_to_requeue_list(struct request *rq, bool at_head,
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 61339bc44400..59378939a8cd 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -17,6 +17,22 @@ struct io_context;
 struct cgroup_subsys_state;
 typedef void (bio_end_io_t) (struct bio *);
 
+/*
+ * Block error status values.  See block/blk-core:blk_errors for the details.
+ */
+typedef u8 __bitwise blk_status_t;
+#define	BLK_STS_OK 0
+#define BLK_STS_NOTSUPP		((__force blk_status_t)1)
+#define BLK_STS_TIMEOUT		((__force blk_status_t)2)
+#define BLK_STS_NOSPC		((__force blk_status_t)3)
+#define BLK_STS_TRANSPORT	((__force blk_status_t)4)
+#define BLK_STS_TARGET		((__force blk_status_t)5)
+#define BLK_STS_NEXUS		((__force blk_status_t)6)
+#define BLK_STS_MEDIUM		((__force blk_status_t)7)
+#define BLK_STS_PROTECTION	((__force blk_status_t)8)
+#define BLK_STS_RESOURCE	((__force blk_status_t)9)
+#define BLK_STS_IOERR		((__force blk_status_t)10)
+
 struct blk_issue_stat {
 	u64 stat;
 };
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 019f18c65098..2a8871638453 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -55,7 +55,7 @@ struct blk_stat_callback;
  */
 #define BLKCG_MAX_POLS		3
 
-typedef void (rq_end_io_fn)(struct request *, int);
+typedef void (rq_end_io_fn)(struct request *, blk_status_t);
 
 #define BLK_RL_SYNCFULL		(1U << 0)
 #define BLK_RL_ASYNCFULL	(1U << 1)
@@ -940,7 +940,7 @@ extern int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
 			     int (*bio_ctr)(struct bio *, struct bio *, void *),
 			     void *data);
 extern void blk_rq_unprep_clone(struct request *rq);
-extern int blk_insert_cloned_request(struct request_queue *q,
+extern blk_status_t blk_insert_cloned_request(struct request_queue *q,
 				     struct request *rq);
 extern int blk_rq_append_bio(struct request *rq, struct bio *bio);
 extern void blk_delay_queue(struct request_queue *, unsigned long);
@@ -980,6 +980,9 @@ extern void blk_execute_rq(struct request_queue *, struct gendisk *,
 extern void blk_execute_rq_nowait(struct request_queue *, struct gendisk *,
 				  struct request *, int, rq_end_io_fn *);
 
+int blk_status_to_errno(blk_status_t status);
+blk_status_t errno_to_blk_status(int errno);
+
 bool blk_mq_poll(struct request_queue *q, blk_qc_t cookie);
 
 static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
@@ -1112,16 +1115,16 @@ extern struct request *blk_fetch_request(struct request_queue *q);
  * blk_end_request() for parts of the original function.
  * This prevents code duplication in drivers.
  */
-extern bool blk_update_request(struct request *rq, int error,
+extern bool blk_update_request(struct request *rq, blk_status_t error,
 			       unsigned int nr_bytes);
-extern void blk_finish_request(struct request *rq, int error);
-extern bool blk_end_request(struct request *rq, int error,
+extern void blk_finish_request(struct request *rq, blk_status_t error);
+extern bool blk_end_request(struct request *rq, blk_status_t error,
 			    unsigned int nr_bytes);
-extern void blk_end_request_all(struct request *rq, int error);
-extern bool __blk_end_request(struct request *rq, int error,
+extern void blk_end_request_all(struct request *rq, blk_status_t error);
+extern bool __blk_end_request(struct request *rq, blk_status_t error,
 			      unsigned int nr_bytes);
-extern void __blk_end_request_all(struct request *rq, int error);
-extern bool __blk_end_request_cur(struct request *rq, int error);
+extern void __blk_end_request_all(struct request *rq, blk_status_t error);
+extern bool __blk_end_request_cur(struct request *rq, blk_status_t error);
 
 extern void blk_complete_request(struct request *);
 extern void __blk_complete_request(struct request *);
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index dec227acc13b..5de5c53251ec 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -74,7 +74,7 @@ typedef void (*dm_release_clone_request_fn) (struct request *clone);
 typedef int (*dm_endio_fn) (struct dm_target *ti,
 			    struct bio *bio, int *error);
 typedef int (*dm_request_endio_fn) (struct dm_target *ti,
-				    struct request *clone, int error,
+				    struct request *clone, blk_status_t error,
 				    union map_info *map_context);
 
 typedef void (*dm_presuspend_fn) (struct dm_target *ti);
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 6980ca322074..dc152e4b7f73 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -671,7 +671,7 @@ struct ide_port_ops {
 	void	(*init_dev)(ide_drive_t *);
 	void	(*set_pio_mode)(struct hwif_s *, ide_drive_t *);
 	void	(*set_dma_mode)(struct hwif_s *, ide_drive_t *);
-	int	(*reset_poll)(ide_drive_t *);
+	blk_status_t (*reset_poll)(ide_drive_t *);
 	void	(*pre_reset)(ide_drive_t *);
 	void	(*resetproc)(ide_drive_t *);
 	void	(*maskproc)(ide_drive_t *, int);
@@ -1092,7 +1092,7 @@ int generic_ide_ioctl(ide_drive_t *, struct block_device *, unsigned, unsigned l
 extern int ide_vlb_clk;
 extern int ide_pci_clk;
 
-int ide_end_rq(ide_drive_t *, struct request *, int, unsigned int);
+int ide_end_rq(ide_drive_t *, struct request *, blk_status_t, unsigned int);
 void ide_kill_rq(ide_drive_t *, struct request *);
 
 void __ide_set_handler(ide_drive_t *, ide_handler_t *, unsigned int);
@@ -1123,7 +1123,7 @@ extern int ide_devset_execute(ide_drive_t *drive,
 			      const struct ide_devset *setting, int arg);
 
 void ide_complete_cmd(ide_drive_t *, struct ide_cmd *, u8, u8);
-int ide_complete_rq(ide_drive_t *, int, unsigned int);
+int ide_complete_rq(ide_drive_t *, blk_status_t, unsigned int);
 
 void ide_tf_readback(ide_drive_t *drive, struct ide_cmd *cmd);
 void ide_tf_dump(const char *, struct ide_cmd *);
diff --git a/include/scsi/osd_initiator.h b/include/scsi/osd_initiator.h
index a09cca829082..a29d3086eb56 100644
--- a/include/scsi/osd_initiator.h
+++ b/include/scsi/osd_initiator.h
@@ -157,7 +157,7 @@ struct osd_request {
 
 	osd_req_done_fn *async_done;
 	void *async_private;
-	int async_error;
+	blk_status_t async_error;
 	int req_errors;
 };
 
-- 
2.11.0
