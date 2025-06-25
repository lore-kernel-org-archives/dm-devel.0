Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C4D1F3BB5;
	Wed, 25 Jun 2025 06:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750831277; cv=none; b=UuQE2KtYCa/wxLg1HpTULtq1qrjK0QbldKhQUjORcMBtC/J7N+OhXsKpGfQ97GBnytB2ojt+LDm2q1/9WWLvgH9sHFAoC3AriPZ8R3E72RqSBS37+MCadFozkJHEbpevEtJHcRJt/WA4gJR71ZdozdlMlr+8lwzmfnlwnEyPGt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750831277; c=relaxed/simple;
	bh=uNtbJemdgvFOPBC/Tb/46BxkEiIxbtmdDIyYU4ZZLfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8YZ6gA0rLMMtCH4WBJgUn7Go/DrL9w+D9S99e01FhYd5uazIzpla7gPX+TfItgn7aG66+suynQ0TJp4NWDgm1Q9vO6H8lAz2zpMyTyZkhopRulSzB1+lmFrXenxRCoxHXKhcdEEkxufBM2t67+2sMw9ytyP0+wQqESKM47yvIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d4STLAwf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d4STLAwf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 481DBC4CEF6;
	Wed, 25 Jun 2025 06:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750831276;
	bh=uNtbJemdgvFOPBC/Tb/46BxkEiIxbtmdDIyYU4ZZLfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d4STLAwfGZvS7foKfuzqI8ScURkJFjLRXip3i8vWY/g2/AFPPOu87Rs0xvvpeafGt
	 5CkrP05lmYUhaulZ+Qm41HZNhCSbY5f+1soJYk/ZWqZnvY2aTPY7fgVeh1t8laXSFS
	 hmVD7577yraaC227g8iO4Rfdupn2tpZV+BniBqwYu0gz5MR35LzBTWQCoKpTh1dgJn
	 gkBwAuprqVr0YRZ2CAF9l4188ohkVFOZ5v3DebLhNL7mg60XCnSbExWrfE8VX5nj1V
	 e7FP1v7POyoBXrvc4EAW+woQODWGpD8HzWZlu5HSzmNeLL5e9LGIyktVV6BZIx7lqk
	 bG3RoD2kK7dHg==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 2/4] dm: Always split write BIOs to zoned device limits
Date: Wed, 25 Jun 2025 14:59:06 +0900
Message-ID: <20250625055908.456235-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250625055908.456235-1-dlemoal@kernel.org>
References: <20250625055908.456235-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Any zoned DM target that requires zone append emulation will use the
block layer zone write plugging. In such case, DM target drivers must
not split BIOs using dm_accept_partial_bio() as doing so can potentially
lead to deadlocks with queue freeze operations. Regular write operations
used to emulate zone append operations also cannot be split by the
target driver as that would result in an invalid writen sector value
return using the BIO sector.

In order for zoned DM target drivers to avoid such incorrect BIO
splitting, we must ensure that large BIOs are split before being passed
to the map() function of the target, thus guaranteeing that the
limits for the mapped device are not exceeded.

dm-crypt and dm-flakey are the only target drivers supporting zoned
devices and using dm_accept_partial_bio().

In the case of dm-crypt, this function is used to split BIOs to the
internal max_write_size limit (which will be suppressed in a different
patch). However, since crypt_alloc_buffer() uses a bioset allowing only
up to BIO_MAX_VECS (256) vectors in a BIO. The dm-crypt device
max_segments limit, which is not set and so default to BLK_MAX_SEGMENTS
(128), must thus be respected and write BIOs split accordingly.

In the case of dm-flakey, since zone append emulation is not required,
the block layer zone write plugging is not used and no splitting of BIOs
required.

Modify the function dm_zone_bio_needs_split() to use the block layer
helper function bio_needs_zone_write_plugging() to force a call to
bio_split_to_limits() in dm_split_and_process_bio(). This allows DM
target drivers to avoid using dm_accept_partial_bio() for write
operations on zoned DM devices.

Fixes: f211268ed1f9 ("dm: Use the block layer zone append emulation")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/md/dm.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 55579adbeb3f..e01ed89b2e45 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1773,12 +1773,28 @@ static inline bool dm_zone_bio_needs_split(struct mapped_device *md,
 					   struct bio *bio)
 {
 	/*
-	 * For mapped device that need zone append emulation, we must
-	 * split any large BIO that straddles zone boundaries.
+	 * Special case REQ_OP_ZONE_RESET_ALL and REQ_OP_ZONE_APPEND as these
+	 * operations cannot be split.
 	 */
-	return dm_emulate_zone_append(md) && bio_straddles_zones(bio) &&
-		!bio_flagged(bio, BIO_ZONE_WRITE_PLUGGING);
+	switch (bio_op(bio)) {
+	case REQ_OP_ZONE_RESET_ALL:
+	case REQ_OP_ZONE_APPEND:
+		return false;
+	default:
+		break;
+	}
+
+	/*
+	 * Mapped device that require zone append emulation will use the block
+	 * layer zone write plugging. In such case, we must split any large BIO
+	 * to the mapped device limits to avoid potential deadlocks with queue
+	 * freeze operations.
+	 */
+	if (!dm_emulate_zone_append(md))
+		return false;
+	return bio_needs_zone_write_plugging(bio) || bio_straddles_zones(bio);
 }
+
 static inline bool dm_zone_plug_bio(struct mapped_device *md, struct bio *bio)
 {
 	return dm_emulate_zone_append(md) && blk_zone_plug_bio(bio, 0);
@@ -1925,9 +1941,7 @@ static void dm_split_and_process_bio(struct mapped_device *md,
 
 	is_abnormal = is_abnormal_io(bio);
 	if (static_branch_unlikely(&zoned_enabled)) {
-		/* Special case REQ_OP_ZONE_RESET_ALL as it cannot be split. */
-		need_split = (bio_op(bio) != REQ_OP_ZONE_RESET_ALL) &&
-			(is_abnormal || dm_zone_bio_needs_split(md, bio));
+		need_split = is_abnormal || dm_zone_bio_needs_split(md, bio);
 	} else {
 		need_split = is_abnormal;
 	}
-- 
2.49.0

