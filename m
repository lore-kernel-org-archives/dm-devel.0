Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A061C4332F
	for <dm-devel@archiver.kernel.org>; Mon, 24 Jan 2022 09:11:50 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-pJG2THgbM3aKoTwfKC9iug-1; Mon, 24 Jan 2022 04:11:45 -0500
X-MC-Unique: pJG2THgbM3aKoTwfKC9iug-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EEDBF1923B80;
	Mon, 24 Jan 2022 09:11:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CCAFA73143;
	Mon, 24 Jan 2022 09:11:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A39491809CB9;
	Mon, 24 Jan 2022 09:11:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20O9BMIe016838 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 24 Jan 2022 04:11:23 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2F203141DED5; Mon, 24 Jan 2022 09:11:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B3C4141DED4
	for <dm-devel@redhat.com>; Mon, 24 Jan 2022 09:11:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 11B463C0010F
	for <dm-devel@redhat.com>; Mon, 24 Jan 2022 09:11:22 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-115-ab0ENgRPN_C4dSBQBNvDYQ-1; Mon, 24 Jan 2022 04:11:20 -0500
X-MC-Unique: ab0ENgRPN_C4dSBQBNvDYQ-1
Received: from [2001:4bb8:184:72a4:a337:a75f:a24e:7e39] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nBvNV-002jyR-9a; Mon, 24 Jan 2022 09:11:09 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Mon, 24 Jan 2022 10:10:48 +0100
Message-Id: <20220124091107.642561-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, linux-nfs@vger.kernel.org,
	linux-nilfs@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.co>,
	dm-devel@redhat.com, "Md . Haris Iqbal " <haris.iqbal@ionos.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	linux-fsdevel@vger.kernel.org, xen-devel@lists.xenproject.org,
	Andrew Morton <akpm@linux-foundation.org>, ntfs3@lists.linux.dev,
	Jack Wang <jinpu.wang@ionos.com>, Pavel Begunkov <asml.silence@gmail.com>,
	drbd-dev@lists.linbit.com
Subject: [dm-devel] improve the bio allocation interface v2
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Jens,

this series is posted early because it has wide-ranging changes and could use some
early ACKs before -rc1.

It changes the interface to the bio allocators to always pass a block_device and
the operation, which is information needed for every bio submitted through
bio_submit.  This means the fields can be directly initialized in bio_init instead
of first being zeroed and thus should help to micro-optimize even better than the
__bio_set_dev that Pavel proposed while also cleaning up code.

I have a follow on series to also deal with the bio cloning interfaces that need
even more love, and additional cleanups for the callers which might be material
for the next merge window.

Changes since v1:
 - fix bio_add_page return value handling in rnbd-srv
 - fix bio clenup in rnbd-srv
 - fix a few commit message typos
 - fix a bisection hazard in rnbd
 - fix an initialization order issue in bio_alloc_bioset/bio_init

Diffstat:
 block/bio.c                         |   73 ++++++++++++++++++++++++------------
 block/blk-flush.c                   |    4 -
 block/blk-lib.c                     |   32 ++-------------
 block/blk-zoned.c                   |   14 +-----
 block/blk.h                         |    2 
 block/bounce.c                      |    6 --
 block/fops.c                        |   35 +++++++----------
 drivers/block/drbd/drbd_actlog.c    |    5 --
 drivers/block/drbd/drbd_bitmap.c    |    7 +--
 drivers/block/drbd/drbd_receiver.c  |   32 +++------------
 drivers/block/floppy.c              |    4 -
 drivers/block/pktcdvd.c             |    8 ---
 drivers/block/rnbd/rnbd-srv-dev.c   |   61 ------------------------------
 drivers/block/rnbd/rnbd-srv-dev.h   |   18 --------
 drivers/block/rnbd/rnbd-srv.c       |   45 ++++++++--------------
 drivers/block/rnbd/rnbd-srv.h       |    1 
 drivers/block/xen-blkback/blkback.c |   25 ++----------
 drivers/block/zram/zram_drv.c       |   16 ++-----
 drivers/md/bcache/io.c              |    3 -
 drivers/md/bcache/journal.c         |   16 ++-----
 drivers/md/bcache/movinggc.c        |    4 -
 drivers/md/bcache/request.c         |   18 +++-----
 drivers/md/bcache/super.c           |    8 +--
 drivers/md/bcache/writeback.c       |    4 -
 drivers/md/dm-crypt.c               |   27 ++++---------
 drivers/md/dm-io.c                  |    5 --
 drivers/md/dm-log-writes.c          |   39 +++----------------
 drivers/md/dm-snap.c                |   21 ----------
 drivers/md/dm-thin.c                |   41 +++++---------------
 drivers/md/dm-writecache.c          |    7 +--
 drivers/md/dm-zoned-metadata.c      |   26 ++----------
 drivers/md/dm.c                     |   12 ++---
 drivers/md/md-multipath.c           |    2 
 drivers/md/md.c                     |   24 +++++------
 drivers/md/raid1.c                  |    8 +--
 drivers/md/raid10.c                 |   14 ++----
 drivers/md/raid5-cache.c            |   19 +++------
 drivers/md/raid5-ppl.c              |   13 ++----
 drivers/md/raid5.c                  |   12 ++---
 drivers/nvdimm/nd_virtio.c          |    6 +-
 drivers/nvme/target/io-cmd-bdev.c   |   18 +++-----
 drivers/nvme/target/passthru.c      |    7 +--
 drivers/nvme/target/zns.c           |   14 +++---
 drivers/scsi/ufs/ufshpb.c           |    4 -
 drivers/target/target_core_iblock.c |   11 +----
 fs/btrfs/disk-io.c                  |   10 +---
 fs/btrfs/extent_io.c                |    2 
 fs/buffer.c                         |   14 ++----
 fs/crypto/bio.c                     |   13 ++----
 fs/direct-io.c                      |    5 --
 fs/erofs/zdata.c                    |    5 --
 fs/ext4/page-io.c                   |    3 -
 fs/ext4/readpage.c                  |    8 +--
 fs/f2fs/data.c                      |    7 +--
 fs/gfs2/lops.c                      |    8 +--
 fs/gfs2/meta_io.c                   |    4 -
 fs/gfs2/ops_fstype.c                |    4 -
 fs/hfsplus/wrapper.c                |    4 -
 fs/iomap/buffered-io.c              |   26 +++++-------
 fs/iomap/direct-io.c                |    8 ---
 fs/jfs/jfs_logmgr.c                 |   11 -----
 fs/jfs/jfs_metapage.c               |    9 +---
 fs/mpage.c                          |   34 ++--------------
 fs/nfs/blocklayout/blocklayout.c    |   26 +-----------
 fs/nilfs2/segbuf.c                  |   31 +--------------
 fs/ntfs3/fsntfs.c                   |   27 -------------
 fs/ocfs2/cluster/heartbeat.c        |    4 -
 fs/squashfs/block.c                 |   11 ++---
 fs/xfs/xfs_bio_io.c                 |   14 ++----
 fs/xfs/xfs_buf.c                    |    4 -
 fs/xfs/xfs_log.c                    |   14 +++---
 fs/zonefs/super.c                   |    9 +---
 include/linux/bio.h                 |   30 ++++++--------
 kernel/power/swap.c                 |    5 --
 mm/page_io.c                        |   10 +---
 75 files changed, 372 insertions(+), 759 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

