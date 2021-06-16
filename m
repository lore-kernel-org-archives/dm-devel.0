Return-Path: <SRS0=Xutw=LK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE2B7C48BE5
	for <dm-devel@archiver.kernel.org>; Wed, 16 Jun 2021 13:06:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4E04061166
	for <dm-devel@archiver.kernel.org>; Wed, 16 Jun 2021 13:06:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4E04061166
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1623848783;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=SWPCfdH4VYfiAIdFjoT0us/Ev8xfTf3ztBKiaVN920s=;
	b=HxYpOvtOTdb7GMeez32Cyye9+Bj8nJ3V4sijIa9T8O3/3kHg6xl53NrR55ipvOwuDgEket
	4gw+xUn4Dr7vs+oTwCHFKAFJEUHTlpvYMZpmfym+CSG2ORgo1VxhLQz1O3ZJE5FCnlxvWu
	0NQEghxl6mLGe+3DKx9CheRedRoMpJQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-UwJJtHgBPfikBfAAX9bJSA-1; Wed, 16 Jun 2021 09:06:21 -0400
X-MC-Unique: UwJJtHgBPfikBfAAX9bJSA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD885A40C6;
	Wed, 16 Jun 2021 13:06:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6E9555C233;
	Wed, 16 Jun 2021 13:06:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 023A31809CAD;
	Wed, 16 Jun 2021 13:06:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15GD68xx001311 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 16 Jun 2021 09:06:08 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 98D412E09A; Wed, 16 Jun 2021 13:06:08 +0000 (UTC)
Received: from localhost (ovpn-12-48.pek2.redhat.com [10.72.12.48])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 806846060F;
	Wed, 16 Jun 2021 13:05:49 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>
Date: Wed, 16 Jun 2021 21:05:29 +0800
Message-Id: <20210616130533.754248-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [dm-devel] [RFC PATCH 0/4] block/dm: support bio polling
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello Guys,

Based on Christoph's bio based polling model[1], implement DM bio polling
with one very simple approach.

Patch 1 adds helper of blk_queue_poll().

Patch 2 reuses .bi_next to bio driver for storing driver data.

Patch 3 adds .bio_poll() callback to block_device_operations, so bio
driver can implement its own logic for io polling.

Patch 4 implements bio polling for device mapper.

Any comments are welcome.

[1] switch block layer polling to a bio based model v4
https://lore.kernel.org/linux-block/20210615160619.GA32435@lst.de/T/#t


Ming Lei (4):
  block: add helper of blk_queue_poll
  block: add field of .bi_bio_drv_data to bio
  block: add ->poll_bio to block_device_operations
  dm: support bio polling

 block/blk-core.c          | 21 +++++++++-----
 block/blk-sysfs.c         |  4 +--
 block/genhd.c             |  3 ++
 drivers/md/dm-table.c     | 24 ++++++++++++++++
 drivers/md/dm.c           | 59 ++++++++++++++++++++++++++++++++++++---
 drivers/nvme/host/core.c  |  2 +-
 include/linux/blk_types.h | 11 +++++++-
 include/linux/blkdev.h    |  3 ++
 8 files changed, 112 insertions(+), 15 deletions(-)

-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

