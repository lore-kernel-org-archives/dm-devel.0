Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD0829BDB5
	for <dm-devel@lists.linux.dev>; Fri, 29 Aug 2025 08:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756455202; cv=none; b=kAXymEzCTVT5iBX8kQ+b8NgoO4NcROkiynE2lZ1UWlKXHSFHLhyGxtEHY5I87bzyFFEhnmYQwym+t3KWT/3RmHFANW3tcX6Nba8UauF6NKzUUyNjCd3wnG6yjfVRIYpAGtduLhJD55nVnzawGDxP58tBJ/b81sZwnC5M9Q3zVG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756455202; c=relaxed/simple;
	bh=A0V8NrU+/d9oOJrAnfiuCrLAa4Kzy73YPCwn4yCQios=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=upH7rTl69QzRs8myKvDxUCi3rklNLyOd7XfJsB6GksII7nt7M/J0Yd8g/EpfC+pkPK/jxbKrrtQetcLVdC4tNGCFOhalaTSPyca6aFW0govQvwQpAU+pCU/1MIEymQKVOaLOsY6uwQdIZNZoZn1hN3OGRgJ7m63Xq8sm2P5nAUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cCrcQ4Xt3zKHNHR
	for <dm-devel@lists.linux.dev>; Fri, 29 Aug 2025 16:13:10 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 5968A1A1A2A
	for <dm-devel@lists.linux.dev>; Fri, 29 Aug 2025 16:13:10 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgB3wY0RYbFohAO2Ag--.45648S4;
	Fri, 29 Aug 2025 16:13:08 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: hch@infradead.org,
	xni@redhat.com,
	colyli@kernel.org,
	linan122@huawei.com,
	corbet@lwn.net,
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
	johnny.chenyi@huawei.com,
	hailan@yukuai.org.cn
Subject: [PATCH v7 md-6.18 00/11] md/llbitmap: md/md-llbitmap: introduce a new lockless bitmap
Date: Fri, 29 Aug 2025 16:04:15 +0800
Message-Id: <20250829080426.1441678-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3wY0RYbFohAO2Ag--.45648S4
X-Coremail-Antispam: 1UD129KBjvJXoWxKr1rGF45Cr4rXF4fXF1kXwb_yoW7Xr4Upa
	9aqr43CwsxJr4fWa17J342vFyrKan5XrZrKr1fG3yF93yqyrn8Ga1SgF4ru34DGryfWF9F
	qr45ArnrKryj9FJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Y14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
	nIWIevJa73UjIFyTuYvjTRNJ5oDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Changes from v6:
 - fix special case in degraded mode in patch 11, also add description
 about this case;
 - fix some typos in patch 11;
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

Due to known performance issues with md-bitmap and the unreasonable
implementations:

 - self-managed IO submitting like filemap_write_page();
 - global spin_lock

I have decided not to continue optimizing based on the current bitmap
implementation, this new bitmap is invented without locking from IO fast
path and can be used with fast disks.

For designs and details, see patch 11;

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
 drivers/md/md-llbitmap.c         | 1625 ++++++++++++++++++++++++++++++
 drivers/md/md.c                  |  332 ++++--
 drivers/md/md.h                  |   20 +-
 drivers/md/raid5.c               |   34 +-
 9 files changed, 2046 insertions(+), 123 deletions(-)
 create mode 100644 drivers/md/md-llbitmap.c

-- 
2.39.2

