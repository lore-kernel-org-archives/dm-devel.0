Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08025A0FC;
	Sun,  3 Mar 2024 14:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709474552; cv=none; b=WfRm0dnY4aQmJaDifJTe0gqeNNCsxbghGr/fk4fIBZ2Xd+jntFpmc6W6u6aIZ6V5Z/SQa+L1sVqtfZMspsR65kHA4fxBDkSaSKGluRL8FisEOBPwlyPKiMqSX6ZQAVqNGjRRLYQIa+7jEpPj6K3Ryvnx3N02DeJQN8349D2QChM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709474552; c=relaxed/simple;
	bh=kFfvcvIwAY3mFC3pnSuEqjTVxH9IzhjT91DbCCSoaR8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OlBt/nkhRSz4rWzSWXHi+4MkvnqmiRMYfsckLBax7BXtXHdmT71Fk20DSWtvuzL5OaOZATXx6EU0y98PZoCYm51G4YwMyqfikmprgid0owzegr6Sg6wyuKXMBom/ZPdyz+zVcMGEyO1eh9EB/XGU9T/GuJwBgv5tzTQgcyip2VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=p/EM0UDN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="p/EM0UDN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=1hEyHs3RXys2pPpM0x+T8ikO/Q+ab47lWa7kxrpT+8k=; b=p/EM0UDNMFze8WhB5VPiCOxOJN
	dFnXlxSayouoYNiCU/b7VvAPCuunWfpAvDGyjPkhtoxQHhey92g0UGi5HLJNuSmOPJSRKXBJSRt/P
	M1FV7D+kzlZ4xggg8VdTpD/CPJNXHdCOpq4pdJMqLitBkhkOOIaWHD8tqwAiAdcBhILbhEZjpUyR4
	0qT4wXPxwZBGxW3gQ1hrzMCUG23o7MTrdmAaezBGEXeMDUX8a2y72qH6soGvHVgoUXTsd0ICHFcqt
	xZSpXAqaNoHUwRLBOGQzCY1XZQ/Nw0FupgdmefpykF3W0dst2Yxoxzd988hCYCgxC+kFeVnmIZ3EJ
	WJmPOpvA==;
Received: from [206.0.71.27] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rgmQ9-000000061vc-1Kjh;
	Sun, 03 Mar 2024 14:02:29 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH 09/11] md: don't initialize queue limits
Date: Sun,  3 Mar 2024 07:01:48 -0700
Message-Id: <20240303140150.5435-10-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240303140150.5435-1-hch@lst.de>
References: <20240303140150.5435-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Initial queue limits are now set from ->run.  Remove the superfluous
initialization in md_alloc and level_store.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed--by: Song Liu <song@kernel.org>
Tested-by: Song Liu <song@kernel.org>
---
 drivers/md/md.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9a7f3d2b8c2d16..f564ad051a427d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4173,7 +4173,6 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 		mddev->in_sync = 1;
 		del_timer_sync(&mddev->safemode_timer);
 	}
-	blk_set_stacking_limits(&mddev->queue->limits);
 	pers->run(mddev);
 	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 	if (!mddev->thread)
@@ -5859,7 +5858,6 @@ struct mddev *md_alloc(dev_t dev, char *name)
 	disk->private_data = mddev;
 
 	mddev->queue = disk->queue;
-	blk_set_stacking_limits(&mddev->queue->limits);
 	blk_queue_write_cache(mddev->queue, true, true);
 	disk->events |= DISK_EVENT_MEDIA_CHANGE;
 	mddev->gendisk = disk;
-- 
2.39.2

