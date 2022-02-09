Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97118C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  9 Feb 2022 09:00:01 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-532-QAp8VSqKNvu6F6Sn3mi59Q-1; Wed, 09 Feb 2022 03:59:57 -0500
X-MC-Unique: QAp8VSqKNvu6F6Sn3mi59Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BC63B1091DA2;
	Wed,  9 Feb 2022 08:59:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A254D4F84B;
	Wed,  9 Feb 2022 08:59:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6B7321806D1C;
	Wed,  9 Feb 2022 08:59:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2198xoIC020613 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 9 Feb 2022 03:59:50 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B9A2114171FE; Wed,  9 Feb 2022 08:59:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B62D31410F36
	for <dm-devel@redhat.com>; Wed,  9 Feb 2022 08:59:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9E1F73C11C71
	for <dm-devel@redhat.com>; Wed,  9 Feb 2022 08:59:50 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-225-hN1jF1T9MFWIlZAG5ue8xg-1; Wed, 09 Feb 2022 03:59:49 -0500
X-MC-Unique: hN1jF1T9MFWIlZAG5ue8xg-1
Received: from [2001:4bb8:188:3efc:ea2:7599:7eeb:4b5a] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nHiL1-00Gc6p-7q; Wed, 09 Feb 2022 08:28:32 +0000
From: Christoph Hellwig <hch@lst.de>
To: axboe@kernel.dk, martin.petersen@oracle.com, philipp.reisner@linbit.com,
	lars.ellenberg@linbit.com, target-devel@vger.kernel.org,
	haris.iqbal@ionos.com, jinpu.wang@ionos.com, manoj@linux.ibm.com,
	mrochs@linux.ibm.com, ukrishn@linux.ibm.com
Date: Wed,  9 Feb 2022 09:28:21 +0100
Message-Id: <20220209082828.2629273-1-hch@lst.de>
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
	linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com
Subject: [dm-devel] remove REQ_OP_WRITE_SAME v2
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Now that we are using REQ_OP_WRITE_ZEROES for all zeroing needs in the
kernel there is very little use left for REQ_OP_WRITE_SAME.  We only
have two callers left, and both just export optional protocol features
to remote systems: DRBD and the target code.

For the target code the only real use case was zeroing offload, which
is kept with this series, and for DRBD I suspect the same based on the
usage.

    git://git.infradead.org/users/hch/block.git delete-write-same

Gitweb:

    http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/delete-write-same

Changes since v2:
 - split up
 - rebased ontop of five years of kernel change, including the totally
   pointless addition of REQ_OP_WRITE_SAME in rnbd

Changes from RFC:
 - add zeroing offload for the SCSI target.

Diffstat:
 block/blk-core.c                   |   13 -----
 block/blk-lib.c                    |   91 -------------------------------------
 block/blk-merge.c                  |   40 ----------------
 block/blk-settings.c               |   16 ------
 block/blk-sysfs.c                  |    8 ---
 block/blk-zoned.c                  |    1 
 block/blk.h                        |    1 
 block/bounce.c                     |    3 -
 drivers/block/drbd/drbd_main.c     |   31 +-----------
 drivers/block/drbd/drbd_nl.c       |   72 -----------------------------
 drivers/block/drbd/drbd_receiver.c |   47 ++-----------------
 drivers/block/drbd/drbd_req.c      |    1 
 drivers/block/drbd/drbd_worker.c   |    5 --
 drivers/block/rnbd/rnbd-clt.c      |    7 --
 drivers/block/rnbd/rnbd-clt.h      |    1 
 drivers/block/rnbd/rnbd-proto.h    |    6 --
 drivers/block/rnbd/rnbd-srv.c      |    3 -
 drivers/md/dm-core.h               |    1 
 drivers/md/dm-crypt.c              |    1 
 drivers/md/dm-ebs-target.c         |    1 
 drivers/md/dm-io.c                 |   22 --------
 drivers/md/dm-linear.c             |    1 
 drivers/md/dm-mpath.c              |    1 
 drivers/md/dm-rq.c                 |    3 -
 drivers/md/dm-stripe.c             |    4 -
 drivers/md/dm-table.c              |   29 -----------
 drivers/md/dm-zone.c               |    4 -
 drivers/md/dm.c                    |   15 ------
 drivers/md/md-linear.c             |    1 
 drivers/md/md-multipath.c          |    1 
 drivers/md/md.h                    |    7 --
 drivers/md/raid0.c                 |    2 
 drivers/md/raid1.c                 |    4 -
 drivers/md/raid10.c                |    1 
 drivers/md/raid5.c                 |    1 
 drivers/scsi/cxlflash/vlun.c       |    4 -
 drivers/scsi/sd.c                  |   75 ++----------------------------
 drivers/scsi/sd_zbc.c              |    2 
 include/linux/bio.h                |    3 -
 include/linux/blk_types.h          |    2 
 include/linux/blkdev.h             |   19 -------
 include/linux/device-mapper.h      |    6 --
 kernel/trace/blktrace.c            |    1 
 43 files changed, 30 insertions(+), 527 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

