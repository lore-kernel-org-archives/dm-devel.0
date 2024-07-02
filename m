Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA8C84DF1;
	Tue,  2 Jul 2024 06:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719902983; cv=none; b=IdkiEMno9iaSKSgUpu1UawMD6xmnmZWeySTPbAjNFyLraa/KQNOcZBcm/pEo7n9LJbC/Ktzba04U2c5LXD3iiDm6qbX4p3I4E7UTskmxcEvACU53qq/NURXlOC2uLupILjT0p8IHR7oLNcpXRfD7r3FABk/dvN0VJ+ExqKYEt/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719902983; c=relaxed/simple;
	bh=ypS3wDjrki602PRpZAix8qK+2Aw3HThVdjAOH9xqvE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cwDyU1A5iOvu/j4e8hKHGo2kaC4T6YciUNvTLiVmJkE0RsqV7moY/SrBWK88ozpkSvHFUGG96WUrL6+NuzGK73Kwwb+jGTYei86X3RmBzYjEgodJ5B7mTykHZlgoIc6VGNcOvI+r3HpSOvB2tlSvxv9xJQ/cFqsH1YYFPBSYT5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VK8fJvKn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VK8fJvKn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07EF6C4AF0A;
	Tue,  2 Jul 2024 06:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719902983;
	bh=ypS3wDjrki602PRpZAix8qK+2Aw3HThVdjAOH9xqvE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VK8fJvKn6u2LSnl+IwVhzEMYDG5NwAcbGFGW9AWevmW2d/WGHrf4dIPXW9zmxgQlF
	 y7XIwQyQct8b0NVivQuECDr/bHWfjrzjQ5I1et8t9nCmqJV9nNAsYUKoqZSGzCfyLR
	 IHe4XIXmBbEAb8NlQk+gWDkthJWIIZEg8K8RyFD1ft2lHGZHzb9CdVUcl7G/0VyJdt
	 vBwgs40nyErxUF/qLQqFMKFoinrYSAGfZnSugi92EZG4ccZrGRI22YR3hLd9wv1BKW
	 l4uNwggC41EwdCMasdCMoxWNpOGTqhU8cMnboAmlewsOEE4FraET+V+zaL37SGmmUU
	 SxeXaadkeE29g==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 1/7] dm-verity: move hash algorithm setup into its own function
Date: Mon,  1 Jul 2024 23:48:29 -0700
Message-ID: <20240702064835.120541-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702064835.120541-1-ebiggers@kernel.org>
References: <20240702064835.120541-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Move the code that sets up the hash transformation into its own
function.  No change in behavior.

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/md/dm-verity-target.c | 70 +++++++++++++++++++----------------
 1 file changed, 39 insertions(+), 31 deletions(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index bb5da66da4c1..88d2a49dca43 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1224,10 +1224,47 @@ static int verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
 	} while (argc && !r);
 
 	return r;
 }
 
+static int verity_setup_hash_alg(struct dm_verity *v, const char *alg_name)
+{
+	struct dm_target *ti = v->ti;
+	struct crypto_ahash *ahash;
+
+	v->alg_name = kstrdup(alg_name, GFP_KERNEL);
+	if (!v->alg_name) {
+		ti->error = "Cannot allocate algorithm name";
+		return -ENOMEM;
+	}
+
+	ahash = crypto_alloc_ahash(alg_name, 0,
+				   v->use_bh_wq ? CRYPTO_ALG_ASYNC : 0);
+	if (IS_ERR(ahash)) {
+		ti->error = "Cannot initialize hash function";
+		return PTR_ERR(ahash);
+	}
+	v->tfm = ahash;
+
+	/*
+	 * dm-verity performance can vary greatly depending on which hash
+	 * algorithm implementation is used.  Help people debug performance
+	 * problems by logging the ->cra_driver_name.
+	 */
+	DMINFO("%s using implementation \"%s\"", alg_name,
+	       crypto_hash_alg_common(ahash)->base.cra_driver_name);
+
+	v->digest_size = crypto_ahash_digestsize(ahash);
+	if ((1 << v->hash_dev_block_bits) < v->digest_size * 2) {
+		ti->error = "Digest size too big";
+		return -EINVAL;
+	}
+	v->ahash_reqsize = sizeof(struct ahash_request) +
+			   crypto_ahash_reqsize(ahash);
+	return 0;
+}
+
 /*
  * Target parameters:
  *	<version>	The current format is version 1.
  *			Vsn 0 is compatible with original Chromium OS releases.
  *	<data device>
@@ -1348,42 +1385,13 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		r = -EINVAL;
 		goto bad;
 	}
 	v->hash_start = num_ll;
 
-	v->alg_name = kstrdup(argv[7], GFP_KERNEL);
-	if (!v->alg_name) {
-		ti->error = "Cannot allocate algorithm name";
-		r = -ENOMEM;
-		goto bad;
-	}
-
-	v->tfm = crypto_alloc_ahash(v->alg_name, 0,
-				    v->use_bh_wq ? CRYPTO_ALG_ASYNC : 0);
-	if (IS_ERR(v->tfm)) {
-		ti->error = "Cannot initialize hash function";
-		r = PTR_ERR(v->tfm);
-		v->tfm = NULL;
-		goto bad;
-	}
-
-	/*
-	 * dm-verity performance can vary greatly depending on which hash
-	 * algorithm implementation is used.  Help people debug performance
-	 * problems by logging the ->cra_driver_name.
-	 */
-	DMINFO("%s using implementation \"%s\"", v->alg_name,
-	       crypto_hash_alg_common(v->tfm)->base.cra_driver_name);
-
-	v->digest_size = crypto_ahash_digestsize(v->tfm);
-	if ((1 << v->hash_dev_block_bits) < v->digest_size * 2) {
-		ti->error = "Digest size too big";
-		r = -EINVAL;
+	r = verity_setup_hash_alg(v, argv[7]);
+	if (r)
 		goto bad;
-	}
-	v->ahash_reqsize = sizeof(struct ahash_request) +
-		crypto_ahash_reqsize(v->tfm);
 
 	v->root_digest = kmalloc(v->digest_size, GFP_KERNEL);
 	if (!v->root_digest) {
 		ti->error = "Cannot allocate root digest";
 		r = -ENOMEM;
-- 
2.45.2

