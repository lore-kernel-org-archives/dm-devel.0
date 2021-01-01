Return-Path: <SRS0=eRft=GE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C0EEC433E0
	for <dm-devel@archiver.kernel.org>; Fri,  1 Jan 2021 10:27:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CDC1221E92
	for <dm-devel@archiver.kernel.org>; Fri,  1 Jan 2021 10:27:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CDC1221E92
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-CvEdKvXYPf-Ap1JLybCX6w-1; Fri, 01 Jan 2021 05:27:14 -0500
X-MC-Unique: CvEdKvXYPf-Ap1JLybCX6w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7DA82801AC9;
	Fri,  1 Jan 2021 10:27:09 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 525E55D9DD;
	Fri,  1 Jan 2021 10:27:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 18CE5180954D;
	Fri,  1 Jan 2021 10:27:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 101AR5pj006853 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 1 Jan 2021 05:27:05 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0C4DB110F744; Fri,  1 Jan 2021 10:27:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 084FF110F742
	for <dm-devel@redhat.com>; Fri,  1 Jan 2021 10:27:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E5462101A53F
	for <dm-devel@redhat.com>; Fri,  1 Jan 2021 10:27:02 +0000 (UTC)
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com
	[209.85.166.170]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-186-PAXkFi80NOm8FQ8BaZNJNw-1; Fri, 01 Jan 2021 05:26:58 -0500
X-MC-Unique: PAXkFi80NOm8FQ8BaZNJNw-1
Received: by mail-il1-f170.google.com with SMTP id n9so19173272ili.0
	for <dm-devel@redhat.com>; Fri, 01 Jan 2021 02:26:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=k2vQ6iqC4CndNBeiIFLrfo2PMRh+mcqERP0ZLSMI0UU=;
	b=LSS3WhV2pUHOP1cB1tb0eBAa/nTPcCxkWqn8Hmq5OpC7q5ThbHd78tS+aZrF7Lqq9w
	93GxVALTumkTYLOldE0gpaFHwpiJdG2rLuKWFZC3CTdjgrv19t5+C5fqCnJq1iHJqxJh
	krodTKZH7UE5uT2ABpB2YKNkfDyb5peepygpUBGkAAqKg3lulj68IqC+iMlpjPJPnKEO
	JpadZ3UeKmmelmUxm9APEW9xXjEmjzXwWDUdXkCHls5Pr29g9KSCNUxz7EpXW9nDHwY9
	PalbTTLVeJ7Dx9u9rCjxJ4a/DxB4GCNHrHByB9Uo/o2X8L1oWAZupHV7qFXb9jJmRwJX
	7zlA==
X-Gm-Message-State: AOAM531mJsq1ZJ5RDOxyobmvxtgTqExQVGfCIGJc0zlVdy0erI/04/JH
	co2A4q/vgxjU3YQx41k7KFjm0+5mWCsLSj/eTFWG6A==
X-Google-Smtp-Source: ABdhPJz1USMv6E2KC8ZVmIWBjUJhlS5f9B0ew9hFe2xL6yHufIj3i5Q+DJrMQoaeY+K+o+6kwBrDtzQTcfz8CCZkwqA=
X-Received: by 2002:a92:c990:: with SMTP id y16mr60036119iln.35.1609496817666; 
	Fri, 01 Jan 2021 02:26:57 -0800 (PST)
MIME-Version: 1.0
References: <20201230214520.154793-1-ignat@cloudflare.com>
	<20201230214520.154793-2-ignat@cloudflare.com>
	<alpine.LRH.2.02.2101010450460.31009@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.2101010450460.31009@file01.intranet.prod.int.rdu2.redhat.com>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Fri, 1 Jan 2021 10:26:46 +0000
Message-ID: <CALrw=nFFt4aUaJMc0OkKJfFfyv+A3oPuJxKMceOVGzrzwtP3Cw@mail.gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>
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
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Mike Snitzer <snitzer@redhat.com>,
	kernel-team <kernel-team@cloudflare.com>, dm-crypt@saout.de,
	linux-kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
	Nobuto Murata <nobuto.murata@canonical.com>,
	Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
	device-mapper development <dm-devel@redhat.com>,
	linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	"Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
	Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 1/2] dm crypt: use GFP_ATOMIC when
 allocating crypto requests from softirq
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

On Fri, Jan 1, 2021 at 10:00 AM Mikulas Patocka <mpatocka@redhat.com> wrote:
>
>
>
> On Wed, 30 Dec 2020, Ignat Korchagin wrote:
>
> > diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> > index 53791138d78b..e4fd690c70e1 100644
> > --- a/drivers/md/dm-crypt.c
> > +++ b/drivers/md/dm-crypt.c
> > @@ -1539,7 +1549,10 @@ static blk_status_t crypt_convert(struct crypt_config *cc,
> >
> >       while (ctx->iter_in.bi_size && ctx->iter_out.bi_size) {
> >
> > -             crypt_alloc_req(cc, ctx);
> > +             r = crypt_alloc_req(cc, ctx);
> > +             if (r)
> > +                     return BLK_STS_RESOURCE;
> > +
> >               atomic_inc(&ctx->cc_pending);
> >
> >               if (crypt_integrity_aead(cc))
> > --
> > 2.20.1
>
> I'm not quite convinced that returning BLK_STS_RESOURCE will help. The
> block layer will convert this value back to -ENOMEM and return it to the
> caller, resulting in an I/O error.
>
> Note that GFP_ATOMIC allocations may fail anytime and you must handle
> allocation failure gracefully - i.e. process the request without any
> error.
>
> An acceptable solution would be to punt the request to a workqueue and do
> GFP_NOIO allocation from the workqueue. Or add the request to some list
> and process the list when some other request completes.

We can do the workqueue, if that's the desired behaviour. The second patch
from this patchset already adds the code for the request to be retried from the
workqueue if crypt_convert returns BLK_STS_DEV_RESOURCE, so all is needed
is to change returning BLK_STS_RESOURCE to BLK_STS_DEV_RESOURCE
here. Does that sound reasonable?

> You should write a test that simulates allocation failure and verify that
> the kernel handles it gracefully without any I/O error.

I already have the test for the second patch in the set, but will
adapt it to make sure the
allocation failure codepath is covered as well.

> Mikulas
>

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

