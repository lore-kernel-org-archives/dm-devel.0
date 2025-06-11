Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DD42D5432
	for <dm-devel@lists.linux.dev>; Wed, 11 Jun 2025 01:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749604528; cv=none; b=kHPKpURjEcmiogopCaNFm+chzNgRC1UCMf3QRtP2ZB18PGSWBOdcsl9sH3kartjS8N0Kr3cwaePu0yjwAPoBbtUBpK4DhmpYenQ7AOVApvKb8ysb3teUlejoQot3hMSiiLAFgYQ0y4dGv5on3WzMhw4zScMLeUgmEjeDJo/0MUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749604528; c=relaxed/simple;
	bh=cUfvJ38TTS+iHhLonY0dCmQoFZhXYbyl/38gdKaGy0I=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QZ2OEekiqsU9RJYl3lWy0Iaw+1rs00f+iC7rNNc7YI4RRNJbmJsN6YMRLM0TsnkUDxpqfb3gSUREzfPQ52YGwrzWuzm3/2Cxr+wWKn7Zmf9AQ9gOnjcoEcSIKhUVFTdrBRxioJwHoHuGPy634TbrYtf18UkD9MSJGQ3Se+KQjMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fJ+lbs9T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fJ+lbs9T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 305DAC4CEED;
	Wed, 11 Jun 2025 01:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749604528;
	bh=cUfvJ38TTS+iHhLonY0dCmQoFZhXYbyl/38gdKaGy0I=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=fJ+lbs9TjRQgs6SZq1Md9sD8NfykR+DAcyxCWP953UYNaftrJkypwvDlS1WRyj8ED
	 Nf0YGzrxWQz0RtsM7j2NTuNV0CK5C4jSV8h847hJGlcXZ4BW6fkjQT3Tbc93Y8FLCn
	 l+UEl/cuE3mBLLDrvCZ/2gQirF59VLvbLkVsLdEFI2f4h7ylIJWb3+WdOUVqajbuho
	 vCFkxFqHsi++hLHFrCDcS+0delHGsnRTOdODrn8CFUlHCSQMTKi1RXZXFZWN81vUVj
	 6KlAJu/Xt4ranpqXvNXQcnB2ZYL6rGpyAcdDECu3mYvrSATOUxknFq8Q9jY9ve0LmI
	 tTQlBnBx+yVtg==
From: Damien Le Moal <dlemoal@kernel.org>
To: dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/2] dm: Check for forbidden splitting of emulated zone append operations
Date: Wed, 11 Jun 2025 10:13:40 +0900
Message-ID: <20250611011340.92226-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250611011340.92226-1-dlemoal@kernel.org>
References: <20250611011340.92226-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a DM target does not support native zone append, the block layer
zone write plugging will transform a REQ_OP_ZONE_APPEND operation into a
regular REQ_OP_WRITE BIO flagged with BIO_EMULATES_ZONE_APPEND. A DM
target must always be able to process such write request without
resorting to calling dm_accept_partial_bio() as otherwise, the original
BIO cannot indicate to the issuer a correct written sector on
completion. Make sure that dm_accept_partial_bio() is never called for
an emulated zone append BIO with a BUG_ON() check in
dm_accept_partial_bio().

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/md/dm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 55579adbeb3f..21920991ab28 100644
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
@@ -1322,6 +1323,7 @@ void dm_accept_partial_bio(struct bio *bio, unsigned int n_sectors)
 	BUG_ON(dm_tio_flagged(tio, DM_TIO_IS_DUPLICATE_BIO));
 	BUG_ON(op_is_zone_mgmt(bio_op(bio)));
 	BUG_ON(bio_op(bio) == REQ_OP_ZONE_APPEND);
+	BUG_ON(bio_flagged(bio, BIO_EMULATES_ZONE_APPEND));
 	BUG_ON(bio_sectors > *tio->len_ptr);
 	BUG_ON(n_sectors > bio_sectors);
 
-- 
2.49.0

