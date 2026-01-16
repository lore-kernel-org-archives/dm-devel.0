Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F88376BCC
	for <dm-devel@lists.linux.dev>; Fri, 16 Jan 2026 12:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768565493; cv=none; b=hq6s2e1lFQwEa0uU36rSfL0EbpbuO7zxX2iRxLydTn6sJfwNNtS8pvw1AcO0D3jpGeknTi9hlx0/J+ak60GtlK74hA0rFf0mCniDy/WtFloLH3c2QlPH/GRIRjMnvQP7HIWwjSF3NmS4fHCz68YWHB8h9P9Hi0Yr1/nTcTf/mb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768565493; c=relaxed/simple;
	bh=/Yd34El++CCt08toxVD8Oe+2GJdlGtPi5iTl12UsvJg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Arsbd1av8X0+rnuafU4i+fOTyDJR9mX+oO4eDWLl4qgGC8PiGV2bu2CcT/IQuTfump5sCiNI6ZnR6DtcMCeFPMBRs5mF43ff0t6GDO/72XrpVWcV9Q+mlvOM9fWXEZOpfS5RWpO9YnT+8QallK+8hoQJnkpvH4szkDwcJK+vwOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=D8HfNTRW; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="D8HfNTRW"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=nYmaYPLH2er8UG6enM6EeoVcPjWY0mCAQvIGP55CyfE=;
	b=D8HfNTRWRHbiGPmsG/tQ7VXp1tMWTofz8Dn/cJfF1qpGhS1wa8yV0OOln/hjjAMcJO3RehEqi
	tL24dhTdZDzKFOWIKYnsLi04YNMThwIvKE91VVQxSa1JU5/7BhGT+1tP/UY+RHkdcgQ9pdAkPpO
	tVjco/AUuApKBmy1L1yuDBs=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4dszBZ3dXJzpStc;
	Fri, 16 Jan 2026 20:07:50 +0800 (CST)
Received: from kwepemk500005.china.huawei.com (unknown [7.202.194.90])
	by mail.maildlp.com (Postfix) with ESMTPS id BD11D405AA;
	Fri, 16 Jan 2026 20:11:27 +0800 (CST)
Received: from huawei.com (10.50.85.155) by kwepemk500005.china.huawei.com
 (7.202.194.90) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 16 Jan
 2026 20:11:27 +0800
From: Zhihao Cheng <chengzhihao1@huawei.com>
To: <agk@redhat.com>, <snitzer@kernel.org>, <mpatocka@redhat.com>,
	<bmarzins@redhat.com>
CC: <dm-devel@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<chengzhihao1@huawei.com>, <yangerkun@huawei.com>, <lilingfeng3@huawei.com>
Subject: [PATCH] dm: pass origin bio's bdev to bio_alloc_clone
Date: Fri, 16 Jan 2026 20:07:44 +0800
Message-ID: <20260116120744.908987-1-chengzhihao1@huawei.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemk500005.china.huawei.com (7.202.194.90)

The origin bio carries blk-cgroup information which could be set from
foreground(task_css(css) - wbc->wb->blkcg_css), so the blkcg won't
control buffer io since commit ca522482e3eaf ("dm: pass NULL bdev to
bio_alloc_clone"). The synchronous io is still under control by blkcg,
because 'bio->bi_blkg' is set by io submitting task which has been
added into 'cgroup.procs'.

Fix it by passing origin bio's bdev to bio_alloc_clone.

Fetch a reproducer in [Link].

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220985
Fixes: ca522482e3eaf ("dm: pass NULL bdev to bio_alloc_clone")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
---
 drivers/md/dm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index b63279202260..e763e3b02a9f 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -574,7 +574,8 @@ static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio, gfp_t g
 	struct dm_target_io *tio;
 	struct bio *clone;
 
-	clone = bio_alloc_clone(NULL, bio, gfp_mask, &md->mempools->io_bs);
+	clone = bio_alloc_clone(bio->bi_bdev, bio,
+				gfp_mask, &md->mempools->io_bs);
 	if (unlikely(!clone))
 		return NULL;
 	tio = clone_to_tio(clone);
@@ -623,7 +624,7 @@ static struct bio *alloc_tio(struct clone_info *ci, struct dm_target *ti,
 		/* alloc_io() already initialized embedded clone */
 		clone = &tio->clone;
 	} else {
-		clone = bio_alloc_clone(NULL, ci->bio, gfp_mask,
+		clone = bio_alloc_clone(ci->bio->bi_bdev, ci->bio, gfp_mask,
 					&md->mempools->bs);
 		if (!clone)
 			return NULL;
-- 
2.52.0

