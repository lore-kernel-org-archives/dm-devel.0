Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9967821D3E9;
	Wed,  9 Jul 2025 19:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752088370; cv=none; b=FF7bStc/wdwI5/GQ9F+OyNlKeJYCxnefc4eh6BnMvTKOZB22cMembF86GyR689SFNUarGUWv9DSy2dMPYBu8yzgW7DVk4DFJarXfNr8xEndaM7mhbrrRj/NjqENuo1ElIKMp5DMIOy0ulXGt2DrOhU8u/3Mxr7WMhdrFuwWCmf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752088370; c=relaxed/simple;
	bh=iJNHcB0sFYdwHF06nu+SSzrgoBhnYAgQa76+IUApaOY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=khQegM0bwi8YQOCn+CEt2X55C7sb7w98YZRayrMK59lJEehwyyH3KQnAslVDpbV6lGmn59mO0zIh/MMF/tiIJ7LWma4cr+alN51fXHeOmJZZ44aa5XJiUfkLoGwQSzH8xQtN2+zLbjl5DHp3Z8aWEkTd4CpJeAj+nXC8VAWMxcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fXgIJDab; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fXgIJDab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C948BC4CEEF;
	Wed,  9 Jul 2025 19:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752088370;
	bh=iJNHcB0sFYdwHF06nu+SSzrgoBhnYAgQa76+IUApaOY=;
	h=From:To:Cc:Subject:Date:From;
	b=fXgIJDab8zpqBtmX6TfonPErWXM9xYSFQcYzVQMQsKkN4CDBmV0K8/xZEgpvftGpC
	 MG5b5+yx9mLYxO19X1Cf1A7zppTecXNP5OFRAtZW4bMCzm62gxBjeAcPrc1ruViw1Q
	 e8/SvUvtXpIyaZ6kv7NHulD/oyZ/agEhQTacNkdH7+xT3WgWmF8R+XaYk8H4S21x8Z
	 nujX7n/UEDr+mGfnJmE2F6TGVfrRJTyoWAZjWr9ycmRcQZ8Jy+rGZ7L4l9bHlG2Zmx
	 rKFPopQO7A3ZRG4VYMOrRr+wHAw/LTvhJ8i+TXYWfOdL5wWWBGhHdDpypQHlwTr2jy
	 Cy/PElvAEC7eA==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	Gilad Ben-Yossef <gilad@benyossef.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2] dm-verity: remove support for asynchronous hashes
Date: Wed,  9 Jul 2025 12:09:02 -0700
Message-ID: <20250709190902.49554-1-ebiggers@kernel.org>
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
bugs.  I don't know of anyone using it in practice.  (The original
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

Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

Changed in v2:
  - Removed the now-unused 'may_sleep' parameter from verity_hash()
  - Fixed a typo in commit message
  - Added comment in verity_setup_salt_and_hashstate()
  - Keep SHASH_DESC_ON_STACK in existing place in
    verity_setup_salt_and_hashstate(), to reduce the diff slightly
  - Added Ard's Acked-by

 drivers/md/dm-verity-fec.c    |   4 +-
 drivers/md/dm-verity-target.c | 183 ++++++----------------------------
 drivers/md/dm-verity.h        |  22 ++--
 3 files changed, 37 insertions(+), 172 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 631a887b487cc..d382a390d39ab 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -189,11 +189,11 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
  */
 static int fec_is_erasure(struct dm_verity *v, struct dm_verity_io *io,
 			  u8 *want_digest, u8 *data)
 {
 	if (unlikely(verity_hash(v, io, data, 1 << v->data_dev_block_bits,
-				 verity_io_real_digest(v, io), true)))
+				 verity_io_real_digest(v, io))))
 		return 0;
 
 	return memcmp(verity_io_real_digest(v, io), want_digest,
 		      v->digest_size) != 0;
 }
@@ -390,11 +390,11 @@ static int fec_decode_rsb(struct dm_verity *v, struct dm_verity_io *io,
 		pos += fio->nbufs << DM_VERITY_FEC_BUF_RS_BITS;
 	}
 
 	/* Always re-validate the corrected block against the expected hash */
 	r = verity_hash(v, io, fio->output, 1 << v->data_dev_block_bits,
-			verity_io_real_digest(v, io), true);
+			verity_io_real_digest(v, io));
 	if (unlikely(r < 0))
 		return r;
 
 	if (memcmp(verity_io_real_digest(v, io), verity_io_want_digest(v, io),
 		   v->digest_size)) {
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 81186bded1ce7..498af3bb203ff 100644
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
-		const u8 *data, size_t len, u8 *digest, bool may_sleep)
+		const u8 *data, size_t len, u8 *digest)
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
+		/* Version 0: salt at end */
+		r = crypto_shash_init(desc) ?:
+		    crypto_shash_update(desc, data, len) ?:
+		    crypto_shash_update(desc, v->salt, v->salt_size) ?:
+		    crypto_shash_final(desc, digest);
 	} else {
-		struct shash_desc *desc = verity_io_hash_req(v, io);
-
-		desc->tfm = v->shash_tfm;
+		/* Version 1: salt at beginning */
 		r = crypto_shash_import(desc, v->initial_hashstate) ?:
 		    crypto_shash_finup(desc, data, len, digest);
 	}
 	if (unlikely(r))
 		DMERR("Error hashing block: %d", r);
@@ -360,11 +277,11 @@ static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
 			r = 1;
 			goto release_ret_r;
 		}
 
 		r = verity_hash(v, io, data, 1 << v->hash_dev_block_bits,
-				verity_io_real_digest(v, io), !io->in_bh);
+				verity_io_real_digest(v, io));
 		if (unlikely(r < 0))
 			goto release_ret_r;
 
 		if (likely(memcmp(verity_io_real_digest(v, io), want_digest,
 				  v->digest_size) == 0))
@@ -463,11 +380,11 @@ static noinline int verity_recheck(struct dm_verity *v, struct dm_verity_io *io,
 	r = dm_io(&io_req, 1, &io_loc, NULL, IOPRIO_DEFAULT);
 	if (unlikely(r))
 		goto free_ret;
 
 	r = verity_hash(v, io, buffer, 1 << v->data_dev_block_bits,
-			verity_io_real_digest(v, io), true);
+			verity_io_real_digest(v, io));
 	if (unlikely(r))
 		goto free_ret;
 
 	if (memcmp(verity_io_real_digest(v, io),
 		   verity_io_want_digest(v, io), v->digest_size)) {
@@ -579,11 +496,11 @@ static int verity_verify_io(struct dm_verity_io *io)
 			kunmap_local(data);
 			continue;
 		}
 
 		r = verity_hash(v, io, data, block_size,
-				verity_io_real_digest(v, io), !io->in_bh);
+				verity_io_real_digest(v, io));
 		if (unlikely(r < 0)) {
 			kunmap_local(data);
 			return r;
 		}
 
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
@@ -1155,22 +1067,23 @@ static int verity_alloc_zero_digest(struct dm_verity *v)
 	v->zero_digest = kmalloc(v->digest_size, GFP_KERNEL);
 
 	if (!v->zero_digest)
 		return r;
 
-	io = kmalloc(sizeof(*io) + v->hash_reqsize, GFP_KERNEL);
+	io = kmalloc(sizeof(*io) + crypto_shash_descsize(v->shash_tfm),
+		     GFP_KERNEL);
 
 	if (!io)
 		return r; /* verity_dtr will free zero_digest */
 
 	zero_data = kzalloc(1 << v->data_dev_block_bits, GFP_KERNEL);
 
 	if (!zero_data)
 		goto out;
 
 	r = verity_hash(v, io, zero_data, 1 << v->data_dev_block_bits,
-			v->zero_digest, true);
+			v->zero_digest);
 
 out:
 	kfree(io);
 	kfree(zero_data);
 
@@ -1322,64 +1235,26 @@ static int verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
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
@@ -1400,11 +1275,11 @@ static int verity_setup_salt_and_hashstate(struct dm_verity *v, const char *arg)
 		    hex2bin(v->salt, arg, v->salt_size)) {
 			ti->error = "Invalid salt";
 			return -EINVAL;
 		}
 	}
-	if (v->shash_tfm) {
+	if (v->version) { /* Version 1: salt at beginning */
 		SHASH_DESC_ON_STACK(desc, v->shash_tfm);
 		int r;
 
 		/*
 		 * Compute the pre-salted hash state that can be passed to
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
index 8cbb57862ae19..6d141abd965c7 100644
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
@@ -124,11 +116,11 @@ static inline u8 *verity_io_want_digest(struct dm_verity *v,
 {
 	return io->want_digest;
 }
 
 extern int verity_hash(struct dm_verity *v, struct dm_verity_io *io,
-		       const u8 *data, size_t len, u8 *digest, bool may_sleep);
+		       const u8 *data, size_t len, u8 *digest);
 
 extern int verity_hash_for_block(struct dm_verity *v, struct dm_verity_io *io,
 				 sector_t block, u8 *digest, bool *is_zero);
 
 extern bool dm_is_verity_target(struct dm_target *ti);

base-commit: 846e9e999dd36ce5898d302d674e441e72c3a8cf
-- 
2.50.1

