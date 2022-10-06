Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC5B7C433F5
	for <dm-devel@archiver.kernel.org>; Fri,  7 Oct 2022 06:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1665124094;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=VwbEraD6S55fpzRiqL8zNPp1Q30aBcVQssIbeMbmaZc=;
	b=aKcY+wbw0VOwP0orE+ZO2JKXS+FYTuSic53gRxQSyYHkn4QNYJy+EAhq6bqhxcM+1ObcnC
	gRjnuNFQ9bGBq4WVqWXq1uIuqVLi78Hs8rIC3GFPRH5jbU+iArOJHbnGceCmWsHm73TAuS
	zq9hvweYTAbsZS7+UxuZ78ez7KETW+E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-37-6LYbSNW2NQOk9pcQuTxXFA-1; Fri, 07 Oct 2022 02:28:11 -0400
X-MC-Unique: 6LYbSNW2NQOk9pcQuTxXFA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AB7C0185A7A3;
	Fri,  7 Oct 2022 06:28:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D0B001402C01;
	Fri,  7 Oct 2022 06:28:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7EBC31946A49;
	Fri,  7 Oct 2022 06:28:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E41921946588
 for <dm-devel@listman.corp.redhat.com>; Thu,  6 Oct 2022 18:43:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B7B27404705F; Thu,  6 Oct 2022 18:43:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B0E5B404705A
 for <dm-devel@redhat.com>; Thu,  6 Oct 2022 18:43:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 920F52A2AD74
 for <dm-devel@redhat.com>; Thu,  6 Oct 2022 18:43:41 +0000 (UTC)
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com
 [209.85.214.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-110-xvV__9UDM6m7R-v6Oi9sFQ-1; Thu, 06 Oct 2022 14:43:35 -0400
X-MC-Unique: xvV__9UDM6m7R-v6Oi9sFQ-1
Received: by mail-pl1-f173.google.com with SMTP id c24so2511861plo.3;
 Thu, 06 Oct 2022 11:43:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=WP+EI4SSCkM2swdzFsOehVVg2VMMJeFZlUzZRWJA3M8=;
 b=i3Q/nMJG2G5ImabBprZOzvLaAfT0270RdsTRHXCNT4riBdkSduHlSLim/vzqUPLHcd
 XiT611/o1G7TxmydqEZRPt4qNRRMC872c+VkuOK8EVQ6pTDeJ8A+kT/LI2NJNfpF9y8Z
 sWXzabmny07MFIYIXkeiBk2u7ITKhczwbOJHKpxQ5r1oOKHX3azMfx/rFWAeS8DeYdXf
 EoeFiUSpD/0OltbyBtggCuANSl6tnWI6hrM1Ab6CaqpZanclUlEdlJ6dCFVjUE6FRfGV
 57mDCK70IhH2eHt2tP8QEEdYTJ+IRaRPOKCdN307mvRyy8NNS1N7k6GgpRaPBigI5wbD
 wNHw==
X-Gm-Message-State: ACrzQf3K7zSjPt+8OZitnWryO6wiL9uNEtKndMpcOIPQXpGriJ1ccNcR
 cohmibmC3jqVrclsAan+9DaKXf9Ou8A6z+EjB97yuAKO
X-Google-Smtp-Source: AMsMyM5R7Z42TNNA1tMYIegVXcP07NIU1oHEmI3BRNLHVLakFg15TMdvprayB+SwHTUk4MLp83RzkNpprXxB9P+6afI=
X-Received: by 2002:a17:903:41d2:b0:17d:707a:3618 with SMTP id
 u18-20020a17090341d200b0017d707a3618mr755584ple.61.1665081813669; Thu, 06 Oct
 2022 11:43:33 -0700 (PDT)
MIME-Version: 1.0
References: <20221005180341.1738796-1-shy828301@gmail.com>
 <20221005180341.1738796-3-shy828301@gmail.com>
 <Yz7qeI0s6TjSEIFe@bfoster>
In-Reply-To: <Yz7qeI0s6TjSEIFe@bfoster>
From: Yang Shi <shy828301@gmail.com>
Date: Thu, 6 Oct 2022 11:43:21 -0700
Message-ID: <CAHbLzkprAJFApT8hK5z8MB8Xc4Kq6ZDTXJRByujQNEgcvo5TgQ@mail.gmail.com>
To: Brian Foster <bfoster@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Fri, 07 Oct 2022 06:28:03 +0000
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
 akpm@linux-foundation.org, mgorman@techsingularity.net, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Oct 6, 2022 at 7:47 AM Brian Foster <bfoster@redhat.com> wrote:
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
> > ---
>
> Hi Yang,
>
> I'm not terribly familiar with either component so I'm probably missing
> context/details, but just a couple high level thoughts when reading your
> patches...
>
> >  include/linux/mempool.h |  19 ++++
> >  mm/mempool.c            | 188 +++++++++++++++++++++++++++++++++++++---
> >  2 files changed, 197 insertions(+), 10 deletions(-)
> >
> ...
> > diff --git a/mm/mempool.c b/mm/mempool.c
> > index ba32151f3843..7711ca2e6d66 100644
> > --- a/mm/mempool.c
> > +++ b/mm/mempool.c
> > @@ -177,6 +177,7 @@ void mempool_destroy(mempool_t *pool)
> >  EXPORT_SYMBOL(mempool_destroy);
> >
> >  static inline int __mempool_init(mempool_t *pool, int min_nr,
> > +                              mempool_alloc_pages_bulk_t *alloc_pages_bulk_fn,
> >                                mempool_alloc_t *alloc_fn,
> >                                mempool_free_t *free_fn, void *pool_data,
> >                                gfp_t gfp_mask, int node_id)
> > @@ -186,8 +187,11 @@ static inline int __mempool_init(mempool_t *pool, int min_nr,
> >       pool->pool_data = pool_data;
> >       pool->alloc     = alloc_fn;
> >       pool->free      = free_fn;
> > +     pool->alloc_pages_bulk = alloc_pages_bulk_fn;
> >       init_waitqueue_head(&pool->wait);
> >
> > +     WARN_ON_ONCE(alloc_pages_bulk_fn && alloc_fn);
> > +
> >       pool->elements = kmalloc_array_node(min_nr, sizeof(void *),
> >                                           gfp_mask, node_id);
> >       if (!pool->elements)
> > @@ -199,7 +203,10 @@ static inline int __mempool_init(mempool_t *pool, int min_nr,
> >       while (pool->curr_nr < pool->min_nr) {
> >               void *element;
> >
> > -             element = pool->alloc(gfp_mask, pool->pool_data);
> > +             if (pool->alloc_pages_bulk)
> > +                     element = alloc_page(gfp_mask);
>
> Any reason to not use the callback from the caller for the bulk variant
> here? It looks like some users might expect consistency between the
> alloc / free callbacks for the pool. I.e., I'm not familiar with
> dm-crypt, but the code modified in the subsequent patches looks like it
> keeps an allocated page count. Will that still work with this, assuming
> these pages are freed through free_fn?

No special reason, this implementation just end up with fewer code
otherwise we should need to define a list, and manipulate the list,
seems like a little bit overkilling for initialization code.

Yes, that allocated page count works, just the pages in the pool are
not counted in the count anymore, 256 pages should be not a big deal
IMHO.

>
> > +             else
> > +                     element = pool->alloc(gfp_mask, pool->pool_data);
> >               if (unlikely(!element)) {
> >                       mempool_exit(pool);
> >                       return -ENOMEM;
> ...
> > @@ -457,6 +499,132 @@ void *mempool_alloc(mempool_t *pool, gfp_t gfp_mask)
> >  }
> >  EXPORT_SYMBOL(mempool_alloc);
> >
> > +/**
> > + * mempool_alloc_pages_bulk - allocate a bulk of pagesfrom a specific
> > + *                           memory pool
> > + * @pool:       pointer to the memory pool which was allocated via
> > + *              mempool_create().
> > + * @gfp_mask:   the usual allocation bitmask.
> > + * @nr:         the number of requested pages.
> > + * @page_list:  the list the pages will be added to.
> > + * @page_array: the array the pages will be added to.
> > + *
> > + * this function only sleeps if the alloc_pages_bulk_fn() function sleeps
> > + * or the allocation can not be satisfied even though the mempool is depleted.
> > + * Note that due to preallocation, this function *never* fails when called
> > + * from process contexts. (it might fail if called from an IRQ context.)
> > + * Note: using __GFP_ZERO is not supported.  And the caller should not pass
> > + * in both valid page_list and page_array.
> > + *
> > + * Return: true when nr pages are allocated or false if not.  It is the
> > + *         caller's responsibility to free the partial allocated pages.
> > + */
> > +static bool mempool_alloc_pages_bulk(mempool_t *pool, gfp_t gfp_mask,
> > +                                  unsigned int nr,
> > +                                  struct list_head *page_list,
> > +                                  struct page **page_array)
> > +{
> > +     unsigned long flags;
> > +     wait_queue_entry_t wait;
> > +     gfp_t gfp_temp;
> > +     int i;
> > +     unsigned int ret, nr_remaining;
> > +     struct page *page;
> > +
>
> This looks like a lot of duplicate boilerplate from mempool_alloc().
> Could this instead do something like: rename the former to
> __mempool_alloc() and add a count parameter, implement bulk alloc
> support in there for count > 1, then let traditional (i.e., non-bulk)
> mempool_alloc() callers pass a count of 1?

Thanks for the suggestion. Yeah, the duplicate code is not perfect. I
thought about this way too, but it may need to have a lot of "if
(count > 0)" of "if (is_bulk_alloc) " if a flag is used in the code to
handle the bulk allocation, for example, calculate remaining nr, loop
to remove element from the pool, manipulate list or array, etc. Seems
not that readable IMHO.

We may be able to extract some common code into shared helpers, for
example, the gfp sanitization and wait logic.

>
> Along the same lines, I also wonder if there's any value in generic bulk
> alloc support for mempool. For example, I suppose technically this could
> be implemented via one change to support a pool->alloc_bulk() callback
> that any user could implement via a loop if they wanted
> mempool_alloc_bulk() support backed by a preallocated pool. The page
> based user could then just use that to call alloc_pages_bulk_*() as an
> optimization without the mempool layer needing to know or care about
> whether the underlying elements are pages or not. Hm?

Thanks for the suggestion. Actually I thought about this too. But the
memory space overhead, particularly stack space seems like a
showstopper to me. We just can put the pointers into an array, but
this may consume a significant amount of stack memory. One pointer is
8 bytes, 256 objects imply 2K stack space. Of course the users could
move the array into a dynamic allocated data structure, but this may
need the users modify their driver. Bulk kmalloc via kmalloc_array()
may be fine, this is the only usercase other than pages I could think
of.

>
> Brian
>
> > +     VM_WARN_ON_ONCE(gfp_mask & __GFP_ZERO);
> > +     might_alloc(gfp_mask);
> > +
> > +     gfp_mask |= __GFP_NOMEMALLOC;   /* don't allocate emergency reserves */
> > +     gfp_mask |= __GFP_NORETRY;      /* don't loop in __alloc_pages */
> > +     gfp_mask |= __GFP_NOWARN;       /* failures are OK */
> > +
> > +     gfp_temp = gfp_mask & ~(__GFP_DIRECT_RECLAIM|__GFP_IO);
> > +
> > +repeat_alloc:
> > +     i = 0;
> > +     ret = pool->alloc_pages_bulk(gfp_temp, nr, pool->pool_data, page_list,
> > +                                  page_array);
> > +
> > +     if (ret == nr)
> > +             return true;
> > +
> > +     nr_remaining = nr - ret;
> > +
> > +     spin_lock_irqsave(&pool->lock, flags);
> > +     /* Allocate page from the pool and add to the list or array */
> > +     while (pool->curr_nr && (nr_remaining > 0)) {
> > +             page = remove_element(pool);
> > +             spin_unlock_irqrestore(&pool->lock, flags);
> > +             smp_wmb();
> > +
> > +             kmemleak_update_trace((void *)page);
> > +
> > +             if (page_list)
> > +                     list_add(&page->lru, page_list);
> > +             else
> > +                     page_array[ret + i] = page;
> > +
> > +             i++;
> > +             nr_remaining--;
> > +
> > +             spin_lock_irqsave(&pool->lock, flags);
> > +     }
> > +
> > +     spin_unlock_irqrestore(&pool->lock, flags);
> > +
> > +     if (!nr_remaining)
> > +             return true;
> > +
> > +     /*
> > +      * The bulk allocator counts in the populated pages for array,
> > +      * but don't do it for list.
> > +      */
> > +     if (page_list)
> > +             nr = nr_remaining;
> > +
> > +     /*
> > +      * We use gfp mask w/o direct reclaim or IO for the first round.  If
> > +      * alloc failed with that and @pool was empty, retry immediately.
> > +      */
> > +     if (gfp_temp != gfp_mask) {
> > +             gfp_temp = gfp_mask;
> > +             goto repeat_alloc;
> > +     }
> > +
> > +     /* We must not sleep if !__GFP_DIRECT_RECLAIM */
> > +     if (!(gfp_mask & __GFP_DIRECT_RECLAIM))
> > +             return false;
> > +
> > +     /* Let's wait for someone else to return an element to @pool */
> > +     init_wait(&wait);
> > +     prepare_to_wait(&pool->wait, &wait, TASK_UNINTERRUPTIBLE);
> > +
> > +     /*
> > +      * FIXME: this should be io_schedule().  The timeout is there as a
> > +      * workaround for some DM problems in 2.6.18.
> > +      */
> > +     io_schedule_timeout(5*HZ);
> > +
> > +     finish_wait(&pool->wait, &wait);
> > +     goto repeat_alloc;
> > +}
> > +
> > +bool mempool_alloc_pages_bulk_list(mempool_t *pool, gfp_t gfp_mask,
> > +                                unsigned int nr,
> > +                                struct list_head *page_list)
> > +{
> > +     return mempool_alloc_pages_bulk(pool, gfp_mask, nr, page_list, NULL);
> > +}
> > +EXPORT_SYMBOL(mempool_alloc_pages_bulk_list);
> > +
> > +bool mempool_alloc_pages_bulk_array(mempool_t *pool, gfp_t gfp_mask,
> > +                                 unsigned int nr,
> > +                                 struct page **page_array)
> > +{
> > +     return mempool_alloc_pages_bulk(pool, gfp_mask, nr, NULL, page_array);
> > +}
> > +EXPORT_SYMBOL(mempool_alloc_pages_bulk_array);
> > +
> >  /**
> >   * mempool_free - return an element to the pool.
> >   * @element:   pool element pointer.
> > --
> > 2.26.3
> >
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

