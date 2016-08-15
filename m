From: Ram Pai <linuxram@us.ibm.com>
Subject: [RFC PATCH 02/16] DM: Ability to choose the compressor.
Date: Mon, 15 Aug 2016 10:36:39 -0700
Message-ID: <1471282613-31006-3-git-send-email-linuxram@us.ibm.com>
References: <1471282613-31006-1-git-send-email-linuxram@us.ibm.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1471282613-31006-1-git-send-email-linuxram@us.ibm.com>
Sender: linux-doc-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-doc@vger.kernel.org
Cc: shli@kernel.org, agk@redhat.com, snitzer@redhat.com, corbet@lwn.net, Ram Pai <linuxram@us.ibm.com>
List-Id: dm-devel.ids

Ability to create a block device with a compression algorithm of the users
choice. Currently lzo and nx842 compressors are supported.

If the compressor algorithm is not specified the default setting in
/sys/modules/dm-inplace-compress/parameters/compress is used.

Signed-off-by: Ram Pai <linuxram@us.ibm.com>
---
 drivers/md/dm-inplace-compress.c |  129 ++++++++++++++++++++++++++++----------
 drivers/md/dm-inplace-compress.h |    8 ++-
 2 files changed, 103 insertions(+), 34 deletions(-)

diff --git a/drivers/md/dm-inplace-compress.c b/drivers/md/dm-inplace-compress.c
index c3c3750..70d6c0e 100644
--- a/drivers/md/dm-inplace-compress.c
+++ b/drivers/md/dm-inplace-compress.c
@@ -20,8 +20,62 @@ static struct dm_icomp_compressor_data compressors[] = {
 		.name = "lzo",
 		.comp_len = lzo_comp_len,
 	},
+	[DMCP_COMP_ALG_842] = {
+		.name = "842",
+		.comp_len = nx842_comp_len,
+	},
+};
+static int default_compressor = -1;
+
+#define DMCP_ALGO_LENGTH 9
+static char dm_icomp_algorithm[DMCP_ALGO_LENGTH] = "lzo";
+static struct kparam_string dm_icomp_compressor_kparam = {
+	.string =	dm_icomp_algorithm,
+	.maxlen =	sizeof(dm_icomp_algorithm),
 };
-static int default_compressor;
+static int dm_icomp_compressor_param_set(const char *,
+		const struct kernel_param *);
+static struct kernel_param_ops dm_icomp_compressor_param_ops = {
+	.set =	dm_icomp_compressor_param_set,
+	.get =	param_get_string,
+};
+module_param_cb(compress_algorithm, &dm_icomp_compressor_param_ops,
+		&dm_icomp_compressor_kparam, 0644);
+
+static int dm_icomp_get_compressor(const char *s)
+{
+	int r, val_len;
+
+	if (crypto_has_comp(s, 0, 0)) {
+		for (r = 0; r < ARRAY_SIZE(compressors); r++) {
+			val_len = strlen(compressors[r].name);
+			if (strncmp(s, compressors[r].name, val_len) == 0)
+				return r;
+		}
+	}
+	return -1;
+}
+
+static int dm_icomp_compressor_param_set(const char *val,
+		const struct kernel_param *kp)
+{
+	int ret;
+	char str[kp->str->maxlen], *s;
+	int val_len = strlen(val)+1;
+
+	strlcpy(str, val, val_len);
+	s = strim(str);
+	ret = dm_icomp_get_compressor(s);
+	if (ret < 0) {
+		DMWARN("Compressor %s not supported", s);
+		return -1;
+	}
+	DMWARN("compressor  is %s", s);
+	default_compressor = ret;
+	strlcpy(dm_icomp_algorithm, compressors[ret].name,
+		sizeof(dm_icomp_algorithm));
+	return 0;
+}
 
 static struct kmem_cache *dm_icomp_req_cachep;
 static struct kmem_cache *dm_icomp_io_range_cachep;
@@ -417,7 +471,7 @@ static int dm_icomp_read_or_create_super(struct dm_icomp_info *info)
 			ret = -EINVAL;
 			goto out;
 		}
-		if (!crypto_has_comp(compressors[super->comp_alg].name, 0, 0)) {
+		if (!crypto_has_comp(compressors[info->comp_alg].name, 0, 0)) {
 			info->ti->error =
 					"Compressor algorithm doesn't support";
 			ret = -EINVAL;
@@ -436,7 +490,6 @@ static int dm_icomp_read_or_create_super(struct dm_icomp_info *info)
 		new_super = true;
 	}
 
-	info->comp_alg = super->comp_alg;
 	if (dm_icomp_alloc_compressor(info)) {
 		ret = -ENOMEM;
 		goto out;
@@ -467,50 +520,56 @@ out:
 }
 
 /*
- * <dev> <writethough>/<writeback> <meta_commit_delay>
+ * <dev> [ <writethough>/<writeback> <meta_commit_delay> ]
+ *	 [ <compressor> <type> ]
  */
 static int dm_icomp_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
 	struct dm_icomp_info *info;
-	char write_mode[15];
+	char mode[15];
+	int par = 0;
 	int ret, i;
 
-	if (argc < 2) {
-		ti->error = "Invalid argument count";
-		return -EINVAL;
-	}
-
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
 	if (!info) {
 		ti->error = "dm-inplace-compress: Cannot allocate context";
 		return -ENOMEM;
 	}
 	info->ti = ti;
-
-	if (sscanf(argv[1], "%s", write_mode) != 1) {
-		ti->error = "Invalid argument";
-		ret = -EINVAL;
-		goto err_para;
-	}
-
-	if (strcmp(write_mode, "writeback") == 0) {
-		if (argc != 3) {
+	info->comp_alg = default_compressor;
+	while (++par < argc) {
+		if (sscanf(argv[par], "%s", mode) != 1) {
 			ti->error = "Invalid argument";
 			ret = -EINVAL;
 			goto err_para;
 		}
-		info->write_mode = DMCP_WRITE_BACK;
-		if (sscanf(argv[2], "%u", &info->writeback_delay) != 1) {
-			ti->error = "Invalid argument";
-			ret = -EINVAL;
-			goto err_para;
+
+		if (strcmp(mode, "writeback") == 0) {
+			info->write_mode = DMCP_WRITE_BACK;
+			if (sscanf(argv[++par], "%u",
+				 &info->writeback_delay) != 1) {
+				ti->error = "Invalid argument";
+				ret = -EINVAL;
+				goto err_para;
+			}
+		} else if (strcmp(mode, "writethrough") == 0) {
+			info->write_mode = DMCP_WRITE_THROUGH;
+		} else if (strcmp(mode, "compressor") == 0) {
+			if (sscanf(argv[++par], "%s", mode) != 1) {
+				ti->error = "Invalid argument";
+				ret = -EINVAL;
+				goto err_para;
+			}
+			ret = dm_icomp_get_compressor(mode);
+			if (ret >= 0) {
+				DMWARN("compressor  is %s", mode);
+				info->comp_alg = ret;
+			} else {
+				ti->error = "Unsupported compressor";
+				ret = -EINVAL;
+				goto err_para;
+			}
 		}
-	} else if (strcmp(write_mode, "writethrough") == 0) {
-		info->write_mode = DMCP_WRITE_THROUGH;
-	} else {
-		ti->error = "Invalid argument";
-		ret = -EINVAL;
-		goto err_para;
 	}
 
 	if (dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
@@ -1407,16 +1466,20 @@ static struct target_type dm_icomp_target = {
 static int __init dm_icomp_init(void)
 {
 	int r;
+	int arr_size = ARRAY_SIZE(compressors);
 
-	for (r = 0; r < ARRAY_SIZE(compressors); r++)
+	for (r = 0; r < arr_size; r++)
 		if (crypto_has_comp(compressors[r].name, 0, 0))
 			break;
-	if (r >= ARRAY_SIZE(compressors)) {
+	if (r >= arr_size) {
 		DMWARN("No crypto compressors are supported");
 		return -EINVAL;
 	}
-
 	default_compressor = r;
+	strlcpy(dm_icomp_algorithm, compressors[r].name,
+			sizeof(dm_icomp_algorithm));
+	DMWARN(" %s crypto compressor used ",
+			compressors[default_compressor].name);
 
 	r = -ENOMEM;
 	dm_icomp_req_cachep = kmem_cache_create("dm_icomp_requests",
diff --git a/drivers/md/dm-inplace-compress.h b/drivers/md/dm-inplace-compress.h
index e07b9b7..b61ff0d 100644
--- a/drivers/md/dm-inplace-compress.h
+++ b/drivers/md/dm-inplace-compress.h
@@ -10,7 +10,8 @@ struct dm_icomp_super_block {
 	u8 comp_alg;
 } __packed;
 
-#define DMCP_COMP_ALG_LZO 0
+#define DMCP_COMP_ALG_LZO 1
+#define DMCP_COMP_ALG_842 0
 
 #ifdef __KERNEL__
 struct dm_icomp_compressor_data {
@@ -23,6 +24,11 @@ static inline int lzo_comp_len(int comp_len)
 	return lzo1x_worst_compress(comp_len);
 }
 
+static inline int nx842_comp_len(int comp_len)
+{
+	return comp_len;
+}
+
 /*
  * Minium logical sector size of this target is 4096 byte, which is a block.
  * Data of a block is compressed. Compressed data is round up to 512B, which is
-- 
1.7.1

