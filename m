Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95B3DC433FE
	for <dm-devel@archiver.kernel.org>; Tue, 18 Oct 2022 07:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666077043;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=HcM9pJ1TZKNBykU6EBJB6MegoXJZO8qSCNqZBWxpERU=;
	b=LihNuzYDG2zC8At859dZ86fEQXuIIWFGlsAI3x/PUlA/FC4KvTXR8CmwP+JKPu/RgAMbe0
	r9WDphe+flQ1XLa/LE2JyM6MAx50DI+m6AMWV4Vni9AZzXm/S0PIF9yIDvygcUAFPnNqA8
	21XXZDYaGVTbfwoFpBV/fMC1d2ypkdM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-364-ctUcSB7QNh686R_BKPsRdw-1; Tue, 18 Oct 2022 03:10:40 -0400
X-MC-Unique: ctUcSB7QNh686R_BKPsRdw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD69F185A792;
	Tue, 18 Oct 2022 07:10:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3A6BC111DCE8;
	Tue, 18 Oct 2022 07:10:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0CAFB1946594;
	Tue, 18 Oct 2022 07:10:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 202BE194658F
 for <dm-devel@listman.corp.redhat.com>; Mon, 17 Oct 2022 09:49:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EA0DA200A384; Mon, 17 Oct 2022 09:49:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E2ADD2028E8F
 for <dm-devel@redhat.com>; Mon, 17 Oct 2022 09:49:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C4A3A3C025BB
 for <dm-devel@redhat.com>; Mon, 17 Oct 2022 09:49:51 +0000 (UTC)
Received: from outbound-smtp51.blacknight.com
 (outbound-smtp51.blacknight.com [46.22.136.235]) by relay.mimecast.com with
 ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-526-eOa1Bu_QORyW6rKPNHglAA-1; Mon, 17 Oct 2022 05:49:50 -0400
X-MC-Unique: eOa1Bu_QORyW6rKPNHglAA-1
Received: from mail.blacknight.com (pemlinmail01.blacknight.ie [81.17.254.10])
 by outbound-smtp51.blacknight.com (Postfix) with ESMTPS id 5F124FAF36
 for <dm-devel@redhat.com>; Mon, 17 Oct 2022 10:41:34 +0100 (IST)
Received: (qmail 4063 invoked from network); 17 Oct 2022 09:41:34 -0000
Received: from unknown (HELO techsingularity.net)
 (mgorman@techsingularity.net@[84.203.198.246])
 by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated);
 17 Oct 2022 09:41:34 -0000
Date: Mon, 17 Oct 2022 10:41:32 +0100
From: Mel Gorman <mgorman@techsingularity.net>
To: Yang Shi <shy828301@gmail.com>
Message-ID: <20221017094132.vnanndrwa2yn7qcw@techsingularity.net>
References: <20221005180341.1738796-1-shy828301@gmail.com>
 <20221005180341.1738796-3-shy828301@gmail.com>
 <20221013123830.opbulq4qad56kuev@techsingularity.net>
 <CAHbLzkpc+CAfsYe6gXjh=-3MxMH_aWhPMYhic7ddFZgWttOhng@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAHbLzkpc+CAfsYe6gXjh=-3MxMH_aWhPMYhic7ddFZgWttOhng@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Tue, 18 Oct 2022 07:10:34 +0000
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Oct 13, 2022 at 01:16:31PM -0700, Yang Shi wrote:
> On Thu, Oct 13, 2022 at 5:38 AM Mel Gorman <mgorman@techsingularity.net> wrote:
> >
> > On Wed, Oct 05, 2022 at 11:03:39AM -0700, Yang Shi wrote:
> > > Since v5.13 the page bulk allocator was introduced to allocate order-0
> > > pages in bulk.  There are a few mempool allocator callers which does
> > > order-0 page allocation in a loop, for example, dm-crypt, f2fs compress,
> > > etc.  A mempool page bulk allocator seems useful.  So introduce the
> > > mempool page bulk allocator.
> > >
> > > It introduces the below APIs:
> > >   - mempool_init_pages_bulk()
> > >   - mempool_create_pages_bulk()
> > > They initialize the mempool for page bulk allocator.  The pool is filled
> > > by alloc_page() in a loop.
> > >
> > >   - mempool_alloc_pages_bulk_list()
> > >   - mempool_alloc_pages_bulk_array()
> > > They do bulk allocation from mempool.
> > > They do the below conceptually:
> > >   1. Call bulk page allocator
> > >   2. If the allocation is fulfilled then return otherwise try to
> > >      allocate the remaining pages from the mempool
> > >   3. If it is fulfilled then return otherwise retry from #1 with sleepable
> > >      gfp
> > >   4. If it is still failed, sleep for a while to wait for the mempool is
> > >      refilled, then retry from #1
> > > The populated pages will stay on the list or array until the callers
> > > consume them or free them.
> > > Since mempool allocator is guaranteed to success in the sleepable context,
> > > so the two APIs return true for success or false for fail.  It is the
> > > caller's responsibility to handle failure case (partial allocation), just
> > > like the page bulk allocator.
> > >
> > > The mempool typically is an object agnostic allocator, but bulk allocation
> > > is only supported by pages, so the mempool bulk allocator is for page
> > > allocation only as well.
> > >
> > > Signed-off-by: Yang Shi <shy828301@gmail.com>
> >
> > Overall, I think it's an ok approach and certainly a good use case for
> > the bulk allocator.
> >
> > The main concern that I have is that the dm-crypt use case doesn't really
> > want to use lists as such and it's just a means for collecting pages to pass
> > to bio_add_page(). bio_add_page() is working with arrays but you cannot
> > use that array directly as any change to how that array is populated will
> > then explode. Unfortunately, what you have is adding pages to a list to
> > take them off the list and put them in an array and that is inefficient.
> 
> Yeah, I didn't think of a better way to pass the pages to dm-crypt.
> 
> >
> > How about this
> >
> > 1. Add a callback to __alloc_pages_bulk() that takes a page as a
> >    parameter like bulk_add_page() or whatever.
> >
> > 2. For page_list == NULL && page_array == NULL, the callback is used
> >
> > 3. Add alloc_pages_bulk_cb() that passes in the name of a callback
> >    function
> >
> > 4. In the dm-crypt case, use the callback to pass the page to bio_add_page
> >    for the new page allocated.
> 
> Thank you so much for the suggestion. But I have a hard time
> understanding how these work together. Do you mean call bio_add_page()
> in the callback? But bio_add_page() needs other parameters. Or I
> misunderstood you?
> 

I expected dm-crypt to define the callback. Using bio_add_page
directly would not work as the bulk allocator has no idea what to pass
bio_add_page. dm-crypt would likely need to create both a callback and an
opaque data structure passed as (void *) to track "clone" and "len"

-- 
Mel Gorman
SUSE Labs

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

