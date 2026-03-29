Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C322DEA61;
	Sun, 29 Mar 2026 20:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774817433; cv=none; b=GD4Ve4+AqJbTYOxfWY6JHoHvOqf5OLBBveMV9sAjfXzau1CtVzhcfaMXDm1yMQGwAxiVudt+k55HSQgVHKPJDFlfrxy1FItaMshGw6h9/It+lkraGJEHmYwpFfP9IMLKTZB2rc8CALNJSXCqU+11iDyvmTWtHciGJh6Ov1MKvk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774817433; c=relaxed/simple;
	bh=dGhJhnX7gO6ISqIWwq0ezFmlxoWIeOWeB3KECoNmeAY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DekWQbgMmb7mA5yPS81nhunFXv7KvkNbvNMtW1Ot/J/LlNjUB1Dda/2PSWwkeARUZ2R+Xo1gDh+IkTFickRqR2lewzxhxPpJ3JzD7xizr3qB7P3n2i++NGWDr+T4HxOPBvGxBeNfifKpbWuR1aQE/KvbxeD18RfvT4+YdPPZFlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h/U2JfFB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h/U2JfFB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CCB4C116C6;
	Sun, 29 Mar 2026 20:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774817433;
	bh=dGhJhnX7gO6ISqIWwq0ezFmlxoWIeOWeB3KECoNmeAY=;
	h=From:To:Cc:Subject:Date:From;
	b=h/U2JfFBIkLv1ewoeiMnjM2XYzGzt1Vub6twV0+322GQn8ARqfMBatQpOGEybHQ5E
	 /gh1/dNXqYv8kDHAAhKw5vU8l4YWTiwjOaNsBCpll+Sxzp4h56HnZrNk3QEnIqDMnp
	 vu45OYdBSZo0Pdke3ugF/aHErOvxhxdJZxpuA3wg243r8riT2+Q9gsqdXc5/6UpCgQ
	 RaeLo07VxEV3n/syoyJJLOaVMDJs6olDKi1R1VuGirvFJLHbNA3u2J9G6uHK8Jnp+7
	 4I2kwJ+JPUShJGx995BYumYNpaZ3tMIhycG4gHksSXBLeKe9nQjnMrIsM/Y4vVk9Vo
	 1mwtY6rVfeE6Q==
From: Eric Biggers <ebiggers@kernel.org>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] dm-crypt: Make crypt_iv_operations::post return void
Date: Sun, 29 Mar 2026 13:49:52 -0700
Message-ID: <20260329204952.63850-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since all implementations of crypt_iv_operations::post now return 0,
change the return type to void.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is targeting linux-dm/for-next

 drivers/md/dm-crypt.c | 31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 60642cee8609..608b617fb817 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -111,12 +111,12 @@ struct crypt_iv_operations {
 	void (*dtr)(struct crypt_config *cc);
 	int (*init)(struct crypt_config *cc);
 	void (*wipe)(struct crypt_config *cc);
 	int (*generator)(struct crypt_config *cc, u8 *iv,
 			 struct dm_crypt_request *dmreq);
-	int (*post)(struct crypt_config *cc, u8 *iv,
-		    struct dm_crypt_request *dmreq);
+	void (*post)(struct crypt_config *cc, u8 *iv,
+		     struct dm_crypt_request *dmreq);
 };
 
 struct iv_benbi_private {
 	int shift;
 };
@@ -557,28 +557,27 @@ static int crypt_iv_lmk_gen(struct crypt_config *cc, u8 *iv,
 	} else
 		memset(iv, 0, cc->iv_size);
 	return 0;
 }
 
-static int crypt_iv_lmk_post(struct crypt_config *cc, u8 *iv,
-			     struct dm_crypt_request *dmreq)
+static void crypt_iv_lmk_post(struct crypt_config *cc, u8 *iv,
+			      struct dm_crypt_request *dmreq)
 {
 	struct scatterlist *sg;
 	u8 *dst;
 
 	if (bio_data_dir(dmreq->ctx->bio_in) == WRITE)
-		return 0;
+		return;
 
 	sg = crypt_get_sg_data(cc, dmreq->sg_out);
 	dst = kmap_local_page(sg_page(sg));
 	crypt_iv_lmk_one(cc, iv, dmreq, dst + sg->offset);
 
 	/* Tweak the first block of plaintext sector */
 	crypto_xor(dst + sg->offset, iv, cc->iv_size);
 
 	kunmap_local(dst);
-	return 0;
 }
 
 static void crypt_iv_tcw_dtr(struct crypt_config *cc)
 {
 	struct iv_tcw_private *tcw = &cc->iv_gen_private.tcw;
@@ -682,26 +681,24 @@ static int crypt_iv_tcw_gen(struct crypt_config *cc, u8 *iv,
 			       cc->iv_size - 8);
 
 	return 0;
 }
 
-static int crypt_iv_tcw_post(struct crypt_config *cc, u8 *iv,
-			     struct dm_crypt_request *dmreq)
+static void crypt_iv_tcw_post(struct crypt_config *cc, u8 *iv,
+			      struct dm_crypt_request *dmreq)
 {
 	struct scatterlist *sg;
 	u8 *dst;
 
 	if (bio_data_dir(dmreq->ctx->bio_in) != WRITE)
-		return 0;
+		return;
 
 	/* Apply whitening on ciphertext */
 	sg = crypt_get_sg_data(cc, dmreq->sg_out);
 	dst = kmap_local_page(sg_page(sg));
 	crypt_iv_tcw_whitening(cc, dmreq, dst + sg->offset);
 	kunmap_local(dst);
-
-	return 0;
 }
 
 static int crypt_iv_random_gen(struct crypt_config *cc, u8 *iv,
 				struct dm_crypt_request *dmreq)
 {
@@ -992,17 +989,15 @@ static int crypt_iv_elephant_gen(struct crypt_config *cc, u8 *iv,
 		crypt_iv_elephant(cc, dmreq);
 
 	return crypt_iv_eboiv_gen(cc, iv, dmreq);
 }
 
-static int crypt_iv_elephant_post(struct crypt_config *cc, u8 *iv,
-				  struct dm_crypt_request *dmreq)
+static void crypt_iv_elephant_post(struct crypt_config *cc, u8 *iv,
+				   struct dm_crypt_request *dmreq)
 {
 	if (bio_data_dir(dmreq->ctx->bio_in) != WRITE)
 		crypt_iv_elephant(cc, dmreq);
-
-	return 0;
 }
 
 static int crypt_iv_elephant_init(struct crypt_config *cc)
 {
 	struct iv_elephant_private *elephant = &cc->iv_gen_private.elephant;
@@ -1344,11 +1339,11 @@ static int crypt_convert_block_aead(struct crypt_config *cc,
 					 ctx->bio_in, s, 0);
 		}
 	}
 
 	if (!r && cc->iv_gen_ops && cc->iv_gen_ops->post)
-		r = cc->iv_gen_ops->post(cc, org_iv, dmreq);
+		cc->iv_gen_ops->post(cc, org_iv, dmreq);
 
 	bio_advance_iter(ctx->bio_in, &ctx->iter_in, cc->sector_size);
 	bio_advance_iter(ctx->bio_out, &ctx->iter_out, cc->sector_size);
 
 	return r;
@@ -1421,11 +1416,11 @@ static int crypt_convert_block_skcipher(struct crypt_config *cc,
 		r = crypto_skcipher_encrypt(req);
 	else
 		r = crypto_skcipher_decrypt(req);
 
 	if (!r && cc->iv_gen_ops && cc->iv_gen_ops->post)
-		r = cc->iv_gen_ops->post(cc, org_iv, dmreq);
+		cc->iv_gen_ops->post(cc, org_iv, dmreq);
 
 	bio_advance_iter(ctx->bio_in, &ctx->iter_in, cc->sector_size);
 	bio_advance_iter(ctx->bio_out, &ctx->iter_out, cc->sector_size);
 
 	return r;
@@ -2185,11 +2180,11 @@ static void kcryptd_async_done(void *data, int error)
 		complete(&ctx->restart);
 		return;
 	}
 
 	if (!error && cc->iv_gen_ops && cc->iv_gen_ops->post)
-		error = cc->iv_gen_ops->post(cc, org_iv_of_dmreq(cc, dmreq), dmreq);
+		cc->iv_gen_ops->post(cc, org_iv_of_dmreq(cc, dmreq), dmreq);
 
 	if (error == -EBADMSG) {
 		sector_t s = le64_to_cpu(*org_sector_of_dmreq(cc, dmreq));
 
 		ctx->aead_failed = true;

base-commit: 33eded29319d41fcba5d0257b126a48b449aad47
-- 
2.53.0

