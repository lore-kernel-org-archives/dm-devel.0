Return-Path: <SRS0=c+In=IJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 538BCC433E0
	for <dm-devel@archiver.kernel.org>; Thu, 11 Mar 2021 21:28:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4E2DD64F9F
	for <dm-devel@archiver.kernel.org>; Thu, 11 Mar 2021 21:28:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4E2DD64F9F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-9X5W6bKOOV6DRfTgHYFNGA-1; Thu, 11 Mar 2021 16:28:29 -0500
X-MC-Unique: 9X5W6bKOOV6DRfTgHYFNGA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 462CB81746A;
	Thu, 11 Mar 2021 21:28:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 101295D75F;
	Thu, 11 Mar 2021 21:28:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 96CC61C97;
	Thu, 11 Mar 2021 21:28:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12BLSKVo013437 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Mar 2021 16:28:20 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3650C2166BA2; Thu, 11 Mar 2021 21:28:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 318622166BA3
	for <dm-devel@redhat.com>; Thu, 11 Mar 2021 21:28:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E0BF5892D34
	for <dm-devel@redhat.com>; Thu, 11 Mar 2021 21:28:17 +0000 (UTC)
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com
	[209.85.166.181]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-235-cyTmY-WMOyWLvbKk3tl_cw-1; Thu, 11 Mar 2021 16:28:16 -0500
X-MC-Unique: cyTmY-WMOyWLvbKk3tl_cw-1
Received: by mail-il1-f181.google.com with SMTP id r7so725353ilb.0
	for <dm-devel@redhat.com>; Thu, 11 Mar 2021 13:28:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=effRDum3wDyMWASt09lQDi+EECM71NJnadN4OgEwlcg=;
	b=MkeKgGYJo73xQkXerrBvUYyaDToxJiu7LATWqWJCEwdebpd6/zrIe48EENMkfOS+KX
	IsrDZgrxnFK20RTRRpI7WzsiBXr/dVMcnaCwUIBKtouCxzBno38G5ge9yEE1+JZYQh/7
	srRueymPjBDXwr2kQzuYbdc1V4vJtFMiRjXMviP2ePClJPSf52QmQTPe2hkysq+zQsMV
	/QoFryrvbiIvK7syy5Q/Zn29PvKtTxz9DN01N0+KeQ2qCTyJCS1hp9EOE4ZneOmpTjFc
	3R9BZESRkrRAFG1wrhGKVyeWDuGev2A3VHoHyU/tkUNYTSZh3qxVTV5HV17H8UIOG9zv
	vF0Q==
X-Gm-Message-State: AOAM532EfIQdV5qYtdfkqt2VZkuB3hoHvJ0p31fA0EnDfHpuAktpOMzJ
	AuOwlI8oMtc+QJ6v2QKSYHqDysnSVebKY5GmEjdSwA==
X-Google-Smtp-Source: ABdhPJymr1LS0x3b6Z0gOnVsQl2qigtvbpV93fNGbu85kRGZI113XUPJA1KmGAnZPoD3QjyH6o9lOXlhHwesdplHa4Q=
X-Received: by 2002:a05:6e02:1d11:: with SMTP id
	i17mr331912ila.145.1615498095283; 
	Thu, 11 Mar 2021 13:28:15 -0800 (PST)
MIME-Version: 1.0
References: <20210213111146.3080152-1-bigeasy@linutronix.de>
	<20210213111146.3080152-3-bigeasy@linutronix.de>
	<CALrw=nHhOST4udsCrExA7CVLWjWQyNLPau8jde6yq3FR7ONQMw@mail.gmail.com>
	<20210311182507.GA28637@redhat.com>
In-Reply-To: <20210311182507.GA28637@redhat.com>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Thu, 11 Mar 2021 21:28:04 +0000
Message-ID: <CALrw=nEoSpQb+tRK10zj6Q5zM9bLZrT4OndsJqh3yPQevdEF5A@mail.gmail.com>
To: Mike Snitzer <snitzer@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	device-mapper development <dm-devel@redhat.com>,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 2/6] dm crypt: Handle DM_CRYPT_NO_*_WORKQUEUE
	more explicit.
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

On Thu, Mar 11, 2021 at 6:25 PM Mike Snitzer <snitzer@redhat.com> wrote:
>
> On Sat, Feb 13 2021 at  9:31am -0500,
> Ignat Korchagin <ignat@cloudflare.com> wrote:
>
> > On Sat, Feb 13, 2021 at 11:11 AM Sebastian Andrzej Siewior
> > <bigeasy@linutronix.de> wrote:
> > >
> > > By looking at the handling of DM_CRYPT_NO_*_WORKQUEUE in
> > > kcryptd_queue_crypt() it appears that READ and WRITE requests might be
> > > handled in the tasklet context as long as interrupts are disabled or it
> > > is handled in hardirq context.
> > >
> > > The WRITE requests should always be fed in preemptible context. There
> > > are other requirements in the write path which sleep or acquire a mutex.
> > >
> > > The READ requests should come from the storage driver, likely not in a
> > > preemptible context. The source of the requests depends on the driver
> > > and other factors like multiple queues in the block layer.
> >
> > My personal opinion: I really don't like the guesswork and
> > assumptions. If we want
> > to remove the usage of in_*irq() and alike, we should propagate the execution
> > context from the source. Storage drivers have this information and can
> > pass it on to the device-mapper framework, which in turn can pass it
> > on to dm modules.
>
> I'm missing where DM core has the opportunity to convey this context in
> a clean manner.

Does DM core currently even have this context from the drivers?

> Any quick patch that shows the type of transform you'd like to see would
> be appreciated.. doesn't need to be comprehensive, just enough for me or
> others to carry through to completion.

I didn't think it through well, but from the top of my head maybe the
execution context
info can be passed over between different storage layers in the bio
structure? For example,
if a driver completes a read in interrupt context - it sets a flag in
the bio structure and passes
it up the stack. Later, if an intermediate layer changes the execution
context (for example,
dm-crypt offloading the bio processing to a workqueue), that layer
updates the flag and so
on. The same applies to write path: writes are generally started in a
preemptible context, but
if we have some obscure DM module, which will schedule a tasklet for a
write, that module must
update the flag in the bio structure.

Basically, the idea is that a bio processing code will get the current
execution context from an upper/lower
layer and if the code itself changes the execution context, that code
is able to update the execution context
info in the bio before passing it on.

This thinking may be flawed of course as I don't know enough details
about the Linux storage layers and how
well the ownership of bios are defined.

> > Assuming WRITE requests are always in preemptible context might break with the
> > addition of some new type of obscure storage hardware.
> >
> > In our testing we saw a lot of cases with SATA disks, where READ requests come
> > from preemptible contexts, so probably don't want to pay (no matter how small)
> > tasklet setup overhead, not to mention executing it in softirq, which
> > is hard later to
> > attribute to a specific process in metrics.
> >
> > In other words, I think we should be providing support for this in the
> > device-mapper
> > framework itself, not start from individual modules.
>
> I think your concerns are valid... it does seem like this patch is
> assuming too much.
>
> Mike
>

Ignat

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

