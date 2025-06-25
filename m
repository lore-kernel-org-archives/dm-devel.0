Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151A11CAA82;
	Wed, 25 Jun 2025 06:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750831279; cv=none; b=X0DjNYJ/MMlgi3T5rOSED4BmtTb507W0NG5k2joSC/Vo+lNdA4yLXnRlbLcJH33EdHJzHogz5pr6uckvAcEt1JvC4ILzdZpAhwa3EkVMxWGT8Q7sOHW7ej8thEZnKWXLHYiR1X7vLrD4j5a0/cz4J1IMqWPQL9ze6TI1usaMFd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750831279; c=relaxed/simple;
	bh=1owoDQVBXBdEbexbo6XNuxVETLndmRZ9qUaGxXMqPR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AZAWppe9+LgG78jNmRREXVpWYt57H7AuoHdkiYwYnJKDkKPPZvE6f5CNhcMaAtPKgb4YeqjYpQWn+V+iHOhdT0WNU0rQ5dacELa/VSViuJa6OaihDu3KYXD33qXjHLHLUxGCoMCwodJDpaJaG4etV7fC/7X/N1wF2fqUoUp2QP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KdDWxqMa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KdDWxqMa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF53C4CEEA;
	Wed, 25 Jun 2025 06:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750831278;
	bh=1owoDQVBXBdEbexbo6XNuxVETLndmRZ9qUaGxXMqPR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KdDWxqMaHRrwbqvIT2+6g2JTLCluUQWkhYw54mXg+J7RFDSFXqrgUYKVZpEVekfXX
	 c0hlCmDtzWkVTmlOTxYa7MsxA+jozhBmXSz86gGSXtjB7qJJBYnngbfBYz3s77jtc/
	 /A3GYkF0NXEa4pIBm4pw2EXhpNSUe64U1zP+fb8Aheqg1QyQHtD7Dt+PE4f+QD60gn
	 NQQHM1L+wAzzsYfFK17UNaR5DHwJDUCV9f5BHeSU4FgASph7o6CHQqiwNwjg6jKZpS
	 InmXmZAmlbrq2vxvWAYWLez3J2fO6CMZqDmqzFcBUdpcDDk5PFiXzr+VwX3x8neJ8o
	 vBqQshahzzaBw==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 4/4] dm: Check for forbidden splitting of zone write operations
Date: Wed, 25 Jun 2025 14:59:08 +0900
Message-ID: <20250625055908.456235-5-dlemoal@kernel.org>
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

DM targets must not split zone append and write operations using
dm_accept_partial_bio() as doing so is forbidden for zone append BIOs,
breaks zone append emulation using regular write BIOs and potentially
creates deadlock situations with queue freeze operations.

Modify dm_accept_partial_bio() to add missing BUG_ON() checks for all
these cases, that is, check that the BIO is a write or write zeroes
operation. This change packs all the zone related checks together under
a static_branch_unlikely(&zoned_enabled) and done only if the target is
a zoned device.

Fixes: f211268ed1f9 ("dm: Use the block layer zone append emulation")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/md/dm.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index e01ed89b2e45..86647dcaf981 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1286,8 +1286,9 @@ static size_t dm_dax_recovery_write(struct dax_device *dax_dev, pgoff_t pgoff,
 /*
  * A target may call dm_accept_partial_bio only from the map routine.  It is
  * allowed for all bio types except REQ_PREFLUSH, REQ_OP_ZONE_* zone management
- * operations, REQ_OP_ZONE_APPEND (zone append writes) and any bio serviced by
- * __send_duplicate_bios().
+ * operations, zone append writes (native with REQ_OP_ZONE_APPEND or emulated
+ * with write BIOs flagged with BIO_EMULATES_ZONE_APPEND) and any bio serviced
+ * by __send_duplicate_bios().
  *
  * dm_accept_partial_bio informs the dm that the target only wants to process
  * additional n_sectors sectors of the bio and the rest of the data should be
@@ -1320,11 +1321,19 @@ void dm_accept_partial_bio(struct bio *bio, unsigned int n_sectors)
 	unsigned int bio_sectors = bio_sectors(bio);
 
 	BUG_ON(dm_tio_flagged(tio, DM_TIO_IS_DUPLICATE_BIO));
-	BUG_ON(op_is_zone_mgmt(bio_op(bio)));
-	BUG_ON(bio_op(bio) == REQ_OP_ZONE_APPEND);
 	BUG_ON(bio_sectors > *tio->len_ptr);
 	BUG_ON(n_sectors > bio_sectors);
 
+	if (static_branch_unlikely(&zoned_enabled) &&
+	    unlikely(bdev_is_zoned(bio->bi_bdev))) {
+		enum req_op op = bio_op(bio);
+
+		BUG_ON(op_is_zone_mgmt(op));
+		BUG_ON(op == REQ_OP_WRITE);
+		BUG_ON(op == REQ_OP_WRITE_ZEROES);
+		BUG_ON(op == REQ_OP_ZONE_APPEND);
+	}
+
 	*tio->len_ptr -= bio_sectors - n_sectors;
 	bio->bi_iter.bi_size = n_sectors << SECTOR_SHIFT;
 
-- 
2.49.0

