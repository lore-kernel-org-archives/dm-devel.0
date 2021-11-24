Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25F85C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 24 Nov 2021 07:24:51 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-477-05c-HwkYNPqkJ0x0GhKTew-1; Wed, 24 Nov 2021 02:24:46 -0500
X-MC-Unique: 05c-HwkYNPqkJ0x0GhKTew-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1C93180292D;
	Wed, 24 Nov 2021 07:24:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CAE3460C7F;
	Wed, 24 Nov 2021 07:24:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 596564BB7C;
	Wed, 24 Nov 2021 07:24:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AO7OeNO005365 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 24 Nov 2021 02:24:40 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 464F851E4; Wed, 24 Nov 2021 07:24:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4096551E3
	for <dm-devel@redhat.com>; Wed, 24 Nov 2021 07:24:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 69E8385A5B9
	for <dm-devel@redhat.com>; Wed, 24 Nov 2021 07:24:37 +0000 (UTC)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com
	[209.85.219.181]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-40-3ICuSoJ_OQS7gaOEsy4o5A-1; Wed, 24 Nov 2021 02:24:35 -0500
X-MC-Unique: 3ICuSoJ_OQS7gaOEsy4o5A-1
Received: by mail-yb1-f181.google.com with SMTP id v64so4635015ybi.5
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 23:24:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to;
	bh=JTv449dLTQjWnh+VHdBZYiPkUh26hBTfKET2KXUuyWA=;
	b=n2BpvV+9RGq49En086DiJ8dzz1SSWOu6fWaToZmja+Fq1IxDXqNpcV8TFnjZe1gjce
	NyAmxc5l5wIIwM++ARWgAchslEDoTo5mDevY6SLKyc0bZepXDUx7nYBCVbDggZYYkdtu
	7Iwt9aJp+9cwjAcVUGggNy2FWKrM8LBZIfFOTNVPtR2iOmUXULlp00RkLz9wALx1j7ig
	0qjudAbc/nYL4gmZ89mJOdP4WpkV4YZaVINgDeFHcQlgVwNVM25bOEktBVVdWl0x6rE9
	xfIp7wAQjT/KWoU2E2bQfvj98vX/jSpN/T98wCm/BcHj4QGUT5d/zcGHdaqQp4k0UUBn
	73Sg==
X-Gm-Message-State: AOAM530ihVrF+to7aGnlOW1Y3EO3Xm59pXr3Yr30hx+wYJ3bGZYOssfT
	uplyzl+jhGxxM8eAwt/LWlzsB8xikEMCxfn1F+hvYA==
X-Google-Smtp-Source: ABdhPJyjea0gvPPoRvI0yQFHqDny/NBwH0BZ1vbbbVLY+8PyOMCrJSV2pILHfIfN3w35JkwhCvcT67cWdCbfnVZZido=
X-Received: by 2002:a25:5d08:: with SMTP id r8mr13491866ybb.227.1637738675084; 
	Tue, 23 Nov 2021 23:24:35 -0800 (PST)
MIME-Version: 1.0
References: <alpine.LRH.2.02.2111231421490.24195@file01.intranet.prod.int.rdu2.redhat.com>
	<CABSDvDL23UZ8KMrjK+qm0Lw0bfDaWh2TruZ2kLgGXqidgOt0jQ@mail.gmail.com>
	<20211124003831.GB63964@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
	<20211124010239.GC63964@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
In-Reply-To: <20211124010239.GC63964@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
From: Akilesh Kailash <akailash@google.com>
Date: Tue, 23 Nov 2021 23:24:23 -0800
Message-ID: <CABSDvDL5gi9KQ3+x1+0vonSFX-OZdd6NeD-XO-d_nvwXtbRMqA@mail.gmail.com>
To: Akilesh Kailash <akailash@google.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <msnitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>,
	Jonathan Brassow <jbrassow@redhat.com>,
	Heinz Mauelshagen <heinzm@redhat.com>,
	David Anderson <dvander@google.com>, dm-devel@redhat.com
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
Subject: Re: [dm-devel] [PATCH] announcing the dm-update target
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 23, 2021 at 5:04 PM Alasdair G Kergon <agk@redhat.com> wrote:
>
> On Wed, Nov 24, 2021 at 12:38:31AM +0000, Alasdair G Kergon wrote:
> > There seems to be a general industry movement towards edge, attestation,
> > trusted boot, nested systems, confidential computing, containers,
> > <insert your favourite buzzwords> etc. and I think this type of
> > device-mapper target might play a useful role as one of the low-level
> > components involved in building up support for some of those scenarios.
> > (Just as we recently began adding support for attestation.)
>
> For example, I think we've already made good progress towards
> standardising the industry around dm-verity.  (At least, I keep
> on encountering it being used in various different places, rather
> than people attempting to develop their own version.)  We extended
> that concept with dm-integrity but I'm less sure about how widely
> that has been taken up so far.
>
> For edge systems needing unattended remote reliable updates, our
> high-level challenge here is: Can we together develop a decent and
> efficient solution for OTA updates that the industry will be happy to
> standardise around?

With OTA, it is challenging to have one general COW format - for instance
what is good for the Android ecosystem may not be useful for the
enterprise world.
For ex: Most of the space savings in Android comes from COPY operation i.e
for an incremental OTA, we would have metadata which states:

COPY BLOCK X -> BLOCK Y

There is no compression involved with these operations. Compression is only
when a block is "replaced". All these are too specific to the Android ecosystem.

I don't want to hijack this conversation here as the current patch is more
specific; however, since you mentioned about the standardization of OTA updates,
I want to bring up the aspect of block device in user space which gives you the
flexibility for users to define COW format as required. There are already couple
of use cases which we are aware off (one being android OTA) and there are
few open source work such as [1] .

[1]  https://github.com/albertofaria/bdus

> Alasdair
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

