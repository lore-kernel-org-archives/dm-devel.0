From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.22 PATCH 15/26] dm io: prepare for new interface
Date: Tue, 8 May 2007 20:47:26 +0100
Message-ID: <20070508194726.GV24114@agk.fab.redhat.com>
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
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Heinz Mauelshagen <hjm@redhat.com>
List-Id: dm-devel.ids

From: Heinz Mauelshagen <hjm@redhat.com>

Introduce struct dm_io_client to prepare for per-client mempools
and bio_sets.

Temporary functions bios() and io_pool() choose between
the per-client structures and the global ones so the old
and new interfaces can co-exist.

Make error_bits optional.
 
Signed-off-by: Heinz Mauelshagen <hjm@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: Milan Broz <mbroz@redhat.com>
---

 drivers/md/dm-io.c |   61 ++++++++++++++++++++++++++++++++++++++---------------
 1 files changed, 44 insertions(+), 17 deletions(-)

Index: linux-2.6.21/drivers/md/dm-io.c
===================================================================
--- linux-2.6.21.orig/drivers/md/dm-io.c	2007-05-01 17:40:52.000000000 +0100
+++ linux-2.6.21/drivers/md/dm-io.c	2007-05-01 17:40:52.000000000 +0100
@@ -1,5 +1,6 @@
 /*
  * Copyright (C) 2003 Sistina Software
+ * Copyright (C) 2006 Red Hat GmbH
  *
  * This file is released under the GPL.
  */
@@ -14,11 +15,17 @@
 
 static struct bio_set *_bios;
 
+struct dm_io_client {
+	mempool_t *pool;
+	struct bio_set *bios;
+};
+
 /* FIXME: can we shrink this ? */
 struct io {
 	unsigned long error;
 	atomic_t count;
 	struct task_struct *sleeper;
+	struct dm_io_client *client;
 	io_notify_fn callback;
 	void *context;
 };
@@ -26,12 +33,24 @@ struct io {
 /*
  * io contexts are only dynamically allocated for asynchronous
  * io.  Since async io is likely to be the majority of io we'll
- * have the same number of io contexts as buffer heads ! (FIXME:
- * must reduce this).
+ * have the same number of io contexts as bios! (FIXME: must reduce this).
  */
 static unsigned _num_ios;
 static mempool_t *_io_pool;
 
+/*
+ * Temporary functions to allow old and new interfaces to co-exist.
+ */
+static struct bio_set *bios(struct dm_io_client *client)
+{
+	return client ? client->bios : _bios;
+}
+
+static mempool_t *io_pool(struct dm_io_client *client)
+{
+	return client ? client->pool : _io_pool;
+}
+
 static unsigned int pages_to_ios(unsigned int pages)
 {
 	return 4 * pages;	/* too many ? */
@@ -118,7 +137,7 @@ static void dec_count(struct io *io, uns
 			io_notify_fn fn = io->callback;
 			void *context = io->context;
 
-			mempool_free(io, _io_pool);
+			mempool_free(io, io_pool(io->client));
 			fn(r, context);
 		}
 	}
@@ -241,7 +260,9 @@ static void vm_dp_init(struct dpages *dp
 
 static void dm_bio_destructor(struct bio *bio)
 {
-	bio_free(bio, _bios);
+	struct io *io = bio->bi_private;
+
+	bio_free(bio, bios(io->client));
 }
 
 /*-----------------------------------------------------------------
@@ -264,7 +285,7 @@ static void do_region(int rw, unsigned i
 		 * to hide it from bio_add_page().
 		 */
 		num_bvecs = (remaining / (PAGE_SIZE >> SECTOR_SHIFT)) + 2;
-		bio = bio_alloc_bioset(GFP_NOIO, num_bvecs, _bios);
+		bio = bio_alloc_bioset(GFP_NOIO, num_bvecs, bios(io->client));
 		bio->bi_sector = where->sector + (where->count - remaining);
 		bio->bi_bdev = where->bdev;
 		bio->bi_end_io = endio;
@@ -319,8 +340,9 @@ static void dispatch_io(int rw, unsigned
 	dec_count(io, 0, 0);
 }
 
-static int sync_io(unsigned int num_regions, struct io_region *where,
-	    int rw, struct dpages *dp, unsigned long *error_bits)
+static int sync_io(struct dm_io_client *client, unsigned int num_regions,
+		   struct io_region *where, int rw, struct dpages *dp,
+		   unsigned long *error_bits)
 {
 	struct io io;
 
@@ -332,6 +354,7 @@ static int sync_io(unsigned int num_regi
 	io.error = 0;
 	atomic_set(&io.count, 1); /* see dispatch_io() */
 	io.sleeper = current;
+	io.client = client;
 
 	dispatch_io(rw, num_regions, where, dp, &io, 1);
 
@@ -348,12 +371,15 @@ static int sync_io(unsigned int num_regi
 	if (atomic_read(&io.count))
 		return -EINTR;
 
-	*error_bits = io.error;
+	if (error_bits)
+		*error_bits = io.error;
+
 	return io.error ? -EIO : 0;
 }
 
-static int async_io(unsigned int num_regions, struct io_region *where, int rw,
-	     struct dpages *dp, io_notify_fn fn, void *context)
+static int async_io(struct dm_io_client *client, unsigned int num_regions,
+		    struct io_region *where, int rw, struct dpages *dp,
+		    io_notify_fn fn, void *context)
 {
 	struct io *io;
 
@@ -363,10 +389,11 @@ static int async_io(unsigned int num_reg
 		return -EIO;
 	}
 
-	io = mempool_alloc(_io_pool, GFP_NOIO);
+	io = mempool_alloc(io_pool(client), GFP_NOIO);
 	io->error = 0;
 	atomic_set(&io->count, 1); /* see dispatch_io() */
 	io->sleeper = NULL;
+	io->client = client;
 	io->callback = fn;
 	io->context = context;
 
@@ -380,7 +407,7 @@ int dm_io_sync(unsigned int num_regions,
 {
 	struct dpages dp;
 	list_dp_init(&dp, pl, offset);
-	return sync_io(num_regions, where, rw, &dp, error_bits);
+	return sync_io(NULL, num_regions, where, rw, &dp, error_bits);
 }
 
 int dm_io_sync_bvec(unsigned int num_regions, struct io_region *where, int rw,
@@ -388,7 +415,7 @@ int dm_io_sync_bvec(unsigned int num_reg
 {
 	struct dpages dp;
 	bvec_dp_init(&dp, bvec);
-	return sync_io(num_regions, where, rw, &dp, error_bits);
+	return sync_io(NULL, num_regions, where, rw, &dp, error_bits);
 }
 
 int dm_io_sync_vm(unsigned int num_regions, struct io_region *where, int rw,
@@ -396,7 +423,7 @@ int dm_io_sync_vm(unsigned int num_regio
 {
 	struct dpages dp;
 	vm_dp_init(&dp, data);
-	return sync_io(num_regions, where, rw, &dp, error_bits);
+	return sync_io(NULL, num_regions, where, rw, &dp, error_bits);
 }
 
 int dm_io_async(unsigned int num_regions, struct io_region *where, int rw,
@@ -405,7 +432,7 @@ int dm_io_async(unsigned int num_regions
 {
 	struct dpages dp;
 	list_dp_init(&dp, pl, offset);
-	return async_io(num_regions, where, rw, &dp, fn, context);
+	return async_io(NULL, num_regions, where, rw, &dp, fn, context);
 }
 
 int dm_io_async_bvec(unsigned int num_regions, struct io_region *where, int rw,
@@ -413,7 +440,7 @@ int dm_io_async_bvec(unsigned int num_re
 {
 	struct dpages dp;
 	bvec_dp_init(&dp, bvec);
-	return async_io(num_regions, where, rw, &dp, fn, context);
+	return async_io(NULL, num_regions, where, rw, &dp, fn, context);
 }
 
 int dm_io_async_vm(unsigned int num_regions, struct io_region *where, int rw,
@@ -421,7 +448,7 @@ int dm_io_async_vm(unsigned int num_regi
 {
 	struct dpages dp;
 	vm_dp_init(&dp, data);
-	return async_io(num_regions, where, rw, &dp, fn, context);
+	return async_io(NULL, num_regions, where, rw, &dp, fn, context);
 }
 
 EXPORT_SYMBOL(dm_io_get);
