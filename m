Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B68026E701;
	Mon, 18 Aug 2025 04:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755493106; cv=none; b=TSoytNiIo03k/oEMkrlbIB7j9qPUhrBLlbv+ISNLwdXuKUb8i8nm0Ailci79QiMvkYu5BKBfMc9EU71QNWouKMZD3Kh3l6VIyD321oNgVw7mtIlCCclu8RO5PmUhrLfNyb6NZKPElTtZvjCfrmE2P32Ab+3ROQAHLsGA7vehoUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755493106; c=relaxed/simple;
	bh=SUfLVmpBc3BQmXUTyJz2HWAWVwX9Rq+OXCXDUzW4zuI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M3+KVZmb/ONBavmOI/KWvTnabmVLV+0FxL2R3eI+iSLmx+HZbyyn9eyak21tP+xjsDLQUlQoPpRGS0dD9Pdqwumz9FDJkjMWFu0LJBlxcV/93t3ZvNqbx+/7piDeRTb6pnCYC1UhZXnoQZdEbI+81hRXGc4wtj0SYH1tUYn0SXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=beehFWbU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="beehFWbU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=SK39JpU56EkW4j23uc8aJhcASS5XFIDeSdN2dDsuzZM=; b=beehFWbUhHfRvA2f0jH3/s4Ci4
	qPWKee8qDlmJ5NuNZyPay/CxozQjfuut4y43PptB+sKxs0M4Z/W+PPM0R/iudYN4yfKeMai2rFBG0
	CkupZQMEEyYpZuRbqY/YDROsgsukq6Os05f2NxIsru+vzBhKe8FfJ5olZUkVRbIys0ZxoalKrohOm
	YF7ZcaV1mo9ismSe4prvbB3omlXMJOF0fO9WdRPFdYx9CBK3EP3mfXOME/hIxsBrFRVVdqO8/DaHd
	8qmbgXRJnDMqa/UEQpWNJfTpPLze8YN4+7RESyp+hPFFFWh18W4AHgUtw0udfwFPTNPHJzO2co5el
	tvCJG0zQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1unrwu-00000006Vd3-1eaa;
	Mon, 18 Aug 2025 04:58:24 +0000
From: Christoph Hellwig <hch@lst.de>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	dm-devel@lists.linux.dev
Cc: linux-block@vger.kernel.org
Subject: [PATCH] dm error: mark as DM_TARGET_PASSES_INTEGRITY
Date: Mon, 18 Aug 2025 06:58:21 +0200
Message-ID: <20250818045821.1483488-1-hch@lst.de>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Mark dm error as DM_TARGET_PASSES_INTEGRITY so that it can be stacked on
top of PI capable devices.  The claim is strictly speaking as lie as dm
error fails all I/O and doesn't pass anything on, but doing the same for
integrity I/O work just fine :)

This helps to make about two dozen xfstests test cases pass on PI capable
devices.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-target.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
index 2af5a9514c05..8fede41adec0 100644
--- a/drivers/md/dm-target.c
+++ b/drivers/md/dm-target.c
@@ -263,7 +263,8 @@ static long io_err_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
 static struct target_type error_target = {
 	.name = "error",
 	.version = {1, 7, 0},
-	.features = DM_TARGET_WILDCARD | DM_TARGET_ZONED_HM,
+	.features = DM_TARGET_WILDCARD | DM_TARGET_ZONED_HM |
+		DM_TARGET_PASSES_INTEGRITY,
 	.ctr  = io_err_ctr,
 	.dtr  = io_err_dtr,
 	.map  = io_err_map,
-- 
2.47.2

