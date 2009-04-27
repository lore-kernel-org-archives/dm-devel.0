From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 4/8] raid1 barriers
Date: Mon, 27 Apr 2009 07:47:14 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904270746210.18227@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0904270701250.12459@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904270743540.18227@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904270744220.18227@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904270745190.18227@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904270745510.18227@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0904270745510.18227@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Heinz Mauelshagen <heinzm@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Introduce a callback pointer from the log to dm-raid1 layer.

Before some region is set as "in-sync", we need to flush hardware cache on
all the disks. But the log module doesn't have access to the mirror_set
structure. So it will use this callback.

So far the callback is unused, it will be used in further patches.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-log.c            |    4 ++--
 drivers/md/dm-raid1.c          |    6 +++---
 drivers/md/dm-region-hash.c    |    8 ++++----
 include/linux/dm-dirty-log.h   |    4 ++--
 include/linux/dm-region-hash.h |    4 ++--
 5 files changed, 13 insertions(+), 13 deletions(-)

Index: linux-2.6.30-rc2-devel/drivers/md/dm-log.c
===================================================================
--- linux-2.6.30-rc2-devel.orig/drivers/md/dm-log.c	2009-04-27 12:37:15.000000000 +0200
+++ linux-2.6.30-rc2-devel/drivers/md/dm-log.c	2009-04-27 12:42:02.000000000 +0200
@@ -662,13 +662,13 @@ static int core_in_sync(struct dm_dirty_
 	return log_test_bit(lc->sync_bits, region);
 }
 
-static int core_flush(struct dm_dirty_log *log)
+static int core_flush(struct dm_dirty_log *log, int (*flush)(void *), void *cookie)
 {
 	/* no op */
 	return 0;
 }
 
-static int disk_flush(struct dm_dirty_log *log)
+static int disk_flush(struct dm_dirty_log *log, int (*flush)(void *), void *cookie)
 {
 	int r;
 	struct log_c *lc = (struct log_c *) log->context;
Index: linux-2.6.30-rc2-devel/include/linux/dm-dirty-log.h
===================================================================
--- linux-2.6.30-rc2-devel.orig/include/linux/dm-dirty-log.h	2009-04-27 12:37:15.000000000 +0200
+++ linux-2.6.30-rc2-devel/include/linux/dm-dirty-log.h	2009-04-27 12:42:02.000000000 +0200
@@ -40,7 +40,7 @@ struct dm_dirty_log_type {
 	 * the disk.
 	 */
 	int (*presuspend)(struct dm_dirty_log *log);
-	int (*postsuspend)(struct dm_dirty_log *log);
+	int (*postsuspend)(struct dm_dirty_log *log, int (*flush)(void *), void *cookie);
 	int (*resume)(struct dm_dirty_log *log);
 
 	/*
@@ -73,7 +73,7 @@ struct dm_dirty_log_type {
 	 * Flush the current log state (eg, to disk).  This
 	 * function may block.
 	 */
-	int (*flush)(struct dm_dirty_log *log);
+	int (*flush)(struct dm_dirty_log *log, int (*flush)(void *), void *cookie);
 
 	/*
 	 * Mark an area as clean or dirty.  These functions may
Index: linux-2.6.30-rc2-devel/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.30-rc2-devel.orig/drivers/md/dm-raid1.c	2009-04-27 12:37:15.000000000 +0200
+++ linux-2.6.30-rc2-devel/drivers/md/dm-raid1.c	2009-04-27 12:42:02.000000000 +0200
@@ -654,7 +654,7 @@ static void do_writes(struct mirror_set 
 	 */
 	dm_rh_inc_pending(ms->rh, &sync);
 	dm_rh_inc_pending(ms->rh, &nosync);
-	ms->log_failure = dm_rh_flush(ms->rh) ? 1 : 0;
+	ms->log_failure = dm_rh_flush(ms->rh, NULL, NULL) ? 1 : 0;
 
 	/*
 	 * Dispatch io.
@@ -755,7 +755,7 @@ static void do_mirror(struct work_struct
 	bio_list_init(&ms->failures);
 	spin_unlock_irqrestore(&ms->lock, flags);
 
-	dm_rh_update_states(ms->rh, errors_handled(ms));
+	dm_rh_update_states(ms->rh, errors_handled(ms), NULL, NULL);
 	do_recovery(ms);
 	do_reads(ms, &reads);
 	do_writes(ms, &writes);
@@ -1211,7 +1211,7 @@ static void mirror_postsuspend(struct dm
 	struct mirror_set *ms = ti->private;
 	struct dm_dirty_log *log = dm_rh_dirty_log(ms->rh);
 
-	if (log->type->postsuspend && log->type->postsuspend(log))
+	if (log->type->postsuspend && log->type->postsuspend(log, NULL, NULL))
 		/* FIXME: need better error handling */
 		DMWARN("log postsuspend failed");
 }
Index: linux-2.6.30-rc2-devel/drivers/md/dm-region-hash.c
===================================================================
--- linux-2.6.30-rc2-devel.orig/drivers/md/dm-region-hash.c	2009-04-27 12:37:15.000000000 +0200
+++ linux-2.6.30-rc2-devel/drivers/md/dm-region-hash.c	2009-04-27 12:42:02.000000000 +0200
@@ -443,7 +443,7 @@ void dm_rh_mark_nosync(struct dm_region_
 }
 EXPORT_SYMBOL_GPL(dm_rh_mark_nosync);
 
-void dm_rh_update_states(struct dm_region_hash *rh, int errors_handled)
+void dm_rh_update_states(struct dm_region_hash *rh, int errors_handled, int (*flush)(void *), void *cookie)
 {
 	struct dm_region *reg, *next;
 
@@ -502,7 +502,7 @@ void dm_rh_update_states(struct dm_regio
 		mempool_free(reg, rh->region_pool);
 	}
 
-	rh->log->type->flush(rh->log);
+	rh->log->type->flush(rh->log, flush, cookie);
 }
 EXPORT_SYMBOL_GPL(dm_rh_update_states);
 
@@ -692,9 +692,9 @@ int dm_rh_recovery_in_flight(struct dm_r
 }
 EXPORT_SYMBOL_GPL(dm_rh_recovery_in_flight);
 
-int dm_rh_flush(struct dm_region_hash *rh)
+int dm_rh_flush(struct dm_region_hash *rh, int (*flush)(void *), void *cookie)
 {
-	return rh->log->type->flush(rh->log);
+	return rh->log->type->flush(rh->log, flush, cookie);
 }
 EXPORT_SYMBOL_GPL(dm_rh_flush);
 
Index: linux-2.6.30-rc2-devel/include/linux/dm-region-hash.h
===================================================================
--- linux-2.6.30-rc2-devel.orig/include/linux/dm-region-hash.h	2009-04-27 12:37:15.000000000 +0200
+++ linux-2.6.30-rc2-devel/include/linux/dm-region-hash.h	2009-04-27 12:42:02.000000000 +0200
@@ -66,10 +66,10 @@ void dm_rh_set_state(struct dm_region_ha
 		     enum dm_rh_region_states state, int may_block);
 
 /* Non-zero errors_handled leaves the state of the region NOSYNC */
-void dm_rh_update_states(struct dm_region_hash *rh, int errors_handled);
+void dm_rh_update_states(struct dm_region_hash *rh, int errors_handled, int (*flush)(void *), void *cookie);
 
 /* Flush the region hash and dirty log. */
-int dm_rh_flush(struct dm_region_hash *rh);
+int dm_rh_flush(struct dm_region_hash *rh, int (*flush)(void *), void *cookie);
 
 /* Inc/dec pending count on regions. */
 void dm_rh_inc_pending(struct dm_region_hash *rh, struct bio_list *bios);
