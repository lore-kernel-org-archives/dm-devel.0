Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383EC221F04
	for <dm-devel@lists.linux.dev>; Fri, 18 Jul 2025 09:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752830994; cv=none; b=kjG69Oc+lMYdzrqX8ygt2ASAUpITtnPPR3T6SugGqX9hTEDN189t13qaqxHNmmBP6v3diiBUPu1jQ0FQm9rNcgTLAlk3IZHk1d1JMiRjuQASiTpxZu91wQ4NcIwtJ4TZI7ObgqOI2mf5jl6i0qvEFZXWHl0onrnPYWro9yu7p/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752830994; c=relaxed/simple;
	bh=g4kDhLD/4pJTURNV77Bgm4Zv/r4c8a0bS3yvlC2ToMU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UVSQeR3994HP8HPmSXj+4V52R5O0bV1tAoPXIAM8TjLNxMU0DlIW8Ow6KdbzVxKVViaXF7NrwRYXgpMGFmOMHH/ZvvWP2NR5jQXkJYbW/Hah09vV6NrrNsvBLuMWiH88EHfN74jSuBm+NtqBpel1AKTbUNPOarPb+ftE0jPpeJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bk4JJ4P1WzKHN1T
	for <dm-devel@lists.linux.dev>; Fri, 18 Jul 2025 17:29:52 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 3F1DD1A220E
	for <dm-devel@lists.linux.dev>; Fri, 18 Jul 2025 17:29:51 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDXUxQGFHpoDl6qAg--.5172S12;
	Fri, 18 Jul 2025 17:29:51 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: corbet@lwn.net,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	yukuai3@huawei.com,
	hare@suse.de
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH v3 08/11] md/md-bitmap: add a new method blocks_synced() in bitmap_operations
Date: Fri, 18 Jul 2025 17:23:33 +0800
Message-Id: <20250718092336.3346644-9-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250718092336.3346644-1-yukuai1@huaweicloud.com>
References: <20250718092336.3346644-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDXUxQGFHpoDl6qAg--.5172S12
X-Coremail-Antispam: 1UD129KBjvJXoW7ZrWDWFW8XFy7WF4UWF1rZwb_yoW8KF47pa
	9xXasxu3yjgr4YqF15JayDuFyFq3s7JrWxtFyfu3yruF95Kr9rWFWrKayUtF1UKF1aqasx
	Z3Z8trWUCr1FqrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUQFxUUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Currently, raid456 must perform a whole array initial recovery to build
initail xor data, then IO to the array won't have to read all the blocks
in underlying disks.

This behavior will affect IO performance a lot, and nowadays there are
huge disks and the initial recovery can take a long time. Hence llbitmap
will support lazy initial recovery in following patches. This method is
used to check if data blocks is synced or not, if not then IO will still
have to read all blocks for raid456.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/md-bitmap.h | 1 +
 drivers/md/raid5.c     | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 95453696c68e..5f41724cbcd8 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -90,6 +90,7 @@ struct bitmap_operations {
 	md_bitmap_fn *end_discard;
 
 	sector_t (*skip_sync_blocks)(struct mddev *mddev, sector_t offset);
+	bool (*blocks_synced)(struct mddev *mddev, sector_t offset);
 	bool (*start_sync)(struct mddev *mddev, sector_t offset,
 			   sector_t *blocks, bool degraded);
 	void (*end_sync)(struct mddev *mddev, sector_t offset, sector_t *blocks);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 5b19b6c02b26..5b270d4ee99c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3748,6 +3748,7 @@ static int want_replace(struct stripe_head *sh, int disk_idx)
 static int need_this_block(struct stripe_head *sh, struct stripe_head_state *s,
 			   int disk_idx, int disks)
 {
+	struct mddev *mddev = sh->raid_conf->mddev;
 	struct r5dev *dev = &sh->dev[disk_idx];
 	struct r5dev *fdev[2] = { &sh->dev[s->failed_num[0]],
 				  &sh->dev[s->failed_num[1]] };
@@ -3762,6 +3763,11 @@ static int need_this_block(struct stripe_head *sh, struct stripe_head_state *s,
 		 */
 		return 0;
 
+	/* The initial recover is not done, must read everything */
+	if (mddev->bitmap_ops && mddev->bitmap_ops->blocks_synced &&
+	    !mddev->bitmap_ops->blocks_synced(mddev, sh->sector))
+		return 1;
+
 	if (dev->toread ||
 	    (dev->towrite && !test_bit(R5_OVERWRITE, &dev->flags)))
 		/* We need this block to directly satisfy a request */
-- 
2.39.2

