Return-Path: <SRS0=MhoS=E6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34051C2D0E4
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 13:32:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 90758204EC
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 13:32:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 90758204EC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-6HPdTU5tPkemnHK2BnWnlg-1; Tue, 24 Nov 2020 08:32:25 -0500
X-MC-Unique: 6HPdTU5tPkemnHK2BnWnlg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D07F2835B48;
	Tue, 24 Nov 2020 13:32:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B223E63BA7;
	Tue, 24 Nov 2020 13:32:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 811FF50032;
	Tue, 24 Nov 2020 13:32:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AODWGSA018766 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 24 Nov 2020 08:32:16 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 412222166B27; Tue, 24 Nov 2020 13:32:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3A3832166B2B
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 13:32:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AE86C108C1CC
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 13:32:11 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-573-h3irwj2qN3CWjfpGAzuBxw-1; Tue, 24 Nov 2020 08:32:09 -0500
X-MC-Unique: h3irwj2qN3CWjfpGAzuBxw-1
Received: from [2001:4bb8:180:5443:c70:4a89:bc61:3] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1khYML-0006U2-TO; Tue, 24 Nov 2020 13:27:54 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Tue, 24 Nov 2020 14:27:06 +0100
Message-Id: <20201124132751.3747337-1-hch@lst.de>
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
Cc: linux-bcache@vger.kernel.org, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	Richard Weinberger <richard@nod.at>, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Tejun Heo <tj@kernel.org>, xen-devel@lists.xenproject.org,
	linux-mm@kvack.org
Subject: [dm-devel] merge struct block_device and struct hd_struct v2
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

Note that this now includes the previous "misc cleanups" series as I had
to fix up a thing in there with the changed patch ordering.

The first patch already is in 5.10-rc, but not in for-5.11/block

A git tree is available here:

    git://git.infradead.org/users/hch/block.git bdev-lookup

Gitweb:

    http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/bdev-lookup

Changes since v1:
 - spelling fixes
 - fix error unwinding in __alloc_disk_node
 - use bdev_is_partition in a few more places
 - don't send the RESIZE=1 uevent for hidden gendisks
 - rename __bdget_disk to disk_find_part
 - drop a bcache patch
 - some patch reordering
 - add more refactoring
 - use rcu protection to prevent racing with a disk going away
   in blkdev_get
 - split up some of the big patches into many small ones
 - clean up the freeze_bdev interface

Diffstat:
 block/bio.c                                  |    6 
 block/blk-cgroup.c                           |   50 -
 block/blk-core.c                             |   68 +-
 block/blk-flush.c                            |    2 
 block/blk-iocost.c                           |   36 -
 block/blk-lib.c                              |    2 
 block/blk-merge.c                            |    2 
 block/blk-mq.c                               |    9 
 block/blk-mq.h                               |    7 
 block/blk.h                                  |   84 ---
 block/genhd.c                                |  467 ++++-------------
 block/ioctl.c                                |   14 
 block/partitions/core.c                      |  252 +++------
 drivers/block/drbd/drbd_receiver.c           |    2 
 drivers/block/drbd/drbd_worker.c             |    3 
 drivers/block/loop.c                         |   24 
 drivers/block/mtip32xx/mtip32xx.c            |   15 
 drivers/block/mtip32xx/mtip32xx.h            |    2 
 drivers/block/nbd.c                          |    6 
 drivers/block/xen-blkback/common.h           |    4 
 drivers/block/xen-blkfront.c                 |   20 
 drivers/block/zram/zram_drv.c                |   87 ---
 drivers/block/zram/zram_drv.h                |    1 
 drivers/md/bcache/request.c                  |    4 
 drivers/md/bcache/super.c                    |   29 -
 drivers/md/dm-core.h                         |    7 
 drivers/md/dm-table.c                        |    9 
 drivers/md/dm.c                              |   45 -
 drivers/md/md.c                              |    8 
 drivers/mtd/mtdsuper.c                       |   17 
 drivers/nvme/target/admin-cmd.c              |   20 
 drivers/s390/block/dasd.c                    |    8 
 drivers/s390/block/dasd_ioctl.c              |    9 
 drivers/scsi/scsicam.c                       |    2 
 drivers/target/target_core_file.c            |    6 
 drivers/target/target_core_pscsi.c           |    7 
 drivers/usb/gadget/function/storage_common.c |    8 
 fs/block_dev.c                               |  730 +++++++++------------------
 fs/btrfs/sysfs.c                             |   15 
 fs/btrfs/volumes.c                           |   13 
 fs/buffer.c                                  |    2 
 fs/ext4/ioctl.c                              |    2 
 fs/ext4/super.c                              |   18 
 fs/ext4/sysfs.c                              |   10 
 fs/f2fs/checkpoint.c                         |    5 
 fs/f2fs/f2fs.h                               |    2 
 fs/f2fs/file.c                               |   14 
 fs/f2fs/super.c                              |    8 
 fs/f2fs/sysfs.c                              |    9 
 fs/inode.c                                   |    3 
 fs/internal.h                                |    7 
 fs/io_uring.c                                |   10 
 fs/pipe.c                                    |    5 
 fs/pstore/blk.c                              |    2 
 fs/quota/quota.c                             |   40 +
 fs/statfs.c                                  |    2 
 fs/super.c                                   |   86 ---
 fs/xfs/xfs_fsops.c                           |    7 
 include/linux/blk-cgroup.h                   |    4 
 include/linux/blk_types.h                    |   24 
 include/linux/blkdev.h                       |   27 
 include/linux/fs.h                           |    5 
 include/linux/genhd.h                        |  110 ----
 include/linux/part_stat.h                    |   45 -
 init/do_mounts.c                             |  271 ++++------
 kernel/trace/blktrace.c                      |   54 -
 mm/filemap.c                                 |   13 
 67 files changed, 957 insertions(+), 1928 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

