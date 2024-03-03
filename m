Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992665A4FD;
	Sun,  3 Mar 2024 14:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709474533; cv=none; b=eozCnIgOi2HlO73br5VNxuxvYxmgiBOUhOzn74UsqiK1Fmle3SW4GqRUctrzxIbbfjqAzjvGNWYoUu7VOK8UfQxuMU32A6IMek9YJZWH41Gz3MiXmqrSxbbOunj0Zz5z7xxT9r1UM2h4HF3xUSESijm4ygeaRzYeioJWaSGWW8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709474533; c=relaxed/simple;
	bh=iNTtym882ygluTq4ryeqOEHvFlL9+HUBeumRbVpb5QY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aKdJB6kwtJkhVmMoXjKoGC1XpXdO9B5OEkC/OffIJv8dp56uYgc1VOv6zqTcJ/doiTajSFDA3YMSgbi06/DbMTvNLoW3C/lxOa05qxXTXYEv/gVwsQX0GAy59BTqlnUVLgSq20O0HP4Qo/B5gzS3UAofcLi3LBser14MDse2Vzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=g3VmozA3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="g3VmozA3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=1qAXyHcvDJOSQjP0wb23hu4/G3KFhlCZvPwkDtR2WH0=; b=g3VmozA3d83VKAfFLNgmu9Cs04
	h24A5CNN7pnyYzIRYXGt+v9v9M/jFWdA+wT4M40Ma8DGeRADaM6EY3ix+A1Ap1dy8y/hFy+N1q5d9
	E6gMrH8SUNt+zcLC+FojXVj2WKcMnbMoPfu01ymambV3M8P8nUC+VgYTuwbnP8DJwQxwmWy5W6+RG
	gxVUTqCMOsh0N1PaydG9INB2PdRi0ySS5SgoykypOc1K+Cob7a6XXtCtN/bgPMS16rSidGqbqUHN8
	XKLGE7Zxrdevi9eGHaB21JWTwrms7o+uhnJc3EdbjuXaF7LZff6qPlmvTRgLSMo+hQ478Bw4mdbJJ
	uWT/mrgw==;
Received: from [206.0.71.27] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rgmPq-000000061lb-0JEt;
	Sun, 03 Mar 2024 14:02:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH 04/11] md: add queue limit helpers
Date: Sun,  3 Mar 2024 07:01:43 -0700
Message-Id: <20240303140150.5435-5-hch@lst.de>
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

Add a few helpers that wrap the block queue limits API for use in MD.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed--by: Song Liu <song@kernel.org>
Tested-by: Song Liu <song@kernel.org>
---
 drivers/md/md.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/md.h |  3 +++
 2 files changed, 48 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9ce4b5f2324dab..9a7f3d2b8c2d16 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5731,6 +5731,51 @@ static const struct kobj_type md_ktype = {
 
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
index 786b0eebd1cad6..003db35b4b5926 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -872,6 +872,9 @@ void md_autostart_arrays(int part);
 int md_set_array_info(struct mddev *mddev, struct mdu_array_info_s *info);
 int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info);
 int do_md_run(struct mddev *mddev);
+void mddev_stack_rdev_limits(struct mddev *mddev, struct queue_limits *lim);
+int mddev_stack_new_rdev(struct mddev *mddev, struct md_rdev *rdev);
+void mddev_update_io_opt(struct mddev *mddev, unsigned int nr_stripes);
 
 extern const struct block_device_operations md_fops;
 
-- 
2.39.2

