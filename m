Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98007C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 21 Dec 2021 14:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1640096149;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=JS/fWS6zpZHhThhXgENcEVotSuPmYZWUWnT7vwxq8iI=;
	b=B4jHeIP4hRnDl401O/6OywSWC4v88eSdtW4deGZ/id+JhtA6T2I5RFIrspepj33tsYu8xV
	6mwiaEG7FhWDc3T6rVvZTOsp5K6qgOaOQ7jlGXebbm0Nfp4H+DTA3O5sUiQgb7RxJv77xA
	rtd7XhrK6Os9cud0J5s4nEWzEMba5r4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-520-b4LeMklnPoOthEnYG-Ipog-1; Tue, 21 Dec 2021 09:15:46 -0500
X-MC-Unique: b4LeMklnPoOthEnYG-Ipog-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D524801962;
	Tue, 21 Dec 2021 14:15:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CBA89908B;
	Tue, 21 Dec 2021 14:15:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2B5694BB7C;
	Tue, 21 Dec 2021 14:15:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BLEFZXp006161 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 21 Dec 2021 09:15:35 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C06E04BC67; Tue, 21 Dec 2021 14:15:35 +0000 (UTC)
Received: from localhost (ovpn-8-30.pek2.redhat.com [10.72.8.30])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 501A94BC6F;
	Tue, 21 Dec 2021 14:15:04 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>
Date: Tue, 21 Dec 2021 22:14:56 +0800
Message-Id: <20211221141459.1368176-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
	Ming Lei <ming.lei@redhat.com>
Subject: [dm-devel] [PATCH 0/3] blk-mq/dm-rq: support BLK_MQ_F_BLOCKING for
	dm-rq
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello,

dm-rq may be built on blk-mq device which marks BLK_MQ_F_BLOCKING, so
dm_mq_queue_rq() may become to sleep current context.

Fixes the issue by allowing dm-rq to set BLK_MQ_F_BLOCKING in case that
any underlying queue is marked as BLK_MQ_F_BLOCKING.

DM request queue is allocated before allocating tagset, this way is a
bit special, so we need to pre-allocate srcu payload, then use the queue
flag of QUEUE_FLAG_BLOCKING for locking dispatch.


Ming Lei (3):
  block: split having srcu from queue blocking
  block: add blk_alloc_disk_srcu
  dm: mark dm queue as blocking if any underlying is blocking

 block/blk-core.c       |  2 +-
 block/blk-mq.c         |  6 +++---
 block/blk-mq.h         |  2 +-
 block/blk-sysfs.c      |  2 +-
 block/genhd.c          |  5 +++--
 drivers/md/dm-rq.c     |  5 ++++-
 drivers/md/dm-rq.h     |  3 ++-
 drivers/md/dm-table.c  | 14 ++++++++++++++
 drivers/md/dm.c        |  5 +++--
 drivers/md/dm.h        |  1 +
 include/linux/blkdev.h |  5 +++--
 include/linux/genhd.h  | 12 ++++++++----
 12 files changed, 44 insertions(+), 18 deletions(-)

-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

