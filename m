From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/2]: optimize dm-raid1 memory consumption
Date: Wed, 4 Feb 2009 21:53:07 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0902042148070.8695@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

With my previous patch to save bio vector, the size of dm_raid1_read_record
is significantly increased (the vector list takes 3072 bytes on 32-bit machines
and 4096 bytes on 64-bit machines).

The structure dm_raid1_read_record used to be allocated with kmalloc,
but kmalloc aligns the size on the next power-of-two --- so an object
slightly greater than 4096 will allocate 8192 bytes of memory and half of
that memory will be wasted.

This patch turns kmalloc into a slab cache. Slab cache doesn't have this
padding, so it will reduce memory consumption per-request.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-raid1.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

Index: linux-2.6.29-rc3-devel/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.29-rc3-devel.orig/drivers/md/dm-raid1.c	2009-02-05 03:26:25.000000000 +0100
+++ linux-2.6.29-rc3-devel/drivers/md/dm-raid1.c	2009-02-05 03:33:54.000000000 +0100
@@ -145,6 +145,8 @@ struct dm_raid1_read_record {
 	struct dm_bio_details details;
 };
 
+static struct kmem_cache *_dm_raid1_read_record_cache;
+
 /*
  * Every mirror should look like this one.
  */
@@ -764,9 +766,8 @@ static struct mirror_set *alloc_context(
 	atomic_set(&ms->suspend, 0);
 	atomic_set(&ms->default_mirror, DEFAULT_MIRROR);
 
-	len = sizeof(struct dm_raid1_read_record);
-	ms->read_record_pool = mempool_create_kmalloc_pool(MIN_READ_RECORDS,
-							   len);
+	ms->read_record_pool = mempool_create_slab_pool(MIN_READ_RECORDS, _dm_raid1_read_record_cache);
+
 	if (!ms->read_record_pool) {
 		ti->error = "Error creating mirror read_record_pool";
 		kfree(ms);
@@ -1279,16 +1280,31 @@ static int __init dm_mirror_init(void)
 {
 	int r;
 
+	_dm_raid1_read_record_cache = KMEM_CACHE(dm_raid1_read_record, 0);
+	if (!_dm_raid1_read_record_cache) {
+		DMERR("Can't allocate dm_raid1_read_record cache");
+		r = -ENOMEM;
+		goto bad_cache;
+	}
+
 	r = dm_register_target(&mirror_target);
-	if (r < 0)
+	if (r < 0) {
 		DMERR("Failed to register mirror target");
+		goto bad_target;
+	}
+
+	return 0;
 
+bad_target:
+	kmem_cache_destroy(_dm_raid1_read_record_cache);
+bad_cache:
 	return r;
 }
 
 static void __exit dm_mirror_exit(void)
 {
 	dm_unregister_target(&mirror_target);
+	kmem_cache_destroy(_dm_raid1_read_record_cache);
 }
 
 /* Module hooks */
