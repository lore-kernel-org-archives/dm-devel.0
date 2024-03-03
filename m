Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8A85A11A;
	Sun,  3 Mar 2024 14:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709474540; cv=none; b=kR5icVVxqP9hWg8BJQJNhjKttQi7fJg1+AN0fjgKRs1wOVzj2wqMVdljIE39E+DuDbnn/i+OJbZr59Clc3+ZjJeGKp6tMinQJJ4ub+9xCh1hg939+ddXoofibuIJ+HsImUrpA/uMd93jR3Qzhobemc5sDYEdqY0NooVwCT8IpzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709474540; c=relaxed/simple;
	bh=PJknENnzGqKTYL6XbypJX3zmTOAN1fFogRAd/0U/z2Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FpePEgleKpSb+2vxrOoPRo+fjTr3MTTgaeI7/7lLxFUuVsHWjsptU2sqi+VYBSoaQz+Q9nz/pcy3VNg10tSsz8pbKjMeZwM4h3mDJejxrQ2qp4E5NMhrSiAhdvhQWoc4y6ruyDdspk3Bx1c8PRIJEljAm4+pI4rQ2rHaasgBuf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vHiM/gF9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vHiM/gF9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=2bEVfBtv2paAJxkJku8hAomPcVgK2LRowJNeyncOGuE=; b=vHiM/gF9vdMkOa5fM61xrGHem2
	eRx88FyYG8XM/N6OJlDDlmiVTQx5fyKxMeP8HOKGmhD9azoFe6scMEd6srzXBuq2XnorcKlF4coI2
	RbAsCsLsBWHnIpowt59F+4dwzaY4IXgYdD5gcYQWiWHaHKgBwAqH8brTT9Jr4Vq5aw6zH1Kk9XmbI
	x/ufwoH7n4pzftGR+cDSGNOPbXs1Gj1RsaVndDO/86/H+iGvqrY0hK9Yum5B6Na3kg+vn21B4mnOH
	btYdxMYlYitCR585eEolVrPOeEm0OVL32mRjB+Xk9O7qb/QynkfY9c1/BtQ412eZh3t80ngbfh6bZ
	0EEktxjg==;
Received: from [206.0.71.27] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rgmPx-000000061o5-1m5A;
	Sun, 03 Mar 2024 14:02:17 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH 06/11] md/raid1: use the atomic queue limit update APIs
Date: Sun,  3 Mar 2024 07:01:45 -0700
Message-Id: <20240303140150.5435-7-hch@lst.de>
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

Build the queue limits outside the queue and apply them using
queue_limits_set.  To make the code more obvious also split the queue
limits handling into a separate helper function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed--by: Song Liu <song@kernel.org>
Tested-by: Song Liu <song@kernel.org>
---
 drivers/md/raid1.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index dd1393d0f08461..c3496837837720 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1926,12 +1926,11 @@ static int raid1_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 	for (mirror = first; mirror <= last; mirror++) {
 		p = conf->mirrors + mirror;
 		if (!p->rdev) {
-			if (!mddev_is_dm(mddev))
-				disk_stack_limits(mddev->gendisk, rdev->bdev,
-						  rdev->data_offset << 9);
+			err = mddev_stack_new_rdev(mddev, rdev);
+			if (err)
+				return err;
 
 			raid1_add_conf(conf, rdev, mirror, false);
-			err = 0;
 			/* As all devices are equivalent, we don't need a full recovery
 			 * if this was recently any drive of the array
 			 */
@@ -3195,12 +3194,21 @@ static struct r1conf *setup_conf(struct mddev *mddev)
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
@@ -3228,10 +3236,9 @@ static int raid1_run(struct mddev *mddev)
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

