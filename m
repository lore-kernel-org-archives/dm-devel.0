From: Ram Pai <linuxram@us.ibm.com>
Subject: [RFC PATCH 10/16] DM: Try to use the bio buffer for
	decompression instead of allocating one.
Date: Mon, 15 Aug 2016 10:36:47 -0700
Message-ID: <1471282613-31006-11-git-send-email-linuxram@us.ibm.com>
References: <1471282613-31006-1-git-send-email-linuxram@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1471282613-31006-1-git-send-email-linuxram@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-doc@vger.kernel.org
Cc: shli@kernel.org, snitzer@redhat.com, agk@redhat.com, corbet@lwn.net
List-Id: dm-devel.ids

The read path allocates a temporary buffer to hold decompressed data, which is
than copied into the caller's bio buffer.

Instead of allocating a temporary buffer to hold the decompressed data,
decompress the data in the caller's bio buffer. This can be done only if the
destination in the bio-buffer is contigious within the same bio-segment.

Signed-off-by: Ram Pai <linuxram@us.ibm.com>
---
 drivers/md/dm-inplace-compress.c |  143 ++++++++++++++++++++++++++-----------
 drivers/md/dm-inplace-compress.h |    2 +
 2 files changed, 102 insertions(+), 43 deletions(-)

diff --git a/drivers/md/dm-inplace-compress.c b/drivers/md/dm-inplace-compress.c
index c56d9b7..f6b95e3 100644
--- a/drivers/md/dm-inplace-compress.c
+++ b/drivers/md/dm-inplace-compress.c
@@ -792,11 +792,34 @@ static void dm_icomp_kfree(void *addr, unsigned int size)
 	kfree(addr);
 }
 
+static void dm_icomp_release_decomp_buffer(struct dm_icomp_io_range *io)
+{
+	if (!io->decomp_data)
+		return;
 
-static void dm_icomp_free_io_range(struct dm_icomp_io_range *io)
+	if (io->decomp_kmap)
+		kunmap(io->decomp_real_data);
+	else
+		dm_icomp_kfree(io->decomp_real_data, io->decomp_req_len);
+	io->decomp_data = io->decomp_real_data = NULL;
+	io->decomp_len  = 0;
+	io->decomp_kmap = false;
+}
+
+static void dm_icomp_release_comp_buffer(struct dm_icomp_io_range *io)
 {
-	dm_icomp_kfree(io->decomp_data, io->decomp_len);
+	if (!io->comp_data)
+		return;
 	dm_icomp_kfree(io->comp_data, io->comp_len);
+
+	io->comp_data = NULL;
+	io->comp_len = 0;
+}
+
+static void dm_icomp_free_io_range(struct dm_icomp_io_range *io)
+{
+	dm_icomp_release_decomp_buffer(io);
+	dm_icomp_release_comp_buffer(io);
 	kmem_cache_free(dm_icomp_io_range_cachep, io);
 }
 
@@ -890,7 +913,9 @@ static struct dm_icomp_io_range *dm_icomp_create_io_range(
 	io->req = req;
 
 	io->decomp_data = NULL;
+	io->decomp_real_data = NULL;
 	io->decomp_len = 0;
+	io->decomp_kmap = false;
 	io->decomp_req_len = 0;
 	return io;
 }
@@ -909,15 +934,43 @@ static struct dm_icomp_io_range *dm_icomp_create_io_read_range(
 	return io;
 }
 
-static int dm_icomp_update_io_read_range(struct dm_icomp_io_range *io)
+static int dm_icomp_update_io_read_range(struct dm_icomp_io_range *io,
+		struct bio *bio, ssize_t bio_off)
 {
+	struct bvec_iter iter;
+	struct bio_vec bv;
+	bool just_use = false;
+
 	if (io->decomp_len)
 		return 0;
 
+	/* use a bio buffer long enough to hold the uncompressed data */
+	bio_for_each_segment(bv, bio, iter) {
+		int avail_len;
+		int length = bv.bv_len;
+
+		if (!just_use && bio_off >= length) {
+			bio_off -= length;
+			continue;
+		}
+		avail_len = just_use ? length : length-bio_off;
+		if (avail_len >= io->decomp_req_len) {
+			io->decomp_real_data = kmap(bv.bv_page);
+			io->decomp_data = io->decomp_real_data + bio_off;
+			io->decomp_len = io->decomp_req_len = avail_len;
+			io->decomp_kmap = true;
+			return 0;
+		}
+		just_use = true;
+	}
+
+	/* none available. :( Allocate one */
 	io->decomp_data = dm_icomp_kmalloc(io->decomp_req_len, GFP_NOIO);
 	if (!io->decomp_data)
 		return 1;
+	io->decomp_real_data = io->decomp_data;
 	io->decomp_len = io->decomp_req_len;
+	io->decomp_kmap = false;
 
 	return 0;
 }
@@ -978,24 +1031,34 @@ static struct dm_icomp_io_range *dm_icomp_create_io_write_range(
 		struct dm_icomp_req *req)
 {
 	struct dm_icomp_io_range *io;
+	struct bio *bio = req->bio;
 	sector_t size  = bio_sectors(req->bio)<<9;
+	int segments = bio_segments(bio);
 	int comp_len = dm_icomp_compressor_len(req->info, size);
 	void *addr;
 
-	addr  = dm_icomp_kmalloc(size, GFP_NOIO);
+	if (segments == 1) {
+		struct bio_vec bv = bio_iovec(bio);
+
+		addr = kmap(bv.bv_page);
+	} else
+		addr  = dm_icomp_kmalloc(size, GFP_NOIO);
+
 	if (!addr)
 		return NULL;
 
 	io = dm_icomp_create_io_range(req, comp_len);
 	if (!io) {
-		dm_icomp_kfree(addr, size);
+		(segments == 1) ?  kunmap(addr) : dm_icomp_kfree(addr, size);
 		return NULL;
 	}
 
-	io->decomp_data = addr;
+	io->decomp_data = io->decomp_real_data = addr;
 	io->decomp_len = size;
 
-	dm_icomp_bio_copy(req->bio, 0, io->decomp_data, size, true);
+	io->decomp_kmap = (segments == 1);
+	if (!io->decomp_kmap)
+		dm_icomp_bio_copy(req->bio, 0, io->decomp_data, size, true);
 	return io;
 }
 
@@ -1105,7 +1168,15 @@ static void dm_icomp_handle_read_decomp(struct dm_icomp_req *req)
 
 		io->io_region.sector -= req->info->data_start;
 
-		if (dm_icomp_update_io_read_range(io)) {
+		if (io->io_region.sector >=
+				req->bio->bi_iter.bi_sector)
+			dst_off = (io->io_region.sector -
+				req->bio->bi_iter.bi_sector) << 9;
+		else
+			src_off = (req->bio->bi_iter.bi_sector -
+				io->io_region.sector) << 9;
+
+		if (dm_icomp_update_io_read_range(io, req->bio, dst_off)) {
 			req->result = -EIO;
 			return;
 		}
@@ -1114,20 +1185,19 @@ static void dm_icomp_handle_read_decomp(struct dm_icomp_req *req)
 		ret = dm_icomp_io_range_decompress(req->info, io->comp_data,
 			io->comp_len, io->decomp_data, io->decomp_len);
 		if (ret < 0) {
+			dm_icomp_release_decomp_buffer(io);
+			dm_icomp_release_comp_buffer(io);
 			req->result = -EIO;
 			return;
 		}
 
-		if (io->io_region.sector >= req->bio->bi_iter.bi_sector)
-			dst_off = (io->io_region.sector -
-				 req->bio->bi_iter.bi_sector) << 9;
-		else
-			src_off = (req->bio->bi_iter.bi_sector -
-				 io->io_region.sector) << 9;
-
 		len = min_t(ssize_t, io->decomp_len - src_off,
 			(bio_sectors(req->bio) << 9) - dst_off);
 
+		dm_icomp_bio_copy(req->bio, dst_off,
+		  ((ret == 1) ? io->comp_data : io->decomp_data) + src_off,
+		  len, false);
+
 		/* io range in all_io list is ordered for read IO */
 		while (bio_off != dst_off) {
 			ssize_t size = min_t(ssize_t, PAGE_SIZE,
@@ -1137,13 +1207,9 @@ static void dm_icomp_handle_read_decomp(struct dm_icomp_req *req)
 			bio_off += size;
 		}
 
-		if (ret == 1)
-			dm_icomp_bio_copy(req->bio, dst_off,
-					io->comp_data + src_off, len, false);
-		else
-			dm_icomp_bio_copy(req->bio, dst_off,
-					io->decomp_data + src_off, len, false);
 		bio_off = dst_off + len;
+		dm_icomp_release_decomp_buffer(io);
+		dm_icomp_release_comp_buffer(io);
 	}
 
 	while (bio_off != (bio_sectors(req->bio) << 9)) {
@@ -1270,29 +1336,20 @@ static int dm_icomp_handle_write_modify(struct dm_icomp_io_range *io,
 	if (start < req->bio->bi_iter.bi_sector && start + count >
 					bio_end_sector(req->bio)) {
 		/* we don't split an extent */
-		if (ret == 1) {
-			memcpy(io->decomp_data, io->comp_data, io->decomp_len);
-			dm_icomp_bio_copy(req->bio, 0,
-			   io->decomp_data +
-			   ((req->bio->bi_iter.bi_sector - start) << 9),
-			   bio_sectors(req->bio) << 9, true);
-		} else {
-			dm_icomp_bio_copy(req->bio, 0,
-			   io->decomp_data +
-			   ((req->bio->bi_iter.bi_sector - start) << 9),
-			   bio_sectors(req->bio) << 9, true);
-
-			dm_icomp_kfree(io->comp_data, io->comp_len);
-			/* New compressed len might be bigger */
-			io->comp_data = dm_icomp_kmalloc(
-				dm_icomp_compressor_len(
-				req->info, io->decomp_len), GFP_NOIO);
-			io->comp_len = io->decomp_len;
-			if (!io->comp_data) {
-				req->result = -ENOMEM;
-				return -EIO;
+		if (!io->decomp_kmap) {
+			if (ret == 1) {
+				memcpy(io->decomp_data, io->comp_data,
+					io->decomp_len);
+				dm_icomp_bio_copy(req->bio, 0,
+				   io->decomp_data +
+				   ((req->bio->bi_iter.bi_sector - start) << 9),
+				   bio_sectors(req->bio) << 9, true);
+			} else {
+				dm_icomp_bio_copy(req->bio, 0,
+				   io->decomp_data +
+				   ((req->bio->bi_iter.bi_sector - start) << 9),
+				   bio_sectors(req->bio) << 9, true);
 			}
-			io->io_req.mem.ptr.addr = io->comp_data;
 		}
 		/* need compress data */
 		ret = 0;
diff --git a/drivers/md/dm-inplace-compress.h b/drivers/md/dm-inplace-compress.h
index d9cf05a..e144e96 100644
--- a/drivers/md/dm-inplace-compress.h
+++ b/drivers/md/dm-inplace-compress.h
@@ -115,7 +115,9 @@ struct dm_icomp_meta_io {
 struct dm_icomp_io_range {
 	struct dm_io_request io_req;
 	struct dm_io_region io_region;
+	int decomp_kmap;	/* Is the decomp_data kmapped'? */
 	void *decomp_data;
+	void *decomp_real_data; /* holds the actual start of the buffer */
 	unsigned int decomp_req_len;/* originally requested length */
 	unsigned int decomp_len; /* actual allocated/mapped length */
 	void *comp_data;
-- 
1.7.1
