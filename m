From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/2] dm-delay: use per-bio data instead of a
 mempool and slab cache
Date: Fri, 15 Nov 2013 16:12:51 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1311151612260.28962@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1311151611230.28962@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1311151611230.28962@file01.intranet.prod.int.rdu2.redhat.com>
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

Starting with commit c0820cf5ad09522bdd9ff68e84841a09c9f339d8, device
mapper has capability to pre-allocate target-specific structure with the
bio.

This patch changes dm-delay to use this facility instead of a slab cache
and mempool.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-delay.c |   35 +++++++----------------------------
 1 file changed, 7 insertions(+), 28 deletions(-)

Index: linux-3.12-fast/drivers/md/dm-delay.c
===================================================================
--- linux-3.12-fast.orig/drivers/md/dm-delay.c	2013-11-15 22:10:21.000000000 +0100
+++ linux-3.12-fast/drivers/md/dm-delay.c	2013-11-15 22:10:27.000000000 +0100
@@ -24,7 +24,6 @@ struct delay_c {
 	struct work_struct flush_expired_bios;
 	struct list_head delayed_bios;
 	atomic_t may_delay;
-	mempool_t *delayed_pool;
 
 	struct dm_dev *dev_read;
 	sector_t start_read;
@@ -40,14 +39,11 @@ struct delay_c {
 struct dm_delay_info {
 	struct delay_c *context;
 	struct list_head list;
-	struct bio *bio;
 	unsigned long expires;
 };
 
 static DEFINE_MUTEX(delayed_bios_lock);
 
-static struct kmem_cache *delayed_cache;
-
 static void handle_delayed_timer(unsigned long data)
 {
 	struct delay_c *dc = (struct delay_c *)data;
@@ -87,13 +83,14 @@ static struct bio *flush_delayed_bios(st
 	mutex_lock(&delayed_bios_lock);
 	list_for_each_entry_safe(delayed, next, &dc->delayed_bios, list) {
 		if (flush_all || time_after_eq(jiffies, delayed->expires)) {
+			struct bio *bio = dm_bio_from_per_bio_data(delayed,
+						sizeof(struct dm_delay_info));
 			list_del(&delayed->list);
-			bio_list_add(&flush_bios, delayed->bio);
-			if ((bio_data_dir(delayed->bio) == WRITE))
+			bio_list_add(&flush_bios, bio);
+			if ((bio_data_dir(bio) == WRITE))
 				delayed->context->writes--;
 			else
 				delayed->context->reads--;
-			mempool_free(delayed, dc->delayed_pool);
 			continue;
 		}
 
@@ -185,12 +182,6 @@ static int delay_ctr(struct dm_target *t
 	}
 
 out:
-	dc->delayed_pool = mempool_create_slab_pool(128, delayed_cache);
-	if (!dc->delayed_pool) {
-		DMERR("Couldn't create delayed bio pool.");
-		goto bad_dev_write;
-	}
-
 	dc->kdelayd_wq = alloc_workqueue("kdelayd", WQ_MEM_RECLAIM, 0);
 	if (!dc->kdelayd_wq) {
 		DMERR("Couldn't start kdelayd");
@@ -206,12 +197,11 @@ out:
 
 	ti->num_flush_bios = 1;
 	ti->num_discard_bios = 1;
+	ti->per_bio_data_size = sizeof(struct dm_delay_info);
 	ti->private = dc;
 	return 0;
 
 bad_queue:
-	mempool_destroy(dc->delayed_pool);
-bad_dev_write:
 	if (dc->dev_write)
 		dm_put_device(ti, dc->dev_write);
 bad_dev_read:
@@ -232,7 +222,6 @@ static void delay_dtr(struct dm_target *
 	if (dc->dev_write)
 		dm_put_device(ti, dc->dev_write);
 
-	mempool_destroy(dc->delayed_pool);
 	kfree(dc);
 }
 
@@ -244,10 +233,9 @@ static int delay_bio(struct delay_c *dc,
 	if (!delay || !atomic_read(&dc->may_delay))
 		return 1;
 
-	delayed = mempool_alloc(dc->delayed_pool, GFP_NOIO);
+	delayed = dm_per_bio_data(bio, sizeof(struct dm_delay_info));
 
 	delayed->context = dc;
-	delayed->bio = bio;
 	delayed->expires = expires = jiffies + (delay * HZ / 1000);
 
 	mutex_lock(&delayed_bios_lock);
@@ -356,13 +344,7 @@ static struct target_type delay_target =
 
 static int __init dm_delay_init(void)
 {
-	int r = -ENOMEM;
-
-	delayed_cache = KMEM_CACHE(dm_delay_info, 0);
-	if (!delayed_cache) {
-		DMERR("Couldn't create delayed bio cache.");
-		goto bad_memcache;
-	}
+	int r;
 
 	r = dm_register_target(&delay_target);
 	if (r < 0) {
@@ -373,15 +355,12 @@ static int __init dm_delay_init(void)
 	return 0;
 
 bad_register:
-	kmem_cache_destroy(delayed_cache);
-bad_memcache:
 	return r;
 }
 
 static void __exit dm_delay_exit(void)
 {
 	dm_unregister_target(&delay_target);
-	kmem_cache_destroy(delayed_cache);
 }
 
 /* Module hooks */
