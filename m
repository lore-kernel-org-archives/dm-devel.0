Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35AE9C433F5
	for <dm-devel@archiver.kernel.org>; Sun, 16 Jan 2022 05:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1642312503;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=q3WTLsJLPgQRzJfFKprK4W36ezo7lBT7uiOAUTuv0mg=;
	b=UiSOiL+87CvorfInrrllcQ6MGMtKEJr/bidoKP2v6U5D+9RNo/XuYSvfSVEj/CT8KFm/lU
	jGp8UhW+QcxPtB0zelaNiPQB+8cEv5vXAgpzYOsZHkiJLr4SL0pwuaomJOHQkKsYvlgWlQ
	nTH3//PlS7hsf7nk7QTEGoa917ACZEM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-JFSh0ppvO92pxXMUiy-rIw-1; Sun, 16 Jan 2022 00:54:59 -0500
X-MC-Unique: JFSh0ppvO92pxXMUiy-rIw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BBE581083F65;
	Sun, 16 Jan 2022 05:54:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E6944EC80;
	Sun, 16 Jan 2022 05:54:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3672C4BB7C;
	Sun, 16 Jan 2022 05:54:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20G5qnPc024950 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 16 Jan 2022 00:52:49 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7727640CFD14; Sun, 16 Jan 2022 05:52:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 71BA940CFD0E
	for <dm-devel@redhat.com>; Sun, 16 Jan 2022 05:52:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 56D54811E76
	for <dm-devel@redhat.com>; Sun, 16 Jan 2022 05:52:49 +0000 (UTC)
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
	[209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-295-sgz97wf8N4a44EsA_LccYw-1; Sun, 16 Jan 2022 00:52:47 -0500
X-MC-Unique: sgz97wf8N4a44EsA_LccYw-1
Received: by mail-lf1-f69.google.com with SMTP id
	u26-20020a056512041a00b0042fcdc4f7baso4575569lfk.16
	for <dm-devel@redhat.com>; Sat, 15 Jan 2022 21:52:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=rtGcbX0FFehzAReINNuQ6O8FDdfNIai2TerZhtHAlXw=;
	b=AuDEvKGey2SfiSNBLkEGBnDP/FJ9w/hmKABA0UbNvRZ3AS1j+lvz8/hVoJJaxQgziW
	6kB4fO2T3uwKl8DBT6UtmTcrIvh8RWvA8XOOXJpeS0yxrPgjoNYfkRgMAxrolJzKNDrZ
	Np3hXW8Ohxqx8ai89q6R/cL5ceRD+Lu+j3n6zbl5L2NG0PkDmug1DVeXo9AnxDpWyeHa
	xVwcLEpXsvFPOhMNDRHQ9kY2eX5t083rhXU+BbsAqSVX4jBoEXjgS1c97V+VUj4PoTnC
	30KeQ2UjjdWsxwSjY1csucl8R7ofDuECpVXHxDeGC4qVeow08XjJO9BqZkgKQWJJq1px
	baaw==
X-Gm-Message-State: AOAM532FGfXP/pWPizBhPnUIwbSdw/e1BUpASqTFjo4QskPgKTAzB13t
	S9XC9xkID/Qo1McIPTWDy7s0VSCt6OpweXcW2o0oyKfVncWp392LZyN8rqY3rZAt9bAKL019cBm
	g4Q17ihaLO8k8vicnjBiaPiYO9s2MUDw=
X-Received: by 2002:a2e:86c7:: with SMTP id n7mr8859068ljj.102.1642312366372; 
	Sat, 15 Jan 2022 21:52:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzGUz+a8d1wdqPHmKhdS96L2yWChhcIzoVksQ8ZNdwiTXzFHRetksucdS0IhpyzjobalCDaP6xB+AB3dBfpF2w=
X-Received: by 2002:a2e:86c7:: with SMTP id n7mr8859060ljj.102.1642312366152; 
	Sat, 15 Jan 2022 21:52:46 -0800 (PST)
MIME-Version: 1.0
References: <1642183128-17875-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1642183128-17875-1-git-send-email-bmarzins@redhat.com>
From: Ming Lei <ming.lei@redhat.com>
Date: Sun, 16 Jan 2022 13:52:33 +0800
Message-ID: <CAFj5m9KYyQP_HR9HcXY3h2tyLFHoJBA6CW3pr8JRmEGsL7QSkA@mail.gmail.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] [PATCH] dm rq: clear cloned bio ->bi_bdev to fix I/O
	accounting
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Jan 15, 2022 at 1:59 AM Benjamin Marzinski <bmarzins@redhat.com> wrote:
>
> bio_clone_fast() sets the cloned bio to have the same ->bi_bdev as the
> source bio. This means that when request-based dm called setup_clone(),
> the cloned bio had its ->bi_bdev pointing to the dm device. After Commit
> 0b6e522cdc4a ("blk-mq: use ->bi_bdev for I/O accounting")
> __blk_account_io_start() started using the request's ->bio->bi_bdev for
> I/O accounting, if it was set. This caused IO going to the underlying
> devices to use the dm device for their I/O accounting.
>
> Request-based dm can't be used on top of partitions, so
> dm_rq_bio_constructor() can just clear the cloned bio's ->bi_bdev and
> have __blk_account_io_start() fall back to using rq->rq_disk->part0 for
> the I/O accounting.
>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  drivers/md/dm-rq.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
> index 579ab6183d4d..42099dc76e3c 100644
> --- a/drivers/md/dm-rq.c
> +++ b/drivers/md/dm-rq.c
> @@ -328,6 +328,7 @@ static int dm_rq_bio_constructor(struct bio *bio, struct bio *bio_orig,
>         info->orig = bio_orig;
>         info->tio = tio;
>         bio->bi_end_io = end_clone_bio;
> +       bio->bi_bdev = NULL;

Reviewed-by: Ming Lei <ming.lei@redhat.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

