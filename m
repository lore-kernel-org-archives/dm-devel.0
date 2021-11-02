Return-Path: <SRS0=3wtw=PV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91E2FC433F5
	for <dm-devel@archiver.kernel.org>; Tue,  2 Nov 2021 01:57:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1A49460724
	for <dm-devel@archiver.kernel.org>; Tue,  2 Nov 2021 01:57:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1A49460724
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=hansenpartnership.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-mQ7rFBHRNayjyBi3aBrtBQ-1; Mon, 01 Nov 2021 21:57:15 -0400
X-MC-Unique: mQ7rFBHRNayjyBi3aBrtBQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 95079802682;
	Tue,  2 Nov 2021 01:57:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F4E9104A9C1;
	Tue,  2 Nov 2021 01:57:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E3EBE1806D03;
	Tue,  2 Nov 2021 01:57:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A21qc6w016558 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 1 Nov 2021 21:52:38 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 07E9F51E4; Tue,  2 Nov 2021 01:52:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 027D351DC
	for <dm-devel@redhat.com>; Tue,  2 Nov 2021 01:52:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 00CAD8011A5
	for <dm-devel@redhat.com>; Tue,  2 Nov 2021 01:52:34 +0000 (UTC)
Received: from bedivere.hansenpartnership.com
	(bedivere.hansenpartnership.com [96.44.175.130]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-316-wA8FmjBaP3qR1Ca3k0aJzg-1;
	Mon, 01 Nov 2021 21:52:32 -0400
X-MC-Unique: wA8FmjBaP3qR1Ca3k0aJzg-1
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id C82DB1280A86; 
	Mon,  1 Nov 2021 21:43:30 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
	by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new,
	port 10024)
	with ESMTP id woUwEHJk3ESK; Mon,  1 Nov 2021 21:43:30 -0400 (EDT)
Received: from [172.20.40.112] (unknown [12.248.214.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id
	187A912809EF; Mon,  1 Nov 2021 21:43:30 -0400 (EDT)
Message-ID: <10c279f54ed0b24cb1ac0861f9a407e6b64f64da.camel@HansenPartnership.com>
From: James Bottomley <James.Bottomley@hansenpartnership.com>
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Date: Mon, 01 Nov 2021 21:43:27 -0400
In-Reply-To: <20211021145918.2691762-3-ming.lei@redhat.com>
References: <20211021145918.2691762-1-ming.lei@redhat.com>
	<20211021145918.2691762-3-ming.lei@redhat.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, 2021-10-21 at 22:59 +0800, Ming Lei wrote:
> For fixing queue quiesce race between driver and block layer(elevator
> switch, update nr_requests, ...), we need to support concurrent
> quiesce
> and unquiesce, which requires the two call balanced.
> 
> It isn't easy to audit that in all scsi drivers, especially the two
> may
> be called from different contexts, so do it in scsi core with one
> per-device
> bit flag & global spinlock, basically zero cost since request queue
> quiesce
> is seldom triggered.
> 
> Reported-by: Yi Zhang <yi.zhang@redhat.com>
> Fixes: e70feb8b3e68 ("blk-mq: support concurrent queue
> quiesce/unquiesce")
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/scsi/scsi_lib.c    | 45 ++++++++++++++++++++++++++++++----
> ----
>  include/scsi/scsi_device.h |  1 +
>  2 files changed, 37 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 51fcd46be265..414f4daf8005 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2638,6 +2638,40 @@ static int
> __scsi_internal_device_block_nowait(struct scsi_device *sdev)
>  	return 0;
>  }
>  
> +static DEFINE_SPINLOCK(sdev_queue_stop_lock);
> +
> +void scsi_start_queue(struct scsi_device *sdev)
> +{
> +	bool need_start;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&sdev_queue_stop_lock, flags);
> +	need_start = sdev->queue_stopped;
> +	sdev->queue_stopped = 0;
> +	spin_unlock_irqrestore(&sdev_queue_stop_lock, flags);
> +
> +	if (need_start)
> +		blk_mq_unquiesce_queue(sdev->request_queue);

Well, this is a classic atomic pattern:

if (cmpxchg(&sdev->queue_stopped, 1, 0))
	blk_mq_unquiesce_queue(sdev->request_queue);

The reason to do it with atomics rather than spinlocks is

   1. no need to disable interrupts: atomics are locked
   2. faster because a spinlock takes an exclusive line every time but the
      read to check the value can be in shared mode in cmpxchg
   3. it's just shorter and better code.

The only minor downside is queue_stopped now needs to be a u32.

James


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

