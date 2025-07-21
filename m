Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B102E1C5B;
	Mon, 21 Jul 2025 17:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753118230; cv=none; b=bZQX+E4iYTZHokmyE1mLvQ1h1Bv0ImApwWBKVTTvP6O5bHoT+zLdexRyYey7CmVcN9spqvqBGHkreQI4BBkiTjt62+USdXmEj0PgNoH5U8Gj4PdHQv1HFhTE58oy2atRJQi9TwQ5RtgvS/S3WuCA0/tSUJ2sxypVdBGaix+PtW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753118230; c=relaxed/simple;
	bh=6Rzk93eRwFOdwhfFBl8w8D401AiA1qOoPbahxbNbl/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bgcaDxrgyjlDcqjDjVxyffU43pVX8qn2VNXp2HZbXPAWfIk7i0SGDZGGcX9leGZG6mSOFqrZDCUAq1+8kd9LSlwJSo/ooMGd6P6nMUCiOMieJJfPzRpCl1PxFncm/eIINpCqNvI/rxZ49YXqMkJNE0Q80IGC2ZaCJNpp5+ojFcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L5vJ37hV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L5vJ37hV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B13C4CEF4;
	Mon, 21 Jul 2025 17:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753118230;
	bh=6Rzk93eRwFOdwhfFBl8w8D401AiA1qOoPbahxbNbl/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L5vJ37hVD12XhHceTMKkdKIZ+PJP9zlA88t3ZSRzjDa2xOzogC0oWc5Vobp7IHr4Z
	 mRfmCQIHeli8cSc9xYFrLfi+TQwAi1zefNyQ+8jfEqUNRnFzgn45Knvbb9R5c3cX+J
	 38+oQi7uZ5yOi02wlNIz4/4bLJIHR+QypptS+gyVyPyf5eqMDWY/QNI4PVXwb44+Zh
	 ZbobzDjROV7IyfgapD2gYmQ9PzJWOp02k3LHEqt7Fw20lsRs+himVaXuDZ5Y+2JJH+
	 O+E17G5G2mLFKQdE0WCDu19qA3BjcGJ3lVfNKCb3uZt0ShopRiNlkj4j1BijAxTi6B
	 +Cjnmk63lgQGg==
From: Yu Kuai <yukuai@kernel.org>
To: corbet@lwn.net,
	agk@redhat.co,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	hch@lst.de,
	song@kernel.org,
	hare@suse.de
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com,
	johnny.chenyi@huawei.com,
	Xiao Ni <xni@redhat.com>
Subject: [PATCH v4 07/11] md/md-bitmap: add a new method skip_sync_blocks() in bitmap_operations
Date: Tue, 22 Jul 2025 01:15:53 +0800
Message-ID: <20250721171557.34587-8-yukuai@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250721171557.34587-1-yukuai@kernel.org>
References: <20250721171557.34587-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai3@huawei.com>

This method is used to check if blocks can be skipped before calling
into pers->sync_request(), llbitmap will use this method to skip
resync for unwritten/clean data blocks, and recovery/check/repair for
unwritten data blocks;

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Xiao Ni <xni@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/md-bitmap.h | 1 +
 drivers/md/md.c        | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 8616ced49077..95453696c68e 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -89,6 +89,7 @@ struct bitmap_operations {
 	md_bitmap_fn *start_discard;
 	md_bitmap_fn *end_discard;
 
+	sector_t (*skip_sync_blocks)(struct mddev *mddev, sector_t offset);
 	bool (*start_sync)(struct mddev *mddev, sector_t offset,
 			   sector_t *blocks, bool degraded);
 	void (*end_sync)(struct mddev *mddev, sector_t offset, sector_t *blocks);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 744cac10506b..71f39f9ce9ca 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9396,6 +9396,12 @@ void md_do_sync(struct md_thread *thread)
 		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
 			break;
 
+		if (mddev->bitmap_ops && mddev->bitmap_ops->skip_sync_blocks) {
+			sectors = mddev->bitmap_ops->skip_sync_blocks(mddev, j);
+			if (sectors)
+				goto update;
+		}
+
 		sectors = mddev->pers->sync_request(mddev, j, max_sectors,
 						    &skipped);
 		if (sectors == 0) {
@@ -9411,6 +9417,7 @@ void md_do_sync(struct md_thread *thread)
 		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
 			break;
 
+update:
 		j += sectors;
 		if (j > max_sectors)
 			/* when skipping, extra large numbers can be returned. */
-- 
2.43.0

