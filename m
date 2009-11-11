From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/2] Use low pointer bits for dm io region
Date: Tue, 10 Nov 2009 21:05:04 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0911102104350.23116@hs20-bc2-1.build.redhat.com>
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

Use low pointer bits for dm io region

We need to store two things per bio: the pointer to the main io structure and
a region number, an index of disk where this bio belongs to (if there is
simultaneous write to multiple disks). There can be at most BITS_PER_LONG
regions. BITS_PER_LONG is 32 on 32-bit machines and 64 on 64-bit machines.

A region number was stored in the last hidden bio vector and the pointer to
struct io was stored in bi_private.

This patch changes it so that "struct io" is always aligned on BITS_PER_LONG
bytes and region number is stored in the low BITS_PER_LONG bits of bi_private.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-io.c |   84 +++++++++++++++++++++++++++++++----------------------
 1 file changed, 50 insertions(+), 34 deletions(-)

Index: linux-2.6.31.6-fast/drivers/md/dm-io.c
===================================================================
--- linux-2.6.31.6-fast.orig/drivers/md/dm-io.c	2009-11-11 00:51:38.000000000 +0100
+++ linux-2.6.31.6-fast/drivers/md/dm-io.c	2009-11-11 02:13:32.000000000 +0100
@@ -14,12 +14,17 @@
 #include <linux/slab.h>
 #include <linux/dm-io.h>
 
+#define DM_IO_MAX_REGIONS	BITS_PER_LONG
+
 struct dm_io_client {
 	mempool_t *pool;
 	struct bio_set *bios;
 };
 
-/* FIXME: can we shrink this ? */
+/*
+ * The alignment of "struct io" is required because region number is stored
+ * in the low bits of the pointer.
+ */
 struct io {
 	unsigned long error_bits;
 	unsigned long eopnotsupp_bits;
@@ -28,7 +33,7 @@ struct io {
 	struct dm_io_client *client;
 	io_notify_fn callback;
 	void *context;
-};
+} __attribute__((aligned(DM_IO_MAX_REGIONS)));
 
 static struct kmem_cache *_io_cache = NULL;
 
@@ -90,18 +95,25 @@ EXPORT_SYMBOL(dm_io_client_destroy);
 
 /*-----------------------------------------------------------------
  * We need to keep track of which region a bio is doing io for.
- * In order to save a memory allocation we store this the last
- * bvec which we know is unused (blech).
- * XXX This is ugly and can OOPS with some configs... find another way.
+ * In order to save a memory allocation we store this the lowest
+ * bits of the pointer.
  *---------------------------------------------------------------*/
-static inline void bio_set_region(struct bio *bio, unsigned region)
+static inline void bio_set_io_region(struct bio *bio, struct io *io,
+				     unsigned region)
 {
-	bio->bi_io_vec[bio->bi_max_vecs].bv_len = region;
+	if (unlikely(!IS_ALIGNED((unsigned long)io, DM_IO_MAX_REGIONS))) {
+		printk(KERN_CRIT "dm-io: Unaligned pointer %p\n", io);
+		BUG();
+	}
+	bio->bi_private = (void *)((unsigned long)io | region);
 }
 
-static inline unsigned bio_get_region(struct bio *bio)
+static inline void bio_get_io_region(struct bio *bio, struct io **io,
+				     unsigned *region)
 {
-	return bio->bi_io_vec[bio->bi_max_vecs].bv_len;
+	unsigned long val = (unsigned long)bio->bi_private;
+	*io = (void *)(val & -(unsigned long)DM_IO_MAX_REGIONS);
+	*region = val & (DM_IO_MAX_REGIONS - 1);
 }
 
 /*-----------------------------------------------------------------
@@ -142,10 +154,8 @@ static void endio(struct bio *bio, int e
 	/*
 	 * The bio destructor in bio_put() may use the io object.
 	 */
-	io = bio->bi_private;
-	region = bio_get_region(bio);
+	bio_get_io_region(bio, &io, &region);
 
-	bio->bi_max_vecs++;
 	bio_put(bio);
 
 	dec_count(io, region, error);
@@ -245,7 +255,10 @@ static void vm_dp_init(struct dpages *dp
 
 static void dm_bio_destructor(struct bio *bio)
 {
-	struct io *io = bio->bi_private;
+	unsigned region;
+	struct io *io;
+
+	bio_get_io_region(bio, &io, &region);
 
 	bio_free(bio, io->client->bios);
 }
@@ -294,24 +307,17 @@ static void do_region(int rw, unsigned r
 	 */
 	do {
 		/*
-		 * Allocate a suitably sized-bio: we add an extra
-		 * bvec for bio_get/set_region() and decrement bi_max_vecs
-		 * to hide it from bio_add_page().
+		 * Allocate a suitably sized-bio.
 		 */
 		num_bvecs = dm_sector_div_up(remaining,
 					     (PAGE_SIZE >> SECTOR_SHIFT));
-		num_bvecs = 1 + min_t(int, bio_get_nr_vecs(where->bdev),
-				      num_bvecs);
-		if (unlikely(num_bvecs > BIO_MAX_PAGES))
-			num_bvecs = BIO_MAX_PAGES;
+		num_bvecs = min_t(int, bio_get_nr_vecs(where->bdev), num_bvecs);
 		bio = bio_alloc_bioset(GFP_NOIO, num_bvecs, io->client->bios);
 		bio->bi_sector = where->sector + (where->count - remaining);
 		bio->bi_bdev = where->bdev;
 		bio->bi_end_io = endio;
-		bio->bi_private = io;
 		bio->bi_destructor = dm_bio_destructor;
-		bio->bi_max_vecs--;
-		bio_set_region(bio, region);
+		bio_set_io_region(bio, io, region);
 
 		/*
 		 * Try and add as many pages as possible.
@@ -339,6 +345,8 @@ static void dispatch_io(int rw, unsigned
 	int i;
 	struct dpages old_pages = *dp;
 
+	BUG_ON(num_regions > DM_IO_MAX_REGIONS);
+
 	if (sync)
 		rw |= (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG);
 
@@ -363,7 +371,15 @@ static int sync_io(struct dm_io_client *
 		   struct dm_io_region *where, int rw, struct dpages *dp,
 		   unsigned long *error_bits)
 {
-	struct io io;
+	/*
+	 * gcc <= 4.3 can't do the alignment for stack variables, so we must
+	 * align it on our own.
+	 * volatile is there to prevent the optimizer from removing or reusing
+	 * "io_" field from the stack frame. (which would be allowed according
+	 * to ANSI C rules).
+	 */
+	volatile char io_[sizeof(struct io) * 2 - 1];
+	struct io *io = (struct io *)PTR_ALIGN(&io_, __alignof__(struct io));
 
 	if (num_regions > 1 && (rw & RW_MASK) != WRITE) {
 		WARN_ON(1);
@@ -371,33 +387,33 @@ static int sync_io(struct dm_io_client *
 	}
 
 retry:
-	io.error_bits = 0;
-	io.eopnotsupp_bits = 0;
-	atomic_set(&io.count, 1); /* see dispatch_io() */
-	io.sleeper = current;
-	io.client = client;
+	io->error_bits = 0;
+	io->eopnotsupp_bits = 0;
+	atomic_set(&io->count, 1); /* see dispatch_io() */
+	io->sleeper = current;
+	io->client = client;
 
-	dispatch_io(rw, num_regions, where, dp, &io, 1);
+	dispatch_io(rw, num_regions, where, dp, io, 1);
 
 	while (1) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
 
-		if (!atomic_read(&io.count))
+		if (!atomic_read(&io->count))
 			break;
 
 		io_schedule();
 	}
 	set_current_state(TASK_RUNNING);
 
-	if (io.eopnotsupp_bits && (rw & (1 << BIO_RW_BARRIER))) {
+	if (io->eopnotsupp_bits && (rw & (1 << BIO_RW_BARRIER))) {
 		rw &= ~(1 << BIO_RW_BARRIER);
 		goto retry;
 	}
 
 	if (error_bits)
-		*error_bits = io.error_bits;
+		*error_bits = io->error_bits;
 
-	return io.error_bits ? -EIO : 0;
+	return io->error_bits ? -EIO : 0;
 }
 
 static int async_io(struct dm_io_client *client, unsigned int num_regions,
