From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-3.14 17/20] dm thin: fix set_pool_mode exposed pool operation races
Date: Fri, 20 Dec 2013 18:37:30 -0500
Message-ID: <1387582653-13647-18-git-send-email-snitzer@redhat.com>
References: <1387582653-13647-1-git-send-email-snitzer@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1387582653-13647-1-git-send-email-snitzer@redhat.com>
Sender: stable-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: stable@vger.kernel.org
List-Id: dm-devel.ids

The pool mode must not be switched until after the corresponding pool
process_* methods have been established.  Otherwise, because
set_pool_mode() isn't interlocked with the IO path for performance
reasons, the IO path can end up executing process_* operations that
don't match the mode.  This patch eliminates problems like the following
(as seen on really fast PCIe SSD storage when transitioning the pool's
mode from PM_READ_ONLY to PM_WRITE):

kernel: device-mapper: thin: 253:2: reached low water mark for data device: sending event.
kernel: device-mapper: thin: 253:2: no free data space available.
kernel: device-mapper: thin: 253:2: switching pool to read-only mode
kernel: device-mapper: thin: 253:2: switching pool to write mode
kernel: ------------[ cut here ]------------
kernel: WARNING: CPU: 11 PID: 7564 at drivers/md/dm-thin.c:995 handle_unserviceable_bio+0x146/0x160 [dm_thin_pool]()
...
kernel: Workqueue: dm-thin do_worker [dm_thin_pool]
kernel: 00000000000003e3 ffff880308831cc8 ffffffff8152ebcb 00000000000003e3
kernel: 0000000000000000 ffff880308831d08 ffffffff8104c46c ffff88032502a800
kernel: ffff880036409000 ffff88030ec7ce00 0000000000000001 00000000ffffffc3
kernel: Call Trace:
kernel: [<ffffffff8152ebcb>] dump_stack+0x49/0x5e
kernel: [<ffffffff8104c46c>] warn_slowpath_common+0x8c/0xc0
kernel: [<ffffffff8104c4ba>] warn_slowpath_null+0x1a/0x20
kernel: [<ffffffffa001e2c6>] handle_unserviceable_bio+0x146/0x160 [dm_thin_pool]
kernel: [<ffffffffa001f276>] process_bio_read_only+0x136/0x180 [dm_thin_pool]
kernel: [<ffffffffa0020b75>] process_deferred_bios+0xc5/0x230 [dm_thin_pool]
kernel: [<ffffffffa0020d31>] do_worker+0x51/0x60 [dm_thin_pool]
kernel: [<ffffffff81067823>] process_one_work+0x183/0x490
kernel: [<ffffffff81068c70>] worker_thread+0x120/0x3a0
kernel: [<ffffffff81068b50>] ? manage_workers+0x160/0x160
kernel: [<ffffffff8106e86e>] kthread+0xce/0xf0
kernel: [<ffffffff8106e7a0>] ? kthread_freezable_should_stop+0x70/0x70
kernel: [<ffffffff8153b3ec>] ret_from_fork+0x7c/0xb0
kernel: [<ffffffff8106e7a0>] ? kthread_freezable_should_stop+0x70/0x70
kernel: ---[ end trace 3f00528e08ffa55c ]---
kernel: device-mapper: thin: pool mode is PM_WRITE not PM_READ_ONLY like expected!?

dm-thin.c:995 was the WARN_ON_ONCE(get_pool_mode(pool) != PM_READ_ONLY);
at the top of handle_unserviceable_bio().  And as the additional
debugging I had conveys: the pool mode was _not_ PM_READ_ONLY like
expected, it was already PM_WRITE, yet pool->process_bio was still set
to process_bio_read_only().

Also, while fixing this up, reduce logging of redundant pool mode
transitions by checking new_mode is different from old_mode.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: stable@vger.kernel.org
---
 drivers/md/dm-thin.c | 40 +++++++++++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index bfae790..4a2432a 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1396,16 +1396,16 @@ static enum pool_mode get_pool_mode(struct pool *pool)
 	return pool->pf.mode;
 }
 
-static void set_pool_mode(struct pool *pool, enum pool_mode mode)
+static void set_pool_mode(struct pool *pool, enum pool_mode new_mode)
 {
 	int r;
+	enum pool_mode old_mode = pool->pf.mode;
 
-	pool->pf.mode = mode;
-
-	switch (mode) {
+	switch (new_mode) {
 	case PM_FAIL:
-		DMERR("%s: switching pool to failure mode",
-		      dm_device_name(pool->pool_md));
+		if (old_mode != new_mode)
+			DMERR("%s: switching pool to failure mode",
+			      dm_device_name(pool->pool_md));
 		dm_pool_metadata_read_only(pool->pmd);
 		pool->process_bio = process_bio_fail;
 		pool->process_discard = process_bio_fail;
@@ -1414,13 +1414,15 @@ static void set_pool_mode(struct pool *pool, enum pool_mode mode)
 		break;
 
 	case PM_READ_ONLY:
-		DMERR("%s: switching pool to read-only mode",
-		      dm_device_name(pool->pool_md));
+		if (old_mode != new_mode)
+			DMERR("%s: switching pool to read-only mode",
+			      dm_device_name(pool->pool_md));
 		r = dm_pool_abort_metadata(pool->pmd);
 		if (r) {
 			DMERR("%s: aborting transaction failed",
 			      dm_device_name(pool->pool_md));
-			set_pool_mode(pool, PM_FAIL);
+			new_mode = PM_FAIL;
+			set_pool_mode(pool, new_mode);
 		} else {
 			dm_pool_metadata_read_only(pool->pmd);
 			pool->process_bio = process_bio_read_only;
@@ -1431,6 +1433,9 @@ static void set_pool_mode(struct pool *pool, enum pool_mode mode)
 		break;
 
 	case PM_WRITE:
+		if (old_mode != new_mode)
+			DMINFO("%s: switching pool to write mode",
+			       dm_device_name(pool->pool_md));
 		dm_pool_metadata_read_write(pool->pmd);
 		pool->process_bio = process_bio;
 		pool->process_discard = process_discard;
@@ -1438,6 +1443,8 @@ static void set_pool_mode(struct pool *pool, enum pool_mode mode)
 		pool->process_prepared_discard = process_prepared_discard;
 		break;
 	}
+
+	pool->pf.mode = new_mode;
 }
 
 /*
@@ -1681,6 +1688,17 @@ static int bind_control_target(struct pool *pool, struct dm_target *ti)
 	enum pool_mode new_mode = pt->adjusted_pf.mode;
 
 	/*
+	 * Don't change the pool's mode until set_pool_mode() below.
+	 * Otherwise the pool's process_* function pointers may
+	 * not match the desired pool mode.
+	 */
+	pt->adjusted_pf.mode = old_mode;
+
+	pool->ti = ti;
+	pool->pf = pt->adjusted_pf;
+	pool->low_water_blocks = pt->low_water_blocks;
+
+	/*
 	 * If we were in PM_FAIL mode, rollback of metadata failed.  We're
 	 * not going to recover without a thin_repair.  So we never let the
 	 * pool move out of the old mode.  On the other hand a PM_READ_ONLY
@@ -1690,10 +1708,6 @@ static int bind_control_target(struct pool *pool, struct dm_target *ti)
 	if (old_mode == PM_FAIL)
 		new_mode = old_mode;
 
-	pool->ti = ti;
-	pool->low_water_blocks = pt->low_water_blocks;
-	pool->pf = pt->adjusted_pf;
-
 	set_pool_mode(pool, new_mode);
 
 	return 0;
-- 
1.8.1.4
