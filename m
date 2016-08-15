From: Ram Pai <linuxram@us.ibm.com>
Subject: [RFC PATCH 08/16] DM: Tag a magicmarker at the end of
	each compressed segment.
Date: Mon, 15 Aug 2016 10:36:45 -0700
Message-ID: <1471282613-31006-9-git-send-email-linuxram@us.ibm.com>
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

We store the size of the compressed segment, on the sector boundary. And later
use that location to determine the size of the compressed segment. However if
that location is corrupted for any reason we would'nt know. Hence add a
magicmarker to catch for such corruptions.

Signed-off-by: Ram Pai <linuxram@us.ibm.com>
---
 drivers/md/dm-inplace-compress.c |   24 ++++++++++++++++--------
 drivers/md/dm-inplace-compress.h |    1 +
 2 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-inplace-compress.c b/drivers/md/dm-inplace-compress.c
index fe4a4c1..04decdd 100644
--- a/drivers/md/dm-inplace-compress.c
+++ b/drivers/md/dm-inplace-compress.c
@@ -984,19 +984,21 @@ static int dm_icomp_io_range_compress(struct dm_icomp_info *info,
 		DMWARN("CO Error %d ", ret);
 
 	atomic64_add(decomp_len, &info->uncompressed_write_size);
-	if (ret || decomp_len < actual_comp_len + sizeof(u32) + 512) {
+	if (ret || decomp_len < actual_comp_len + 2*sizeof(u32) + 512) {
 		*comp_len = decomp_len;
 		atomic64_add(*comp_len, &info->compressed_write_size);
 		return 1;
 	}
 
 	*comp_len = round_up(actual_comp_len, 512);
-	if (*comp_len - actual_comp_len < sizeof(u32))
+	if (*comp_len - actual_comp_len < 2*sizeof(u32))
 		*comp_len += 512;
 	atomic64_add(*comp_len, &info->compressed_write_size);
 	addr = io->comp_data + *comp_len;
 	addr--;
 	*addr = cpu_to_le32(actual_comp_len);
+	addr--;
+	*addr = cpu_to_le32(DMCP_COMPRESS_MAGIC);
 	return 0;
 }
 
@@ -1020,13 +1022,19 @@ static int dm_icomp_io_range_decompress(struct dm_icomp_info *info,
 	addr = comp_data + comp_len;
 	addr--;
 	comp_len = le32_to_cpu(*addr);
+	addr--;
 
-	tfm = info->tfm[get_cpu()];
-	ret = crypto_comp_decompress(tfm, comp_data, comp_len,
-		decomp_data, &decomp_len);
-	put_cpu();
-	if (ret)
-		return -EINVAL;
+	if (comp_len == decomp_len)
+		return 1;
+	if (le32_to_cpu(*addr) == DMCP_COMPRESS_MAGIC) {
+		tfm = info->tfm[get_cpu()];
+		ret = crypto_comp_decompress(tfm, comp_data, comp_len,
+			decomp_data, &decomp_len);
+		put_cpu();
+		if (ret)
+			return -EINVAL;
+	} else
+		memset(decomp_data, 0, decomp_len);
 	return 0;
 }
 
diff --git a/drivers/md/dm-inplace-compress.h b/drivers/md/dm-inplace-compress.h
index 86c0ce6..1ce7a6e 100644
--- a/drivers/md/dm-inplace-compress.h
+++ b/drivers/md/dm-inplace-compress.h
@@ -3,6 +3,7 @@
 #include <linux/types.h>
 
 #define DMCP_SUPER_MAGIC 0x106526c206506c09
+#define DMCP_COMPRESS_MAGIC 0xfaceecaf
 struct dm_icomp_super_block {
 	__le64 magic;
 	__le64 meta_blocks;
-- 
1.7.1
