Return-Path: <SRS0=s6zu=FE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 641D1C63777
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 18:12:13 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 94AFE2074A
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 18:12:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 94AFE2074A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-tRhZoZx-MUSGXwAb8BNEYg-1; Mon, 30 Nov 2020 13:12:02 -0500
X-MC-Unique: tRhZoZx-MUSGXwAb8BNEYg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E24BC8797E4;
	Mon, 30 Nov 2020 18:11:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C43A1A8A0;
	Mon, 30 Nov 2020 18:11:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A4D104A7C6;
	Mon, 30 Nov 2020 18:11:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AUIBrep010544 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 30 Nov 2020 13:11:53 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1665F111143A; Mon, 30 Nov 2020 18:11:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 124D6100320C
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 18:11:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A800D80B2AB
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 18:11:50 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-97-hCk_EuyBNjisJ07uF97eYw-1; Mon, 30 Nov 2020 13:11:47 -0500
X-MC-Unique: hCk_EuyBNjisJ07uF97eYw-1
Received: from 089144198196.atnat0007.highway.a1.net ([89.144.198.196]
	helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1kjnU2-0006Rv-GW; Mon, 30 Nov 2020 18:01:06 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Mon, 30 Nov 2020 18:58:49 +0100
Message-Id: <20201130175854.982460-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	casper.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
	dm-devel@redhat.com, linux-s390@vger.kernel.org
Subject: [dm-devel] block tracepoint cleanups
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Jens,

this series cleans up the block layer tracepoints by removing unused
tracepoints or tracepoint arguments and consolidating the implementation
of various bio based tracepoints.

Diffstat:
 block/blk-core.c              |    4 
 block/blk-merge.c             |    8 -
 block/blk-mq-sched.c          |    2 
 block/blk-mq.c                |   10 -
 block/bounce.c                |    2 
 drivers/md/dm-rq.c            |    2 
 drivers/md/dm.c               |    5 
 drivers/md/md-linear.c        |    3 
 drivers/md/md.c               |    5 
 drivers/md/raid0.c            |    4 
 drivers/md/raid1.c            |    7 -
 drivers/md/raid10.c           |    6 -
 drivers/md/raid5.c            |   15 +-
 drivers/nvme/host/multipath.c |    3 
 drivers/s390/scsi/zfcp_fsf.c  |    3 
 include/linux/blktrace_api.h  |    5 
 include/trace/events/block.h  |  228 +++++++++---------------------------------
 kernel/trace/blktrace.c       |  126 ++++++-----------------
 18 files changed, 125 insertions(+), 313 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

