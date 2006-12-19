From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [RFC PATCH 2/8] rqbased-dm: add block layer hook
Date: Tue, 19 Dec 2006 17:11:50 -0500 (EST)
Message-ID: <20061219.171150.75425661.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jens.axboe@oracle.com, agk@redhat.com, mchristi@redhat.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

This patch adds new "end_io_first" hook in __end_that_request_first()
for request-based device-mapper.


Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

diff -rupN 1-blk-get-request-irqrestore/block/ll_rw_blk.c 2-add-generic-hook/block/ll_rw_blk.c
--- 1-blk-get-request-irqrestore/block/ll_rw_blk.c	2006-12-15 10:21:29.000000000 -0500
+++ 2-add-generic-hook/block/ll_rw_blk.c	2006-12-15 10:23:30.000000000 -0500
@@ -260,6 +260,7 @@ static void rq_init(request_queue_t *q, 
 	rq->data = NULL;
 	rq->nr_phys_segments = 0;
 	rq->sense = NULL;
+	rq->end_io_first = NULL;
 	rq->end_io = NULL;
 	rq->end_io_data = NULL;
 	rq->completion_data = NULL;
@@ -3216,6 +3217,22 @@ static int __end_that_request_first(stru
 
 	blk_add_trace_rq(req->q, req, BLK_TA_COMPLETE);
 
+	if (!uptodate) {
+		if (blk_fs_request(req) && !(req->cmd_flags & REQ_QUIET))
+			printk("end_request: I/O error, dev %s, sector %llu\n",
+				req->rq_disk ? req->rq_disk->disk_name : "?",
+				(unsigned long long)req->sector);
+	}
+
+	if (blk_fs_request(req) && req->rq_disk) {
+		const int rw = rq_data_dir(req);
+
+		disk_stat_add(req->rq_disk, sectors[rw], nr_bytes >> 9);
+	}
+
+	if (req->end_io_first)
+		return req->end_io_first(req, uptodate, nr_bytes);
+
 	/*
 	 * extend uptodate bool to allow < 0 value to be direct io error
 	 */
@@ -3230,19 +3247,6 @@ static int __end_that_request_first(stru
 	if (!blk_pc_request(req))
 		req->errors = 0;
 
-	if (!uptodate) {
-		if (blk_fs_request(req) && !(req->cmd_flags & REQ_QUIET))
-			printk("end_request: I/O error, dev %s, sector %llu\n",
-				req->rq_disk ? req->rq_disk->disk_name : "?",
-				(unsigned long long)req->sector);
-	}
-
-	if (blk_fs_request(req) && req->rq_disk) {
-		const int rw = rq_data_dir(req);
-
-		disk_stat_add(req->rq_disk, sectors[rw], nr_bytes >> 9);
-	}
-
 	total_bytes = bio_nbytes = 0;
 	while ((bio = req->bio) != NULL) {
 		int nbytes;
diff -rupN 1-blk-get-request-irqrestore/include/linux/blkdev.h 2-add-generic-hook/include/linux/blkdev.h
--- 1-blk-get-request-irqrestore/include/linux/blkdev.h	2006-12-11 14:32:53.000000000 -0500
+++ 2-add-generic-hook/include/linux/blkdev.h	2006-12-15 10:23:30.000000000 -0500
@@ -126,6 +126,7 @@ void copy_io_context(struct io_context *
 void swap_io_context(struct io_context **ioc1, struct io_context **ioc2);
 
 struct request;
+typedef int (rq_end_first_fn)(struct request *, int, int);
 typedef void (rq_end_io_fn)(struct request *, int);
 
 struct request_list {
@@ -312,6 +313,7 @@ struct request {
 	/*
 	 * completion callback.
 	 */
+	rq_end_first_fn *end_io_first;
 	rq_end_io_fn *end_io;
 	void *end_io_data;
 };
