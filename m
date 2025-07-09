Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9B226E175;
	Wed,  9 Jul 2025 06:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752043729; cv=none; b=dD3KQGt9jG1LayD8I5c0pBrauZSRdFROtLSlRR5D1YNpg7ILD0bKZh798Sw7GtG3nX74GrWS4yclRIaOJ7MgDbS+Z66AzqefYz6/dqu9XRqww70HGSIIC07gOJ8jyfOI7vb1/YrJdYLsB8eN8MZVpZSOc72RSwtYOkQl0mn9ZXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752043729; c=relaxed/simple;
	bh=Ag+c6KYhWSBNEs+mWeKzZMKQWqZ1Xik3C77KWIEMK+g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RfnUKkJhLkM4D66Tf6W+DMGmzsXEcyid3gvF1p+GJ7yL6ez1pZl9NTO+SPUDz6H2Ly2JPdSwEyxLMHpXmw3jKVY9gpA7XxXoIm//UFkkiv08AqZI2GHdZEV8TkbgpULRPuUENm99vyu8Rwpihbit49nfQYJ+JqjySMJr4oiWfkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=riywWTCh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="riywWTCh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15012C4CEF0;
	Wed,  9 Jul 2025 06:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752043729;
	bh=Ag+c6KYhWSBNEs+mWeKzZMKQWqZ1Xik3C77KWIEMK+g=;
	h=From:To:Cc:Subject:Date:From;
	b=riywWTChcf6NUy5fVCYsq/2yGvozvkwm1txAk1gs8JWnKUCK88CnHLUVh+q5wm4MX
	 9B6Uk8diqWNI27Mym1uNLe0boTYKAfSZUrRu/ql70p4TUermjIyWdNOpZ6hs1kf8j8
	 mv3gp4W+T6FtdN1FuqrscI4F1zEOBH2UA0MHJlZL/VC90fRh9n6ezRIV3ZN9hAyhOT
	 RensXiI6ZrRVpQ4wB7B4C4nfwvItaq4AXOo4pM6pFtXlgDkqv8PowW1Yk69NseRGCu
	 3TdlX89JCbYsInB3qitKVX1/8o8c6EyzRgJ3u5G4D3EW6Hc22by8ssR633SuSp5zuS
	 OcCqCHA735dAg==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	Gilad Ben-Yossef <gilad@benyossef.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] dm-verity: remove support for asynchronous hashes
Date: Tue,  8 Jul 2025 23:45:12 -0700
Message-ID: <20250709064512.67551-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The support for asynchronous hashes in dm-verity has outlived its
usefulness.  It adds significant code complexity and opportunity for
bugs.  I don't know of anyone using it practice.  (The original
submitter of the code possibly was, but that was 8 years ago.)  Data I
recently collected for en/decryption shows that using off-CPU crypto
"accelerators" is consistently much slower than the CPU
(https://lore.kernel.org/r/20250704070322.20692-1-ebiggers@kernel.org/),
even on CPUs that lack dedicated cryptographic instructions.  Similar
results are likely to be seen for hashing.

I already removed support for asynchronous hashes from fsverity two
years ago, and no one ever complained.

Moreover, neither dm-verity, fsverity, nor fscrypt has ever actually
used the asynchronous crypto algorithms in a truly asynchronous manner.
The lack of interest in such optimizations provides further evidence
that it's only the CPU-based crypto that actually matters.

Historically, it's also been common for people to forget to enable the
optimized SHA-256 code, which could contribute to an off-CPU crypto
engine being perceived as more useful than it really is.  In 6.16 I
fixed that: the optimized SHA-256 code is now enabled by default.

Therefore, let's drop the support for asynchronous hashes in dm-verity.

Tested with verity-compat-test.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/dm-verity-target.c | 175 +++++-----------------------------
 drivers/md/dm-verity.h        |  20 ++--
 2 files changed, 30 insertions(+), 165 deletions(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 81186bded1ce7..f94d0b6bd6ba0 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -17,11 +17,10 @@
 #include "dm-verity-fec.h"
 #include "dm-verity-verify-sig.h"
 #include "dm-audit.h"
 #include <linux/module.h>
 #include <linux/reboot.h>
-#include <linux/scatterlist.h>
 #include <linux/string.h>
 #include <linux/jump_label.h>
 #include <linux/security.h>
 
 #define DM_MSG_PREFIX			"verity"
@@ -59,13 +58,10 @@ static unsigned int dm_verity_use_bh_bytes[4] = {
 
 module_param_array_named(use_bh_bytes, dm_verity_use_bh_bytes, uint, NULL, 0644);
 
 static DEFINE_STATIC_KEY_FALSE(use_bh_wq_enabled);
 
-/* Is at least one dm-verity instance using ahash_tfm instead of shash_tfm? */
-static DEFINE_STATIC_KEY_FALSE(ahash_enabled);
-
 struct dm_verity_prefetch_work {
 	struct work_struct work;
 	struct dm_verity *v;
 	unsigned short ioprio;
 	sector_t block;
@@ -116,104 +112,25 @@ static sector_t verity_position_at_level(struct dm_verity *v, sector_t block,
 					 int level)
 {
 	return block >> (level * v->hash_per_block_bits);
 }
 
-static int verity_ahash_update(struct dm_verity *v, struct ahash_request *req,
-				const u8 *data, size_t len,
-				struct crypto_wait *wait)
-{
-	struct scatterlist sg;
-
-	if (likely(!is_vmalloc_addr(data))) {
-		sg_init_one(&sg, data, len);
-		ahash_request_set_crypt(req, &sg, NULL, len);
-		return crypto_wait_req(crypto_ahash_update(req), wait);
-	}
-
-	do {
-		int r;
-		size_t this_step = min_t(size_t, len, PAGE_SIZE - offset_in_page(data));
-
-		flush_kernel_vmap_range((void *)data, this_step);
-		sg_init_table(&sg, 1);
-		sg_set_page(&sg, vmalloc_to_page(data), this_step, offset_in_page(data));
-		ahash_request_set_crypt(req, &sg, NULL, this_step);
-		r = crypto_wait_req(crypto_ahash_update(req), wait);
-		if (unlikely(r))
-			return r;
-		data += this_step;
-		len -= this_step;
-	} while (len);
-
-	return 0;
-}
-
-/*
- * Wrapper for crypto_ahash_init, which handles verity salting.
- */
-static int verity_ahash_init(struct dm_verity *v, struct ahash_request *req,
-				struct crypto_wait *wait, bool may_sleep)
-{
-	int r;
-
-	ahash_request_set_tfm(req, v->ahash_tfm);
-	ahash_request_set_callback(req,
-		may_sleep ? CRYPTO_TFM_REQ_MAY_SLEEP | CRYPTO_TFM_REQ_MAY_BACKLOG : 0,
-		crypto_req_done, (void *)wait);
-	crypto_init_wait(wait);
-
-	r = crypto_wait_req(crypto_ahash_init(req), wait);
-
-	if (unlikely(r < 0)) {
-		if (r != -ENOMEM)
-			DMERR("crypto_ahash_init failed: %d", r);
-		return r;
-	}
-
-	if (likely(v->salt_size && (v->version >= 1)))
-		r = verity_ahash_update(v, req, v->salt, v->salt_size, wait);
-
-	return r;
-}
-
-static int verity_ahash_final(struct dm_verity *v, struct ahash_request *req,
-			      u8 *digest, struct crypto_wait *wait)
-{
-	int r;
-
-	if (unlikely(v->salt_size && (!v->version))) {
-		r = verity_ahash_update(v, req, v->salt, v->salt_size, wait);
-
-		if (r < 0) {
-			DMERR("%s failed updating salt: %d", __func__, r);
-			goto out;
-		}
-	}
-
-	ahash_request_set_crypt(req, NULL, digest, 0);
-	r = crypto_wait_req(crypto_ahash_final(req), wait);
-out:
-	return r;
-}
-
 int verity_hash(struct dm_verity *v, struct dm_verity_io *io,
 		const u8 *data, size_t len, u8 *digest, bool may_sleep)
 {
+	struct shash_desc *desc = &io->hash_desc;
 	int r;
 
-	if (static_branch_unlikely(&ahash_enabled) && !v->shash_tfm) {
-		struct ahash_request *req = verity_io_hash_req(v, io);
-		struct crypto_wait wait;
-
-		r = verity_ahash_init(v, req, &wait, may_sleep) ?:
-		    verity_ahash_update(v, req, data, len, &wait) ?:
-		    verity_ahash_final(v, req, digest, &wait);
+	desc->tfm = v->shash_tfm;
+	if (unlikely(v->initial_hashstate == NULL)) {
+		/* version 0: salt at end */
+		r = crypto_shash_init(desc) ?:
+		    crypto_shash_update(desc, data, len) ?:
+		    crypto_shash_update(desc, v->salt, v->salt_size) ?:
+		    crypto_shash_final(desc, digest);
 	} else {
-		struct shash_desc *desc = verity_io_hash_req(v, io);
-
-		desc->tfm = v->shash_tfm;
+		/* version 1: salt at beginning */
 		r = crypto_shash_import(desc, v->initial_hashstate) ?:
 		    crypto_shash_finup(desc, data, len, digest);
 	}
 	if (unlikely(r))
 		DMERR("Error hashing block: %d", r);
@@ -1090,16 +1007,11 @@ static void verity_dtr(struct dm_target *ti)
 	kfree(v->initial_hashstate);
 	kfree(v->root_digest);
 	kfree(v->zero_digest);
 	verity_free_sig(v);
 
-	if (v->ahash_tfm) {
-		static_branch_dec(&ahash_enabled);
-		crypto_free_ahash(v->ahash_tfm);
-	} else {
-		crypto_free_shash(v->shash_tfm);
-	}
+	crypto_free_shash(v->shash_tfm);
 
 	kfree(v->alg_name);
 
 	if (v->hash_dev)
 		dm_put_device(ti, v->hash_dev);
@@ -1155,11 +1067,12 @@ static int verity_alloc_zero_digest(struct dm_verity *v)
 	v->zero_digest = kmalloc(v->digest_size, GFP_KERNEL);
 
 	if (!v->zero_digest)
 		return r;
 
-	io = kmalloc(sizeof(*io) + v->hash_reqsize, GFP_KERNEL);
+	io = kmalloc(sizeof(*io) + crypto_shash_descsize(v->shash_tfm),
+		     GFP_KERNEL);
 
 	if (!io)
 		return r; /* verity_dtr will free zero_digest */
 
 	zero_data = kzalloc(1 << v->data_dev_block_bits, GFP_KERNEL);
@@ -1322,74 +1235,37 @@ static int verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
 }
 
 static int verity_setup_hash_alg(struct dm_verity *v, const char *alg_name)
 {
 	struct dm_target *ti = v->ti;
-	struct crypto_ahash *ahash;
-	struct crypto_shash *shash = NULL;
-	const char *driver_name;
+	struct crypto_shash *shash;
 
 	v->alg_name = kstrdup(alg_name, GFP_KERNEL);
 	if (!v->alg_name) {
 		ti->error = "Cannot allocate algorithm name";
 		return -ENOMEM;
 	}
 
-	/*
-	 * Allocate the hash transformation object that this dm-verity instance
-	 * will use.  The vast majority of dm-verity users use CPU-based
-	 * hashing, so when possible use the shash API to minimize the crypto
-	 * API overhead.  If the ahash API resolves to a different driver
-	 * (likely an off-CPU hardware offload), use ahash instead.  Also use
-	 * ahash if the obsolete dm-verity format with the appended salt is
-	 * being used, so that quirk only needs to be handled in one place.
-	 */
-	ahash = crypto_alloc_ahash(alg_name, 0,
-				   v->use_bh_wq ? CRYPTO_ALG_ASYNC : 0);
-	if (IS_ERR(ahash)) {
+	shash = crypto_alloc_shash(alg_name, 0, 0);
+	if (IS_ERR(shash)) {
 		ti->error = "Cannot initialize hash function";
-		return PTR_ERR(ahash);
-	}
-	driver_name = crypto_ahash_driver_name(ahash);
-	if (v->version >= 1 /* salt prepended, not appended? */) {
-		shash = crypto_alloc_shash(alg_name, 0, 0);
-		if (!IS_ERR(shash) &&
-		    strcmp(crypto_shash_driver_name(shash), driver_name) != 0) {
-			/*
-			 * ahash gave a different driver than shash, so probably
-			 * this is a case of real hardware offload.  Use ahash.
-			 */
-			crypto_free_shash(shash);
-			shash = NULL;
-		}
-	}
-	if (!IS_ERR_OR_NULL(shash)) {
-		crypto_free_ahash(ahash);
-		ahash = NULL;
-		v->shash_tfm = shash;
-		v->digest_size = crypto_shash_digestsize(shash);
-		v->hash_reqsize = sizeof(struct shash_desc) +
-				  crypto_shash_descsize(shash);
-		DMINFO("%s using shash \"%s\"", alg_name, driver_name);
-	} else {
-		v->ahash_tfm = ahash;
-		static_branch_inc(&ahash_enabled);
-		v->digest_size = crypto_ahash_digestsize(ahash);
-		v->hash_reqsize = sizeof(struct ahash_request) +
-				  crypto_ahash_reqsize(ahash);
-		DMINFO("%s using ahash \"%s\"", alg_name, driver_name);
+		return PTR_ERR(shash);
 	}
+	v->shash_tfm = shash;
+	v->digest_size = crypto_shash_digestsize(shash);
+	DMINFO("%s using \"%s\"", alg_name, crypto_shash_driver_name(shash));
 	if ((1 << v->hash_dev_block_bits) < v->digest_size * 2) {
 		ti->error = "Digest size too big";
 		return -EINVAL;
 	}
 	return 0;
 }
 
 static int verity_setup_salt_and_hashstate(struct dm_verity *v, const char *arg)
 {
 	struct dm_target *ti = v->ti;
+	SHASH_DESC_ON_STACK(desc, v->shash_tfm);
 
 	if (strcmp(arg, "-") != 0) {
 		v->salt_size = strlen(arg) / 2;
 		v->salt = kmalloc(v->salt_size, GFP_KERNEL);
 		if (!v->salt) {
@@ -1400,12 +1276,11 @@ static int verity_setup_salt_and_hashstate(struct dm_verity *v, const char *arg)
 		    hex2bin(v->salt, arg, v->salt_size)) {
 			ti->error = "Invalid salt";
 			return -EINVAL;
 		}
 	}
-	if (v->shash_tfm) {
-		SHASH_DESC_ON_STACK(desc, v->shash_tfm);
+	if (v->version) {
 		int r;
 
 		/*
 		 * Compute the pre-salted hash state that can be passed to
 		 * crypto_shash_import() for each block later.
@@ -1679,11 +1554,12 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		ti->error = "Cannot allocate workqueue";
 		r = -ENOMEM;
 		goto bad;
 	}
 
-	ti->per_io_data_size = sizeof(struct dm_verity_io) + v->hash_reqsize;
+	ti->per_io_data_size = sizeof(struct dm_verity_io) +
+			       crypto_shash_descsize(v->shash_tfm);
 
 	r = verity_fec_ctr(v);
 	if (r)
 		goto bad;
 
@@ -1786,14 +1662,11 @@ static int verity_preresume(struct dm_target *ti)
 
 	v = ti->private;
 	bdev = dm_disk(dm_table_get_md(ti->table))->part0;
 	root_digest.digest = v->root_digest;
 	root_digest.digest_len = v->digest_size;
-	if (static_branch_unlikely(&ahash_enabled) && !v->shash_tfm)
-		root_digest.alg = crypto_ahash_alg_name(v->ahash_tfm);
-	else
-		root_digest.alg = crypto_shash_alg_name(v->shash_tfm);
+	root_digest.alg = crypto_shash_alg_name(v->shash_tfm);
 
 	r = security_bdev_setintegrity(bdev, LSM_INT_DMVERITY_ROOTHASH, &root_digest,
 				       sizeof(root_digest));
 	if (r)
 		return r;
diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
index 8cbb57862ae19..d6a0e912f2e18 100644
--- a/drivers/md/dm-verity.h
+++ b/drivers/md/dm-verity.h
@@ -37,15 +37,14 @@ struct dm_verity {
 	struct dm_dev *data_dev;
 	struct dm_dev *hash_dev;
 	struct dm_target *ti;
 	struct dm_bufio_client *bufio;
 	char *alg_name;
-	struct crypto_ahash *ahash_tfm; /* either this or shash_tfm is set */
-	struct crypto_shash *shash_tfm; /* either this or ahash_tfm is set */
+	struct crypto_shash *shash_tfm;
 	u8 *root_digest;	/* digest of the root block */
 	u8 *salt;		/* salt: its size is salt_size */
-	u8 *initial_hashstate;	/* salted initial state, if shash_tfm is set */
+	u8 *initial_hashstate;	/* salted initial state, if version >= 1 */
 	u8 *zero_digest;	/* digest for a zero block */
 #ifdef CONFIG_SECURITY
 	u8 *root_digest_sig;	/* signature of the root digest */
 	unsigned int sig_size;	/* root digest signature size */
 #endif /* CONFIG_SECURITY */
@@ -59,11 +58,10 @@ struct dm_verity {
 	unsigned char levels;	/* the number of tree levels */
 	unsigned char version;
 	bool hash_failed:1;	/* set if hash of any block failed */
 	bool use_bh_wq:1;	/* try to verify in BH wq before normal work-queue */
 	unsigned int digest_size;	/* digest size for the current hash algorithm */
-	unsigned int hash_reqsize; /* the size of temporary space for crypto */
 	enum verity_mode mode;	/* mode for handling verification errors */
 	enum verity_mode error_mode;/* mode for handling I/O errors */
 	unsigned int corrupted_errs;/* Number of errors for corrupted blocks */
 
 	struct workqueue_struct *verify_wq;
@@ -98,23 +96,17 @@ struct dm_verity_io {
 
 	u8 real_digest[HASH_MAX_DIGESTSIZE];
 	u8 want_digest[HASH_MAX_DIGESTSIZE];
 
 	/*
-	 * This struct is followed by a variable-sized hash request of size
-	 * v->hash_reqsize, either a struct ahash_request or a struct shash_desc
-	 * (depending on whether ahash_tfm or shash_tfm is being used).  To
-	 * access it, use verity_io_hash_req().
+	 * Temporary space for hashing.  This is variable-length and must be at
+	 * the end of the struct.  struct shash_desc is just the fixed part;
+	 * it's followed by a context of size crypto_shash_descsize(shash_tfm).
 	 */
+	struct shash_desc hash_desc;
 };
 
-static inline void *verity_io_hash_req(struct dm_verity *v,
-				       struct dm_verity_io *io)
-{
-	return io + 1;
-}
-
 static inline u8 *verity_io_real_digest(struct dm_verity *v,
 					struct dm_verity_io *io)
 {
 	return io->real_digest;
 }

base-commit: 846e9e999dd36ce5898d302d674e441e72c3a8cf
-- 
2.50.1

