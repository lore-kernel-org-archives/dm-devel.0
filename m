Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E18772936;
	Wed, 28 Feb 2024 22:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709161019; cv=none; b=nOOeJe3uu0OrBA1muplODC//y+AgBx0bPHdMB//Qq3E2+Bu/5N+5vCqip6AY71ppkCtlxdE8ZnuT5W7Nx4DfExJHnLyR/bpmcxt4yqt+sEYQZRdpAm+o5nGsPB/I2Yjs2doBMfego097DVnMOqx2Io3Dl+bsdpUet7c2/iJb6E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709161019; c=relaxed/simple;
	bh=fO2OcLGc6ABvLwJD7bXwyyJ/UD6MJXBneMfAwO/gmXM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZLL4xedppDry83fAH0oc0Sgvj+Gg9akyptdrWvxavm9rFv6LcGK3tyNsVZJbv+Kvk3uYPNDwaY6xl9fgbA2FAZHwFO7uZzCSDZYczeKhCk/yLDhpidTB2JEx0OvVE92XP9sEXf3KvejvYDrJOtqFvk8041MfH7IHxpjEopxSjZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MIXeTVQj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MIXeTVQj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=4pEzXEENf2nRoMzp3gcfpwk0OQV71w8bWmGMmdfnx1A=; b=MIXeTVQjyKOHplmAgJDUp+AuKx
	uqXZPUWKQkdhIDcMJAx1pBCqcojrZAvmmtde4zwim7fpfIp5JfmjE7bqe/Zei2ejpho/Hx3TynW/3
	VUZO7CE1wA9ctjyT2/spRNF/mk3BMiMS3nndcMR5YUo7NgdqKrgL/lrCNgI8+XzHXmCkEDkDJNyAM
	ri34esTcN0MUOuKpHEpeVrxKRsSJ1AG1VRwKj9UpuRnnjO9YrQPc33Vl+Y8/N2Zr0v6Q87mJ9j1kn
	vu/fkzSzaiTYX53lPGRDxmP7boFWbTs84HDIPFWka1Yt72YrfrHQEqxi3jzjQliv/NCqX1s9Hsbem
	hToLuGsQ==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfSrA-0000000BCOk-2IG7;
	Wed, 28 Feb 2024 22:56:56 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH 07/14] md: add queue limit helpers
Date: Wed, 28 Feb 2024 14:56:46 -0800
Message-Id: <20240228225653.947152-8-hch@lst.de>
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

Add a few helpers that wrap the block queue limits API for use in MD.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/md.h |  3 +++
 2 files changed, 48 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 01a219b2559bdb..bfc38cb4b31014 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5697,6 +5697,51 @@ static const struct kobj_type md_ktype = {
 
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
+	struct queue_limits lim;
+
+	if (mddev_is_dm(mddev))
+		return 0;
+
+	lim = queue_limits_start_update(mddev->queue);
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
+
+	if (mddev_is_dm(mddev))
+		return;
+
+	/* don't bother updating io_opt if we can't suspend the array */
+	if (mddev_suspend(mddev, false) < 0)
+		return;
+	lim = queue_limits_start_update(mddev->gendisk->queue);
+	lim.io_opt = lim.io_min * nr_stripes;
+	queue_limits_commit_update(mddev->gendisk->queue, &lim);
+	mddev_resume(mddev);
+}
+EXPORT_SYMBOL_GPL(mddev_update_io_opt);
+
 static void mddev_delayed_delete(struct work_struct *ws)
 {
 	struct mddev *mddev = container_of(ws, struct mddev, del_work);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index b08e655f8bec41..5db58d076256d3 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -861,6 +861,9 @@ void md_autostart_arrays(int part);
 int md_set_array_info(struct mddev *mddev, struct mdu_array_info_s *info);
 int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info);
 int do_md_run(struct mddev *mddev);
+void mddev_stack_rdev_limits(struct mddev *mddev, struct queue_limits *lim);
+int mddev_stack_new_rdev(struct mddev *mddev, struct md_rdev *rdev);
+void mddev_update_io_opt(struct mddev *mddev, unsigned int nr_stripes);
 
 extern const struct block_device_operations md_fops;
 
-- 
2.39.2

