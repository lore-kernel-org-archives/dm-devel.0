From: Ram Pai <linuxram@us.ibm.com>
Subject: [RFC PATCH 11/16] DM: Try to avoid temporary buffer allocation to hold compressed data.
Date: Mon, 15 Aug 2016 10:36:48 -0700
Message-ID: <1471282613-31006-12-git-send-email-linuxram@us.ibm.com>
References: <1471282613-31006-1-git-send-email-linuxram@us.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1471282613-31006-1-git-send-email-linuxram@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-doc@vger.kernel.org
Cc: shli@kernel.org, agk@redhat.com, snitzer@redhat.com, corbet@lwn.net, Ram Pai <linuxram@us.ibm.com>
List-Id: dm-devel.ids

The read path
a) allocates a temporary buffer to hold the compressed data.
b) reads the compressed data into the temporary buffer.
c) decompresses the compressed data into the caller's bio-buffer.

We know that the caller's bio-buffer will be atleast as large as the compressed
data.  So we could save a buffer allocation in step (a) if we use caller's
bio-buffer to read in the compressed data from the disk. NOTE: this is not
possible all the time, but is possible if the destination within the bio-buffer
falls within the same segment.

This saves us from holding the temporary buffer across read boundaries.  Which
is a huge advantage especially if we are operating under acute memory
starvation; mostly when this block device is used as a swap device.

Signed-off-by: Ram Pai <linuxram@us.ibm.com>
---
 drivers/md/dm-inplace-compress.c |  185 ++++++++++++++++++-------------------
 drivers/md/dm-inplace-compress.h |    1 +
 2 files changed, 91 insertions(+), 95 deletions(-)

diff --git a/drivers/md/dm-inplace-compress.c b/drivers/md/dm-inplace-compress.c
index f6b95e3..bc1cf70 100644
--- a/drivers/md/dm-inplace-compress.c
+++ b/drivers/md/dm-inplace-compress.c
@@ -810,10 +810,15 @@ static void dm_icomp_release_comp_buffer(struct dm_icomp_io_range *io)
 {
 	if (!io->comp_data)
 		return;
-	dm_icomp_kfree(io->comp_data, io->comp_len);
+
+	if (io->comp_kmap)
+		kunmap(io->comp_data);
+	else
+		dm_icomp_kfree(io->comp_data, io->comp_len);
 
 	io->comp_data = NULL;
 	io->comp_len = 0;
+	io->comp_kmap = false;
 }
 
 static void dm_icomp_free_io_range(struct dm_icomp_io_range *io)
@@ -857,6 +862,39 @@ static void dm_icomp_put_req(struct dm_icomp_req *req)
 	kmem_cache_free(dm_icomp_req_cachep, req);
 }
 
+static void dm_icomp_bio_copy(struct bio *bio, off_t bio_off, void *buf,
+		ssize_t len, bool to_buf)
+{
+	struct bio_vec bv;
+	struct bvec_iter iter;
+	off_t buf_off = 0;
+	ssize_t size;
+	void *addr;
+
+	WARN_ON(bio_off + len > (bio_sectors(bio) << 9));
+
+	bio_for_each_segment(bv, bio, iter) {
+		int length = bv.bv_len;
+
+		if (bio_off >= length) {
+			bio_off -= length;
+			continue;
+		}
+		addr = kmap_atomic(bv.bv_page);
+		size = min_t(ssize_t, len, length - bio_off);
+		if (to_buf)
+			memcpy(buf + buf_off, addr + bio_off + bv.bv_offset,
+			size);
+		else
+			memcpy(addr + bio_off + bv.bv_offset, buf + buf_off,
+			size);
+		kunmap_atomic(addr);
+		bio_off = 0;
+		buf_off += size;
+		len -= size;
+	}
+}
+
 static void dm_icomp_io_range_done(unsigned long error, void *context)
 {
 	struct dm_icomp_io_range *io = context;
@@ -886,7 +924,7 @@ static inline int dm_icomp_compressor_maxlen(struct dm_icomp_info *info,
  * comp_data
  */
 static struct dm_icomp_io_range *dm_icomp_create_io_range(
-		struct dm_icomp_req *req, int comp_len)
+		struct dm_icomp_req *req)
 {
 	struct dm_icomp_io_range *io;
 
@@ -894,120 +932,67 @@ static struct dm_icomp_io_range *dm_icomp_create_io_range(
 	if (!io)
 		return NULL;
 
-	io->comp_data = dm_icomp_kmalloc(comp_len, GFP_NOIO);
-	if (!io->comp_data) {
-		kmem_cache_free(dm_icomp_io_range_cachep, io);
-		return NULL;
-	}
-
 	io->io_req.notify.fn = dm_icomp_io_range_done;
 	io->io_req.notify.context = io;
 	io->io_req.client = req->info->io_client;
 	io->io_req.mem.type = DM_IO_KMEM;
-	io->io_req.mem.ptr.addr = io->comp_data;
 	io->io_req.mem.offset = 0;
 
 	io->io_region.bdev = req->info->dev->bdev;
-
-	io->comp_len = comp_len;
 	io->req = req;
 
-	io->decomp_data = NULL;
-	io->decomp_real_data = NULL;
-	io->decomp_len = 0;
-	io->decomp_kmap = false;
-	io->decomp_req_len = 0;
+	io->comp_data = io->decomp_data = io->decomp_real_data = NULL;
+	io->comp_len = io->decomp_len = io->decomp_req_len = 0;
+	io->comp_kmap = io->decomp_kmap = false;
 	return io;
 }
 
 static struct dm_icomp_io_range *dm_icomp_create_io_read_range(
 		struct dm_icomp_req *req, int comp_len, int decomp_len)
 {
-	struct dm_icomp_io_range *io = dm_icomp_create_io_range(req, comp_len);
-
-	if (io) {
-		/* note down the requested length for decompress buffer.
-		 * but dont allocate it yet.
-		 */
-		io->decomp_req_len = decomp_len;
-	}
-	return io;
-}
+	struct bio *bio = req->bio;
+	sector_t size  = bio_sectors(bio)<<9;
+	int segments = bio_segments(bio);
+	void *addr;
+	struct dm_icomp_io_range *io = dm_icomp_create_io_range(req);
 
-static int dm_icomp_update_io_read_range(struct dm_icomp_io_range *io,
-		struct bio *bio, ssize_t bio_off)
-{
-	struct bvec_iter iter;
-	struct bio_vec bv;
-	bool just_use = false;
+	if (!io)
+		return NULL;
 
-	if (io->decomp_len)
-		return 0;
+	/* try reusing the bio buffer for compress data. */
+	if (segments == 1) {
+		struct bio_vec bv = bio_iovec(bio);
 
-	/* use a bio buffer long enough to hold the uncompressed data */
-	bio_for_each_segment(bv, bio, iter) {
-		int avail_len;
-		int length = bv.bv_len;
+		WARN_ON(size < comp_len);
+		addr = kmap(bv.bv_page);
+	} else
+		addr  = dm_icomp_kmalloc(comp_len, GFP_NOIO);
 
-		if (!just_use && bio_off >= length) {
-			bio_off -= length;
-			continue;
-		}
-		avail_len = just_use ? length : length-bio_off;
-		if (avail_len >= io->decomp_req_len) {
-			io->decomp_real_data = kmap(bv.bv_page);
-			io->decomp_data = io->decomp_real_data + bio_off;
-			io->decomp_len = io->decomp_req_len = avail_len;
-			io->decomp_kmap = true;
-			return 0;
-		}
-		just_use = true;
+	if (!addr) {
+		kmem_cache_free(dm_icomp_io_range_cachep, io);
+		return NULL;
 	}
+	io->comp_data = io->io_req.mem.ptr.addr = addr;
+	io->comp_len = comp_len;
+	io->comp_kmap = (segments == 1);
+	/* note down the requested length for decompress buffer.
+	 * but dont allocate it yet.
+	 /
+	io->decomp_req_len = decomp_len;
+	return io;
+}
 
-	/* none available. :( Allocate one */
+static int dm_icomp_update_io_read_range(struct dm_icomp_io_range *io)
+{
 	io->decomp_data = dm_icomp_kmalloc(io->decomp_req_len, GFP_NOIO);
 	if (!io->decomp_data)
 		return 1;
 	io->decomp_real_data = io->decomp_data;
 	io->decomp_len = io->decomp_req_len;
 	io->decomp_kmap = false;
-
 	return 0;
 }
 
-static void dm_icomp_bio_copy(struct bio *bio, off_t bio_off, void *buf,
-		ssize_t len, bool to_buf)
-{
-	struct bio_vec bv;
-	struct bvec_iter iter;
-	off_t buf_off = 0;
-	ssize_t size;
-	void *addr;
-
-	WARN_ON(bio_off + len > (bio_sectors(bio) << 9));
-
-	bio_for_each_segment(bv, bio, iter) {
-		int length = bv.bv_len;
-
-		if (bio_off >= length) {
-			bio_off -= length;
-			continue;
-		}
-		addr = kmap_atomic(bv.bv_page);
-		size = min_t(ssize_t, len, length - bio_off);
-		if (to_buf)
-			memcpy(buf + buf_off, addr + bio_off + bv.bv_offset,
-				size);
-		else
-			memcpy(addr + bio_off + bv.bv_offset, buf + buf_off,
-				size);
-		kunmap_atomic(addr);
-		bio_off = 0;
-		buf_off += size;
-		len -= size;
-	}
-}
-
 static int dm_icomp_mod_to_max_io_range(struct dm_icomp_info *info,
 			 struct dm_icomp_io_range *io)
 {
@@ -1030,13 +1015,26 @@ static int dm_icomp_mod_to_max_io_range(struct dm_icomp_info *info,
 static struct dm_icomp_io_range *dm_icomp_create_io_write_range(
 		struct dm_icomp_req *req)
 {
-	struct dm_icomp_io_range *io;
 	struct bio *bio = req->bio;
 	sector_t size  = bio_sectors(req->bio)<<9;
 	int segments = bio_segments(bio);
 	int comp_len = dm_icomp_compressor_len(req->info, size);
 	void *addr;
+	struct dm_icomp_io_range *io = dm_icomp_create_io_range(req);
+
+	if (!io)
+		return NULL;
+
+	addr = dm_icomp_kmalloc(comp_len, GFP_NOIO);
+	if (!addr) {
+		kmem_cache_free(dm_icomp_io_range_cachep, io);
+		return NULL;
+	}
+	io->comp_data = io->io_req.mem.ptr.addr = addr;
+	io->comp_len = comp_len;
+	io->comp_kmap = false;
 
+	/* try reusing the bio buffer for decomp data. */
 	if (segments == 1) {
 		struct bio_vec bv = bio_iovec(bio);
 
@@ -1044,21 +1042,18 @@ static struct dm_icomp_io_range *dm_icomp_create_io_write_range(
 	} else
 		addr  = dm_icomp_kmalloc(size, GFP_NOIO);
 
-	if (!addr)
-		return NULL;
-
-	io = dm_icomp_create_io_range(req, comp_len);
-	if (!io) {
-		(segments == 1) ?  kunmap(addr) : dm_icomp_kfree(addr, size);
+	if (!addr) {
+		dm_icomp_kfree(io->comp_data, comp_len);
+		kmem_cache_free(dm_icomp_io_range_cachep, io);
 		return NULL;
 	}
-
 	io->decomp_data = io->decomp_real_data = addr;
 	io->decomp_len = size;
 
 	io->decomp_kmap = (segments == 1);
 	if (!io->decomp_kmap)
 		dm_icomp_bio_copy(req->bio, 0, io->decomp_data, size, true);
+
 	return io;
 }
 
@@ -1176,7 +1171,7 @@ static void dm_icomp_handle_read_decomp(struct dm_icomp_req *req)
 			src_off = (req->bio->bi_iter.bi_sector -
 				io->io_region.sector) << 9;
 
-		if (dm_icomp_update_io_read_range(io, req->bio, dst_off)) {
+		if (dm_icomp_update_io_read_range(io)) {
 			req->result = -EIO;
 			return;
 		}
diff --git a/drivers/md/dm-inplace-compress.h b/drivers/md/dm-inplace-compress.h
index e144e96..775ccbf 100644
--- a/drivers/md/dm-inplace-compress.h
+++ b/drivers/md/dm-inplace-compress.h
@@ -120,6 +120,7 @@ struct dm_icomp_io_range {
 	void *decomp_real_data; /* holds the actual start of the buffer */
 	unsigned int decomp_req_len;/* originally requested length */
 	unsigned int decomp_len; /* actual allocated/mapped length */
+	int comp_kmap;          /* Is the comp_data kmapped'? */
 	void *comp_data;
 	unsigned int comp_len; /* For write, this is estimated */
 	struct list_head next;
-- 
1.7.1
