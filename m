From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-io: flush CPU cache on vmalloc mappings
Date: Wed, 18 May 2011 18:12:39 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1105181810380.1252@hs20-bc2-1.build.redhat.com>
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
To: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

dm-io: flush CPU cache on vmalloc mappings

For normal kernel pages, CPU cache is synchronized by the dma layer.
However, this is not done for pages allocated with vmalloc. If we do I/O
to/from vmallocated pages, we must synchronize CPU cache explicitly.

Prior to doing I/O on vmallocated page we must call
flush_kernel_vmap_range to flush dirty cache on the virtual address.
After finished read we must call invalidate_kernel_vmap_range to
invalidate cache on the virtual address, so that accesses to the virtual
address return newly read data and not stale data from CPU cache.

This patch fixes metadata corruption on dm-snapshots on PA-RISC and
possibly other architectures with caches indexed by virtual address.

Cc: stable <stable@kernel.org>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-io.c |   29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

Index: linux-2.6.39-rc7-fast/drivers/md/dm-io.c
===================================================================
--- linux-2.6.39-rc7-fast.orig/drivers/md/dm-io.c	2011-05-18 19:14:52.000000000 +0200
+++ linux-2.6.39-rc7-fast/drivers/md/dm-io.c	2011-05-18 19:48:30.000000000 +0200
@@ -36,6 +36,8 @@ struct io {
 	struct dm_io_client *client;
 	io_notify_fn callback;
 	void *context;
+	void *vma_invalidate_address;
+	unsigned long vma_invalidate_size;
 } __attribute__((aligned(DM_IO_MAX_REGIONS)));
 
 static struct kmem_cache *_dm_io_cache;
@@ -133,6 +135,10 @@ static void dec_count(struct io *io, uns
 		set_bit(region, &io->error_bits);
 
 	if (atomic_dec_and_test(&io->count)) {
+		if (io->vma_invalidate_size)
+			invalidate_kernel_vmap_range(io->vma_invalidate_address,
+						     io->vma_invalidate_size);
+
 		if (io->sleeper)
 			wake_up_process(io->sleeper);
 
@@ -176,6 +182,9 @@ struct dpages {
 
 	unsigned context_u;
 	void *context_ptr;
+
+	void *vma_invalidate_address;
+	unsigned long vma_invalidate_size;
 };
 
 /*
@@ -394,6 +403,9 @@ static int sync_io(struct dm_io_client *
 	io->sleeper = current;
 	io->client = client;
 
+	io->vma_invalidate_address = dp->vma_invalidate_address;
+	io->vma_invalidate_size = dp->vma_invalidate_size;
+
 	dispatch_io(rw, num_regions, where, dp, io, 1);
 
 	while (1) {
@@ -432,13 +444,21 @@ static int async_io(struct dm_io_client 
 	io->callback = fn;
 	io->context = context;
 
+	io->vma_invalidate_address = dp->vma_invalidate_address;
+	io->vma_invalidate_size = dp->vma_invalidate_size;
+
 	dispatch_io(rw, num_regions, where, dp, io, 0);
 	return 0;
 }
 
-static int dp_init(struct dm_io_request *io_req, struct dpages *dp)
+static int dp_init(struct dm_io_request *io_req, struct dpages *dp,
+		   unsigned long size)
 {
 	/* Set up dpages based on memory type */
+
+	dp->vma_invalidate_address = NULL;
+	dp->vma_invalidate_size = 0;
+
 	switch (io_req->mem.type) {
 	case DM_IO_PAGE_LIST:
 		list_dp_init(dp, io_req->mem.ptr.pl, io_req->mem.offset);
@@ -449,6 +469,11 @@ static int dp_init(struct dm_io_request 
 		break;
 
 	case DM_IO_VMA:
+		flush_kernel_vmap_range(io_req->mem.ptr.vma, size);
+		if ((io_req->bi_rw & RW_MASK) == READ) {
+			dp->vma_invalidate_address = io_req->mem.ptr.vma;
+			dp->vma_invalidate_size = size;
+		}
 		vm_dp_init(dp, io_req->mem.ptr.vma);
 		break;
 
@@ -477,7 +502,7 @@ int dm_io(struct dm_io_request *io_req, 
 	int r;
 	struct dpages dp;
 
-	r = dp_init(io_req, &dp);
+	r = dp_init(io_req, &dp, (unsigned long)where->count << SECTOR_SHIFT);
 	if (r)
 		return r;
 
