From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [Patch 3 of 14] Device Mapper Mirror
Date: Tue, 07 Nov 2006 10:00:52 -0600
Message-ID: <1162915252.17899.39.camel@hydrogen.msp.redhat.com>
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

All device-mapper targets must complete out-standing I/O before
suspending.  The mirror target produces its own I/O when in the
recovery phase.  This recovery I/O must be tracked so we can
ensure that it has completed before we suspend.
Index: linux-2.6.18.1/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.18.1.orig/drivers/md/dm-raid1.c	2006-10-25 11:36:14.000000000 -0500
+++ linux-2.6.18.1/drivers/md/dm-raid1.c	2006-10-25 11:36:23.000000000 -0500
@@ -24,6 +24,7 @@
 
 static struct workqueue_struct *_kmirrord_wq;
 static struct work_struct _kmirrord_work;
+DECLARE_WAIT_QUEUE_HEAD(recovery_stopped_event);
 
 static inline void wake(void)
 {
@@ -83,6 +84,7 @@ struct region_hash {
 	struct list_head *buckets;
 
 	spinlock_t region_lock;
+	atomic_t recovery_in_flight;
 	struct semaphore recovery_count;
 	struct list_head clean_regions;
 	struct list_head quiesced_regions;
@@ -191,6 +193,7 @@ static int rh_init(struct region_hash *r
 
 	spin_lock_init(&rh->region_lock);
 	sema_init(&rh->recovery_count, 0);
+	atomic_set(&rh->recovery_in_flight, 0);
 	INIT_LIST_HEAD(&rh->clean_regions);
 	INIT_LIST_HEAD(&rh->quiesced_regions);
 	INIT_LIST_HEAD(&rh->recovered_regions);
@@ -346,6 +349,8 @@ static void complete_resync_work(struct 
 	struct region_hash *rh = reg->rh;
 
 	rh->log->type->set_region_sync(rh->log, reg->key, success);
+	if (atomic_dec_and_test(&rh->recovery_in_flight))
+		wake_up_all(&recovery_stopped_event);
 	dispatch_bios(rh->ms, &reg->delayed_bios);
 	up(&rh->recovery_count);
 }
@@ -509,11 +514,21 @@ static int __rh_recovery_prepare(struct 
 
 static void rh_recovery_prepare(struct region_hash *rh)
 {
-	while (!down_trylock(&rh->recovery_count))
+	/* Extra reference to avoid race with rh_stop_recovery */
+	atomic_inc(&rh->recovery_in_flight);
+
+	while (!down_trylock(&rh->recovery_count)) {
+		atomic_inc(&rh->recovery_in_flight);
 		if (__rh_recovery_prepare(rh) <= 0) {
+			atomic_dec(&rh->recovery_in_flight);
 			up(&rh->recovery_count);
 			break;
 		}
+	}
+
+	/* Drop the extra reference */
+	if (atomic_dec_and_test(&rh->recovery_in_flight))
+		wake_up_all(&recovery_stopped_event);
 }
 
 /*
@@ -1184,6 +1199,11 @@ static void mirror_postsuspend(struct dm
 	struct dirty_log *log = ms->rh.log;
 
 	rh_stop_recovery(&ms->rh);
+
+	/* Wait for all I/O we generated to complete */
+	wait_event(recovery_stopped_event,
+		   !atomic_read(&ms->rh.recovery_in_flight));
+
 	if (log->type->suspend && log->type->suspend(log))
 		/* FIXME: need better error handling */
 		DMWARN("log suspend failed");
