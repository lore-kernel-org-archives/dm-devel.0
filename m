Return-Path: <SRS0=ctUg=NF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63316C4338F
	for <dm-devel@archiver.kernel.org>; Sat, 14 Aug 2021 21:17:52 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E645E60D07
	for <dm-devel@archiver.kernel.org>; Sat, 14 Aug 2021 21:17:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E645E60D07
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-456-fZ1Cr54gPxSdf5OpaPCi8Q-1; Sat, 14 Aug 2021 17:17:47 -0400
X-MC-Unique: fZ1Cr54gPxSdf5OpaPCi8Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C1D2801AC0;
	Sat, 14 Aug 2021 21:17:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 23ED46A8FC;
	Sat, 14 Aug 2021 21:17:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7567F1819AC9;
	Sat, 14 Aug 2021 21:17:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17ELDK19001541 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 14 Aug 2021 17:13:21 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D9E752023274; Sat, 14 Aug 2021 21:13:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D53792023273
	for <dm-devel@redhat.com>; Sat, 14 Aug 2021 21:13:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D40E185A79C
	for <dm-devel@redhat.com>; Sat, 14 Aug 2021 21:13:17 +0000 (UTC)
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com
	[209.85.210.52]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-320--yQSU9Z4OW2JiNl8-BqYyQ-1; Sat, 14 Aug 2021 17:13:13 -0400
X-MC-Unique: -yQSU9Z4OW2JiNl8-BqYyQ-1
Received: by mail-ot1-f52.google.com with SMTP id
	108-20020a9d01750000b029050e5cc11ae3so16361980otu.5; 
	Sat, 14 Aug 2021 14:13:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=chqNyYr5sx+CKUTzwwmJS9/KkSEMwSOW2RsvrLIKseQ=;
	b=PZFymih0We+ELyV4PpcGRtqYLqBJXs9OoZgJn/lgvcyHERgg/VROD6Xw33NTUSrgAh
	lNlTXoJ1H3lflFsIMdSvhOV2HOd3M2dxIXNOXNEKXDgd5x79qBiCOkWOnfRymEzotgzl
	eBouq6RfLCIsaIG9Rup8rd9xZShtgJFiLLBNpQKzCeUKYJ/DEONEAM052F85OjVAQF/h
	WuveTjXwIF9pFcKSza8s4AjxbxNYPFYLKylYh8MrxEPv8NfpyYdtPpKFvUhNvyAhV+Xn
	ou/tA4ctW6ybWeAEBfbkWL0ZBCj0WnhUMLJrp/ab37ZUTuqjbiE9uoNzWOcXJp58KfXk
	Txvg==
X-Gm-Message-State: AOAM531hImJrxqL4HcUo7UnK9mk0nO5CSz0EU9RTnM7fJwcY7AV+ntf9
	YkkKCQ8AXNw1IWf+y2O1W5Y=
X-Google-Smtp-Source: ABdhPJxeXqgzkXKKwKjcmH6xtt4QhpICs0OkzRmM/3FPg7z98ftFhTHBiQnJxd3se1LIO/a7fDVakg==
X-Received: by 2002:a05:6830:20cf:: with SMTP id
	z15mr2725990otq.7.1628975592096; 
	Sat, 14 Aug 2021 14:13:12 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
	by smtp.gmail.com with ESMTPSA id
	31sm1214870oti.63.2021.08.14.14.13.10
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Sat, 14 Aug 2021 14:13:11 -0700 (PDT)
Date: Sat, 14 Aug 2021 14:13:09 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20210814211309.GA616511@roeck-us.net>
References: <20210804094147.459763-1-hch@lst.de>
	<20210804094147.459763-5-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20210804094147.459763-5-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] [PATCH 4/8] block: support delayed holder
	registration
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Aug 04, 2021 at 11:41:43AM +0200, Christoph Hellwig wrote:
> device mapper needs to register holders before it is ready to do I/O.
> Currently it does so by registering the disk early, which can leave
> the disk and queue in a weird half state where the queue is registered
> with the disk, except for sysfs and the elevator.  And this state has
> been a bit promlematic before, and will get more so when sorting out
> the responsibilities between the queue and the disk.
> 
> Support registering holders on an initialized but not registered disk
> instead by delaying the sysfs registration until the disk is registered.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Mike Snitzer <snitzer@redhat.com>

This patch results in lockdep splats when booting from flash.
Reverting it fixes the proboem.

Guenter

---
bisect log:

# bad: [4b358aabb93a2c654cd1dcab1a25a589f6e2b153] Add linux-next specific files for 20210813
# good: [36a21d51725af2ce0700c6ebcb6b9594aac658a6] Linux 5.14-rc5
git bisect start 'HEAD' 'v5.14-rc5'
# good: [204808b2ca750e27cbad3455f7cb4368c4f5b260] Merge remote-tracking branch 'crypto/master'
git bisect good 204808b2ca750e27cbad3455f7cb4368c4f5b260
# bad: [2201162fca73b487152bcff2ebb0f85c1dde8479] Merge remote-tracking branch 'tip/auto-latest'
git bisect bad 2201162fca73b487152bcff2ebb0f85c1dde8479
# good: [a22c074fd1dd52a8b41dd6789220409b64093e9c] Merge tag 'drm-intel-next-2021-08-10-1' of git://anongit.freedesktop.org/drm/drm-intel into drm-next
git bisect good a22c074fd1dd52a8b41dd6789220409b64093e9c
# bad: [33a201f05bbd7475ebe10af22b986ab70550dc8f] Merge remote-tracking branch 'block/for-next'
git bisect bad 33a201f05bbd7475ebe10af22b986ab70550dc8f
# good: [6849b6a4f2d8a7ce7c9434ed6f1e286443cf5fd3] Merge remote-tracking branch 'sound/for-next'
git bisect good 6849b6a4f2d8a7ce7c9434ed6f1e286443cf5fd3
# good: [77fb0208ae88b36e46d99441c8369412dbaacc0d] Merge remote-tracking branch 'sound-asoc/for-next'
git bisect good 77fb0208ae88b36e46d99441c8369412dbaacc0d
# bad: [3d2e79894bd7adc7d14638a0c72ceb8b722d1fa3] block: pass a gendisk to bdev_resize_partition
git bisect bad 3d2e79894bd7adc7d14638a0c72ceb8b722d1fa3
# good: [7957d93bf32bc211415827e44fdd9cdf1388df59] block: add ioctl to read the disk sequence number
git bisect good 7957d93bf32bc211415827e44fdd9cdf1388df59
# bad: [1008162b2782a3624d12b0aee8da58bc75d12e19] block: add a queue_has_disk helper
git bisect bad 1008162b2782a3624d12b0aee8da58bc75d12e19
# good: [fbd9a39542ecdd2ade55869c13856b2590db3df8] block: remove the extra kobject reference in bd_link_disk_holder
git bisect good fbd9a39542ecdd2ade55869c13856b2590db3df8
# bad: [ba30585936b0b88f0fb2b19be279b346a6cc87eb] dm: move setting md->type into dm_setup_md_queue
git bisect bad ba30585936b0b88f0fb2b19be279b346a6cc87eb
# bad: [d626338735909bc2b2e7cafc332f44ed41cfdeee] block: support delayed holder registration
git bisect bad d626338735909bc2b2e7cafc332f44ed41cfdeee
# good: [0dbcfe247f22a6d73302dfa691c48b3c14d31c4c] block: look up holders by bdev
git bisect good 0dbcfe247f22a6d73302dfa691c48b3c14d31c4c
# first bad commit: [d626338735909bc2b2e7cafc332f44ed41cfdeee] block: support delayed holder registration

---

lockdep splat on mips:

======================================================
WARNING: possible circular locking dependency detected
5.14.0-rc5-next-20210813 #1 Not tainted
------------------------------------------------------
swapper/0/1 is trying to acquire lock:
81066ab8 (mtd_table_mutex){+.+.}-{3:3}, at: blktrans_open+0x4c/0x214

but task is already holding lock:
82675ea8 (&disk->open_mutex){+.+.}-{3:3}, at: blkdev_get_by_dev+0x17c/0x454

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&disk->open_mutex){+.+.}-{3:3}:
       lock_acquire+0x2b0/0x49c
       __mutex_lock+0xb8/0x760
       mutex_lock_nested+0x1c/0x28
       bd_register_pending_holders+0x34/0x140
       device_add_disk+0x214/0x55c
       add_mtd_blktrans_dev+0x318/0x58c
       mtdblock_add_mtd+0x94/0xf4
       blktrans_notify_add+0x44/0x6c
       add_mtd_device+0x35c/0x5ec
       add_mtd_partitions+0xc4/0x22c
       parse_mtd_partitions+0x1d8/0x3d8
       mtd_device_parse_register+0x94/0x330
       physmap_flash_probe+0x438/0x7a8
       platform_probe+0x50/0xc4
       really_probe+0x140/0x30c
       driver_probe_device+0x48/0x110
       __driver_attach+0xe8/0x13c
       bus_for_each_dev+0x70/0xd0
       bus_add_driver+0x174/0x234
       driver_register+0x80/0x144
       do_one_initcall+0x94/0x3c4
       kernel_init_freeable+0x20c/0x2a0
       kernel_init+0x24/0x128
       ret_from_kernel_thread+0x14/0x1c

-> #0 (mtd_table_mutex){+.+.}-{3:3}:
       check_noncircular+0x1b4/0x21c
       __lock_acquire+0x1ebc/0x3b70
       lock_acquire+0x2b0/0x49c
       __mutex_lock+0xb8/0x760
       mutex_lock_nested+0x1c/0x28
       blktrans_open+0x4c/0x214
       blkdev_get_whole+0x2c/0xd4
       blkdev_get_by_dev+0x140/0x454
       blkdev_get_by_path+0x6c/0xbc
       mount_bdev+0x50/0x1fc
       ext4_mount+0x18/0x24
       legacy_get_tree+0x30/0x78
       vfs_get_tree+0x2c/0x104
       path_mount+0x44c/0xa1c
       init_mount+0x70/0xb4
       do_mount_root+0xac/0x164
       mount_block_root+0x174/0x2a8
       mount_root+0x120/0x15c
       prepare_namespace+0x15c/0x19c
       kernel_init+0x24/0x128
       ret_from_kernel_thread+0x14/0x1c

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&disk->open_mutex);
                               lock(mtd_table_mutex);
                               lock(&disk->open_mutex);
  lock(mtd_table_mutex);

 *** DEADLOCK ***

1 lock held by swapper/0/1:
 #0: 82675ea8 (&disk->open_mutex){+.+.}-{3:3}, at: blkdev_get_by_dev+0x17c/0x454

stack backtrace:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.14.0-rc5-next-20210813 #1
Stack : ffffffff 801b5414 80cfba14 00000004 801b5374 00000000 820cb90c a16af2b0
        80fe0000 81119930 80ef8fe0 80fe0000 80fddc23 00000001 820cb8b0 82100ec0
        00000000 00000000 80ef8fe0 820cb730 00000001 820cb744 00000000 0000ffff
        00000008 00000007 00000280 82318800 80fe0000 00000000 80ef8fe0 80fe0000
        00000000 80fdad68 820c6fd8 820c6fb8 00000000 807b0f60 00000000 81120000
        ...
Call Trace:
[<8010ad9c>] show_stack+0x84/0x11c
[<80c79334>] dump_stack_lvl+0xa8/0x100
[<801a3978>] check_noncircular+0x1b4/0x21c
[<801a8184>] __lock_acquire+0x1ebc/0x3b70
[<801a58c0>] lock_acquire+0x2b0/0x49c
[<80c85068>] __mutex_lock+0xb8/0x760
[<80c8572c>] mutex_lock_nested+0x1c/0x28
[<8087bf68>] blktrans_open+0x4c/0x214
[<8033ddfc>] blkdev_get_whole+0x2c/0xd4
[<8033f2c0>] blkdev_get_by_dev+0x140/0x454
[<8033f954>] blkdev_get_by_path+0x6c/0xbc
[<802e3f10>] mount_bdev+0x50/0x1fc
[<80423c04>] ext4_mount+0x18/0x24
[<8032ef70>] legacy_get_tree+0x30/0x78
[<802e3034>] vfs_get_tree+0x2c/0x104
[<803149ec>] path_mount+0x44c/0xa1c
[<810aec68>] init_mount+0x70/0xb4
[<8109948c>] do_mount_root+0xac/0x164
[<81099714>] mount_block_root+0x174/0x2a8
[<81099968>] mount_root+0x120/0x15c
[<81099b00>] prepare_namespace+0x15c/0x19c
[<80c810c0>] kernel_init+0x24/0x128
[<801038f8>] ret_from_kernel_thread+0x14/0x1c

---
lockdep splat on powerpc:

[   14.502119][    T1] ======================================================
[   14.502379][    T1] WARNING: possible circular locking dependency detected
[   14.502668][    T1] 5.14.0-rc5-next-20210813 #1 Not tainted
[   14.502933][    T1] ------------------------------------------------------
[   14.503185][    T1] swapper/0/1 is trying to acquire lock:
[   14.503419][    T1] c0000000018bbb90 (mtd_table_mutex){+.+.}-{3:3}, at: blktrans_open+0x60/0x300
[   14.503992][    T1]
[   14.503992][    T1] but task is already holding lock:
[   14.504273][    T1] c0000000058a8718 (&disk->open_mutex){+.+.}-{3:3}, at: blkdev_get_by_dev+0x20c/0x3c0
[   14.504643][    T1]
[   14.504643][    T1] which lock already depends on the new lock.
[   14.504643][    T1]
[   14.505012][    T1]
[   14.505012][    T1] the existing dependency chain (in reverse order) is:
[   14.505377][    T1]
[   14.505377][    T1] -> #1 (&disk->open_mutex){+.+.}-{3:3}:
[   14.505724][    T1]        __mutex_lock+0xd8/0xad0
[   14.505945][    T1]        bd_register_pending_holders+0x48/0x190
[   14.506191][    T1]        device_add_disk+0x29c/0x400
[   14.506390][    T1]        add_mtd_blktrans_dev+0x358/0x630
[   14.506600][    T1]        mtdblock_add_mtd+0x94/0x120
[   14.506802][    T1]        blktrans_notify_add+0x7c/0xb0
[   14.507004][    T1]        add_mtd_device+0x408/0x5f0
[   14.507197][    T1]        add_mtd_partitions+0xfc/0x2b0
[   14.507400][    T1]        parse_mtd_partitions+0x2b4/0x980
[   14.507611][    T1]        mtd_device_parse_register+0xc0/0x3a0
[   14.507843][    T1]        powernv_flash_probe+0x180/0x240
[   14.508051][    T1]        platform_probe+0x78/0x120
[   14.508246][    T1]        really_probe+0x1cc/0x440
[   14.508435][    T1]        __driver_probe_device+0xb0/0x160
[   14.508645][    T1]        driver_probe_device+0x60/0x130
[   14.508848][    T1]        __driver_attach+0xe8/0x160
[   14.509041][    T1]        bus_for_each_dev+0xb4/0x130
[   14.509234][    T1]        driver_attach+0x34/0x50
[   14.509426][    T1]        bus_add_driver+0x1d8/0x2b0
[   14.509621][    T1]        driver_register+0x98/0x1a0
[   14.509820][    T1]        __platform_driver_register+0x38/0x50
[   14.510048][    T1]        powernv_flash_driver_init+0x2c/0x40
[   14.510276][    T1]        do_one_initcall+0x88/0x490
[   14.510471][    T1]        kernel_init_freeable+0x3dc/0x484
[   14.510688][    T1]        kernel_init+0x3c/0x180
[   14.510871][    T1]        ret_from_kernel_thread+0x5c/0x64
[   14.511120][    T1]
[   14.511120][    T1] -> #0 (mtd_table_mutex){+.+.}-{3:3}:
[   14.511419][    T1]        __lock_acquire+0x1eb0/0x2a40
[   14.511622][    T1]        lock_acquire+0x2d8/0x490
[   14.511815][    T1]        __mutex_lock+0xd8/0xad0
[   14.512001][    T1]        blktrans_open+0x60/0x300
[   14.512189][    T1]        blkdev_get_whole+0x50/0x110
[   14.512387][    T1]        blkdev_get_by_dev+0x1dc/0x3c0
[   14.512588][    T1]        blkdev_get_by_path+0x90/0xe0
[   14.512787][    T1]        mount_bdev+0x6c/0x2b0
[   14.512972][    T1]        ext4_mount+0x28/0x40
[   14.513154][    T1]        legacy_get_tree+0x4c/0xb0
[   14.513358][    T1]        vfs_get_tree+0x4c/0x110
[   14.513545][    T1]        path_mount+0x2d8/0xd30
[   14.513730][    T1]        init_mount+0x7c/0xcc
[   14.513911][    T1]        mount_block_root+0x230/0x454
[   14.514111][    T1]        prepare_namespace+0x1b0/0x204
[   14.514313][    T1]        kernel_init_freeable+0x428/0x484
[   14.514524][    T1]        kernel_init+0x3c/0x180
[   14.514713][    T1]        ret_from_kernel_thread+0x5c/0x64
[   14.514944][    T1]
[   14.514944][    T1] other info that might help us debug this:
[   14.514944][    T1]
[   14.515330][    T1]  Possible unsafe locking scenario:
[   14.515330][    T1]
[   14.515607][    T1]        CPU0                    CPU1
[   14.515808][    T1]        ----                    ----
[   14.516007][    T1]   lock(&disk->open_mutex);
[   14.516196][    T1]                                lock(mtd_table_mutex);
[   14.516463][    T1]                                lock(&disk->open_mutex);
[   14.516739][    T1]   lock(mtd_table_mutex);
[   14.516926][    T1]
[   14.516926][    T1]  *** DEADLOCK ***
[   14.516926][    T1]
[   14.517242][    T1] 1 lock held by swapper/0/1:
[   14.517455][    T1]  #0: c0000000058a8718 (&disk->open_mutex){+.+.}-{3:3}, at: blkdev_get_by_dev+0x20c/0x3c0
[   14.517875][    T1]
[   14.517875][    T1] stack backtrace:
[   14.518197][    T1] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.14.0-rc5-next-20210813 #1
[   14.518684][    T1] Call Trace:
[   14.518852][    T1] [c000000002c872c0] [c00000000090eb28] dump_stack_lvl+0xac/0x108 (unreliable)
[   14.519242][    T1] [c000000002c87300] [c0000000001a9dac] print_circular_bug.isra.44+0x37c/0x3e0
[   14.519588][    T1] [c000000002c873a0] [c0000000001a9fe0] check_noncircular+0x1d0/0x220
[   14.519887][    T1] [c000000002c87470] [c0000000001affd0] __lock_acquire+0x1eb0/0x2a40
[   14.520182][    T1] [c000000002c875b0] [c0000000001ad028] lock_acquire+0x2d8/0x490
[   14.520469][    T1] [c000000002c876a0] [c0000000010ab098] __mutex_lock+0xd8/0xad0
[   14.520756][    T1] [c000000002c877b0] [c000000000bac480] blktrans_open+0x60/0x300
[   14.521045][    T1] [c000000002c87800] [c0000000005406d0] blkdev_get_whole+0x50/0x110
[   14.521346][    T1] [c000000002c87840] [c000000000542efc] blkdev_get_by_dev+0x1dc/0x3c0
[   14.521650][    T1] [c000000002c878a0] [c0000000005434f0] blkdev_get_by_path+0x90/0xe0
[   14.521948][    T1] [c000000002c878f0] [c0000000004d1dec] mount_bdev+0x6c/0x2b0
[   14.522221][    T1] [c000000002c87990] [c000000000649af8] ext4_mount+0x28/0x40
[   14.522503][    T1] [c000000002c879b0] [c000000000531d5c] legacy_get_tree+0x4c/0xb0
[   14.522800][    T1] [c000000002c879e0] [c0000000004cff2c] vfs_get_tree+0x4c/0x110
[   14.523083][    T1] [c000000002c87a50] [c0000000005103a8] path_mount+0x2d8/0xd30
[   14.523365][    T1] [c000000002c87ae0] [c0000000015776c4] init_mount+0x7c/0xcc
[   14.523645][    T1] [c000000002c87b50] [c000000001541bd0] mount_block_root+0x230/0x454
[   14.523943][    T1] [c000000002c87c50] [c000000001542050] prepare_namespace+0x1b0/0x204
[   14.524238][    T1] [c000000002c87cc0] [c00000000154170c] kernel_init_freeable+0x428/0x484
[   14.524545][    T1] [c000000002c87da0] [c000000000012d2c] kernel_init+0x3c/0x180
[   14.524831][    T1] [c000000002c87e10] [c00000000000cfd4] ret_from_kernel_thread+0x5c/0x64


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

