Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00EA92DFA2F;
	Wed, 25 Jun 2025 09:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750844139; cv=none; b=Ek6SdOwmF8zQtG+etyNh3fi4UkBgdXXUiEtCsBnU/Fqgc1qhFTXNCXgDbez5lJK/Kjkpg/sc0raiKfVGYEyDDuVoiOB8Z1oYyF02BL0WKKatu+AtnzR6t7TSNURVUGSYD1LHBLwiG6vhZVFkouT804JIc4CtGgyv7nKdxNIayGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750844139; c=relaxed/simple;
	bh=Ib8xlgtRgLHP3I0038y8eG6QJibB5hQxTpwY4tpZGic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MoPl3aBUYM6v1TIZiNNflqBHEm4cYBFNA7ZPv3Q/tiFAwYe+2CNVyX+Umfrfs/Qfgnz+msqP1MMeB85tLKbi1/cYNJiBZLbhwOxUWfEN2hoE8iosEp5IFFdwBr04PfL2oRudetXi0BYWGk0eI0SE48z6fHrpjDqh5Cb/2vPzO2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z+kt2kxb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z+kt2kxb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9FB4C4CEF1;
	Wed, 25 Jun 2025 09:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750844137;
	bh=Ib8xlgtRgLHP3I0038y8eG6QJibB5hQxTpwY4tpZGic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z+kt2kxb6cnQng7iIpIyfzFqKajufUWPiwytblVXYEhuaUmgS9lXPjuNYMLrpLLet
	 GI7Cmx4RzllbvyjKLSssXsTYxlyLdhZbPPyblXV1T0wft1Z/gB7W2rk+D2jTeiAAIO
	 9R3aHZtAVtRJxrZ9ixdib+VZthJDZjtUUnPK98iK0JEomFIwCtj/CDnVivCkv5pDWZ
	 xIvAzwY1oc3glHu6ZWtqzum37ldUqJdVbvJ4uaAAMCNxoNrArWd2Q3CmlYqSYauPe5
	 PIdPllduJLrc3DQ/b9fgazzvB2Hf4To6XhMcs+j8X1L7sUXWnCVUPikwXPakue+ECJ
	 Fl83BzjVFygMg==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 5/5] dm: Check for forbidden splitting of zone write operations
Date: Wed, 25 Jun 2025 18:33:27 +0900
Message-ID: <20250625093327.548866-6-dlemoal@kernel.org>
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
index f1e63c1808b4..f82457e7eed1 100644
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

