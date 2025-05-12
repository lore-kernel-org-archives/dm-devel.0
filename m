Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84831E2607
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 01:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747013289; cv=none; b=SCzFmVh0gMynpVdeiXwfBCbBOy71kDW+NFYTn/6vlBwG4aH74bWuijdAsMNp6hmM3Kyhb4pPavymUYJj1QKBFY7uolNHvvGi3xZuKLMcdDNIHyIw9g5+/nfYuMj5P++kJJoWIiiCad0GJOaZE9RRycc+tJJT0luk4w+2ujOSluI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747013289; c=relaxed/simple;
	bh=qXmb0BvXKmaAPHPJGw6G5BNdZlVB/QxbhsD9p7+ticA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HFu4dSxY4/70x7KJQp2uZwBP/4K8/zjQF3KW2cX3SGXDZdMlTyTPx7vsQSURxwWFHozX17BnvKCc4GR3f8xrnOXOuKyeEz567HE4TBngsaBZ0+UHmkI/dD7LD2zi1Pq6IeDWM9MnWN90B5x2biV8G+teoq9MFOjar6GLtiqfSWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4ZwhnG59BBzYQv8m
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 09:28:02 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 0A5F71A0359
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 09:28:02 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCnC2CdTiFoNFCWMA--.55093S4;
	Mon, 12 May 2025 09:27:59 +0800 (CST)
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
Subject: [PATCH RFC md-6.16 v3 00/19] md: introduce a new lockless bitmap
Date: Mon, 12 May 2025 09:19:08 +0800
Message-Id: <20250512011927.2809400-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnC2CdTiFoNFCWMA--.55093S4
X-Coremail-Antispam: 1UD129KBjvJXoW3GryUGry3Jr13ur1UCr4rXwb_yoWxtw4kpF
	ZxZrn3Jrs8Jr4Ig3ZrZryxJFySq3ykJrnxJr1rA3sY9rn8Cr9avr48GayFq347Gry7JF1q
	qF45tr9xGw1DuFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Y14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
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
	nIWIevJa73UjIFyTuYvjfUOv38UUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

changes in v3:
 - reimplement bitmap IO;
 - support skipping unwritten blocks for recovery;
 - support lazy initial recover for raid5;
 - many other changes.

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

#### Key Features

 - IO fastpath is lockless, if user issues lots of write IO to the same
 bitmap bit in a short time, only the first write have additional overhead
 to update bitmap bit, no additional overhead for the following writes;
 - support only resync or recover written data, means in the case creating
 new array or replacing with a new disk, there is no need to do a full disk
 resync/recovery;

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

Typical scenarios:

1) Create new array
All bits will be set to Unwritten by default, if --assume-clean is set,
All bits will be set to Clean instead.

2) write data, raid1/raid10 have full copy of data, while raid456 doesn't and
rely on xor data

2.1) write new data to raid1/raid10:
Unwritten --StartWrite--> Dirty

2.2) write new data to raid456:
Unwritten --StartWrite--> NeedSync

Because the initial recover for raid456 is skipped, the xor data is not build
yet, the bit must set to NeedSync first and after lazy initial recover is
finished, the bit will finially set to Dirty(see 4.1 and 4.4);

2.3) cover write
Clean --StartWrite--> Dirty

3) daemon, if the array is not degraded:
Dirty --Daemon--> Clean

For degraded array, the Dirty bit will never be cleared, prevent full disk
recovery while readding a removed disk.

4) discard
{Clean, Dirty, NeedSync, Syncing} --Discard--> Unwritten

5) resync and recover

5.1) common process
NeedSync --Startsync--> Syncing --Endsync--> Dirty --Daemon--> Clean

5.2) resync after power failure
Dirty --Reload--> NeedSync

5.3) recover while replacing with a new disk
By default, the old bitmap framework will recover all data, and llbitmap
implement this by a new helper llbitmap_skip_sync_blocks:

skip recover for bits other than dirty or clean;

5.4) lazy initial recover for raid5:
By default, the old bitmap framework will only allow new recover when there
are spares(new disk), a new recovery flag MD_RECOVERY_LAZY_RECOVER is add
to perform raid456 lazy recover for set bits(from 2.2).

 ##### Bitmap IO

##### Chunksize

The default bitmap size is 128k, incluing 1k bitmap super block, and
the default size of segment of data in the array each bit(chunksize) is 64k,
and chunksize will adjust to twice the old size each time if the total number
bits is not less than 127k.(see llbitmap_init)

##### READ

While creating bitmap, all pages will be allocated and read for llbitmap,
there won't be read afterwards

##### WRITE

WRITE IO is divided into logical_block_size of the array, the dirty state
of each block is tracked independently, for example:

each page is 4k, contain 8 blocks; each block is 512 bytes contain 512 bit;

| page0 | page1 | ... | page 31 |
|       |
|        \-----------------------\
|                                |
| block0 | block1 | ... | block 8|
|        |
|         \-----------------\
|                            |
| bit0 | bit1 | ... | bit511 |

From IO path, if one bit is changed to Dirty or NeedSync, the corresponding
block will be marked dirty, such block must write first before the IO is
issued. This behaviour will affect IO performance, to reduce the impact, if
multiple bits are changed in the same block in a short time, all bits in this
block will be changed to Dirty/NeedSync, so that there won't be any overhead
until daemon clears dirty bits.

##### Dirty Bits syncronization

IO fast path will set bits to dirty, and those dirty bits will be cleared
by daemon after IO is done. llbitmap_barrier is used to synchronize between
IO path and daemon;

IO path:
 1) try to grab a reference, if succeed, set expire time after 5s and return;
 2) if failed to grab a reference, wait for daemon to finish clearing dirty
 bits;

Daemon(Daemon will be waken up every daemon_sleep seconds):
For each page:
 1) check if page expired, if not skip this page; for expired page:
 2) suspend the page and wait for inflight write IO to be done;
 3) change dirty page to clean;
 4) resume the page;

Noted:
1) user must apply the following mdadm patch, and then llbitmap can be
enabled by --bitmap=lockless
https://lore.kernel.org/all/20250509101411.2093911-1-yukuai1@huaweicloud.com/
2) following branch for review or test:
https://git.kernel.org/pub/scm/linux/kernel/git/yukuai/linux.git/log/?h=yukuai/md-6.16

Yu Kuai (19):
  md/md-bitmap: add {start, end}_discard in bitmap_operations
  md: support discard for bitmap ops
  md/md-bitmap: remove parameter slot from bitmap_create()
  md: add a new sysfs api bitmap_version
  md: delay registration of bitmap_ops until creating bitmap
  md: add a new parameter 'offset' to md_super_write()
  md/md-bitmap: add a new helper skip_sync_blocks() in bitmap_operations
  md/md-bitmap: add a new helper blocks_synced() in bitmap_operations
  md: add a new recovery_flag MD_RECOVERY_LAZY_RECOVER
  md/md-llbitmap: add data structure definition and comments
  md/md-llbitmap: implement bitmap IO
  md/md-llbitmap: implement bit state machine
  md/md-llbitmap: implement APIs for page level dirty bits
    synchronization
  md/md-llbitmap: implement APIs to mange bitmap lifetime
  md/md-llbitmap: implement APIs to dirty bits and clear bits
  md/md-llbitmap: implement APIs for sync_thread
  md/md-llbitmap: implement all bitmap operations
  md/md-llbitmap: implement sysfs APIs
  md/md-llbitmap: add Kconfig

 drivers/md/Kconfig       |   12 +
 drivers/md/Makefile      |    1 +
 drivers/md/md-bitmap.c   |    9 +-
 drivers/md/md-bitmap.h   |   25 +-
 drivers/md/md-llbitmap.c | 1465 ++++++++++++++++++++++++++++++++++++++
 drivers/md/md.c          |  221 ++++--
 drivers/md/md.h          |    8 +-
 drivers/md/raid5.c       |    6 +
 8 files changed, 1700 insertions(+), 47 deletions(-)
 create mode 100644 drivers/md/md-llbitmap.c

-- 
2.39.2

