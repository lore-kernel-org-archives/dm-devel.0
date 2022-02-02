Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00153C433FE
	for <dm-devel@archiver.kernel.org>; Wed,  2 Feb 2022 16:01:35 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-167-Uix_kRSiNq-tutqmdwPJpg-1; Wed, 02 Feb 2022 11:01:32 -0500
X-MC-Unique: Uix_kRSiNq-tutqmdwPJpg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9219C81440B;
	Wed,  2 Feb 2022 16:01:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5B5737D490;
	Wed,  2 Feb 2022 16:01:25 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3CD494BB7C;
	Wed,  2 Feb 2022 16:01:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 212G1K5G018626 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Feb 2022 11:01:20 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id AA5622027EB4; Wed,  2 Feb 2022 16:01:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A58C72026609
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 16:01:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1E66185A5BB
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 16:01:16 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-634-EFtN4h9nO4GkELoL_gQmOw-1; Wed, 02 Feb 2022 11:01:14 -0500
X-MC-Unique: EFtN4h9nO4GkELoL_gQmOw-1
Received: from [2001:4bb8:191:327d:b3e5:1ccd:eaac:6609] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nFI4F-00G7vu-Ff; Wed, 02 Feb 2022 16:01:11 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed,  2 Feb 2022 17:00:56 +0100
Message-Id: <20220202160109.108149-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Pavel Begunkov <asml.silence@gmail.com>, drbd-dev@lists.linbit.com
Subject: [dm-devel] improve the bio cloning interface v2
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Jens,

this series changes the bio cloning interface to match the rest changes
to the bio allocation interface and passes the block_device and operation
to the cloning helpers.  In addition it renames the cloning helpers to
be more descriptive.

To get there it requires a bit of refactoring in the device mapper code.

Changes since v1:
 - rebased to the lastest for-5.18/block tree
 - fix a fatal double initialization in device mapper

A git tree is also available here:

    git://git.infradead.org/users/hch/block.git bio_alloc-cleanup-part2

Gitweb:

    http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/bio_alloc-cleanup-part2

Diffstat:
 Documentation/block/biodoc.rst   |    5 -
 block/bio-integrity.c            |    1 
 block/bio.c                      |  106 +++++++++++++-----------
 block/blk-crypto.c               |    1 
 block/blk-mq.c                   |    4 
 block/bounce.c                   |    3 
 drivers/block/drbd/drbd_req.c    |    5 -
 drivers/block/drbd/drbd_worker.c |    4 
 drivers/block/pktcdvd.c          |    4 
 drivers/md/bcache/request.c      |    6 -
 drivers/md/dm-cache-target.c     |   26 ++----
 drivers/md/dm-crypt.c            |   11 +-
 drivers/md/dm-zoned-target.c     |    3 
 drivers/md/dm.c                  |  166 +++++++++++++--------------------------
 drivers/md/md-faulty.c           |    4 
 drivers/md/md-multipath.c        |    4 
 drivers/md/md.c                  |    5 -
 drivers/md/raid1.c               |   34 +++----
 drivers/md/raid10.c              |   16 +--
 drivers/md/raid5.c               |    4 
 fs/btrfs/extent_io.c             |    4 
 include/linux/bio.h              |    6 -
 22 files changed, 183 insertions(+), 239 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

