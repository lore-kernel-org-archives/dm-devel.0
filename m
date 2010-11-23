From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2] dm kcopyd: delay unplug of the queues
Date: Tue, 23 Nov 2010 18:25:56 -0500
Message-ID: <20101123232556.GB24962@redhat.com>
References: <Pine.LNX.4.64.1010242102240.6231@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1010242102240.6231@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

From: Mikulas Patocka <mpatocka@redhat.com>

This patch improves performance by about 20% when writing to the
snapshot origin.

Sequential write throughput (chunksize of 4k, 32k, 512k)
unpatched: 15.2, 18.5, 17.5 MB/s
patched:   14.4, 22.6, 23.0 MB/s

We keep track of two block devices to unplug (one for read and the
other for write) and unplug them when exiting "do_work" thread.  If
there are more devices used (in theory it could happen, in practice it
is rare), we unplug immediately.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-kcopyd.c |   35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

v2: added missing parenthesis around sizeof, renamed prepare_unplug and
    unplug 'queue' parameter to 'rw'.

Index: linux-2.6/drivers/md/dm-kcopyd.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-kcopyd.c
+++ linux-2.6/drivers/md/dm-kcopyd.c
@@ -37,6 +37,8 @@ struct dm_kcopyd_client {
 	unsigned int nr_pages;
 	unsigned int nr_free_pages;
 
+	struct block_device *unplug[2];
+
 	struct dm_io_client *io_client;
 
 	wait_queue_head_t destroyq;
@@ -308,6 +310,23 @@ static int run_complete_job(struct kcopy
 	return 0;
 }
 
+static void unplug(struct dm_kcopyd_client *kc, int rw)
+{
+	if (kc->unplug[rw] != NULL) {
+		blk_unplug(bdev_get_queue(kc->unplug[rw]));
+		kc->unplug[rw] = NULL;
+	}
+}
+
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
@@ -345,7 +364,7 @@ static int run_io_job(struct kcopyd_job 
 {
 	int r;
 	struct dm_io_request io_req = {
-		.bi_rw = job->rw | REQ_UNPLUG,
+		.bi_rw = job->rw,
 		.mem.type = DM_IO_PAGE_LIST,
 		.mem.ptr.pl = job->pages,
 		.mem.offset = job->offset,
@@ -354,10 +373,16 @@ static int run_io_job(struct kcopyd_job 
 		.client = job->kc->io_client,
 	};
 
-	if (job->rw == READ)
+	if (job->rw == READ) {
 		r = dm_io(&io_req, 1, &job->source, NULL);
-	else
+		prepare_unplug(job->kc, READ, job->source.bdev);
+	} else {
+		if (unlikely(job->num_dests > 1))
+			io_req.bi_rw |= REQ_UNPLUG;
 		r = dm_io(&io_req, job->num_dests, job->dests, NULL);
+		if (likely(!(io_req.bi_rw & REQ_UNPLUG)))
+			prepare_unplug(job->kc, WRITE, job->dests[0].bdev);
+	}
 
 	return r;
 }
@@ -439,6 +464,8 @@ static void do_work(struct work_struct *
 	process_jobs(&kc->complete_jobs, kc, run_complete_job);
 	process_jobs(&kc->pages_jobs, kc, run_pages_job);
 	process_jobs(&kc->io_jobs, kc, run_io_job);
+	unplug(kc, READ);
+	unplug(kc, WRITE);
 }
 
 /*
@@ -619,6 +646,8 @@ int dm_kcopyd_client_create(unsigned int
 	INIT_LIST_HEAD(&kc->io_jobs);
 	INIT_LIST_HEAD(&kc->pages_jobs);
 
+	memset(kc->unplug, 0, sizeof(kc->unplug));
+
 	kc->job_pool = mempool_create_slab_pool(MIN_JOBS, _job_cache);
 	if (!kc->job_pool)
 		goto bad_slab;
