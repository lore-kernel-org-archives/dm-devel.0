From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm crypt: fix lost ioprio when queuing crypto
	bios from task with ioprio
Date: Thu,  6 Dec 2018 17:15:07 -0500
Message-ID: <20181206221507.5423-1-snitzer@redhat.com>
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
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Eric Wheeler <dm-devel@lists.ewheeler.net>, dm-devel@redhat.com
List-Id: dm-devel.ids

From: Eric Wheeler <dm-devel@lists.ewheeler.net>

Since dm-crypt queues writes (and sometimes reads) to a different kernel
thread (workqueue), the bios will dispatch from tasks with different
io_context->ioprio settings than the submitting task, thus giving
incorrect ioprio hints to the io scheduler.

By assigning the ioprio to the bio before queuing to a workqueue, the
original submitting task's io_context->ioprio setting can be retained
through the life of the bio.  We only set the bio's ioprio in dm-crypt
if not already set (by somewhere else, higher in the stack).

Signed-off-by: Eric Wheeler <dm-devel@linux.ewheeler.net>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/bio.c           | 24 ++++++++++++++++++++++++
 drivers/md/dm-crypt.c | 15 +++++++++++++--
 include/linux/bio.h   |  2 ++
 3 files changed, 39 insertions(+), 2 deletions(-)

[Jens, too much block code for me to take, please feel free to pick
this up, I tweaked Eric's original for 2 years ago (sorry this slipped
through the cracks Eric!):
https://patchwork.kernel.org/patch/9474535/
]

diff --git a/block/bio.c b/block/bio.c
index 0c2208a5446d..ed68fdd78547 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -647,6 +647,30 @@ struct bio *bio_clone_fast(struct bio *bio, gfp_t gfp_mask, struct bio_set *bs)
 }
 EXPORT_SYMBOL(bio_clone_fast);
 
+/**
+ *	bio_set_task_prio - set bio's ioprio to task's ioprio, if any.
+ *	@bio: bio to set the ioprio of, can be NULL
+ *	@task: task of interest
+ *	@gfp_flags: allocation flags, used if allocation is necessary
+ *	@node: allocation node, used if allocation is necessary
+ */
+void bio_set_task_prio(struct bio *bio, struct task_struct *task,
+		       gfp_t gfp_flags, int node)
+{
+	struct io_context *ioc;
+
+	if (!bio)
+		return;
+
+	ioc = get_task_io_context(current, gfp_flags, node);
+	if (ioc) {
+		if (ioprio_valid(ioc->ioprio))
+			bio_set_prio(bio, ioc->ioprio);
+		put_io_context(ioc);
+	}
+}
+EXPORT_SYMBOL(bio_set_task_prio);
+
 /**
  *	bio_add_pc_page	-	attempt to add page to bio
  *	@q: the target queue
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 509fb20f7f86..4e3f0962f230 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1548,6 +1548,7 @@ static void clone_init(struct dm_crypt_io *io, struct bio *clone)
 	clone->bi_private = io;
 	clone->bi_end_io  = crypt_endio;
 	bio_set_dev(clone, cc->dev->bdev);
+	bio_set_prio(clone, bio_prio(io->base_bio));
 	clone->bi_opf	  = io->base_bio->bi_opf;
 }
 
@@ -2916,10 +2917,20 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
 		io->ctx.r.req = (struct skcipher_request *)(io + 1);
 
 	if (bio_data_dir(io->base_bio) == READ) {
-		if (kcryptd_io_read(io, GFP_NOWAIT))
+		if (kcryptd_io_read(io, GFP_NOWAIT)) {
+			if (!ioprio_valid(bio_prio(io->base_bio))) {
+				bio_set_task_prio(io->base_bio, current,
+						  GFP_NOIO, NUMA_NO_NODE);
+			}
 			kcryptd_queue_read(io);
-	} else
+		}
+	} else {
+		if (!ioprio_valid(bio_prio(io->base_bio))) {
+			bio_set_task_prio(io->base_bio, current,
+					  GFP_NOIO, NUMA_NO_NODE);
+		}
 		kcryptd_queue_crypt(io);
+	}
 
 	return DM_MAPIO_SUBMITTED;
 }
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 056fb627edb3..93e11424e7f0 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -46,6 +46,8 @@
 
 #define bio_prio(bio)			(bio)->bi_ioprio
 #define bio_set_prio(bio, prio)		((bio)->bi_ioprio = prio)
+extern void bio_set_task_prio(struct bio *bio, struct task_struct *task,
+			      gfp_t gfp_flags, int node);
 
 #define bio_iter_iovec(bio, iter)				\
 	bvec_iter_bvec((bio)->bi_io_vec, (iter))
-- 
2.15.0
