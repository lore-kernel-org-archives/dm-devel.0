From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/2] dm-delay: fix a possible deadlock due to
 shared workqueue
Date: Fri, 15 Nov 2013 16:12:20 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1311151611230.28962@file01.intranet.prod.int.rdu2.redhat.com>
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

The dm-delay target uses a shared workqueue for multiple instances. This
can cause deadlock if two or more dm-delay targets are stacked on the top
of each other.

This patch changes dm-delay to use per-instance workqueue.
Cc: stable@kernel.org	# 2.6.22+

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-delay.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

Index: linux-3.12-fast/drivers/md/dm-delay.c
===================================================================
--- linux-3.12-fast.orig/drivers/md/dm-delay.c	2013-11-15 20:56:09.000000000 +0100
+++ linux-3.12-fast/drivers/md/dm-delay.c	2013-11-15 22:10:21.000000000 +0100
@@ -20,6 +20,7 @@
 struct delay_c {
 	struct timer_list delay_timer;
 	struct mutex timer_lock;
+	struct workqueue_struct *kdelayd_wq;
 	struct work_struct flush_expired_bios;
 	struct list_head delayed_bios;
 	atomic_t may_delay;
@@ -45,14 +46,13 @@ struct dm_delay_info {
 
 static DEFINE_MUTEX(delayed_bios_lock);
 
-static struct workqueue_struct *kdelayd_wq;
 static struct kmem_cache *delayed_cache;
 
 static void handle_delayed_timer(unsigned long data)
 {
 	struct delay_c *dc = (struct delay_c *)data;
 
-	queue_work(kdelayd_wq, &dc->flush_expired_bios);
+	queue_work(dc->kdelayd_wq, &dc->flush_expired_bios);
 }
 
 static void queue_timeout(struct delay_c *dc, unsigned long expires)
@@ -191,6 +191,12 @@ out:
 		goto bad_dev_write;
 	}
 
+	dc->kdelayd_wq = alloc_workqueue("kdelayd", WQ_MEM_RECLAIM, 0);
+	if (!dc->kdelayd_wq) {
+		DMERR("Couldn't start kdelayd");
+		goto bad_queue;
+	}
+
 	setup_timer(&dc->delay_timer, handle_delayed_timer, (unsigned long)dc);
 
 	INIT_WORK(&dc->flush_expired_bios, flush_expired_bios);
@@ -203,6 +209,8 @@ out:
 	ti->private = dc;
 	return 0;
 
+bad_queue:
+	mempool_destroy(dc->delayed_pool);
 bad_dev_write:
 	if (dc->dev_write)
 		dm_put_device(ti, dc->dev_write);
@@ -217,7 +225,7 @@ static void delay_dtr(struct dm_target *
 {
 	struct delay_c *dc = ti->private;
 
-	flush_workqueue(kdelayd_wq);
+	destroy_workqueue(dc->kdelayd_wq);
 
 	dm_put_device(ti, dc->dev_read);
 
@@ -350,12 +358,6 @@ static int __init dm_delay_init(void)
 {
 	int r = -ENOMEM;
 
-	kdelayd_wq = alloc_workqueue("kdelayd", WQ_MEM_RECLAIM, 0);
-	if (!kdelayd_wq) {
-		DMERR("Couldn't start kdelayd");
-		goto bad_queue;
-	}
-
 	delayed_cache = KMEM_CACHE(dm_delay_info, 0);
 	if (!delayed_cache) {
 		DMERR("Couldn't create delayed bio cache.");
@@ -373,8 +375,6 @@ static int __init dm_delay_init(void)
 bad_register:
 	kmem_cache_destroy(delayed_cache);
 bad_memcache:
-	destroy_workqueue(kdelayd_wq);
-bad_queue:
 	return r;
 }
 
@@ -382,7 +382,6 @@ static void __exit dm_delay_exit(void)
 {
 	dm_unregister_target(&delay_target);
 	kmem_cache_destroy(delayed_cache);
-	destroy_workqueue(kdelayd_wq);
 }
 
 /* Module hooks */
