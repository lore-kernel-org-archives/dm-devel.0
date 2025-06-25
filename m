Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE80D2E0B72;
	Wed, 25 Jun 2025 09:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750844137; cv=none; b=hamupPaQZA/vAkIwH+q7QOuM5yf2wKgTRxm2UCzO0NaKj2oDrL/nZ8AYmFkveDZ918HqBUVX/Iuw4UInBaEBdBHja3WH755UIXS9bBgZvxsjFTvsy99MP9azPE8XcSLcYIBgsycj+l/Kx7WOutigj1df9CVssDfgb5gEGSc0YRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750844137; c=relaxed/simple;
	bh=eHPP3rvvh3/5BnnmvkOsb2rmtKQ3bHqJw3heyHto5o4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hotvJn7mIfKciCA5plzGtpZGmYS4cm2okFl+CldUPpCbwCgpmvrmeXPCEn+w8uFEv7MPOxTUVlWsD1BlkVKwcWYGW9sN5gf0sNd17LuGfcAoVNMMAhJxXMwSsHRZEXxNm9UVDuZfNhcr99IGwFhkNdY2tWllFu9g57BK0StSxm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qaysViao; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qaysViao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42C0C4CEEA;
	Wed, 25 Jun 2025 09:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750844135;
	bh=eHPP3rvvh3/5BnnmvkOsb2rmtKQ3bHqJw3heyHto5o4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qaysViao+I//eKeqY+Zm53JuyQTh8B6d/jhn8SfkGW+S+XF+JxoqYYxHclVOpT03q
	 opz89al0S1nl0lIUo4yHXd9sgUlHyhkW/+iws4LoTqF+DE3+x6uN8PTZYVU/homeq1
	 qRlCZlbVSO3Xj8/0B5n1sECc5NjYQ2Jf9ps99a8xWThhqOUif8XlkSxTwlHqD6v7Bz
	 rj0Y1yPV8mWYYKUT92QN6JBexKatPHZAPsRndV19y25xygnJe38HUAJ5XzgE0o0Lfp
	 0RYzOOq1B29G8FQZjVCHwUl56iSFx2BuJB5e3NXUAetIkGD187xmOkFguWxYBwLDfx
	 HIOa51IlCMXmQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 3/5] dm: Always split write BIOs to zoned device limits
Date: Wed, 25 Jun 2025 18:33:25 +0900
Message-ID: <20250625093327.548866-4-dlemoal@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250625093327.548866-1-dlemoal@kernel.org>
References: <20250625093327.548866-1-dlemoal@kernel.org>
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
 drivers/md/dm.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index e477765cdd27..f1e63c1808b4 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1773,12 +1773,29 @@ static inline bool dm_zone_bio_needs_split(struct mapped_device *md,
 					   struct bio *bio)
 {
 	/*
-	 * For mapped device that need zone append emulation, we must
-	 * split any large BIO that straddles zone boundaries.
+	 * Special case the zone operations that cannot or should not be split.
 	 */
-	return dm_emulate_zone_append(md) && bio_straddles_zones(bio) &&
-		!bio_flagged(bio, BIO_ZONE_WRITE_PLUGGING);
+	switch (bio_op(bio)) {
+	case REQ_OP_ZONE_APPEND:
+	case REQ_OP_ZONE_FINISH:
+	case REQ_OP_ZONE_RESET:
+	case REQ_OP_ZONE_RESET_ALL:
+		return false;
+	default:
+		break;
+	}
+
+	/*
+	 * Mapped devices that require zone append emulation will use the block
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
 	if (!bio_needs_zone_write_plugging(bio))
@@ -1927,9 +1944,7 @@ static void dm_split_and_process_bio(struct mapped_device *md,
 
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

