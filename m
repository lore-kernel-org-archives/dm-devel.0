From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v3 09/10] dm-kcopyd: Add sequential write feature
Date: Mon, 8 May 2017 16:40:51 -0700
Message-ID: <20170508234052.32375-10-bart.vanassche@sandisk.com>
References: <20170508234052.32375-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170508234052.32375-1-bart.vanassche@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Damien Le Moal <damien.lemoal@wdc.com>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

From: Damien Le Moal <damien.lemoal@wdc.com>

When copyying blocks to host-managed zoned block devices, writes must be
sequential. dm_kcopyd_copy() does not howerver guarantee this as writes
are issued in the completion order of reads, and reads may complete out
of order despite being issued sequentially.

Fix this by introducing the DM_KCOPYD_WRITE_SEQ flag. This can be
specified by the user when calling dm_kcopyd_copy() and is set
automatically if one of the destinations is a host-managed zoned block
device. For a split job, the master job maintains the write position at
which writes must be issued. This is checked with the pop() function
which is modify to not return any write I/O sub job that is not at the
correct write position.

When DM_KCOPYD_WRITE_SEQ is specified for a job, errors cannot be
ignored and the flag DM_KCOPYD_IGNORE_ERROR is ignored, even if
specified by the user.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 drivers/md/dm-kcopyd.c    | 68 +++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/dm-kcopyd.h |  1 +
 2 files changed, 67 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
index f858467..6487905 100644
--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -356,6 +356,7 @@ struct kcopyd_job {
 	struct mutex lock;
 	atomic_t sub_jobs;
 	sector_t progress;
+	sector_t write_ofst;
 
 	struct kcopyd_job *master_job;
 };
@@ -386,6 +387,34 @@ void dm_kcopyd_exit(void)
  * Functions to push and pop a job onto the head of a given job
  * list.
  */
+static struct kcopyd_job *pop_io_job(struct list_head *jobs,
+				     struct dm_kcopyd_client *kc)
+{
+	struct kcopyd_job *job;
+
+	/*
+	 * For I/O jobs, pop any read, any write without sequential write
+	 * constraint and sequential writes that are at the right position.
+	 */
+	list_for_each_entry(job, jobs, list) {
+
+		if (job->rw == READ ||
+		    !test_bit(DM_KCOPYD_WRITE_SEQ, &job->flags)) {
+			list_del(&job->list);
+			return job;
+		}
+
+		if (job->write_ofst == job->master_job->write_ofst) {
+			job->master_job->write_ofst += job->source.count;
+			list_del(&job->list);
+			return job;
+		}
+
+	}
+
+	return NULL;
+}
+
 static struct kcopyd_job *pop(struct list_head *jobs,
 			      struct dm_kcopyd_client *kc)
 {
@@ -395,8 +424,12 @@ static struct kcopyd_job *pop(struct list_head *jobs,
 	spin_lock_irqsave(&kc->job_lock, flags);
 
 	if (!list_empty(jobs)) {
-		job = list_entry(jobs->next, struct kcopyd_job, list);
-		list_del(&job->list);
+		if (jobs == &kc->io_jobs) {
+			job = pop_io_job(jobs, kc);
+		} else {
+			job = list_entry(jobs->next, struct kcopyd_job, list);
+			list_del(&job->list);
+		}
 	}
 	spin_unlock_irqrestore(&kc->job_lock, flags);
 
@@ -506,6 +539,14 @@ static int run_io_job(struct kcopyd_job *job)
 		.client = job->kc->io_client,
 	};
 
+	/*
+	 * If we need to write sequentially and some reads or writes failed,
+	 * no point in continuing.
+	 */
+	if (test_bit(DM_KCOPYD_WRITE_SEQ, &job->flags) &&
+	    job->master_job->write_err)
+		return -EIO;
+
 	io_job_start(job->kc->throttle);
 
 	if (job->rw == READ)
@@ -655,6 +696,7 @@ static void segment_complete(int read_err, unsigned long write_err,
 		int i;
 
 		*sub_job = *job;
+		sub_job->write_ofst = progress;
 		sub_job->source.sector += progress;
 		sub_job->source.count = count;
 
@@ -723,6 +765,27 @@ int dm_kcopyd_copy(struct dm_kcopyd_client *kc, struct dm_io_region *from,
 	job->num_dests = num_dests;
 	memcpy(&job->dests, dests, sizeof(*dests) * num_dests);
 
+	/*
+	 * If one of the destination is a host-managed zoned block device,
+	 * we need to write sequentially. If one of the destination is a
+	 * host-aware device, then leave it to the caller to choose what to do.
+	 */
+	if (!test_bit(DM_KCOPYD_WRITE_SEQ, &job->flags)) {
+		for (i = 0; i < job->num_dests; i++) {
+			if (bdev_zoned_model(dests[i].bdev) == BLK_ZONED_HM) {
+				set_bit(DM_KCOPYD_WRITE_SEQ, &job->flags);
+				break;
+			}
+		}
+	}
+
+	/*
+	 * If we need to write sequentially, errors cannot be ignored.
+	 */
+	if (test_bit(DM_KCOPYD_WRITE_SEQ, &job->flags) &&
+	    test_bit(DM_KCOPYD_IGNORE_ERROR, &job->flags))
+		clear_bit(DM_KCOPYD_IGNORE_ERROR, &job->flags);
+
 	if (from) {
 		job->source = *from;
 		job->pages = NULL;
@@ -746,6 +809,7 @@ int dm_kcopyd_copy(struct dm_kcopyd_client *kc, struct dm_io_region *from,
 	job->fn = fn;
 	job->context = context;
 	job->master_job = job;
+	job->write_ofst = 0;
 
 	if (job->source.count <= SUB_JOB_SIZE)
 		dispatch_job(job);
diff --git a/include/linux/dm-kcopyd.h b/include/linux/dm-kcopyd.h
index f486d63..cfac858 100644
--- a/include/linux/dm-kcopyd.h
+++ b/include/linux/dm-kcopyd.h
@@ -20,6 +20,7 @@
 #define DM_KCOPYD_MAX_REGIONS 8
 
 #define DM_KCOPYD_IGNORE_ERROR 1
+#define DM_KCOPYD_WRITE_SEQ    2
 
 struct dm_kcopyd_throttle {
 	unsigned throttle;
-- 
2.9.3
