From: Ram Pai <linuxram@us.ibm.com>
Subject: [RFC PATCH 06/16] DM: separate out compression and decompression routines.
Date: Mon, 15 Aug 2016 10:36:43 -0700
Message-ID: <1471282613-31006-7-git-send-email-linuxram@us.ibm.com>
References: <1471282613-31006-1-git-send-email-linuxram@us.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1471282613-31006-1-git-send-email-linuxram@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-doc@vger.kernel.org
Cc: shli@kernel.org, agk@redhat.com, snitzer@redhat.com, corbet@lwn.net, Ram Pai <linuxram@us.ibm.com>
List-Id: dm-devel.ids

Simplify the code by separating out the compression and decompression routines.

Signed-off-by: Ram Pai <linuxram@us.ibm.com>
---
 drivers/md/dm-inplace-compress.c |  127 +++++++++++++++++++++-----------------
 1 files changed, 71 insertions(+), 56 deletions(-)

diff --git a/drivers/md/dm-inplace-compress.c b/drivers/md/dm-inplace-compress.c
index c11567c..5c39169 100644
--- a/drivers/md/dm-inplace-compress.c
+++ b/drivers/md/dm-inplace-compress.c
@@ -793,8 +793,8 @@ static void dm_icomp_kfree(void *addr, unsigned int size)
 
 static void dm_icomp_free_io_range(struct dm_icomp_io_range *io)
 {
-	kfree(io->decomp_data);
-	kfree(io->comp_data);
+	dm_icomp_kfree(io->decomp_data, io->decomp_len);
+	dm_icomp_kfree(io->comp_data, io->comp_len);
 	kmem_cache_free(dm_icomp_io_range_cachep, io);
 }
 
@@ -861,12 +861,12 @@ static struct dm_icomp_io_range *dm_icomp_create_io_range(
 	if (!io)
 		return NULL;
 
-	io->comp_data = kmalloc(dm_icomp_compressor_len(req->info, comp_len),
-								GFP_NOIO);
-	io->decomp_data = kmalloc(decomp_len, GFP_NOIO);
+	io->comp_data = dm_icomp_kmalloc(
+		dm_icomp_compressor_len(req->info, comp_len), GFP_NOIO);
+	io->decomp_data = dm_icomp_kmalloc(decomp_len, GFP_NOIO);
 	if (!io->decomp_data || !io->comp_data) {
-		kfree(io->decomp_data);
-		kfree(io->comp_data);
+		dm_icomp_kfree(io->decomp_data, io->decomp_len);
+		dm_icomp_kfree(io->comp_data, io->comp_len);
 		kmem_cache_free(dm_icomp_io_range_cachep, io);
 		return NULL;
 	}
@@ -928,51 +928,66 @@ static void dm_icomp_bio_copy(struct bio *bio, off_t bio_off, void *buf,
  * We store the actual compressed len in the last u32 of the payload.
  * If there is no free space, we add 512 to the payload size.
  */
-static int dm_icomp_io_range_comp(struct dm_icomp_info *info, void *comp_data,
-	unsigned int *comp_len, void *decomp_data, unsigned int decomp_len,
-	bool do_comp)
+static int dm_icomp_io_range_compress(struct dm_icomp_info *info,
+		struct dm_icomp_io_range *io, unsigned int *comp_len,
+		void *decomp_data, unsigned int decomp_len)
 {
-	struct crypto_comp *tfm;
+	unsigned int actual_comp_len = io->comp_len;
 	u32 *addr;
-	unsigned int actual_comp_len;
+	struct crypto_comp *tfm =  info->tfm[get_cpu()];
 	int ret;
 
-	if (do_comp) {
-		actual_comp_len = *comp_len;
-
-		tfm = info->tfm[get_cpu()];
-		ret = crypto_comp_compress(tfm, decomp_data, decomp_len,
-			comp_data, &actual_comp_len);
-		put_cpu();
+	ret = crypto_comp_compress(tfm, decomp_data, decomp_len,
+		io->comp_data, &actual_comp_len);
 
-		atomic64_add(decomp_len, &info->uncompressed_write_size);
-		if (ret || decomp_len < actual_comp_len + sizeof(u32) + 512) {
-			*comp_len = decomp_len;
-			atomic64_add(*comp_len, &info->compressed_write_size);
-			return 1;
-		}
+	put_cpu();
+	if (ret < 0)
+		DMWARN("CO Error %d ", ret);
 
-		*comp_len = round_up(actual_comp_len, 512);
-		if (*comp_len - actual_comp_len < sizeof(u32))
-			*comp_len += 512;
+	atomic64_add(decomp_len, &info->uncompressed_write_size);
+	if (ret || decomp_len < actual_comp_len + sizeof(u32) + 512) {
+		*comp_len = decomp_len;
 		atomic64_add(*comp_len, &info->compressed_write_size);
-		addr = comp_data + *comp_len;
-		addr--;
-		*addr = cpu_to_le32(actual_comp_len);
-	} else {
-		if (*comp_len == decomp_len)
-			return 1;
-		addr = comp_data + *comp_len;
-		addr--;
-		actual_comp_len = le32_to_cpu(*addr);
-
-		tfm = info->tfm[get_cpu()];
-		ret = crypto_comp_decompress(tfm, comp_data, actual_comp_len,
-			decomp_data, &decomp_len);
-		put_cpu();
-		if (ret)
-			return -EINVAL;
+		return 1;
 	}
+
+	*comp_len = round_up(actual_comp_len, 512);
+	if (*comp_len - actual_comp_len < sizeof(u32))
+		*comp_len += 512;
+	atomic64_add(*comp_len, &info->compressed_write_size);
+	addr = io->comp_data + *comp_len;
+	addr--;
+	*addr = cpu_to_le32(actual_comp_len);
+	return 0;
+}
+
+/*
+ * return value:
+ * < 0 : error
+ * == 0 : ok
+ * == 1 : ok, but comp/decomp is skipped
+ */
+static int dm_icomp_io_range_decompress(struct dm_icomp_info *info,
+	void *comp_data, unsigned int comp_len, void *decomp_data,
+	unsigned int decomp_len)
+{
+	struct crypto_comp *tfm;
+	u32 *addr;
+	int ret;
+
+	if (comp_len == decomp_len)
+		return 1;
+
+	addr = comp_data + comp_len;
+	addr--;
+	comp_len = le32_to_cpu(*addr);
+
+	tfm = info->tfm[get_cpu()];
+	ret = crypto_comp_decompress(tfm, comp_data, comp_len,
+		decomp_data, &decomp_len);
+	put_cpu();
+	if (ret)
+		return -EINVAL;
 	return 0;
 }
 
@@ -993,8 +1008,8 @@ static void dm_icomp_handle_read_decomp(struct dm_icomp_req *req)
 		io->io_region.sector -= req->info->data_start;
 
 		/* Do decomp here */
-		ret = dm_icomp_io_range_comp(req->info, io->comp_data,
-			&io->comp_len, io->decomp_data, io->decomp_len, false);
+		ret = dm_icomp_io_range_decompress(req->info, io->comp_data,
+			io->comp_len, io->decomp_data, io->decomp_len);
 		if (ret < 0) {
 			req->result = -EIO;
 			return;
@@ -1140,8 +1155,8 @@ static int dm_icomp_handle_write_modify(struct dm_icomp_io_range *io,
 	io->io_region.sector -= req->info->data_start;
 
 	/* decompress original data */
-	ret = dm_icomp_io_range_comp(req->info, io->comp_data, &io->comp_len,
-			io->decomp_data, io->decomp_len, false);
+	ret = dm_icomp_io_range_decompress(req->info, io->comp_data,
+		io->comp_len, io->decomp_data, io->decomp_len);
 	if (ret < 0) {
 		req->result = -EINVAL;
 		return -EIO;
@@ -1164,11 +1179,11 @@ static int dm_icomp_handle_write_modify(struct dm_icomp_io_range *io,
 			   ((req->bio->bi_iter.bi_sector - start) << 9),
 			   bio_sectors(req->bio) << 9, true);
 
-			kfree(io->comp_data);
+			dm_icomp_kfree(io->comp_data, io->comp_len);
 			/* New compressed len might be bigger */
-			io->comp_data = kmalloc(
-				dm_icomp_compressor_len(req->info,
-					io->decomp_len), GFP_NOIO);
+			io->comp_data = dm_icomp_kmalloc(
+				dm_icomp_compressor_len(
+				req->info, io->decomp_len), GFP_NOIO);
 			io->comp_len = io->decomp_len;
 			if (!io->comp_data) {
 				req->result = -ENOMEM;
@@ -1197,8 +1212,8 @@ static int dm_icomp_handle_write_modify(struct dm_icomp_io_range *io,
 
 	/* assume compress less data uses less space (at least 4k lsess data) */
 	comp_len = io->comp_len;
-	ret = dm_icomp_io_range_comp(req->info, io->comp_data, &comp_len,
-		io->decomp_data + (offset << 9), count << 9, true);
+	ret = dm_icomp_io_range_compress(req->info, io, &comp_len,
+		io->decomp_data + (offset << 9), count << 9);
 	if (ret < 0) {
 		req->result = -EIO;
 		return -EIO;
@@ -1260,8 +1275,8 @@ static void dm_icomp_handle_write_comp(struct dm_icomp_req *req)
 
 	/* compress data */
 	comp_len = io->comp_len;
-	ret = dm_icomp_io_range_comp(req->info, io->comp_data, &comp_len,
-		io->decomp_data, count << 9, true);
+	ret = dm_icomp_io_range_compress(req->info, io, &comp_len,
+			io->decomp_data, count << 9);
 	if (ret < 0) {
 		dm_icomp_free_io_range(io);
 		req->result = -EIO;
-- 
1.7.1
