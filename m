Return-Path: <SRS0=/Nun=EY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31DC8C5519F
	for <dm-devel@archiver.kernel.org>; Wed, 18 Nov 2020 08:52:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 63E8520719
	for <dm-devel@archiver.kernel.org>; Wed, 18 Nov 2020 08:52:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 63E8520719
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-125-3qwp40MaPoCz9cFyJAB7EA-1; Wed, 18 Nov 2020 03:51:58 -0500
X-MC-Unique: 3qwp40MaPoCz9cFyJAB7EA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 93CCA8042CF;
	Wed, 18 Nov 2020 08:51:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 49655196FB;
	Wed, 18 Nov 2020 08:51:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4D26058127;
	Wed, 18 Nov 2020 08:51:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AI8pj1p019032 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 18 Nov 2020 03:51:47 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 143B72166BCC; Wed, 18 Nov 2020 08:51:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F23D2166BA2
	for <dm-devel@redhat.com>; Wed, 18 Nov 2020 08:51:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E47C4858298
	for <dm-devel@redhat.com>; Wed, 18 Nov 2020 08:51:42 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-20-h1vW4aiAMIS60e3Ohj3CSw-1; Wed, 18 Nov 2020 03:51:39 -0500
X-MC-Unique: h1vW4aiAMIS60e3Ohj3CSw-1
Received: from [2001:4bb8:18c:31ba:32b1:ec66:5459:36a] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1kfJ8E-0007kG-NB; Wed, 18 Nov 2020 08:48:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed, 18 Nov 2020 09:47:40 +0100
Message-Id: <20201118084800.2339180-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	casper.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: linux-bcache@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Richard Weinberger <richard@nod.at>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com, linux-mtd@lists.infradead.org,
	Jan Kara <jack@suse.com>, Tejun Heo <tj@kernel.org>,
	xen-devel@lists.xenproject.org, linux-mm@kvack.org
Subject: [dm-devel] merge struct block_device and struct hd_struct
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Jens,

this series cleans up our main per-device node data structure by merging
the block_device and hd_struct data structures that have the same scope,
but different life times.  The main effect (besides removing lots of
code) is that instead of having two device sizes that need complex
synchronization there is just one now.

Note that it depends on the previous "misc cleanups" series.

A git tree is available here:

    git://git.infradead.org/users/hch/block.git bdev-lookup

Gitweb:

    http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/bdev-lookup

Diffstat:
 block/bio.c                                  |    6 
 block/blk-cgroup.c                           |   50 +-
 block/blk-core.c                             |   85 +--
 block/blk-flush.c                            |    2 
 block/blk-iocost.c                           |   36 -
 block/blk-lib.c                              |    2 
 block/blk-merge.c                            |    6 
 block/blk-mq.c                               |   11 
 block/blk-mq.h                               |    5 
 block/blk.h                                  |   92 ----
 block/genhd.c                                |  444 +++++---------------
 block/ioctl.c                                |    7 
 block/partitions/core.c                      |  238 +++--------
 drivers/block/drbd/drbd_receiver.c           |    2 
 drivers/block/drbd/drbd_worker.c             |    2 
 drivers/block/loop.c                         |   21 
 drivers/block/nbd.c                          |    6 
 drivers/block/xen-blkback/common.h           |    4 
 drivers/block/xen-blkfront.c                 |   20 
 drivers/block/zram/zram_drv.c                |   20 
 drivers/md/bcache/request.c                  |    4 
 drivers/md/bcache/super.c                    |   53 --
 drivers/md/dm-table.c                        |    9 
 drivers/md/dm.c                              |   16 
 drivers/md/md.c                              |    8 
 drivers/mtd/mtdsuper.c                       |   17 
 drivers/nvme/target/admin-cmd.c              |   20 
 drivers/s390/block/dasd.c                    |    8 
 drivers/s390/block/dasd_ioctl.c              |    9 
 drivers/scsi/scsicam.c                       |    2 
 drivers/target/target_core_file.c            |    6 
 drivers/target/target_core_pscsi.c           |    7 
 drivers/usb/gadget/function/storage_common.c |    8 
 fs/block_dev.c                               |  578 ++++++++-------------------
 fs/btrfs/sysfs.c                             |   15 
 fs/btrfs/volumes.c                           |   13 
 fs/ext4/super.c                              |   18 
 fs/ext4/sysfs.c                              |   10 
 fs/f2fs/checkpoint.c                         |    5 
 fs/f2fs/f2fs.h                               |    2 
 fs/f2fs/super.c                              |    8 
 fs/f2fs/sysfs.c                              |    9 
 fs/inode.c                                   |    3 
 fs/internal.h                                |    7 
 fs/io_uring.c                                |   10 
 fs/pipe.c                                    |    5 
 fs/pstore/blk.c                              |    2 
 fs/quota/quota.c                             |   40 +
 fs/statfs.c                                  |    2 
 fs/super.c                                   |   86 ----
 include/linux/blk-cgroup.h                   |    4 
 include/linux/blk_types.h                    |   26 +
 include/linux/blkdev.h                       |   24 -
 include/linux/fs.h                           |    5 
 include/linux/genhd.h                        |  104 ----
 include/linux/part_stat.h                    |   17 
 init/do_mounts.c                             |  271 +++++-------
 kernel/trace/blktrace.c                      |   54 --
 mm/filemap.c                                 |    9 
 59 files changed, 837 insertions(+), 1716 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

