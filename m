Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C9056465;
	Mon, 26 Feb 2024 10:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708943437; cv=none; b=QQeRGDScQCEclD8xO+5CSTPORD5XIWv8X24PKQQcFUS0CXEPIPNeQ/yi0/slVVVIlAO8zFYFfBY28j/zCYVPJ9hbx6GameYwp5EqvzyhesUhv1uwxoyvzu/tZBKPmNtwp1JpMBw1nwMdOHi5O3WBPdVBXPq7s0QC/9OXUPl/XG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708943437; c=relaxed/simple;
	bh=qpx5ZfsXN/PL+1OUdl1bDP6qACVTtOCO66trsr+igSI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YRuIpZVwgax4qSUDXv4+Gi8vJXJIL1echjNuc0eHURuh1ZWn6K50jw9tiUL6xVs2C5o6peC+5WTu19VhzFElV1iwKabVkEFkjzjt2w/TLBIyH2cACkbemnSkew3x5p7zhrgrjhjMn3t7XkFTcAl3B9ZpY6ZbmFk8XT2IdmhT3V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aGlUIGI+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aGlUIGI+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=58hQxzCOBh09HYswQ4p4ZVLnJZqyofksZjan/0dqSg4=; b=aGlUIGI+A60ujJC00FlheS2EJM
	3Q5lRJ1gs46mcAW771vCLA0jCcjBFqdJwpOMNtJ/OcKlJxk1NTlg9DXwyqLRAiAv8cu7+P1jn+tW6
	618kRbozhUwQi8XTiyW7Lcf8QhLOPU8JunLuqDegmYa5NcpBOVXqQSSSU/MalH2YVRSCjbcUpb4F3
	Pc1yBa0ktz3xBkNFNeLILR1Fhu1mdsPxoxad5m9uPLzT2a7MTD4HtK4T5/31cTc27CXL5/Qzz5Pzt
	5aKtfx9HAJUsL/C9QICWiZL+SQ4OvuGJmqsgUJGOVaeSe4SeBBPSgwRGmBEcPPu0w9HLSEGPYtX5W
	o3slJx2A==;
Received: from 213-147-167-65.nat.highway.webapn.at ([213.147.167.65] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1reYFi-000000004ep-11yj;
	Mon, 26 Feb 2024 10:30:31 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	=?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>
Cc: drbd-dev@lists.linbit.com,
	dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH 04/16] md: add queue limit helpers
Date: Mon, 26 Feb 2024 11:29:52 +0100
Message-Id: <20240226103004.281412-5-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240226103004.281412-1-hch@lst.de>
References: <20240226103004.281412-1-hch@lst.de>
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

