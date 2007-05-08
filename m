From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.22 PATCH 21/26] dm io: remove old interface
Date: Tue, 8 May 2007 20:48:37 +0100
Message-ID: <20070508194837.GB24114@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Milan Broz <mbroz@redhat.com>

Remove old dm-io interface.

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---

 drivers/md/dm-io.c |  131 +----------------------------------------------------
 drivers/md/dm-io.h |   51 +-------------------
 2 files changed, 7 insertions(+), 175 deletions(-)

Index: linux-2.6.21/drivers/md/dm-io.c
===================================================================
--- linux-2.6.21.orig/drivers/md/dm-io.c	2007-05-08 16:28:26.000000000 +0100
+++ linux-2.6.21/drivers/md/dm-io.c	2007-05-08 16:29:01.000000000 +0100
@@ -13,8 +13,6 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 
-static struct bio_set *_bios;
-
 struct dm_io_client {
 	mempool_t *pool;
 	struct bio_set *bios;
@@ -35,74 +33,12 @@ struct io {
  * io.  Since async io is likely to be the majority of io we'll
  * have the same number of io contexts as bios! (FIXME: must reduce this).
  */
-static unsigned _num_ios;
-static mempool_t *_io_pool;
-
-/*
- * Temporary functions to allow old and new interfaces to co-exist.
- */
-static struct bio_set *bios(struct dm_io_client *client)
-{
-	return client ? client->bios : _bios;
-}
-
-static mempool_t *io_pool(struct dm_io_client *client)
-{
-	return client ? client->pool : _io_pool;
-}
 
 static unsigned int pages_to_ios(unsigned int pages)
 {
 	return 4 * pages;	/* too many ? */
 }
 
-static int resize_pool(unsigned int new_ios)
-{
-	int r = 0;
-
-	if (_io_pool) {
-		if (new_ios == 0) {
-			/* free off the pool */
-			mempool_destroy(_io_pool);
-			_io_pool = NULL;
-			bioset_free(_bios);
-
-		} else {
-			/* resize the pool */
-			r = mempool_resize(_io_pool, new_ios, GFP_KERNEL);
-		}
-
-	} else {
-		/* create new pool */
-		_io_pool = mempool_create_kmalloc_pool(new_ios,
-						       sizeof(struct io));
-		if (!_io_pool)
-			return -ENOMEM;
-
-		_bios = bioset_create(16, 16);
-		if (!_bios) {
-			mempool_destroy(_io_pool);
-			_io_pool = NULL;
-			return -ENOMEM;
-		}
-	}
-
-	if (!r)
-		_num_ios = new_ios;
-
-	return r;
-}
-
-int dm_io_get(unsigned int num_pages)
-{
-	return resize_pool(_num_ios + pages_to_ios(num_pages));
-}
-
-void dm_io_put(unsigned int num_pages)
-{
-	resize_pool(_num_ios - pages_to_ios(num_pages));
-}
-
 /*
  * Create a client with mempool and bioset.
  */
@@ -182,7 +118,7 @@ static void dec_count(struct io *io, uns
 			io_notify_fn fn = io->callback;
 			void *context = io->context;
 
-			mempool_free(io, io_pool(io->client));
+			mempool_free(io, io->client->pool);
 			fn(r, context);
 		}
 	}
@@ -310,7 +246,7 @@ static void dm_bio_destructor(struct bio
 {
 	struct io *io = bio->bi_private;
 
-	bio_free(bio, bios(io->client));
+	bio_free(bio, io->client->bios);
 }
 
 /*
@@ -358,7 +294,7 @@ static void do_region(int rw, unsigned i
 		 * to hide it from bio_add_page().
 		 */
 		num_bvecs = (remaining / (PAGE_SIZE >> SECTOR_SHIFT)) + 2;
-		bio = bio_alloc_bioset(GFP_NOIO, num_bvecs, bios(io->client));
+		bio = bio_alloc_bioset(GFP_NOIO, num_bvecs, io->client->bios);
 		bio->bi_sector = where->sector + (where->count - remaining);
 		bio->bi_bdev = where->bdev;
 		bio->bi_end_io = endio;
@@ -462,7 +398,7 @@ static int async_io(struct dm_io_client 
 		return -EIO;
 	}
 
-	io = mempool_alloc(io_pool(client), GFP_NOIO);
+	io = mempool_alloc(client->pool, GFP_NOIO);
 	io->error = 0;
 	atomic_set(&io->count, 1); /* see dispatch_io() */
 	io->sleeper = NULL;
@@ -474,56 +410,6 @@ static int async_io(struct dm_io_client 
 	return 0;
 }
 
-int dm_io_sync(unsigned int num_regions, struct io_region *where, int rw,
-	       struct page_list *pl, unsigned int offset,
-	       unsigned long *error_bits)
-{
-	struct dpages dp;
-	list_dp_init(&dp, pl, offset);
-	return sync_io(NULL, num_regions, where, rw, &dp, error_bits);
-}
-
-int dm_io_sync_bvec(unsigned int num_regions, struct io_region *where, int rw,
-		    struct bio_vec *bvec, unsigned long *error_bits)
-{
-	struct dpages dp;
-	bvec_dp_init(&dp, bvec);
-	return sync_io(NULL, num_regions, where, rw, &dp, error_bits);
-}
-
-int dm_io_sync_vm(unsigned int num_regions, struct io_region *where, int rw,
-		  void *data, unsigned long *error_bits)
-{
-	struct dpages dp;
-	vm_dp_init(&dp, data);
-	return sync_io(NULL, num_regions, where, rw, &dp, error_bits);
-}
-
-int dm_io_async(unsigned int num_regions, struct io_region *where, int rw,
-		struct page_list *pl, unsigned int offset,
-		io_notify_fn fn, void *context)
-{
-	struct dpages dp;
-	list_dp_init(&dp, pl, offset);
-	return async_io(NULL, num_regions, where, rw, &dp, fn, context);
-}
-
-int dm_io_async_bvec(unsigned int num_regions, struct io_region *where, int rw,
-		     struct bio_vec *bvec, io_notify_fn fn, void *context)
-{
-	struct dpages dp;
-	bvec_dp_init(&dp, bvec);
-	return async_io(NULL, num_regions, where, rw, &dp, fn, context);
-}
-
-int dm_io_async_vm(unsigned int num_regions, struct io_region *where, int rw,
-		   void *data, io_notify_fn fn, void *context)
-{
-	struct dpages dp;
-	vm_dp_init(&dp, data);
-	return async_io(NULL, num_regions, where, rw, &dp, fn, context);
-}
-
 static int dp_init(struct dm_io_request *io_req, struct dpages *dp)
 {
 	/* Set up dpages based on memory type */
@@ -572,12 +458,3 @@ int dm_io(struct dm_io_request *io_req, 
 			&dp, io_req->notify.fn, io_req->notify.context);
 }
 EXPORT_SYMBOL(dm_io);
-
-EXPORT_SYMBOL(dm_io_get);
-EXPORT_SYMBOL(dm_io_put);
-EXPORT_SYMBOL(dm_io_sync);
-EXPORT_SYMBOL(dm_io_async);
-EXPORT_SYMBOL(dm_io_sync_bvec);
-EXPORT_SYMBOL(dm_io_async_bvec);
-EXPORT_SYMBOL(dm_io_sync_vm);
-EXPORT_SYMBOL(dm_io_async_vm);
Index: linux-2.6.21/drivers/md/dm-io.h
===================================================================
--- linux-2.6.21.orig/drivers/md/dm-io.h	2007-05-08 16:28:11.000000000 +0100
+++ linux-2.6.21/drivers/md/dm-io.h	2007-05-08 16:29:01.000000000 +0100
@@ -12,7 +12,7 @@
 struct io_region {
 	struct block_device *bdev;
 	sector_t sector;
-	sector_t count;
+	sector_t count;		/* If this is zero the region is ignored. */
 };
 
 struct page_list {
@@ -20,10 +20,6 @@ struct page_list {
 	struct page *page;
 };
 
-/*
- * 'error' is a bitset, with each bit indicating whether an error
- * occurred doing io to the corresponding region.
- */
 typedef void (*io_notify_fn)(unsigned long error, void *context);
 
 enum dm_io_mem_type {
@@ -63,16 +59,6 @@ struct dm_io_request {
 };
 
 /*
- * Before anyone uses the IO interface they should call
- * dm_io_get(), specifying roughly how many pages they are
- * expecting to perform io on concurrently.
- *
- * This function may block.
- */
-int dm_io_get(unsigned int num_pages);
-void dm_io_put(unsigned int num_pages);
-
-/*
  * For async io calls, users can alternatively use the dm_io() function below
  * and dm_io_client_create() to create private mempools for the client.
  *
@@ -83,40 +69,9 @@ int dm_io_client_resize(unsigned num_pag
 void dm_io_client_destroy(struct dm_io_client *client);
 
 /*
- * Synchronous IO.
- *
- * Please ensure that the rw flag in the next two functions is
- * either READ or WRITE, ie. we don't take READA.  Any
- * regions with a zero count field will be ignored.
- */
-int dm_io_sync(unsigned int num_regions, struct io_region *where, int rw,
-	       struct page_list *pl, unsigned int offset,
-	       unsigned long *error_bits);
-
-int dm_io_sync_bvec(unsigned int num_regions, struct io_region *where, int rw,
-		    struct bio_vec *bvec, unsigned long *error_bits);
-
-int dm_io_sync_vm(unsigned int num_regions, struct io_region *where, int rw,
-		  void *data, unsigned long *error_bits);
-
-/*
- * Aynchronous IO.
- *
- * The 'where' array may be safely allocated on the stack since
- * the function takes a copy.
- */
-int dm_io_async(unsigned int num_regions, struct io_region *where, int rw,
-		struct page_list *pl, unsigned int offset,
-		io_notify_fn fn, void *context);
-
-int dm_io_async_bvec(unsigned int num_regions, struct io_region *where, int rw,
-		     struct bio_vec *bvec, io_notify_fn fn, void *context);
-
-int dm_io_async_vm(unsigned int num_regions, struct io_region *where, int rw,
-		   void *data, io_notify_fn fn, void *context);
-
-/*
  * IO interface using private per-client pools.
+ * Each bit in the optional 'sync_error_bits' bitset indicates whether an
+ * error occurred doing io to the corresponding region.
  */
 int dm_io(struct dm_io_request *io_req, unsigned num_regions,
 	  struct io_region *region, unsigned long *sync_error_bits);
