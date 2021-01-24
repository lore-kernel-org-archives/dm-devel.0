Return-Path: <SRS0=PWLs=G3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A076C433E0
	for <dm-devel@archiver.kernel.org>; Sun, 24 Jan 2021 10:13:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C4A0922C7E
	for <dm-devel@archiver.kernel.org>; Sun, 24 Jan 2021 10:13:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C4A0922C7E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-FZDE2I_lOrGQE__4w8JxOg-1; Sun, 24 Jan 2021 05:13:37 -0500
X-MC-Unique: FZDE2I_lOrGQE__4w8JxOg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F7FA801817;
	Sun, 24 Jan 2021 10:13:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 99F4871CBE;
	Sun, 24 Jan 2021 10:13:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 728B21809CA1;
	Sun, 24 Jan 2021 10:13:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10OADUE7005672 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 24 Jan 2021 05:13:31 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C819A47CD6; Sun, 24 Jan 2021 10:13:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C315847CD4
	for <dm-devel@redhat.com>; Sun, 24 Jan 2021 10:13:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6318D1875049
	for <dm-devel@redhat.com>; Sun, 24 Jan 2021 10:13:28 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-406-3NoeWAwCMAesROlxKtTpQA-1; Sun, 24 Jan 2021 05:13:24 -0500
X-MC-Unique: 3NoeWAwCMAesROlxKtTpQA-1
Received: from 089144206130.atnat0015.highway.bob.at ([89.144.206.130]
	helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
	id 1l3cGJ-002q3S-S7; Sun, 24 Jan 2021 10:04:55 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Sun, 24 Jan 2021 11:02:31 +0100
Message-Id: <20210124100241.1167849-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: linux-s390@vger.kernel.org, linux-bcache@vger.kernel.org,
	Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	linux-block@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [dm-devel] store a pointer to the block_device in struct bio
	(again) v2
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
"split hard read-only vs read-only policy" series.

A git tree is also available:

    git://git.infradead.org/users/hch/block.git bi_bdev

Gitweb:

    http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/bi_bdev

Changes since v1:
 - protect against double remapping I/O to partitions

Diffstat:
 arch/m68k/emu/nfblock.c             |    2 
 arch/xtensa/platforms/iss/simdisk.c |    2 
 block/bio-integrity.c               |   18 +-
 block/bio.c                         |   31 +---
 block/blk-cgroup.c                  |    7 
 block/blk-core.c                    |  100 ++++++-------
 block/blk-crypto-fallback.c         |    2 
 block/blk-crypto.c                  |    2 
 block/blk-merge.c                   |   17 +-
 block/blk-mq.c                      |    2 
 block/blk-settings.c                |    2 
 block/blk-throttle.c                |    2 
 block/blk.h                         |    5 
 block/bounce.c                      |    2 
 block/genhd.c                       |  271 ++++--------------------------------
 block/partitions/core.c             |   31 ----
 drivers/block/brd.c                 |    8 -
 drivers/block/drbd/drbd_int.h       |    4 
 drivers/block/drbd/drbd_req.c       |    2 
 drivers/block/null_blk/main.c       |    2 
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
 include/linux/bio.h                 |   20 +-
 include/linux/blk-mq.h              |    4 
 include/linux/blk_types.h           |    4 
 include/linux/blkdev.h              |   20 --
 include/linux/genhd.h               |   21 --
 kernel/trace/blktrace.c             |   16 +-
 mm/page_io.c                        |    2 
 59 files changed, 260 insertions(+), 561 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

