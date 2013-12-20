From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-3.14 04/20] dm delay: use per-bio data
	instead of a mempool and slab cache
Date: Fri, 20 Dec 2013 18:37:17 -0500
Message-ID: <1387582653-13647-5-git-send-email-snitzer@redhat.com>
References: <1387582653-13647-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1387582653-13647-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

From: Mikulas Patocka <mpatocka@redhat.com>

Starting with commit c0820cf5ad095 ("dm: introduce per_bio_data"),
device mapper has the capability to pre-allocate a target-specific
structure with the bio.

This patch changes dm-delay to use this facility instead of a slab cache
and mempool.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-delay.c | 35 +++++++----------------------------
 1 file changed, 7 insertions(+), 28 deletions(-)

diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index 2f91d6d..a8a511c 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
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
@@ -87,13 +83,14 @@ static struct bio *flush_delayed_bios(struct delay_c *dc, int flush_all)
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
 
@@ -185,12 +182,6 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
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
@@ -232,7 +222,6 @@ static void delay_dtr(struct dm_target *ti)
 	if (dc->dev_write)
 		dm_put_device(ti, dc->dev_write);
 
-	mempool_destroy(dc->delayed_pool);
 	kfree(dc);
 }
 
@@ -244,10 +233,9 @@ static int delay_bio(struct delay_c *dc, int delay, struct bio *bio)
 	if (!delay || !atomic_read(&dc->may_delay))
 		return 1;
 
-	delayed = mempool_alloc(dc->delayed_pool, GFP_NOIO);
+	delayed = dm_per_bio_data(bio, sizeof(struct dm_delay_info));
 
 	delayed->context = dc;
-	delayed->bio = bio;
 	delayed->expires = expires = jiffies + (delay * HZ / 1000);
 
 	mutex_lock(&delayed_bios_lock);
@@ -356,13 +344,7 @@ static struct target_type delay_target = {
 
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
-- 
1.8.1.4
