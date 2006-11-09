From: akpm@osdl.org
Subject: [patch 09/24] dm: raid1: fix waiting for io on suspend
Date: Wed, 08 Nov 2006 17:44:44 -0800
Message-ID: <200611090144.kA91iiTM000705@shell0.pdx.osdl.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: torvalds@osdl.org
Cc: akpm@osdl.org, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

From: Jonathan E Brassow <jbrassow@redhat.com>

All device-mapper targets must complete outstanding I/O before suspending. 
The mirror target generates I/O in its recovery phase and fails to wait for
it.  It needs to be tracked so we can ensure that it has completed before we
suspend.

[akpm@osdl.org: cleanup]
Signed-off-by: Jonathan E Brassow <jbrassow@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: <dm-devel@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/dm-raid1.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff -puN drivers/md/dm-raid1.c~dm-raid1-fix-waiting-for-io-on-suspend drivers/md/dm-raid1.c
--- a/drivers/md/dm-raid1.c~dm-raid1-fix-waiting-for-io-on-suspend
+++ a/drivers/md/dm-raid1.c
@@ -24,6 +24,7 @@
 
 static struct workqueue_struct *_kmirrord_wq;
 static struct work_struct _kmirrord_work;
+static DECLARE_WAIT_QUEUE_HEAD(_kmirrord_recovery_stopped);
 
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
@@ -382,6 +385,8 @@ static void rh_update_states(struct regi
 		rh->log->type->clear_region(rh->log, reg->key);
 		rh->log->type->complete_resync_work(rh->log, reg->key, 1);
 		dispatch_bios(rh->ms, &reg->delayed_bios);
+		if (atomic_dec_and_test(&rh->recovery_in_flight))
+			wake_up_all(&_kmirrord_recovery_stopped);
 		up(&rh->recovery_count);
 		mempool_free(reg, rh->region_pool);
 	}
@@ -502,11 +507,21 @@ static int __rh_recovery_prepare(struct 
 
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
+		wake_up_all(&_kmirrord_recovery_stopped);
 }
 
 /*
@@ -1177,6 +1192,11 @@ static void mirror_postsuspend(struct dm
 	struct dirty_log *log = ms->rh.log;
 
 	rh_stop_recovery(&ms->rh);
+
+	/* Wait for all I/O we generated to complete */
+	wait_event(_kmirrord_recovery_stopped,
+		   !atomic_read(&ms->rh.recovery_in_flight));
+
 	if (log->type->suspend && log->type->suspend(log))
 		/* FIXME: need better error handling */
 		DMWARN("log suspend failed");
_
