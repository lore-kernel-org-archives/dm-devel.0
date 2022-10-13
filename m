Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7207AC43217
	for <dm-devel@archiver.kernel.org>; Mon, 17 Oct 2022 07:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1665991859;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ErztbPr22X+Lhq0ZKKuaKCrirrTKMipeLOoCzRXtwFk=;
	b=Q9aeraygxOJVfqapHDCvlC3x0z/fFCUYiH4qwtytIInCSQUouwA3dhydWuJ62JbNLM2aCv
	aJo6X8gApRSCUmV3sUdlsqGnrHXGZYKhxAQdwFGy4Ym8NDvgrJlQX29Rg8Gk/AtFNeNDek
	mHXPmJqn5BhvzZHEIfNj2FxhnJjbH1g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-421-4RZeFkGZPP-rhjaWGWimAg-1; Mon, 17 Oct 2022 03:30:55 -0400
X-MC-Unique: 4RZeFkGZPP-rhjaWGWimAg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B3660858F13;
	Mon, 17 Oct 2022 07:30:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ACCC41468238;
	Mon, 17 Oct 2022 07:30:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 786FE194658D;
	Mon, 17 Oct 2022 07:30:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 17E6B1946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 13 Oct 2022 20:17:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1F5FE403350; Thu, 13 Oct 2022 20:17:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1805642479A
 for <dm-devel@redhat.com>; Thu, 13 Oct 2022 20:16:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2341F185A7AB
 for <dm-devel@redhat.com>; Thu, 13 Oct 2022 20:16:48 +0000 (UTC)
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com
 [209.85.214.179]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-655-Mz4EGVafOpC9KXZiXrW61A-1; Thu, 13 Oct 2022 16:16:45 -0400
X-MC-Unique: Mz4EGVafOpC9KXZiXrW61A-1
Received: by mail-pl1-f179.google.com with SMTP id z20so2799026plb.10;
 Thu, 13 Oct 2022 13:16:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=gOTkI6DiG9zNlMVvwhJN0xPlCDiBJf3npR9m1obgkeo=;
 b=Mk4WhqrLpZlNILUMlMUFRJYpu1LzVGYl2OMvdm04LTeT68P5BvoWPWb6Od5yaPcNWM
 Y5ZCBTzw4dmvWEmxH6cMTyHAZ6AUL5bKF0IsT9g7JqhpVHPzapuNUumH/MG4rYoqfP5J
 6K1VAht/Ty3cDuNVyO3IaUDYSdTOWMzDFkmSM/cUZ0ZcsSHbGrsxYxFXKS02xo79w5sn
 +RqYTYHwrZhdKBigHoyO2dqEl5wup25AT28H6n21MGqLJNvD9vsRJPsjvARKgEQRksAq
 GOEmQ4ZhgBbwlkY/6UOXv1XzsiDDEI+GT8wejckZva68ox1gdxWxAYrawgb94JioD2e6
 2rbA==
X-Gm-Message-State: ACrzQf0Kjibs0pKLjwhzM/nVUOuqKHjcisLLg2wpGEu1ZZZMaPTSpdkK
 /eWxkzOz+RLVBoYRojeg+SCm8EfUJSiuIyESsK8=
X-Google-Smtp-Source: AMsMyM6oJD/yMaxb7cro3W7Zw+cQjBDGxa+i3q11ifg/KVLAfGAnzcBpn57njRrsLsdEm4UMGMYmjk8ypjuUqiKsQ4M=
X-Received: by 2002:a17:903:41cf:b0:183:5a22:c63e with SMTP id
 u15-20020a17090341cf00b001835a22c63emr1364803ple.61.1665692203956; Thu, 13
 Oct 2022 13:16:43 -0700 (PDT)
MIME-Version: 1.0
References: <20221005180341.1738796-1-shy828301@gmail.com>
 <20221005180341.1738796-3-shy828301@gmail.com>
 <20221013123830.opbulq4qad56kuev@techsingularity.net>
In-Reply-To: <20221013123830.opbulq4qad56kuev@techsingularity.net>
From: Yang Shi <shy828301@gmail.com>
Date: Thu, 13 Oct 2022 13:16:31 -0700
Message-ID: <CAHbLzkpc+CAfsYe6gXjh=-3MxMH_aWhPMYhic7ddFZgWttOhng@mail.gmail.com>
To: Mel Gorman <mgorman@techsingularity.net>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Mon, 17 Oct 2022 07:30:49 +0000
Subject: Re: [dm-devel] [PATCH 2/4] mm: mempool: introduce page bulk
 allocator
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: snitzer@kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-mm@kvack.org, dm-devel@redhat.com,
 akpm@linux-foundation.org, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Oct 13, 2022 at 5:38 AM Mel Gorman <mgorman@techsingularity.net> wrote:
>
> On Wed, Oct 05, 2022 at 11:03:39AM -0700, Yang Shi wrote:
> > Since v5.13 the page bulk allocator was introduced to allocate order-0
> > pages in bulk.  There are a few mempool allocator callers which does
> > order-0 page allocation in a loop, for example, dm-crypt, f2fs compress,
> > etc.  A mempool page bulk allocator seems useful.  So introduce the
> > mempool page bulk allocator.
> >
> > It introduces the below APIs:
> >   - mempool_init_pages_bulk()
> >   - mempool_create_pages_bulk()
> > They initialize the mempool for page bulk allocator.  The pool is filled
> > by alloc_page() in a loop.
> >
> >   - mempool_alloc_pages_bulk_list()
> >   - mempool_alloc_pages_bulk_array()
> > They do bulk allocation from mempool.
> > They do the below conceptually:
> >   1. Call bulk page allocator
> >   2. If the allocation is fulfilled then return otherwise try to
> >      allocate the remaining pages from the mempool
> >   3. If it is fulfilled then return otherwise retry from #1 with sleepable
> >      gfp
> >   4. If it is still failed, sleep for a while to wait for the mempool is
> >      refilled, then retry from #1
> > The populated pages will stay on the list or array until the callers
> > consume them or free them.
> > Since mempool allocator is guaranteed to success in the sleepable context,
> > so the two APIs return true for success or false for fail.  It is the
> > caller's responsibility to handle failure case (partial allocation), just
> > like the page bulk allocator.
> >
> > The mempool typically is an object agnostic allocator, but bulk allocation
> > is only supported by pages, so the mempool bulk allocator is for page
> > allocation only as well.
> >
> > Signed-off-by: Yang Shi <shy828301@gmail.com>
>
> Overall, I think it's an ok approach and certainly a good use case for
> the bulk allocator.
>
> The main concern that I have is that the dm-crypt use case doesn't really
> want to use lists as such and it's just a means for collecting pages to pass
> to bio_add_page(). bio_add_page() is working with arrays but you cannot
> use that array directly as any change to how that array is populated will
> then explode. Unfortunately, what you have is adding pages to a list to
> take them off the list and put them in an array and that is inefficient.

Yeah, I didn't think of a better way to pass the pages to dm-crypt.

>
> How about this
>
> 1. Add a callback to __alloc_pages_bulk() that takes a page as a
>    parameter like bulk_add_page() or whatever.
>
> 2. For page_list == NULL && page_array == NULL, the callback is used
>
> 3. Add alloc_pages_bulk_cb() that passes in the name of a callback
>    function
>
> 4. In the dm-crypt case, use the callback to pass the page to bio_add_page
>    for the new page allocated.

Thank you so much for the suggestion. But I have a hard time
understanding how these work together. Do you mean call bio_add_page()
in the callback? But bio_add_page() needs other parameters. Or I
misunderstood you?

>
> It's not free because there will be an additional function call for every
> page bulk allocated but I suspect that's cheaper than adding a pile of
> pages to a list just to take them off again. It also avoids adding a user
> for the bulk allocator list interface that does not even want a list.
>
> It might mean that there is additional cleanup work for __alloc_pages_bulk
> to abstract away whether a list, array or cb is used but nothing
> impossible.
>
> --
> Mel Gorman
> SUSE Labs

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

