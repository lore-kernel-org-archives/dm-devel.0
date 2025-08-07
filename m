Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36DE21DE8A4
	for <dm-devel@lists.linux.dev>; Thu,  7 Aug 2025 03:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754539067; cv=none; b=mAgJqdwyGD9xMX7LhzvJjdwn8z9Yu4phx2mBKOTCCQQnZ8w88RFwfOixACT+lGvq9NU1dTzF+7xQNayKODGo8j5YTwbR/Gmx3DDp58XvFwzxeW1d0oFbEB2IYY9smEduRgzy7G/uYj+n74UvmzrIZML6YH32ogR6TD+nTnSWRtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754539067; c=relaxed/simple;
	bh=qiJrsie/KEzpONL0hZ6eAUvPXEaoZrE+Lh6a93VgLVE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ote2FUzsIWDo+idWCkUs0wgZ8f6h57tUyrVyLfjzR/bBpZA7O2BLvj8HMLgIVJT7CYT4acz+Qt+Bka24LuZU3m0TGwlLAknO09cTX+HylL5S2hNMiBZSj4xXdactvJA7FAGQvlz3+PVuX6JGhGmoNNjFaiEN65mqZsfCfL5Depk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F5E26wgW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F5E26wgW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754539062;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZyIn++jCVk0twGU+U+1DFZFRQf3QuYHgQTngbhm+x+g=;
	b=F5E26wgWooE/57BKni4jzw4krs9jUs61O/Lhr5KLlIHMPGY2ujmbCw8faJGNZaE1Tx4A/5
	Rh6xismJaXjJ0vJaCVm299RQKAcQ3ecOhc/IVU6HssutoMsyFH03Ru+UHEnZipBEEenb+h
	6M2x3+RuewkPvOrY1lWmbjeFhxn2jyo=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-568-YsjX6LifMdWhJoEjhVF5BQ-1; Wed, 06 Aug 2025 23:57:40 -0400
X-MC-Unique: YsjX6LifMdWhJoEjhVF5BQ-1
X-Mimecast-MFC-AGG-ID: YsjX6LifMdWhJoEjhVF5BQ_1754539059
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-55b9f899bd5so284412e87.1
        for <dm-devel@lists.linux.dev>; Wed, 06 Aug 2025 20:57:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754539059; x=1755143859;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZyIn++jCVk0twGU+U+1DFZFRQf3QuYHgQTngbhm+x+g=;
        b=dLnZ+0JGV931GU2xpLxWD9uGv7h0yKmps+9jGrGWomwjjcca/55jKndsV/EXVx/93u
         2pxMnMmUoDUn3z9K27IKKawun2red14gctg09V4xua2Ef5snL42LevuAOygALpyx50Zb
         n7XEdsxTNn0UuDuHS979Ua84ZxQlem4wQnDarxJh4rw4D8D9LjMQT2vTfWhPFZD7FXQM
         KPP/fCp3kYtEal5uazI4CW43iWbLA0ET8sRQP/mweUn4RBlsIFG5BKjrxhDzUvhjt6ep
         NiiDMdN31c+t6q0K/pkV4J2bPF7Tk90XtXGr1c56VDVZOlUb7Ee5F3h39+QxAwNKHzG+
         w41w==
X-Forwarded-Encrypted: i=1; AJvYcCU2RWywzS5J3jpGON8fuWpsH052Jqu/2/yorxQIT3gTFDr6HWMiYNPimUn7DiHpp137F51UYO1trg==@lists.linux.dev
X-Gm-Message-State: AOJu0YymsVQB8SHKHSB2dPpmNO/zEWOHJWsnZXx/GnEvj7K4PGaf/jNz
	E1GI0MK3nGYW/mPPVEd5+67psJsJVdDBb0GEhk9/oEmrbj4B48taKhfWZ2fnzlSrPCR/LEiugxg
	hQQfZOSA3r99UGjgOhWsUiz6kyJ5vyyXTJwXQ0cqlu21YU9hGWTI996DrpN9FTv1GafmpwAl05J
	YGq417Rfl7t1diU/pjMRx7zsjtc19UusNnJqo=
X-Gm-Gg: ASbGncsQBHWgMV3RMlR0INtVxR7Q/AjFcLE3LZ1WihMhqINoYWB2Qtnp1XCTw+WMYa/
	TpmaGRpAs79aWvpm6EknC+L5r9RCTquLvvvt1G2XIZqnSaYBRDgs2n02lUDZWmXgMl99ER2YOBG
	44mE90RtL5B/TXbkfvUYs31A==
X-Received: by 2002:a05:6512:b95:b0:550:e608:410b with SMTP id 2adb3069b0e04-55cb688e461mr340667e87.33.1754539058053;
        Wed, 06 Aug 2025 20:57:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGfjn8wIe/940C6LFBgLqVEPeVdoXebwmooD8/8m3WNF3J7rlRKMVYR7f008qrz+G52T3VxhmqudOoifZfG/GE=
X-Received: by 2002:a05:6512:b95:b0:550:e608:410b with SMTP id
 2adb3069b0e04-55cb688e461mr340653e87.33.1754539057315; Wed, 06 Aug 2025
 20:57:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250801070346.4127558-1-yukuai1@huaweicloud.com> <20250801070346.4127558-12-yukuai1@huaweicloud.com>
In-Reply-To: <20250801070346.4127558-12-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Thu, 7 Aug 2025 11:57:24 +0800
X-Gm-Features: Ac12FXwkh7gBBwwWxhUSrBrKDtlRnT4M9uD61huWMGJNtyXR8HJP9Ao_Crrq7V8
Message-ID: <CALTww2-FTgDn9pD-Gmh8YKT-fU1ykk_QbB9J2KO8xQzrkAa_Bg@mail.gmail.com>
Subject: Re: [PATCH v5 11/11] md/md-llbitmap: introduce new lockless bitmap
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, corbet@lwn.net, song@kernel.org, yukuai3@huawei.com, 
	agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, linan122@huawei.com, 
	hare@suse.de, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, dm-devel@lists.linux.dev, yi.zhang@huawei.com, 
	yangerkun@huawei.com, johnny.chenyi@huawei.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sQnlT7un-CCZBJt8a-RHETKbi1gbfYUyG413yHtXZDs_1754539059
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kuai

On Fri, Aug 1, 2025 at 3:11=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> wr=
ote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> Redundant data is used to enhance data fault tolerance, and the storage
> method for redundant data vary depending on the RAID levels. And it's
> important to maintain the consistency of redundant data.
>
> Bitmap is used to record which data blocks have been synchronized and whi=
ch
> ones need to be resynchronized or recovered. Each bit in the bitmap
> represents a segment of data in the array. When a bit is set, it indicate=
s
> that the multiple redundant copies of that data segment may not be
> consistent. Data synchronization can be performed based on the bitmap aft=
er
> power failure or readding a disk. If there is no bitmap, a full disk
> synchronization is required.
>
> Key Features:
>
>  - IO fastpath is lockless, if user issues lots of write IO to the same
>  bitmap bit in a short time, only the first write have additional overhea=
d
>  to update bitmap bit, no additional overhead for the following writes;
>  - support only resync or recover written data, means in the case creatin=
g
>  new array or replacing with a new disk, there is no need to do a full di=
sk
>  resync/recovery;
>
> Key Concept:
>
>  - State Machine:
>
> Each bit is one byte, contain 6 difference state, see llbitmap_state. And
> there are total 8 differenct actions, see llbitmap_action, can change sta=
te:
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
> all bits will be set to Clean instead.
>
> 2) write data, raid1/raid10 have full copy of data, while raid456 doesn't=
 and
> rely on xor data
>
> 2.1) write new data to raid1/raid10:
> Unwritten --StartWrite--> Dirty
>
> 2.2) write new data to raid456:
> Unwritten --StartWrite--> NeedSync
>
> Because the initial recover for raid456 is skipped, the xor data is not b=
uild
> yet, the bit must set to NeedSync first and after lazy initial recover is
> finished, the bit will finially set to Dirty(see 5.1 and 5.4);
>
> 2.3) cover write
> Clean --StartWrite--> Dirty
>
> 3) daemon, if the array is not degraded:
> Dirty --Daemon--> Clean
>
> For degraded array, the Dirty bit will never be cleared, prevent full dis=
k
> recovery while readding a removed disk.
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
>
> skip recover for bits other than dirty or clean;
>
> 5.4) lazy initial recover for raid5:
> By default, the old bitmap framework will only allow new recover when the=
re
> are spares(new disk), a new recovery flag MD_RECOVERY_LAZY_RECOVER is add
> to perform raid456 lazy recover for set bits(from 2.2).
>
> Bitmap IO:
>
>  - Chunksize
>
> The default bitmap size is 128k, incluing 1k bitmap super block, and
> the default size of segment of data in the array each bit(chunksize) is 6=
4k,
> and chunksize will adjust to twice the old size each time if the total nu=
mber
> bits is not less than 127k.(see llbitmap_init)
>
>  - READ
>
> While creating bitmap, all pages will be allocated and read for llbitmap,
> there won't be read afterwards
>
>  - WRITE
>
> WRITE IO is divided into logical_block_size of the array, the dirty state
> of each block is tracked independently, for example:
>
> each page is 4k, contain 8 blocks; each block is 512 bytes contain 512 bi=
t;
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
> From IO path, if one bit is changed to Dirty or NeedSync, the correspondi=
ng
> subpage will be marked dirty, such block must write first before the IO i=
s
> issued. This behaviour will affect IO performance, to reduce the impact, =
if
> multiple bits are changed in the same block in a short time, all bits in =
this
> block will be changed to Dirty/NeedSync, so that there won't be any overh=
ead
> until daemon clears dirty bits.
>
> Dirty Bits syncronization:
>
> IO fast path will set bits to dirty, and those dirty bits will be cleared
> by daemon after IO is done. llbitmap_page_ctl is used to synchronize betw=
een
> IO path and daemon;
>
> IO path:
>  1) try to grab a reference, if succeed, set expire time after 5s and ret=
urn;
>  2) if failed to grab a reference, wait for daemon to finish clearing dir=
ty
>  bits;
>
> Daemon(Daemon will be waken up every daemon_sleep seconds):
> For each page:
>  1) check if page expired, if not skip this page; for expired page:
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
>  drivers/md/md-llbitmap.c         | 1596 ++++++++++++++++++++++++++++++
>  drivers/md/md.c                  |    6 +
>  drivers/md/md.h                  |    4 +-
>  8 files changed, 1666 insertions(+), 12 deletions(-)
>  create mode 100644 drivers/md/md-llbitmap.c
>
> diff --git a/Documentation/admin-guide/md.rst b/Documentation/admin-guide=
/md.rst
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
>  If bitmap_type is not none, then additional bitmap attributes bitmap/xxx=
 or
>  llbitmap/xxx will be created after md device KOBJ_CHANGE event.
> @@ -447,6 +449,24 @@ If bitmap_type is bitmap, then the md device will al=
so contain:
>       once the array becomes non-degraded, and this fact has been
>       recorded in the metadata.
>
> +If bitmap_type is llbitmap, then the md device will also contain:
> +
> +  llbitmap/bits
> +     This is readonly, show status of bitmap bits, the number of each
> +     value.
> +
> +  llbitmap/metadata
> +     This is readonly, show bitmap metadata, include chunksize, chunkshi=
ft,
> +     chunks, offset and daemon_sleep.
> +
> +  llbitmap/daemon_sleep
> +     This is readwrite, time in seconds that daemon function will be
> +     triggered to clear dirty bits.
> +
> +  llbitmap/barrier_idle
> +     This is readwrite, time in seconds that page barrier will be idled,
> +     means dirty bits in the page will be cleared.
> +
>  As component devices are added to an md array, they appear in the ``md``
>  directory as new directories named::
>
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index f913579e731c..07c19b2182ca 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -52,6 +52,17 @@ config MD_BITMAP
>
>           If unsure, say Y.
>
> +config MD_LLBITMAP
> +       bool "MD RAID lockless bitmap support"
> +       depends on BLK_DEV_MD
> +       help
> +         If you say Y here, support for the lockless write intent bitmap=
 will
> +         be enabled.
> +
> +         Note, this is an experimental feature.
> +
> +         If unsure, say N.
> +
>  config MD_AUTODETECT
>         bool "Autodetect RAID arrays during kernel boot"
>         depends on BLK_DEV_MD=3Dy
> diff --git a/drivers/md/Makefile b/drivers/md/Makefile
> index 2e18147a9c40..5a51b3408b70 100644
> --- a/drivers/md/Makefile
> +++ b/drivers/md/Makefile
> @@ -29,6 +29,7 @@ dm-zoned-y    +=3D dm-zoned-target.o dm-zoned-metadata.=
o dm-zoned-reclaim.o
>
>  md-mod-y       +=3D md.o
>  md-mod-$(CONFIG_MD_BITMAP)     +=3D md-bitmap.o
> +md-mod-$(CONFIG_MD_LLBITMAP)   +=3D md-llbitmap.o
>  raid456-y      +=3D raid5.o raid5-cache.o raid5-ppl.o
>  linear-y       +=3D md-linear.o
>
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index dc050ff94d5b..84b7e2af6dba 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -34,15 +34,6 @@
>  #include "md-bitmap.h"
>  #include "md-cluster.h"
>
> -#define BITMAP_MAJOR_LO 3
> -/* version 4 insists the bitmap is in little-endian order
> - * with version 3, it is host-endian which is non-portable
> - * Version 5 is currently set only for clustered devices
> - */
> -#define BITMAP_MAJOR_HI 4
> -#define BITMAP_MAJOR_CLUSTERED 5
> -#define        BITMAP_MAJOR_HOSTENDIAN 3
> -
>  /*
>   * in-memory bitmap:
>   *
> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
> index 5f41724cbcd8..b42a28fa83a0 100644
> --- a/drivers/md/md-bitmap.h
> +++ b/drivers/md/md-bitmap.h
> @@ -9,10 +9,26 @@
>
>  #define BITMAP_MAGIC 0x6d746962
>
> +/*
> + * version 3 is host-endian order, this is deprecated and not used for n=
ew
> + * array
> + */
> +#define BITMAP_MAJOR_LO                3
> +#define BITMAP_MAJOR_HOSTENDIAN        3
> +/* version 4 is little-endian order, the default value */
> +#define BITMAP_MAJOR_HI                4
> +/* version 5 is only used for cluster */
> +#define BITMAP_MAJOR_CLUSTERED 5
> +/* version 6 is only used for lockless bitmap */
> +#define BITMAP_MAJOR_LOCKLESS  6
> +
>  /* use these for bitmap->flags and bitmap->sb->state bit-fields */
>  enum bitmap_state {
> -       BITMAP_STALE       =3D 1,  /* the bitmap file is out of date or h=
ad -EIO */
> +       BITMAP_STALE       =3D 1, /* the bitmap file is out of date or ha=
d -EIO */
>         BITMAP_WRITE_ERROR =3D 2, /* A write error has occurred */
> +       BITMAP_FIRST_USE   =3D 3, /* llbitmap is just created */
> +       BITMAP_CLEAN       =3D 4, /* llbitmap is created with assume_clea=
n */
> +       BITMAP_DAEMON_BUSY =3D 5, /* llbitmap daemon is not finished afte=
r daemon_sleep */
>         BITMAP_HOSTENDIAN  =3D15,
>  };
>
> @@ -166,4 +182,17 @@ static inline void md_bitmap_exit(void)
>  }
>  #endif
>
> +#ifdef CONFIG_MD_LLBITMAP
> +int md_llbitmap_init(void);
> +void md_llbitmap_exit(void);
> +#else
> +static inline int md_llbitmap_init(void)
> +{
> +       return 0;
> +}
> +static inline void md_llbitmap_exit(void)
> +{
> +}
> +#endif
> +
>  #endif
> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> new file mode 100644
> index 000000000000..077203106f4d
> --- /dev/null
> +++ b/drivers/md/md-llbitmap.c
> @@ -0,0 +1,1596 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +
> +#include <linux/blkdev.h>
> +#include <linux/module.h>
> +#include <linux/errno.h>
> +#include <linux/slab.h>
> +#include <linux/init.h>
> +#include <linux/timer.h>
> +#include <linux/sched.h>
> +#include <linux/list.h>
> +#include <linux/file.h>
> +#include <linux/seq_file.h>
> +#include <trace/events/block.h>
> +
> +#include "md.h"
> +#include "md-bitmap.h"
> +
> +/*
> + * #### Background
> + *
> + * Redundant data is used to enhance data fault tolerance, and the stora=
ge
> + * method for redundant data vary depending on the RAID levels. And it's
> + * important to maintain the consistency of redundant data.
> + *
> + * Bitmap is used to record which data blocks have been synchronized and=
 which
> + * ones need to be resynchronized or recovered. Each bit in the bitmap
> + * represents a segment of data in the array. When a bit is set, it indi=
cates
> + * that the multiple redundant copies of that data segment may not be
> + * consistent. Data synchronization can be performed based on the bitmap=
 after
> + * power failure or readding a disk. If there is no bitmap, a full disk
> + * synchronization is required.
> + *
> + * #### Key Features
> + *
> + *  - IO fastpath is lockless, if user issues lots of write IO to the sa=
me
> + *  bitmap bit in a short time, only the first write have additional ove=
rhead
> + *  to update bitmap bit, no additional overhead for the following write=
s;
> + *  - support only resync or recover written data, means in the case cre=
ating
> + *  new array or replacing with a new disk, there is no need to do a ful=
l disk
> + *  resync/recovery;
> + *
> + * #### Key Concept
> + *
> + * ##### State Machine
> + *
> + * Each bit is one byte, contain 6 difference state, see llbitmap_state.=
 And
> + * there are total 8 differenct actions, see llbitmap_action, can change=
 state:
> + *
> + * llbitmap state machine: transitions between states
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
> + * All bits will be set to Unwritten by default, if --assume-clean is se=
t,
> + * all bits will be set to Clean instead.
> + *
> + * 2) write data, raid1/raid10 have full copy of data, while raid456 doe=
sn't and
> + * rely on xor data
> + *
> + * 2.1) write new data to raid1/raid10:
> + * Unwritten --StartWrite--> Dirty
> + *
> + * 2.2) write new data to raid456:
> + * Unwritten --StartWrite--> NeedSync
> + *
> + * Because the initial recover for raid456 is skipped, the xor data is n=
ot build
> + * yet, the bit must set to NeedSync first and after lazy initial recove=
r is
> + * finished, the bit will finially set to Dirty(see 5.1 and 5.4);
> + *
> + * 2.3) cover write
> + * Clean --StartWrite--> Dirty
> + *
> + * 3) daemon, if the array is not degraded:
> + * Dirty --Daemon--> Clean
> + *
> + * For degraded array, the Dirty bit will never be cleared, prevent full=
 disk
> + * recovery while readding a removed disk.
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
> + * By default, the old bitmap framework will recover all data, and llbit=
map
> + * implement this by a new helper, see llbitmap_skip_sync_blocks:
> + *
> + * skip recover for bits other than dirty or clean;
> + *
> + * 5.4) lazy initial recover for raid5:
> + * By default, the old bitmap framework will only allow new recover when=
 there
> + * are spares(new disk), a new recovery flag MD_RECOVERY_LAZY_RECOVER is=
 add
> + * to perform raid456 lazy recover for set bits(from 2.2).
> + *
> + * ##### Bitmap IO
> + *
> + * ##### Chunksize
> + *
> + * The default bitmap size is 128k, incluing 1k bitmap super block, and
> + * the default size of segment of data in the array each bit(chunksize) =
is 64k,
> + * and chunksize will adjust to twice the old size each time if the tota=
l number
> + * bits is not less than 127k.(see llbitmap_init)
> + *
> + * ##### READ
> + *
> + * While creating bitmap, all pages will be allocated and read for llbit=
map,
> + * there won't be read afterwards
> + *
> + * ##### WRITE
> + *
> + * WRITE IO is divided into logical_block_size of the array, the dirty s=
tate
> + * of each block is tracked independently, for example:
> + *
> + * each page is 4k, contain 8 blocks; each block is 512 bytes contain 51=
2 bit;
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
> + * From IO path, if one bit is changed to Dirty or NeedSync, the corresp=
onding
> + * subpage will be marked dirty, such block must write first before the =
IO is
> + * issued. This behaviour will affect IO performance, to reduce the impa=
ct, if
> + * multiple bits are changed in the same block in a short time, all bits=
 in this
> + * block will be changed to Dirty/NeedSync, so that there won't be any o=
verhead
> + * until daemon clears dirty bits.
> + *
> + * ##### Dirty Bits syncronization
> + *
> + * IO fast path will set bits to dirty, and those dirty bits will be cle=
ared
> + * by daemon after IO is done. llbitmap_page_ctl is used to synchronize =
between
> + * IO path and daemon;
> + *
> + * IO path:
> + *  1) try to grab a reference, if succeed, set expire time after 5s and=
 return;
> + *  2) if failed to grab a reference, wait for daemon to finish clearing=
 dirty
> + *  bits;
> + *
> + * Daemon(Daemon will be waken up every daemon_sleep seconds):
> + * For each page:
> + *  1) check if page expired, if not skip this page; for expired page:
> + *  2) suspend the page and wait for inflight write IO to be done;
> + *  3) change dirty page to clean;
> + *  4) resume the page;
> + */
> +
> +#define BITMAP_DATA_OFFSET 1024
> +
> +/* 64k is the max IO size of sync IO for raid1/raid10 */
> +#define MIN_CHUNK_SIZE (64 * 2)
> +
> +/* By default, daemon will be waken up every 30s */
> +#define DEFAULT_DAEMON_SLEEP 30
> +
> +/*
> + * Dirtied bits that have not been accessed for more than 5s will be cle=
ared
> + * by daemon.
> + */
> +#define DEFAULT_BARRIER_IDLE 5
> +
> +enum llbitmap_state {
> +       /* No valid data, init state after assemble the array */
> +       BitUnwritten =3D 0,
> +       /* data is consistent */
> +       BitClean,
> +       /* data will be consistent after IO is done, set directly for wri=
tes */
> +       BitDirty,
> +       /*
> +        * data need to be resynchronized:
> +        * 1) set directly for writes if array is degraded, prevent full =
disk
> +        * synchronization after readding a disk;
> +        * 2) reassemble the array after power failure, and dirty bits ar=
e
> +        * found after reloading the bitmap;
> +        * 3) set for first write for raid5, to build initial xor data la=
zily
> +        */
> +       BitNeedSync,
> +       /* data is synchronizing */
> +       BitSyncing,
> +       BitStateCount,
> +       BitNone =3D 0xff,
> +};
> +
> +enum llbitmap_action {
> +       /* User write new data, this is the only action from IO fast path=
 */
> +       BitmapActionStartwrite =3D 0,
> +       /* Start recovery */
> +       BitmapActionStartsync,
> +       /* Finish recovery */
> +       BitmapActionEndsync,
> +       /* Failed recovery */
> +       BitmapActionAbortsync,
> +       /* Reassemble the array */
> +       BitmapActionReload,
> +       /* Daemon thread is trying to clear dirty bits */
> +       BitmapActionDaemon,
> +       /* Data is deleted */
> +       BitmapActionDiscard,
> +       /*
> +        * Bitmap is stale, mark all bits in addition to BitUnwritten to
> +        * BitNeedSync.
> +        */
> +       BitmapActionStale,
> +       BitmapActionCount,
> +       /* Init state is BitUnwritten */
> +       BitmapActionInit,
> +};
> +
> +enum llbitmap_page_state {
> +       LLPageFlush =3D 0,
> +       LLPageDirty,
> +};
> +
> +struct llbitmap_page_ctl {
> +       char *state;
> +       struct page *page;
> +       unsigned long expire;
> +       unsigned long flags;
> +       wait_queue_head_t wait;
> +       struct percpu_ref active;
> +       /* Per block size dirty state, maximum 64k page / 1 sector =3D 12=
8 */
> +       unsigned long dirty[];
> +};
> +
> +struct llbitmap {
> +       struct mddev *mddev;
> +       struct llbitmap_page_ctl **pctl;
> +
> +       unsigned int nr_pages;
> +       unsigned int io_size;
> +       unsigned int blocks_per_page;
> +
> +       /* shift of one chunk */
> +       unsigned long chunkshift;
> +       /* size of one chunk in sector */
> +       unsigned long chunksize;
> +       /* total number of chunks */
> +       unsigned long chunks;
> +       unsigned long last_end_sync;
> +       /*
> +        * time in seconds that dirty bits will be cleared if the page is=
 not
> +        * accessed.
> +        */
> +       unsigned long barrier_idle;
> +       /* fires on first BitDirty state */
> +       struct timer_list pending_timer;
> +       struct work_struct daemon_work;
> +
> +       unsigned long flags;
> +       __u64   events_cleared;
> +
> +       /* for slow disks */
> +       atomic_t behind_writes;
> +       wait_queue_head_t behind_wait;
> +};
> +
> +struct llbitmap_unplug_work {
> +       struct work_struct work;
> +       struct llbitmap *llbitmap;
> +       struct completion *done;
> +};
> +
> +static struct workqueue_struct *md_llbitmap_io_wq;
> +static struct workqueue_struct *md_llbitmap_unplug_wq;
> +
> +static char state_machine[BitStateCount][BitmapActionCount] =3D {
> +       [BitUnwritten] =3D {
> +               [BitmapActionStartwrite]        =3D BitDirty,
> +               [BitmapActionStartsync]         =3D BitNone,
> +               [BitmapActionEndsync]           =3D BitNone,
> +               [BitmapActionAbortsync]         =3D BitNone,
> +               [BitmapActionReload]            =3D BitNone,
> +               [BitmapActionDaemon]            =3D BitNone,
> +               [BitmapActionDiscard]           =3D BitNone,
> +               [BitmapActionStale]             =3D BitNone,
> +       },
> +       [BitClean] =3D {
> +               [BitmapActionStartwrite]        =3D BitDirty,
> +               [BitmapActionStartsync]         =3D BitNone,
> +               [BitmapActionEndsync]           =3D BitNone,
> +               [BitmapActionAbortsync]         =3D BitNone,
> +               [BitmapActionReload]            =3D BitNone,
> +               [BitmapActionDaemon]            =3D BitNone,
> +               [BitmapActionDiscard]           =3D BitUnwritten,
> +               [BitmapActionStale]             =3D BitNeedSync,
> +       },
> +       [BitDirty] =3D {
> +               [BitmapActionStartwrite]        =3D BitNone,
> +               [BitmapActionStartsync]         =3D BitNone,
> +               [BitmapActionEndsync]           =3D BitNone,
> +               [BitmapActionAbortsync]         =3D BitNone,
> +               [BitmapActionReload]            =3D BitNeedSync,
> +               [BitmapActionDaemon]            =3D BitClean,
> +               [BitmapActionDiscard]           =3D BitUnwritten,
> +               [BitmapActionStale]             =3D BitNeedSync,
> +       },
> +       [BitNeedSync] =3D {
> +               [BitmapActionStartwrite]        =3D BitNone,
> +               [BitmapActionStartsync]         =3D BitSyncing,
> +               [BitmapActionEndsync]           =3D BitNone,
> +               [BitmapActionAbortsync]         =3D BitNone,
> +               [BitmapActionReload]            =3D BitNone,
> +               [BitmapActionDaemon]            =3D BitNone,
> +               [BitmapActionDiscard]           =3D BitUnwritten,
> +               [BitmapActionStale]             =3D BitNone,
> +       },
> +       [BitSyncing] =3D {
> +               [BitmapActionStartwrite]        =3D BitNone,
> +               [BitmapActionStartsync]         =3D BitSyncing,
> +               [BitmapActionEndsync]           =3D BitDirty,
> +               [BitmapActionAbortsync]         =3D BitNeedSync,
> +               [BitmapActionReload]            =3D BitNeedSync,
> +               [BitmapActionDaemon]            =3D BitNone,
> +               [BitmapActionDiscard]           =3D BitUnwritten,
> +               [BitmapActionStale]             =3D BitNeedSync,
> +       },
> +};
> +
> +static enum llbitmap_state llbitmap_read(struct llbitmap *llbitmap, loff=
_t pos)
> +{
> +       unsigned int idx;
> +       unsigned int offset;
> +
> +       pos +=3D BITMAP_DATA_OFFSET;
> +       idx =3D pos >> PAGE_SHIFT;
> +       offset =3D offset_in_page(pos);
> +
> +       return llbitmap->pctl[idx]->state[offset];
> +}
> +
> +/* set all the bits in the subpage as dirty */
> +static void llbitmap_infect_dirty_bits(struct llbitmap *llbitmap,
> +                                      struct llbitmap_page_ctl *pctl,
> +                                      unsigned int block, unsigned int o=
ffset)
> +{
> +       bool level_456 =3D raid_is_456(llbitmap->mddev);
> +       unsigned int io_size =3D llbitmap->io_size;
> +       int pos;
> +
> +       for (pos =3D block * io_size; pos < (block + 1) * io_size; pos++)=
 {
> +               if (pos =3D=3D offset)
> +                       continue;

It looks like it doesn't need to pass the argument offset to this
function. The pctl->state[offset] must be BitDirty or BitNeedSync. So
the following switch/case can skip it. So it can save hundreds
comparing pos with offset here.

> +
> +               switch (pctl->state[pos]) {
> +               case BitUnwritten:
> +                       pctl->state[pos] =3D level_456 ? BitNeedSync : Bi=
tDirty;
> +                       break;
> +               case BitClean:
> +                       pctl->state[pos] =3D BitDirty;
> +                       break;
> +               };
> +       }
> +
> +}
> +
> +static void llbitmap_set_page_dirty(struct llbitmap *llbitmap, int idx,
> +                                   int offset)
> +{
> +       struct llbitmap_page_ctl *pctl =3D llbitmap->pctl[idx];
> +       unsigned int io_size =3D llbitmap->io_size;
> +       int block =3D offset / io_size;
> +       int pos;
> +
> +       if (!test_bit(LLPageDirty, &pctl->flags))
> +               set_bit(LLPageDirty, &pctl->flags);
> +
> +       /*
> +        * The subpage usually contains a total of 512 bits. If any singl=
e bit
> +        * within the subpage is marked as dirty, the entire sector will =
be
> +        * written. To avoid impacting write performance, when multiple b=
its
> +        * within the same sector are modified within llbitmap->barrier_i=
dle,
> +        * all bits in the sector will be collectively marked as dirty at=
 once.
> +        */
> +       if (test_and_set_bit(block, pctl->dirty)) {
> +               llbitmap_infect_dirty_bits(llbitmap, pctl, block, offset)=
;
> +               return;
> +       }
> +
> +       for (pos =3D block * io_size; pos < (block + 1) * io_size; pos++)=
 {
> +               if (pos =3D=3D offset)
> +                       continue;
> +               if (pctl->state[pos] =3D=3D BitDirty ||
> +                   pctl->state[pos] =3D=3D BitNeedSync) {
> +                       llbitmap_infect_dirty_bits(llbitmap, pctl, block,=
 offset);
> +                       return;
> +               }
> +       }
> +}
> +
> +static void llbitmap_write(struct llbitmap *llbitmap, enum llbitmap_stat=
e state,
> +                          loff_t pos)
> +{
> +       unsigned int idx;
> +       unsigned int offset;

How about change offset to bit?
> +
> +       pos +=3D BITMAP_DATA_OFFSET;
> +       idx =3D pos >> PAGE_SHIFT;
> +       offset =3D offset_in_page(pos);
> +
> +       llbitmap->pctl[idx]->state[offset] =3D state;
> +       if (state =3D=3D BitDirty || state =3D=3D BitNeedSync)
> +               llbitmap_set_page_dirty(llbitmap, idx, offset);
> +}
> +
> +static struct page *llbitmap_read_page(struct llbitmap *llbitmap, int id=
x)
> +{
> +       struct mddev *mddev =3D llbitmap->mddev;
> +       struct page *page =3D NULL;
> +       struct md_rdev *rdev;
> +
> +       if (llbitmap->pctl && llbitmap->pctl[idx])
> +               page =3D llbitmap->pctl[idx]->page;
> +       if (page)
> +               return page;
> +
> +       page =3D alloc_page(GFP_KERNEL | __GFP_ZERO);
> +       if (!page)
> +               return ERR_PTR(-ENOMEM);
> +
> +       rdev_for_each(rdev, mddev) {
> +               sector_t sector;
> +
> +               if (rdev->raid_disk < 0 || test_bit(Faulty, &rdev->flags)=
)
> +                       continue;
> +
> +               sector =3D mddev->bitmap_info.offset +
> +                        (idx << PAGE_SECTORS_SHIFT);
> +
> +               if (sync_page_io(rdev, sector, PAGE_SIZE, page, REQ_OP_RE=
AD,
> +                                true))
> +                       return page;
> +
> +               md_error(mddev, rdev);
> +       }
> +
> +       __free_page(page);
> +       return ERR_PTR(-EIO);
> +}
> +
> +static void llbitmap_write_page(struct llbitmap *llbitmap, int idx)
> +{
> +       struct page *page =3D llbitmap->pctl[idx]->page;
> +       struct mddev *mddev =3D llbitmap->mddev;
> +       struct md_rdev *rdev;
> +       int bit;

It's better to change name "bit" to "block"
> +
> +       for (bit =3D 0; bit < llbitmap->blocks_per_page; bit++) {
> +               struct llbitmap_page_ctl *pctl =3D llbitmap->pctl[idx];
> +
> +               if (!test_and_clear_bit(bit, pctl->dirty))
> +                       continue;
> +
> +               rdev_for_each(rdev, mddev) {
> +                       sector_t sector;
> +                       sector_t bit_sector =3D llbitmap->io_size >> SECT=
OR_SHIFT;
> +
> +                       if (rdev->raid_disk < 0 || test_bit(Faulty, &rdev=
->flags))
> +                               continue;
> +
> +                       sector =3D mddev->bitmap_info.offset + rdev->sb_s=
tart +
> +                                (idx << PAGE_SECTORS_SHIFT) +
> +                                bit * bit_sector;
> +                       md_write_metadata(mddev, rdev, sector,
> +                                         llbitmap->io_size, page,
> +                                         bit * llbitmap->io_size);
> +               }
> +       }
> +}
> +
> +static void active_release(struct percpu_ref *ref)
> +{
> +       struct llbitmap_page_ctl *pctl =3D
> +               container_of(ref, struct llbitmap_page_ctl, active);
> +
> +       wake_up(&pctl->wait);
> +}
> +
> +static void llbitmap_free_pages(struct llbitmap *llbitmap)
> +{
> +       int i;
> +
> +       if (!llbitmap->pctl)
> +               return;
> +
> +       for (i =3D 0; i < llbitmap->nr_pages; i++) {
> +               struct llbitmap_page_ctl *pctl =3D llbitmap->pctl[i];
> +
> +               if (!pctl || !pctl->page)
> +                       break;
> +
> +               __free_page(pctl->page);
> +               percpu_ref_exit(&pctl->active);
> +       }
> +
> +       kfree(llbitmap->pctl[0]);
> +       kfree(llbitmap->pctl);
> +       llbitmap->pctl =3D NULL;
> +}
> +
> +static int llbitmap_cache_pages(struct llbitmap *llbitmap)
> +{
> +       struct llbitmap_page_ctl *pctl;
> +       unsigned int nr_pages =3D DIV_ROUND_UP(llbitmap->chunks +
> +                                            BITMAP_DATA_OFFSET, PAGE_SIZ=
E);
> +       unsigned int size =3D struct_size(pctl, dirty, BITS_TO_LONGS(
> +                                               llbitmap->blocks_per_page=
));
> +       int i;
> +
> +       llbitmap->pctl =3D kmalloc_array(nr_pages, sizeof(void *),
> +                                      GFP_KERNEL | __GFP_ZERO);
> +       if (!llbitmap->pctl)
> +               return -ENOMEM;
> +
> +       size =3D round_up(size, cache_line_size());
> +       pctl =3D kmalloc_array(nr_pages, size, GFP_KERNEL | __GFP_ZERO);
> +       if (!pctl) {
> +               kfree(llbitmap->pctl);
> +               return -ENOMEM;
> +       }
> +
> +       llbitmap->nr_pages =3D nr_pages;
> +
> +       for (i =3D 0; i < nr_pages; i++, pctl =3D (void *)pctl + size) {
> +               struct page *page =3D llbitmap_read_page(llbitmap, i);
> +
> +               llbitmap->pctl[i] =3D pctl;
> +
> +               if (IS_ERR(page)) {
> +                       llbitmap_free_pages(llbitmap);
> +                       return PTR_ERR(page);
> +               }
> +
> +               if (percpu_ref_init(&pctl->active, active_release,
> +                                   PERCPU_REF_ALLOW_REINIT, GFP_KERNEL))=
 {
> +                       __free_page(page);
> +                       llbitmap_free_pages(llbitmap);
> +                       return -ENOMEM;
> +               }
> +
> +               pctl->page =3D page;
> +               pctl->state =3D page_address(page);
> +               init_waitqueue_head(&pctl->wait);
> +       }
> +
> +       return 0;
> +}
> +
> +static void llbitmap_init_state(struct llbitmap *llbitmap)
> +{
> +       enum llbitmap_state state =3D BitUnwritten;
> +       unsigned long i;
> +
> +       if (test_and_clear_bit(BITMAP_CLEAN, &llbitmap->flags))
> +               state =3D BitClean;
> +
> +       for (i =3D 0; i < llbitmap->chunks; i++)
> +               llbitmap_write(llbitmap, state, i);
> +}
> +
> +/* The return value is only used from resync, where @start =3D=3D @end. =
*/
> +static enum llbitmap_state llbitmap_state_machine(struct llbitmap *llbit=
map,
> +                                                 unsigned long start,
> +                                                 unsigned long end,
> +                                                 enum llbitmap_action ac=
tion)
> +{
> +       struct mddev *mddev =3D llbitmap->mddev;
> +       enum llbitmap_state state =3D BitNone;
> +       bool need_resync =3D false;
> +       bool need_recovery =3D false;
> +
> +       if (test_bit(BITMAP_WRITE_ERROR, &llbitmap->flags))
> +               return BitNone;
> +
> +       if (action =3D=3D BitmapActionInit) {
> +               llbitmap_init_state(llbitmap);
> +               return BitNone;
> +       }
> +
> +       while (start <=3D end) {
> +               enum llbitmap_state c =3D llbitmap_read(llbitmap, start);
> +
> +               if (c < 0 || c >=3D BitStateCount) {
> +                       pr_err("%s: invalid bit %lu state %d action %d, f=
orcing resync\n",
> +                              __func__, start, c, action);
> +                       state =3D BitNeedSync;
> +                       goto write_bitmap;
> +               }
> +
> +               if (c =3D=3D BitNeedSync)
> +                       need_resync =3D true;
> +
> +               state =3D state_machine[c][action];
> +               if (state =3D=3D BitNone) {
> +                       start++;
> +                       continue;
> +               }
> +
> +write_bitmap:
> +               /* Delay raid456 initial recovery to first write. */
> +               if (c =3D=3D BitUnwritten && state =3D=3D BitDirty &&
> +                   action =3D=3D BitmapActionStartwrite && raid_is_456(m=
ddev)) {
> +                       state =3D BitNeedSync;
> +                       need_recovery =3D true;
> +               }
> +
> +               llbitmap_write(llbitmap, state, start);
> +
> +               if (state =3D=3D BitNeedSync)
> +                       need_resync =3D true;
> +               else if (state =3D=3D BitDirty &&
> +                        !timer_pending(&llbitmap->pending_timer))
> +                       mod_timer(&llbitmap->pending_timer,
> +                                 jiffies + mddev->bitmap_info.daemon_sle=
ep * HZ);
> +
> +               start++;
> +       }
> +
> +       if (need_recovery) {
> +               set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> +               set_bit(MD_RECOVERY_LAZY_RECOVER, &mddev->recovery);
> +               md_wakeup_thread(mddev->thread);
> +       } else if (need_resync) {
> +               set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> +               set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
> +               md_wakeup_thread(mddev->thread);
> +       }
> +
> +       return state;
> +}
> +
> +static void llbitmap_raise_barrier(struct llbitmap *llbitmap, int page_i=
dx)
> +{
> +       struct llbitmap_page_ctl *pctl =3D llbitmap->pctl[page_idx];
> +
> +retry:
> +       if (likely(percpu_ref_tryget_live(&pctl->active))) {
> +               WRITE_ONCE(pctl->expire, jiffies + llbitmap->barrier_idle=
 * HZ);
> +               return;
> +       }
> +
> +       wait_event(pctl->wait, !percpu_ref_is_dying(&pctl->active));
> +       goto retry;
> +}
> +
> +static void llbitmap_release_barrier(struct llbitmap *llbitmap, int page=
_idx)
> +{
> +       struct llbitmap_page_ctl *pctl =3D llbitmap->pctl[page_idx];
> +
> +       percpu_ref_put(&pctl->active);
> +}
> +
> +static int llbitmap_suspend_timeout(struct llbitmap *llbitmap, int page_=
idx)
> +{
> +       struct llbitmap_page_ctl *pctl =3D llbitmap->pctl[page_idx];
> +
> +       percpu_ref_kill(&pctl->active);
> +
> +       if (!wait_event_timeout(pctl->wait, percpu_ref_is_zero(&pctl->act=
ive),
> +                       llbitmap->mddev->bitmap_info.daemon_sleep * HZ))
> +               return -ETIMEDOUT;
> +
> +       return 0;
> +}
> +
> +static void llbitmap_resume(struct llbitmap *llbitmap, int page_idx)
> +{
> +       struct llbitmap_page_ctl *pctl =3D llbitmap->pctl[page_idx];
> +
> +       pctl->expire =3D LONG_MAX;
> +       percpu_ref_resurrect(&pctl->active);
> +       wake_up(&pctl->wait);
> +}
> +
> +static int llbitmap_check_support(struct mddev *mddev)
> +{
> +       if (test_bit(MD_HAS_JOURNAL, &mddev->flags)) {
> +               pr_notice("md/llbitmap: %s: array with journal cannot hav=
e bitmap\n",
> +                         mdname(mddev));
> +               return -EBUSY;
> +       }
> +
> +       if (mddev->bitmap_info.space =3D=3D 0) {
> +               if (mddev->bitmap_info.default_space =3D=3D 0) {
> +                       pr_notice("md/llbitmap: %s: no space for bitmap\n=
",
> +                                 mdname(mddev));
> +                       return -ENOSPC;
> +               }
> +       }
> +
> +       if (!mddev->persistent) {
> +               pr_notice("md/llbitmap: %s: array must be persistent\n",
> +                         mdname(mddev));
> +               return -EOPNOTSUPP;
> +       }
> +
> +       if (mddev->bitmap_info.file) {
> +               pr_notice("md/llbitmap: %s: doesn't support bitmap file\n=
",
> +                         mdname(mddev));
> +               return -EOPNOTSUPP;
> +       }
> +
> +       if (mddev->bitmap_info.external) {
> +               pr_notice("md/llbitmap: %s: doesn't support external meta=
data\n",
> +                         mdname(mddev));
> +               return -EOPNOTSUPP;
> +       }
> +
> +       if (mddev_is_dm(mddev)) {
> +               pr_notice("md/llbitmap: %s: doesn't support dm-raid\n",
> +                         mdname(mddev));
> +               return -EOPNOTSUPP;
> +       }
> +
> +       return 0;
> +}
> +
> +static int llbitmap_init(struct llbitmap *llbitmap)
> +{
> +       struct mddev *mddev =3D llbitmap->mddev;
> +       sector_t blocks =3D mddev->resync_max_sectors;
> +       unsigned long chunksize =3D MIN_CHUNK_SIZE;
> +       unsigned long chunks =3D DIV_ROUND_UP(blocks, chunksize);
> +       unsigned long space =3D mddev->bitmap_info.space << SECTOR_SHIFT;
> +       int ret;
> +
> +       while (chunks > space) {
> +               chunksize =3D chunksize << 1;
> +               chunks =3D DIV_ROUND_UP(blocks, chunksize);
> +       }
> +
> +       llbitmap->barrier_idle =3D DEFAULT_BARRIER_IDLE;
> +       llbitmap->chunkshift =3D ffz(~chunksize);
> +       llbitmap->chunksize =3D chunksize;
> +       llbitmap->chunks =3D chunks;
> +       mddev->bitmap_info.daemon_sleep =3D DEFAULT_DAEMON_SLEEP;
> +
> +       ret =3D llbitmap_cache_pages(llbitmap);
> +       if (ret)
> +               return ret;
> +
> +       llbitmap_state_machine(llbitmap, 0, llbitmap->chunks - 1, BitmapA=
ctionInit);
> +       return 0;
> +}

There is a problem, if array is created with --assume-clean, it
doesn't need to start sync. And it doesn't have the chance to sync
llbitmap superblock to member disks. So it can't get the right bitmap
superblock information which is calculated here after a power off. It
needs to sync the superblock here.

> +
> +static int llbitmap_read_sb(struct llbitmap *llbitmap)
> +{
> +       struct mddev *mddev =3D llbitmap->mddev;
> +       unsigned long daemon_sleep;
> +       unsigned long chunksize;
> +       unsigned long events;
> +       struct page *sb_page;
> +       bitmap_super_t *sb;
> +       int ret =3D -EINVAL;
> +
> +       if (!mddev->bitmap_info.offset) {
> +               pr_err("md/llbitmap: %s: no super block found", mdname(md=
dev));
> +               return -EINVAL;
> +       }
> +
> +       sb_page =3D llbitmap_read_page(llbitmap, 0);
> +       if (IS_ERR(sb_page)) {
> +               pr_err("md/llbitmap: %s: read super block failed",
> +                      mdname(mddev));
> +               return -EIO;
> +       }
> +
> +       sb =3D kmap_local_page(sb_page);
> +       if (sb->magic !=3D cpu_to_le32(BITMAP_MAGIC)) {
> +               pr_err("md/llbitmap: %s: invalid super block magic number=
",
> +                      mdname(mddev));
> +               goto out_put_page;
> +       }
> +
> +       if (sb->version !=3D cpu_to_le32(BITMAP_MAJOR_LOCKLESS)) {
> +               pr_err("md/llbitmap: %s: invalid super block version",
> +                      mdname(mddev));
> +               goto out_put_page;
> +       }
> +
> +       if (memcmp(sb->uuid, mddev->uuid, 16)) {
> +               pr_err("md/llbitmap: %s: bitmap superblock UUID mismatch\=
n",
> +                      mdname(mddev));
> +               goto out_put_page;
> +       }
> +
> +       if (mddev->bitmap_info.space =3D=3D 0) {
> +               int room =3D le32_to_cpu(sb->sectors_reserved);
> +
> +               if (room)
> +                       mddev->bitmap_info.space =3D room;
> +               else
> +                       mddev->bitmap_info.space =3D mddev->bitmap_info.d=
efault_space;
> +       }
> +       llbitmap->flags =3D le32_to_cpu(sb->state);
> +       if (test_and_clear_bit(BITMAP_FIRST_USE, &llbitmap->flags)) {
> +               ret =3D llbitmap_init(llbitmap);
> +               goto out_put_page;
> +       }
> +
> +       chunksize =3D le32_to_cpu(sb->chunksize);
> +       if (!is_power_of_2(chunksize)) {
> +               pr_err("md/llbitmap: %s: chunksize not a power of 2",
> +                      mdname(mddev));
> +               goto out_put_page;
> +       }
> +
> +       if (chunksize < DIV_ROUND_UP(mddev->resync_max_sectors,
> +                                    mddev->bitmap_info.space << SECTOR_S=
HIFT)) {
> +               pr_err("md/llbitmap: %s: chunksize too small %lu < %llu /=
 %lu",
> +                      mdname(mddev), chunksize, mddev->resync_max_sector=
s,
> +                      mddev->bitmap_info.space);
> +               goto out_put_page;
> +       }
> +
> +       daemon_sleep =3D le32_to_cpu(sb->daemon_sleep);
> +       if (daemon_sleep < 1 || daemon_sleep > MAX_SCHEDULE_TIMEOUT / HZ)=
 {
> +               pr_err("md/llbitmap: %s: daemon sleep %lu period out of r=
ange",
> +                      mdname(mddev), daemon_sleep);
> +               goto out_put_page;
> +       }
> +
> +       events =3D le64_to_cpu(sb->events);
> +       if (events < mddev->events) {
> +               pr_warn("md/llbitmap :%s: bitmap file is out of date (%lu=
 < %llu) -- forcing full recovery",
> +                       mdname(mddev), events, mddev->events);
> +               set_bit(BITMAP_STALE, &llbitmap->flags);
> +       }
> +
> +       sb->sync_size =3D cpu_to_le64(mddev->resync_max_sectors);
> +       mddev->bitmap_info.chunksize =3D chunksize;
> +       mddev->bitmap_info.daemon_sleep =3D daemon_sleep;
> +
> +       llbitmap->barrier_idle =3D DEFAULT_BARRIER_IDLE;
> +       llbitmap->chunksize =3D chunksize;
> +       llbitmap->chunks =3D DIV_ROUND_UP(mddev->resync_max_sectors, chun=
ksize);
> +       llbitmap->chunkshift =3D ffz(~chunksize);
> +       ret =3D llbitmap_cache_pages(llbitmap);
> +
> +out_put_page:
> +       __free_page(sb_page);
> +       kunmap_local(sb);
> +       return ret;
> +}
> +
> +static void llbitmap_pending_timer_fn(struct timer_list *pending_timer)
> +{
> +       struct llbitmap *llbitmap =3D
> +               container_of(pending_timer, struct llbitmap, pending_time=
r);
> +
> +       if (work_busy(&llbitmap->daemon_work)) {
> +               pr_warn("md/llbitmap: %s daemon_work not finished in %lu =
seconds\n",
> +                       mdname(llbitmap->mddev),
> +                       llbitmap->mddev->bitmap_info.daemon_sleep);
> +               set_bit(BITMAP_DAEMON_BUSY, &llbitmap->flags);
> +               return;
> +       }
> +
> +       queue_work(md_llbitmap_io_wq, &llbitmap->daemon_work);
> +}
> +
> +static void md_llbitmap_daemon_fn(struct work_struct *work)
> +{
> +       struct llbitmap *llbitmap =3D
> +               container_of(work, struct llbitmap, daemon_work);
> +       unsigned long start;
> +       unsigned long end;
> +       bool restart;
> +       int idx;
> +
> +       if (llbitmap->mddev->degraded)
> +               return;
> +
> +retry:
> +       start =3D 0;
> +       end =3D min(llbitmap->chunks, PAGE_SIZE - BITMAP_DATA_OFFSET) - 1=
;
> +       restart =3D false;
> +
> +       for (idx =3D 0; idx < llbitmap->nr_pages; idx++) {
> +               struct llbitmap_page_ctl *pctl =3D llbitmap->pctl[idx];
> +
> +               if (idx > 0) {
> +                       start =3D end + 1;
> +                       end =3D min(end + PAGE_SIZE, llbitmap->chunks - 1=
);
> +               }
> +
> +               if (!test_bit(LLPageFlush, &pctl->flags) &&
> +                   time_before(jiffies, pctl->expire)) {
> +                       restart =3D true;
> +                       continue;
> +               }
> +
> +               if (llbitmap_suspend_timeout(llbitmap, idx) < 0) {
> +                       pr_warn("md/llbitmap: %s: %s waiting for page %d =
timeout\n",
> +                               mdname(llbitmap->mddev), __func__, idx);
> +                       continue;
> +               }
> +
> +               llbitmap_state_machine(llbitmap, start, end, BitmapAction=
Daemon);
> +               llbitmap_resume(llbitmap, idx);
> +       }
> +
> +       /*
> +        * If the daemon took a long time to finish, retry to prevent mis=
sing
> +        * clearing dirty bits.
> +        */
> +       if (test_and_clear_bit(BITMAP_DAEMON_BUSY, &llbitmap->flags))
> +               goto retry;
> +
> +       /* If some page is dirty but not expired, setup timer again */
> +       if (restart)
> +               mod_timer(&llbitmap->pending_timer,
> +                         jiffies + llbitmap->mddev->bitmap_info.daemon_s=
leep * HZ);
> +}
> +
> +static int llbitmap_create(struct mddev *mddev)
> +{
> +       struct llbitmap *llbitmap;
> +       int ret;
> +
> +       ret =3D llbitmap_check_support(mddev);
> +       if (ret)
> +               return ret;
> +
> +       llbitmap =3D kzalloc(sizeof(*llbitmap), GFP_KERNEL);
> +       if (!llbitmap)
> +               return -ENOMEM;
> +
> +       llbitmap->mddev =3D mddev;
> +       llbitmap->io_size =3D bdev_logical_block_size(mddev->gendisk->par=
t0);
> +       llbitmap->blocks_per_page =3D PAGE_SIZE / llbitmap->io_size;
> +
> +       timer_setup(&llbitmap->pending_timer, llbitmap_pending_timer_fn, =
0);
> +       INIT_WORK(&llbitmap->daemon_work, md_llbitmap_daemon_fn);
> +       atomic_set(&llbitmap->behind_writes, 0);
> +       init_waitqueue_head(&llbitmap->behind_wait);
> +
> +       mutex_lock(&mddev->bitmap_info.mutex);
> +       mddev->bitmap =3D llbitmap;
> +       ret =3D llbitmap_read_sb(llbitmap);
> +       mutex_unlock(&mddev->bitmap_info.mutex);
> +       if (ret)
> +               goto err_out;
> +
> +       return 0;
> +
> +err_out:
> +       kfree(llbitmap);

mddev->bitmap =3D NULL. If not,
md_run->md_bitmap_destroy->llbitmap_destroy will free it again.

> +       return ret;
> +}
> +
> +static int llbitmap_resize(struct mddev *mddev, sector_t blocks, int chu=
nksize)
> +{
> +       struct llbitmap *llbitmap =3D mddev->bitmap;
> +       unsigned long chunks;
> +
> +       if (chunksize =3D=3D 0)
> +               chunksize =3D llbitmap->chunksize;
> +
> +       /* If there is enough space, leave the chunksize unchanged. */
> +       chunks =3D DIV_ROUND_UP(blocks, chunksize);
> +       while (chunks > mddev->bitmap_info.space << SECTOR_SHIFT) {
> +               chunksize =3D chunksize << 1;
> +               chunks =3D DIV_ROUND_UP(blocks, chunksize);
> +       }
> +
> +       llbitmap->chunkshift =3D ffz(~chunksize);
> +       llbitmap->chunksize =3D chunksize;
> +       llbitmap->chunks =3D chunks;
> +
> +       return 0;
> +}
> +
> +static int llbitmap_load(struct mddev *mddev)
> +{
> +       enum llbitmap_action action =3D BitmapActionReload;
> +       struct llbitmap *llbitmap =3D mddev->bitmap;
> +
> +       if (test_and_clear_bit(BITMAP_STALE, &llbitmap->flags))
> +               action =3D BitmapActionStale;
> +
> +       llbitmap_state_machine(llbitmap, 0, llbitmap->chunks - 1, action)=
;
> +       return 0;
> +}
> +
> +static void llbitmap_destroy(struct mddev *mddev)
> +{
> +       struct llbitmap *llbitmap =3D mddev->bitmap;
> +
> +       if (!llbitmap)
> +               return;
> +
> +       mutex_lock(&mddev->bitmap_info.mutex);
> +
> +       timer_delete_sync(&llbitmap->pending_timer);
> +       flush_workqueue(md_llbitmap_io_wq);
> +       flush_workqueue(md_llbitmap_unplug_wq);
> +
> +       mddev->bitmap =3D NULL;
> +       llbitmap_free_pages(llbitmap);
> +       kfree(llbitmap);
> +       mutex_unlock(&mddev->bitmap_info.mutex);
> +}
> +
> +static void llbitmap_start_write(struct mddev *mddev, sector_t offset,
> +                                unsigned long sectors)
> +{
> +       struct llbitmap *llbitmap =3D mddev->bitmap;
> +       unsigned long start =3D offset >> llbitmap->chunkshift;
> +       unsigned long end =3D (offset + sectors - 1) >> llbitmap->chunksh=
ift;
> +       int page_start =3D (start + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;
> +       int page_end =3D (end + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;
> +
> +       llbitmap_state_machine(llbitmap, start, end, BitmapActionStartwri=
te);
> +
> +

Two lines here, just need one.
> +       while (page_start <=3D page_end) {
> +               llbitmap_raise_barrier(llbitmap, page_start);
> +               page_start++;
> +       }
> +}
> +
> +static void llbitmap_end_write(struct mddev *mddev, sector_t offset,
> +                              unsigned long sectors)
> +{
> +       struct llbitmap *llbitmap =3D mddev->bitmap;
> +       unsigned long start =3D offset >> llbitmap->chunkshift;
> +       unsigned long end =3D (offset + sectors - 1) >> llbitmap->chunksh=
ift;
> +       int page_start =3D (start + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;
> +       int page_end =3D (end + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;
> +
> +       while (page_start <=3D page_end) {
> +               llbitmap_release_barrier(llbitmap, page_start);
> +               page_start++;
> +       }
> +}
> +
> +static void llbitmap_start_discard(struct mddev *mddev, sector_t offset,
> +                                  unsigned long sectors)
> +{
> +       struct llbitmap *llbitmap =3D mddev->bitmap;
> +       unsigned long start =3D DIV_ROUND_UP(offset, llbitmap->chunksize)=
;
> +       unsigned long end =3D (offset + sectors - 1) >> llbitmap->chunksh=
ift;
> +       int page_start =3D (start + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;
> +       int page_end =3D (end + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;
> +
> +       llbitmap_state_machine(llbitmap, start, end, BitmapActionDiscard)=
;
> +
> +       while (page_start <=3D page_end) {
> +               llbitmap_raise_barrier(llbitmap, page_start);
> +               page_start++;
> +       }
> +}
> +
> +static void llbitmap_end_discard(struct mddev *mddev, sector_t offset,
> +                                unsigned long sectors)
> +{
> +       struct llbitmap *llbitmap =3D mddev->bitmap;
> +       unsigned long start =3D DIV_ROUND_UP(offset, llbitmap->chunksize)=
;
> +       unsigned long end =3D (offset + sectors - 1) >> llbitmap->chunksh=
ift;
> +       int page_start =3D (start + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;
> +       int page_end =3D (end + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;
> +
> +       while (page_start <=3D page_end) {
> +               llbitmap_release_barrier(llbitmap, page_start);
> +               page_start++;
> +       }
> +}
> +
> +static void llbitmap_unplug_fn(struct work_struct *work)
> +{
> +       struct llbitmap_unplug_work *unplug_work =3D
> +               container_of(work, struct llbitmap_unplug_work, work);
> +       struct llbitmap *llbitmap =3D unplug_work->llbitmap;
> +       struct blk_plug plug;
> +       int i;
> +
> +       blk_start_plug(&plug);
> +
> +       for (i =3D 0; i < llbitmap->nr_pages; i++) {
> +               if (!test_bit(LLPageDirty, &llbitmap->pctl[i]->flags) ||
> +                   !test_and_clear_bit(LLPageDirty, &llbitmap->pctl[i]->=
flags))
> +                       continue;
> +
> +               llbitmap_write_page(llbitmap, i);
> +       }
> +
> +       blk_finish_plug(&plug);
> +       md_super_wait(llbitmap->mddev);
> +       complete(unplug_work->done);
> +}
> +
> +static bool llbitmap_dirty(struct llbitmap *llbitmap)
> +{
> +       int i;
> +
> +       for (i =3D 0; i < llbitmap->nr_pages; i++)
> +               if (test_bit(LLPageDirty, &llbitmap->pctl[i]->flags))
> +                       return true;
> +
> +       return false;
> +}
> +
> +static void llbitmap_unplug(struct mddev *mddev, bool sync)
> +{
> +       DECLARE_COMPLETION_ONSTACK(done);
> +       struct llbitmap *llbitmap =3D mddev->bitmap;
> +       struct llbitmap_unplug_work unplug_work =3D {
> +               .llbitmap =3D llbitmap,
> +               .done =3D &done,
> +       };
> +
> +       if (!llbitmap_dirty(llbitmap))
> +               return;
> +
> +       /*
> +        * Issue new bitmap IO under submit_bio() context will deadlock:
> +        *  - the bio will wait for bitmap bio to be done, before it can =
be
> +        *  issued;
> +        *  - bitmap bio will be added to current->bio_list and wait for =
this
> +        *  bio to be issued;
> +        */
> +       INIT_WORK_ONSTACK(&unplug_work.work, llbitmap_unplug_fn);
> +       queue_work(md_llbitmap_unplug_wq, &unplug_work.work);
> +       wait_for_completion(&done);
> +       destroy_work_on_stack(&unplug_work.work);
> +}
> +
> +/*
> + * Force to write all bitmap pages to disk, called when stopping the arr=
ay, or
> + * every daemon_sleep seconds when sync_thread is running.
> + */
> +static void __llbitmap_flush(struct mddev *mddev)
> +{
> +       struct llbitmap *llbitmap =3D mddev->bitmap;
> +       struct blk_plug plug;
> +       int i;
> +
> +       blk_start_plug(&plug);
> +       for (i =3D 0; i < llbitmap->nr_pages; i++) {
> +               struct llbitmap_page_ctl *pctl =3D llbitmap->pctl[i];
> +
> +               /* mark all bits as dirty */

"mark all blocks as dirty" is better?

> +               set_bit(LLPageDirty, &pctl->flags);
> +               bitmap_fill(pctl->dirty, llbitmap->blocks_per_page);
> +               llbitmap_write_page(llbitmap, i);
> +       }
> +       blk_finish_plug(&plug);
> +       md_super_wait(llbitmap->mddev);
> +}
> +
> +static void llbitmap_flush(struct mddev *mddev)
> +{
> +       struct llbitmap *llbitmap =3D mddev->bitmap;
> +       int i;
> +
> +       for (i =3D 0; i < llbitmap->nr_pages; i++)
> +               set_bit(LLPageFlush, &llbitmap->pctl[i]->flags);
> +
> +       timer_delete_sync(&llbitmap->pending_timer);
> +       queue_work(md_llbitmap_io_wq, &llbitmap->daemon_work);
> +       flush_work(&llbitmap->daemon_work);
> +
> +       __llbitmap_flush(mddev);
> +}
> +
> +/* This is used for raid5 lazy initial recovery */
> +static bool llbitmap_blocks_synced(struct mddev *mddev, sector_t offset)
> +{
> +       struct llbitmap *llbitmap =3D mddev->bitmap;
> +       unsigned long p =3D offset >> llbitmap->chunkshift;
> +       enum llbitmap_state c =3D llbitmap_read(llbitmap, p);
> +
> +       return c =3D=3D BitClean || c =3D=3D BitDirty;
> +}
> +
> +static sector_t llbitmap_skip_sync_blocks(struct mddev *mddev, sector_t =
offset)
> +{
> +       struct llbitmap *llbitmap =3D mddev->bitmap;
> +       unsigned long p =3D offset >> llbitmap->chunkshift;
> +       int blocks =3D llbitmap->chunksize - (offset & (llbitmap->chunksi=
ze - 1));
> +       enum llbitmap_state c =3D llbitmap_read(llbitmap, p);
> +
> +       /* always skip unwritten blocks */
> +       if (c =3D=3D BitUnwritten)
> +               return blocks;
> +
> +       /* For resync also skip clean/dirty blocks */
> +       if ((c =3D=3D BitClean || c =3D=3D BitDirty) &&
> +           test_bit(MD_RECOVERY_SYNC, &mddev->recovery) &&
> +           !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
> +               return blocks;
> +
> +       return 0;
> +}
> +
> +static bool llbitmap_start_sync(struct mddev *mddev, sector_t offset,
> +                               sector_t *blocks, bool degraded)
> +{
> +       struct llbitmap *llbitmap =3D mddev->bitmap;
> +       unsigned long p =3D offset >> llbitmap->chunkshift;
> +
> +       /*
> +        * Handle one bit at a time, this is much simpler. And it doesn't=
 matter
> +        * if md_do_sync() loop more times.
> +        */
> +       *blocks =3D llbitmap->chunksize - (offset & (llbitmap->chunksize =
- 1));
> +       return llbitmap_state_machine(llbitmap, p, p,
> +                                     BitmapActionStartsync) =3D=3D BitSy=
ncing;
> +}
> +
> +/* Something is wrong, sync_thread stop at @offset */
> +static void llbitmap_end_sync(struct mddev *mddev, sector_t offset,
> +                             sector_t *blocks)
> +{
> +       struct llbitmap *llbitmap =3D mddev->bitmap;
> +       unsigned long p =3D offset >> llbitmap->chunkshift;
> +
> +       *blocks =3D llbitmap->chunksize - (offset & (llbitmap->chunksize =
- 1));
> +       llbitmap_state_machine(llbitmap, p, llbitmap->chunks - 1,
> +                              BitmapActionAbortsync);
> +}
> +
> +/* A full sync_thread is finished */
> +static void llbitmap_close_sync(struct mddev *mddev)
> +{
> +       struct llbitmap *llbitmap =3D mddev->bitmap;
> +       int i;
> +
> +       for (i =3D 0; i < llbitmap->nr_pages; i++) {
> +               struct llbitmap_page_ctl *pctl =3D llbitmap->pctl[i];
> +
> +               /* let daemon_fn clear dirty bits immediately */
> +               WRITE_ONCE(pctl->expire, jiffies);
> +       }
> +
> +       llbitmap_state_machine(llbitmap, 0, llbitmap->chunks - 1,
> +                              BitmapActionEndsync);
> +}
> +
> +/*
> + * sync_thread have reached @sector, update metadata every daemon_sleep =
seconds,
> + * just in case sync_thread have to restart after power failure.
> + */
> +static void llbitmap_cond_end_sync(struct mddev *mddev, sector_t sector,
> +                                  bool force)
> +{
> +       struct llbitmap *llbitmap =3D mddev->bitmap;
> +
> +       if (sector =3D=3D 0) {
> +               llbitmap->last_end_sync =3D jiffies;
> +               return;
> +       }
> +
> +       if (time_before(jiffies, llbitmap->last_end_sync +
> +                                HZ * mddev->bitmap_info.daemon_sleep))
> +               return;
> +
> +       wait_event(mddev->recovery_wait, !atomic_read(&mddev->recovery_ac=
tive));
> +
> +       mddev->curr_resync_completed =3D sector;
> +       set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
> +       llbitmap_state_machine(llbitmap, 0, sector >> llbitmap->chunkshif=
t,
> +                              BitmapActionEndsync);
> +       __llbitmap_flush(mddev);
> +
> +       llbitmap->last_end_sync =3D jiffies;
> +       sysfs_notify_dirent_safe(mddev->sysfs_completed);
> +}
> +
> +static bool llbitmap_enabled(void *data, bool flush)
> +{
> +       struct llbitmap *llbitmap =3D data;
> +
> +       return llbitmap && !test_bit(BITMAP_WRITE_ERROR, &llbitmap->flags=
);
> +}
> +
> +static void llbitmap_dirty_bits(struct mddev *mddev, unsigned long s,
> +                               unsigned long e)
> +{
> +       llbitmap_state_machine(mddev->bitmap, s, e, BitmapActionStartwrit=
e);
> +}
> +
> +static void llbitmap_write_sb(struct llbitmap *llbitmap)
> +{
> +       int nr_bits =3D DIV_ROUND_UP(BITMAP_DATA_OFFSET, llbitmap->io_siz=
e);

s/nr_bits/nr_blocks/g




> +
> +       bitmap_fill(llbitmap->pctl[0]->dirty, nr_bits);
> +       llbitmap_write_page(llbitmap, 0);
> +       md_super_wait(llbitmap->mddev);
> +}
> +
> +static void llbitmap_update_sb(void *data)
> +{
> +       struct llbitmap *llbitmap =3D data;
> +       struct mddev *mddev =3D llbitmap->mddev;
> +       struct page *sb_page;
> +       bitmap_super_t *sb;
> +
> +       if (test_bit(BITMAP_WRITE_ERROR, &llbitmap->flags))
> +               return;
> +
> +       sb_page =3D llbitmap_read_page(llbitmap, 0);
> +       if (IS_ERR(sb_page)) {
> +               pr_err("%s: %s: read super block failed", __func__,
> +                      mdname(mddev));
> +               set_bit(BITMAP_WRITE_ERROR, &llbitmap->flags);
> +               return;
> +       }
> +
> +       if (mddev->events < llbitmap->events_cleared)
> +               llbitmap->events_cleared =3D mddev->events;
> +
> +       sb =3D kmap_local_page(sb_page);
> +       sb->events =3D cpu_to_le64(mddev->events);
> +       sb->state =3D cpu_to_le32(llbitmap->flags);
> +       sb->chunksize =3D cpu_to_le32(llbitmap->chunksize);
> +       sb->sync_size =3D cpu_to_le64(mddev->resync_max_sectors);
> +       sb->events_cleared =3D cpu_to_le64(llbitmap->events_cleared);
> +       sb->sectors_reserved =3D cpu_to_le32(mddev->bitmap_info.space);
> +       sb->daemon_sleep =3D cpu_to_le32(mddev->bitmap_info.daemon_sleep)=
;
> +
> +       kunmap_local(sb);
> +       llbitmap_write_sb(llbitmap);
> +}
> +
> +static int llbitmap_get_stats(void *data, struct md_bitmap_stats *stats)
> +{
> +       struct llbitmap *llbitmap =3D data;
> +
> +       memset(stats, 0, sizeof(*stats));
> +
> +       stats->missing_pages =3D 0;
> +       stats->pages =3D llbitmap->nr_pages;
> +       stats->file_pages =3D llbitmap->nr_pages;
> +
> +       stats->behind_writes =3D atomic_read(&llbitmap->behind_writes);
> +       stats->behind_wait =3D wq_has_sleeper(&llbitmap->behind_wait);
> +       stats->events_cleared =3D llbitmap->events_cleared;
> +
> +       return 0;
> +}
> +
> +/* just flag all pages as needing to be written */
> +static void llbitmap_write_all(struct mddev *mddev)
> +{
> +       int i;
> +       struct llbitmap *llbitmap =3D mddev->bitmap;
> +
> +       for (i =3D 0; i < llbitmap->nr_pages; i++) {
> +               struct llbitmap_page_ctl *pctl =3D llbitmap->pctl[i];
> +
> +               set_bit(LLPageDirty, &pctl->flags);
> +               bitmap_fill(pctl->dirty, llbitmap->blocks_per_page);
> +       }
> +}
> +
> +static void llbitmap_start_behind_write(struct mddev *mddev)
> +{
> +       struct llbitmap *llbitmap =3D mddev->bitmap;
> +
> +       atomic_inc(&llbitmap->behind_writes);
> +}
> +
> +static void llbitmap_end_behind_write(struct mddev *mddev)
> +{
> +       struct llbitmap *llbitmap =3D mddev->bitmap;
> +
> +       if (atomic_dec_and_test(&llbitmap->behind_writes))
> +               wake_up(&llbitmap->behind_wait);
> +}
> +
> +static void llbitmap_wait_behind_writes(struct mddev *mddev)
> +{
> +       struct llbitmap *llbitmap =3D mddev->bitmap;
> +
> +       if (!llbitmap)
> +               return;
> +
> +       wait_event(llbitmap->behind_wait,
> +                  atomic_read(&llbitmap->behind_writes) =3D=3D 0);
> +
> +}
> +
> +static ssize_t bits_show(struct mddev *mddev, char *page)
> +{
> +       struct llbitmap *llbitmap;
> +       int bits[BitStateCount] =3D {0};
> +       loff_t start =3D 0;
> +
> +       mutex_lock(&mddev->bitmap_info.mutex);
> +       llbitmap =3D mddev->bitmap;
> +       if (!llbitmap || !llbitmap->pctl) {
> +               mutex_unlock(&mddev->bitmap_info.mutex);
> +               return sprintf(page, "no bitmap\n");
> +       }
> +
> +       if (test_bit(BITMAP_WRITE_ERROR, &llbitmap->flags)) {
> +               mutex_unlock(&mddev->bitmap_info.mutex);
> +               return sprintf(page, "bitmap io error\n");
> +       }
> +
> +       while (start < llbitmap->chunks) {
> +               enum llbitmap_state c =3D llbitmap_read(llbitmap, start);
> +
> +               if (c < 0 || c >=3D BitStateCount)
> +                       pr_err("%s: invalid bit %llu state %d\n",
> +                              __func__, start, c);
> +               else
> +                       bits[c]++;
> +               start++;
> +       }
> +
> +       mutex_unlock(&mddev->bitmap_info.mutex);
> +       return sprintf(page, "unwritten %d\nclean %d\ndirty %d\nneed sync=
 %d\nsyncing %d\n",
> +                      bits[BitUnwritten], bits[BitClean], bits[BitDirty]=
,
> +                      bits[BitNeedSync], bits[BitSyncing]);
> +}
> +
> +static struct md_sysfs_entry llbitmap_bits =3D
> +__ATTR_RO(bits);
> +
> +static ssize_t metadata_show(struct mddev *mddev, char *page)
> +{
> +       struct llbitmap *llbitmap;
> +       ssize_t ret;
> +
> +       mutex_lock(&mddev->bitmap_info.mutex);
> +       llbitmap =3D mddev->bitmap;
> +       if (!llbitmap) {
> +               mutex_unlock(&mddev->bitmap_info.mutex);
> +               return sprintf(page, "no bitmap\n");
> +       }
> +
> +       ret =3D  sprintf(page, "chunksize %lu\nchunkshift %lu\nchunks %lu=
\noffset %llu\ndaemon_sleep %lu\n",
> +                      llbitmap->chunksize, llbitmap->chunkshift,
> +                      llbitmap->chunks, mddev->bitmap_info.offset,
> +                      llbitmap->mddev->bitmap_info.daemon_sleep);
> +       mutex_unlock(&mddev->bitmap_info.mutex);
> +
> +       return ret;
> +}
> +
> +static struct md_sysfs_entry llbitmap_metadata =3D
> +__ATTR_RO(metadata);
> +
> +static ssize_t
> +daemon_sleep_show(struct mddev *mddev, char *page)
> +{
> +       return sprintf(page, "%lu\n", mddev->bitmap_info.daemon_sleep);
> +}
> +
> +static ssize_t
> +daemon_sleep_store(struct mddev *mddev, const char *buf, size_t len)
> +{
> +       unsigned long timeout;
> +       int rv =3D kstrtoul(buf, 10, &timeout);
> +
> +       if (rv)
> +               return rv;
> +
> +       mddev->bitmap_info.daemon_sleep =3D timeout;
> +       return len;
> +}
> +
> +static struct md_sysfs_entry llbitmap_daemon_sleep =3D
> +__ATTR_RW(daemon_sleep);
> +
> +static ssize_t
> +barrier_idle_show(struct mddev *mddev, char *page)
> +{
> +       struct llbitmap *llbitmap =3D mddev->bitmap;
> +
> +       return sprintf(page, "%lu\n", llbitmap->barrier_idle);
> +}
> +
> +static ssize_t
> +barrier_idle_store(struct mddev *mddev, const char *buf, size_t len)
> +{
> +       struct llbitmap *llbitmap =3D mddev->bitmap;
> +       unsigned long timeout;
> +       int rv =3D kstrtoul(buf, 10, &timeout);
> +
> +       if (rv)
> +               return rv;
> +
> +       llbitmap->barrier_idle =3D timeout;
> +       return len;
> +}
> +
> +static struct md_sysfs_entry llbitmap_barrier_idle =3D
> +__ATTR_RW(barrier_idle);
> +
> +static struct attribute *md_llbitmap_attrs[] =3D {
> +       &llbitmap_bits.attr,
> +       &llbitmap_metadata.attr,
> +       &llbitmap_daemon_sleep.attr,
> +       &llbitmap_barrier_idle.attr,
> +       NULL
> +};
> +
> +static struct attribute_group md_llbitmap_group =3D {
> +       .name =3D "llbitmap",
> +       .attrs =3D md_llbitmap_attrs,
> +};
> +
> +static struct bitmap_operations llbitmap_ops =3D {
> +       .head =3D {
> +               .type   =3D MD_BITMAP,
> +               .id     =3D ID_LLBITMAP,
> +               .name   =3D "llbitmap",
> +       },
> +
> +       .enabled                =3D llbitmap_enabled,
> +       .create                 =3D llbitmap_create,
> +       .resize                 =3D llbitmap_resize,
> +       .load                   =3D llbitmap_load,
> +       .destroy                =3D llbitmap_destroy,
> +
> +       .start_write            =3D llbitmap_start_write,
> +       .end_write              =3D llbitmap_end_write,
> +       .start_discard          =3D llbitmap_start_discard,
> +       .end_discard            =3D llbitmap_end_discard,
> +       .unplug                 =3D llbitmap_unplug,
> +       .flush                  =3D llbitmap_flush,
> +
> +       .start_behind_write     =3D llbitmap_start_behind_write,
> +       .end_behind_write       =3D llbitmap_end_behind_write,
> +       .wait_behind_writes     =3D llbitmap_wait_behind_writes,
> +
> +       .blocks_synced          =3D llbitmap_blocks_synced,
> +       .skip_sync_blocks       =3D llbitmap_skip_sync_blocks,
> +       .start_sync             =3D llbitmap_start_sync,
> +       .end_sync               =3D llbitmap_end_sync,
> +       .close_sync             =3D llbitmap_close_sync,
> +       .cond_end_sync          =3D llbitmap_cond_end_sync,
> +
> +       .update_sb              =3D llbitmap_update_sb,
> +       .get_stats              =3D llbitmap_get_stats,
> +       .dirty_bits             =3D llbitmap_dirty_bits,
> +       .write_all              =3D llbitmap_write_all,
> +
> +       .group                  =3D &md_llbitmap_group,
> +};
> +
> +int md_llbitmap_init(void)
> +{
> +       md_llbitmap_io_wq =3D alloc_workqueue("md_llbitmap_io",
> +                                        WQ_MEM_RECLAIM | WQ_UNBOUND, 0);
> +       if (!md_llbitmap_io_wq)
> +               return -ENOMEM;
> +
> +       md_llbitmap_unplug_wq =3D alloc_workqueue("md_llbitmap_unplug",
> +                                        WQ_MEM_RECLAIM | WQ_UNBOUND, 0);
> +       if (!md_llbitmap_unplug_wq) {
> +               destroy_workqueue(md_llbitmap_io_wq);
> +               md_llbitmap_io_wq =3D NULL;
> +               return -ENOMEM;
> +       }
> +
> +       return register_md_submodule(&llbitmap_ops.head);
> +}
> +
> +void md_llbitmap_exit(void)
> +{
> +       destroy_workqueue(md_llbitmap_io_wq);
> +       md_llbitmap_io_wq =3D NULL;
> +       destroy_workqueue(md_llbitmap_unplug_wq);
> +       md_llbitmap_unplug_wq =3D NULL;
> +       unregister_md_submodule(&llbitmap_ops.head);
> +}
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 90b8f9a70152..688ba1a58e55 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -10228,6 +10228,10 @@ static int __init md_init(void)
>         if (ret)
>                 return ret;
>
> +       ret =3D md_llbitmap_init();
> +       if (ret)
> +               goto err_bitmap;
> +
>         ret =3D -ENOMEM;
>         md_wq =3D alloc_workqueue("md", WQ_MEM_RECLAIM, 0);
>         if (!md_wq)
> @@ -10259,6 +10263,8 @@ static int __init md_init(void)
>  err_misc_wq:
>         destroy_workqueue(md_wq);
>  err_wq:
> +       md_llbitmap_exit();
> +err_bitmap:
>         md_bitmap_exit();
>         return ret;
>  }
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 7b6357879a84..1979c2d4fe89 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -26,7 +26,7 @@
>  enum md_submodule_type {
>         MD_PERSONALITY =3D 0,
>         MD_CLUSTER,
> -       MD_BITMAP, /* TODO */
> +       MD_BITMAP,
>  };
>
>  enum md_submodule_id {
> @@ -39,7 +39,7 @@ enum md_submodule_id {
>         ID_RAID10       =3D 10,
>         ID_CLUSTER,
>         ID_BITMAP,
> -       ID_LLBITMAP,    /* TODO */
> +       ID_LLBITMAP,
>         ID_BITMAP_NONE,
>  };
>
> --
> 2.39.2
>

