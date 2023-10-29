Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1304186E
	for <dm-devel@lists.linux.dev>; Sun, 29 Oct 2023 05:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qOQZDhVI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4F1DC433C8;
	Sun, 29 Oct 2023 05:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698555607;
	bh=76pvdRXuWcukGNX5lb4N9tDTaqcQAw+2NWLxLrug6kA=;
	h=From:To:Cc:Subject:Date:From;
	b=qOQZDhVIrcGe8drVuTHAyGCcc5RZFfhOYXSKmHVBNi9Q+Fge/2XlsTSLxPUMhKnh/
	 AYffdSb/DmNXNWQ2o0BrTtdx6qGZmehEuaAlHXDbnqRGcwG3ZYYiL89zU0ZQWcCCvc
	 VwmcAyi+hSGhRLKFrm3faq3+zzVUaKj4Z6sn2cXdHmXkNjotJrNmRrErM2ZXUu+7mn
	 ypiU1s0vr/cYvWrErKrppJZaBNEXAv0hL9vgLyHrwA5fDi3/hyZRiFBDyxDfpqnwrY
	 bWe/xgANqlV6vF90X4Hyv10MRqakFwA2H2VIhej+3+/8T3KW5N3fhtr9UKrwLX86Pe
	 qspuMe5q/3hYA==
From: Eric Biggers <ebiggers@kernel.org>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev
Cc: linux-crypto@vger.kernel.org
Subject: [PATCH] dm-integrity: use crypto_shash_digest() in sb_mac()
Date: Sat, 28 Oct 2023 21:59:44 -0700
Message-ID: <20231029045944.154382-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Simplify sb_mac() by using crypto_shash_digest() instead of an
init+update+final sequence.  This should also improve performance.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/md/dm-integrity.c | 30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 97a8d5fc9ebb..e85c688fd91e 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -486,56 +486,46 @@ static void sb_set_version(struct dm_integrity_c *ic)
 	else if (ic->meta_dev || ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING))
 		ic->sb->version = SB_VERSION_2;
 	else
 		ic->sb->version = SB_VERSION_1;
 }
 
 static int sb_mac(struct dm_integrity_c *ic, bool wr)
 {
 	SHASH_DESC_ON_STACK(desc, ic->journal_mac);
 	int r;
-	unsigned int size = crypto_shash_digestsize(ic->journal_mac);
+	unsigned int mac_size = crypto_shash_digestsize(ic->journal_mac);
+	__u8 *sb = (__u8 *)ic->sb;
+	__u8 *mac = sb + (1 << SECTOR_SHIFT) - mac_size;
 
-	if (sizeof(struct superblock) + size > 1 << SECTOR_SHIFT) {
+	if (sizeof(struct superblock) + mac_size > 1 << SECTOR_SHIFT) {
 		dm_integrity_io_error(ic, "digest is too long", -EINVAL);
 		return -EINVAL;
 	}
 
 	desc->tfm = ic->journal_mac;
 
-	r = crypto_shash_init(desc);
-	if (unlikely(r < 0)) {
-		dm_integrity_io_error(ic, "crypto_shash_init", r);
-		return r;
-	}
-
-	r = crypto_shash_update(desc, (__u8 *)ic->sb, (1 << SECTOR_SHIFT) - size);
-	if (unlikely(r < 0)) {
-		dm_integrity_io_error(ic, "crypto_shash_update", r);
-		return r;
-	}
-
 	if (likely(wr)) {
-		r = crypto_shash_final(desc, (__u8 *)ic->sb + (1 << SECTOR_SHIFT) - size);
+		r = crypto_shash_digest(desc, sb, mac - sb, mac);
 		if (unlikely(r < 0)) {
-			dm_integrity_io_error(ic, "crypto_shash_final", r);
+			dm_integrity_io_error(ic, "crypto_shash_digest", r);
 			return r;
 		}
 	} else {
-		__u8 result[HASH_MAX_DIGESTSIZE];
+		__u8 actual_mac[HASH_MAX_DIGESTSIZE];
 
-		r = crypto_shash_final(desc, result);
+		r = crypto_shash_digest(desc, sb, mac - sb, actual_mac);
 		if (unlikely(r < 0)) {
-			dm_integrity_io_error(ic, "crypto_shash_final", r);
+			dm_integrity_io_error(ic, "crypto_shash_digest", r);
 			return r;
 		}
-		if (memcmp((__u8 *)ic->sb + (1 << SECTOR_SHIFT) - size, result, size)) {
+		if (memcmp(mac, actual_mac, mac_size)) {
 			dm_integrity_io_error(ic, "superblock mac", -EILSEQ);
 			dm_audit_log_target(DM_MSG_PREFIX, "mac-superblock", ic->ti, 0);
 			return -EILSEQ;
 		}
 	}
 
 	return 0;
 }
 
 static int sync_rw_sb(struct dm_integrity_c *ic, blk_opf_t opf)

base-commit: 2af9b20dbb39f6ebf9b9b6c090271594627d818e
-- 
2.42.0

