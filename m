Return-Path: <SRS0=3wtw=PV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7E20C433EF
	for <dm-devel@archiver.kernel.org>; Tue,  2 Nov 2021 13:05:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7E58D610A0
	for <dm-devel@archiver.kernel.org>; Tue,  2 Nov 2021 13:05:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7E58D610A0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1635858308;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6LJ6MkOB8bAi/XxM0X0MqEIV2E8z2REDItwYl/MZyyk=;
	b=CjK8deEhrDk/uC8OIbVmqywCLkynLLHSGpayAtqvOyoRh9pMVO7Hv4sy1c49zsTnuySKgs
	odDgtKLZq1dWExj7lChO1ui0VACpCPCd1d9SQRXeWfBQ7Jr2sZNB71pZ7luoS5ff+jjuHY
	+Fk1gfuRV3Ns9rG+HzglnVWMJrWZLRw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-81-GeXAEfUuMEWgwbkwMsGYMA-1; Tue, 02 Nov 2021 09:05:05 -0400
X-MC-Unique: GeXAEfUuMEWgwbkwMsGYMA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F9C41923761;
	Tue,  2 Nov 2021 13:04:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 51D7C101E589;
	Tue,  2 Nov 2021 13:04:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 807884E58F;
	Tue,  2 Nov 2021 13:04:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A2Cwx2q014051 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 2 Nov 2021 08:58:59 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id B02BF18432; Tue,  2 Nov 2021 12:58:59 +0000 (UTC)
Received: from T590 (ovpn-8-19.pek2.redhat.com [10.72.8.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 379F95D740;
	Tue,  2 Nov 2021 12:58:05 +0000 (UTC)
Date: Tue, 2 Nov 2021 20:58:01 +0800
From: Ming Lei <ming.lei@redhat.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Message-ID: <YYE12XJ66QWpr4Fo@T590>
References: <20211021145918.2691762-1-ming.lei@redhat.com>
	<20211021145918.2691762-3-ming.lei@redhat.com>
	<10c279f54ed0b24cb1ac0861f9a407e6b64f64da.camel@HansenPartnership.com>
MIME-Version: 1.0
In-Reply-To: <10c279f54ed0b24cb1ac0861f9a407e6b64f64da.camel@HansenPartnership.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Yi Zhang <yi.zhang@redhat.com>,
	linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [dm-devel] [PATCH 2/3] scsi: make sure that request queue
 queiesce and unquiesce balanced
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi James,

On Mon, Nov 01, 2021 at 09:43:27PM -0400, James Bottomley wrote:
> On Thu, 2021-10-21 at 22:59 +0800, Ming Lei wrote:
> > For fixing queue quiesce race between driver and block layer(elevator
> > switch, update nr_requests, ...), we need to support concurrent
> > quiesce
> > and unquiesce, which requires the two call balanced.
> > 
> > It isn't easy to audit that in all scsi drivers, especially the two
> > may
> > be called from different contexts, so do it in scsi core with one
> > per-device
> > bit flag & global spinlock, basically zero cost since request queue
> > quiesce
> > is seldom triggered.
> > 
> > Reported-by: Yi Zhang <yi.zhang@redhat.com>
> > Fixes: e70feb8b3e68 ("blk-mq: support concurrent queue
> > quiesce/unquiesce")
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >  drivers/scsi/scsi_lib.c    | 45 ++++++++++++++++++++++++++++++----
> > ----
> >  include/scsi/scsi_device.h |  1 +
> >  2 files changed, 37 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index 51fcd46be265..414f4daf8005 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -2638,6 +2638,40 @@ static int
> > __scsi_internal_device_block_nowait(struct scsi_device *sdev)
> >  	return 0;
> >  }
> >  
> > +static DEFINE_SPINLOCK(sdev_queue_stop_lock);
> > +
> > +void scsi_start_queue(struct scsi_device *sdev)
> > +{
> > +	bool need_start;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&sdev_queue_stop_lock, flags);
> > +	need_start = sdev->queue_stopped;
> > +	sdev->queue_stopped = 0;
> > +	spin_unlock_irqrestore(&sdev_queue_stop_lock, flags);
> > +
> > +	if (need_start)
> > +		blk_mq_unquiesce_queue(sdev->request_queue);
> 
> Well, this is a classic atomic pattern:
> 
> if (cmpxchg(&sdev->queue_stopped, 1, 0))
> 	blk_mq_unquiesce_queue(sdev->request_queue);
> 
> The reason to do it with atomics rather than spinlocks is
> 
>    1. no need to disable interrupts: atomics are locked
>    2. faster because a spinlock takes an exclusive line every time but the
>       read to check the value can be in shared mode in cmpxchg
>    3. it's just shorter and better code.

You are right, I agree.

> 
> The only minor downside is queue_stopped now needs to be a u32.

Yeah, that is the reason I don't take this atomic way since it needs to
add one extra u32 into 'struct scsi_device'.


Thanks,
Ming

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

