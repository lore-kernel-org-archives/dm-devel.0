Return-Path: <SRS0=3wtw=PV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6361EC433F5
	for <dm-devel@archiver.kernel.org>; Tue,  2 Nov 2021 14:49:55 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B06B161205
	for <dm-devel@archiver.kernel.org>; Tue,  2 Nov 2021 14:49:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B06B161205
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=hansenpartnership.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-H4pFzW-EOFypL4Vb1Zcvvw-1; Tue, 02 Nov 2021 10:49:52 -0400
X-MC-Unique: H4pFzW-EOFypL4Vb1Zcvvw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 371841015DBC;
	Tue,  2 Nov 2021 14:49:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D9C51B5C2;
	Tue,  2 Nov 2021 14:49:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E8F07181A1CF;
	Tue,  2 Nov 2021 14:49:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A2Em8s5026313 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 2 Nov 2021 10:48:08 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 40E4851E4; Tue,  2 Nov 2021 14:48:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B41D51E1
	for <dm-devel@redhat.com>; Tue,  2 Nov 2021 14:48:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 073E918A01A5
	for <dm-devel@redhat.com>; Tue,  2 Nov 2021 14:48:03 +0000 (UTC)
Received: from bedivere.hansenpartnership.com
	(bedivere.hansenpartnership.com [96.44.175.130]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-264-5jA6P3XfMPOoPXpV6zJqQQ-1;
	Tue, 02 Nov 2021 10:47:57 -0400
X-MC-Unique: 5jA6P3XfMPOoPXpV6zJqQQ-1
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id C205A128065E; 
	Tue,  2 Nov 2021 10:47:55 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
	by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new,
	port 10024)
	with ESMTP id H6rrzm6rGiUZ; Tue,  2 Nov 2021 10:47:55 -0400 (EDT)
Received: from jarvis.int.hansenpartnership.com
	(c-67-166-174-65.hsd1.va.comcast.net [67.166.174.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id
	DBDF81280129; Tue,  2 Nov 2021 10:47:54 -0400 (EDT)
Message-ID: <461ac99c7d9d4493f37d2b8377ec3f05ce8a2735.camel@HansenPartnership.com>
From: James Bottomley <James.Bottomley@hansenpartnership.com>
To: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>
Date: Tue, 02 Nov 2021 10:47:53 -0400
In-Reply-To: <042056b5-6fea-1bcf-bfae-274f23e9e5c5@kernel.dk>
References: <20211021145918.2691762-1-ming.lei@redhat.com>
	<20211021145918.2691762-3-ming.lei@redhat.com>
	<10c279f54ed0b24cb1ac0861f9a407e6b64f64da.camel@HansenPartnership.com>
	<8cbc1be6-15a5-ed34-53f1-081a05025d34@kernel.dk>
	<a7bae1c4c3d6b08487b96cb3aa86d4fab1a0abcc.camel@HansenPartnership.com>
	<1ab71603-0104-2071-02c9-d6c22e3aa275@kernel.dk>
	<042056b5-6fea-1bcf-bfae-274f23e9e5c5@kernel.dk>
User-Agent: Evolution 3.34.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: Mike, Yi Zhang <yi.zhang@redhat.com>, linux-scsi@vger.kernel.org,
	Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, "Martin K . Petersen" <martin.petersen@oracle.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, 2021-11-02 at 08:41 -0600, Jens Axboe wrote:
> On 11/2/21 8:36 AM, Jens Axboe wrote:
> > On 11/2/21 8:33 AM, James Bottomley wrote:
> > > On Tue, 2021-11-02 at 06:59 -0600, Jens Axboe wrote:
> > > > On 11/1/21 7:43 PM, James Bottomley wrote:
> > > > > On Thu, 2021-10-21 at 22:59 +0800, Ming Lei wrote:
> > > > > > For fixing queue quiesce race between driver and block
> > > > > > layer(elevator switch, update nr_requests, ...), we need to
> > > > > > support concurrent quiesce and unquiesce, which requires
> > > > > > the two
> > > > > > call balanced.
> > > > > > 
> > > > > > It isn't easy to audit that in all scsi drivers, especially
> > > > > > the two may be called from different contexts, so do it in
> > > > > > scsi core with one per-device bit flag & global spinlock,
> > > > > > basically zero cost since request queue quiesce is seldom
> > > > > > triggered.
> > > > > > 
> > > > > > Reported-by: Yi Zhang <yi.zhang@redhat.com>
> > > > > > Fixes: e70feb8b3e68 ("blk-mq: support concurrent queue
> > > > > > quiesce/unquiesce")
> > > > > > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > > > > > ---
> > > > > >  drivers/scsi/scsi_lib.c    | 45
> > > > > > ++++++++++++++++++++++++++++++
> > > > > > ----
> > > > > > ----
> > > > > >  include/scsi/scsi_device.h |  1 +
> > > > > >  2 files changed, 37 insertions(+), 9 deletions(-)
> > > > > > 
> > > > > > diff --git a/drivers/scsi/scsi_lib.c
> > > > > > b/drivers/scsi/scsi_lib.c
> > > > > > index 51fcd46be265..414f4daf8005 100644
> > > > > > --- a/drivers/scsi/scsi_lib.c
> > > > > > +++ b/drivers/scsi/scsi_lib.c
> > > > > > @@ -2638,6 +2638,40 @@ static int
> > > > > > __scsi_internal_device_block_nowait(struct scsi_device
> > > > > > *sdev)
> > > > > >  	return 0;
> > > > > >  }
> > > > > >  
> > > > > > +static DEFINE_SPINLOCK(sdev_queue_stop_lock);
> > > > > > +
> > > > > > +void scsi_start_queue(struct scsi_device *sdev)
> > > > > > +{
> > > > > > +	bool need_start;
> > > > > > +	unsigned long flags;
> > > > > > +
> > > > > > +	spin_lock_irqsave(&sdev_queue_stop_lock, flags);
> > > > > > +	need_start = sdev->queue_stopped;
> > > > > > +	sdev->queue_stopped = 0;
> > > > > > +	spin_unlock_irqrestore(&sdev_queue_stop_lock, flags);
> > > > > > +
> > > > > > +	if (need_start)
> > > > > > +		blk_mq_unquiesce_queue(sdev->request_queue);
> > > > > 
> > > > > Well, this is a classic atomic pattern:
> > > > > 
> > > > > if (cmpxchg(&sdev->queue_stopped, 1, 0))
> > > > > 	blk_mq_unquiesce_queue(sdev->request_queue);
> > > > > 
> > > > > The reason to do it with atomics rather than spinlocks is
> > > > > 
> > > > >    1. no need to disable interrupts: atomics are locked
> > > > >    2. faster because a spinlock takes an exclusive line every
> > > > > time but the
> > > > >       read to check the value can be in shared mode in
> > > > > cmpxchg
> > > > >    3. it's just shorter and better code.
> > > > > 
> > > > > The only minor downside is queue_stopped now needs to be a
> > > > > u32.
> > > > 
> > > > Are you fine with the change as-is, or do you want it redone? I
> > > > can drop the SCSI parts and just queue up the dm fix.
> > > > Personally I think it'd be better to get it fixed upfront.
> > > 
> > > Well, given the path isn't hot, I don't really care.  However,
> > > what I don't want is to have to continually bat back patches from
> > > the make work code churners trying to update this code for being
> > > the wrong pattern.  I think at the very least it needs a comment
> > > saying why we chose a suboptimal pattern to try to forestall
> > > this.
> > 
> > Right, with a comment it's probably better. And as you said, since
> > it's not a hot path, don't think we'd be revisiting it anyway.
> > 
> > I'll amend the patch with a comment.
> 
> I started adding the comment and took another look at this, and that
> made me change my mind. We really should make this a cmpxcgh, it's
> not even using a device lock here.
> 
> I've dropped the two SCSI patches for now, Ming can you resend? If
> James agrees, I really think queue_stopped should just have the type
> changed and the patch redone with that using cmpxcgh().

Well, that's what I suggested originally, so I agree ... I don't think
31 more bytes is going to be a huge burden to scsi_device.

James


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

