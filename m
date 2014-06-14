From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm: allocate a special workqueue for deferred
	remove
Date: Sat, 14 Jun 2014 13:44:31 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1406141344050.25628@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

The commit 2c140a246dc0bc085b98eddde978060fcec1080c introduced a deferred
removal feature for the device mapper. When this feature is used (by
passing a flag DM_DEFERRED_REMOVE to DM_DEV_REMOVE_CMD ioctl) and the user
tries to remove a device that is currently in use, the device will be
removed automatically in the future when the last user closes it.

Device mapper used the system workqueue to perform deferred removals.
However, some targets (dm-raid1, dm-mpath, dm-stripe) flush work items
scheduled for the system workqueue from their destructor. If the
destructor itself is called from the system workqueue during deferred
removal, it introduces a possible deadlock - the workqueue tries to flush
itself.

This patch fixes the possible deadlock by introducing a new workqueue for
deferred removals.

We allocate just one workqueue for all dm targets. The ability of dm
targets to process IOs isn't dependent on deferred removal of unused
targets, so a deadlock due to shared workqueue isn't possible.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# 3.13+

---
 drivers/md/dm.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

Index: linux-3.15/drivers/md/dm.c
===================================================================
--- linux-3.15.orig/drivers/md/dm.c	2014-06-14 17:04:05.000000000 +0200
+++ linux-3.15/drivers/md/dm.c	2014-06-14 17:12:38.000000000 +0200
@@ -54,6 +54,8 @@ static void do_deferred_remove(struct wo
 
 static DECLARE_WORK(deferred_remove_work, do_deferred_remove);
 
+static struct workqueue_struct *deferred_remove_workqueue;
+
 /*
  * For bio-based dm.
  * One of these is allocated per bio.
@@ -276,16 +278,22 @@ static int __init local_init(void)
 	if (r)
 		goto out_free_rq_tio_cache;
 
+	deferred_remove_workqueue = alloc_workqueue("kdmremove", WQ_UNBOUND, 1);
+	if (!deferred_remove_workqueue)
+		goto out_uevent_exit;
+
 	_major = major;
 	r = register_blkdev(_major, _name);
 	if (r < 0)
-		goto out_uevent_exit;
+		goto out_free_workqueue;
 
 	if (!_major)
 		_major = r;
 
 	return 0;
 
+out_free_workqueue:
+	destroy_workqueue(deferred_remove_workqueue);
 out_uevent_exit:
 	dm_uevent_exit();
 out_free_rq_tio_cache:
@@ -299,6 +307,7 @@ out_free_io_cache:
 static void local_exit(void)
 {
 	flush_scheduled_work();
+	destroy_workqueue(deferred_remove_workqueue);
 
 	kmem_cache_destroy(_rq_tio_cache);
 	kmem_cache_destroy(_io_cache);
@@ -407,7 +416,7 @@ static void dm_blk_close(struct gendisk 
 
 	if (atomic_dec_and_test(&md->open_count) &&
 	    (test_bit(DMF_DEFERRED_REMOVE, &md->flags)))
-		schedule_work(&deferred_remove_work);
+		queue_work(deferred_remove_workqueue, &deferred_remove_work);
 
 	dm_put(md);
 
