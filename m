Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55ADB1849;
	Fri,  4 Oct 2024 00:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728002662; cv=none; b=fN1rwZH5W2vq7cXVVJMkctxpR9HOyhB4JBQy1YDYiUk69DKdU2wzxFzEO2wadzHw1TqNUCXma2TdioaKGYa0iRvEUPtwk93hnI47MHnR2eEecnM11GlMXDuIb6YPHWIoZan4MwnWYKQJA1S156MwekEuMUGDlvC5gWFymfU4BFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728002662; c=relaxed/simple;
	bh=Ut0qGry4AC6vjLBNGtjpvD9uIpEghwri6/+jpMKnDZI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JcXmqy5EZdR7zCTc7uPmFo8L4nAeUDpoBY8c3HkY68VsMC0QhM2kLCYrWuL8Bb1cC6T0Rwfxs6ovPoU4w/qOxIZ9NjpT5U384jy3u6h4D+znprOVuVnX0PhoKkSGxW50AVGObmCvKK++eQG9JlbZMXNJ70l/YtyvmG1M94tw3xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mvuvp/XZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mvuvp/XZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7080C4CEC5;
	Fri,  4 Oct 2024 00:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728002662;
	bh=Ut0qGry4AC6vjLBNGtjpvD9uIpEghwri6/+jpMKnDZI=;
	h=From:To:Cc:Subject:Date:From;
	b=Mvuvp/XZMyFohtnNkUH4+xSSk5aeuJ85StJFtejSarmN9PTYA2UnU5tEfBhB65NL9
	 SAMz409m6IQiGeayqGGjyhCznwO5D1lZTwpj2X2uMmslWiV0ooW9MmwjMuITugaFNX
	 b4RSoytpIDHe2wOf7IygTUdKgjsk56mB5ka7l+r3N9c0dLzN1lszrXdPc2bLX/+ong
	 UqZBrJNzOfJdFGaM8FXu4gNi82QJ68i+XQV0+IkOs7N3k1eDJ1EWn4723F47o0Ip2J
	 4BZVFnL25k+mSF8IG50rHuko5+I9mLn0YdK5gfw+b6nFR5lbdGcF9o9s664Zo4eZiN
	 BciGQiLWTGirw==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Md Sadre Alam <quic_mdalam@quicinc.com>,
	Israel Rukshin <israelr@nvidia.com>
Subject: [RFC PATCH] dm-inlinecrypt: add target for inline block device encryption
Date: Thu,  3 Oct 2024 17:41:52 -0700
Message-ID: <20241004004152.8845-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.46.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Add a new device-mapper target "dm-inlinecrypt" that is similar to
dm-crypt but uses the blk-crypto API instead of the regular crypto API.
This allows it to take advantage of inline encryption hardware such as
that commonly built into UFS host controllers.

The table syntax matches dm-crypt's, but for now only a stripped-down
set of parameters is supported.  For example, for now AES-256-XTS is the
only supported cipher.

dm-inlinecrypt is based on Android's dm-default-key with the
controversial passthrough support removed.  Note that due to the removal
of passthrough support, use of dm-inlinecrypt in combination with
fscrypt causes double encryption of file contents (similar to dm-crypt +
fscrypt), with the fscrypt layer not being able to use the inline
encryption hardware.  This makes dm-inlinecrypt unusable on systems such
as Android that use fscrypt and where a more optimized approach is
needed.  It is however suitable as a replacement for dm-crypt.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---

This is yet another proposal for dm-inlinecrypt, this one resulting from
the conversation at
https://lore.kernel.org/linux-block/20240916085741.1636554-2-quic_mdalam@quicinc.com/T/#u.
This brings in the work that was already done in Android's
dm-default-key but drops the passthrough support, as it doesn't seem
like that will go anywhere upstream anytime soon.  This makes the
proposal suitable as a replacement for dm-crypt only.

 block/blk-crypto.c          |   3 +
 drivers/md/Kconfig          |  10 +
 drivers/md/Makefile         |   1 +
 drivers/md/dm-inlinecrypt.c | 415 ++++++++++++++++++++++++++++++++++++
 4 files changed, 429 insertions(+)
 create mode 100644 drivers/md/dm-inlinecrypt.c

diff --git a/block/blk-crypto.c b/block/blk-crypto.c
index 4d760b092deb..5a121b1292f9 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -104,10 +104,11 @@ void bio_crypt_set_ctx(struct bio *bio, const struct blk_crypto_key *key,
 	bc->bc_key = key;
 	memcpy(bc->bc_dun, dun, sizeof(bc->bc_dun));
 
 	bio->bi_crypt_context = bc;
 }
+EXPORT_SYMBOL_GPL(bio_crypt_set_ctx);
 
 void __bio_crypt_free_ctx(struct bio *bio)
 {
 	mempool_free(bio->bi_crypt_context, bio_crypt_ctx_pool);
 	bio->bi_crypt_context = NULL;
@@ -354,10 +355,11 @@ int blk_crypto_init_key(struct blk_crypto_key *blk_key, const u8 *raw_key,
 	blk_key->size = mode->keysize;
 	memcpy(blk_key->raw, raw_key, mode->keysize);
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(blk_crypto_init_key);
 
 bool blk_crypto_config_supported_natively(struct block_device *bdev,
 					  const struct blk_crypto_config *cfg)
 {
 	return __blk_crypto_cfg_supported(bdev_get_queue(bdev)->crypto_profile,
@@ -396,10 +398,11 @@ int blk_crypto_start_using_key(struct block_device *bdev,
 {
 	if (blk_crypto_config_supported_natively(bdev, &key->crypto_cfg))
 		return 0;
 	return blk_crypto_fallback_start_using_mode(key->crypto_cfg.crypto_mode);
 }
+EXPORT_SYMBOL_GPL(blk_crypto_start_using_key);
 
 /**
  * blk_crypto_evict_key() - Evict a blk_crypto_key from a block_device
  * @bdev: a block_device on which I/O using the key may have been done
  * @key: the key to evict
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 1e9db8e4acdf..caed60097a21 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -268,10 +268,20 @@ config DM_CRYPT
 	  To compile this code as a module, choose M here: the module will
 	  be called dm-crypt.
 
 	  If unsure, say N.
 
+config DM_INLINECRYPT
+	tristate "Inline encryption target support"
+	depends on BLK_DEV_DM
+	depends on BLK_INLINE_ENCRYPTION
+	help
+	  This device-mapper target is similar to dm-crypt, but it uses the
+	  blk-crypto API instead of the regular crypto API. This allows it to
+	  take advantage of inline encryption hardware such as that commonly
+	  built into UFS host controllers.
+
 config DM_SNAPSHOT
        tristate "Snapshot target"
        depends on BLK_DEV_DM
        select DM_BUFIO
 	help
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 476a214e4bdc..6e44ff32b8af 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -49,10 +49,11 @@ obj-$(CONFIG_BLK_DEV_DM)	+= dm-mod.o
 obj-$(CONFIG_BLK_DEV_DM_BUILTIN) += dm-builtin.o
 obj-$(CONFIG_DM_UNSTRIPED)	+= dm-unstripe.o
 obj-$(CONFIG_DM_BUFIO)		+= dm-bufio.o
 obj-$(CONFIG_DM_BIO_PRISON)	+= dm-bio-prison.o
 obj-$(CONFIG_DM_CRYPT)		+= dm-crypt.o
+obj-$(CONFIG_DM_INLINECRYPT)	+= dm-inlinecrypt.o
 obj-$(CONFIG_DM_DELAY)		+= dm-delay.o
 obj-$(CONFIG_DM_DUST)		+= dm-dust.o
 obj-$(CONFIG_DM_FLAKEY)		+= dm-flakey.o
 obj-$(CONFIG_DM_MULTIPATH)	+= dm-multipath.o dm-round-robin.o
 obj-$(CONFIG_DM_MULTIPATH_QL)	+= dm-queue-length.o
diff --git a/drivers/md/dm-inlinecrypt.c b/drivers/md/dm-inlinecrypt.c
new file mode 100644
index 000000000000..1330db1bb48c
--- /dev/null
+++ b/drivers/md/dm-inlinecrypt.c
@@ -0,0 +1,415 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright 2024 Google LLC
+ */
+
+#include <linux/blk-crypto.h>
+#include <linux/device-mapper.h>
+#include <linux/module.h>
+
+#define DM_MSG_PREFIX	"inlinecrypt"
+
+static const struct dm_inlinecrypt_cipher {
+	const char *name;
+	enum blk_crypto_mode_num mode_num;
+	int key_size;
+} dm_inlinecrypt_ciphers[] = {
+	{
+		.name = "aes-xts-plain64",
+		.mode_num = BLK_ENCRYPTION_MODE_AES_256_XTS,
+		.key_size = 64,
+	},
+};
+
+/**
+ * struct inlinecrypt_ctx - private data of an inlinecrypt target
+ * @dev: the underlying device
+ * @start: starting sector of the range of @dev which this target actually maps.
+ *	   For this purpose a "sector" is 512 bytes.
+ * @cipher_string: the name of the encryption algorithm being used
+ * @iv_offset: starting offset for IVs.  IVs are generated as if the target were
+ *	       preceded by @iv_offset 512-byte sectors.
+ * @sector_size: crypto sector size in bytes (usually 4096)
+ * @sector_bits: log2(sector_size)
+ * @key: the encryption key to use
+ * @max_dun: the maximum DUN that may be used (computed from other params)
+ */
+struct inlinecrypt_ctx {
+	struct dm_dev *dev;
+	sector_t start;
+	const char *cipher_string;
+	u64 iv_offset;
+	unsigned int sector_size;
+	unsigned int sector_bits;
+	struct blk_crypto_key key;
+	u64 max_dun;
+};
+
+static const struct dm_inlinecrypt_cipher *
+lookup_cipher(const char *cipher_string)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(dm_inlinecrypt_ciphers); i++) {
+		if (strcmp(cipher_string, dm_inlinecrypt_ciphers[i].name) == 0)
+			return &dm_inlinecrypt_ciphers[i];
+	}
+	return NULL;
+}
+
+static void inlinecrypt_dtr(struct dm_target *ti)
+{
+	struct inlinecrypt_ctx *ctx = ti->private;
+
+	if (ctx->dev) {
+		blk_crypto_evict_key(ctx->dev->bdev, &ctx->key);
+		dm_put_device(ti, ctx->dev);
+	}
+	kfree_sensitive(ctx->cipher_string);
+	kfree_sensitive(ctx);
+}
+
+static int inlinecrypt_ctr_optional(struct dm_target *ti,
+				    unsigned int argc, char **argv)
+{
+	struct inlinecrypt_ctx *ctx = ti->private;
+	struct dm_arg_set as;
+	static const struct dm_arg _args[] = {
+		{0, 3, "Invalid number of feature args"},
+	};
+	unsigned int opt_params;
+	const char *opt_string;
+	bool iv_large_sectors = false;
+	char dummy;
+	int err;
+
+	as.argc = argc;
+	as.argv = argv;
+
+	err = dm_read_arg_group(_args, &as, &opt_params, &ti->error);
+	if (err)
+		return err;
+
+	while (opt_params--) {
+		opt_string = dm_shift_arg(&as);
+		if (!opt_string) {
+			ti->error = "Not enough feature arguments";
+			return -EINVAL;
+		}
+		if (!strcmp(opt_string, "allow_discards")) {
+			ti->num_discard_bios = 1;
+		} else if (sscanf(opt_string, "sector_size:%u%c",
+				  &ctx->sector_size, &dummy) == 1) {
+			if (ctx->sector_size < SECTOR_SIZE ||
+			    ctx->sector_size > 4096 ||
+			    !is_power_of_2(ctx->sector_size)) {
+				ti->error = "Invalid sector_size";
+				return -EINVAL;
+			}
+		} else if (!strcmp(opt_string, "iv_large_sectors")) {
+			iv_large_sectors = true;
+		} else {
+			ti->error = "Invalid feature arguments";
+			return -EINVAL;
+		}
+	}
+
+	/* dm-inlinecrypt doesn't implement iv_large_sectors=false. */
+	if (ctx->sector_size != SECTOR_SIZE && !iv_large_sectors) {
+		ti->error = "iv_large_sectors must be specified";
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/*
+ * Construct an inlinecrypt mapping:
+ * <cipher> <key> <iv_offset> <dev_path> <start>
+ *
+ * This syntax matches dm-crypt's, but the set of supported functionality has
+ * been stripped down.
+ */
+static int inlinecrypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
+{
+	struct inlinecrypt_ctx *ctx;
+	const struct dm_inlinecrypt_cipher *cipher;
+	u8 raw_key[BLK_CRYPTO_MAX_KEY_SIZE];
+	unsigned int dun_bytes;
+	unsigned long long tmpll;
+	char dummy;
+	int err;
+
+	if (argc < 5) {
+		ti->error = "Not enough arguments";
+		return -EINVAL;
+	}
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx) {
+		ti->error = "Out of memory";
+		return -ENOMEM;
+	}
+	ti->private = ctx;
+
+	/* <cipher> */
+	ctx->cipher_string = kstrdup(argv[0], GFP_KERNEL);
+	if (!ctx->cipher_string) {
+		ti->error = "Out of memory";
+		err = -ENOMEM;
+		goto bad;
+	}
+	cipher = lookup_cipher(ctx->cipher_string);
+	if (!cipher) {
+		ti->error = "Unsupported cipher";
+		err = -EINVAL;
+		goto bad;
+	}
+
+	/* <key> */
+	if (strlen(argv[1]) != 2 * cipher->key_size) {
+		ti->error = "Incorrect key size for cipher";
+		err = -EINVAL;
+		goto bad;
+	}
+	if (hex2bin(raw_key, argv[1], cipher->key_size) != 0) {
+		ti->error = "Malformed key string";
+		err = -EINVAL;
+		goto bad;
+	}
+
+	/* <iv_offset> */
+	if (sscanf(argv[2], "%llu%c", &ctx->iv_offset, &dummy) != 1) {
+		ti->error = "Invalid iv_offset sector";
+		err = -EINVAL;
+		goto bad;
+	}
+
+	/* <dev_path> */
+	err = dm_get_device(ti, argv[3], dm_table_get_mode(ti->table),
+			    &ctx->dev);
+	if (err) {
+		ti->error = "Device lookup failed";
+		goto bad;
+	}
+
+	/* <start> */
+	if (sscanf(argv[4], "%llu%c", &tmpll, &dummy) != 1 ||
+	    tmpll != (sector_t)tmpll) {
+		ti->error = "Invalid start sector";
+		err = -EINVAL;
+		goto bad;
+	}
+	ctx->start = tmpll;
+
+	/* optional arguments */
+	ctx->sector_size = SECTOR_SIZE;
+	if (argc > 5) {
+		err = inlinecrypt_ctr_optional(ti, argc - 5, &argv[5]);
+		if (err)
+			goto bad;
+	}
+	ctx->sector_bits = ilog2(ctx->sector_size);
+	if (ti->len & ((ctx->sector_size >> SECTOR_SHIFT) - 1)) {
+		ti->error = "Device size is not a multiple of sector_size";
+		err = -EINVAL;
+		goto bad;
+	}
+
+	ctx->max_dun = (ctx->iv_offset + ti->len - 1) >>
+		       (ctx->sector_bits - SECTOR_SHIFT);
+	dun_bytes = DIV_ROUND_UP(fls64(ctx->max_dun), 8);
+
+	err = blk_crypto_init_key(&ctx->key, raw_key, cipher->mode_num,
+				  dun_bytes, ctx->sector_size);
+	if (err) {
+		ti->error = "Error initializing blk-crypto key";
+		goto bad;
+	}
+
+	err = blk_crypto_start_using_key(ctx->dev->bdev, &ctx->key);
+	if (err) {
+		ti->error = "Error starting to use blk-crypto";
+		goto bad;
+	}
+
+	ti->num_flush_bios = 1;
+
+	err = 0;
+	goto out;
+
+bad:
+	inlinecrypt_dtr(ti);
+out:
+	memzero_explicit(raw_key, sizeof(raw_key));
+	return err;
+}
+
+static int inlinecrypt_map(struct dm_target *ti, struct bio *bio)
+{
+	const struct inlinecrypt_ctx *ctx = ti->private;
+	sector_t sector_in_target;
+	u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE] = { 0 };
+
+	bio_set_dev(bio, ctx->dev->bdev);
+
+	/*
+	 * If the bio is a device-level request which doesn't target a specific
+	 * sector, there's nothing more to do.
+	 */
+	if (bio_sectors(bio) == 0)
+		return DM_MAPIO_REMAPPED;
+
+	/*
+	 * The bio should never have an encryption context already, since
+	 * dm-inlinecrypt doesn't pass through any inline encryption
+	 * capabilities to the layer above it.
+	 */
+	if (WARN_ON_ONCE(bio_has_crypt_ctx(bio)))
+		return DM_MAPIO_KILL;
+
+	/* Map the bio's sector to the underlying device. (512-byte sectors) */
+	sector_in_target = dm_target_offset(ti, bio->bi_iter.bi_sector);
+	bio->bi_iter.bi_sector = ctx->start + sector_in_target;
+
+	/* Calculate the DUN and enforce data-unit (crypto sector) alignment. */
+	dun[0] = ctx->iv_offset + sector_in_target; /* 512-byte sectors */
+	if (dun[0] & ((ctx->sector_size >> SECTOR_SHIFT) - 1))
+		return DM_MAPIO_KILL;
+	dun[0] >>= ctx->sector_bits - SECTOR_SHIFT; /* crypto sectors */
+
+	/*
+	 * This check isn't necessary as we should have calculated max_dun
+	 * correctly, but be safe.
+	 */
+	if (WARN_ON_ONCE(dun[0] > ctx->max_dun))
+		return DM_MAPIO_KILL;
+
+	bio_crypt_set_ctx(bio, &ctx->key, dun, GFP_NOIO);
+
+	return DM_MAPIO_REMAPPED;
+}
+
+static void inlinecrypt_status(struct dm_target *ti, status_type_t type,
+			       unsigned int status_flags, char *result,
+			       unsigned int maxlen)
+{
+	const struct inlinecrypt_ctx *ctx = ti->private;
+	unsigned int sz = 0;
+	int num_feature_args = 0;
+
+	switch (type) {
+	case STATUSTYPE_INFO:
+	case STATUSTYPE_IMA:
+		result[0] = '\0';
+		break;
+
+	case STATUSTYPE_TABLE:
+		/* Omit the key for now. */
+		DMEMIT("%s - %llu %s %llu", ctx->cipher_string, ctx->iv_offset,
+		       ctx->dev->name, (unsigned long long)ctx->start);
+
+		num_feature_args += !!ti->num_discard_bios;
+		if (ctx->sector_size != SECTOR_SIZE)
+			num_feature_args += 2;
+		if (num_feature_args != 0) {
+			DMEMIT(" %d", num_feature_args);
+			if (ti->num_discard_bios)
+				DMEMIT(" allow_discards");
+			if (ctx->sector_size != SECTOR_SIZE) {
+				DMEMIT(" sector_size:%u", ctx->sector_size);
+				DMEMIT(" iv_large_sectors");
+			}
+		}
+		break;
+	}
+}
+
+static int inlinecrypt_prepare_ioctl(struct dm_target *ti,
+				     struct block_device **bdev)
+{
+	const struct inlinecrypt_ctx *ctx = ti->private;
+	const struct dm_dev *dev = ctx->dev;
+
+	*bdev = dev->bdev;
+
+	/* Only pass ioctls through if the device sizes match exactly. */
+	if (ctx->start != 0 ||
+	    ti->len != bdev_nr_sectors(dev->bdev))
+		return 1;
+	return 0;
+}
+
+static int inlinecrypt_iterate_devices(struct dm_target *ti,
+				       iterate_devices_callout_fn fn,
+				       void *data)
+{
+	const struct inlinecrypt_ctx *ctx = ti->private;
+
+	return fn(ti, ctx->dev, ctx->start, ti->len, data);
+}
+
+#ifdef CONFIG_BLK_DEV_ZONED
+static int inlinecrypt_report_zones(struct dm_target *ti,
+				    struct dm_report_zones_args *args,
+				    unsigned int nr_zones)
+{
+	const struct inlinecrypt_ctx *ctx = ti->private;
+
+	return dm_report_zones(ctx->dev->bdev, ctx->start,
+			ctx->start + dm_target_offset(ti, args->next_sector),
+			args, nr_zones);
+}
+#else
+#define inlinecrypt_report_zones NULL
+#endif
+
+static void inlinecrypt_io_hints(struct dm_target *ti,
+				 struct queue_limits *limits)
+{
+	const struct inlinecrypt_ctx *ctx = ti->private;
+	const unsigned int sector_size = ctx->sector_size;
+
+	limits->logical_block_size =
+		max_t(unsigned int, limits->logical_block_size, sector_size);
+	limits->physical_block_size =
+		max_t(unsigned int, limits->physical_block_size, sector_size);
+	limits->io_min = max_t(unsigned int, limits->io_min, sector_size);
+	limits->dma_alignment = limits->logical_block_size - 1;
+}
+
+static struct target_type inlinecrypt_target = {
+	.name			= "inlinecrypt",
+	.version		= {1, 0, 0},
+	/*
+	 * Do not set DM_TARGET_PASSES_CRYPTO, since dm-inlinecrypt consumes the
+	 * crypto capability itself.
+	 */
+	.features		= DM_TARGET_ZONED_HM,
+	.module			= THIS_MODULE,
+	.ctr			= inlinecrypt_ctr,
+	.dtr			= inlinecrypt_dtr,
+	.map			= inlinecrypt_map,
+	.status			= inlinecrypt_status,
+	.prepare_ioctl		= inlinecrypt_prepare_ioctl,
+	.iterate_devices	= inlinecrypt_iterate_devices,
+	.report_zones		= inlinecrypt_report_zones,
+	.io_hints		= inlinecrypt_io_hints,
+};
+
+static int __init dm_inlinecrypt_init(void)
+{
+	return dm_register_target(&inlinecrypt_target);
+}
+
+static void __exit dm_inlinecrypt_exit(void)
+{
+	dm_unregister_target(&inlinecrypt_target);
+}
+
+module_init(dm_inlinecrypt_init);
+module_exit(dm_inlinecrypt_exit);
+
+MODULE_AUTHOR("Eric Biggers <ebiggers@google.com>");
+MODULE_DESCRIPTION(DM_NAME " target for inline encryption");
+MODULE_LICENSE("GPL");

base-commit: e32cde8d2bd7d251a8f9b434143977ddf13dcec6
-- 
2.46.2

