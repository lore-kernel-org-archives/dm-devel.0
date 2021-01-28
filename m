Return-Path: <SRS0=XDEt=G7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44781C433DB
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:39:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A23F064DBD
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:39:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A23F064DBD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-51THv7GbOO-EfBsNBqRxnw-1; Thu, 28 Jan 2021 03:39:11 -0500
X-MC-Unique: 51THv7GbOO-EfBsNBqRxnw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A96E3185A0DD;
	Thu, 28 Jan 2021 08:39:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 886D960C76;
	Thu, 28 Jan 2021 08:39:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 570101809CA1;
	Thu, 28 Jan 2021 08:39:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10S7BjUY007320 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 28 Jan 2021 02:11:45 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 08996EC4AA; Thu, 28 Jan 2021 07:11:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 01E46ED145
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 07:11:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC5FF187504C
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 07:11:41 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-142-cwDwRlI0Os2c2jngTuKtvg-1; Thu, 28 Jan 2021 02:11:39 -0500
X-MC-Unique: cwDwRlI0Os2c2jngTuKtvg-1
IronPort-SDR: CKZOTs4pU56vufwkbE/6Qq0pxzidiPefIdG155QC3pF/Fdi7NIDbqV72EXqQMSSHy5RbfqT04A
	u3WAJVBrtvUG7MfTAFBcligJnCKc8dt9LndeVScOaJrs/Ton+IL92O9s6DzPb1UwU+J2Ft/yHH
	wXljQAcrfdzqs3IsaGS/3GH47i5U7e2yYW2MqJVbmcGsF7wxCwvxmCZXATP4AmHwSPkAIQHgih
	fh6u7DPyZlfoVJx4PslsbolZx5kIFglCK+0inbF6w6gB3EB906Aok5DJhI83WYvxxnYgQVgtfR
	+Wg=
X-IronPort-AV: E=Sophos;i="5.79,381,1602518400"; d="scan'208";a="262548837"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 15:12:39 +0800
IronPort-SDR: UTznEvHbsQGmjPo75icGMIYMsUAdeLV9TCVUdy1geThSk0vhjBGCQsB1j2zwecvTjUSwSiT0JH
	cm8ofiTr2+jj4uZwEOcT7+OO3FetVJ7q5VkDhugHW8USN5R8XMVgEB+ShdOEDqIV6r6cz63cw1
	+jEqJGdQmBoAvyv22jjjS2QmLob6Qu/G3D9I/fXP9T+lWkHpXYGW3o5er0ple0rcP8isVwdRcf
	F/yp7JcafkQjtnhaV09TG4ZpWJaD5mvNvV2uA3CSDF+DaaQTFOvKHEJ1AjUnf6ZHhESJarJ2ZQ
	U9B44jVFpxK1eRS3efOtkrcV
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	27 Jan 2021 22:53:56 -0800
IronPort-SDR: 61Jf/0E9AfrbFBR+VL+aX9SYCVB0aW8ut/7/jLtTqvhkleWzu7b9JjkuOaGgMYwgMXw5C5Sybl
	VeNQs3LEjTqxDsR0ZyK8GA/cVYEZNMX2maaVF3ljBoeSQOO/ApbWgebfLMlSCkYd12pl+6neKj
	zn8nHOcIOMnNA2IBKV67KMXVLkXTllokNu+jCcdgoa5YFwfQecWL2vYSP5hgldmlqCiXple2ew
	fybG/wLzJMKvqPxvYQ59ATt+ZGQv1DjVDDtxXyNp0NJ+IswNbwLOu8d1uiq12NaSa1/W79MYTO
	wq8=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
	by uls-op-cesaip02.wdc.com with ESMTP; 27 Jan 2021 23:11:38 -0800
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, drbd-dev@tron.linbit.com,
	xen-devel@lists.xenproject.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-nilfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
	linux-pm@vger.kernel.org, linux-mm@kvack.org
Date: Wed, 27 Jan 2021 23:10:59 -0800
Message-Id: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
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
X-Mailman-Approved-At: Thu, 28 Jan 2021 03:38:54 -0500
Cc: shaggy@kernel.org, sergey.senozhatsky.work@gmail.com, snitzer@redhat.com,
	tiwai@suse.de, djwong@kernel.org, gustavoars@kernel.org,
	joseph.qi@linux.alibaba.com, pavel@ucw.cz,
	alex.shi@linux.alibaba.com, hch@lst.de, agk@redhat.com,
	naohiro.aota@wdc.com, sagi@grimberg.me, mark@fasheh.com,
	osandov@fb.com, ebiggers@kernel.org, ngupta@vflare.org,
	len.brown@intel.com, chaitanya.kulkarni@wdc.com,
	konrad.wilk@oracle.com, ming.lei@redhat.com,
	viro@zeniv.linux.org.uk, jefflexu@linux.alibaba.com,
	jaegeuk@kernel.org, konishi.ryusuke@gmail.com,
	bvanassche@acm.org, axboe@kernel.dk, damien.lemoal@wdc.com,
	tytso@mit.edu, akpm@linux-foundation.org,
	martin.petersen@oracle.com, rjw@rjwysocki.net,
	philipp.reisner@linbit.com, minchan@kernel.org, tj@kernel.org,
	lars.ellenberg@linbit.com, jth@kernel.org,
	asml.silence@gmail.com, jlbec@evilplan.org, roger.pau@citrix.com
Subject: [dm-devel] [RFC PATCH 00/34] block: introduce bio_new()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

This is a *compile only RFC* which adds a generic helper to initialize
the various fields of the bio that is repeated all the places in
file-systems, block layer, and drivers.

The new helper allows callers to initialize non-optional members of bio
such as bdev, sector, op, opflags, max_bvecs and gfp_mask by
encapsulating new bio allocation with bio alloc with initialization
at one place.

The objective of this RFC is to only start a discussion, this it not 
completely tested at all.

-ck                         

Chaitanya Kulkarni (34):
  block: move common code into blk_next_bio()
  block: introduce and use bio_new
  drdb: use bio_new in drdb
  drdb: use bio_new() in submit_one_flush
  xen-blkback: use bio_new
  zram: use bio_new
  dm: use bio_new in dm-log-writes
  dm-zoned: use bio_new in get_mblock_slow
  dm-zoned: use bio_new in dmz_write_mblock
  dm-zoned: use bio_new in dmz_rdwr_block
  nvmet: use bio_new in nvmet_bdev_execute_rw
  scsi: target/iblock: use bio_new
  block: use bio_new in __blkdev_direct_IO
  fs/buffer: use bio_new in submit_bh_wbc
  fscrypt: use bio_new in fscrypt_zeroout_range
  fs/direct-io: use bio_new in dio_bio_alloc
  iomap: use bio_new in iomap_dio_zero
  iomap: use bio_new in iomap_dio_bio_actor
  fs/jfs/jfs_logmgr.c: use bio_new in lbmRead
  fs/jfs/jfs_logmgr.c: use bio_new in lbmStartIO
  fs/jfs/jfs_metapage.c: use bio_new in metapage_writepage
  fs/jfs/jfs_metapage.c: use bio_new in metapage_readpage
  fs/mpage.c: use bio_new mpage_alloc
  fs/nilfs: use bio_new nilfs_alloc_seg_bio
  ocfs/cluster: use bio_new in dm-log-writes
  xfs: use bio_new in xfs_rw_bdev
  xfs: use bio_new in xfs_buf_ioapply_map
  zonefs: use bio_new
  power/swap: use bio_new in hib_submit_io
  hfsplus: use bio_new in hfsplus_submit_bio()
  iomap: use bio_new in iomap_readpage_actor
  mm: use bio_new in __swap_writepage
  mm: use bio_new in swap_readpage
  mm: add swap_bio_new common bio helper

 block/blk-lib.c                     | 34 ++++++++++-------------------
 block/blk-zoned.c                   |  4 +---
 block/blk.h                         |  5 +++--
 drivers/block/drbd/drbd_receiver.c  | 12 +++++-----
 drivers/block/xen-blkback/blkback.c | 20 +++++++++++------
 drivers/block/zram/zram_drv.c       |  5 ++---
 drivers/md/dm-log-writes.c          | 30 +++++++++----------------
 drivers/md/dm-zoned-metadata.c      | 18 +++++----------
 drivers/nvme/target/io-cmd-bdev.c   |  9 +++-----
 drivers/target/target_core_iblock.c |  5 ++---
 fs/block_dev.c                      |  6 ++---
 fs/buffer.c                         | 16 ++++++--------
 fs/crypto/bio.c                     |  5 ++---
 fs/direct-io.c                      |  6 ++---
 fs/hfsplus/wrapper.c                |  5 +----
 fs/iomap/buffered-io.c              | 12 +++++-----
 fs/iomap/direct-io.c                | 11 ++++------
 fs/jfs/jfs_logmgr.c                 | 13 ++++-------
 fs/jfs/jfs_metapage.c               | 15 +++++--------
 fs/mpage.c                          | 18 +++++----------
 fs/nilfs2/segbuf.c                  | 10 ++-------
 fs/ocfs2/cluster/heartbeat.c        |  6 ++---
 fs/xfs/xfs_bio_io.c                 |  7 ++----
 fs/xfs/xfs_buf.c                    |  6 ++---
 fs/zonefs/super.c                   |  6 ++---
 include/linux/bio.h                 | 25 +++++++++++++++++++++
 kernel/power/swap.c                 |  7 +++---
 mm/page_io.c                        | 30 +++++++++++++------------
 28 files changed, 151 insertions(+), 195 deletions(-)

-- 
2.22.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

