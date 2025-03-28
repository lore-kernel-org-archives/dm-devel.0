Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF33218C907
	for <dm-devel@lists.linux.dev>; Fri, 28 Mar 2025 06:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743142492; cv=none; b=fE20xJNz97Lt/QTvwcTVxv4ezsGcO/1sSqGNRCuWQsGiEJFjVH0IJ58/ZxaHTFlXp4/RGAOdYEG9XJIrf5qLyqhdKG/KNmuSEI+2Yp+MwLsHrAyQ/jMf5DFS3KShag9PmuMmucuXCz14D+hnY4LKrtDd3a2beoKXfTHJ7rnKhvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743142492; c=relaxed/simple;
	bh=v5tjRA3ZVyMyUsgojjyteteRUZX2Erx+Fr5ybQyUuh0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FkHCv+ystZ+JrcUtnuRIhVmjygXCL1zJuBhdZe5VlJ7AncLtV4JD1lAUdrSV2VqitJ/psGo0EBMl/ITx8651ATX/fg5jR74RuSPHVsFrUQBEzsQL2GonaqvxTwHvxj4rvoQGsr66hGucHzn7AcgMvGtn1sQ8kjs0YEQ9nLxwxqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4ZP9GR1SLxz4f3jY1
	for <dm-devel@lists.linux.dev>; Fri, 28 Mar 2025 14:14:23 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 331FF1A07F4
	for <dm-devel@lists.linux.dev>; Fri, 28 Mar 2025 14:14:46 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDHK2BSPuZnfAUtHw--.25875S4;
	Fri, 28 Mar 2025 14:14:44 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: hch@lst.de,
	xni@redhat.com,
	colyli@kernel.org,
	axboe@kernel.dk,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	yukuai3@huawei.com
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC v2 00/14] md: introduce a new lockless bitmap
Date: Fri, 28 Mar 2025 14:08:39 +0800
Message-Id: <20250328060853.4124527-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHK2BSPuZnfAUtHw--.25875S4
X-Coremail-Antispam: 1UD129KBjvJXoWxGr1kZry3XFW5GryUtrW5Jrb_yoWrGF1UpF
	ZxJr4fGrs0qr47Xw13AryIqFySqr4kJr9Igr93A39Y9F1DCr9Ivr48WayFv347Gry3JF1q
	qr45tr95GFyDCrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Y14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
	nIWIevJa73UjIFyTuYvjfUOv38UUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

#### Background

Redundant data is used to enhance data fault tolerance, and the storage
method for redundant data vary depending on the RAID levels. And it's
important to maintain the consistency of redundant data.

Bitmap is used to record which data blocks have been synchronized and which
ones need to be resynchronized or recovered. Each bit in the bitmap
represents a segment of data in the array. When a bit is set, it indicates
that the multiple redundant copies of that data segment may not be
consistent. Data synchronization can be performed based on the bitmap after
power failure or readding a disk. If there is no bitmap, a full disk
synchronization is required.

#### Key Concept

##### State Machine

Each bit is one byte, contain 6 difference state, see llbitmap_state. And
there are total 8 differenct actions, see llbitmap_action, can change state:

llbitmap state machine: transitions between states

|           | Startwrite | Startsync | Endsync | Abortsync| Reload   | Daemon | Discard   | Stale     |
| --------- | ---------- | --------- | ------- | -------  | -------- | ------ | --------- | --------- |
| Unwritten | Dirty      | x         | x       | x        | x        | x      | x         | x         |
| Clean     | Dirty      | x         | x       | x        | x        | x      | Unwritten | NeedSync  |
| Dirty     | x          | x         | x       | x        | NeedSync | Clean  | Unwritten | NeedSync  |
| NeedSync  | x          | Syncing   | x       | x        | x        | x      | Unwritten | x         |
| Syncing   | x          | Syncing   | Dirty   | NeedSync | NeedSync | x      | Unwritten | NeedSync  |

special illustration:
- Unwritten is special state, which means user never write data, hence there
  is no need to resync/recover data. This is safe if user create filesystems
  for the array, filesystem will make sure user will get zero data for
  unwritten blocks.
- After resync is done, change state from Syncing to Dirty first, in case
  Startwrite happen before the state is Clean.

##### Bitmap IO

A hidden disk, named mdxxx_bitmap, is created for bitmap, see details in
llbitmap_add_disk(). And a file is created as well to manage bitmap IO for
this disk, see details in llbitmap_open_disk(). Read/write bitmap is
converted to buffer IO to this file.

IO fast path will set bits to dirty, and those dirty bits will be cleared
by daemon after IO is done. llbitmap_barrier is used to syncronize between
IO path and daemon;

Test result: to be added

Noted:
1) user must apply the following mdadm patch, and then llbitmap can be
enabled by --bitmap=lockless
https://lore.kernel.org/all/20250327134853.1069356-1-yukuai1@huaweicloud.com/
2) this set is cooked on the top of my other set:
https://lore.kernel.org/all/20250219083456.941760-1-yukuai1@huaweicloud.com/

Yu Kuai (14):
  block: factor out a helper bdev_file_alloc()
  md/md-bitmap: pass discard information to bitmap_{start, end}write
  md/md-bitmap: remove parameter slot from bitmap_create()
  md: add a new sysfs api bitmap_version
  md: delay registeration of bitmap_ops until creating bitmap
  md/md-llbitmap: implement bit state machine
  md/md-llbitmap: implement hidden disk to manage bitmap IO
  md/md-llbitmap: implement APIs for page level dirty bits
    synchronization
  md/md-llbitmap: implement APIs to mange bitmap lifetime
  md/md-llbitmap: implement APIs to dirty bits and clear bits
  md/md-llbitmap: implement APIs for sync_thread
  md/md-llbitmap: implement all bitmap operations
  md/md-llbitmap: implement sysfs APIs
  md/md-llbitmap: add Kconfig

 block/bdev.c             |   21 +-
 drivers/md/Kconfig       |   12 +
 drivers/md/Makefile      |    1 +
 drivers/md/md-bitmap.c   |   10 +-
 drivers/md/md-bitmap.h   |   21 +-
 drivers/md/md-llbitmap.c | 1410 ++++++++++++++++++++++++++++++++++++++
 drivers/md/md.c          |  180 ++++-
 drivers/md/md.h          |    3 +
 include/linux/blkdev.h   |    1 +
 9 files changed, 1614 insertions(+), 45 deletions(-)
 create mode 100644 drivers/md/md-llbitmap.c

-- 
2.39.2

