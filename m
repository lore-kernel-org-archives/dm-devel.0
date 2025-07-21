Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5FA1E32D3;
	Mon, 21 Jul 2025 17:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753118194; cv=none; b=KLOX8iRF9J/GcspMePSCRKNDfhH+vo5v3/0tZ0Qnt37Liki/1xhZfczgcHfSNSJZbHalfog7JkyPTI3P+gWuloUy5FsfLbGu2klN71j7VYeKnHW2h0yVtP5Atvv/wewxLbDNErzqpy3s3tzJMYkmrRSDcyVCZXCXE39lE0Rq3Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753118194; c=relaxed/simple;
	bh=1GT4lWwNp8stNHLex+5QlywJON0Cd9VdZN+XvmXNm9A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u5NtPCMlozArXiDUldXYH3caouMJUXEhnjK+2UA2rwezSAH9mqXJXnK+rRTIdCQi9/mNH3XCHtMJuzUF720V7JnES+x2ej4MI5QWC1UKV08LDf7lcJzH8urjtAJe7X/nkeTp0o70wapIrqJUywuodtGTZF7p1PSELe0wYBOXaQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tbkhZT2F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tbkhZT2F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F036CC4CEED;
	Mon, 21 Jul 2025 17:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753118194;
	bh=1GT4lWwNp8stNHLex+5QlywJON0Cd9VdZN+XvmXNm9A=;
	h=From:To:Cc:Subject:Date:From;
	b=tbkhZT2FNanibBwM9Q3Dp4dkbsYM77XTmHz5Db6bUAgTGFruCprlZTixHQqEB746h
	 VUmUAZtLybbkJ99nPPZnq5Jw5ghPMRv7Qi2cW4+PmxxE9d7A+roA3bWT0k89LvXTu0
	 FFhtMSyZoo/CZpDZuC+06PvBVss81jGMRS7R6PH4+j24kV+EGgUM4ghRVhiVV3fN7H
	 IbGMbc1h0cD3HNWZUQrqtzWeZfanR83THL+ic1lUXDo2muIELIvkA/bOwynY0KcFWb
	 b3GVEIQ+CLC9In2S5cnhpVMeUT1KxvGUqfus4gkaxDc+abCMV5/a2ZJOiHQDqjUs8d
	 8eqyxlEriqTXA==
From: Yu Kuai <yukuai@kernel.org>
To: corbet@lwn.net,
	agk@redhat.co,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	hch@lst.de,
	song@kernel.org,
	hare@suse.de
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH v4 00/11] md/llbitmap: md/md-llbitmap: introduce a new lockless bitmap
Date: Tue, 22 Jul 2025 01:15:46 +0800
Message-ID: <20250721171557.34587-1-yukuai@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai3@huawei.com>

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

v3: https://lore.kernel.org/linux-raid/20250718092336.3346644-1-yukuai1@huaweicloud.com/
v2: https://lore.kernel.org/all/20250707165202.11073-12-yukuai@kernel.org/
v1: https://lore.kernel.org/all/20250524061320.370630-1-yukuai1@huaweicloud.com/
RFC: https://lore.kernel.org/all/20250512011927.2809400-1-yukuai1@huaweicloud.com/

Branch for review:
https://git.kernel.org/pub/scm/linux/kernel/git/yukuai/linux.git/log/?h=yukuai/md-llbitmap-v4

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
 drivers/md/md-llbitmap.c         | 1598 ++++++++++++++++++++++++++++++
 drivers/md/md.c                  |  288 ++++--
 drivers/md/md.h                  |   20 +-
 drivers/md/raid5.c               |    6 +
 9 files changed, 1963 insertions(+), 107 deletions(-)
 create mode 100644 drivers/md/md-llbitmap.c

-- 
2.43.0

