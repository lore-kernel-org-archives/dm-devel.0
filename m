Return-Path: <SRS0=LVdJ=HP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 658E9C433E0
	for <dm-devel@archiver.kernel.org>; Sat, 13 Feb 2021 14:52:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C29DE64DE7
	for <dm-devel@archiver.kernel.org>; Sat, 13 Feb 2021 14:52:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C29DE64DE7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-x7GzyjiNNSad2SJexWu6gg-1; Sat, 13 Feb 2021 09:52:55 -0500
X-MC-Unique: x7GzyjiNNSad2SJexWu6gg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9DE15427D1;
	Sat, 13 Feb 2021 14:52:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AF94260855;
	Sat, 13 Feb 2021 14:52:49 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0A32A18095CB;
	Sat, 13 Feb 2021 14:52:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11DEqlQM017648 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 13 Feb 2021 09:52:47 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DC65810070AF; Sat, 13 Feb 2021 14:52:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D859F1003213
	for <dm-devel@redhat.com>; Sat, 13 Feb 2021 14:52:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B960800C81
	for <dm-devel@redhat.com>; Sat, 13 Feb 2021 14:52:44 +0000 (UTC)
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com
	[209.85.166.41]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-206-Yoh6_BJUNFKgoYWHBraafQ-1; Sat, 13 Feb 2021 09:52:42 -0500
X-MC-Unique: Yoh6_BJUNFKgoYWHBraafQ-1
Received: by mail-io1-f41.google.com with SMTP id e133so2260388iof.8
	for <dm-devel@redhat.com>; Sat, 13 Feb 2021 06:52:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=nZDJw6Sn8s3t0+Hv8hFRdOYU9AqCIvryt88cY5O1DkE=;
	b=eGZlX0sR+5Dn2wzYwq3z+/z8AQ/xp3OaClimNJ7nrJNNH2FHvcu7J2EnKqHRkmqZa1
	q39vSj1lir+IN+kXYBcMaUsz/351wogerZ+1kM6jn65nmbHBUsJc6je1G9N4vq0bjRhG
	mkpAYc6Lqq0DwTb9nvCrMWR1SR2jBBfLWdIkDFuG+4vkLFABpQkzyvFLb0b16hyicdbz
	oV+YRocFGAQlPCxtvaixI/sYKn6nxqm3ROaYtHmPlHyeSzZGTvLiKAgt6zovbn715iUg
	olgIDB/IRWsjs24e/keTx5+mQ9K3H9mxCDoAP9prUNOpV1qM6sOi1obqGWhWohu5Cdae
	6gjQ==
X-Gm-Message-State: AOAM5324qWrrH58lRE+GUJtoyJyte43HxUZDXJz/qt+bDa4ItR/AR0H9
	TzUGX+H7v3j6iyFXlzR0ScKI5c9kcaNOOM230RPAAQ==
X-Google-Smtp-Source: ABdhPJyAvINbfwkmAtSheHBvqQ34kxZO8gNMY+XCKWWu0A6G5+6H+1ho7kvjXbC30y2sh1CEinYbcF7B1ZyY23mV2oQ=
X-Received: by 2002:a5d:9717:: with SMTP id h23mr6161730iol.4.1613227961140;
	Sat, 13 Feb 2021 06:52:41 -0800 (PST)
MIME-Version: 1.0
References: <20210213111146.3080152-1-bigeasy@linutronix.de>
	<20210213111146.3080152-5-bigeasy@linutronix.de>
In-Reply-To: <20210213111146.3080152-5-bigeasy@linutronix.de>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Sat, 13 Feb 2021 14:52:30 +0000
Message-ID: <CALrw=nEtYqXX_cjwYA_F40gPy8BVFMBFr8+ownbXHGPmuDLJ8A@mail.gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
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
Cc: device-mapper development <dm-devel@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, Mike Snitzer <snitzer@redhat.com>,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 4/6] dm crypt: Revisit the atomic argument
	passed to crypt_convert().
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Feb 13, 2021 at 11:11 AM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> The atomic argument of crypto_convert() is used to decide if
> cond_resched() may be invoked.
>
> kcryptd_crypt_write_continue() and kcryptd_crypt_read_continue() pass
> true here but both are invoked by a worker where scheduling is possible.
>
> kcryptd_crypt_write_convert() is invoked from preemptible context even
> if DM_CRYPT_NO_WRITE_WORKQUEUE is set.
>
> Set the atomic argument to false in the three cases because
> cond_resched() is not forbidden.

"atomic" parameter name might be confusing here as usually it is
related to the execution context.
But here it has additional meaning - it is also bound to the
DM_NO_*_WORKQUEUE flags. Basically,
as a user, if I set these flags - my intention is that dm-crypt should
process requests ASAP, so I don't
want it to voluntarily yield CPU even if the context is preemptible.

> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/md/dm-crypt.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index f5eafc32d32c5..1151a0108ae78 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -2019,7 +2019,7 @@ static void kcryptd_crypt_write_continue(struct work_struct *work)
>         wait_for_completion(&ctx->restart);
>         reinit_completion(&ctx->restart);
>
> -       r = crypt_convert(cc, &io->ctx, true, false);
> +       r = crypt_convert(cc, &io->ctx, false, false);
>         if (r)
>                 io->error = r;
>         crypt_finished = atomic_dec_and_test(&ctx->cc_pending);
> @@ -2065,8 +2065,7 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
>         sector += bio_sectors(clone);
>
>         crypt_inc_pending(io);
> -       r = crypt_convert(cc, ctx,
> -                         test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags), true);
> +       r = crypt_convert(cc, ctx, false, true);
>         /*
>          * Crypto API backlogged the request, because its queue was full
>          * and we're in softirq context, so continue from a workqueue
> @@ -2110,7 +2109,7 @@ static void kcryptd_crypt_read_continue(struct work_struct *work)
>         wait_for_completion(&io->ctx.restart);
>         reinit_completion(&io->ctx.restart);
>
> -       r = crypt_convert(cc, &io->ctx, true, false);
> +       r = crypt_convert(cc, &io->ctx, false, false);
>         if (r)
>                 io->error = r;
>
> --
> 2.30.0
>

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

