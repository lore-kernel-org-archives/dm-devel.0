Return-Path: <SRS0=6Nrr=JT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCBADC433B4
	for <dm-devel@archiver.kernel.org>; Thu, 22 Apr 2021 12:21:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4195761450
	for <dm-devel@archiver.kernel.org>; Thu, 22 Apr 2021 12:21:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4195761450
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1619094077;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=A71ACzh0ZCm8nX4O5DOk6MqNKQeDmW+jJC+xrikViPg=;
	b=JkcZ01hOIUQ0kEnS6929F35kuSYSczL+RmUl5rJZWtdHnTzGx5HruhdhLZgEGx7/YiTEGW
	DEUmSYCkZZZBJ1a6W5WQ1EpaXSXzzk72DGF6BiSsQBGxJB8OoPXtB4X6BDZ/2Uov7OQHcv
	Grt4kSF3/uT2uSZWoPFioJcUOaqV9Ok=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-490-MJNAGCmqP8KPiwPlpiBMXQ-1; Thu, 22 Apr 2021 08:21:16 -0400
X-MC-Unique: MJNAGCmqP8KPiwPlpiBMXQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C4615192204C;
	Thu, 22 Apr 2021 12:20:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 783DF60C05;
	Thu, 22 Apr 2021 12:20:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C6F721806D0F;
	Thu, 22 Apr 2021 12:20:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13MCKrc6020455 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 22 Apr 2021 08:20:53 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id B3DE12BFE7; Thu, 22 Apr 2021 12:20:53 +0000 (UTC)
Received: from localhost (ovpn-13-243.pek2.redhat.com [10.72.13.243])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7ACA9136F5;
	Thu, 22 Apr 2021 12:20:42 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Date: Thu, 22 Apr 2021 20:20:26 +0800
Message-Id: <20210422122038.2192933-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>, Ming Lei <ming.lei@redhat.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Jeffle Xu <jefflexu@linux.alibaba.com>
Subject: [dm-devel] [PATCH V6 00/12] block: support bio based io polling
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

Add per-task io poll context for holding HIPRI blk-mq/underlying bios
queued from bio based driver's io submission context, and reuse one bio
padding field for storing 'cookie' returned from submit_bio() for these
bios. Also explicitly end these bios in poll context by adding two
new bio flags.

In this way, we needn't to poll all underlying hw queues any more,
which is implemented in Jeffle's patches. And we can just poll hw queues
in which there is HIPRI IO queued.

Usually io submission and io poll share same context, so the added io
poll context data is just like one stack variable, and the cost for
saving bios is cheap.

V6:
	- move poll code into block/blk-poll.c, as suggested by Christoph
	- define bvec_iter as __packed, and add one new field to bio, as
	  suggested by Christoph
	- re-organize patch order, as suggested by Christoph
	- add one flag for checking if the disk is capable of bio polling
	  and remove .poll_capable(), as suggested by Christoph
	- fix type of .bi_poll

V5:
	- fix one use-after-free issue in case that polling is from another
	context: adds one new cookie of BLK_QC_T_NOT_READY for preventing
	this issue in patch 8/12
	- add reviewed-by & tested-by tag

V4:
	- cover one more test_bit(QUEUE_FLAG_POLL, ...) suggested by
	  Jeffle(01/12)
	- drop patch of 'block: add helper of blk_create_io_context'
	- add new helper of blk_create_io_poll_context() (03/12)
	- drain submission queues in exit_io_context(), suggested by
	  Jeffle(08/13)
	- considering shared io context case for blk_bio_poll_io_drain()
	(08/13)
	- fix one issue in blk_bio_poll_pack_groups() as suggested by
	Jeffle(08/13)
	- add reviewed-by tag
V3:
	- fix cookie returned for bio based driver, as suggested by Jeffle Xu
	- draining pending bios when submission context is exiting
	- patch style and comment fix, as suggested by Mike
	- allow poll context data to be NULL by always polling on submission queue
	- remove RFC, and reviewed-by

V2:
	- address queue depth scalability issue reported by Jeffle via bio
	group list. Reuse .bi_end_io for linking bios which share same
	.bi_end_io, and support 32 such groups in submit queue. With this way,
	the scalability issue caused by kfifio is solved. Before really
	ending bio, .bi_end_io is recovered from the group head.



Jeffle Xu (2):
  block: extract one helper function polling hw queue
  dm: support IO polling for bio-based dm device

Ming Lei (10):
  block: add helper of blk_queue_poll
  block: define 'struct bvec_iter' as packed
  block: add one helper to free io_context
  block: move block polling code into one dedicated source file
  block: prepare for supporting bio_list via other link
  block: create io poll context for submission and poll task
  block: add req flag of REQ_POLL_CTX
  block: use per-task poll context to implement bio based io polling
  block: limit hw queues to be polled in each blk_poll()
  block: allow to control FLAG_POLL via sysfs for bio poll capable queue

 block/Makefile                |   3 +-
 block/bio.c                   |   5 +
 block/blk-core.c              |  68 +++-
 block/blk-ioc.c               |  15 +-
 block/blk-mq.c                | 231 -------------
 block/blk-mq.h                |  40 +++
 block/blk-poll.c              | 632 ++++++++++++++++++++++++++++++++++
 block/blk-sysfs.c             |  16 +-
 block/blk.h                   | 112 ++++++
 drivers/md/dm-table.c         |  24 ++
 drivers/md/dm.c               |   2 +
 drivers/nvme/host/core.c      |   2 +-
 include/linux/bio.h           | 132 +++----
 include/linux/blk_types.h     |  31 +-
 include/linux/blkdev.h        |   1 +
 include/linux/bvec.h          |   2 +-
 include/linux/device-mapper.h |   1 +
 include/linux/genhd.h         |   2 +
 include/linux/iocontext.h     |   2 +
 19 files changed, 1003 insertions(+), 318 deletions(-)
 create mode 100644 block/blk-poll.c

-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

