Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8BC329ACDB
	for <dm-devel@lists.linux.dev>; Tue, 26 Aug 2025 09:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756198842; cv=none; b=ucqRm3HijTn3jhYVtRbX73cX9slwVIwlR5DNT/GsDUEqRyXtqDmye3sGM2Jh33da7sG5P9S6Mzrb+VU4fgEP1ahB0mwKwZieqBbOb8o2lErPzfEC3PWSrMHMyRz+R2E13WnxMY5ltnPk/gscJrxYBwveFhPx++w9qlByf9mK6qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756198842; c=relaxed/simple;
	bh=iEtMYraNyUTqmVoiGS3pQ4q8xsOoMRiUHX5YX6evacM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=afi3ZUQh8bBtpgfNbR+fZ4uDxZo4XEu2tu0hYe82DxNoJLfuaoZU/jjcbRu7QtYwWeM+Ju0Wx+xdN2837NOTGqb7ZokOhG1rdPGydZC28I5NDIrsPLb/RNR71FFSoZIgw9+iKHnUHj7YZBi/i5CABdsVw702vVK4AegLKm6fXv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cB1pZ5DVtzYQv0K
	for <dm-devel@lists.linux.dev>; Tue, 26 Aug 2025 17:00:38 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 42C811A0A5B
	for <dm-devel@lists.linux.dev>; Tue, 26 Aug 2025 17:00:37 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAncIyyd61oPOlgAQ--.7793S4;
	Tue, 26 Aug 2025 17:00:35 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: hch@infradead.org,
	corbet@lwn.net,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	xni@redhat.com,
	hare@suse.de,
	linan122@huawei.com,
	colyli@kernel.org
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH v6 md-6.18 00/11] md/llbitmap: md/md-llbitmap: introduce a new lockless bitmap
Date: Tue, 26 Aug 2025 16:51:54 +0800
Message-Id: <20250826085205.1061353-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAncIyyd61oPOlgAQ--.7793S4
X-Coremail-Antispam: 1UD129KBjvJXoWxKr1rGF45Cr4rXF43tF45Awb_yoWfCF43p3
	yavrn3Grs8Jr4IgwsrA342qFyrtw4kJr9rtr1rJ34F9wn0krn0va1xWay8Z34DGry3WF1j
	qFs8Xr97Gr1DuFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9F14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcS
	sGvfC2KfnxnUUI43ZEXa7sRRKZX5UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Changes from v5:
 - fix wrong place to check is blocks are synced in patch 8; (Xiao)
 - raid5 is using recover to build initial xor data, fix that unexpected
 resync is triggered, patch 9 and patch 11; (Myself by test)
 - flush bitmap after it's initialized the first time, patch 11; (Xiao)
 - some coding style, patch 11; (Xiao)
Changes from v4:
 - fix dm-raid regerssion in patch 6, skip creating bitmap attributes
 under mddev gendisk which is NULL;
 - some minor cleanups and error handling fixes in patch 11;
 - add review tag:
  - patch 1-10 from Li Nan
  - patch 4,5,6,8 from Xiao
  - patch 6 from Hannes
Changes from v3:
 - fix redundant setting mddev->bitmap_id in patch 6;
 - add explanation of bitmap attributes in Documentation;
 - add llbitmap/barrier_idle in patch 11;
 - add some comments in patch 11;
Changes from v2:
 - add comments about KOBJECT_CHANGE uevent in patch 6;
 - convert llbitmap_suspend() to llbitmap_suspend_timeout() in patch 11;
 - add some comments in patch 11;
 - add review tag:
  - patch 3,4,5,9 from Hannes
Changes from v1:
 - explain md_bitmap_fn in commit message, patch 3;
 - handle the case CONFIG_MD_BITMAP is disabled, patch 4;
 - split patch 7 from v1 into patch 5 + 6;
 - rewrite bitmap_type_store, patch 5;
 - fix dm-raid regerssion that md-bitmap sysfs entries should not be
 created under mddev kobject, patch 6
 - merge llbitmap patches into one patch, with lots of cleanups;
 - add review tag:
  - patch 1,2,7,8,9,10 from Christoph
  - patch 1,2,7,8,10 from Hannes
  - patch 1,2,3,7 from Xiao

v4: https://lore.kernel.org/all/20250721171557.34587-1-yukuai@kernel.org/
v3: https://lore.kernel.org/linux-raid/20250718092336.3346644-1-yukuai1@huaweicloud.com/
v2: https://lore.kernel.org/all/20250707165202.11073-12-yukuai@kernel.org/
v1: https://lore.kernel.org/all/20250524061320.370630-1-yukuai1@huaweicloud.com/
RFC: https://lore.kernel.org/all/20250512011927.2809400-1-yukuai1@huaweicloud.com/

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

|           | Startwrite | Startsync | Endsync | Abortsync|
| --------- | ---------- | --------- | ------- | -------  |
| Unwritten | Dirty      | x         | x       | x        |
| Clean     | Dirty      | x         | x       | x        |
| Dirty     | x          | x         | x       | x        |
| NeedSync  | x          | Syncing   | x       | x        |
| Syncing   | x          | Syncing   | Dirty   | NeedSync |

|           | Reload   | Daemon | Discard   | Stale     |
| --------- | -------- | ------ | --------- | --------- |
| Unwritten | x        | x      | x         | x         |
| Clean     | x        | x      | Unwritten | NeedSync  |
| Dirty     | NeedSync | Clean  | Unwritten | NeedSync  |
| NeedSync  | x        | x      | Unwritten | x         |
| Syncing   | NeedSync | x      | Unwritten | NeedSync  |

Typical scenarios:

1) Create new array
All bits will be set to Unwritten by default, if --assume-clean is set,
all bits will be set to Clean instead.

2) write data, raid1/raid10 have full copy of data, while raid456 doesn't and
rely on xor data

2.1) write new data to raid1/raid10:
Unwritten --StartWrite--> Dirty

2.2) write new data to raid456:
Unwritten --StartWrite--> NeedSync

Because the initial recover for raid456 is skipped, the xor data is not build
yet, the bit must set to NeedSync first and after lazy initial recover is
finished, the bit will finially set to Dirty(see 5.1 and 5.4);

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
implement this by a new helper, see llbitmap_skip_sync_blocks:

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

>From IO path, if one bit is changed to Dirty or NeedSync, the corresponding
subpage will be marked dirty, such block must write first before the IO is
issued. This behaviour will affect IO performance, to reduce the impact, if
multiple bits are changed in the same block in a short time, all bits in this
block will be changed to Dirty/NeedSync, so that there won't be any overhead
until daemon clears dirty bits.

##### Dirty Bits syncronization

IO fast path will set bits to dirty, and those dirty bits will be cleared
by daemon after IO is done. llbitmap_page_ctl is used to synchronize between
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

Performance Test:
Simple fio randwrite test to build array with 20GB ramdisk in my VM:

|                      | none      | bitmap    | llbitmap  |
| -------------------- | --------- | --------- | --------- |
| raid1                | 13.7MiB/s | 9696KiB/s | 19.5MiB/s |
| raid1(assume clean)  | 19.5MiB/s | 11.9MiB/s | 19.5MiB/s |
| raid10               | 21.9MiB/s | 11.6MiB/s | 27.8MiB/s |
| raid10(assume clean) | 27.8MiB/s | 15.4MiB/s | 27.8MiB/s |
| raid5                | 14.0MiB/s | 11.6MiB/s | 12.9MiB/s |
| raid5(assume clean)  | 17.8MiB/s | 13.4MiB/s | 13.9MiB/s |

For raid1/raid10 llbitmap can be better than none bitmap with background
initial resync, and it's the same as none bitmap without it.

Noted that llbitmap performance improvement for raid5 is not obvious,
this is due to raid5 has many other performance bottleneck, perf
results still shows that bitmap overhead will be much less.

Yu Kuai (11):
  md: add a new parameter 'offset' to md_super_write()
  md: factor out a helper raid_is_456()
  md/md-bitmap: support discard for bitmap ops
  md: add a new mddev field 'bitmap_id'
  md/md-bitmap: add a new sysfs api bitmap_type
  md/md-bitmap: delay registration of bitmap_ops until creating bitmap
  md/md-bitmap: add a new method skip_sync_blocks() in bitmap_operations
  md/md-bitmap: add a new method blocks_synced() in bitmap_operations
  md: add a new recovery_flag MD_RECOVERY_LAZY_RECOVER
  md/md-bitmap: make method bitmap_ops->daemon_work optional
  md/md-llbitmap: introduce new lockless bitmap

 Documentation/admin-guide/md.rst |   86 +-
 drivers/md/Kconfig               |   11 +
 drivers/md/Makefile              |    1 +
 drivers/md/md-bitmap.c           |   15 +-
 drivers/md/md-bitmap.h           |   45 +-
 drivers/md/md-llbitmap.c         | 1600 ++++++++++++++++++++++++++++++
 drivers/md/md.c                  |  332 +++++--
 drivers/md/md.h                  |   20 +-
 drivers/md/raid5.c               |   34 +-
 9 files changed, 2021 insertions(+), 123 deletions(-)
 create mode 100644 drivers/md/md-llbitmap.c

-- 
2.39.2

