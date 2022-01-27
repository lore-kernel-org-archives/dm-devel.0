Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EEC1C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 27 Jan 2022 07:19:53 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-621-upKzV99pNvqEPnNa8C3-Qg-1; Thu, 27 Jan 2022 02:19:50 -0500
X-MC-Unique: upKzV99pNvqEPnNa8C3-Qg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F1541006AA4;
	Thu, 27 Jan 2022 07:19:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D30D94EC6D;
	Thu, 27 Jan 2022 07:19:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 853451806D1C;
	Thu, 27 Jan 2022 07:19:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20R7Jhrb004372 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 27 Jan 2022 02:19:43 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C35B340F9D6E; Thu, 27 Jan 2022 07:19:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BEDC240F9D68
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 07:19:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A551E3C11A2F
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 07:19:43 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-156-GZbQETb3OMi3kZphcS_9qg-1; Thu, 27 Jan 2022 02:19:42 -0500
X-MC-Unique: GZbQETb3OMi3kZphcS_9qg-1
Received: from 213-225-10-69.nat.highway.a1.net ([213.225.10.69]
	helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nCyNq-00EY07-23; Thu, 27 Jan 2022 06:35:50 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Thu, 27 Jan 2022 07:35:32 +0100
Message-Id: <20220127063546.1314111-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Pavel Begunkov <asml.silence@gmail.com>, drbd-dev@lists.linbit.com
Subject: [dm-devel] improve the bio cloning interface
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

Hi Jens,

this series changes the bio cloning interface to match the rest changes
to the bio allocation interface and passes the block_device and operation
to the cloning helpers.  In addition it renames the cloning helpers to
be more descriptive.

To get there it requires a bit of refactoring in the device mapper code.

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
 drivers/md/dm.c                  |  167 ++++++++++++++-------------------------
 drivers/md/md-faulty.c           |    4 
 drivers/md/md-multipath.c        |    4 
 drivers/md/md.c                  |    5 -
 drivers/md/raid1.c               |   34 +++----
 drivers/md/raid10.c              |   16 +--
 drivers/md/raid5.c               |    4 
 fs/btrfs/extent_io.c             |    4 
 include/linux/bio.h              |    6 -
 22 files changed, 185 insertions(+), 238 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

