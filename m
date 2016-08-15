From: Ram Pai <linuxram@us.ibm.com>
Subject: [RFC PATCH 07/16] DM: Optimize memory allocated to hold
	compressed buffer.
Date: Mon, 15 Aug 2016 10:36:44 -0700
Message-ID: <1471282613-31006-8-git-send-email-linuxram@us.ibm.com>
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

On an average the compressed size is less than 50% of the original buffer.  Use
this knowledge to optimize the amount of space allocated to hold the compressed
buffer. If the allocated size is determined to be insufficient than reallocate
the required size.

Signed-off-by: Ram Pai <linuxram@us.ibm.com>
---
 drivers/md/dm-inplace-compress.c |   39 ++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-inplace-compress.h |   11 ++++++++++
 2 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-inplace-compress.c b/drivers/md/dm-inplace-compress.c
index 5c39169..fe4a4c1 100644
--- a/drivers/md/dm-inplace-compress.c
+++ b/drivers/md/dm-inplace-compress.c
@@ -19,10 +19,12 @@ static struct dm_icomp_compressor_data compressors[] = {
 	[DMCP_COMP_ALG_LZO] = {
 		.name = "lzo",
 		.comp_len = lzo_comp_len,
+		.max_comp_len = lzo_max_comp_len,
 	},
 	[DMCP_COMP_ALG_842] = {
 		.name = "842",
 		.comp_len = nx842_comp_len,
+		.max_comp_len = nx842_max_comp_len,
 	},
 };
 static int default_compressor = -1;
@@ -848,6 +850,14 @@ static inline int dm_icomp_compressor_len(struct dm_icomp_info *info, int len)
 	return len;
 }
 
+static inline int dm_icomp_compressor_maxlen(struct dm_icomp_info *info,
+		int len)
+{
+	if (compressors[info->comp_alg].max_comp_len)
+		return compressors[info->comp_alg].max_comp_len(len);
+	return len;
+}
+
 /*
  * caller should set region.sector, region.count. bi_rw. IO always to/from
  * comp_data
@@ -919,6 +929,25 @@ static void dm_icomp_bio_copy(struct bio *bio, off_t bio_off, void *buf,
 	}
 }
 
+static int dm_icomp_mod_to_max_io_range(struct dm_icomp_info *info,
+			 struct dm_icomp_io_range *io)
+{
+	unsigned int maxlen = dm_icomp_compressor_maxlen(info, io->decomp_len);
+
+	if (maxlen <= io->comp_len)
+		return -ENOSPC;
+	io->io_req.mem.ptr.addr = io->comp_data =
+		dm_icomp_krealloc(io->comp_data, maxlen,
+			io->comp_len, GFP_NOIO);
+	if (!io->comp_data) {
+		DMWARN("UNFORTUNE allocation failure ");
+		io->comp_len = 0;
+		return -ENOSPC;
+	}
+	io->comp_len = maxlen;
+	return 0;
+}
+
 /*
  * return value:
  * < 0 : error
@@ -940,7 +969,17 @@ static int dm_icomp_io_range_compress(struct dm_icomp_info *info,
 	ret = crypto_comp_compress(tfm, decomp_data, decomp_len,
 		io->comp_data, &actual_comp_len);
 
+	if (ret || actual_comp_len > io->comp_len) {
+		ret = dm_icomp_mod_to_max_io_range(info, io);
+		if (!ret) {
+			actual_comp_len = io->comp_len;
+			ret = crypto_comp_compress(tfm, decomp_data, decomp_len,
+				io->comp_data, &actual_comp_len);
+		}
+	}
+
 	put_cpu();
+
 	if (ret < 0)
 		DMWARN("CO Error %d ", ret);
 
diff --git a/drivers/md/dm-inplace-compress.h b/drivers/md/dm-inplace-compress.h
index b61ff0d..86c0ce6 100644
--- a/drivers/md/dm-inplace-compress.h
+++ b/drivers/md/dm-inplace-compress.h
@@ -17,15 +17,26 @@ struct dm_icomp_super_block {
 struct dm_icomp_compressor_data {
 	char *name;
 	int (*comp_len)(int comp_len);
+	int (*max_comp_len)(int comp_len);
 };
 
 static inline int lzo_comp_len(int comp_len)
 {
+	return lzo1x_worst_compress(comp_len) >> 1;
+}
+
+static inline int lzo_max_comp_len(int comp_len)
+{
 	return lzo1x_worst_compress(comp_len);
 }
 
 static inline int nx842_comp_len(int comp_len)
 {
+	return (comp_len>>4)*7; /* less than half: 7/16 */
+}
+
+static inline int nx842_max_comp_len(int comp_len)
+{
 	return comp_len;
 }
 
-- 
1.7.1
