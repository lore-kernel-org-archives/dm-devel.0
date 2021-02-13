Return-Path: <SRS0=LVdJ=HP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FE79C433DB
	for <dm-devel@archiver.kernel.org>; Sat, 13 Feb 2021 14:31:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 91F4264D9E
	for <dm-devel@archiver.kernel.org>; Sat, 13 Feb 2021 14:31:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 91F4264D9E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-O8XVbynlNES6xYwc-gciyA-1; Sat, 13 Feb 2021 09:31:28 -0500
X-MC-Unique: O8XVbynlNES6xYwc-gciyA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D2271801965;
	Sat, 13 Feb 2021 14:31:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CD19719D6C;
	Sat, 13 Feb 2021 14:31:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EAA764E58D;
	Sat, 13 Feb 2021 14:31:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11DEVG8Y015926 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 13 Feb 2021 09:31:16 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B1F70F8083; Sat, 13 Feb 2021 14:31:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AC4FCF882A
	for <dm-devel@redhat.com>; Sat, 13 Feb 2021 14:31:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CF763101A53A
	for <dm-devel@redhat.com>; Sat, 13 Feb 2021 14:31:13 +0000 (UTC)
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com
	[209.85.166.42]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-312-s40lDPzONHyNm0GOBYtnRA-1; Sat, 13 Feb 2021 09:31:11 -0500
X-MC-Unique: s40lDPzONHyNm0GOBYtnRA-1
Received: by mail-io1-f42.google.com with SMTP id s24so2235526iob.6
	for <dm-devel@redhat.com>; Sat, 13 Feb 2021 06:31:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=rniKDU34XJpqVs430BoWVbbHkdXsJ4LKoINpdbDDUU4=;
	b=HjVt7C4eGk0uKsO2oDNBN1QpM1SB1CELyAoOnUsnbzdQ6TavlyASvaygHLCea64Nmo
	h50YIoAbBTSq8YkoDIrIXx6GoGasBc4FhGa/1t2InHWuXW/ZcslgdSr02e9uPvJpzSn3
	HEJh2QgCKHICn0ID5dT3aVmkw4bU1bEfGqLQMmNp2LQ9d6rnic61wxQ2uNbU9h7gUl8+
	++wLz6aKVBgieccuWCiev0Ay91+cNLikJFcCD/t2M6FGD0DKnzgpNgTT1XkFOEHq+Yw9
	pj8XG4bmoL27LCaGM2XA+m5zJRAt7yJYy585+4keZZ6Ud4Eia925vQX+8t3zurHZT2cX
	SKAg==
X-Gm-Message-State: AOAM5321V/MgsKNPWNuXer1nQ/Tmyom3xJTi0WPOF3BV7b639JuXeHEE
	LBec9BUIPeUToY9hlZGMZbKCIVReF+vMIyA8asgq+w==
X-Google-Smtp-Source: ABdhPJwyJSiClGjGTmjgkJnsptVXgWHuuI0fr6SHolP+KB1m3HYlbs80qMqXYlm86eJGrySBBSuS9rjNbhPwvwZsrss=
X-Received: by 2002:a5d:8ac5:: with SMTP id e5mr5958325iot.33.1613226670891;
	Sat, 13 Feb 2021 06:31:10 -0800 (PST)
MIME-Version: 1.0
References: <20210213111146.3080152-1-bigeasy@linutronix.de>
	<20210213111146.3080152-3-bigeasy@linutronix.de>
In-Reply-To: <20210213111146.3080152-3-bigeasy@linutronix.de>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Sat, 13 Feb 2021 14:31:00 +0000
Message-ID: <CALrw=nHhOST4udsCrExA7CVLWjWQyNLPau8jde6yq3FR7ONQMw@mail.gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
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
Cc: device-mapper development <dm-devel@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, Mike Snitzer <snitzer@redhat.com>,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 2/6] dm crypt: Handle DM_CRYPT_NO_*_WORKQUEUE
	more explicit.
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

On Sat, Feb 13, 2021 at 11:11 AM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> By looking at the handling of DM_CRYPT_NO_*_WORKQUEUE in
> kcryptd_queue_crypt() it appears that READ and WRITE requests might be
> handled in the tasklet context as long as interrupts are disabled or it
> is handled in hardirq context.
>
> The WRITE requests should always be fed in preemptible context. There
> are other requirements in the write path which sleep or acquire a mutex.
>
> The READ requests should come from the storage driver, likely not in a
> preemptible context. The source of the requests depends on the driver
> and other factors like multiple queues in the block layer.

My personal opinion: I really don't like the guesswork and
assumptions. If we want
to remove the usage of in_*irq() and alike, we should propagate the execution
context from the source. Storage drivers have this information and can
pass it on to the device-mapper framework, which in turn can pass it
on to dm modules.

Assuming WRITE requests are always in preemptible context might break with the
addition of some new type of obscure storage hardware.

In our testing we saw a lot of cases with SATA disks, where READ requests come
from preemptible contexts, so probably don't want to pay (no matter how small)
tasklet setup overhead, not to mention executing it in softirq, which
is hard later to
attribute to a specific process in metrics.

In other words, I think we should be providing support for this in the
device-mapper
framework itself, not start from individual modules.

> To simplify the handling of DM_CRYPT_NO_*_WORKQUEUE, handle READ
> requests always in tasklet/softirq context since the requests will be
> passed in hard or softirq context.
> Handle the WRITE requests directly because they are already in
> preemptible context and must not be passed to the taslket/softirq.
>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/md/dm-crypt.c | 26 +++++++++-----------------
>  1 file changed, 9 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 506655e5eecba..a498de3604a67 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -2215,30 +2215,22 @@ static void kcryptd_crypt_tasklet(struct tasklet_struct *t)
>  {
>         struct dm_crypt_io *io = from_tasklet(io, t, tasklet);
>
> -       if (bio_data_dir(io->base_bio) == READ)
> -               kcryptd_crypt_read_convert(io);
> -       else
> -               kcryptd_crypt_write_convert(io);
Should we add BUG_ON(bio_data_dir(io->base_bio) != READ) here?
> +       kcryptd_crypt_read_convert(io);
>  }
>
>  static void kcryptd_queue_crypt(struct dm_crypt_io *io)
>  {
>         struct crypt_config *cc = io->cc;
>
> -       if ((bio_data_dir(io->base_bio) == READ && test_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags)) ||
> -           (bio_data_dir(io->base_bio) == WRITE && test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags))) {
> -               /*
> -                * in_irq(): Crypto API's skcipher_walk_first() refuses to work in hard IRQ context.
> -                * irqs_disabled(): the kernel may run some IO completion from the idle thread, but
> -                * it is being executed with irqs disabled.
> -                */
> -               if (in_irq() || irqs_disabled()) {
> -                       tasklet_setup(&io->tasklet, kcryptd_crypt_tasklet);
> -                       tasklet_schedule(&io->tasklet);
> -                       return;
> -               }
> +       if (bio_data_dir(io->base_bio) == READ &&
> +           test_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags)) {
> +               tasklet_setup(&io->tasklet, kcryptd_crypt_tasklet);
> +               tasklet_schedule(&io->tasklet);
> +               return;
>
> -               kcryptd_crypt(&io->work);
> +       } else if (bio_data_dir(io->base_bio) == WRITE &&
> +                  test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags)) {
> +               kcryptd_crypt_write_convert(io);
>                 return;
>         }
>
> --
> 2.30.0
>

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

