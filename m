From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v2 01/13] dm-mpath: Split activate_path()
Date: Thu, 27 Apr 2017 10:11:14 -0700
Message-ID: <20170427171126.26814-2-bart.vanassche@sandisk.com>
References: <20170427171126.26814-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170427171126.26814-1-bart.vanassche@sandisk.com>
Sender: stable-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Bart Van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
List-Id: dm-devel.ids

This patch does not change any functionality but makes the next
patch in this series easier to read.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: <stable@vger.kernel.org>
---
 drivers/md/dm-mpath.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 7f223dbed49f..eff7ecea1d2a 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -111,7 +111,8 @@ typedef int (*action_fn) (struct pgpath *pgpath);
 
 static struct workqueue_struct *kmultipathd, *kmpath_handlerd;
 static void trigger_event(struct work_struct *work);
-static void activate_path(struct work_struct *work);
+static void activate_or_offline_path(struct pgpath *pgpath);
+static void activate_path_work(struct work_struct *work);
 static void process_queued_bios(struct work_struct *work);
 
 /*-----------------------------------------------
@@ -136,7 +137,7 @@ static struct pgpath *alloc_pgpath(void)
 
 	if (pgpath) {
 		pgpath->is_active = true;
-		INIT_DELAYED_WORK(&pgpath->activate_path, activate_path);
+		INIT_DELAYED_WORK(&pgpath->activate_path, activate_path_work);
 	}
 
 	return pgpath;
@@ -1437,10 +1438,8 @@ static void pg_init_done(void *data, int errors)
 	spin_unlock_irqrestore(&m->lock, flags);
 }
 
-static void activate_path(struct work_struct *work)
+static void activate_or_offline_path(struct pgpath *pgpath)
 {
-	struct pgpath *pgpath =
-		container_of(work, struct pgpath, activate_path.work);
 	struct request_queue *q = bdev_get_queue(pgpath->path.dev->bdev);
 
 	if (pgpath->is_active && !blk_queue_dying(q))
@@ -1449,6 +1448,14 @@ static void activate_path(struct work_struct *work)
 		pg_init_done(pgpath, SCSI_DH_DEV_OFFLINED);
 }
 
+static void activate_path_work(struct work_struct *work)
+{
+	struct pgpath *pgpath =
+		container_of(work, struct pgpath, activate_path.work);
+
+	activate_or_offline_path(pgpath);
+}
+
 static int noretry_error(int error)
 {
 	switch (error) {
-- 
2.12.2
