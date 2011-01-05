From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] Make kcopyd merge more I/O requests
Date: Wed, 5 Jan 2011 15:48:42 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1101051545490.30162@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
Cc: "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

Hi

This is resend of the previous patch, with comments added.

Mikulas

---

Make kcopyd merge more I/O requests by using device unplugging.

Without this patch, each I/O request is dispatched separately to the device.
If the device supports tagged queuing, there are many small requests sent
to the device. To improve performance, this patch will batch as many requests
as possible, allowing the queue to merge consecutive requests, and send them
to the device at once.

In my tests (15k SCSI disk), this patch improves sequential write throughput:

  Sequential write throughput (chunksize of 4k, 32k, 512k)
  unpatched: 15.2, 18.5, 17.5 MB/s
  patched:   14.4, 22.6, 23.0 MB/s

In most common uses (snapshot or two-way mirror), kcopyd is only used for
two devices, one for reading and the other for writing, thus this optimization
is implemented only for two devices. The optimization may be extended to n-way
mirrors with some code complexity increase.

We keep track of two block devices to unplug (one for read and the
other for write) and unplug them when exiting "do_work" thread.  If
there are more devices used (in theory it could happen, in practice it
is rare), we unplug immediately.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm-kcopyd.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 51 insertions(+), 3 deletions(-)


Index: linux-2.6.37-rc8-fast/drivers/md/dm-kcopyd.c
===================================================================
--- linux-2.6.37-rc8-fast.orig/drivers/md/dm-kcopyd.c	2011-01-05 14:49:03.000000000 +0100
+++ linux-2.6.37-rc8-fast/drivers/md/dm-kcopyd.c	2011-01-05 21:47:37.000000000 +0100
@@ -37,6 +37,13 @@ struct dm_kcopyd_client {
 	unsigned int nr_pages;
 	unsigned int nr_free_pages;
 
+	/*
+	 * Block devices to unplug.
+	 * Non-NULL pointer means that a block device has some pending requests
+	 * and needs to be unplugged.
+	 */
+	struct block_device *unplug[2];
+
 	struct dm_io_client *io_client;
 
 	wait_queue_head_t destroyq;
@@ -308,6 +315,31 @@ static int run_complete_job(struct kcopy
 	return 0;
 }
 
+/*
+ * Unplug the block device at the specified index.
+ */
+static void unplug(struct dm_kcopyd_client *kc, int rw)
+{
+	if (kc->unplug[rw] != NULL) {
+		blk_unplug(bdev_get_queue(kc->unplug[rw]));
+		kc->unplug[rw] = NULL;
+	}
+}
+
+/*
+ * Prepare block device unplug. If there's another device
+ * to be unplugged at the same array index, we unplug that
+ * device first.
+ */
+static void prepare_unplug(struct dm_kcopyd_client *kc, int rw,
+			   struct block_device *bdev)
+{
+	if (likely(kc->unplug[rw] == bdev))
+		return;
+	unplug(kc, rw);
+	kc->unplug[rw] = bdev;
+}
+
 static void complete_io(unsigned long error, void *context)
 {
 	struct kcopyd_job *job = (struct kcopyd_job *) context;
@@ -345,7 +377,7 @@ static int run_io_job(struct kcopyd_job 
 {
 	int r;
 	struct dm_io_request io_req = {
-		.bi_rw = job->rw | REQ_UNPLUG,
+		.bi_rw = job->rw,
 		.mem.type = DM_IO_PAGE_LIST,
 		.mem.ptr.pl = job->pages,
 		.mem.offset = job->offset,
@@ -354,10 +386,16 @@ static int run_io_job(struct kcopyd_job 
 		.client = job->kc->io_client,
 	};
 
-	if (job->rw == READ)
+	if (job->rw == READ) {
 		r = dm_io(&io_req, 1, &job->source, NULL);
-	else
+		prepare_unplug(job->kc, READ, job->source.bdev);
+	} else {
+		if (job->num_dests > 1)
+			io_req.bi_rw |= REQ_UNPLUG;
 		r = dm_io(&io_req, job->num_dests, job->dests, NULL);
+		if (!(io_req.bi_rw & REQ_UNPLUG))
+			prepare_unplug(job->kc, WRITE, job->dests[0].bdev);
+	}
 
 	return r;
 }
@@ -435,10 +473,18 @@ static void do_work(struct work_struct *
 	 * Pages jobs when successful will jump onto the io jobs
 	 * list.  io jobs call wake when they complete and it all
 	 * starts again.
+	 *
+	 * Note that io_jobs add block devices to the unplug array,
+	 * this array is cleared with "unplug" calls. It is thus
+	 * forbidden to run complete_jobs after io_jobs and before
+	 * unplug because the block device could be destroyed in
+	 * job completion callback.
 	 */
 	process_jobs(&kc->complete_jobs, kc, run_complete_job);
 	process_jobs(&kc->pages_jobs, kc, run_pages_job);
 	process_jobs(&kc->io_jobs, kc, run_io_job);
+	unplug(kc, READ);
+	unplug(kc, WRITE);
 }
 
 /*
@@ -619,6 +665,8 @@ int dm_kcopyd_client_create(unsigned int
 	INIT_LIST_HEAD(&kc->io_jobs);
 	INIT_LIST_HEAD(&kc->pages_jobs);
 
+	memset(kc->unplug, 0, sizeof(kc->unplug));
+
 	kc->job_pool = mempool_create_slab_pool(MIN_JOBS, _job_cache);
 	if (!kc->job_pool)
 		goto bad_slab;
