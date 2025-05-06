Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA6D27A47A
	for <dm-devel@lists.linux.dev>; Tue,  6 May 2025 12:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746536115; cv=none; b=a6ytYJqwjdSuW0fv/jCWdIAaBgsmtjESncRE/HR7CQJ4Lq8lGdbWTv8RlVOQySzG45bllEN+K4Vx885kSC1ldYkQxUtOnZKAv29hIrhT5mdFLsYNM6sq8b0qVIk6l9yDCgURhcgVkjQiw7i+tIM9dzwA8CBMHiuECaRojPCVBgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746536115; c=relaxed/simple;
	bh=226HvrpzIggRv7+P11Xi1OD0yG8CL9+835GwM5RSIDM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FpAfgUHoQpAwIMU0WbT2SBrp2FXqxL2uJXdrPHK4dbXR+KOD+9PESVhmK96tVPMoj8C6tON2wZJy3/5/HGpOUE1r2EaO5DuY58JvNtH0OYYxRzsqJdt3b6d+qgWIc/gg/pVKetNkS4hKBzOvRT36h7I/trFpkYGw1BuZArl+jwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4ZsJJw0ktdzKHMgd
	for <dm-devel@lists.linux.dev>; Tue,  6 May 2025 20:55:12 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id DF1DD1A1A18
	for <dm-devel@lists.linux.dev>; Tue,  6 May 2025 20:55:10 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDnSl+sBhpo8C9vLg--.36407S4;
	Tue, 06 May 2025 20:55:10 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: axboe@kernel.dk,
	agk@redhat.com,
	song@kernel.org,
	hch@lst.de,
	john.g.garry@oracle.com,
	hare@suse.de,
	xni@redhat.com,
	pmenzel@molgen.mpg.de
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH v3 0/9] md: fix is_mddev_idle()
Date: Tue,  6 May 2025 20:46:47 +0800
Message-Id: <20250506124658.2537886-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDnSl+sBhpo8C9vLg--.36407S4
X-Coremail-Antispam: 1UD129KBjvdXoWrtr18Ww1xAFyUJFyDKryUWrg_yoWDKwc_uF
	WkZFyaqF4xXF13AF90kF13ZrW0krW8X3s8XFySqrZ5Zr93Xr98K398K39Yq398WFW3u3ZY
	yr18ur48Ar1IqjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb3AFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
	n2kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1x
	MIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCT
	nIWIevJa73UjIFyTuYvjTRNJ5oDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Changes in v3:
 - add review tag for patch 1-5;
 - fix some typo and words;
Changes in v2:
 - add patch 1-5;
 - add reviewed-by in patch 6,7,9;
 - rename mddev->last_events to mddev->normal_IO_events in patch 8;

Yu Kuai (9):
  blk-mq: remove blk_mq_in_flight()
  block: reuse part_in_flight_rw for part_in_flight
  block: WARN if bdev inflight counter is negative
  block: clean up blk_mq_in_flight_rw()
  block: export API to get the number of bdev inflight IO
  md: record dm-raid gendisk in mddev
  md: add a new api sync_io_depth
  md: fix is_mddev_idle()
  md: clean up accounting for issued sync IO

 block/blk-core.c          |   2 +-
 block/blk-mq.c            |  22 ++---
 block/blk-mq.h            |   5 +-
 block/blk.h               |   1 -
 block/genhd.c             |  69 ++++++++------
 drivers/md/dm-raid.c      |   3 +
 drivers/md/md.c           | 190 ++++++++++++++++++++++++++------------
 drivers/md/md.h           |  18 +---
 drivers/md/raid1.c        |   3 -
 drivers/md/raid10.c       |   9 --
 drivers/md/raid5.c        |   8 --
 include/linux/blkdev.h    |   1 -
 include/linux/part_stat.h |   2 +
 13 files changed, 191 insertions(+), 142 deletions(-)

-- 
2.39.2

