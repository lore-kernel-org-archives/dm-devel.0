From: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Subject: [PATCH 5/5] dm verity: add support for version 0 of the on-disk format
Date: Tue, 11 Apr 2017 17:33:44 +0200
Message-ID: <20170411153344.27092-6-enric.balletbo@collabora.com>
References: <20170411153344.27092-1-enric.balletbo@collabora.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170411153344.27092-1-enric.balletbo@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jonathan Corbet <corbet@lwn.net>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Will Drewry <wad@chromium.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

From: Will Drewry <wad@chromium.org>

Version 0 of the on-disk format is compatible with the format used in the
Chromium OS. This patch adds support for this version.

Format type 0 is the original Chrome OS version, whereas the format type 1
is current version, but 0, the original format used in the Chromium OS is
still used in most devices. This patch adds support for the original
on-disk format so you can decide which want you want to use.

Signed-off-by: Will Drewry <wad@chromium.org>
Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
---
 drivers/md/dm-verity-target.c | 279 ++++++++++++++++++++++++++++++++----------
 init/do_mounts_dm.c           |  16 +--
 2 files changed, 220 insertions(+), 75 deletions(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 7335d8a..c098d22 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -17,6 +17,7 @@
 #include "dm-verity.h"
 #include "dm-verity-fec.h"
 
+#include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/reboot.h>
 
@@ -28,6 +29,7 @@
 #define DM_VERITY_DEFAULT_PREFETCH_SIZE	262144
 
 #define DM_VERITY_MAX_CORRUPTED_ERRS	100
+#define DM_VERITY_NUM_POSITIONAL_ARGS	10
 
 #define DM_VERITY_OPT_LOGGING		"ignore_corruption"
 #define DM_VERITY_OPT_RESTART		"restart_on_corruption"
@@ -46,6 +48,11 @@ struct dm_verity_prefetch_work {
 	unsigned n_blocks;
 };
 
+/* Controls whether verity_get_device will wait forever for a device. */
+static int dev_wait;
+module_param(dev_wait, int, 0444);
+MODULE_PARM_DESC(dev_wait, "Wait forever for a backing device");
+
 /*
  * Auxiliary structure appended to each dm-bufio buffer. If the value
  * hash_verified is nonzero, hash of the block has been verified.
@@ -803,6 +810,183 @@ static int verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v)
 	return r;
 }
 
+static int verity_get_device(struct dm_target *ti, const char *devname,
+			     struct dm_dev **dm_dev)
+{
+	do {
+		/* Try the normal path first since if everything is ready, it
+		 * will be the fastest.
+		 */
+		if (!dm_get_device(ti, devname, /*FMODE_READ*/
+				   dm_table_get_mode(ti->table), dm_dev))
+			return 0;
+
+		if (!dev_wait)
+			break;
+
+		/* No need to be too aggressive since this is a slow path. */
+		msleep(500);
+	} while (driver_probe_done() != 0 || !(*dm_dev));
+	return -1;
+}
+
+struct verity_args {
+	int version;
+	char *data_device;
+	char *hash_device;
+	int data_block_size_bits;
+	int hash_block_size_bits;
+	u64 num_data_blocks;
+	u64 hash_start_block;
+	char *algorithm;
+	char *digest;
+	char *salt;
+};
+
+static void pr_args(struct verity_args *args)
+{
+	printk(KERN_INFO "VERITY args: version=%d data_device=%s hash_device=%s"
+		" data_block_size_bits=%d hash_block_size_bits=%d"
+		" num_data_blocks=%lld hash_start_block=%lld"
+		" algorithm=%s digest=%s salt=%s\n",
+		args->version,
+		args->data_device,
+		args->hash_device,
+		args->data_block_size_bits,
+		args->hash_block_size_bits,
+		args->num_data_blocks,
+		args->hash_start_block,
+		args->algorithm,
+		args->digest,
+		args->salt);
+}
+
+/*
+ * positional_args - collects the argments using the positional
+ * parameters.
+ * arg# - parameter
+ *    0 - version
+ *    1 - data device
+ *    2 - hash device - may be same as data device
+ *    3 - data block size log2
+ *    4 - hash block size log2
+ *    5 - number of data blocks
+ *    6 - hash start block
+ *    7 - algorithm
+ *    8 - digest
+ *    9 - salt
+ */
+static char *positional_args(unsigned argc, char **argv,
+			     struct verity_args *args)
+{
+	unsigned int num;
+	unsigned long long num_ll;
+	char dummy;
+
+	if (argc < DM_VERITY_NUM_POSITIONAL_ARGS)
+		return "Invalid argument count: at least 10 arguments required";
+
+	if (sscanf(argv[0], "%d%c", &num, &dummy) != 1 ||
+	    num < 0 || num > 1)
+		return "Invalid version";
+	args->version = num;
+
+	args->data_device = argv[1];
+	args->hash_device = argv[2];
+
+	if (sscanf(argv[3], "%u%c", &num, &dummy) != 1 ||
+	    !num || (num & (num - 1)) ||
+	    num > PAGE_SIZE)
+		return "Invalid data device block size";
+	args->data_block_size_bits = ffs(num) - 1;
+
+	if (sscanf(argv[4], "%u%c", &num, &dummy) != 1 ||
+	    !num || (num & (num - 1)) ||
+	    num > INT_MAX)
+		return "Invalid hash device block size";
+	args->hash_block_size_bits = ffs(num) - 1;
+
+	if (sscanf(argv[5], "%llu%c", &num_ll, &dummy) != 1 ||
+	    (sector_t)(num_ll << (args->data_block_size_bits - SECTOR_SHIFT))
+	    >> (args->data_block_size_bits - SECTOR_SHIFT) != num_ll)
+		return "Invalid data blocks";
+	args->num_data_blocks = num_ll;
+
+	if (sscanf(argv[6], "%llu%c", &num_ll, &dummy) != 1 ||
+	    (sector_t)(num_ll << (args->hash_block_size_bits - SECTOR_SHIFT))
+	    >> (args->hash_block_size_bits - SECTOR_SHIFT) != num_ll)
+		return "Invalid hash start";
+	args->hash_start_block = num_ll;
+
+	args->algorithm = argv[7];
+	args->digest = argv[8];
+	args->salt = argv[9];
+
+	return NULL;
+}
+
+static void splitarg(char *arg, char **key, char **val)
+{
+	*key = strsep(&arg, "=");
+	*val = strsep(&arg, "");
+}
+
+static char *chromeos_args(unsigned int argc, char **argv,
+			   struct verity_args *args)
+{
+	char *key, *val;
+	unsigned long num;
+	int i;
+
+	args->version = 0;
+	args->data_block_size_bits = 12;
+	args->hash_block_size_bits = 12;
+	for (i = 0; i < argc; ++i) {
+		DMWARN("Argument %d: '%s'", i, argv[i]);
+		splitarg(argv[i], &key, &val);
+		if (!key) {
+			DMWARN("Bad argument %d: missing key?", i);
+			return "Bad argument: missing key";
+		}
+		if (!val) {
+			DMWARN("Bad argument %d='%s': missing value", i, key);
+			return "Bad argument: missing value";
+		}
+		if (!strcmp(key, "alg")) {
+			args->algorithm = val;
+		} else if (!strcmp(key, "payload")) {
+			args->data_device = val;
+		} else if (!strcmp(key, "hashtree")) {
+			args->hash_device = val;
+		} else if (!strcmp(key, "root_hexdigest")) {
+			args->digest = val;
+		} else if (!strcmp(key, "hashstart")) {
+			if (kstrtoul(val, 10, &num))
+				return "Invalid hashstart";
+			args->hash_start_block =
+			   num >> (args->hash_block_size_bits - SECTOR_SHIFT);
+			args->num_data_blocks = args->hash_start_block;
+		} else if (!strcmp(key, "salt")) {
+			args->salt = val;
+		}
+	}
+	if (!args->salt)
+		args->salt = "";
+
+#define NEEDARG(n) do { \
+	if (!(n)) { \
+		return "Missing argument: " #n; \
+	} } while (0)
+
+	NEEDARG(args->algorithm);
+	NEEDARG(args->data_device);
+	NEEDARG(args->hash_device);
+	NEEDARG(args->digest);
+
+#undef NEEDARG
+	return NULL;
+}
+
 /*
  * Target parameters:
  *	<version>	The current format is version 1.
@@ -819,14 +1003,21 @@ static int verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v)
  */
 static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 {
+	struct verity_args args = { 0 };
 	struct dm_verity *v;
 	struct dm_arg_set as;
-	unsigned int num;
-	unsigned long long num_ll;
 	int r;
 	int i;
 	sector_t hash_position;
-	char dummy;
+
+	if (argc >= DM_VERITY_NUM_POSITIONAL_ARGS)
+		ti->error = positional_args(argc, argv, &args);
+	else
+		ti->error = chromeos_args(argc, argv, &args);
+	if (ti->error)
+		return -EINVAL;
+	if (0)
+		pr_args(&args);
 
 	v = kzalloc(sizeof(struct dm_verity), GFP_KERNEL);
 	if (!v) {
@@ -840,83 +1031,46 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	if (r)
 		goto bad;
 
-	if ((dm_table_get_mode(ti->table) & ~FMODE_READ)) {
-		ti->error = "Device must be readonly";
-		r = -EINVAL;
-		goto bad;
-	}
+	v->version = args.version;
 
-	if (argc < 10) {
-		ti->error = "Not enough arguments";
-		r = -EINVAL;
-		goto bad;
-	}
-
-	if (sscanf(argv[0], "%u%c", &num, &dummy) != 1 ||
-	    num > 1) {
-		ti->error = "Invalid version";
-		r = -EINVAL;
-		goto bad;
-	}
-	v->version = num;
-
-	r = dm_get_device(ti, argv[1], FMODE_READ, &v->data_dev);
+	r = verity_get_device(ti, args.data_device, &v->data_dev);
 	if (r) {
 		ti->error = "Data device lookup failed";
 		goto bad;
 	}
 
-	r = dm_get_device(ti, argv[2], FMODE_READ, &v->hash_dev);
+	r = verity_get_device(ti, args.hash_device, &v->hash_dev);
 	if (r) {
 		ti->error = "Hash device lookup failed";
 		goto bad;
 	}
 
-	if (sscanf(argv[3], "%u%c", &num, &dummy) != 1 ||
-	    !num || (num & (num - 1)) ||
-	    num < bdev_logical_block_size(v->data_dev->bdev) ||
-	    num > PAGE_SIZE) {
+	v->data_dev_block_bits = args.data_block_size_bits;
+	if ((1 << v->data_dev_block_bits) <
+	    bdev_logical_block_size(v->data_dev->bdev)) {
 		ti->error = "Invalid data device block size";
 		r = -EINVAL;
 		goto bad;
 	}
-	v->data_dev_block_bits = __ffs(num);
 
-	if (sscanf(argv[4], "%u%c", &num, &dummy) != 1 ||
-	    !num || (num & (num - 1)) ||
-	    num < bdev_logical_block_size(v->hash_dev->bdev) ||
-	    num > INT_MAX) {
+	v->hash_dev_block_bits = args.hash_block_size_bits;
+	if ((1 << v->data_dev_block_bits) <
+	    bdev_logical_block_size(v->hash_dev->bdev)) {
 		ti->error = "Invalid hash device block size";
 		r = -EINVAL;
 		goto bad;
 	}
-	v->hash_dev_block_bits = __ffs(num);
-
-	if (sscanf(argv[5], "%llu%c", &num_ll, &dummy) != 1 ||
-	    (sector_t)(num_ll << (v->data_dev_block_bits - SECTOR_SHIFT))
-	    >> (v->data_dev_block_bits - SECTOR_SHIFT) != num_ll) {
-		ti->error = "Invalid data blocks";
-		r = -EINVAL;
-		goto bad;
-	}
-	v->data_blocks = num_ll;
 
+	v->data_blocks = args.num_data_blocks;
 	if (ti->len > (v->data_blocks << (v->data_dev_block_bits - SECTOR_SHIFT))) {
 		ti->error = "Data device is too small";
 		r = -EINVAL;
 		goto bad;
 	}
 
-	if (sscanf(argv[6], "%llu%c", &num_ll, &dummy) != 1 ||
-	    (sector_t)(num_ll << (v->hash_dev_block_bits - SECTOR_SHIFT))
-	    >> (v->hash_dev_block_bits - SECTOR_SHIFT) != num_ll) {
-		ti->error = "Invalid hash start";
-		r = -EINVAL;
-		goto bad;
-	}
-	v->hash_start = num_ll;
+	v->hash_start = args.hash_start_block;
 
-	v->alg_name = kstrdup(argv[7], GFP_KERNEL);
+	v->alg_name = kstrdup(args.algorithm, GFP_KERNEL);
 	if (!v->alg_name) {
 		ti->error = "Cannot allocate algorithm name";
 		r = -ENOMEM;
@@ -945,36 +1099,33 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		r = -ENOMEM;
 		goto bad;
 	}
-	if (strlen(argv[8]) != v->digest_size * 2 ||
-	    hex2bin(v->root_digest, argv[8], v->digest_size)) {
+	if (strlen(args.digest) != v->digest_size * 2 ||
+	    hex2bin(v->root_digest, args.digest, v->digest_size)) {
 		ti->error = "Invalid root digest";
 		r = -EINVAL;
 		goto bad;
 	}
 
-	if (strcmp(argv[9], "-")) {
-		v->salt_size = strlen(argv[9]) / 2;
+	if (strcmp(args.salt, "-")) {
+		v->salt_size = strlen(args.salt) / 2;
 		v->salt = kmalloc(v->salt_size, GFP_KERNEL);
 		if (!v->salt) {
 			ti->error = "Cannot allocate salt";
 			r = -ENOMEM;
 			goto bad;
 		}
-		if (strlen(argv[9]) != v->salt_size * 2 ||
-		    hex2bin(v->salt, argv[9], v->salt_size)) {
+		if (strlen(args.salt) != v->salt_size * 2 ||
+		    hex2bin(v->salt, args.salt, v->salt_size)) {
 			ti->error = "Invalid salt";
 			r = -EINVAL;
 			goto bad;
 		}
 	}
 
-	argv += 10;
-	argc -= 10;
-
 	/* Optional parameters */
-	if (argc) {
-		as.argc = argc;
-		as.argv = argv;
+	if (argc > DM_VERITY_NUM_POSITIONAL_ARGS) {
+		as.argc = argc - DM_VERITY_NUM_POSITIONAL_ARGS;
+		as.argv = argv + DM_VERITY_NUM_POSITIONAL_ARGS;
 
 		r = verity_parse_opt_args(&as, v);
 		if (r < 0)
diff --git a/init/do_mounts_dm.c b/init/do_mounts_dm.c
index 54c3299..25a040e 100644
--- a/init/do_mounts_dm.c
+++ b/init/do_mounts_dm.c
@@ -187,8 +187,7 @@ static char * __init dm_parse_device(struct dm_device *dev, char *str)
 	if (opt.delim == DM_FIELD_SEP[0]) {
 		if (!get_dm_option(&opt, DM_LINE_SEP))
 			return NULL;
-		if (kstrtoul(opt.start, 10, &dev->num_targets))
-			dev->num_targets = 1;
+		dev->num_targets = simple_strtoul(opt.start, NULL, 10);
 	} else {
 		dev->num_targets = 1;
 	}
@@ -214,7 +213,7 @@ static char * __init dm_parse_targets(struct dm_device *dev, char *str)
 	 */
 	opt.next = str;
 	for (i = 0; i < num_targets; i++) {
-		*target = kzalloc(sizeof(*target), GFP_KERNEL);
+		*target = kzalloc(sizeof(struct dm_setup_target), GFP_KERNEL);
 		if (!*target) {
 			DMERR("failed to allocate memory for target %s<%ld>",
 			      dev->name, i);
@@ -227,18 +226,14 @@ static char * __init dm_parse_targets(struct dm_device *dev, char *str)
 			      " for target %s<%ld>", dev->name, i);
 			goto parse_fail;
 		}
-
-		if (kstrtoull(opt.start, 10, &(*target)->begin))
-			goto parse_fail;
+		(*target)->begin = simple_strtoull(opt.start, NULL, 10);
 
 		if (!get_dm_option(&opt, DM_FIELD_SEP)) {
 			DMERR("failed to parse length for target %s<%ld>",
 			      dev->name, i);
 			goto parse_fail;
 		}
-
-		if (kstrtoull(opt.start, 10, &(*target)->length))
-			goto parse_fail;
+		(*target)->length = simple_strtoull(opt.start, NULL, 10);
 
 		if (get_dm_option(&opt, DM_FIELD_SEP))
 			(*target)->type = kstrndup(opt.start, opt.len,
@@ -328,8 +323,7 @@ static int __init dm_setup(char *str)
 	if (!get_dm_option(&opt, DM_FIELD_SEP))
 		goto parse_fail;
 	if (isdigit(opt.start[0])) {	/* Optional number field */
-		if (kstrtoul(opt.start, 10, &num_devices))
-			num_devices = 1;
+		num_devices = simple_strtoul(opt.start, NULL, 10);
 		str = opt.next;
 	} else {
 		num_devices = 1;
-- 
2.9.3
