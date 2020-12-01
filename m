Return-Path: <SRS0=byOr=FF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E138C64E7B
	for <dm-devel@archiver.kernel.org>; Tue,  1 Dec 2020 17:02:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 81E3A2076C
	for <dm-devel@archiver.kernel.org>; Tue,  1 Dec 2020 17:02:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 81E3A2076C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-5BzKWpM5OAOjillbAG70VQ-1; Tue, 01 Dec 2020 12:02:15 -0500
X-MC-Unique: 5BzKWpM5OAOjillbAG70VQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C12318042B3;
	Tue,  1 Dec 2020 17:02:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A2D8260854;
	Tue,  1 Dec 2020 17:02:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 79B265002E;
	Tue,  1 Dec 2020 17:02:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B1H1saP032188 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 1 Dec 2020 12:01:54 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 979962026D13; Tue,  1 Dec 2020 17:01:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 929212026D12
	for <dm-devel@redhat.com>; Tue,  1 Dec 2020 17:01:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E481E85828D
	for <dm-devel@redhat.com>; Tue,  1 Dec 2020 17:01:53 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-418-5esk_hlTMxGj9VR70UBWRw-1; Tue, 01 Dec 2020 12:01:51 -0500
X-MC-Unique: 5esk_hlTMxGj9VR70UBWRw-1
Received: from [2001:4bb8:184:6389:bbd8:a1c2:99e0:f58a] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1kk8v3-0005Yk-J4; Tue, 01 Dec 2020 16:54:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Tue,  1 Dec 2020 17:54:15 +0100
Message-Id: <20201201165424.2030647-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: linux-s390@vger.kernel.org, linux-bcache@vger.kernel.org,
	Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	linux-block@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [dm-devel] store a pointer to the block_device in struct bio (again)
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Jens,

this series switches back from storing the gendisk + partno to storing
a block_device pointer in struct bio.  The reason is two fold:  for one
the new struct block_device actually is always available, removing the
need to avoid originally.  Second the merge struct block_device is much
more useful than the old one, as storing it avoids the need for looking
up what used to be hd_struct during partition remapping and I/O
accounting.

Note that this series depends on the posted but not merged
"block tracepoint cleanups" series.

A git tree is also available:

    git://git.infradead.org/users/hch/block.git bi_bdev

Gitweb:

    http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/bi_bdev

Diffstat:
 arch/m68k/emu/nfblock.c             |    2 
 arch/xtensa/platforms/iss/simdisk.c |    2 
 block/bio-integrity.c               |   18 +-
 block/bio.c                         |   31 +---
 block/blk-cgroup.c                  |    7 
 block/blk-core.c                    |   99 ++++++-------
 block/blk-crypto-fallback.c         |    2 
 block/blk-crypto.c                  |    2 
 block/blk-merge.c                   |   17 +-
 block/blk-mq.c                      |    2 
 block/blk-settings.c                |    2 
 block/blk-throttle.c                |    2 
 block/blk.h                         |    9 -
 block/bounce.c                      |    2 
 block/genhd.c                       |  261 +++---------------------------------
 block/partitions/core.c             |   31 ----
 drivers/block/brd.c                 |    8 -
 drivers/block/drbd/drbd_int.h       |    4 
 drivers/block/drbd/drbd_req.c       |    2 
 drivers/block/null_blk_main.c       |    2 
 drivers/block/pktcdvd.c             |    4 
 drivers/block/ps3vram.c             |    2 
 drivers/block/rsxx/dev.c            |    2 
 drivers/block/umem.c                |    2 
 drivers/block/zram/zram_drv.c       |    2 
 drivers/lightnvm/pblk-init.c        |    2 
 drivers/md/bcache/debug.c           |    2 
 drivers/md/bcache/request.c         |   39 +++--
 drivers/md/dm-bio-record.h          |    9 -
 drivers/md/dm-raid1.c               |   10 -
 drivers/md/dm.c                     |   14 -
 drivers/md/md-linear.c              |    2 
 drivers/md/md.c                     |   10 -
 drivers/md/md.h                     |    6 
 drivers/md/raid1.c                  |    6 
 drivers/md/raid10.c                 |   12 -
 drivers/md/raid5.c                  |    2 
 drivers/nvdimm/blk.c                |    4 
 drivers/nvdimm/btt.c                |    4 
 drivers/nvdimm/pmem.c               |    4 
 drivers/nvme/host/core.c            |    6 
 drivers/nvme/host/lightnvm.c        |    3 
 drivers/nvme/host/multipath.c       |    6 
 drivers/nvme/host/rdma.c            |    2 
 drivers/s390/block/dasd.c           |   26 ---
 drivers/s390/block/dcssblk.c        |    6 
 drivers/s390/block/xpram.c          |    2 
 fs/btrfs/check-integrity.c          |   10 -
 fs/btrfs/raid56.c                   |    7 
 fs/btrfs/scrub.c                    |    2 
 fs/direct-io.c                      |    2 
 fs/f2fs/data.c                      |   12 -
 include/linux/bio.h                 |   18 +-
 include/linux/blk_types.h           |    3 
 include/linux/blkdev.h              |   20 --
 include/linux/genhd.h               |   21 --
 kernel/trace/blktrace.c             |   16 +-
 mm/page_io.c                        |    2 
 58 files changed, 251 insertions(+), 556 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

