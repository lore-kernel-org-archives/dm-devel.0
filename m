Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 532AAC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 13 Jan 2022 18:24:31 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-642-NOFLYed3M4aji0YwTPA3Ng-1; Thu, 13 Jan 2022 13:24:26 -0500
X-MC-Unique: NOFLYed3M4aji0YwTPA3Ng-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 40B6783DD20;
	Thu, 13 Jan 2022 18:24:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2211E10A3945;
	Thu, 13 Jan 2022 18:24:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E9C674A7C8;
	Thu, 13 Jan 2022 18:24:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20DIH0bg007656 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 13 Jan 2022 13:17:00 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 345BE141DEDF; Thu, 13 Jan 2022 18:17:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2FA85141DEDD
	for <dm-devel@redhat.com>; Thu, 13 Jan 2022 18:17:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 11A623800E95
	for <dm-devel@redhat.com>; Thu, 13 Jan 2022 18:17:00 +0000 (UTC)
Received: from mellanox.co.il (mail-il-dmz.mellanox.com [193.47.165.129]) by
	relay.mimecast.com with ESMTP id us-mta-624-nEufeXH5OX6zbM5XjrYIQA-1;
	Thu, 13 Jan 2022 13:16:58 -0500
X-MC-Unique: nEufeXH5OX6zbM5XjrYIQA-1
Received: from Internal Mail-Server by MTLPINE1 (envelope-from
	israelr@nvidia.com) with SMTP; 13 Jan 2022 20:10:13 +0200
Received: from rsws47.mtr.labs.mlnx (rsws47.mtr.labs.mlnx [10.210.9.30])
	by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 20DIADSV009929;
	Thu, 13 Jan 2022 20:10:13 +0200
From: Israel Rukshin <israelr@nvidia.com>
To: dm-devel <dm-devel@redhat.com>
Date: Thu, 13 Jan 2022 20:09:01 +0200
Message-Id: <1642097341-6521-2-git-send-email-israelr@nvidia.com>
In-Reply-To: <1642097341-6521-1-git-send-email-israelr@nvidia.com>
References: <1642097341-6521-1-git-send-email-israelr@nvidia.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-loop: dm-devel@redhat.com
Cc: Israel Rukshin <israelr@nvidia.com>, Max Gurtovoy <mgurtovoy@nvidia.com>,
	Nitzan Carmi <nitzanc@nvidia.com>
Subject: [dm-devel] [PATCH 1/1] dm crypt: Add inline encryption support
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Using inline encryption means that the block layer handles the
decryption/encryption as part of the bio, instead of dm-crypt
doing the crypto by itself via Linux's crypto API. This model
is needed to take advantage of the inline encryption hardware
on the market.

To use inline encryption, the new dm-crypt optional parameter
"inline_crypt" should be set for the configured mapping. Afterwards,
dm-crypt will provide the crypto parameters to the block layer by
creating a cypto profile and by filling the bios with crypto context.
In case the block device or the fallback algorithm doesn't support
this feature, the mapping will fail.

Signed-off-by: Israel Rukshin <israelr@nvidia.com>
---
 block/blk-crypto.c    |   3 +
 drivers/md/dm-crypt.c | 202 ++++++++++++++++++++++++++++++++++++------
 2 files changed, 180 insertions(+), 25 deletions(-)

diff --git a/block/blk-crypto.c b/block/blk-crypto.c
index 1c08d3b6e24a..65f13549eb5f 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -102,6 +102,7 @@ void bio_crypt_set_ctx(struct bio *bio, const struct blk_crypto_key *key,
 
 	bio->bi_crypt_context = bc;
 }
+EXPORT_SYMBOL_GPL(bio_crypt_set_ctx);
 
 void __bio_crypt_free_ctx(struct bio *bio)
 {
@@ -370,6 +371,7 @@ int blk_crypto_init_key(struct blk_crypto_key *blk_key,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(blk_crypto_init_key);
 
 /*
  * Check if bios with @cfg can be en/decrypted by blk-crypto (i.e. either the
@@ -411,6 +413,7 @@ int blk_crypto_start_using_key(const struct blk_crypto_key *key,
 	}
 	return blk_crypto_fallback_start_using_mode(key->crypto_cfg.crypto_mode);
 }
+EXPORT_SYMBOL_GPL(blk_crypto_start_using_key);
 
 /**
  * blk_crypto_evict_key() - Evict a key from any inline encryption hardware
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index d4ae31558826..4c0e1904942b 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -39,6 +39,7 @@
 #include <keys/user-type.h>
 #include <keys/encrypted-type.h>
 #include <keys/trusted-type.h>
+#include <linux/blk-crypto.h>
 
 #include <linux/device-mapper.h>
 
@@ -134,7 +135,7 @@ struct iv_elephant_private {
 enum flags { DM_CRYPT_SUSPENDED, DM_CRYPT_KEY_VALID,
 	     DM_CRYPT_SAME_CPU, DM_CRYPT_NO_OFFLOAD,
 	     DM_CRYPT_NO_READ_WORKQUEUE, DM_CRYPT_NO_WRITE_WORKQUEUE,
-	     DM_CRYPT_WRITE_INLINE };
+	     DM_CRYPT_WRITE_INLINE, DM_CRYPT_INLINE_ENCRYPTION };
 
 enum cipher_flags {
 	CRYPT_MODE_INTEGRITY_AEAD,	/* Use authenticated mode for cipher */
@@ -220,6 +221,11 @@ struct crypt_config {
 	struct bio_set bs;
 	struct mutex bio_alloc_lock;
 
+#ifdef CONFIG_BLK_INLINE_ENCRYPTION
+	enum blk_crypto_mode_num crypto_mode;
+	enum blk_crypto_key_type key_type;
+	struct blk_crypto_key *blk_key;
+#endif
 	u8 *authenc_key; /* space for keys in authenc() format (if used) */
 	u8 key[];
 };
@@ -2383,11 +2389,103 @@ static void crypt_copy_authenckey(char *p, const void *key,
 	memcpy(p, key, enckeylen);
 }
 
+#ifdef CONFIG_BLK_INLINE_ENCRYPTION
+static int crypt_select_inline_crypt_mode(struct dm_target *ti, char *cipher,
+					  char *ivmode)
+{
+	struct crypt_config *cc = ti->private;
+
+	if (strcmp(cipher, "xts(aes)") == 0) {
+		cc->crypto_mode = BLK_ENCRYPTION_MODE_AES_256_XTS;
+		cc->key_type = BLK_CRYPTO_KEY_TYPE_STANDARD;
+	} else if (strcmp(cipher, "xts(paes)") == 0) {
+		cc->crypto_mode = BLK_ENCRYPTION_MODE_AES_256_XTS;
+		cc->key_type = BLK_CRYPTO_KEY_TYPE_HW_WRAPPED;
+	} else {
+		ti->error = "Invalid cipher for inline_crypt";
+		return -EINVAL;
+	}
+
+	if (ivmode == NULL || (strcmp(ivmode, "plain64") == 0)) {
+		cc->iv_size = 8;
+	} else {
+		ti->error = "Invalid IV mode for inline_crypt";
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int crypt_prepare_inline_crypt_key(struct crypt_config *cc)
+{
+	int ret;
+
+	cc->blk_key = kzalloc(sizeof(*cc->blk_key), GFP_KERNEL);
+	if (!cc->blk_key)
+		return -ENOMEM;
+
+	ret = blk_crypto_init_key(cc->blk_key, cc->key, cc->key_size,
+				  cc->key_type, cc->crypto_mode, cc->iv_size,
+				  cc->sector_size);
+	if (ret) {
+		DMERR("Failed to init inline encryption key");
+		goto bad_key;
+	}
+
+	ret = blk_crypto_start_using_key(cc->blk_key,
+					 bdev_get_queue(cc->dev->bdev));
+	if (ret) {
+		DMERR("Failed to use inline encryption key");
+		goto bad_key;
+	}
+
+	return 0;
+bad_key:
+	kfree_sensitive(cc->blk_key);
+	cc->blk_key = NULL;
+	return ret;
+}
+
+static void crypt_destroy_inline_crypt_key(struct crypt_config *cc)
+{
+	if (cc->blk_key) {
+		blk_crypto_evict_key(bdev_get_queue(cc->dev->bdev),
+				     cc->blk_key);
+		kfree_sensitive(cc->blk_key);
+		cc->blk_key = NULL;
+	}
+}
+
+static void crypt_inline_encrypt_submit(struct dm_target *ti, struct bio *bio)
+{
+	struct crypt_config *cc = ti->private;
+	u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE];
+
+	bio_set_dev(bio, cc->dev->bdev);
+	if (bio_sectors(bio)) {
+		memset(dun, 0, BLK_CRYPTO_MAX_IV_SIZE);
+		bio->bi_iter.bi_sector = cc->start +
+			dm_target_offset(ti, bio->bi_iter.bi_sector);
+		dun[0] = le64_to_cpu(bio->bi_iter.bi_sector + cc->iv_offset);
+		bio_crypt_set_ctx(bio, cc->blk_key, dun, GFP_KERNEL);
+	}
+
+	submit_bio_noacct(bio);
+}
+#endif
+
 static int crypt_setkey(struct crypt_config *cc)
 {
 	unsigned subkey_size;
 	int err = 0, i, r;
 
+#ifdef CONFIG_BLK_INLINE_ENCRYPTION
+	if (test_bit(DM_CRYPT_INLINE_ENCRYPTION, &cc->flags)) {
+		crypt_destroy_inline_crypt_key(cc);
+		return crypt_prepare_inline_crypt_key(cc);
+	}
+#endif
+
 	/* Ignore extra keys (which are used for IV etc) */
 	subkey_size = crypt_subkey_size(cc);
 
@@ -2648,6 +2746,15 @@ static int crypt_wipe_key(struct crypt_config *cc)
 
 	kfree_sensitive(cc->key_string);
 	cc->key_string = NULL;
+
+#ifdef CONFIG_BLK_INLINE_ENCRYPTION
+	if (test_bit(DM_CRYPT_INLINE_ENCRYPTION, &cc->flags)) {
+		crypt_destroy_inline_crypt_key(cc);
+		memset(&cc->key, 0, cc->key_size * sizeof(u8));
+		return 0;
+	}
+#endif
+
 	r = crypt_setkey(cc);
 	memset(&cc->key, 0, cc->key_size * sizeof(u8));
 
@@ -2713,6 +2820,10 @@ static void crypt_dtr(struct dm_target *ti)
 	if (cc->crypt_queue)
 		destroy_workqueue(cc->crypt_queue);
 
+#ifdef CONFIG_BLK_INLINE_ENCRYPTION
+	crypt_destroy_inline_crypt_key(cc);
+#endif
+
 	crypt_free_tfms(cc);
 
 	bioset_exit(&cc->bs);
@@ -2888,6 +2999,11 @@ static int crypt_ctr_cipher_new(struct dm_target *ti, char *cipher_in, char *key
 	/* The rest is crypto API spec */
 	cipher_api = tmp;
 
+#ifdef CONFIG_BLK_INLINE_ENCRYPTION
+	if (test_bit(DM_CRYPT_INLINE_ENCRYPTION, &cc->flags))
+		return crypt_select_inline_crypt_mode(ti, cipher_api, *ivmode);
+#endif
+
 	/* Alloc AEAD, can be used only in new format. */
 	if (crypt_integrity_aead(cc)) {
 		ret = crypt_ctr_auth_cipher(cc, cipher_api);
@@ -3001,6 +3117,11 @@ static int crypt_ctr_cipher_old(struct dm_target *ti, char *cipher_in, char *key
 		goto bad_mem;
 	}
 
+#ifdef CONFIG_BLK_INLINE_ENCRYPTION
+	if (test_bit(DM_CRYPT_INLINE_ENCRYPTION, &cc->flags))
+		return crypt_select_inline_crypt_mode(ti, cipher_api, *ivmode);
+#endif
+
 	/* Allocate cipher */
 	ret = crypt_alloc_tfms(cc, cipher_api);
 	if (ret < 0) {
@@ -3036,9 +3157,11 @@ static int crypt_ctr_cipher(struct dm_target *ti, char *cipher_in, char *key)
 		return ret;
 
 	/* Initialize IV */
-	ret = crypt_ctr_ivmode(ti, ivmode);
-	if (ret < 0)
-		return ret;
+	if (!test_bit(DM_CRYPT_INLINE_ENCRYPTION, &cc->flags)) {
+		ret = crypt_ctr_ivmode(ti, ivmode);
+		if (ret < 0)
+			return ret;
+	}
 
 	/* Initialize and set key */
 	ret = crypt_set_key(cc, key);
@@ -3111,6 +3234,10 @@ static int crypt_ctr_optional(struct dm_target *ti, unsigned int argc, char **ar
 			set_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags);
 		else if (!strcasecmp(opt_string, "no_write_workqueue"))
 			set_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags);
+#ifdef CONFIG_BLK_INLINE_ENCRYPTION
+		else if (!strcasecmp(opt_string, "inline_crypt"))
+			set_bit(DM_CRYPT_INLINE_ENCRYPTION, &cc->flags);
+#endif
 		else if (sscanf(opt_string, "integrity:%u:", &val) == 1) {
 			if (val == 0 || val > MAX_TAG_SIZE) {
 				ti->error = "Invalid integrity arguments";
@@ -3218,10 +3345,36 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 			goto bad;
 	}
 
+	ret = -EINVAL;
+	if ((sscanf(argv[2], "%llu%c", &tmpll, &dummy) != 1) ||
+	    (tmpll & ((cc->sector_size >> SECTOR_SHIFT) - 1))) {
+		ti->error = "Invalid iv_offset sector";
+		goto bad;
+	}
+	cc->iv_offset = tmpll;
+
+	ret = dm_get_device(ti, argv[3], dm_table_get_mode(ti->table),
+			    &cc->dev);
+	if (ret) {
+		ti->error = "Device lookup failed";
+		goto bad;
+	}
+
+	ret = -EINVAL;
+	if (sscanf(argv[4], "%llu%c", &tmpll, &dummy) != 1 ||
+	    tmpll != (sector_t)tmpll) {
+		ti->error = "Invalid device sector";
+		goto bad;
+	}
+	cc->start = tmpll;
+
 	ret = crypt_ctr_cipher(ti, argv[0], argv[1]);
 	if (ret < 0)
 		goto bad;
 
+	if (test_bit(DM_CRYPT_INLINE_ENCRYPTION, &cc->flags))
+		return 0;
+
 	if (crypt_integrity_aead(cc)) {
 		cc->dmreq_start = sizeof(struct aead_request);
 		cc->dmreq_start += crypto_aead_reqsize(any_tfm_aead(cc));
@@ -3277,27 +3430,6 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	mutex_init(&cc->bio_alloc_lock);
 
-	ret = -EINVAL;
-	if ((sscanf(argv[2], "%llu%c", &tmpll, &dummy) != 1) ||
-	    (tmpll & ((cc->sector_size >> SECTOR_SHIFT) - 1))) {
-		ti->error = "Invalid iv_offset sector";
-		goto bad;
-	}
-	cc->iv_offset = tmpll;
-
-	ret = dm_get_device(ti, argv[3], dm_table_get_mode(ti->table), &cc->dev);
-	if (ret) {
-		ti->error = "Device lookup failed";
-		goto bad;
-	}
-
-	ret = -EINVAL;
-	if (sscanf(argv[4], "%llu%c", &tmpll, &dummy) != 1 || tmpll != (sector_t)tmpll) {
-		ti->error = "Invalid device sector";
-		goto bad;
-	}
-	cc->start = tmpll;
-
 	if (bdev_is_zoned(cc->dev->bdev)) {
 		/*
 		 * For zoned block devices, we need to preserve the issuer write
@@ -3419,6 +3551,13 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
 	if (unlikely(bio->bi_iter.bi_size & (cc->sector_size - 1)))
 		return DM_MAPIO_KILL;
 
+#ifdef CONFIG_BLK_INLINE_ENCRYPTION
+	if (test_bit(DM_CRYPT_INLINE_ENCRYPTION, &cc->flags)) {
+		crypt_inline_encrypt_submit(ti, bio);
+		return DM_MAPIO_SUBMITTED;
+	}
+#endif
+
 	io = dm_per_bio_data(bio, cc->per_bio_data_size);
 	crypt_io_init(io, cc, bio, dm_target_offset(ti, bio->bi_iter.bi_sector));
 
@@ -3481,6 +3620,10 @@ static void crypt_status(struct dm_target *ti, status_type_t type,
 		num_feature_args += test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags);
 		num_feature_args += test_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags);
 		num_feature_args += test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags);
+#ifdef CONFIG_BLK_INLINE_ENCRYPTION
+		num_feature_args +=
+			test_bit(DM_CRYPT_INLINE_ENCRYPTION, &cc->flags);
+#endif
 		num_feature_args += cc->sector_size != (1 << SECTOR_SHIFT);
 		num_feature_args += test_bit(CRYPT_IV_LARGE_SECTORS, &cc->cipher_flags);
 		if (cc->on_disk_tag_size)
@@ -3497,6 +3640,10 @@ static void crypt_status(struct dm_target *ti, status_type_t type,
 				DMEMIT(" no_read_workqueue");
 			if (test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags))
 				DMEMIT(" no_write_workqueue");
+#ifdef CONFIG_BLK_INLINE_ENCRYPTION
+			if (test_bit(DM_CRYPT_INLINE_ENCRYPTION, &cc->flags))
+				DMEMIT(" inline_crypt");
+#endif
 			if (cc->on_disk_tag_size)
 				DMEMIT(" integrity:%u:%s", cc->on_disk_tag_size, cc->cipher_auth);
 			if (cc->sector_size != (1 << SECTOR_SHIFT))
@@ -3516,6 +3663,11 @@ static void crypt_status(struct dm_target *ti, status_type_t type,
 		       'y' : 'n');
 		DMEMIT(",no_write_workqueue=%c", test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags) ?
 		       'y' : 'n');
+#ifdef CONFIG_BLK_INLINE_ENCRYPTION
+		DMEMIT(",inline_crypt=%c",
+		       test_bit(DM_CRYPT_INLINE_ENCRYPTION, &cc->flags) ?
+		       'y' : 'n');
+#endif
 		DMEMIT(",iv_large_sectors=%c", test_bit(CRYPT_IV_LARGE_SECTORS, &cc->cipher_flags) ?
 		       'y' : 'n');
 
-- 
2.27.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

