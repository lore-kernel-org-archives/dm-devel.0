Return-Path: <SRS0=/4vF=GC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 677DDC433DB
	for <dm-devel@archiver.kernel.org>; Wed, 30 Dec 2020 11:22:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C38F520759
	for <dm-devel@archiver.kernel.org>; Wed, 30 Dec 2020 11:22:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C38F520759
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-ZkxdDbEgPCON6lHl0FznfQ-1; Wed, 30 Dec 2020 06:22:30 -0500
X-MC-Unique: ZkxdDbEgPCON6lHl0FznfQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2095D107ACE3;
	Wed, 30 Dec 2020 11:22:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 104F45D9CC;
	Wed, 30 Dec 2020 11:22:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1B0E51809C9F;
	Wed, 30 Dec 2020 11:22:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BUBMIwq023333 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 30 Dec 2020 06:22:18 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DF3462026D11; Wed, 30 Dec 2020 11:22:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D8CC92026D49
	for <dm-devel@redhat.com>; Wed, 30 Dec 2020 11:22:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BA7E2800883
	for <dm-devel@redhat.com>; Wed, 30 Dec 2020 11:22:12 +0000 (UTC)
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com
	[209.85.166.47]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-125-OsWg-XQ3PcqFJQ9DZAgcEQ-1; Wed, 30 Dec 2020 06:22:10 -0500
X-MC-Unique: OsWg-XQ3PcqFJQ9DZAgcEQ-1
Received: by mail-io1-f47.google.com with SMTP id u26so11754867iof.3
	for <dm-devel@redhat.com>; Wed, 30 Dec 2020 03:22:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=6oPKzLyyXT4TdO6sFZrA2FFrPyuYED6DhcCJYDeGYf8=;
	b=hWUaUS16cg2nbaiS7k/neF0WAjpX682dKE3WmklP1JZR4tkxjAPHUx3i+C6YWqKGuq
	9la4ThbVPliTnaD2YjeSahmMRKpefNi2GpljvUJznOk0SLZKlCE4ASGcLeZQCUYtWp+v
	bbtHuFkoQu3a4AWZpB4r3eGldaxdJArK90E+E5CkU401pUYZ110ZG/xG0AV6eayv5EU1
	woP9BrJc4lYtvTwETqlnjF2VGpGMDrLfuxqF6CUmA4CGm/Fg2yJK0ry9bPK+LeGguwK0
	KmNq3Q2LTdKtPW2N6IyzKzpIikuq+dFlIKgWsqgQUj+QBwg+xwlmyMShJq3PnrVy4XAp
	+3FA==
X-Gm-Message-State: AOAM533G8H/PFnidXeGrR9PqzoL9ZW+O6paOVcNrRv+F5dzXnXPLwvP2
	bFhTy6sQv8ZShg7aciDLB7OtjsmqB0+gdeez/FN4iw==
X-Google-Smtp-Source: ABdhPJx+Wy/89M+XxyQP1337iMXRcYzY09+IGgpGdQNNhSlJA0ioAsbB3KnOfbLHhUOzoOaeM118/CMR2Ly4YbM2Ql0=
X-Received: by 2002:a6b:700f:: with SMTP id l15mr43085763ioc.22.1609327329832; 
	Wed, 30 Dec 2020 03:22:09 -0800 (PST)
MIME-Version: 1.0
References: <20201229225714.1580-1-ignat@cloudflare.com>
	<20201230073557.2253-1-hdanton@sina.com>
In-Reply-To: <20201230073557.2253-1-hdanton@sina.com>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Wed, 30 Dec 2020 11:21:59 +0000
Message-ID: <CALrw=nHBM++dx1gtWZEgaWGduLqRMOFwfbfZtjLWD-JcpT+=hA@mail.gmail.com>
To: Hillf Danton <hdanton@sina.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: dm-crypt@saout.de, device-mapper development <dm-devel@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH 1/2] dm crypt: use GFP_ATOMIC when allocating
 crypto requests from softirq
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Dec 30, 2020 at 7:36 AM Hillf Danton <hdanton@sina.com> wrote:
>
> On Tue, 29 Dec 2020 22:57:13 +0000
> >
> > Fixes: 39d42fa96ba1 ("dm crypt: add flags to optionally bypass kcryptd workqueues")
>
> Looks like a seperate fix to this commit is needed if what can be found
> at (Subject: [patch 00/12] UBS: Cleanup in_interupt/in_irq/in_atomic() usage)
> https://lore.kernel.org/lkml/20201014145215.518912759@linutronix.de/

I think the above request should be satisfied by device mapper core
code itself rather than individual DM module implementations, as the
execution context in the module is dependent on the underlying block
driver: some block drivers complete requests in task contexts and some
in interrupt - but the underlying block drivers should be transparent
to the modules.

The device mapper core code can pass context information to the
modules if we are to avoid in_*irq() marcos in the code.

> is correct.
>
> > Reported-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
> > Cc: <stable@vger.kernel.org> # v5.9+
> > Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
> > ---
> >  drivers/md/dm-crypt.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> > index 5f9f9b3a226d..777b5c71a2f7 100644
> > --- a/drivers/md/dm-crypt.c
> > +++ b/drivers/md/dm-crypt.c
> > @@ -1460,7 +1460,7 @@ static void crypt_alloc_req_skcipher(struct crypt_config *cc,
> >       unsigned key_index = ctx->cc_sector & (cc->tfms_count - 1);
> >
> >       if (!ctx->r.req)
> > -             ctx->r.req = mempool_alloc(&cc->req_pool, GFP_NOIO);
> > +             ctx->r.req = mempool_alloc(&cc->req_pool, in_interrupt() ? GFP_ATOMIC : GFP_NOIO);
> >
> >       skcipher_request_set_tfm(ctx->r.req, cc->cipher_tfm.tfms[key_index]);
> >
> > @@ -1477,7 +1477,7 @@ static void crypt_alloc_req_aead(struct crypt_config *cc,
> >                                struct convert_context *ctx)
> >  {
> >       if (!ctx->r.req_aead)
> > -             ctx->r.req_aead = mempool_alloc(&cc->req_pool, GFP_NOIO);
> > +             ctx->r.req_aead = mempool_alloc(&cc->req_pool, in_interrupt() ? GFP_ATOMIC : GFP_NOIO);
> >
> >       aead_request_set_tfm(ctx->r.req_aead, cc->cipher_tfm.tfms_aead[0]);
> >
> > --
> > 2.20.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

