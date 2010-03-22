From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: shared snapshots release 17
Date: Mon, 22 Mar 2010 16:54:34 -0400
Message-ID: <20100322205433.GB13346@redhat.com>
References: <Pine.LNX.4.64.1003221513150.15382@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1003221513150.15382@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Mar 22 2010 at  3:18pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Hi
> 
> New shared snapshots are here. It incorporates Mike's changes and it has 
> reworked memory limit:
> - a minimum of 8 buffers is guaranteed to prevent thrasing with too big 
> chunk sizes
> - the cache for multisnapshots is limited to 2% of memory or 25% of 
> vmalloc memory (whichever is lower) [ I'm thinking about making this 
> configurable in /proc ]
> - big chunk sizes (8MB or more) allocate memory always from vmalloc, there 
> is no point in allocating from general allocator

For the benefit of others, here are your r17 changes relative to r16.  I
have some early questions/comments:

- What is going on with EXPORT_SYMBOL at the top of drivers/md/dm-bufio.c?  
  Do you intend to have a standalone dm-bufio module?  I think it makes
  sense to go one way or another.  As is you're in limbo; the name of
  the _init and _exit functions don't _really_ make sense given that it
  isn't a standalone module (e.g. dm_bufio_module_init).  Makes the
  calling code in dm-multisnap-mikulas.c somewhat awkward (calling
  another _{module_init,exit}).  Especially when you consider
  dm_bufio_module_exit() doesn't do anything; yet you've reworked
  dm_multisnapshot_mikulas_module_init() to call it.

- Please don't introduce long lines as you make new changes.  Below, the
  following functions have unnecessarily long lines:
  get_memory_limit, dm_bufio_alloc_buffer_data, dm_bufio_module_init

- The empty newline between comment blocks and functions should be
  removed, see: get_memory_limit, adjust_client_count, dm_bufio_module_exit


diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 44dbb0e..1958b97 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -13,6 +13,10 @@
 
 #include "dm-bufio.h"
 
+/* This will be enabled if this becomes a module or a part of another module */
+#undef EXPORT_SYMBOL
+#define EXPORT_SYMBOL(x)
+
 /*
  * dm_bufio_client_create --- create a buffered IO cache on a given device
  * dm_bufio_client_destroy --- release a buffered IO cache
@@ -51,16 +55,17 @@
 
 /*
  * Memory management policy:
- *	When we're above threshold, start asynchronous writing of dirty buffers
- *	and memory reclaiming --- but still allow new allocations.
- *	When we're above limit, don't allocate any more space and synchronously
- *	wait until existing buffers are freed.
- *
- * These default parameters can be overriden with parameters to
- * dm_bufio_client_create.
+ *	Limit the number of buffers to DM_BUFIO_MEMORY_RATIO of main memory or
+ *	DM_BUFIO_VMALLOC_RATIO of vmalloc memory (whichever is lower).
+ *	Always allocate at least DM_BUFIO_MIN_BUFFERS buffers.
+ *	When there are DM_BUFIO_WRITEBACK_RATIO dirty buffers, start background
+ *	writeback.
  */
-#define DM_BUFIO_THRESHOLD_MEMORY	(8 * 1048576)
-#define DM_BUFIO_LIMIT_MEMORY		(9 * 1048576)
+
+#define DM_BUFIO_MIN_BUFFERS		8
+#define DM_BUFIO_MEMORY_RATIO		2 / 100
+#define DM_BUFIO_VMALLOC_RATIO		1 / 4
+#define DM_BUFIO_WRITEBACK_RATIO	3 / 4
 
 /*
  * The number of bvec entries that are embedded directly in the buffer.
@@ -78,7 +83,8 @@
  * Don't try to kmalloc blocks larger than this.
  * For explanation, see dm_bufio_alloc_buffer_data below.
  */
-#define DM_BUFIO_BLOCK_SIZE_KMALLOC_LIMIT	PAGE_SIZE
+#define DM_BUFIO_BLOCK_SIZE_KMALLOC_LIMIT	(PAGE_SIZE >> 1)
+#define DM_BUFIO_BLOCK_SIZE_GFP_LIMIT		(PAGE_SIZE << (MAX_ORDER - 1))
 
 /*
  * Buffer state bits.
@@ -110,8 +116,6 @@ struct dm_bufio_client {
 	unsigned char pages_per_block_bits;
 
 	unsigned long n_buffers;
-	unsigned threshold_buffers;
-	unsigned limit_buffers;
 
 	struct dm_io_client *dm_io;
 
@@ -146,6 +150,40 @@ struct dm_buffer {
 	struct bio_vec bio_vec[DM_BUFIO_INLINE_VECS];
 };
 
+static unsigned long dm_bufio_avail_mem;
+static unsigned long dm_bufio_avail_mem_per_client;
+static int dm_bufio_client_count;
+static DEFINE_MUTEX(dm_bufio_clients_lock);
+
+/*
+ * Change the number of clients and recalculate per-client limit.
+ */
+
+static void adjust_client_count(int diff)
+{
+	mutex_lock(&dm_bufio_clients_lock);
+	dm_bufio_client_count += diff;
+	BUG_ON(dm_bufio_client_count < 0);
+	dm_bufio_avail_mem_per_client = dm_bufio_avail_mem /
+		(dm_bufio_client_count ? dm_bufio_client_count : 1);
+	mutex_unlock(&dm_bufio_clients_lock);
+}
+
+/*
+ * Get writeback threshold and buffer limit for a given client.
+ */
+
+static void get_memory_limit(struct dm_bufio_client *c,
+			     unsigned long *threshold_buffers,
+			     unsigned long *limit_buffers)
+{
+	unsigned long buffers = dm_bufio_avail_mem_per_client >> (c->sectors_per_block_bits + SECTOR_SHIFT);
+	if (unlikely(buffers < DM_BUFIO_MIN_BUFFERS))
+		buffers = DM_BUFIO_MIN_BUFFERS;
+	*limit_buffers = buffers;
+	*threshold_buffers = buffers * DM_BUFIO_WRITEBACK_RATIO;
+}
+
 /*
  * Allocating buffer data.
  *
@@ -159,7 +197,8 @@ struct dm_buffer {
  *	as low as 128M) --- so using it for caching is not appropriate.
  * If the allocation may fail we use __get_free_pages. Memory fragmentation
  *	won't have fatal effect here, it just causes flushes of some other
- *	buffers and more I/O will be performed.
+ *	buffers and more I/O will be performed. Don't use __get_free_pages if
+ *	it always fails (i.e. order >= MAX_ORDER).
  * If the allocation shouldn't fail we use __vmalloc. This is only for
  *	the initial reserve allocation, so there's no risk of wasting
  *	all vmalloc space.
@@ -170,7 +209,7 @@ static void *dm_bufio_alloc_buffer_data(struct dm_bufio_client *c,
 	if (c->block_size <= DM_BUFIO_BLOCK_SIZE_KMALLOC_LIMIT) {
 		*data_mode = DATA_MODE_KMALLOC;
 		return kmalloc(c->block_size, gfp_mask);
-	} else if (gfp_mask & __GFP_NORETRY) {
+	} else if (c->block_size <= DM_BUFIO_BLOCK_SIZE_GFP_LIMIT && gfp_mask & __GFP_NORETRY) {
 		*data_mode = DATA_MODE_GET_FREE_PAGES;
 		return (void *)__get_free_pages(gfp_mask,
 						c->pages_per_block_bits);
@@ -424,9 +463,11 @@ static void free_buffer_wake(struct dm_buffer *b)
  */
 static void check_watermark(struct dm_bufio_client *c)
 {
-	while (c->n_buffers > c->threshold_buffers) {
+	unsigned long threshold_buffers, limit_buffers;
+	get_memory_limit(c, &threshold_buffers, &limit_buffers);
+	while (c->n_buffers > threshold_buffers) {
 		struct dm_buffer *b;
-		b = get_unclaimed_buffer(c, c->n_buffers > c->limit_buffers);
+		b = get_unclaimed_buffer(c, c->n_buffers > limit_buffers);
 		if (!b)
 			return;
 		free_buffer_wake(b);
@@ -558,7 +599,7 @@ static void *dm_bufio_new_read(struct dm_bufio_client *c, sector_t block,
 retry_search:
 	b = dm_bufio_find(c, block);
 	if (b) {
-		if (new_b)
+		if (unlikely(new_b != NULL))
 			free_buffer_wake(new_b);
 		b->hold_count++;
 		relink_lru(b, test_bit(B_DIRTY, &b->state) ||
@@ -568,7 +609,7 @@ unlock_wait_ret:
 wait_ret:
 		wait_on_bit(&b->state, B_READING,
 			    do_io_schedule, TASK_UNINTERRUPTIBLE);
-		if (b->read_error) {
+		if (unlikely(b->read_error != 0)) {
 			int error = b->read_error;
 			dm_bufio_release(b);
 			return ERR_PTR(error);
@@ -898,8 +939,7 @@ EXPORT_SYMBOL(dm_bufio_drop_buffers);
 
 /* Create the buffering interface */
 struct dm_bufio_client *
-dm_bufio_client_create(struct block_device *bdev, unsigned blocksize,
-		       unsigned flags, __u64 cache_threshold, __u64 cache_limit)
+dm_bufio_client_create(struct block_device *bdev, unsigned blocksize)
 {
 	int r;
 	struct dm_bufio_client *c;
@@ -925,22 +965,6 @@ dm_bufio_client_create(struct block_device *bdev, unsigned blocksize,
 	mutex_init(&c->lock);
 	c->n_buffers = 0;
 
-	if (!cache_limit)
-		cache_limit = DM_BUFIO_LIMIT_MEMORY;
-	c->limit_buffers = cache_limit >>
-		(c->sectors_per_block_bits + SECTOR_SHIFT);
-	if (!c->limit_buffers)
-		c->limit_buffers = 1;
-
-	if (!cache_threshold)
-		cache_threshold = DM_BUFIO_THRESHOLD_MEMORY;
-	if (cache_threshold > cache_limit)
-		cache_threshold = cache_limit;
-	c->threshold_buffers = cache_threshold >>
-		(c->sectors_per_block_bits + SECTOR_SHIFT);
-	if (!c->threshold_buffers)
-		c->threshold_buffers = 1;
-
 	init_waitqueue_head(&c->free_buffer_wait);
 	c->async_write_error = 0;
 
@@ -957,6 +981,8 @@ dm_bufio_client_create(struct block_device *bdev, unsigned blocksize,
 		goto bad_buffer;
 	}
 
+	adjust_client_count(1);
+
 	return c;
 
 bad_buffer:
@@ -983,5 +1009,38 @@ void dm_bufio_client_destroy(struct dm_bufio_client *c)
 	BUG_ON(c->n_buffers != 0);
 	dm_io_client_destroy(c->dm_io);
 	kfree(c);
+	adjust_client_count(-1);
 }
 EXPORT_SYMBOL(dm_bufio_client_destroy);
+
+/*
+ * This is called only once for the whole dm_bufio module.
+ * It initializes memory limit.
+ */
+void __init dm_bufio_module_init(void)
+{
+	__u64 mem = (__u64)((totalram_pages - totalhigh_pages) * DM_BUFIO_MEMORY_RATIO) << PAGE_SHIFT;
+	if (mem > ULONG_MAX)
+		mem = ULONG_MAX;
+#ifdef CONFIG_MMU
+	/*
+	 * Get the size of vmalloc space,
+	 * the same way as VMALLOC_TOTAL in fs/proc/internal.h
+	 */
+	if (mem > (VMALLOC_END - VMALLOC_START) * DM_BUFIO_VMALLOC_RATIO)
+		mem = (VMALLOC_END - VMALLOC_START) * DM_BUFIO_VMALLOC_RATIO;
+#endif
+	dm_bufio_avail_mem = mem;
+	dm_bufio_avail_mem_per_client = mem;
+	dm_bufio_client_count = 0;
+}
+EXPORT_SYMBOL(dm_bufio_module_init);
+
+/*
+ * This is called once when unloading the dm_bufio module.
+ */
+
+void dm_bufio_module_exit(void)
+{
+}
+EXPORT_SYMBOL(dm_bufio_module_exit)
diff --git a/drivers/md/dm-bufio.h b/drivers/md/dm-bufio.h
index 3261ea2..f258d4f 100644
--- a/drivers/md/dm-bufio.h
+++ b/drivers/md/dm-bufio.h
@@ -26,10 +26,11 @@ int dm_bufio_issue_flush(struct dm_bufio_client *c);
 void dm_bufio_release_move(struct dm_buffer *b, sector_t new_block);
 
 struct dm_bufio_client *
-dm_bufio_client_create(struct block_device *bdev, unsigned blocksize,
-		       unsigned flags, __u64 cache_threshold,
-		       __u64 cache_limit);
+dm_bufio_client_create(struct block_device *bdev, unsigned blocksize);
 void dm_bufio_client_destroy(struct dm_bufio_client *c);
 void dm_bufio_drop_buffers(struct dm_bufio_client *c);
 
+void dm_bufio_module_init(void);
+void dm_bufio_module_exit(void);
+
 #endif
diff --git a/drivers/md/dm-multisnap-mikulas.c b/drivers/md/dm-multisnap-mikulas.c
index 27cc050..e16c0d6 100644
--- a/drivers/md/dm-multisnap-mikulas.c
+++ b/drivers/md/dm-multisnap-mikulas.c
@@ -608,8 +608,7 @@ static int dm_multisnap_mikulas_init(struct dm_multisnap *dm,
 	}
 
 	s->bufio = dm_bufio_client_create(dm_multisnap_snapshot_bdev(s->dm),
-					  s->chunk_size, 0, s->cache_threshold,
-					  s->cache_limit);
+					  s->chunk_size);
 	if (IS_ERR(s->bufio)) {
 		*error = "Can't create bufio client";
 		r = PTR_ERR(s->bufio);
@@ -751,13 +750,23 @@ struct dm_multisnap_exception_store dm_multisnap_mikulas_store = {
 
 static int __init dm_multisnapshot_mikulas_module_init(void)
 {
+	int r;
 	BUG_ON(sizeof(struct multisnap_commit_block) != 512);
-	return dm_multisnap_register_exception_store(&dm_multisnap_mikulas_store);
+	dm_bufio_module_init();
+	r = dm_multisnap_register_exception_store(&dm_multisnap_mikulas_store);
+	if (r)
+		goto cant_register;
+	return 0;
+
+cant_register:
+	dm_bufio_module_exit();
+	return r;
 }
 
 static void __exit dm_multisnapshot_mikulas_module_exit(void)
 {
 	dm_multisnap_unregister_exception_store(&dm_multisnap_mikulas_store);
+	dm_bufio_module_exit();
 }
 
 module_init(dm_multisnapshot_mikulas_module_init);
diff --git a/drivers/md/dm-multisnap.c b/drivers/md/dm-multisnap.c
index 1a1a500..5ba1af8 100644
--- a/drivers/md/dm-multisnap.c
+++ b/drivers/md/dm-multisnap.c
@@ -645,8 +645,15 @@ dispatch_write:
 		return;
 	}
 
+	/*
+	 * Jump to the middle of the cycle.
+	 * We already asked for the first remap, so we skip it in the first
+	 * iteration. Chaning the cycle to start with add_next_remap would
+	 * make the code less readable because it wouldn't follow the natural
+	 * flow of operations, so we use this goto instead.
+	 */
 	i = 0;
-	goto midcycle;
+	goto skip_query_next_remap;
 	for (; i < DM_MULTISNAP_MAX_CHUNKS_TO_REMAP; i++) {
 		r = s->store->query_next_remap(s->p, chunk);
 		if (unlikely(r < 0))
@@ -654,7 +661,7 @@ dispatch_write:
 		if (likely(!r))
 			break;
 
-midcycle:
+skip_query_next_remap:
 		s->store->add_next_remap(s->p, &pe->desc[i], &new_chunk);
 		if (unlikely(dm_multisnap_has_error(s)))
 			goto free_err_endio;
@@ -1461,6 +1468,44 @@ poll_for_ios:
 	mutex_unlock(&all_multisnapshots_lock);
 }
 
+static int multisnap_iterate_devices(struct dm_target *ti, struct dm_multisnap *s,
+				     iterate_devices_callout_fn fn, void *data)
+{
+	int r;
+
+	r = fn(ti, s->origin, 0, s->origin_sectors, data);
+
+	if (!r)
+		r = fn(ti, s->snapshot, 0, s->origin_sectors, data);
+
+	return r;
+}
+
+static int multisnap_origin_iterate_devices(struct dm_target *ti,
+					    iterate_devices_callout_fn fn, void *data)
+{
+	struct dm_multisnap *s = ti->private;
+	return multisnap_iterate_devices(ti, s, fn, data);
+}
+
+static int multisnap_snap_iterate_devices(struct dm_target *ti,
+					  iterate_devices_callout_fn fn, void *data)
+{
+	int r;
+	struct dm_multisnap_snap *sn = ti->private;
+	struct dm_multisnap *s;
+
+	mutex_lock(&all_multisnapshots_lock);
+	s = sn->s;
+	if (s)
+		r = multisnap_iterate_devices(ti, s, fn, data);
+	else
+		r = 0;
+	mutex_unlock(&all_multisnapshots_lock);
+
+	return r;
+}
+
 static int multisnap_origin_map(struct dm_target *ti, struct bio *bio,
 				union map_info *map_context)
 {
@@ -1934,6 +1979,7 @@ static struct target_type multisnap_origin_target = {
 	.message 	= multisnap_origin_message,
 	.status		= multisnap_origin_status,
 	.postsuspend	= multisnap_origin_postsuspend,
+	.iterate_devices = multisnap_origin_iterate_devices,
 };
 
 static struct target_type multisnap_snap_target = {
@@ -1945,6 +1991,7 @@ static struct target_type multisnap_snap_target = {
 	.map		= multisnap_snap_map,
 	.end_io		= multisnap_snap_end_io,
 	.status		= multisnap_snap_status,
+	.iterate_devices = multisnap_snap_iterate_devices,
 };
 
 static int __init dm_multisnapshot_init(void)
