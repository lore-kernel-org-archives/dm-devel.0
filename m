From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [Patch 12 of 14] Device Mapper Mirror
Date: Tue, 07 Nov 2006 10:06:53 -0600
Message-ID: <1162915613.17899.58.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: heinzm@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

 brassow

This patch gives the mirroring code the ability to work properly
with a log that is cluster-aware.

One of the main features of mirroring is that does an initial
resync of all regions known to be 'out-of-sync'.  While it is
resync'ing a region, it must defer write I/O until the region
is resync'ed.

In a cluster, multiple machines may be doing recovery.  So, we
must also defer writes to regions that are being recovered on
a remote machine.  We've added a new logging function,
'is_remote_recovering', to determine if the log has assigned
recovery work to a remote machine.  If a write takes place to
a region that is being recovered remotely, we requeue the bio
- effectively deferring it until the region is no longer being
recovered.

One situation that is handled implicitly, but is worth mentioning,
is the handling of write failures in a cluster.  Imagine the
scenario:
0) mirror is in-sync
1) Node1 writes to disk, but write fails to the primary device
2) Node1 increments the error count for that device
3) Node1 checks ms->in_sync to see if it is safe to switch the
   primary.  (We cannot switch the primary if other devices are
   not in-sync.  This would lead to bad data being read.)
4) Node1 switches the primary because the mirror is in-sync, then
   marks the region out-of-sync and ms->in_sync = 0.
5) Node2 writes and fails to the primary device
6) It follows suit with Node1 in switching the primary and marking
   it's region out-of-sync then marking the ms->in_sync = 0

The above works because 'ms->in_sync' is changed to 0 only after
calling fail_mirror (which switches the primary).  If we relied on
log->type->get_sync_count instead of ms->in_sync, or we altered
ms->in_sync as soon as the sync_count changed to < nr_regions; then
the above solution would not work.  This is because the second node
would not be able to switch primaries because it would think the
mirror was out-of-sync during the failure.  Therefore, it is important
to preserve the way ms->in_sync gets set and unset in future patches.
Index: linux-2.6.18.1/drivers/md/dm-log.h
===================================================================
--- linux-2.6.18.1.orig/drivers/md/dm-log.h	2006-11-06 17:00:38.000000000 -0600
+++ linux-2.6.18.1/drivers/md/dm-log.h	2006-11-06 17:00:49.000000000 -0600
@@ -23,6 +23,7 @@ struct dirty_log_type {
 	const char *name;
 	struct module *module;
 	unsigned int use_count;
+	unsigned int flags;
 
 	int (*ctr)(struct dirty_log *log, struct dm_target *ti,
 		   unsigned int argc, char **argv);
@@ -107,6 +108,16 @@ struct dirty_log_type {
 	 */
 	int (*status)(struct dirty_log *log, status_type_t status_type,
 		      char *result, unsigned int maxlen);
+
+	/*
+	 * Returns: 0, 1
+	 *
+	 * This is necessary for cluster mirroring. It provides
+	 * a way to detect recovery on another node, so we
+	 * aren't writing concurrently.  This function is likely
+	 * to block (when a cluster log is used).
+	 */
+	int (*is_remote_recovering)(struct dirty_log *log, region_t region);
 };
 
 int dm_register_dirty_log_type(struct dirty_log_type *type);
Index: linux-2.6.18.1/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.18.1.orig/drivers/md/dm-raid1.c	2006-11-06 17:00:38.000000000 -0600
+++ linux-2.6.18.1/drivers/md/dm-raid1.c	2006-11-06 17:00:49.000000000 -0600
@@ -804,6 +804,8 @@ static struct mirror *choose_mirror(stru
  * if this is the default mirror device (i.e. the primary
  * device) and the mirror set is in-sync, choose an
  * alternate primary device.
+ *
+ * This function cannot block.
  */
 static void fail_mirror(struct mirror *m)
 {
@@ -822,7 +824,9 @@ static void fail_mirror(struct mirror *m
 	if (m != ms->default_mirror)
 		return;
 
-	/* If the default mirror fails, change it. */
+	/*
+	 * If the default mirror fails, change it.
+	 */
 	if (!ms->in_sync) {
 		/*
 		 * Can not switch primary.  Better to issue requests
@@ -1093,6 +1097,9 @@ static void do_writes(struct mirror_set 
 	int state, r;
 	struct bio *bio;
 	struct bio_list sync, nosync, recover, *this_list = NULL;
+	struct bio_list requeue;
+	struct dirty_log *log = ms->rh.log;
+	region_t region;
 
 	if (!writes->head)
 		return;
@@ -1103,9 +1110,18 @@ static void do_writes(struct mirror_set 
 	bio_list_init(&sync);
 	bio_list_init(&nosync);
 	bio_list_init(&recover);
+	bio_list_init(&requeue);
 
 	while ((bio = bio_list_pop(writes))) {
-		state = rh_state(&ms->rh, bio_to_region(&ms->rh, bio), 1);
+		region = bio_to_region(&ms->rh, bio);
+
+		if (log->type->is_remote_recovering &&
+		    log->type->is_remote_recovering(log, region)) {
+			bio_list_add(&requeue, bio);
+			continue;
+		}
+
+		state = rh_state(&ms->rh, region, 1);
 		switch (state) {
 		case RH_CLEAN:
 		case RH_DIRTY:
@@ -1125,6 +1141,17 @@ static void do_writes(struct mirror_set 
 	}
 
 	/*
+	 * Add bios that are delayed due to remote recovery
+	 * back on to the write queue
+	 */
+	if (requeue.head) {
+		spin_lock_irq(&ms->lock);
+		bio_list_merge(&ms->writes, &requeue);
+		spin_unlock_irq(&ms->lock);
+		wake();
+	}
+
+	/*
 	 * Increment the pending counts for any regions that will
 	 * be written to (writes to recover regions are going to
 	 * be delayed).
