Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95AC233B6E1;
	Fri,  6 Feb 2026 05:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770354116; cv=none; b=IkT2j0kdgj/4Lv6NVtmHQHRAAmW/u6qYVFobQWIBx2YTMve/SZ/4iY117uJDDUXTrP43VFDG7CSuYV+akPu0bq4rtXHMwxnyoyF3zZ/B+6sZhcPj99IjnmbMEvKe5TZH74zOpi3eMddLVhC2FC5vKOLHDE844VKLB9QeDkLveSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770354116; c=relaxed/simple;
	bh=xrKH+ehGVoyb6JwhTs96FBZNr3Fvc+0Rbe+tg2c8EGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dWN8D2T7wV0OI9bC4TfRA5gqKNG6O7C5XphJKanwALUv0y37V4HE0iJ+ZnKQ4V5INTzoop6/5CrZNRoXAcdTZF61IgnVC3kAQu/2L3cFgEWPLqDtXRNrBqbLa6rkviDeoymTUEP4wGPNivPQa3yc8thJY9kOHit/MSG8C1PhlX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r8/qe32U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r8/qe32U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B587C2BC87;
	Fri,  6 Feb 2026 05:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770354116;
	bh=xrKH+ehGVoyb6JwhTs96FBZNr3Fvc+0Rbe+tg2c8EGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r8/qe32UJz0pIzEQLLtIuYQPtwD+94Ox8oIKFfR30MVgbz5YTvPYt93UuoAPUiPZS
	 osjEuxqjhpyFpZwK5+R7bFLA3Y71XsvirODnjw0nnhuPujXeZNYkJ56WgNB4d/yMgF
	 fyUxiX+68qqghEeI/AOZ1v6FFi/zqDOSWaWe7t7YW5BNLiKjHm7Gsvrh63tcXuTN8/
	 Fopc461BhswvpfsGHzbXffpkJd/SdAe+yk/y02EWzIgWrU6RJcaOmO+4BoZgj9+mFp
	 YfdyUANxkCQsvabdAuUT9lvG8cPqA2HGUZbugymDdFi2Vmw2mYPML9oIR+78KmFmD1
	 ToxjZEmfyplkQ==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 06/22] dm-verity: rename dm_verity::hash_blocks to dm_verity::hash_end
Date: Thu,  5 Feb 2026 20:59:25 -0800
Message-ID: <20260206045942.52965-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260206045942.52965-1-ebiggers@kernel.org>
References: <20260206045942.52965-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rename hash_blocks to hash_end to reflect what it actually is.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/dm-verity-fec.c    | 2 +-
 drivers/md/dm-verity-target.c | 8 ++++----
 drivers/md/dm-verity.h        | 4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index fcfacaec2989a..c3f2516f9c2a9 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -633,11 +633,11 @@ int verity_fec_ctr(struct dm_verity *v)
 	 *
 	 * If metadata is included, we require it to be available on the
 	 * hash device after the hash blocks.
 	 */
 
-	hash_blocks = v->hash_blocks - v->hash_start;
+	hash_blocks = v->hash_end - v->hash_start;
 
 	/*
 	 * Require matching block sizes for data and hash devices for
 	 * simplicity.
 	 */
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 631ccc6a2bb7e..ad9a86e8e44bb 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -730,12 +730,12 @@ static void verity_prefetch_io(struct work_struct *work)
 			if (unlikely(cluster & (cluster - 1)))
 				cluster = 1 << __fls(cluster);
 
 			hash_block_start &= ~(sector_t)(cluster - 1);
 			hash_block_end |= cluster - 1;
-			if (unlikely(hash_block_end >= v->hash_blocks))
-				hash_block_end = v->hash_blocks - 1;
+			if (unlikely(hash_block_end >= v->hash_end))
+				hash_block_end = v->hash_end - 1;
 		}
 no_prefetch_cluster:
 		dm_bufio_prefetch_with_ioprio(v->bufio, hash_block_start,
 					hash_block_end - hash_block_start + 1,
 					pw->ioprio);
@@ -1604,11 +1604,11 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 			r = -E2BIG;
 			goto bad;
 		}
 		hash_position += s;
 	}
-	v->hash_blocks = hash_position;
+	v->hash_end = hash_position;
 
 	r = mempool_init_page_pool(&v->recheck_pool, 1, 0);
 	if (unlikely(r)) {
 		ti->error = "Cannot allocate mempool";
 		goto bad;
@@ -1631,11 +1631,11 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		r = PTR_ERR(v->bufio);
 		v->bufio = NULL;
 		goto bad;
 	}
 
-	if (dm_bufio_get_device_size(v->bufio) < v->hash_blocks) {
+	if (dm_bufio_get_device_size(v->bufio) < v->hash_end) {
 		ti->error = "Hash device is too small";
 		r = -E2BIG;
 		goto bad;
 	}
 
diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
index d6bfabb27113b..2922263501f68 100644
--- a/drivers/md/dm-verity.h
+++ b/drivers/md/dm-verity.h
@@ -51,13 +51,13 @@ struct dm_verity {
 #ifdef CONFIG_SECURITY
 	u8 *root_digest_sig;	/* signature of the root digest */
 	unsigned int sig_size;	/* root digest signature size */
 #endif /* CONFIG_SECURITY */
 	unsigned int salt_size;
-	sector_t hash_start;	/* hash start in blocks */
+	sector_t hash_start;	/* index of first hash block on hash_dev */
+	sector_t hash_end;	/* 1 + index of last hash block on hash dev */
 	sector_t data_blocks;	/* the number of data blocks */
-	sector_t hash_blocks;	/* the number of hash blocks */
 	unsigned char data_dev_block_bits;	/* log2(data blocksize) */
 	unsigned char hash_dev_block_bits;	/* log2(hash blocksize) */
 	unsigned char hash_per_block_bits;	/* log2(hashes in hash block) */
 	unsigned char levels;	/* the number of tree levels */
 	unsigned char version;
-- 
2.52.0

