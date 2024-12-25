Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277331898F2
	for <dm-devel@lists.linux.dev>; Wed, 25 Dec 2024 11:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735125598; cv=none; b=RmN8SHhVKLxOAbzVjWWEv7RDRNbsQ4GAzQem6hsGdCsgJ+r5pObEV5LfbnWWB3nzuru3oOo5zuQbZI3tG5QDop0clXHLVbZ3m33gvQwMRpmhSE8EhauKXHxhFcCx06Qsi1+JNQUPjjAjpM8WpuLDxGFIEpZMOrZ3pXSSO3i+zik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735125598; c=relaxed/simple;
	bh=cxmSRd7gl4AwyHS3j9ftmzcUjJuNXr6j80+r3mtdChs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=uOXwBGIDIuf/7Zp7TydjhWIfHmKzeWduIpM4SwDM547P9ZZNHiXyYsq5kZo+gCjUjl5n56/M4Ocs38+4bp+ATb+fMSIwkFPpXT8dZpyKN8q1aicOZ0X915pMyrAN7yGEdRIGGqr1G1pxmRVQWJXjkw/T0gRyBgkzjX6/pnDLJYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YJ8RQ3rcxz4f3kvl
	for <dm-devel@lists.linux.dev>; Wed, 25 Dec 2024 19:19:30 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 5797B1A0359
	for <dm-devel@lists.linux.dev>; Wed, 25 Dec 2024 19:19:51 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAnT4NV6mtntXlgFg--.39006S4;
	Wed, 25 Dec 2024 19:19:51 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: xni@redhat.com,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	yukuai3@huawei.com
Cc: dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.14 00/13] md/md-bitmap: support to build md-bitmap as kernel module
Date: Wed, 25 Dec 2024 19:15:33 +0800
Message-Id: <20241225111546.1833250-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAnT4NV6mtntXlgFg--.39006S4
X-Coremail-Antispam: 1UD129KBjvJXoW7Ww1ftF4xXF1UGw1UJF45Awb_yoW8Cw4Upa
	9xtrya9w15JFWavFnxJry8CFyFqwn7Ja9Fkr97Ca1rWFyDZF9xXr48GFW8t34qgryrJ3W7
	Jr15tw1xGr1rXa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Y14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
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

Due to known performance issues with md-bitmap and the unreasonable
implementations like following:

 - self-managed pages, bitmap_storage->filemap;
 - self-managed IO submitting like filemap_write_page();
 - global spin_lock
 ...

I have decided not to continue optimizing based on the current bitmap
implementation, and plan to invent a new lock-less bitmap. And build
the bitmap as kernel module is a good way for isolation. However, we
still encourage anyone who wants to continue optimizing the current
implementation, the new bitmap will take some time to be ready.

Yu Kuai (13):
  md/md-bitmap: remove the parameter 'init' for bitmap_ops->resize()
  md/md-bitmap: merge md_bitmap_group into bitmap_operations
  md/md-bitmap: add md_bitmap_registered/enabled() helper
  md/md-bitmap: handle the case bitmap is not enabled before
    start_sync()
  md/md-bitmap: handle the case bitmap is not enabled before end_sync()
  md/dm-raid: check if bitmap is registered in raid_ctr()
  md/raid1: check bitmap before behind write
  md/raid1: check before deferencing mddev->bitmap_ops
  md/raid10: check before deferencing mddev->bitmap_ops
  md/raid5: check before deferencing mddev->bitmap_ops
  md: check before deferencing mddev->bitmap_ops
  md: export some helpers
  md/md-bitmap: support to build md-bitmap as kernel module

 drivers/md/Kconfig      |  18 ++++
 drivers/md/Makefile     |   4 +-
 drivers/md/dm-raid.c    |   5 +-
 drivers/md/md-bitmap.c  |  72 ++++++++--------
 drivers/md/md-bitmap.h  |  54 +++++++++++-
 drivers/md/md-cluster.c |   2 +-
 drivers/md/md.c         | 183 +++++++++++++++++++++++++++++++---------
 drivers/md/md.h         |  12 ++-
 drivers/md/raid1-10.c   |   2 +-
 drivers/md/raid1.c      |  79 ++++++++++-------
 drivers/md/raid10.c     |  48 +++++------
 drivers/md/raid5.c      |  30 ++++---
 12 files changed, 352 insertions(+), 157 deletions(-)

-- 
2.39.2

