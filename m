Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF1284FA1;
	Fri, 23 Feb 2024 16:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708704796; cv=none; b=EnOslIaMbq8usIFPGfB78GnuHpD1sRgD0U5AKGBFxNozC4bVNxN/1jT9xjWGbvrEPd8kRxh+8SDYEBKLf0UbV4Rg/q0DxJfDXrXrjczRQf+bKDLer3g0Qc4QQZU1wR0nkyGkPXt+vQFZ5qo4NZaiidQnGICAhbXlGt2CzXrvp+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708704796; c=relaxed/simple;
	bh=mKwRPZU/UQcXEo3px/D5v/7XwWRHrzVu9x2yDVPti1U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UMFxjdPUuyODwzjcHy3CJBe9ycO6e1gryX7QV8Fl3Ggw2Th7ZvbJfFFFyNXpfcXYBHxXZ3DheQPvFK66zEjEcrAjLw8KnMlrEES5rMBTfX8e4LUEQD5rmuGsdwfFGI83NMzsx1OG0UT58rK6X3qMXBu2xdJlwqDnQ9q47sM68e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QFnbwKTX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QFnbwKTX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=GyO6JLPvWJHWdBIq99b9W/Hc0Q12PjuJv1kdwaFNu7o=; b=QFnbwKTXgIvAWMHYsoXyH3RHtP
	5e4E3tf6kzowePkmnMFg3EnEh/0LqWQL1HvSwJCVAQwMrm3+mqIgLd3T7lATcsUpqrS4zWSfZODjH
	yPFWWCPzFqCWB04r8iYawITZ4jNFy/IWtOTg06VgWS7ng7oxQeeGlI/yADUrjaN/UTxgFlpyialri
	6q46Pl1H8f14bUg9WiYULQQ9yq7b1C/SNnl/V9hCKZZ3ZuioGLP4t7Z4M6Q2jD4wH5AG0zc4/ty7q
	mbRFctOZ7SViJXiDl11IU/eOcm990a152gHq+NIvN/qU+P+nytAkR/WkPtc/K2K3pLYpGMdjjGnBI
	rmo9hvdg==;
Received: from [2001:4bb8:19a:62b2:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rdYAj-0000000AAmh-1QA0;
	Fri, 23 Feb 2024 16:13:14 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH 6/9] md/raid1: use the atomic queue limit update APIs
Date: Fri, 23 Feb 2024 17:12:44 +0100
Message-Id: <20240223161247.3998821-7-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240223161247.3998821-1-hch@lst.de>
References: <20240223161247.3998821-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Build the queue limits outside the queue and apply them using
queue_limits_set.  Also remove the bogus ->gendisk and ->queue NULL
checks in the are while touching it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/raid1.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 286f8b16c7bde7..752ff99736a636 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1791,10 +1791,9 @@ static int raid1_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 	for (mirror = first; mirror <= last; mirror++) {
 		p = conf->mirrors + mirror;
 		if (!p->rdev) {
-			if (mddev->gendisk)
-				disk_stack_limits(mddev->gendisk, rdev->bdev,
-						  rdev->data_offset << 9);
-
+			err = mddev_stack_new_rdev(mddev, rdev);
+			if (err)
+				return err;
 			p->head_position = 0;
 			rdev->raid_disk = mirror;
 			err = 0;
@@ -3089,9 +3088,9 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 static void raid1_free(struct mddev *mddev, void *priv);
 static int raid1_run(struct mddev *mddev)
 {
+	struct queue_limits lim;
 	struct r1conf *conf;
 	int i;
-	struct md_rdev *rdev;
 	int ret;
 
 	if (mddev->level != 1) {
@@ -3118,15 +3117,12 @@ static int raid1_run(struct mddev *mddev)
 	if (IS_ERR(conf))
 		return PTR_ERR(conf);
 
-	if (mddev->queue)
-		blk_queue_max_write_zeroes_sectors(mddev->queue, 0);
-
-	rdev_for_each(rdev, mddev) {
-		if (!mddev->gendisk)
-			continue;
-		disk_stack_limits(mddev->gendisk, rdev->bdev,
-				  rdev->data_offset << 9);
-	}
+	blk_set_stacking_limits(&lim);
+	lim.max_write_zeroes_sectors = 0;
+	mddev_stack_rdev_limits(mddev, &lim);
+	ret = queue_limits_set(mddev->queue, &lim);
+	if (ret)
+		goto abort;
 
 	mddev->degraded = 0;
 	for (i = 0; i < conf->raid_disks; i++)
-- 
2.39.2

