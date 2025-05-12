Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D44D1E520E
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 01:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747013292; cv=none; b=ocTCFx+MGfTuCaTSTAuNyFxpoy+9Alv0/yIH2Uk9GOs/JLGAbZmTXkfPYlmf6aKLUfgAt15C1Zgzz0Cbuwll8acpg9bgMax1PLqNQ65h9YlsKaqmWKomD3d/0LLgOnWHYbH8bUu1k/a+Wxxn1G2ea2YtletdnvtCJ3t4SxWFrkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747013292; c=relaxed/simple;
	bh=p+03Fj+eOCZMY+6F/S00LYfxCvcAdfwOKOf5RiktbXo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=J0rjPSO5rdJQQfAbC60Dskx8N/d/WqB3r4oGsIi+OthejjIKq6YaLTSf4982U44jxtDvcfnmG43qhLdpAeS2AZXxmd0sz4viTOOjmCpDEZmIb94i5bY1JWoDSKQPh2Vzmoc1sMVDeiloebxU+k64r9pVmLFdGP/rYIgOhE3hz00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Zwhms71vMz4f3jXd
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 09:27:41 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A72721A1BAC
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 09:28:06 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCnC2CdTiFoNFCWMA--.55093S12;
	Mon, 12 May 2025 09:28:06 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: hch@lst.de,
	xni@redhat.com,
	colyli@kernel.org,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	yukuai3@huawei.com
Cc: linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH RFC md-6.16 v3 08/19] md/md-bitmap: add a new helper blocks_synced() in bitmap_operations
Date: Mon, 12 May 2025 09:19:16 +0800
Message-Id: <20250512011927.2809400-9-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250512011927.2809400-1-yukuai1@huaweicloud.com>
References: <20250512011927.2809400-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnC2CdTiFoNFCWMA--.55093S12
X-Coremail-Antispam: 1UD129KBjvJXoW7ZrWDWFW8XFy7Wr17WryUJrb_yoW8tF13pa
	yDJasxA3yjgrWjqF1UJayDuFyFq39rJrWxKFyfu34ruF95Kr9rWFWrJayUtF1UKF1avasx
	Z3Z8t3yUCr1FgrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
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
will support lazy initial recovery in following patches. This helper is
used to check if data blocks is synced or not, if not then IO will still
have to read all blocks.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.h | 1 +
 drivers/md/raid5.c     | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 13be2a10801a..4e27f5f793b7 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -99,6 +99,7 @@ struct bitmap_operations {
 	void (*end_discard)(struct mddev *mddev, sector_t offset,
 			    unsigned long sectors);
 
+	bool (*blocks_synced)(struct mddev *mddev, sector_t offset);
 	sector_t (*skip_sync_blocks)(struct mddev *mddev, sector_t offset);
 	bool (*start_sync)(struct mddev *mddev, sector_t offset,
 			   sector_t *blocks, bool degraded);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7e66a99f29af..e5d3d8facb4b 100644
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

