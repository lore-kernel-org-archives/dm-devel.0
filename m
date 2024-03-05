Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3C97F492
	for <dm-devel@lists.linux.dev>; Tue,  5 Mar 2024 07:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709623776; cv=none; b=qcoLNK1M/ju5IkrXyncDlVkxfA/xmio1DSkmZ5F+M0c4g4wljrEZgatFNhkuak0eseQGXcpX7XaKIIrdtZ74ra26GJyoVYEt7PgVxnOXkEmzoAFHAEGhvBsCosR1+1XSjkw3h1rRUEOUBOx8sLU5WXQLbzFR/mZ1Ahd0U64bq5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709623776; c=relaxed/simple;
	bh=LOAAo12TmpeMqfRlxKgrGSwC8uen4zm5weoQ2qlrzpg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ilp5OP1vyRS/yJZWPLthbQ4p60NUmpjhiJho9l/atJwoC72qxultxsTOOkv0ljRUWx5p/WrhZCddz0IPncCuPDb787f5aen1AfC63Xa51+a6jEZAiTghS1PmHoTnml3AFfYpzgqyZ/rCONZqstu1nAUPAZNeroGA+0Mb+AQJBFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4TpnJ06p4cz4f3jsD
	for <dm-devel@lists.linux.dev>; Tue,  5 Mar 2024 15:29:20 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 596571A016E
	for <dm-devel@lists.linux.dev>; Tue,  5 Mar 2024 15:29:26 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP1 (Coremail) with SMTP id cCh0CgBHGBHRyeZlGnf+Fw--.17927S5;
	Tue, 05 Mar 2024 15:29:26 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: xni@redhat.com,
	zkabelac@redhat.com,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	dm-devel@lists.linux.dev,
	song@kernel.org,
	yukuai3@huawei.com,
	heinzm@redhat.com,
	jbrassow@redhat.com,
	neilb@suse.de
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.8 v2 1/9] md: don't clear MD_RECOVERY_FROZEN for new dm-raid until resume
Date: Tue,  5 Mar 2024 15:22:58 +0800
Message-Id: <20240305072306.2562024-2-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240305072306.2562024-1-yukuai1@huaweicloud.com>
References: <20240305072306.2562024-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBHGBHRyeZlGnf+Fw--.17927S5
X-Coremail-Antispam: 1UD129KBjvJXoW7Zw4ktrW3uryDCrW7CryxAFb_yoW8Gw47pa
	n7Gr1rurWkJrW2kF4DJa4v9a45tasxJrW0yryfu3y5Xr13Xr1kK34YgwnxZryqkF1aga45
	AF1UAryrC3WrKw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBE14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMI
	IF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JU4T5dUUUUU
	=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

After commit 9dbd1aa3a81c ("dm raid: add reshaping support to the
target") raid_ctr() will set MD_RECOVERY_FROZEN before md_run() and
expect to keep array frozen until resume. However, md_run() will clear
the flag by setting mddev->recovery to 0.

Before commit 1baae052cccd ("md: Don't ignore suspended array in
md_check_recovery()"), dm-raid actually relied on suspending to prevent
starting new sync_thread.

Fix this problem by keeping 'MD_RECOVERY_FROZEN' for dm-raid in
md_run().

Fixes: 1baae052cccd ("md: Don't ignore suspended array in md_check_recovery()")
Fixes: 9dbd1aa3a81c ("dm raid: add reshaping support to the target")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Xiao Ni <xni@redhat.com>
Acked-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/md.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9e41a9aaba8b..23f31fd1d024 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6038,7 +6038,10 @@ int md_run(struct mddev *mddev)
 			pr_warn("True protection against single-disk failure might be compromised.\n");
 	}
 
-	mddev->recovery = 0;
+	/* dm-raid expect sync_thread to be frozen until resume */
+	if (mddev->gendisk)
+		mddev->recovery = 0;
+
 	/* may be over-ridden by personality */
 	mddev->resync_max_sectors = mddev->dev_sectors;
 
-- 
2.39.2

