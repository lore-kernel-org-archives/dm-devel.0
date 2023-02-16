Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46597C636CC
	for <dm-devel@archiver.kernel.org>; Fri, 17 Feb 2023 00:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676593681;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=IZwA3T1XTF/TmKyrou25LJL/sOnL4LAr+jUO1AMsllM=;
	b=hKPY8hZUKdfMfl5Vp/90FKO3lFIhBn3j/ptDbfHtY4OhOr7KttteG4PVRYMLtAwfqUw9mu
	TSd+u0WmDIHPoT422eswqRppSojBE0f1Te2Dky1shCNkmrOVkUDHF6mnpD33FL5eCYXqnu
	OuIXIbXCCDR7opyOJc9J0Ad56I+WpLk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-333-uH1BwIXHMweMt8UuQd3ykQ-1; Thu, 16 Feb 2023 19:27:57 -0500
X-MC-Unique: uH1BwIXHMweMt8UuQd3ykQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE70F280AA2C;
	Fri, 17 Feb 2023 00:27:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BB1431121314;
	Fri, 17 Feb 2023 00:27:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F153719465B1;
	Fri, 17 Feb 2023 00:27:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 092781946588
 for <dm-devel@listman.corp.redhat.com>; Thu, 16 Feb 2023 21:49:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C49F051FF; Thu, 16 Feb 2023 21:49:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BC87F175AD
 for <dm-devel@redhat.com>; Thu, 16 Feb 2023 21:49:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9B9E238123C0
 for <dm-devel@redhat.com>; Thu, 16 Feb 2023 21:49:45 +0000 (UTC)
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com
 [209.85.214.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-159-5-vWaODhMei2Y_sfhq7BXg-1; Thu, 16 Feb 2023 16:49:42 -0500
X-MC-Unique: 5-vWaODhMei2Y_sfhq7BXg-1
Received: by mail-pl1-f169.google.com with SMTP id v23so3580768plo.1;
 Thu, 16 Feb 2023 13:49:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=XX55PL86vSqpwFy0eLM4CL0pVCfJIrQzfm/lyyBo490=;
 b=Ht9A3uzs/fIaigE++gubuieCJ6NykbMivTLWhLxY9qu+E+mVCM3ACl7fxkMH79yA9b
 /AaMC7LfUtIk/XAlqRAHtBBhx9wdqAHPWsfd2pqZPsGY4MBBGbchW+oRCM3FNr2kEQAl
 WziZaJHAYBewe8p0Jc/jsObCZE9g4h28Omos80ZTBbRiEPMQG9pJhAaIiLNFA6ok/gYc
 rnEcbH1wIVbHmVRTMJ6yBk5jBN2c4HxzkxaOnYL5svh7D1L3ze4uDjXBm2lyuNwvJzQZ
 QWWGZ1+McQyIpowSxp6031yTyoyU6U4kWWY0TBdXy0hxv0JSPiUumIlDqImOwN45FAXU
 TR7g==
X-Gm-Message-State: AO0yUKWWWlXUiJnGRwfOXf5MfM7QXYwapzan/TnCI63duEOO51drbVyE
 XhTgGs5SKfAaCT1vqeXu3OqVb1/t+eC8u/kDc82a29Fo
X-Google-Smtp-Source: AK7set/T7+Q5Ke9RAIXNTmgqQbtMEUTRVqygR/D0yPOOLVxW7rdMx82FATVHqvrUVFUW95IfthV6DaNu7gewVFyrgNA=
X-Received: by 2002:a17:90b:1e47:b0:230:b973:a726 with SMTP id
 pi7-20020a17090b1e4700b00230b973a726mr937824pjb.23.1676584180003; Thu, 16 Feb
 2023 13:49:40 -0800 (PST)
MIME-Version: 1.0
References: <20230214190221.1156876-1-shy828301@gmail.com>
 <alpine.LRH.2.21.2302150716120.5940@file01.intranet.prod.int.rdu2.redhat.com>
 <CAHbLzkr4RrKpR1pGZxs7JdB=R539SiNgO2+Fr7X-rVKcBh5tQQ@mail.gmail.com>
 <alpine.LRH.2.21.2302161204300.18393@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.21.2302161204300.18393@file01.intranet.prod.int.rdu2.redhat.com>
From: Yang Shi <shy828301@gmail.com>
Date: Thu, 16 Feb 2023 13:49:28 -0800
Message-ID: <CAHbLzkp8odDNqX49mrEQc9Pk3=-3KxXvuhOe5Ny80ABwjBhx=w@mail.gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Fri, 17 Feb 2023 00:27:53 +0000
Subject: Re: [dm-devel] [v2 PATCH 0/5] Introduce mempool pages bulk
 allocator and use it in dm-crypt
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
 akpm@linux-foundation.org, mgorman@techsingularity.net, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Feb 16, 2023 at 9:45 AM Mikulas Patocka <mpatocka@redhat.com> wrote:
>
>
>
> On Wed, 15 Feb 2023, Yang Shi wrote:
>
> > On Wed, Feb 15, 2023 at 4:23 AM Mikulas Patocka <mpatocka@redhat.com> wrote:
> > >
> > >
> > >
> > > On Tue, 14 Feb 2023, Yang Shi wrote:
> > >
> > > >
> > > > Changelog:
> > > > RFC -> v2:
> > > >   * Added callback variant for page bulk allocator and mempool bulk allocator
> > > >     per Mel Gorman.
> > > >   * Used the callback version in dm-crypt driver.
> > > >   * Some code cleanup and refactor to reduce duplicate code.
> > > >
> > > > rfc: https://lore.kernel.org/linux-mm/20221005180341.1738796-1-shy828301@gmail.com/
> > >
> > > Hi
> > >
> > > This seems like unneeded complication to me. We have alloc_pages(), it can
> > > allocate multiple pages efficiently, so why not use it?
> >
> > The alloc_pages() allocates *contiguous* pages, but dm-crypt doesn't
> > need contiguous pages at all. This may incur unnecessary compaction
>
> It doesn't hurt that the pages are contiguous - and allocating and freeing
> a few compound pages is even faster than allocating and freeing many
> 0-order pages.

If "allocating many order-0 pages" means calling alloc_page() multiple
times, just like what the dm-crypt code does before this patchset,
yeah, allocating a compound page may be faster.

But it may be not true with bulk allocator. And it also depends on how
bad the fragmentation is and how contended the zone lock is. When
allocating order-0 page, the bulk allocator just could take the pages
from pcp list within one call. And the pcp list could hold a lot pages
actually, on my test machine per pcp list could have more than 1000
pages.

>
> > overhead to the dm-crypt layer when memory is fragmented.
>
> The compaction overhead may be suppressed by the GFP flags (i.e. don't use
> __GFP_DIRECT_RECLAIM).

You could, but you may pressure the mempool quite more often when
light memory pressure and fragmentation exist. The bulk allocator may
just succeed with light reclamation without allocating from mempool.

>
> > The bulk allocator is a good fit to this usecase, which allocates
> > multiple order-0 pages.
> >
> > In addition, filesystem writeback doesn't guarantee power-of-2 pages
> > every time IIUC. But alloc_pages() just can allocate power-of-2 pages.
>
> So, we can allocate more compound pages for the non-power-of-2 case - see
> the next patch that I'm sending.

Thanks for the patch. If the callers are willing to handle the
complexity (calculating the proper orders, dealing with the compound
pages, etc), it is definitely an option for them.

>
> > >
> > > I suggest to modify crypt_alloc_buffer() to use alloc_pages() and if
> > > alloc_pages() fails (either because the system is low on memory or because
> > > memory is too fragmented), fall back to the existing code that does
> > > mempool_alloc().
> >
> > My PoC patches just did this way, but called bulk allocator. There may
> > be other potential mepool users as I listed in this cover letter,
> > which may get benefits from bulk allocator. So introducing a new bulk
> > mempool API seems better for long run although we just have one user
> > for now. And it makes other uses easier to gain the benefit by just
> > calling the new API.
>
> This mempool bulk refactoring just makes the code bigger. And it is not
> needed - dm-crypt can fall-back to non-bulk mempool allocations.

Do you mean the mempool code? It may be inevitable by adding a new
API. But it is not significantly bigger. And the API hides all the
details and complexity from the callers, as well as handle all the
allocation corner cases in mm layer. It would make the users life much
easier. Of course if the callers are happy to handle all the
complexity by themselves, they don't have to call the API.

>
> In the next email, I'm sending a patch that is noticeably smaller and that
> uses alloc_pages()/__free_pages().

Thanks for the patch. But if other potential users would like to do
the same optimization, the code have to be duplicated everywhere.
Maybe not every one is happy to handle this by themselves.

>
> Mikulas
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

