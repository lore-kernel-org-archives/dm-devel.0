Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408B51AF0A4
	for <dm-devel@lists.linux.dev>; Sun, 27 Apr 2025 08:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745743033; cv=none; b=ZEXbFRWpsiXChMpwfRXdLDiY2HPqKyCXbsyoMOMnUXVdhCpyhxRbnjIAvT4SWNQHC0bDymRbnzjk4LRsaG+DpxxhYUrD4RLZ73dObPVK6OaqW+tNTqE+3m7ss8EN7C7QlrtU/pWKqdiWJNFN8Zn5Fm6dgdfXrEwRoR03EyOGtlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745743033; c=relaxed/simple;
	bh=OUHwNKnG3YpW8fdJ7O7QdjsVE5cAIInl4Sq4+BBFX0w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qCYWfTY0CgsvafpYdfAhtQnAiEzLmQHrWi9c0Mse9Kefm2ChZnXcXjkmV61L00aqR3f7h0tbLdyBnq0oHTgXkzmLcQ09yMt53bXKXy4RMbRLsy/g5dXtX68udsGkhz/mWpsZJQq+F03uOrHhfoxhGThAjUTSokHsCLDkWmY37Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4Zlg1J4Rx3zKHMkQ
	for <dm-devel@lists.linux.dev>; Sun, 27 Apr 2025 16:37:08 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id A01B61A018D
	for <dm-devel@lists.linux.dev>; Sun, 27 Apr 2025 16:37:07 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP3 (Coremail) with SMTP id _Ch0CgDHGsWx7A1oOv4xKg--.7274S4;
	Sun, 27 Apr 2025 16:37:07 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: hch@infradead.org,
	axboe@kernel.dk,
	xni@redhat.com,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	yukuai3@huawei.com,
	cl@linux.com,
	nadav.amit@gmail.com,
	ubizjak@gmail.com,
	akpm@linux-foundation.org
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH v2 0/9] md: fix is_mddev_idle()
Date: Sun, 27 Apr 2025 16:29:19 +0800
Message-Id: <20250427082928.131295-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgDHGsWx7A1oOv4xKg--.7274S4
X-Coremail-Antispam: 1UD129KBjvdXoWrurWUJw17Jr1xury5Ww1xKrg_yoWDWwbE9F
	WDZFyaqF4xXF13AFyqkF13ZrWjkrW8X3s8XFy2qrW5Zr93Xr1UKws0kw4Yq398WFW7u3ZY
	yr18ur18Ar48XjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb3kFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
	n2kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1x
	MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
	VFxhVjvjDU0xZFpf9x0pRHUDLUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Changes in v2:
 - add patch 1-5
 - add reviewed-by in patch 6,7,9
 - rename mddev->last_events to mddev->normal_IO_events in patch 8

Yu Kuai (9):
  blk-mq: remove blk_mq_in_flight()
  block: reuse part_in_flight_rw for part_in_flight
  block: WARN if bdev inflight counter is negative
  block: cleanup blk_mq_in_flight_rw()
  block: export API to get the number of bdev inflight IO
  md: record dm-raid gendisk in mddev
  md: add a new api sync_io_depth
  md: fix is_mddev_idle()
  md: cleanup accounting for issued sync IO

 block/blk-core.c          |   2 +-
 block/blk-mq.c            |  22 ++---
 block/blk-mq.h            |   5 +-
 block/blk.h               |   1 -
 block/genhd.c             |  69 ++++++++------
 drivers/md/dm-raid.c      |   3 +
 drivers/md/md.c           | 193 +++++++++++++++++++++++++++-----------
 drivers/md/md.h           |  18 +---
 drivers/md/raid1.c        |   3 -
 drivers/md/raid10.c       |   9 --
 drivers/md/raid5.c        |   8 --
 include/linux/blkdev.h    |   1 -
 include/linux/part_stat.h |   2 +
 13 files changed, 194 insertions(+), 142 deletions(-)

-- 
2.39.2

