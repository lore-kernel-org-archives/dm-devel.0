From: Ram Pai <linuxram@us.ibm.com>
Subject: [RFC PATCH 09/16] DM: Delay allocation of decompression buffer during read.
Date: Mon, 15 Aug 2016 10:36:46 -0700
Message-ID: <1471282613-31006-10-git-send-email-linuxram@us.ibm.com>
References: <1471282613-31006-1-git-send-email-linuxram@us.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1471282613-31006-1-git-send-email-linuxram@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-doc@vger.kernel.org
Cc: shli@kernel.org, agk@redhat.com, snitzer@redhat.com, corbet@lwn.net, Ram Pai <linuxram@us.ibm.com>
List-Id: dm-devel.ids

The read path allocates a temporary buffer each to hold compressed data and
decompressed data. The buffer to hold the decompressed data is not needed till
the compressed data is read from the device and is uncompressed.

Hence delay the allocation of decompress buffer till it is really needed.

Signed-off-by: Ram Pai <linuxram@us.ibm.com>
---
 drivers/md/dm-inplace-compress.c |   76 +++++++++++++++++++++++++++++++++-----
 drivers/md/dm-inplace-compress.h |    3 +-
 2 files changed, 68 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-inplace-compress.c b/drivers/md/dm-inplace-compress.c
index 04decdd..c56d9b7 100644
--- a/drivers/md/dm-inplace-compress.c
+++ b/drivers/md/dm-inplace-compress.c
@@ -863,7 +863,7 @@ static inline int dm_icomp_compressor_maxlen(struct dm_icomp_info *info,
  * comp_data
  */
 static struct dm_icomp_io_range *dm_icomp_create_io_range(
-	struct dm_icomp_req *req, int comp_len, int decomp_len)
+		struct dm_icomp_req *req, int comp_len)
 {
 	struct dm_icomp_io_range *io;
 
@@ -871,12 +871,8 @@ static struct dm_icomp_io_range *dm_icomp_create_io_range(
 	if (!io)
 		return NULL;
 
-	io->comp_data = dm_icomp_kmalloc(
-		dm_icomp_compressor_len(req->info, comp_len), GFP_NOIO);
-	io->decomp_data = dm_icomp_kmalloc(decomp_len, GFP_NOIO);
-	if (!io->decomp_data || !io->comp_data) {
-		dm_icomp_kfree(io->decomp_data, io->decomp_len);
-		dm_icomp_kfree(io->comp_data, io->comp_len);
+	io->comp_data = dm_icomp_kmalloc(comp_len, GFP_NOIO);
+	if (!io->comp_data) {
 		kmem_cache_free(dm_icomp_io_range_cachep, io);
 		return NULL;
 	}
@@ -890,12 +886,42 @@ static struct dm_icomp_io_range *dm_icomp_create_io_range(
 
 	io->io_region.bdev = req->info->dev->bdev;
 
-	io->decomp_len = decomp_len;
 	io->comp_len = comp_len;
 	io->req = req;
+
+	io->decomp_data = NULL;
+	io->decomp_len = 0;
+	io->decomp_req_len = 0;
 	return io;
 }
 
+static struct dm_icomp_io_range *dm_icomp_create_io_read_range(
+		struct dm_icomp_req *req, int comp_len, int decomp_len)
+{
+	struct dm_icomp_io_range *io = dm_icomp_create_io_range(req, comp_len);
+
+	if (io) {
+		/* note down the requested length for decompress buffer.
+		 * but dont allocate it yet.
+		 */
+		io->decomp_req_len = decomp_len;
+	}
+	return io;
+}
+
+static int dm_icomp_update_io_read_range(struct dm_icomp_io_range *io)
+{
+	if (io->decomp_len)
+		return 0;
+
+	io->decomp_data = dm_icomp_kmalloc(io->decomp_req_len, GFP_NOIO);
+	if (!io->decomp_data)
+		return 1;
+	io->decomp_len = io->decomp_req_len;
+
+	return 0;
+}
+
 static void dm_icomp_bio_copy(struct bio *bio, off_t bio_off, void *buf,
 		ssize_t len, bool to_buf)
 {
@@ -948,6 +974,31 @@ static int dm_icomp_mod_to_max_io_range(struct dm_icomp_info *info,
 	return 0;
 }
 
+static struct dm_icomp_io_range *dm_icomp_create_io_write_range(
+		struct dm_icomp_req *req)
+{
+	struct dm_icomp_io_range *io;
+	sector_t size  = bio_sectors(req->bio)<<9;
+	int comp_len = dm_icomp_compressor_len(req->info, size);
+	void *addr;
+
+	addr  = dm_icomp_kmalloc(size, GFP_NOIO);
+	if (!addr)
+		return NULL;
+
+	io = dm_icomp_create_io_range(req, comp_len);
+	if (!io) {
+		dm_icomp_kfree(addr, size);
+		return NULL;
+	}
+
+	io->decomp_data = addr;
+	io->decomp_len = size;
+
+	dm_icomp_bio_copy(req->bio, 0, io->decomp_data, size, true);
+	return io;
+}
+
 /*
  * return value:
  * < 0 : error
@@ -1054,6 +1105,11 @@ static void dm_icomp_handle_read_decomp(struct dm_icomp_req *req)
 
 		io->io_region.sector -= req->info->data_start;
 
+		if (dm_icomp_update_io_read_range(io)) {
+			req->result = -EIO;
+			return;
+		}
+
 		/* Do decomp here */
 		ret = dm_icomp_io_range_decompress(req->info, io->comp_data,
 			io->comp_len, io->decomp_data, io->decomp_len);
@@ -1110,7 +1166,7 @@ static void dm_icomp_read_one_extent(struct dm_icomp_req *req, u64 block,
 		return;
 	}
 
-	io = dm_icomp_create_io_range(req, data_sectors << 9,
+	io = dm_icomp_create_io_read_range(req, data_sectors << 9,
 		logical_sectors << 9);
 	if (!io) {
 		req->result = -EIO;
@@ -1313,7 +1369,7 @@ static void dm_icomp_handle_write_comp(struct dm_icomp_req *req)
 		goto update_meta;
 
 	count = bio_sectors(req->bio);
-	io = dm_icomp_create_io_range(req, count << 9, count << 9);
+	io = dm_icomp_create_io_write_range(req);
 	if (!io) {
 		req->result = -EIO;
 		return;
diff --git a/drivers/md/dm-inplace-compress.h b/drivers/md/dm-inplace-compress.h
index 1ce7a6e..d9cf05a 100644
--- a/drivers/md/dm-inplace-compress.h
+++ b/drivers/md/dm-inplace-compress.h
@@ -116,7 +116,8 @@ struct dm_icomp_io_range {
 	struct dm_io_request io_req;
 	struct dm_io_region io_region;
 	void *decomp_data;
-	unsigned int decomp_len;
+	unsigned int decomp_req_len;/* originally requested length */
+	unsigned int decomp_len; /* actual allocated/mapped length */
 	void *comp_data;
 	unsigned int comp_len; /* For write, this is estimated */
 	struct list_head next;
-- 
1.7.1
