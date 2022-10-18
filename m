Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 362FEC4332F
	for <dm-devel@archiver.kernel.org>; Wed, 19 Oct 2022 06:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666160346;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=eDOWpmGlabJctKAr3SEh03KgvYiRWFo0bHP8oYHEBnM=;
	b=drfx+6RFpYz5Htsarph1YaBxmQkHu/Q2okcaVYgeU6o4lMgPekuP7BaIh/mnHoYGteqLgi
	Q2mvb84yj5EVmiVJqmNinPHKIS17pnfftv5hwngvQUdPtxJ0HvoDjz8Q3kHAWHCiMM1V7W
	2wB68hJerMe/WLKfTKdxZQaNw7FhoNg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-146-NgKfNfp1NRGdgrHdYJdKTA-1; Wed, 19 Oct 2022 02:18:46 -0400
X-MC-Unique: NgKfNfp1NRGdgrHdYJdKTA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 59D7885A583;
	Wed, 19 Oct 2022 06:18:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D2DB7112132C;
	Wed, 19 Oct 2022 06:18:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AC4241946597;
	Wed, 19 Oct 2022 06:18:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7769F194658F
 for <dm-devel@listman.corp.redhat.com>; Tue, 18 Oct 2022 18:01:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 07D3C111D3D2; Tue, 18 Oct 2022 18:01:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 00E3B111D7AD
 for <dm-devel@redhat.com>; Tue, 18 Oct 2022 18:01:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6C74B805B72
 for <dm-devel@redhat.com>; Tue, 18 Oct 2022 18:01:51 +0000 (UTC)
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com
 [209.85.216.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-27-jW98DjlRM5GmDyFVGdEtSw-1; Tue, 18 Oct 2022 14:01:44 -0400
X-MC-Unique: jW98DjlRM5GmDyFVGdEtSw-1
Received: by mail-pj1-f48.google.com with SMTP id
 x1-20020a17090ab00100b001fda21bbc90so18117403pjq.3; 
 Tue, 18 Oct 2022 11:01:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=kbVWeBLmoXaL5wT4FGVpRcLjWyd0m50VYE8PAOnnEko=;
 b=4zGswY7BWGvXcPtM4tMDIh9ddC8M0NAajFDD8QRCPDYIrvs6sMCH0Zt751SNLWHEuo
 4X+NKFXCAfmDkjPR0m5VScTVVi/Q+iY+tFsijBWIuOYFOVjtA08V9MyGLwhcaCwsm09z
 /vRmoYTPqRcy8d5bTlrlRt3ffpWtIJdmgBbKezJk1ny7HS1zKyP3shaTIEmUyuwhuJJO
 Y8fhd26kMdf3MST2LRDHabqYxOXoa3iNLT44tBjqKECm3MINGwF5lWecOG7QiyRhvfgQ
 gfJg3r6KD6QGE/4NB3oJzFQwxEUgviDbk+tAfu/RX0wFPtSeBQEgn3cL9Ata8HLxliMy
 RpTA==
X-Gm-Message-State: ACrzQf3YEPg9vAP8j/1xXzPN4aIOgSikUMfycYCwyD5tdqHQYcMVJgsB
 m/YmCEstZ8tAmyhwy4mon4+A8AxnFtK0tLJoH9o=
X-Google-Smtp-Source: AMsMyM4dRCMlLxwxpvWPKeEBQqgqTpkBvzI2y4UmcFNFY7lhRcumit+v8Ysop8DlhVkW1Pg4yIXBLJ/OEQVZxMId9tQ=
X-Received: by 2002:a17:902:d512:b0:181:f1f4:fcb4 with SMTP id
 b18-20020a170902d51200b00181f1f4fcb4mr4248525plg.102.1666116103439; Tue, 18
 Oct 2022 11:01:43 -0700 (PDT)
MIME-Version: 1.0
References: <20221005180341.1738796-1-shy828301@gmail.com>
 <20221005180341.1738796-3-shy828301@gmail.com>
 <20221013123830.opbulq4qad56kuev@techsingularity.net>
 <CAHbLzkpc+CAfsYe6gXjh=-3MxMH_aWhPMYhic7ddFZgWttOhng@mail.gmail.com>
 <20221017094132.vnanndrwa2yn7qcw@techsingularity.net>
In-Reply-To: <20221017094132.vnanndrwa2yn7qcw@techsingularity.net>
From: Yang Shi <shy828301@gmail.com>
Date: Tue, 18 Oct 2022 11:01:31 -0700
Message-ID: <CAHbLzkpmbmtOdOsud-VG+wyk18wFAFnan8T55XxxwkHrnhLCmw@mail.gmail.com>
To: Mel Gorman <mgorman@techsingularity.net>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Wed, 19 Oct 2022 06:18:39 +0000
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Oct 17, 2022 at 2:41 AM Mel Gorman <mgorman@techsingularity.net> wrote:
>
> On Thu, Oct 13, 2022 at 01:16:31PM -0700, Yang Shi wrote:
> > On Thu, Oct 13, 2022 at 5:38 AM Mel Gorman <mgorman@techsingularity.net> wrote:
> > >
> > > On Wed, Oct 05, 2022 at 11:03:39AM -0700, Yang Shi wrote:
> > > > Since v5.13 the page bulk allocator was introduced to allocate order-0
> > > > pages in bulk.  There are a few mempool allocator callers which does
> > > > order-0 page allocation in a loop, for example, dm-crypt, f2fs compress,
> > > > etc.  A mempool page bulk allocator seems useful.  So introduce the
> > > > mempool page bulk allocator.
> > > >
> > > > It introduces the below APIs:
> > > >   - mempool_init_pages_bulk()
> > > >   - mempool_create_pages_bulk()
> > > > They initialize the mempool for page bulk allocator.  The pool is filled
> > > > by alloc_page() in a loop.
> > > >
> > > >   - mempool_alloc_pages_bulk_list()
> > > >   - mempool_alloc_pages_bulk_array()
> > > > They do bulk allocation from mempool.
> > > > They do the below conceptually:
> > > >   1. Call bulk page allocator
> > > >   2. If the allocation is fulfilled then return otherwise try to
> > > >      allocate the remaining pages from the mempool
> > > >   3. If it is fulfilled then return otherwise retry from #1 with sleepable
> > > >      gfp
> > > >   4. If it is still failed, sleep for a while to wait for the mempool is
> > > >      refilled, then retry from #1
> > > > The populated pages will stay on the list or array until the callers
> > > > consume them or free them.
> > > > Since mempool allocator is guaranteed to success in the sleepable context,
> > > > so the two APIs return true for success or false for fail.  It is the
> > > > caller's responsibility to handle failure case (partial allocation), just
> > > > like the page bulk allocator.
> > > >
> > > > The mempool typically is an object agnostic allocator, but bulk allocation
> > > > is only supported by pages, so the mempool bulk allocator is for page
> > > > allocation only as well.
> > > >
> > > > Signed-off-by: Yang Shi <shy828301@gmail.com>
> > >
> > > Overall, I think it's an ok approach and certainly a good use case for
> > > the bulk allocator.
> > >
> > > The main concern that I have is that the dm-crypt use case doesn't really
> > > want to use lists as such and it's just a means for collecting pages to pass
> > > to bio_add_page(). bio_add_page() is working with arrays but you cannot
> > > use that array directly as any change to how that array is populated will
> > > then explode. Unfortunately, what you have is adding pages to a list to
> > > take them off the list and put them in an array and that is inefficient.
> >
> > Yeah, I didn't think of a better way to pass the pages to dm-crypt.
> >
> > >
> > > How about this
> > >
> > > 1. Add a callback to __alloc_pages_bulk() that takes a page as a
> > >    parameter like bulk_add_page() or whatever.
> > >
> > > 2. For page_list == NULL && page_array == NULL, the callback is used
> > >
> > > 3. Add alloc_pages_bulk_cb() that passes in the name of a callback
> > >    function
> > >
> > > 4. In the dm-crypt case, use the callback to pass the page to bio_add_page
> > >    for the new page allocated.
> >
> > Thank you so much for the suggestion. But I have a hard time
> > understanding how these work together. Do you mean call bio_add_page()
> > in the callback? But bio_add_page() needs other parameters. Or I
> > misunderstood you?
> >
>
> I expected dm-crypt to define the callback. Using bio_add_page
> directly would not work as the bulk allocator has no idea what to pass
> bio_add_page. dm-crypt would likely need to create both a callback and an
> opaque data structure passed as (void *) to track "clone" and "len"

I see. Yeah, we have to pass the "clone" and "len" to the callback via
pool_data. It should not be hard since dm-crypt already uses
crypt_config to maintain a counter for allocated pages, we should just
need to pass the struct to the callback as a parameter.

But I'm wondering whether this is worth it or not? Will it make the
code harder to follow?

>
> --
> Mel Gorman
> SUSE Labs

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

