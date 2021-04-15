Return-Path: <SRS0=YP8V=JM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 702C0C433B4
	for <dm-devel@archiver.kernel.org>; Thu, 15 Apr 2021 10:34:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 08F556124B
	for <dm-devel@archiver.kernel.org>; Thu, 15 Apr 2021 10:34:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 08F556124B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1618482845;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xRjYMUhs9WEhOkpCdT1WM3ARomV5WEfF4SBll3djADM=;
	b=YsvtgU1/4qiLGIHG6IeeHTZArFLPqpR+Va0nfNRAPry4yIU82lJE1O6S4AEJ364T8i7hk8
	J5W+H0x4hqv5XdlcGmnjRDUKh6HY3FlHXMwKmWdFdyDxY+2hC59SAOI00Oe+G1/0C27vD7
	skzDB9HFIcXuxqX2mvZ5yAUUt/hW+MU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-mw2BH4XUPgyToTOsBqij4A-1; Thu, 15 Apr 2021 06:34:03 -0400
X-MC-Unique: mw2BH4XUPgyToTOsBqij4A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 10BEA801597;
	Thu, 15 Apr 2021 10:33:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AC2F42B3CF;
	Thu, 15 Apr 2021 10:33:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C65F044A5B;
	Thu, 15 Apr 2021 10:33:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13FAXsR9032066 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 15 Apr 2021 06:33:54 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 714EE22E57; Thu, 15 Apr 2021 10:33:54 +0000 (UTC)
Received: from localhost (ovpn-13-200.pek2.redhat.com [10.72.13.200])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BE8835D9DC;
	Thu, 15 Apr 2021 10:33:40 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Date: Thu, 15 Apr 2021 18:33:08 +0800
Message-Id: <20210415103310.1513841-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: linux-raid@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org, Ming Lei <ming.lei@redhat.com>,
	linux-block@vger.kernel.org, Song Liu <song@kernel.org>,
	dm-devel@redhat.com, Jeffle Xu <jefflexu@linux.alibaba.com>
Subject: [dm-devel] [RFC PATCH 0/2] block: support to freeze bio based queue
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

For bio based request queue, the queue usage refcnt is only grabbed
during submission, which isn't consistent with request base queue.

Queue freezing has been used widely, and turns out it is very useful
to quiesce queue activity.

So try to support to freeze bio based queue by ->q_usage_counter.

Any comment are welcome!


Ming Lei (2):
  percpu_ref: add percpu_ref_tryget_many_live
  block: support to freeze bio based request queue

 block/bio.c                     | 12 ++++++++++--
 block/blk-core.c                | 23 +++++++++++++++++------
 drivers/nvme/host/core.c        | 16 ++++++++++++++++
 drivers/nvme/host/multipath.c   |  6 ++++++
 include/linux/blk-mq.h          |  2 ++
 include/linux/blk_types.h       |  1 +
 include/linux/blkdev.h          |  7 ++++++-
 include/linux/percpu-refcount.h | 30 ++++++++++++++++++++++++++----
 8 files changed, 84 insertions(+), 13 deletions(-)

-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

