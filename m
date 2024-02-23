Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC80F81ACE;
	Fri, 23 Feb 2024 16:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708704793; cv=none; b=PFYh0fK0z74avMLkiWk6HEiMSL2vajOZfNWt9+vNzsWeI/CnJ/0wJejbSNUCAeK/HD2UUFJgut1SGqLLzAIVKfFBY7ARvvENF8/x04xZU0jV/42kvAcjiOf40huBpWjd60vjB7Ci/MJN2R94ihWm4lSgSDV0hsgrLdhC9QR/q4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708704793; c=relaxed/simple;
	bh=qpx5ZfsXN/PL+1OUdl1bDP6qACVTtOCO66trsr+igSI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Xa/FDW86GL4AOEt+fhi/gkpCbz2HCtWDwadCOTT0jmjaUFGhDDUlQfg+cvN5ZtkpOcxWeqrrYqjBU1iJMr5xpZTQ2luLTOgMRKFIl9dNKo+6rw7WKA8bwX8qPS/g1qBOjE0FxivrspMBYDyWn4bYRs5vmeIxz59fOoyh41XvlEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mCavDDXd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mCavDDXd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=58hQxzCOBh09HYswQ4p4ZVLnJZqyofksZjan/0dqSg4=; b=mCavDDXdHuHwdJUogbCk//k9SD
	a81mbbYTtPnTNXdGxP4QVMAJ24LgdaScMzxUzx6kRpqD2DPVg3j+22ODiaiiu4c9izvnnwggB9GMG
	ttcsXF1e5qWclwqoSw3feMCKSVRc47AubeB4EUkpDrjzWUt9A3pZCs/iESFxaAXSnQ0d9UM2jYm3K
	fmsuUmgFPIy1T5+VsZcqziB4SwdlqCDEhZNQDetqGJGd1baRQBU3ichLP97/T94SbqszcR74ph8SV
	iG368x+DZNK/JLsdZyAX0yNayJJxHV6hp7+rSZ+k28F4Mdurz5giR5KJlbVMK5maRrNNjrwxtw8Ro
	j+Md2EWg==;
Received: from [2001:4bb8:19a:62b2:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rdYAd-0000000AAkD-4BEM;
	Fri, 23 Feb 2024 16:13:08 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH 4/9] md: add queue limit helpers
Date: Fri, 23 Feb 2024 17:12:42 +0100
Message-Id: <20240223161247.3998821-5-hch@lst.de>
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

Add a few helpers that wrap the block queue limits API for use in MD.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 37 +++++++++++++++++++++++++++++++++++++
 drivers/md/md.h |  3 +++
 2 files changed, 40 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 75266c34b1f99b..23823823f80c6b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5699,6 +5699,43 @@ static const struct kobj_type md_ktype = {
 
 int mdp_major = 0;
 
+/* stack the limit for all rdevs into lim */
+void mddev_stack_rdev_limits(struct mddev *mddev, struct queue_limits *lim)
+{
+	struct md_rdev *rdev;
+
+	rdev_for_each(rdev, mddev) {
+		queue_limits_stack_bdev(lim, rdev->bdev, rdev->data_offset,
+					mddev->gendisk->disk_name);
+	}
+}
+EXPORT_SYMBOL_GPL(mddev_stack_rdev_limits);
+
+/* apply the extra stacking limits from a new rdev into mddev */
+int mddev_stack_new_rdev(struct mddev *mddev, struct md_rdev *rdev)
+{
+	struct queue_limits lim = queue_limits_start_update(mddev->queue);
+
+	queue_limits_stack_bdev(&lim, rdev->bdev, rdev->data_offset,
+				mddev->gendisk->disk_name);
+	return queue_limits_commit_update(mddev->queue, &lim);
+}
+EXPORT_SYMBOL_GPL(mddev_stack_new_rdev);
+
+/* update the optimal I/O size after a reshape */
+void mddev_update_io_opt(struct mddev *mddev, unsigned int nr_stripes)
+{
+	struct queue_limits lim;
+	int ret;
+
+	blk_mq_freeze_queue(mddev->queue);
+	lim = queue_limits_start_update(mddev->queue);
+	lim.io_opt = lim.io_min * nr_stripes;
+	ret = queue_limits_commit_update(mddev->queue, &lim);
+	blk_mq_unfreeze_queue(mddev->queue);
+}
+EXPORT_SYMBOL_GPL(mddev_update_io_opt);
+
 static void mddev_delayed_delete(struct work_struct *ws)
 {
 	struct mddev *mddev = container_of(ws, struct mddev, del_work);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 8d881cc597992f..25b19614aa3239 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -860,6 +860,9 @@ void md_autostart_arrays(int part);
 int md_set_array_info(struct mddev *mddev, struct mdu_array_info_s *info);
 int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info);
 int do_md_run(struct mddev *mddev);
+void mddev_stack_rdev_limits(struct mddev *mddev, struct queue_limits *lim);
+int mddev_stack_new_rdev(struct mddev *mddev, struct md_rdev *rdev);
+void mddev_update_io_opt(struct mddev *mddev, unsigned int nr_stripes);
 
 extern const struct block_device_operations md_fops;
 
-- 
2.39.2

