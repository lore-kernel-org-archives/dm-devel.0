Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E97C72907;
	Wed, 28 Feb 2024 22:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709161026; cv=none; b=kAOdDJF15vEVMln9rUqEijvujzL7DAPtaLDbK8XWZfxJGc/OWHVaItONIks1WdzXK2/dS6OnUYblmlL4yae6KMlH+tFYHDwgPUPwCJLqPeMEHg3lgZgU5MEHUBtvt2Ys13y6yZ9bg0+wJOil3w8abHxUSkAJ7zcF0uAK7pNoUJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709161026; c=relaxed/simple;
	bh=VuNlpuWL+R0rZvazr8iGF9/zHlwENuoTzFR0Pa2F4aY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=W6VN1cGwIuyD+z8oj50IjFqdXfZ6q6qV6jLOpKSDi6V7DDCElVmXhtKXP3X/g72tuxbDrJoeOgrfxK5XZIgE7gULyKAN2mTKgCuUzOwcdK5+VlF4THBJxeLzUYu+P1Xj5rGnR7eMreJCWil2a8/Estz/dan7xcAe73f0whho7QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MhquiGMb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MhquiGMb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=pKUl55zXeZtPShGrrLRyzw4XvdT5TDobR0FI4r7jEZY=; b=MhquiGMbeNN6/T216LLxDYnkqh
	zoH5oc3oP7y/XRqiCHnrPOk3nuAsW5JnnpgeDr2iP6GvX75acpOUB32rG9IoH7LZkPNNjJ9KXsoEH
	eLled3TsNr+NGTvjUHCfUuofFA0vUPMmpwn0uXTxVV+dRPkGLikahfRX9vWGf6KzyPJUAd4LyjuuB
	xbnD+/rTK3lhavXF6mfNBx0qBhTCdBgC7N98z4yFmk6yAHoPZheJmbR7iBeEvI8D71c7C2p4zzllF
	h+8YCTXxErwJy22FRs/Zz7xVYhZg9KS7LhCI0c6E3FNGuw3eP4rbQMaPCtD11pqiVuIOvX3BUAuWZ
	VLlfnh8A==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfSrI-0000000BCPj-1FfQ;
	Wed, 28 Feb 2024 22:57:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH 12/14] md: don't initialize queue limits
Date: Wed, 28 Feb 2024 14:56:51 -0800
Message-Id: <20240228225653.947152-13-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240228225653.947152-1-hch@lst.de>
References: <20240228225653.947152-1-hch@lst.de>
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
---
 drivers/md/md.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index bfc38cb4b31014..eab1b36c1d02ef 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4155,7 +4155,6 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 		mddev->in_sync = 1;
 		del_timer_sync(&mddev->safemode_timer);
 	}
-	blk_set_stacking_limits(&mddev->queue->limits);
 	pers->run(mddev);
 	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 	if (!mddev->thread)
@@ -5825,7 +5824,6 @@ struct mddev *md_alloc(dev_t dev, char *name)
 	disk->private_data = mddev;
 
 	mddev->queue = disk->queue;
-	blk_set_stacking_limits(&mddev->queue->limits);
 	blk_queue_write_cache(mddev->queue, true, true);
 	disk->events |= DISK_EVENT_MEDIA_CHANGE;
 	mddev->gendisk = disk;
-- 
2.39.2

