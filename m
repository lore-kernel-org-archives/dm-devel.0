Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D857A30CD97;
	Thu, 28 Aug 2025 04:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756354525; cv=none; b=GWbHxxdqWxoqhgBsNMrw2LcPKR8DRB0OBT81BK8vAFKGBaKkPe14jEoz0/nJBf1g8n3DRj8WpFK8Fr19eTY2M7nZ18xsIPRmoxmhC+nniZUygyhmQ7PfBPZ7eHDbYUaMq4x/BYOgNp0nhiZMLnphU06Vqq53YSa38fTx2zXqRJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756354525; c=relaxed/simple;
	bh=TqOYXP7QxO4rwzY43NvfWQwCMshSYfBRLrTTmJkYbDI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ae5fjGfAP2HPsBvuPc0lGBqPKWrBWnuJdlCdPxk7V4Ei9zggGegTuhPDKcIZbTPwnu2D1Kse0H/kdkqSZxKd+a67J4xIttlKXe+8R1FCJ2rqYqMzHe4lrP2pVTkNhrLfKfZaopirRQNuupCrJF0MgBG+ubqG+WP53/DlfZyWVRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2M4sYV+f; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2M4sYV+f"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=l+8+WzKXdrJ+MpZtIuHoQQfYspPWLZFFVhI/RZ4JAAw=; b=2M4sYV+fsYM+YggbUwloEdN2lo
	j3CB/wr+tLY5JH3GHiuCtBGRupKNG6MDetwcJ1zs9vAdYYQGK8DY5QZr3zalMsRnYdPuH/giRwDQd
	6vzknfZqAPxxfCZys6lG1IvW3T4BXVHGXGlSqYluKzqI1v4QrYKF1ujo5ZRW73n5jzXadYKieaHd+
	wO5yJUgmlZrPy2PDSCyl/Mwr+ko6TCFDOLrZEevZ8Xe7Oddsq0nfP5U9ohnMu2So51JVRTOGs0mtv
	DxMWa8K9208A/hWdNpeOn47i5olvB2iDTtFTJz+l6BpxmfcsKTC2T5ABEMyIoBwms0cRXaYu6PbiJ
	APOiQUDA==;
Received: from [50.53.25.54] (helo=[192.168.254.17])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1urU2W-00000000DaL-2AP4;
	Thu, 28 Aug 2025 04:15:08 +0000
Message-ID: <79a2c3ff-e490-4fb5-b0fc-0bdadfae1b81@infradead.org>
Date: Wed, 27 Aug 2025 21:15:07 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 md-6.18 11/11] md/md-llbitmap: introduce new lockless
 bitmap
To: Yu Kuai <yukuai1@huaweicloud.com>, hch@infradead.org, corbet@lwn.net,
 agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
 xni@redhat.com, hare@suse.de, linan122@huawei.com, colyli@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, yukuai3@huawei.com,
 yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com
References: <20250826085205.1061353-1-yukuai1@huaweicloud.com>
 <20250826085205.1061353-12-yukuai1@huaweicloud.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20250826085205.1061353-12-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/26/25 1:52 AM, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Redundant data is used to enhance data fault tolerance, and the storage
> method for redundant data vary depending on the RAID levels. And it's
> important to maintain the consistency of redundant data.
> 
> Bitmap is used to record which data blocks have been synchronized and which
> ones need to be resynchronized or recovered. Each bit in the bitmap
> represents a segment of data in the array. When a bit is set, it indicates
> that the multiple redundant copies of that data segment may not be
> consistent. Data synchronization can be performed based on the bitmap after
> power failure or readding a disk. If there is no bitmap, a full disk

                   reading

> synchronization is required.
> 
> Key Features:
> 
>  - IO fastpath is lockless, if user issues lots of write IO to the same

                    lockless. If the user

>  bitmap bit in a short time, only the first write have additional overhead

                                                    has

>  to update bitmap bit, no additional overhead for the following writes;
>  - support only resync or recover written data, means in the case creating
>  new array or replacing with a new disk, there is no need to do a full disk
>  resync/recovery;
> 
> Key Concept:
> 
>  - State Machine:
> 
> Each bit is one byte, contain 6 difference state, see llbitmap_state. And

                        contains 6 different states,


> there are total 8 differenct actions, see llbitmap_action, can change state:

                    different                                that can change state:

> 
> llbitmap state machine: transitions between states
> 
> |           | Startwrite | Startsync | Endsync | Abortsync|
> | --------- | ---------- | --------- | ------- | -------  |
> | Unwritten | Dirty      | x         | x       | x        |
> | Clean     | Dirty      | x         | x       | x        |
> | Dirty     | x          | x         | x       | x        |
> | NeedSync  | x          | Syncing   | x       | x        |
> | Syncing   | x          | Syncing   | Dirty   | NeedSync |
> 
> |           | Reload   | Daemon | Discard   | Stale     |
> | --------- | -------- | ------ | --------- | --------- |
> | Unwritten | x        | x      | x         | x         |
> | Clean     | x        | x      | Unwritten | NeedSync  |
> | Dirty     | NeedSync | Clean  | Unwritten | NeedSync  |
> | NeedSync  | x        | x      | Unwritten | x         |
> | Syncing   | NeedSync | x      | Unwritten | NeedSync  |
> 
> Typical scenarios:
> 
> 1) Create new array
> All bits will be set to Unwritten by default, if --assume-clean is set,

                                       default. If

> all bits will be set to Clean instead.
> 
> 2) write data, raid1/raid10 have full copy of data, while raid456 doesn't and
> rely on xor data
> 
> 2.1) write new data to raid1/raid10:
> Unwritten --StartWrite--> Dirty
> 
> 2.2) write new data to raid456:
> Unwritten --StartWrite--> NeedSync
> 
> Because the initial recover for raid456 is skipped, the xor data is not build
> yet, the bit must set to NeedSync first and after lazy initial recover is
> finished, the bit will finially set to Dirty(see 5.1 and 5.4);

                         finally

> 
> 2.3) cover write
> Clean --StartWrite--> Dirty
> 
> 3) daemon, if the array is not degraded:
> Dirty --Daemon--> Clean
> 
> For degraded array, the Dirty bit will never be cleared, prevent full disk

                                                           preventing

> recovery while readding a removed disk.

                 reading

> 
> 4) discard
> {Clean, Dirty, NeedSync, Syncing} --Discard--> Unwritten
> 
> 5) resync and recover
> 
> 5.1) common process
> NeedSync --Startsync--> Syncing --Endsync--> Dirty --Daemon--> Clean
> 
> 5.2) resync after power failure
> Dirty --Reload--> NeedSync
> 
> 5.3) recover while replacing with a new disk
> By default, the old bitmap framework will recover all data, and llbitmap
> implement this by a new helper, see llbitmap_skip_sync_blocks:

  implements

> 
> skip recover for bits other than dirty or clean;
> 
> 5.4) lazy initial recover for raid5:
> By default, the old bitmap framework will only allow new recover when there
> are spares(new disk), a new recovery flag MD_RECOVERY_LAZY_RECOVER is add

                                                                        added

> to perform raid456 lazy recover for set bits(from 2.2).
> 
> Bitmap IO:
> 
>  - Chunksize
> 
> The default bitmap size is 128k, incluing 1k bitmap super block, and

                                   including

> the default size of segment of data in the array each bit(chunksize) is 64k,
> and chunksize will adjust to twice the old size each time if the total number
> bits is not less than 127k.(see llbitmap_init)
> 
>  - READ
> 
> While creating bitmap, all pages will be allocated and read for llbitmap,

                                                                  llbitmap.

> there won't be read afterwards

  There          a read afterwards.

> 
>  - WRITE
> 
> WRITE IO is divided into logical_block_size of the array, the dirty state
> of each block is tracked independently, for example:
> 
> each page is 4k, contain 8 blocks; each block is 512 bytes contain 512 bit;

                                                       bytes and contains 512 bits:

> 
> | page0 | page1 | ... | page 31 |
> |       |
> |        \-----------------------\
> |                                |
> | block0 | block1 | ... | block 8|
> |        |
> |         \-----------------\
> |                            |
> | bit0 | bit1 | ... | bit511 |
> 
> From IO path, if one bit is changed to Dirty or NeedSync, the corresponding
> subpage will be marked dirty, such block must write first before the IO is

                         dirty;

> issued. This behaviour will affect IO performance, to reduce the impact, if

                                        performance. To

> multiple bits are changed in the same block in a short time, all bits in this
> block will be changed to Dirty/NeedSync, so that there won't be any overhead
> until daemon clears dirty bits.
> 
> Dirty Bits syncronization:
> 
> IO fast path will set bits to dirty, and those dirty bits will be cleared
> by daemon after IO is done. llbitmap_page_ctl is used to synchronize between
> IO path and daemon;
> 
> IO path:
>  1) try to grab a reference, if succeed, set expire time after 5s and return;
>  2) if failed to grab a reference, wait for daemon to finish clearing dirty
>  bits;
> 
> Daemon(Daemon will be waken up every daemon_sleep seconds):

                will be woken up
or
                will be awakened

> For each page:
>  1) check if page expired, if not skip this page; for expired page:

                    expired; if not, skip this page. For expired page:

>  2) suspend the page and wait for inflight write IO to be done;
>  3) change dirty page to clean;
>  4) resume the page;
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  Documentation/admin-guide/md.rst |   20 +
>  drivers/md/Kconfig               |   11 +
>  drivers/md/Makefile              |    1 +
>  drivers/md/md-bitmap.c           |    9 -
>  drivers/md/md-bitmap.h           |   31 +-
>  drivers/md/md-llbitmap.c         | 1600 ++++++++++++++++++++++++++++++
>  drivers/md/md.c                  |    6 +
>  drivers/md/md.h                  |    4 +-
>  8 files changed, 1670 insertions(+), 12 deletions(-)
>  create mode 100644 drivers/md/md-llbitmap.c
> 
> diff --git a/Documentation/admin-guide/md.rst b/Documentation/admin-guide/md.rst
> index 001363f81850..47d1347ccd00 100644
> --- a/Documentation/admin-guide/md.rst
> +++ b/Documentation/admin-guide/md.rst
> @@ -387,6 +387,8 @@ All md devices contain:
>           No bitmap
>       bitmap
>           The default internal bitmap
> +     llbitmap
> +         The lockless internal bitmap
>  
>  If bitmap_type is not none, then additional bitmap attributes bitmap/xxx or
>  llbitmap/xxx will be created after md device KOBJ_CHANGE event.
> @@ -447,6 +449,24 @@ If bitmap_type is bitmap, then the md device will also contain:
>       once the array becomes non-degraded, and this fact has been
>       recorded in the metadata.
>  
> +If bitmap_type is llbitmap, then the md device will also contain:
> +
> +  llbitmap/bits
> +     This is readonly, show status of bitmap bits, the number of each

                read-only; it shows the status of bitmap bits,

> +     value.
> +
> +  llbitmap/metadata
> +     This is readonly, show bitmap metadata, include chunksize, chunkshift,

                read-only; it shows bitmap metadata, including

> +     chunks, offset and daemon_sleep.
> +
> +  llbitmap/daemon_sleep
> +     This is readwrite, time in seconds that daemon function will be

                read-write, time in seconds

> +     triggered to clear dirty bits.
> +
> +  llbitmap/barrier_idle
> +     This is readwrite, time in seconds that page barrier will be idled,

                read-write,> +     means dirty bits in the page will be cleared.
> +
>  As component devices are added to an md array, they appear in the ``md``
>  directory as new directories named::
>  

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> new file mode 100644
> index 000000000000..88207f31c728
> --- /dev/null
> +++ b/drivers/md/md-llbitmap.c
> @@ -0,0 +1,1600 @@

> +/*
> + * #### Background
> + *
> + * Redundant data is used to enhance data fault tolerance, and the storage
> + * method for redundant data vary depending on the RAID levels. And it's

      methods

> + * important to maintain the consistency of redundant data.
> + *
> + * Bitmap is used to record which data blocks have been synchronized and which
> + * ones need to be resynchronized or recovered. Each bit in the bitmap
> + * represents a segment of data in the array. When a bit is set, it indicates
> + * that the multiple redundant copies of that data segment may not be
> + * consistent. Data synchronization can be performed based on the bitmap after
> + * power failure or readding a disk. If there is no bitmap, a full disk

                       reading

> + * synchronization is required.
> + *
> + * #### Key Features
> + *
> + *  - IO fastpath is lockless, if user issues lots of write IO to the same

                        lockless. If the user

> + *  bitmap bit in a short time, only the first write have additional overhead

                                                        has

> + *  to update bitmap bit, no additional overhead for the following writes;

                        bit; there is no additional overhead for the following writes;

> + *  - support only resync or recover written data, means in the case creating
> + *  new array or replacing with a new disk, there is no need to do a full disk
> + *  resync/recovery;
> + *
> + * #### Key Concept
> + *
> + * ##### State Machine
> + *
> + * Each bit is one byte, contain 6 difference state, see llbitmap_state. And

                      byte, containing           states,

> + * there are total 8 differenct actions, see llbitmap_action, can change state:

                        different                              , that can change state.

> + *
> + * llbitmap state machine: transitions between states

                                                  states::

Use "::" to maintain the table spacing.

> + *
> + * |           | Startwrite | Startsync | Endsync | Abortsync|
> + * | --------- | ---------- | --------- | ------- | -------  |
> + * | Unwritten | Dirty      | x         | x       | x        |
> + * | Clean     | Dirty      | x         | x       | x        |
> + * | Dirty     | x          | x         | x       | x        |
> + * | NeedSync  | x          | Syncing   | x       | x        |
> + * | Syncing   | x          | Syncing   | Dirty   | NeedSync |
> + *
> + * |           | Reload   | Daemon | Discard   | Stale     |
> + * | --------- | -------- | ------ | --------- | --------- |
> + * | Unwritten | x        | x      | x         | x         |
> + * | Clean     | x        | x      | Unwritten | NeedSync  |
> + * | Dirty     | NeedSync | Clean  | Unwritten | NeedSync  |
> + * | NeedSync  | x        | x      | Unwritten | x         |
> + * | Syncing   | NeedSync | x      | Unwritten | NeedSync  |
> + *
> + * Typical scenarios:
> + *
> + * 1) Create new array
> + * All bits will be set to Unwritten by default, if --assume-clean is set,

                                           default. If

> + * all bits will be set to Clean instead.
> + *
> + * 2) write data, raid1/raid10 have full copy of data, while raid456 doesn't and
> + * rely on xor data
> + *
> + * 2.1) write new data to raid1/raid10:
> + * Unwritten --StartWrite--> Dirty
> + *
> + * 2.2) write new data to raid456:
> + * Unwritten --StartWrite--> NeedSync
> + *
> + * Because the initial recover for raid456 is skipped, the xor data is not build

                                                                              built

> + * yet, the bit must set to NeedSync first and after lazy initial recover is

                   must be set to

> + * finished, the bit will finially set to Dirty(see 5.1 and 5.4);

                             finally be set to

> + *
> + * 2.3) cover write
> + * Clean --StartWrite--> Dirty
> + *
> + * 3) daemon, if the array is not degraded:
> + * Dirty --Daemon--> Clean
> + *
> + * For degraded array, the Dirty bit will never be cleared, prevent full disk

                                                               preventing

> + * recovery while readding a removed disk.

                     reading

> + *
> + * 4) discard
> + * {Clean, Dirty, NeedSync, Syncing} --Discard--> Unwritten
> + *
> + * 5) resync and recover
> + *
> + * 5.1) common process
> + * NeedSync --Startsync--> Syncing --Endsync--> Dirty --Daemon--> Clean
> + *
> + * 5.2) resync after power failure
> + * Dirty --Reload--> NeedSync
> + *
> + * 5.3) recover while replacing with a new disk
> + * By default, the old bitmap framework will recover all data, and llbitmap
> + * implement this by a new helper, see llbitmap_skip_sync_blocks:

      implements

> + *
> + * skip recover for bits other than dirty or clean;
> + *
> + * 5.4) lazy initial recover for raid5:
> + * By default, the old bitmap framework will only allow new recover when there
> + * are spares(new disk), a new recovery flag MD_RECOVERY_LAZY_RECOVER is add

                     disk). A new                                           added

> + * to perform raid456 lazy recover for set bits(from 2.2).
> + *
> + * ##### Bitmap IO
> + *
> + * ##### Chunksize
> + *
> + * The default bitmap size is 128k, incluing 1k bitmap super block, and
> + * the default size of segment of data in the array each bit(chunksize) is 64k,
> + * and chunksize will adjust to twice the old size each time if the total number
> + * bits is not less than 127k.(see llbitmap_init)
> + *
> + * ##### READ
> + *
> + * While creating bitmap, all pages will be allocated and read for llbitmap,
> + * there won't be read afterwards
> + *
> + * ##### WRITE
> + *
> + * WRITE IO is divided into logical_block_size of the array, the dirty state
> + * of each block is tracked independently, for example:
> + *
> + * each page is 4k, contain 8 blocks; each block is 512 bytes contain 512 bit;

                                                                 and contains 512 bits;

> + *
> + * | page0 | page1 | ... | page 31 |
> + * |       |
> + * |        \-----------------------\
> + * |                                |
> + * | block0 | block1 | ... | block 8|
> + * |        |
> + * |         \-----------------\
> + * |                            |
> + * | bit0 | bit1 | ... | bit511 |
> + *
> + * From IO path, if one bit is changed to Dirty or NeedSync, the corresponding
> + * subpage will be marked dirty, such block must write first before the IO is
> + * issued. This behaviour will affect IO performance, to reduce the impact, if
> + * multiple bits are changed in the same block in a short time, all bits in this
> + * block will be changed to Dirty/NeedSync, so that there won't be any overhead
> + * until daemon clears dirty bits.
> + *
> + * ##### Dirty Bits syncronization

                       synchronization

[snip]

> +
> +static struct md_sysfs_entry llbitmap_bits =
> +__ATTR_RO(bits);

One line, or if you feel that it must be 2 lines, the second line
should be indented.

> +
> +static struct md_sysfs_entry llbitmap_metadata =
> +__ATTR_RO(metadata);

One line, or if you feel that it must be 2 lines, the second line
should be indented.

> +
> +static struct md_sysfs_entry llbitmap_daemon_sleep =
> +__ATTR_RW(daemon_sleep);
> +

One line, or if you feel that it must be 2 lines, the second line
should be indented.

> +
> +static struct md_sysfs_entry llbitmap_barrier_idle =
> +__ATTR_RW(barrier_idle);
> +

One line, or if you feel that it must be 2 lines, the second line
should be indented.


-- 
~Randy

