From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/6] dm-stripe: drop kstriped
Date: Sun, 12 Dec 2010 20:10:50 +0100
Message-ID: <1292181055-25696-2-git-send-email-tj@kernel.org>
References: <1292181055-25696-1-git-send-email-tj@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1292181055-25696-1-git-send-email-tj@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, snitzer@redhat.com
Cc: Tejun Heo <tj@kernel.org>
List-Id: dm-devel.ids

kstriped only serves sc->kstriped_ws which runs dm_table_event().
This doesn't need to be executed from an ordered workqueue w/ rescuer.
Drop kstriped and use the system_wq instead.  While at it, rename
kstriped_ws to trigger_event so that it's consistent with other dm
modules.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
---
 drivers/md/dm-stripe.c |   25 ++++++-------------------
 1 files changed, 6 insertions(+), 19 deletions(-)

diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index f0371b4..f756ac1 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -39,23 +39,20 @@ struct stripe_c {
 	struct dm_target *ti;
 
 	/* Work struct used for triggering events*/
-	struct work_struct kstriped_ws;
+	struct work_struct trigger_event;
 
 	struct stripe stripe[0];
 };
 
-static struct workqueue_struct *kstriped;
-
 /*
  * An event is triggered whenever a drive
  * drops out of a stripe volume.
  */
 static void trigger_event(struct work_struct *work)
 {
-	struct stripe_c *sc = container_of(work, struct stripe_c, kstriped_ws);
-
+	struct stripe_c *sc = container_of(work, struct stripe_c,
+					   trigger_event);
 	dm_table_event(sc->ti->table);
-
 }
 
 static inline struct stripe_c *alloc_context(unsigned int stripes)
@@ -160,7 +157,7 @@ static int stripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		return -ENOMEM;
 	}
 
-	INIT_WORK(&sc->kstriped_ws, trigger_event);
+	INIT_WORK(&sc->trigger_event, trigger_event);
 
 	/* Set pointer to dm target; used in trigger_event */
 	sc->ti = ti;
@@ -211,7 +208,7 @@ static void stripe_dtr(struct dm_target *ti)
 	for (i = 0; i < sc->stripes; i++)
 		dm_put_device(ti, sc->stripe[i].dev);
 
-	flush_workqueue(kstriped);
+	flush_scheduled_work();
 	kfree(sc);
 }
 
@@ -367,7 +364,7 @@ static int stripe_end_io(struct dm_target *ti, struct bio *bio,
 			atomic_inc(&(sc->stripe[i].error_count));
 			if (atomic_read(&(sc->stripe[i].error_count)) <
 			    DM_IO_ERROR_THRESHOLD)
-				queue_work(kstriped, &sc->kstriped_ws);
+				schedule_work(&sc->trigger_event);
 		}
 
 	return error;
@@ -422,20 +419,10 @@ int __init dm_stripe_init(void)
 		return r;
 	}
 
-	kstriped = create_singlethread_workqueue("kstriped");
-	if (!kstriped) {
-		DMERR("failed to create workqueue kstriped");
-		dm_unregister_target(&stripe_target);
-		return -ENOMEM;
-	}
-
 	return r;
 }
 
 void dm_stripe_exit(void)
 {
 	dm_unregister_target(&stripe_target);
-	destroy_workqueue(kstriped);
-
-	return;
 }
-- 
1.7.1
