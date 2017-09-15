From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 5/5] dm-mpath: improve I/O schedule
Date: Sat, 16 Sep 2017 00:44:56 +0800
Message-ID: <20170915164456.9803-6-ming.lei@redhat.com>
References: <20170915164456.9803-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170915164456.9803-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@fb.com>
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

The actual I/O schedule is done in dm-mpath layer, and the
underlying I/O schedule is simply bypassed.

This patch sets underlying queue's nr_requests as its queue's
queue_depth, then  we can get its queue busy feedback by simply
checking if blk_get_request() returns successfully.

In this way, dm-mpath can reports its queue busy to block layer
effectively, so I/O scheduling is improved much.

Follows the test results on lpfc*:

- fio(libaio, bs:4k, dio, queue_depth:64, 64 jobs,
      over dm-mpath disk)
- system(12 cores, dual sockets, mem: 64G)

---------------------------------------
          |v4.13+         |v4.13+
          |+scsi_mq_perf  |+scsi_mq_perf+patches
-----------------------------------------
 IOPS(K)  |MQ-DEADLINE    |MQ-DEADLINE
------------------------------------------
read      |       30.71   |      343.91
-----------------------------------------
randread  |       22.98   |       17.17
------------------------------------------
write     |       16.45   |      390.88
------------------------------------------
randwrite |       16.21   |       16.09
---------------------------------------

*:
1) lpfc.lpfc_lun_queue_depth=3, so that it is same with .cmd_per_lun
2) scsi_mq_perf means the patchset of 'blk-mq-sched: improve SCSI-MQ performance(V4)'[1]
3) v4.13+: top commit is 46c1e79fee41 Merge branch 'perf-urgent-for-linus'
4) the patchset 'blk-mq-sched: improve SCSI-MQ performance(V4)' focuses
on improving on SCSI-MQ, and all the test result in that coverletter was
against the raw lpfc/ib(run after 'multipath -F'), instead of dm-mpath.
5) this patchset itself doesn't depend on the scsi_mq_perf patchset[1]

[1] https://marc.info/?t=150436555700002&r=1&w=2

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/md/dm-mpath.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index f57ad8621c4c..02647386d2d9 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -39,6 +39,8 @@ struct pgpath {
 
 	struct dm_path path;
 	struct delayed_work activate_path;
+	unsigned old_nr_requests;
+	unsigned queue_depth;
 
 	bool is_active:1;		/* Path status */
 };
@@ -160,12 +162,34 @@ static struct priority_group *alloc_priority_group(void)
 	return pg;
 }
 
+static void save_path_queue_depth(struct pgpath *p)
+{
+	struct request_queue *q = bdev_get_queue(p->path.dev->bdev);
+
+	p->old_nr_requests = q->nr_requests;
+	p->queue_depth = q->queue_depth;
+
+	/* one extra request for making the pipeline full */
+	if (p->queue_depth)
+		blk_update_nr_requests(q, p->queue_depth + 1);
+}
+
+static void restore_path_queue_depth(struct pgpath *p)
+{
+	struct request_queue *q = bdev_get_queue(p->path.dev->bdev);
+
+	/* nr->requests isn't changed, we restore to old value */
+	if (q->nr_requests == p->queue_depth + 1)
+		blk_update_nr_requests(q, p->old_nr_requests);
+}
+
 static void free_pgpaths(struct list_head *pgpaths, struct dm_target *ti)
 {
 	struct pgpath *pgpath, *tmp;
 
 	list_for_each_entry_safe(pgpath, tmp, pgpaths, list) {
 		list_del(&pgpath->list);
+		restore_path_queue_depth(pgpath);
 		dm_put_device(ti, pgpath->path.dev);
 		free_pgpath(pgpath);
 	}
@@ -810,6 +834,8 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 		goto bad;
 	}
 
+	save_path_queue_depth(p);
+
 	return p;
 
  bad:
-- 
2.9.5
