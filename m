Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FD60C77B7A
	for <dm-devel@archiver.kernel.org>; Tue,  6 Jun 2023 07:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686037920;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jPBGjl/PbcNWMytM4pxQsQ70Buzq89PxZUHDR8r+QBA=;
	b=BltiXYyTjqcJ3kdgDUCch0iU7uah9W16/7XsM0mKUoZRlpzIUxlLVGkMPFxkhJ5OlpbEXu
	jWYatmgpN7D6l31Xj69c4BWTn/uZBMYLladBsp2Zy3KYj8Q7hNStE0LGhGDrvIhTkdvMcQ
	TGVKzcOEgdOvBQa+E0w9CsYwbnDWBCA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-509-mGotA-pEM0-ADx_9oXa_6w-1; Tue, 06 Jun 2023 03:51:59 -0400
X-MC-Unique: mGotA-pEM0-ADx_9oXa_6w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 717E728078D3;
	Tue,  6 Jun 2023 07:51:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5F8D540D1B66;
	Tue,  6 Jun 2023 07:51:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2ACE319465B9;
	Tue,  6 Jun 2023 07:51:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DBA1D1946595
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Jun 2023 07:51:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BCF674021AA; Tue,  6 Jun 2023 07:51:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B47D0492B00
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 07:51:54 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8BF7B101A531
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 07:51:54 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-619-PQtOUuNiOf2ABW6kCA_jMQ-1; Tue, 06 Jun 2023 03:51:52 -0400
X-MC-Unique: PQtOUuNiOf2ABW6kCA_jMQ-1
Received: from
 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at
 ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
 id 1q6RIH-000Ya3-0f; Tue, 06 Jun 2023 07:39:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Tue,  6 Jun 2023 09:39:19 +0200
Message-Id: <20230606073950.225178-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] decouple block open flags from fmode_t
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Vignesh Raghavendra <vigneshr@ti.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, linux-nvme@lists.infradead.org,
 Phillip Potter <phil@philpotter.co.uk>, Chris Mason <clm@fb.com>,
 dm-devel@redhat.com, "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
 Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>,
 Jack Wang <jinpu.wang@ionos.com>, linux-nilfs@vger.kernel.org,
 linux-scsi@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 linux-pm@vger.kernel.org, linux-um@lists.infradead.org,
 Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
 linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>,
 Christian Brauner <brauner@kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
 linux-mtd@lists.infradead.org, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lst.de
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi all,

this series adds a new blk_mode_t for block open flags instead of abusing
fmode_t.  The block open flags work very different from the normal use of
fmode_t and only share the basic READ/WRITE flags with it.  None of the
other normal FMODE_* flags is used, but instead there are three
block-specific ones not used by anyone else, which can now be removed.

Note that I've only CCed maintainers and lists for drivers and file systems
that have non-trivial changes, as otherwise the series would spam literally
everyone in the block and file system world.

Diffstat:
 arch/um/drivers/ubd_kern.c          |   20 ++-----
 arch/xtensa/platforms/iss/simdisk.c |    6 +-
 block/bdev.c                        |   99 ++++++++++++++++++------------------
 block/blk-zoned.c                   |   12 ++--
 block/blk.h                         |   26 ++++++++-
 block/bsg-lib.c                     |    2 
 block/bsg.c                         |    8 +-
 block/disk-events.c                 |   47 +++++++----------
 block/fops.c                        |   54 ++++++++++++-------
 block/genhd.c                       |   13 ++--
 block/ioctl.c                       |   61 +++++++---------------
 drivers/block/amiflop.c             |   20 +++----
 drivers/block/aoe/aoeblk.c          |    8 +-
 drivers/block/ataflop.c             |   43 +++++++--------
 drivers/block/drbd/drbd_main.c      |   13 ++--
 drivers/block/drbd/drbd_nl.c        |   23 +++++---
 drivers/block/floppy.c              |   72 +++++++++++++-------------
 drivers/block/loop.c                |   24 ++++----
 drivers/block/mtip32xx/mtip32xx.c   |    4 -
 drivers/block/nbd.c                 |   12 ++--
 drivers/block/pktcdvd.c             |   36 ++++++-------
 drivers/block/rbd.c                 |    6 +-
 drivers/block/rnbd/rnbd-clt.c       |    8 +-
 drivers/block/rnbd/rnbd-srv-sysfs.c |    3 -
 drivers/block/rnbd/rnbd-srv.c       |   23 ++++----
 drivers/block/rnbd/rnbd-srv.h       |    2 
 drivers/block/sunvdc.c              |    2 
 drivers/block/swim.c                |   24 ++++----
 drivers/block/swim3.c               |   33 +++++-------
 drivers/block/ublk_drv.c            |    4 -
 drivers/block/xen-blkback/xenbus.c  |    4 -
 drivers/block/xen-blkfront.c        |    2 
 drivers/block/z2ram.c               |    8 +-
 drivers/block/zram/zram_drv.c       |   21 +++----
 drivers/cdrom/cdrom.c               |   36 +++----------
 drivers/cdrom/gdrom.c               |   12 ++--
 drivers/md/bcache/bcache.h          |    2 
 drivers/md/bcache/request.c         |    4 -
 drivers/md/bcache/super.c           |   25 ++++-----
 drivers/md/dm-cache-target.c        |   12 ++--
 drivers/md/dm-clone-target.c        |   10 +--
 drivers/md/dm-core.h                |    7 +-
 drivers/md/dm-era-target.c          |    6 +-
 drivers/md/dm-ioctl.c               |   10 +--
 drivers/md/dm-snap.c                |    4 -
 drivers/md/dm-table.c               |   11 ++--
 drivers/md/dm-thin.c                |    9 +--
 drivers/md/dm-verity-fec.c          |    2 
 drivers/md/dm-verity-target.c       |    6 +-
 drivers/md/dm.c                     |   20 +++----
 drivers/md/dm.h                     |    2 
 drivers/md/md.c                     |   50 +++++++++---------
 drivers/mmc/core/block.c            |   12 ++--
 drivers/mtd/devices/block2mtd.c     |    6 +-
 drivers/mtd/mtd_blkdevs.c           |    8 +-
 drivers/mtd/mtdblock.c              |    2 
 drivers/mtd/ubi/block.c             |    9 +--
 drivers/nvme/host/core.c            |    6 +-
 drivers/nvme/host/ioctl.c           |   66 +++++++++++++-----------
 drivers/nvme/host/multipath.c       |    6 +-
 drivers/nvme/host/nvme.h            |    4 -
 drivers/nvme/target/io-cmd-bdev.c   |    4 -
 drivers/s390/block/dasd.c           |   10 +--
 drivers/s390/block/dasd_genhd.c     |    5 +
 drivers/s390/block/dasd_int.h       |    3 -
 drivers/s390/block/dasd_ioctl.c     |    2 
 drivers/s390/block/dcssblk.c        |   11 +---
 drivers/scsi/ch.c                   |    3 -
 drivers/scsi/scsi_bsg.c             |    4 -
 drivers/scsi/scsi_ioctl.c           |   38 ++++++-------
 drivers/scsi/sd.c                   |   39 ++++++--------
 drivers/scsi/sg.c                   |    7 +-
 drivers/scsi/sr.c                   |   22 ++++----
 drivers/scsi/st.c                   |    2 
 drivers/target/target_core_iblock.c |    9 +--
 drivers/target/target_core_pscsi.c  |   10 +--
 fs/btrfs/dev-replace.c              |    6 +-
 fs/btrfs/ioctl.c                    |   12 ++--
 fs/btrfs/super.c                    |   21 ++-----
 fs/btrfs/volumes.c                  |   55 +++++++++-----------
 fs/btrfs/volumes.h                  |   11 +---
 fs/erofs/super.c                    |    7 +-
 fs/ext4/super.c                     |   11 +---
 fs/f2fs/super.c                     |   12 ++--
 fs/jfs/jfs_logmgr.c                 |    6 +-
 fs/nfs/blocklayout/dev.c            |    9 +--
 fs/nilfs2/super.c                   |   12 +---
 fs/ocfs2/cluster/heartbeat.c        |    7 +-
 fs/reiserfs/journal.c               |   19 +++---
 fs/reiserfs/reiserfs.h              |    1 
 fs/super.c                          |   33 ++++--------
 fs/xfs/xfs_super.c                  |   15 ++---
 include/linux/blkdev.h              |   68 +++++++++++-------------
 include/linux/bsg.h                 |    2 
 include/linux/cdrom.h               |   12 ++--
 include/linux/device-mapper.h       |    8 +-
 include/linux/fs.h                  |    8 --
 include/linux/mtd/blktrans.h        |    2 
 include/scsi/scsi_ioctl.h           |    4 -
 kernel/power/hibernate.c            |   12 +---
 kernel/power/power.h                |    2 
 kernel/power/swap.c                 |   28 ++++------
 mm/swapfile.c                       |    7 +-
 103 files changed, 796 insertions(+), 853 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

