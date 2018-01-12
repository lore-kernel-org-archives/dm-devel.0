From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-4.16 PATCH v5 4/4] dm: fix incomplete request_queue initialization
Date: Fri, 12 Jan 2018 10:06:06 -0500
Message-ID: <20180112150606.6037-5-snitzer@redhat.com>
References: <20180112150606.6037-1-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180112150606.6037-1-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: Ming Lei <tom.leiming@gmail.com>, hare@suse.de, Bart.VanAssche@wdc.com, David Jeffery <djeffery@redhat.com>, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

DM is no longer prone to having its request_queue be improperly
initialized.

Summary of changes:

- defer DM's blk_register_queue() from add_disk()-time until
  dm_setup_md_queue() by using add_disk_no_queue_reg() in alloc_dev().

- dm_setup_md_queue() is updated to fully initialize DM's request_queue
  (_after_ all table loads have occurred and the request_queue's type,
  features and limits are known).

A very welcome side-effect of these changes is DM no longer needs to:
1) backfill the "mq" sysfs entry (because historically DM didn't
initialize the request_queue to use blk-mq until _after_
blk_register_queue() was called via add_disk()).
2) call elv_register_queue() to get .request_fn request-based DM
device's "iosched" exposed in syfs.

In addition, blk-mq debugfs support is now made available because
request-based DM's blk-mq request_queue is now properly initialized
before dm_setup_md_queue() calls blk_register_queue().

These changes also stave off the need to introduce new DM-specific
workarounds in block core, e.g. this proposal:
https://patchwork.kernel.org/patch/10067961/

In the end DM devices should be less unicorn in nature (relative to
initialization and availability of block core infrastructure provided by
the request_queue).

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Tested-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/md/dm-rq.c |  9 ---------
 drivers/md/dm.c    | 11 ++++++++++-
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 9d32f25489c2..c28357f5cb0e 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -713,8 +713,6 @@ int dm_old_init_request_queue(struct mapped_device *md, struct dm_table *t)
 		return error;
 	}
 
-	elv_register_queue(md->queue);
-
 	return 0;
 }
 
@@ -812,15 +810,8 @@ int dm_mq_init_request_queue(struct mapped_device *md, struct dm_table *t)
 	}
 	dm_init_md_queue(md);
 
-	/* backfill 'mq' sysfs registration normally done in blk_register_queue */
-	err = blk_mq_register_dev(disk_to_dev(md->disk), q);
-	if (err)
-		goto out_cleanup_queue;
-
 	return 0;
 
-out_cleanup_queue:
-	blk_cleanup_queue(q);
 out_tag_set:
 	blk_mq_free_tag_set(md->tag_set);
 out_kfree_tag_set:
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 7475739fee49..8c26bfc35335 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1761,7 +1761,7 @@ static struct mapped_device *alloc_dev(int minor)
 		goto bad;
 	md->dax_dev = dax_dev;
 
-	add_disk(md->disk);
+	add_disk_no_queue_reg(md->disk);
 	format_dev_t(md->name, MKDEV(_major, minor));
 
 	md->wq = alloc_workqueue("kdmflush", WQ_MEM_RECLAIM, 0);
@@ -2021,6 +2021,7 @@ EXPORT_SYMBOL_GPL(dm_get_queue_limits);
 int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
 {
 	int r;
+	struct queue_limits limits;
 	enum dm_queue_mode type = dm_get_md_type(md);
 
 	switch (type) {
@@ -2057,6 +2058,14 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
 		break;
 	}
 
+	r = dm_calculate_queue_limits(t, &limits);
+	if (r) {
+		DMERR("Cannot calculate initial queue limits");
+		return r;
+	}
+	dm_table_set_restrictions(t, md->queue, &limits);
+	blk_register_queue(md->disk);
+
 	return 0;
 }
 
-- 
2.15.0
