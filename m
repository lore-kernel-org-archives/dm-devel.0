From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/6] dm: don't use flush_scheduled_work()
Date: Sun, 12 Dec 2010 20:10:53 +0100
Message-ID: <1292181055-25696-5-git-send-email-tj@kernel.org>
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

flush_scheduled_work() is being deprecated.  Flush the used work
directly instead.  In all dm modules, the only work which uses
system_wq is ->trigger_event.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
---
 drivers/md/dm-mpath.c  |    2 +-
 drivers/md/dm-raid1.c  |    2 +-
 drivers/md/dm-stripe.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 5765eb7..33255bd 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -931,7 +931,7 @@ static void flush_multipath_work(struct multipath *m)
 	flush_workqueue(kmpath_handlerd);
 	multipath_wait_for_pg_init_completion(m);
 	flush_workqueue(kmultipathd);
-	flush_scheduled_work();
+	flush_work_sync(&m->trigger_event);
 }
 
 static void multipath_dtr(struct dm_target *ti)
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index dbd6af8..5139091 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -1130,7 +1130,7 @@ static void mirror_dtr(struct dm_target *ti)
 
 	del_timer_sync(&ms->timer);
 	flush_workqueue(ms->kmirrord_wq);
-	flush_scheduled_work();
+	flush_work_sync(&ms->trigger_event);
 	dm_kcopyd_client_destroy(ms->kcopyd_client);
 	destroy_workqueue(ms->kmirrord_wq);
 	free_context(ms, ti, ms->nr_mirrors);
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index f756ac1..cf0693f 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -208,7 +208,7 @@ static void stripe_dtr(struct dm_target *ti)
 	for (i = 0; i < sc->stripes; i++)
 		dm_put_device(ti, sc->stripe[i].dev);
 
-	flush_scheduled_work();
+	flush_work_sync(&sc->trigger_event);
 	kfree(sc);
 }
 
-- 
1.7.1
