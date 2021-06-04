Return-Path: <SRS0=uf5V=K6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04155C07E94
	for <dm-devel@archiver.kernel.org>; Fri,  4 Jun 2021 14:57:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 84FA36140F
	for <dm-devel@archiver.kernel.org>; Fri,  4 Jun 2021 14:57:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 84FA36140F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1622818643;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=B0lWOzJ0SaUyB7F0N7oND15fD8Ub89GzSsrPLOuY7io=;
	b=Mls4htPY10OYlwVsn4Qcjxevtaju2MF3Fw5L/Tq8nzsbj1NZeq6QS/2AbjhH9ExITfgDuQ
	YDGH4kuYIHuvUdUz8EPyc1ESXYHblbj4Tk8Htv+I44aqRBdzy6HkyAvSFPSTRsQPwiCOln
	lxBKBq55jIzjTg+gkJPl4AxaoLtCUns=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-nZ7lzaNJOQSULY-n17xFgA-1; Fri, 04 Jun 2021 10:57:20 -0400
X-MC-Unique: nZ7lzaNJOQSULY-n17xFgA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 388B8818428;
	Fri,  4 Jun 2021 14:56:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 958171037F29;
	Fri,  4 Jun 2021 14:56:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 850371801264;
	Fri,  4 Jun 2021 14:56:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 154Eurjf004536 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Jun 2021 10:56:53 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 4B9E611FC79; Fri,  4 Jun 2021 14:56:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 462A011FC69
	for <dm-devel@redhat.com>; Fri,  4 Jun 2021 14:56:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0ED7980D0E1
	for <dm-devel@redhat.com>; Fri,  4 Jun 2021 14:56:51 +0000 (UTC)
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com
	[209.85.222.177]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-478-h8NH09HHMtyWA7eGzQnTxw-1; Fri, 04 Jun 2021 10:56:47 -0400
X-MC-Unique: h8NH09HHMtyWA7eGzQnTxw-1
Received: by mail-qk1-f177.google.com with SMTP id 76so9540354qkn.13
	for <dm-devel@redhat.com>; Fri, 04 Jun 2021 07:56:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=EapXRX7qql2t5NiRCxLGNSnGSE7Dr4V6203P39laPVo=;
	b=WzRlBkTuSd6AV13V9RBi22DJGaHoeQFggfN7rQxSWr7u18k9vJT3mfFXToCA1kFs6L
	0pj586B3sT/iL9uhO4mBBgb7MJG5OjleqLGEXnOJoLKaHNBiW9i8WdJ12rIxtwTG+YPa
	Dw5FprZoMq4cpwHMSKnfLbscwrovugCt1h3QKymm6pASmftYPeEvPEtzLWzvi6YQXyUx
	SQ44yx5qC0TZKYQyWyjhXybPEkTuOyvTOz3SjdnZ6iG4ha3r6oC9qhcyIesm350b9i/3
	Jxf9YS7IwBHVH6qIaGd383fBYRbMMNgj94N3FihxtjfL5fZa89V8D56b7DqORMF+KNeQ
	AJpg==
X-Gm-Message-State: AOAM533UaN/2K6ZR8Y9a2CshK9oTYCmLEyXMZxnRjY3mjZfLFiY3PCGK
	TOE1tdDMK2JE4HhSgU4c/is=
X-Google-Smtp-Source: ABdhPJz6/z6e+EgsHYGDYUsKt8ZrSz5fJbQL+2toCpf6BzaXBJV/8e0HBaIJ8Y3mqC56GLU87PDYRg==
X-Received: by 2002:a05:620a:30d:: with SMTP id
	s13mr4761020qkm.58.1622818606772; 
	Fri, 04 Jun 2021 07:56:46 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	p14sm4154956qki.27.2021.06.04.07.56.45
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 04 Jun 2021 07:56:45 -0700 (PDT)
Date: Fri, 4 Jun 2021 10:56:44 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Damien Le Moal <damien.lemoal@wdc.com>
Message-ID: <YLo/LO32+rdrfygC@redhat.com>
References: <20210525212501.226888-1-damien.lemoal@wdc.com>
	<20210525212501.226888-9-damien.lemoal@wdc.com>
MIME-Version: 1.0
In-Reply-To: <20210525212501.226888-9-damien.lemoal@wdc.com>
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
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v5 08/11] dm: Forbid requeue of writes to
	zones
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

On Tue, May 25 2021 at  5:24P -0400,
Damien Le Moal <damien.lemoal@wdc.com> wrote:

> A target map method requesting the requeue of a bio with
> DM_MAPIO_REQUEUE or completing it with DM_ENDIO_REQUEUE can cause
> unaligned write errors if the bio is a write operation targeting a
> sequential zone. If a zoned target request such a requeue, warn about
> it and kill the IO.
> 
> The function dm_is_zone_write() is introduced to detect write operations
> to zoned targets.
> 
> This change does not affect the target drivers supporting zoned devices
> and exposing a zoned device, namely dm-crypt, dm-linear and dm-flakey as
> none of these targets ever request a requeue.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
> ---
>  drivers/md/dm-zone.c | 17 +++++++++++++++++
>  drivers/md/dm.c      | 18 +++++++++++++++---
>  drivers/md/dm.h      |  5 +++++
>  3 files changed, 37 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
> index b42474043249..edc3bbb45637 100644
> --- a/drivers/md/dm-zone.c
> +++ b/drivers/md/dm-zone.c
> @@ -104,6 +104,23 @@ int dm_report_zones(struct block_device *bdev, sector_t start, sector_t sector,
>  }
>  EXPORT_SYMBOL_GPL(dm_report_zones);
>  
> +bool dm_is_zone_write(struct mapped_device *md, struct bio *bio)
> +{
> +	struct request_queue *q = md->queue;
> +
> +	if (!blk_queue_is_zoned(q))
> +		return false;
> +
> +	switch (bio_op(bio)) {
> +	case REQ_OP_WRITE_ZEROES:
> +	case REQ_OP_WRITE_SAME:
> +	case REQ_OP_WRITE:
> +		return !op_is_flush(bio->bi_opf) && bio_sectors(bio);
> +	default:
> +		return false;
> +	}
> +}
> +
>  void dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q)
>  {
>  	if (!blk_queue_is_zoned(q))
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index c49976cc4e44..ed8c5a8df2e5 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -846,11 +846,15 @@ static void dec_pending(struct dm_io *io, blk_status_t error)
>  			 * Target requested pushing back the I/O.
>  			 */
>  			spin_lock_irqsave(&md->deferred_lock, flags);
> -			if (__noflush_suspending(md))
> +			if (__noflush_suspending(md) &&
> +			    !WARN_ON_ONCE(dm_is_zone_write(md, bio)))
>  				/* NOTE early return due to BLK_STS_DM_REQUEUE below */
>  				bio_list_add_head(&md->deferred, io->orig_bio);
>  			else
> -				/* noflush suspend was interrupted. */
> +				/*
> +				 * noflush suspend was interrupted or this is
> +				 * a write to a zoned target.
> +				 */
>  				io->status = BLK_STS_IOERR;
>  			spin_unlock_irqrestore(&md->deferred_lock, flags);
>  		}

So I now see this incremental fix:
https://patchwork.kernel.org/project/dm-devel/patch/20210604004703.408562-1-damien.lemoal@opensource.wdc.com/

And I've folded it in...

> @@ -947,7 +951,15 @@ static void clone_endio(struct bio *bio)
>  		int r = endio(tio->ti, bio, &error);
>  		switch (r) {
>  		case DM_ENDIO_REQUEUE:
> -			error = BLK_STS_DM_REQUEUE;
> +			/*
> +			 * Requeuing writes to a sequential zone of a zoned
> +			 * target will break the sequential write pattern:
> +			 * fail such IO.
> +			 */
> +			if (WARN_ON_ONCE(dm_is_zone_write(md, bio)))
> +				error = BLK_STS_IOERR;
> +			else
> +				error = BLK_STS_DM_REQUEUE;
>  			fallthrough;
>  		case DM_ENDIO_DONE:
>  			break;

But I'm left wondering why dec_pending, now dm_io_dec_pending, needs
to be modified to also check dm_is_zone_write() if clone_endio() is
already dealing with it?

Not that big a deal, just not loving how we're sprinkling special
zoned code around...

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

