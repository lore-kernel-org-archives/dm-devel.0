Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D98D76F19;
	Wed, 28 Feb 2024 22:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709161020; cv=none; b=Ejvsp+IIA1GQnTwEQoZ25S+Ewij/9XnESGkHny2VqgKIKphjeSeeyvbsQf7GO2/r82TVs4USmWMy2KBSx0zorBxhwERmx+LEzVM9COsMN8mYFZcPLYOoiecrnTmfNr6KestHMrbG+UVAl3jU+cF2x+ePyC6Zji9jFObHJ7Q1t4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709161020; c=relaxed/simple;
	bh=T16dA4uPo0S1sJZzggzJbFctchiWrhrEDks57vuCR7Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SfE88XsT9aZVhDLuTpC+5mDiZqOjTL0n56Fw7I1sxQFQwwnVXYgAxa+UUjwZ346Gn0XBkRtfifSYoNU5cn6MfNCSSD5rJH2zs+LWVPyjSFThKY5fk6bP7ufquoORPNcifKaSdq3k3t/k3L3IldWmGYDOGGsuy9F4QHoJoUCKbNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Gk1sdSag; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Gk1sdSag"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=uwaMl+cldStB6V1bOYa8zhyrgxqTQSHxDG1wSziHQE4=; b=Gk1sdSagLF2A5YiHC38A++Xb7K
	822/DiTE5u0GQyT6EcdoOz6Rb3sn94HTsh2UJfMF1BNBsXHtQ5a6Vxgj73CFESHx/406tQbXox93B
	akz5bub7Me0a+uERR72BU8pxBU5TlhXj19JKFWIoyRjo46OWn1p9MUUbORQOdUyIXax/DFukaPBTt
	wUTs3HlWeMBkzOYrFbnJes0UiVEuD+738nZlzDPlH775gZmU3q05Hfz4h5xhHOQVSRfTrVCkLvMwz
	8OYtM4Qe0UnPM8KpRa77Gfn6Wal1rptJPg57IYhs9eCEoAWFTzStrvb9ExF6H8OKwmrZvu22jzpRt
	nwSg3coA==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfSrB-0000000BCP2-2oge;
	Wed, 28 Feb 2024 22:56:57 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH 09/14] md/raid1: use the atomic queue limit update APIs
Date: Wed, 28 Feb 2024 14:56:48 -0800
Message-Id: <20240228225653.947152-10-hch@lst.de>
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

Build the queue limits outside the queue and apply them using
queue_limits_set.  To make the code more obvious also split the queue
limits handling into a separate helper function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/raid1.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 3b1227f67a6d61..75329ab2dbd8de 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1782,10 +1782,9 @@ static int raid1_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 	for (mirror = first; mirror <= last; mirror++) {
 		p = conf->mirrors + mirror;
 		if (!p->rdev) {
-			if (!mddev_is_dm(mddev))
-				disk_stack_limits(mddev->gendisk, rdev->bdev,
-						  rdev->data_offset << 9);
-
+			err = mddev_stack_new_rdev(mddev, rdev);
+			if (err)
+				return err;
 			p->head_position = 0;
 			rdev->raid_disk = mirror;
 			err = 0;
@@ -3077,12 +3076,21 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 	return ERR_PTR(err);
 }
 
+static int raid1_set_limits(struct mddev *mddev)
+{
+	struct queue_limits lim;
+
+	blk_set_stacking_limits(&lim);
+	lim.max_write_zeroes_sectors = 0;
+	mddev_stack_rdev_limits(mddev, &lim);
+	return queue_limits_set(mddev->queue, &lim);
+}
+
 static void raid1_free(struct mddev *mddev, void *priv);
 static int raid1_run(struct mddev *mddev)
 {
 	struct r1conf *conf;
 	int i;
-	struct md_rdev *rdev;
 	int ret;
 
 	if (mddev->level != 1) {
@@ -3110,10 +3118,9 @@ static int raid1_run(struct mddev *mddev)
 		return PTR_ERR(conf);
 
 	if (!mddev_is_dm(mddev)) {
-		blk_queue_max_write_zeroes_sectors(mddev->queue, 0);
-		rdev_for_each(rdev, mddev)
-			disk_stack_limits(mddev->gendisk, rdev->bdev,
-					  rdev->data_offset << 9);
+		ret = raid1_set_limits(mddev);
+		if (ret)
+			goto abort;
 	}
 
 	mddev->degraded = 0;
-- 
2.39.2

