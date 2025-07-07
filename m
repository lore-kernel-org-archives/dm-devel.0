Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8401B87C0
	for <dm-devel@lists.linux.dev>; Mon,  7 Jul 2025 01:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751851963; cv=none; b=ouwy3Is0eV8FclnhLNz008MXxVYOkIdcnhbKp1yzithYM23tLE3s+DABsa7KcK0NdHTo2JueWHDHxzAOU916z84zQik2hR5hH+cZz8OYwHuvRSmegacKwdAHuXRd2AwFzHjnI3IqVDpvlZ6YqOVrhU9VRMOMxIZBvZBemXFVGFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751851963; c=relaxed/simple;
	bh=HYK1oedwmLdwVlRLBg19mNSaqT3tblBIZs990YTzH9k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=E6UbDKhOUQYkpJBW6ATeArnhXdbRJ6NDzhaOUKzZolO71j+HRRhiSeZbjiUMGlMeetWTwSEO4I2mSrhhxyRiuO9UXrPjLG7EJsFxgUCf+ugzfQne0iy9ci9b3p0OQN7rqe+dRJln8u2BFsffaxNOJp9C1sLIS4VStdncQhZygSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4bb6Dk6hjNzYQts0
	for <dm-devel@lists.linux.dev>; Mon,  7 Jul 2025 09:32:38 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id C02A31A018C
	for <dm-devel@lists.linux.dev>; Mon,  7 Jul 2025 09:32:37 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP3 (Coremail) with SMTP id _Ch0CgDnSCazI2to_nSRAw--.35890S4;
	Mon, 07 Jul 2025 09:32:37 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	yukuai3@huawei.com
Cc: dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH v5 00/15] md/md-bitmap: introduce CONFIG_MD_BITMAP
Date: Mon,  7 Jul 2025 09:26:56 +0800
Message-Id: <20250707012711.376844-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgDnSCazI2to_nSRAw--.35890S4
X-Coremail-Antispam: 1UD129KBjvJXoW7ur1UXFWDKr4rtFyDGFyUJrb_yoW8Kw13pa
	9xt343uw13JFW2qFnxJFW8CF1rXwn7tF9Fkr92kw4rWFyUZF98Xr48KFy0yrykWryfXa43
	Jr15tr4xGr1rXa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Y14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
	nIWIevJa73UjIFyTuYvjfUonmRUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Changes in v5:
 - rebase on the top of md-6.17;
 - fix compile problem if md-mod is build as module;
 - fix two problems for lvm2 dm-raid tests, patch 5,13
 - other cleanups;
Changes in v4:
 - rebase on the top of other patchset;
Changes in v3:
 - update commit message.
Changes in v2:
 - don't export apis, and don't support build md-bitmap as module

Due to known performance issues with md-bitmap and the unreasonable
implementations like following:

 - self-managed pages, bitmap_storage->filemap;
 - self-managed IO submitting like filemap_write_page();
 - global spin_lock
 ...

I have decided not to continue optimizing based on the current bitmap
implementation, and plan to invent a new lock-less bitmap. And a new
kconfig option is a good way for isolation.

However, we still encourage anyone who wants to continue optimizing the
current implementation

Yu Kuai (15):
  md/raid1: change r1conf->r1bio_pool to a pointer type
  md/raid1: remove struct pool_info and related code
  md/md-bitmap: remove the parameter 'init' for bitmap_ops->resize()
  md/md-bitmap: merge md_bitmap_group into bitmap_operations
  md/md-bitmap: add a new parameter 'flush' to bitmap_ops->enabled
  md/md-bitmap: add md_bitmap_registered/enabled() helper
  md/md-bitmap: handle the case bitmap is not enabled before
    start_sync()
  md/md-bitmap: handle the case bitmap is not enabled before end_sync()
  md/raid1: check bitmap before behind write
  md/raid1: check before referencing mddev->bitmap_ops
  md/raid10: check before referencing mddev->bitmap_ops
  md/raid5: check before referencing mddev->bitmap_ops
  md/dm-raid: check before referencing mddev->bitmap_ops
  md: check before referencing mddev->bitmap_ops
  md/md-bitmap: introduce CONFIG_MD_BITMAP

 drivers/md/Kconfig      |  18 +++++
 drivers/md/Makefile     |   3 +-
 drivers/md/dm-raid.c    |  18 +++--
 drivers/md/md-bitmap.c  |  74 +++++++++---------
 drivers/md/md-bitmap.h  |  62 ++++++++++++++-
 drivers/md/md-cluster.c |   2 +-
 drivers/md/md.c         | 112 +++++++++++++++++++--------
 drivers/md/md.h         |   4 +-
 drivers/md/raid1-10.c   |   2 +-
 drivers/md/raid1.c      | 163 +++++++++++++++++++---------------------
 drivers/md/raid1.h      |  22 +-----
 drivers/md/raid10.c     |  49 ++++++------
 drivers/md/raid5.c      |  30 ++++----
 13 files changed, 330 insertions(+), 229 deletions(-)

-- 
2.39.2

