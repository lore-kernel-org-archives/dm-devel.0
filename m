From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 03/13] dm-mpath: Delay requeuing while path initialization is in progress
Date: Wed, 26 Apr 2017 11:37:18 -0700
Message-ID: <20170426183728.10821-4-bart.vanassche@sandisk.com>
References: <20170426183728.10821-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170426183728.10821-1-bart.vanassche@sandisk.com>
Sender: stable-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Bart Van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
List-Id: dm-devel.ids

Requeuing a request immediately while path initialization is ongoing
causes high CPU usage, something that is undesired. Hence delay
requeuing while path initialization is in progress.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: <stable@vger.kernel.org>
---
 drivers/md/dm-mpath.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 6d4333fdddf5..e38c92178746 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -322,13 +322,16 @@ static int __pg_init_all_paths(struct multipath *m)
 	return atomic_read(&m->pg_init_in_progress);
 }
 
-static void pg_init_all_paths(struct multipath *m)
+static int pg_init_all_paths(struct multipath *m)
 {
 	unsigned long flags;
+	int ret;
 
 	spin_lock_irqsave(&m->lock, flags);
-	__pg_init_all_paths(m);
+	ret = __pg_init_all_paths(m);
 	spin_unlock_irqrestore(&m->lock, flags);
+
+	return ret;
 }
 
 static void __switch_pg(struct multipath *m, struct priority_group *pg)
@@ -485,7 +488,6 @@ static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
 				   struct request **__clone)
 {
 	struct multipath *m = ti->private;
-	int r = DM_MAPIO_REQUEUE;
 	size_t nr_bytes = blk_rq_bytes(rq);
 	struct pgpath *pgpath;
 	struct block_device *bdev;
@@ -504,8 +506,8 @@ static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
 		return -EIO;	/* Failed */
 	} else if (test_bit(MPATHF_QUEUE_IO, &m->flags) ||
 		   test_bit(MPATHF_PG_INIT_REQUIRED, &m->flags)) {
-		pg_init_all_paths(m);
-		return r;
+		return pg_init_all_paths(m) == 0 ? DM_MAPIO_REQUEUE :
+			DM_MAPIO_DELAY_REQUEUE;
 	}
 
 	memset(mpio, 0, sizeof(*mpio));
-- 
2.12.2
