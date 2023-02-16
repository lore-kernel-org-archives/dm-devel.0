Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5D1BC61DA4
	for <dm-devel@archiver.kernel.org>; Thu, 16 Feb 2023 17:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676569521;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=vvDOLUZJEj4jMlVPa2vgvw7z7vrKGhtRFoKOBAG2i4s=;
	b=amGgmOG4ujHDHiQcHUG5hkNCyW3PvQN9qCFPOTqKlO0rvuvPwJi8+48MrW02xd06AFig5Y
	ijVLv6xdZEh+Z9uXL2gV+1GH4sHrNlWB4yyI+/wRmkiy52xdcyrVsQiW8nd2GgasaTT3eT
	jAoVqSVqsfPxx/9/XjszNmLcaEIMkik=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-397-gtZYVNNPNealpHxjNOg_Vw-1; Thu, 16 Feb 2023 12:45:20 -0500
X-MC-Unique: gtZYVNNPNealpHxjNOg_Vw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 681E6802C1D;
	Thu, 16 Feb 2023 17:45:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1534A1121314;
	Thu, 16 Feb 2023 17:45:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CC89D1946589;
	Thu, 16 Feb 2023 17:45:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 217221946595
 for <dm-devel@listman.corp.redhat.com>; Thu, 16 Feb 2023 17:45:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 20C3A492B18; Thu, 16 Feb 2023 17:45:12 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 02756492B15;
 Thu, 16 Feb 2023 17:45:12 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 31GHjBfP024047; Thu, 16 Feb 2023 12:45:11 -0500
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 31GHjBZ0024043; Thu, 16 Feb 2023 12:45:11 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Thu, 16 Feb 2023 12:45:11 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Yang Shi <shy828301@gmail.com>
In-Reply-To: <CAHbLzkr4RrKpR1pGZxs7JdB=R539SiNgO2+Fr7X-rVKcBh5tQQ@mail.gmail.com>
Message-ID: <alpine.LRH.2.21.2302161204300.18393@file01.intranet.prod.int.rdu2.redhat.com>
References: <20230214190221.1156876-1-shy828301@gmail.com>
 <alpine.LRH.2.21.2302150716120.5940@file01.intranet.prod.int.rdu2.redhat.com>
 <CAHbLzkr4RrKpR1pGZxs7JdB=R539SiNgO2+Fr7X-rVKcBh5tQQ@mail.gmail.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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



On Wed, 15 Feb 2023, Yang Shi wrote:

> On Wed, Feb 15, 2023 at 4:23 AM Mikulas Patocka <mpatocka@redhat.com> wrote:
> >
> >
> >
> > On Tue, 14 Feb 2023, Yang Shi wrote:
> >
> > >
> > > Changelog:
> > > RFC -> v2:
> > >   * Added callback variant for page bulk allocator and mempool bulk allocator
> > >     per Mel Gorman.
> > >   * Used the callback version in dm-crypt driver.
> > >   * Some code cleanup and refactor to reduce duplicate code.
> > >
> > > rfc: https://lore.kernel.org/linux-mm/20221005180341.1738796-1-shy828301@gmail.com/
> >
> > Hi
> >
> > This seems like unneeded complication to me. We have alloc_pages(), it can
> > allocate multiple pages efficiently, so why not use it?
> 
> The alloc_pages() allocates *contiguous* pages, but dm-crypt doesn't
> need contiguous pages at all. This may incur unnecessary compaction

It doesn't hurt that the pages are contiguous - and allocating and freeing 
a few compound pages is even faster than allocating and freeing many 
0-order pages.

> overhead to the dm-crypt layer when memory is fragmented.

The compaction overhead may be suppressed by the GFP flags (i.e. don't use 
__GFP_DIRECT_RECLAIM).

> The bulk allocator is a good fit to this usecase, which allocates 
> multiple order-0 pages.
> 
> In addition, filesystem writeback doesn't guarantee power-of-2 pages
> every time IIUC. But alloc_pages() just can allocate power-of-2 pages.

So, we can allocate more compound pages for the non-power-of-2 case - see 
the next patch that I'm sending.

> >
> > I suggest to modify crypt_alloc_buffer() to use alloc_pages() and if
> > alloc_pages() fails (either because the system is low on memory or because
> > memory is too fragmented), fall back to the existing code that does
> > mempool_alloc().
> 
> My PoC patches just did this way, but called bulk allocator. There may
> be other potential mepool users as I listed in this cover letter,
> which may get benefits from bulk allocator. So introducing a new bulk
> mempool API seems better for long run although we just have one user
> for now. And it makes other uses easier to gain the benefit by just
> calling the new API.

This mempool bulk refactoring just makes the code bigger. And it is not 
needed - dm-crypt can fall-back to non-bulk mempool allocations.

In the next email, I'm sending a patch that is noticeably smaller and that 
uses alloc_pages()/__free_pages().

Mikulas
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

