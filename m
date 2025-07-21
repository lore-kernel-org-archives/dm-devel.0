Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30F62E264B;
	Mon, 21 Jul 2025 17:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753118235; cv=none; b=D4IpMqvChszcWRS0BcsY3qzmJkxU0hLEYJlp6+f2sSfoAL1OL0efBsZWIJ5Wf+hgGmI+R2ehUVU9k4RiskStt7qcOEzp+zY9LAcHE3dsih/n/yBEyHnR60JHIt4t9cnXldcXvypPOU3s/urMmsjatjlPoanjqQ2ulRlDIWRMk8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753118235; c=relaxed/simple;
	bh=ySjBQzRtjPZka/V0AkthCdwIssEqa8Xr9ivfpBpWgKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Frxg2LxNU+PSIG0UVYisHCYrlnXnpsrx5Lzdp0MhMP3JqArTal3LR3bcWkmJpUu0wmD5YYmbU/pLe6HaLYtwJoJX+zJOuZJXRAwL+wQ4ayISdBg+X+mr/TOUoRIR4yLkgKlVL69hOd6KRrVbOdHcMZAVYfXGFZfLcVIKLkecYl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qIJ2CVtF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qIJ2CVtF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC8AC4CEED;
	Mon, 21 Jul 2025 17:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753118235;
	bh=ySjBQzRtjPZka/V0AkthCdwIssEqa8Xr9ivfpBpWgKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qIJ2CVtFF9ZCP6VArqlqJhbtuePv36W1LhVLyZosdWMrYnVOE/tBvwBoANbUxgP+H
	 TDYUZUVaMWBsMeWQ3+nV6snN7M1EuulP6p8FvzaCjXPVW0CWu34ldnTJlx64AfKJF8
	 vbqqsq0dqdiQp7McgB5Kp3UUkumH+YoRDvxDBHkzHEQAd56ilQupCfsKOeLcJrFeEj
	 sGRRsMpXfkD5CrmOqsMSnWX00ut2KmeG3ny6gW02YFpjmLCb6OqIgqLEq8uGM0xxzS
	 jtUqq4H/vt9lQLttqstWLmZhZPOghE74YY2hc5wDF/lZg41iAOeOATRZQPwv55OXcS
	 YmwEGN4XaribA==
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
	johnny.chenyi@huawei.com
Subject: [PATCH v4 08/11] md/md-bitmap: add a new method blocks_synced() in bitmap_operations
Date: Tue, 22 Jul 2025 01:15:54 +0800
Message-ID: <20250721171557.34587-9-yukuai@kernel.org>
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

Currently, raid456 must perform a whole array initial recovery to build
initail xor data, then IO to the array won't have to read all the blocks
in underlying disks.

This behavior will affect IO performance a lot, and nowadays there are
huge disks and the initial recovery can take a long time. Hence llbitmap
will support lazy initial recovery in following patches. This method is
used to check if data blocks is synced or not, if not then IO will still
have to read all blocks for raid456.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/md-bitmap.h | 1 +
 drivers/md/raid5.c     | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 95453696c68e..5f41724cbcd8 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -90,6 +90,7 @@ struct bitmap_operations {
 	md_bitmap_fn *end_discard;
 
 	sector_t (*skip_sync_blocks)(struct mddev *mddev, sector_t offset);
+	bool (*blocks_synced)(struct mddev *mddev, sector_t offset);
 	bool (*start_sync)(struct mddev *mddev, sector_t offset,
 			   sector_t *blocks, bool degraded);
 	void (*end_sync)(struct mddev *mddev, sector_t offset, sector_t *blocks);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 519bbfb67dcb..c1ac4da1119f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3748,6 +3748,7 @@ static int want_replace(struct stripe_head *sh, int disk_idx)
 static int need_this_block(struct stripe_head *sh, struct stripe_head_state *s,
 			   int disk_idx, int disks)
 {
+	struct mddev *mddev = sh->raid_conf->mddev;
 	struct r5dev *dev = &sh->dev[disk_idx];
 	struct r5dev *fdev[2] = { &sh->dev[s->failed_num[0]],
 				  &sh->dev[s->failed_num[1]] };
@@ -3762,6 +3763,11 @@ static int need_this_block(struct stripe_head *sh, struct stripe_head_state *s,
 		 */
 		return 0;
 
+	/* The initial recover is not done, must read everything */
+	if (mddev->bitmap_ops && mddev->bitmap_ops->blocks_synced &&
+	    !mddev->bitmap_ops->blocks_synced(mddev, sh->sector))
+		return 1;
+
 	if (dev->toread ||
 	    (dev->towrite && !test_bit(R5_OVERWRITE, &dev->flags)))
 		/* We need this block to directly satisfy a request */
-- 
2.43.0

