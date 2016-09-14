From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 5/6] dm mpath: use dm_mq_kick_requeue_list()
Date: Wed, 14 Sep 2016 12:29:35 -0400
Message-ID: <1473870576-54331-6-git-send-email-snitzer@redhat.com>
References: <1473870576-54331-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1473870576-54331-1-git-send-email-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk, dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
List-Id: dm-devel.ids

When reinstating a path the blk-mq request_queue's requeue_list should
get kicked.  It makes sense to kick the requeue_list as part of the
existing hook (previously only used by bio-based support).

Rename process_queued_bios_list to process_queued_io_list.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-mpath.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index c777d38..f69715b 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -680,9 +680,11 @@ static int multipath_map_bio(struct dm_target *ti, struct bio *bio)
 	return __multipath_map_bio(m, bio, mpio);
 }
 
-static void process_queued_bios_list(struct multipath *m)
+static void process_queued_io_list(struct multipath *m)
 {
-	if (m->queue_mode == DM_TYPE_BIO_BASED)
+	if (m->queue_mode == DM_TYPE_MQ_REQUEST_BASED)
+		dm_mq_kick_requeue_list(dm_table_get_md(m->ti->table));
+	else if (m->queue_mode == DM_TYPE_BIO_BASED)
 		queue_work(kmultipathd, &m->process_queued_bios);
 }
 
@@ -752,7 +754,7 @@ static int queue_if_no_path(struct multipath *m, bool queue_if_no_path,
 
 	if (!queue_if_no_path) {
 		dm_table_run_md_queue_async(m->ti->table);
-		process_queued_bios_list(m);
+		process_queued_io_list(m);
 	}
 
 	return 0;
@@ -1304,7 +1306,7 @@ out:
 	spin_unlock_irqrestore(&m->lock, flags);
 	if (run_queue) {
 		dm_table_run_md_queue_async(m->ti->table);
-		process_queued_bios_list(m);
+		process_queued_io_list(m);
 	}
 
 	return r;
@@ -1502,7 +1504,7 @@ static void pg_init_done(void *data, int errors)
 	}
 	clear_bit(MPATHF_QUEUE_IO, &m->flags);
 
-	process_queued_bios_list(m);
+	process_queued_io_list(m);
 
 	/*
 	 * Wake up any thread waiting to suspend.
@@ -1937,7 +1939,7 @@ static int multipath_prepare_ioctl(struct dm_target *ti,
 		if (test_bit(MPATHF_PG_INIT_REQUIRED, &m->flags))
 			pg_init_all_paths(m);
 		dm_table_run_md_queue_async(m->ti->table);
-		process_queued_bios_list(m);
+		process_queued_io_list(m);
 	}
 
 	/*
-- 
2.7.4 (Apple Git-66)

