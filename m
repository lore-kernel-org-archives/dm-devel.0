From: Sami Tolvanen <samitolvanen@google.com>
Subject: [PATCH] dm-verity: Add error handling modes for
	corrupted blocks
Date: Mon, 16 Mar 2015 15:55:59 +0000
Message-ID: <20150316155559.GA32397@google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: mpatocka@redhat.com, msb@chromium.org, wad@chromium.org
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Add device specific modes to dm-verity to specify how corrupted
blocks should be handled. The following modes are defined:

  - DM_VERITY_MODE_EIO is the default behavior, where reading a
    corrupted block results in -EIO.

  - DM_VERITY_MODE_LOGGING only logs corrupted blocks, but does
    not block the read.

  - DM_VERITY_MODE_RESTART calls kernel_restart when a corrupted
    block is discovered.

In addition, each mode sends a uevent to notify userspace of
corruption and to allow further recovery actions.

The driver defaults to previous behavior (DM_VERITY_MODE_EIO)
and other modes can be enabled with an additional parameter to
the verity table.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

---
 Documentation/device-mapper/verity.txt |   15 ++++-
 drivers/md/dm-verity.c                 |   98 +++++++++++++++++++++++++++++----
 2 files changed, 103 insertions(+), 10 deletions(-)

diff --git a/Documentation/device-mapper/verity.txt b/Documentation/device-mapper/verity.txt
index 9884681..470f14c 100644
--- a/Documentation/device-mapper/verity.txt
+++ b/Documentation/device-mapper/verity.txt
@@ -10,7 +10,7 @@ Construction Parameters
     <version> <dev> <hash_dev>
     <data_block_size> <hash_block_size>
     <num_data_blocks> <hash_start_block>
-    <algorithm> <digest> <salt>
+    <algorithm> <digest> <salt> <mode>
 
 <version>
     This is the type of the on-disk hash format.
@@ -62,6 +62,19 @@ Construction Parameters
 <salt>
     The hexadecimal encoding of the salt value.
 
+<mode>
+    Optional. The mode of operation.
+
+    0 is the normal mode of operation where a corrupted block will result in an
+      I/O error.
+
+    1 is logging mode where corrupted blocks are logged, but the read operation
+      will still succeed normally.
+
+    2 is restart mode, where a corrupted block will result in the system being
+      immediately restarted.
+
+
 Theory of operation
 ===================
 
diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity.c
index 7a7bab8..ab72062 100644
--- a/drivers/md/dm-verity.c
+++ b/drivers/md/dm-verity.c
@@ -18,20 +18,36 @@
 
 #include <linux/module.h>
 #include <linux/device-mapper.h>
+#include <linux/reboot.h>
 #include <crypto/hash.h>
 
 #define DM_MSG_PREFIX			"verity"
 
+#define DM_VERITY_ENV_LENGTH		42
+#define DM_VERITY_ENV_VAR_NAME		"VERITY_ERR_BLOCK_NR"
+
 #define DM_VERITY_IO_VEC_INLINE		16
 #define DM_VERITY_MEMPOOL_SIZE		4
 #define DM_VERITY_DEFAULT_PREFETCH_SIZE	262144
 
 #define DM_VERITY_MAX_LEVELS		63
+#define DM_VERITY_MAX_CORRUPTED_ERRS	100
 
 static unsigned dm_verity_prefetch_cluster = DM_VERITY_DEFAULT_PREFETCH_SIZE;
 
 module_param_named(prefetch_cluster, dm_verity_prefetch_cluster, uint, S_IRUGO | S_IWUSR);
 
+enum verity_mode {
+	DM_VERITY_MODE_EIO = 0,
+	DM_VERITY_MODE_LOGGING = 1,
+	DM_VERITY_MODE_RESTART = 2
+};
+
+enum verity_block_type {
+	DM_VERITY_BLOCK_TYPE_DATA,
+	DM_VERITY_BLOCK_TYPE_METADATA
+};
+
 struct dm_verity {
 	struct dm_dev *data_dev;
 	struct dm_dev *hash_dev;
@@ -54,6 +70,8 @@ struct dm_verity {
 	unsigned digest_size;	/* digest size for the current hash algorithm */
 	unsigned shash_descsize;/* the size of temporary space for crypto */
 	int hash_failed;	/* set to 1 if hash of any block failed */
+	enum verity_mode mode;	/* mode for handling verification errors */
+	unsigned corrupted_errs;/* Number of errors for corrupted blocks */
 
 	mempool_t *vec_mempool;	/* mempool of bio vector */
 
@@ -175,6 +193,54 @@ static void verity_hash_at_level(struct dm_verity *v, sector_t block, int level,
 }
 
 /*
+ * Handle verification errors.
+ */
+static int verity_handle_err(struct dm_verity *v, enum verity_block_type type,
+				 unsigned long long block)
+{
+	char verity_env[DM_VERITY_ENV_LENGTH];
+	char *envp[] = { verity_env, NULL };
+	const char *type_str = "";
+	struct mapped_device *md = dm_table_get_md(v->ti->table);
+
+	if (v->corrupted_errs >= DM_VERITY_MAX_CORRUPTED_ERRS)
+		goto out;
+
+	++v->corrupted_errs;
+
+	switch (type) {
+	case DM_VERITY_BLOCK_TYPE_DATA:
+		type_str = "data";
+		break;
+	case DM_VERITY_BLOCK_TYPE_METADATA:
+		type_str = "metadata";
+		break;
+	default:
+		BUG();
+	}
+
+	DMERR_LIMIT("%s: %s block %llu is corrupted", v->data_dev->name,
+		type_str, block);
+
+	if (v->corrupted_errs == DM_VERITY_MAX_CORRUPTED_ERRS)
+		DMERR("%s: reached maximum errors", v->data_dev->name);
+
+	snprintf(verity_env, DM_VERITY_ENV_LENGTH, "%s=%d,%llu",
+		DM_VERITY_ENV_VAR_NAME, type, block);
+
+	kobject_uevent_env(&disk_to_dev(dm_disk(md))->kobj, KOBJ_CHANGE, envp);
+
+out:
+	if (v->mode == DM_VERITY_MODE_LOGGING)
+		return 0;
+
+	if (v->mode == DM_VERITY_MODE_RESTART)
+		kernel_restart("dm-verity device corrupted");
+
+	return 1;
+}
+
+/*
  * Verify hash of a metadata block pertaining to the specified data block
  * ("block" argument) at a specified level ("level" argument).
  *
@@ -251,11 +317,13 @@ static int verity_verify_level(struct dm_verity_io *io, sector_t block,
 			goto release_ret_r;
 		}
 		if (unlikely(memcmp(result, io_want_digest(v, io), v->digest_size))) {
-			DMERR_LIMIT("metadata block %llu is corrupted",
-				(unsigned long long)hash_block);
 			v->hash_failed = 1;
-			r = -EIO;
-			goto release_ret_r;
+
+			if (verity_handle_err(v, DM_VERITY_BLOCK_TYPE_METADATA,
+					      hash_block)) {
+				r = -EIO;
+				goto release_ret_r;
+			}
 		} else
 			aux->hash_verified = 1;
 	}
@@ -367,10 +435,11 @@ test_block_hash:
 			return r;
 		}
 		if (unlikely(memcmp(result, io_want_digest(v, io), v->digest_size))) {
-			DMERR_LIMIT("data block %llu is corrupted",
-				(unsigned long long)(io->block + b));
 			v->hash_failed = 1;
-			return -EIO;
+
+			if (verity_handle_err(v, DM_VERITY_BLOCK_TYPE_DATA,
+					      io->block + b))
+				return -EIO;
 		}
 	}
 
@@ -668,8 +737,8 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		goto bad;
 	}
 
-	if (argc != 10) {
-		ti->error = "Invalid argument count: exactly 10 arguments required";
+	if (argc < 10 || argc > 11) {
+		ti->error = "Invalid argument count: 10-11 arguments required";
 		r = -EINVAL;
 		goto bad;
 	}
@@ -790,6 +859,17 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		}
 	}
 
+	if (argc > 10) {
+		if (sscanf(argv[10], "%d%c", &num, &dummy) != 1 ||
+			num < DM_VERITY_MODE_EIO ||
+			num > DM_VERITY_MODE_RESTART) {
+			ti->error = "Invalid mode";
+			r = -EINVAL;
+			goto bad;
+		}
+		v->mode = num;
+	}
+
 	v->hash_per_block_bits =
 		__fls((1 << v->hash_dev_block_bits) / v->digest_size);
 
