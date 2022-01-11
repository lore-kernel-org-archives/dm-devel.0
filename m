Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 572B6C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 11 Jan 2022 16:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1641918034;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=IgmLKYT+pJNQcqlHQ8BKZnbHOY5Kjv2kap79aR/Ybhw=;
	b=LO6usznaZqWYLeUGcWeeN/gmSbSp8sSaxXlYAPdQwnaojpil702CRnYrKX4lG2Wfj6QLfR
	9OGtrmaFJYHIKGzZJO5fk5VCeNZcUx00xjju2p/ouHXEqQV9ZYQMsuuGtMVEScD911kAib
	zM1h8DiS9bEWB+Sw9C//vv0Cakm8GeM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-410-_M5lVHLDMe2PgGTNHoOAGg-1; Tue, 11 Jan 2022 11:20:30 -0500
X-MC-Unique: _M5lVHLDMe2PgGTNHoOAGg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 33E44101F01B;
	Tue, 11 Jan 2022 16:20:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4A482703B8;
	Tue, 11 Jan 2022 16:20:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 86B104BB7C;
	Tue, 11 Jan 2022 16:20:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20BGKIlC000431 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 11 Jan 2022 11:20:18 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 832B8C33AE7; Tue, 11 Jan 2022 16:20:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7EF30C33AE3
	for <dm-devel@redhat.com>; Tue, 11 Jan 2022 16:20:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 63CD680A0B8
	for <dm-devel@redhat.com>; Tue, 11 Jan 2022 16:20:18 +0000 (UTC)
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
	[209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-586-n0-TbG-2PAClBtUp2h6y9A-1; Tue, 11 Jan 2022 11:20:17 -0500
X-MC-Unique: n0-TbG-2PAClBtUp2h6y9A-1
Received: by mail-qv1-f69.google.com with SMTP id
	r2-20020a0562140c4200b00418e57a7b35so1974729qvj.3
	for <dm-devel@redhat.com>; Tue, 11 Jan 2022 08:20:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=CC1i5tpLMiW1d6bdv7f77XtvYY1n5qxfZPIldyU34eI=;
	b=yVocQL+Z9NhgqLt7T/1SzJB154ml+nckljRGvy/xIwJUNtC5ZUkYnhl1mvHMHOaxTP
	Hw6FivUkqWe4ahgG/rb2KC0Il/DJwLQR5nnk0U4hyK0WeEfrB71GUzX4H5pwirsU12Av
	L3p56e7VKUxLNPmmb0JzzVrHT8GN6zOSJN96UIcQFBKPjFBXvL6CbDPNfuBLXc6X7X00
	F38YQAddN4OHuhs2IrwFR6Ez0yleYsERBAO0nIfmRblFIT+Tyq2lcMHhsNPTyFX1J9vb
	7iWZOnnAFMpeBVILVcuDR89xJOzLiwqi33/8dw73IuZ667oAMkGb+xOFc5xsubL0Wsvp
	EYkw==
X-Gm-Message-State: AOAM531N9X306ggw0ZO7mzVQ5OVHqtqrtl9GSAt+QlGfpbZvcV4IFHqM
	jyUMWVF9XhKzxf2Zcyz8JSHdhver2EzfuWMrVV9yUcjG/BA6x5Ly3o8Q1Cih+s2ITcQqU8ckL/v
	G3cGWP63PGbhRbQ==
X-Received: by 2002:a05:622a:13ce:: with SMTP id
	p14mr4232669qtk.562.1641917712067; 
	Tue, 11 Jan 2022 08:15:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz9rn8Dc2sri+sXStNgRwr2Ijq9qi5yvFpyULm8k4zkoftteb5wEjtKYGDbnDA0U+OKT8LYwQ==
X-Received: by 2002:a05:622a:13ce:: with SMTP id
	p14mr4232630qtk.562.1641917711671; 
	Tue, 11 Jan 2022 08:15:11 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	j13sm7195820qta.76.2022.01.11.08.15.10
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 11 Jan 2022 08:15:11 -0800 (PST)
Date: Tue, 11 Jan 2022 11:15:09 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>
Message-ID: <Yd2tDWuP+aT3Hxbj@redhat.com>
References: <20211221141459.1368176-1-ming.lei@redhat.com>
	<YcH/E4JNag0QYYAa@infradead.org> <YcP4FMG9an5ReIiV@T590>
	<YcuB4K8P2d9WFb83@redhat.com> <Yd1BFpYTBlQSPReW@infradead.org>
MIME-Version: 1.0
In-Reply-To: <Yd1BFpYTBlQSPReW@infradead.org>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
	Ming Lei <ming.lei@redhat.com>
Subject: Re: [dm-devel] [PATCH 0/3] blk-mq/dm-rq: support BLK_MQ_F_BLOCKING
	for dm-rq
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jan 11 2022 at  3:34P -0500,
Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, Dec 28, 2021 at 04:30:08PM -0500, Mike Snitzer wrote:
> > Yeah, people use request-based for IO scheduling and more capable path
> > selectors. Imposing bio-based would be a pretty jarring workaround for 
> > BLK_MQ_F_BLOCKING. request-based DM should properly support it.
> 
> Given that nvme-tcp is the only blocking driver that has multipath
> driver that driver explicitly does not intend to support dm-multipath
> I'm absolutely against adding block layer cruft for this particular
> use case.

this diffstat amounts to what you call "cruft":

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

> SCSI even has this:
> 
> 	        /*
> 		 * SCSI never enables blk-mq's BLK_MQ_F_BLOCKING flag so
> 		 * calling synchronize_rcu() once is enough.
> 		 */
> 		WARN_ON_ONCE(shost->tag_set.flags & BLK_MQ_F_BLOCKING);
> 

Round and round we go.. Pretty tired of this.

You are perfectly fine with incrementally compromising request-based
DM's ability to evolve as block core does.

Seriously, this patchset shouldn't warrant bickering:
https://patchwork.kernel.org/project/dm-devel/list/?series=598823

Jens, this incremental weakening of what it is that DM is allowed to
do is not something I can continue to work with (nor should Ming's or
others' contributions be rejected for such reasons).

This tribal war needs to stop.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

