Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4C55C6FD1C
	for <dm-devel@archiver.kernel.org>; Fri, 24 Mar 2023 22:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679698411;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=NJqwcUqG8d8kacwh35kzMNkuRMZH9HtaesFlqCM3gwE=;
	b=HIqx0piCoCDaBXJca0wT3qeNaxPdK7GVH8FT/xseDqNysHQnsYRQZ3L4z+HU6b1A6wPQsO
	FclvFAspIEfvkp4Zmkbdy5hk12Jm0UknCC7aNltprPD/AecgANcZOxtKcclciSFtSXl7D+
	kfjGPvVlWc+6CMFMmtYGBHEybsDwEbg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-214-vLqFjkyQOIyPw6UCtaHpEw-1; Fri, 24 Mar 2023 18:53:28 -0400
X-MC-Unique: vLqFjkyQOIyPw6UCtaHpEw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5AFD429DD9A3;
	Fri, 24 Mar 2023 22:53:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BEA9F492B0A;
	Fri, 24 Mar 2023 22:53:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4FA891946A5E;
	Fri, 24 Mar 2023 22:53:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1ADDE1946A5A
 for <dm-devel@listman.corp.redhat.com>; Fri, 24 Mar 2023 22:53:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B39271410F00; Fri, 24 Mar 2023 22:53:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id ABEC1140E950
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 22:53:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 35A4B85A588
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 22:53:16 +0000 (UTC)
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com
 [209.85.219.41]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-146-KLPF1GqDO4GS2nUm6bZEkg-1; Fri, 24 Mar 2023 18:53:14 -0400
X-MC-Unique: KLPF1GqDO4GS2nUm6bZEkg-1
Received: by mail-qv1-f41.google.com with SMTP id t13so2734607qvn.2
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 15:53:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679698394;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=D2MpDxOY5RTaPCS6YUqDqZGPOq9SUUHMYR88rSvDxb0=;
 b=Plu9+jgXaAK82D6FrCCY4efU7TYpc2sgs42pwqqYYByk1DodswrzQdZNBUON2wwvEJ
 d42Tvqoxo/oJWlYRUO3beXC+KBblnl4fP3a6moYz3ORS1d/GYRK9dCXsnWxypXmdus9I
 axD+4/94+kSpFnqgx5ar09hpPYMqdpI2YZAw9iWir6DfytjJ5NYZG7r9BQZj9BP0JIR8
 dXcxjUx4LcnJ7W/R75sU2bd1kdjpes3flPyWBwW3kc4+Ma5qGwN8brULPnTJabm1S8Ew
 raaQN6LCIFh+FOOMFnEY12pu98Lll4r9ldPyi4T7mTgO4LUNAJtDGClYYuvaKX51LOtk
 vl5w==
X-Gm-Message-State: AO0yUKUegDO+CV+V5muxtWyOGScGw6il2/ScEtlCGzCMrtWv/NTb2jA7
 IbhJNKUsOf/8PSFnYbVsYCoYnfs=
X-Google-Smtp-Source: AK7set/iYYymePQwRI7TQ++q8v7dFgzltOarcjA35d7r8ahvMsODuUaCYQTHnnEAWIN7XZcX+qpovw==
X-Received: by 2002:a05:6214:509c:b0:56f:8b5:3e94 with SMTP id
 kk28-20020a056214509c00b0056f08b53e94mr16097821qvb.14.1679698394092; 
 Fri, 24 Mar 2023 15:53:14 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 w3-20020a056214012300b005dd8b9345f3sm1027541qvs.139.2023.03.24.15.53.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 24 Mar 2023 15:53:13 -0700 (PDT)
Date: Fri, 24 Mar 2023 18:53:12 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Message-ID: <ZB4p2NfwIhh9raxa@redhat.com>
References: <20230324175656.85082-1-snitzer@kernel.org>
 <20230324175656.85082-4-snitzer@kernel.org>
 <a1b8ceb8-0a67-86a1-2222-1625f6ebbe33@kernel.dk>
MIME-Version: 1.0
In-Reply-To: <a1b8ceb8-0a67-86a1-2222-1625f6ebbe33@kernel.dk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [dm-6.4 PATCH v2 3/9] dm bufio: improve concurrent
 IO performance
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
Cc: linux-block@vger.kernel.org, keescook@chromium.org, heinzm@redhat.com,
 ejt@redhat.com, nhuck@google.com, ebiggers@kernel.org, dm-devel@redhat.com,
 mpatocka@redhat.com, luomeng12@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Mar 24 2023 at  3:34P -0400,
Jens Axboe <axboe@kernel.dk> wrote:

> Just some random drive-by comments.
> 
> > diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> > index 1de1bdcda1ce..a58f8ac3ba75 100644
> > --- a/drivers/md/dm-bufio.c
> > +++ b/drivers/md/dm-bufio.c
> > +static void lru_destroy(struct lru *lru)
> > +{
> > +	BUG_ON(lru->cursor);
> > +	BUG_ON(!list_empty(&lru->iterators));
> > +}
> 
> Ehm no, WARN_ON_ONCE() for these presumably.

Yeah, I raised concern about the BUG_ONs with Joe. Will try to rid the
code of BUG_ONs as follow-on work.
 
> > @@ -116,9 +366,579 @@ struct dm_buffer {
> >  #endif
> >  };
> >  
> > +/*--------------------------------------------------------------*/
> > +
> > +/*
> > + * The buffer cache manages buffers, particularly:
> > + *  - inc/dec of holder count
> > + *  - setting the last_accessed field
> > + *  - maintains clean/dirty state along with lru
> > + *  - selecting buffers that match predicates
> > + *
> > + * It does *not* handle:
> > + *  - allocation/freeing of buffers.
> > + *  - IO
> > + *  - Eviction or cache sizing.
> > + *
> > + * cache_get() and cache_put() are threadsafe, you do not need to
> > + * protect these calls with a surrounding mutex.  All the other
> > + * methods are not threadsafe; they do use locking primitives, but
> > + * only enough to ensure get/put are threadsafe.
> > + */
> > +
> > +#define NR_LOCKS 64
> > +#define LOCKS_MASK (NR_LOCKS - 1)
> > +
> > +struct tree_lock {
> > +	struct rw_semaphore lock;
> > +} ____cacheline_aligned_in_smp;
> > +
> > +struct dm_buffer_cache {
> > +	/*
> > +	 * We spread entries across multiple trees to reduce contention
> > +	 * on the locks.
> > +	 */
> > +	struct tree_lock locks[NR_LOCKS];
> > +	struct rb_root roots[NR_LOCKS];
> > +	struct lru lru[LIST_SIZE];
> > +};
> 
> This:
> 
> struct foo_tree {
> 	struct rw_semaphore lock;
> 	struct rb_root root;
> 	struct lru lru;
> } ____cacheline_aligned_in_smp;
> 
> would be a lot better.
> 
> And where does this NR_LOCKS come from? Don't make up magic values out
> of thin air. Should this be per-cpu? per-node? N per node? I'll bet you
> that 64 is way too much for most use cases, and too little for others.

I cannot speak to the 64 magic value (other than I think it worked
well for Joe's testbed).  But the point of this exercise is to split
the lock to avoid contention.  Using 64 accomplishes this. Having
there be more or less isn't _that_ critical.  The hash to get the
region index isn't a function of cpu.  We aren't after lockless here.

Now that said, will certainly discuss further with Joe and see if we
can be smarter here.

Your suggestion to combine members certainly makes a lot of sense.  I
ran with it relative to the bio-prison-v1 (patch 9) changes which have
the same layout. Definitely a win on in-core memory as well as
avoiding cacheline thrashing while accessing the lock and then the
rb_root members (as is always expected):

Before:

# pahole -C dm_bio_prison drivers/md/dm-bio-prison.ko
struct dm_bio_prison {
        struct lock                lock[64] __attribute__((__aligned__(64))); /*     0  4096 */
        /* --- cacheline 64 boundary (4096 bytes) --- */
        struct rb_root             cells[64];            /*  4096   512 */
        /* --- cacheline 72 boundary (4608 bytes) --- */
        mempool_t                  cell_pool;            /*  4608    72 */

        /* size: 4736, cachelines: 74, members: 3 */
        /* padding: 56 */
        /* forced alignments: 1 */
} __attribute__((__aligned__(64)));

After:

# pahole -C prison_region drivers/md/dm-bio-prison.ko
struct prison_region {
        spinlock_t                 lock;                 /*     0     4 */

        /* XXX 4 bytes hole, try to pack */

        struct rb_root             cell;                 /*     8     8 */

        /* size: 64, cachelines: 1, members: 2 */
        /* sum members: 12, holes: 1, sum holes: 4 */
        /* padding: 48 */
} __attribute__((__aligned__(64)));

# pahole -C dm_bio_prison drivers/md/dm-bio-prison.ko
struct dm_bio_prison {
        struct prison_region       regions[64] __attribute__((__aligned__(64))); /*     0  4096 */
        /* --- cacheline 64 boundary (4096 bytes) --- */
        mempool_t                  cell_pool;            /*  4096    72 */

        /* size: 4224, cachelines: 66, members: 2 */
        /* padding: 56 */
        /* forced alignments: 1 */
} __attribute__((__aligned__(64)));
 
> > @@ -1141,7 +1904,6 @@ static void *new_read(struct dm_bufio_client *c, sector_t block,
> >  	}
> >  
> >  	*bp = b;
> > -
> >  	return b->data;
> >  }
> >  
> 
> Unrelated change. There are a bunch of these.

I knocked those out, and also the various bracing issues.
 
> I stopped reading here, the patch is just too long. Surely this could be
> split up?
> 
>  1 file changed, 1292 insertions(+), 477 deletions(-)
> 
> That's not a patch, that's a patch series.

I don't want to upset you or the community but saying this but:
in this narrow instance where a sizable percentage of the file got
rewritten: to properly review this work you need to look at the full
scope of the changes in combination.

The effort required by the developer to split the code to ease mail
client based review wasn't worth it to me.  Mikulas and myself bear
the burden of review on dm-bufio.c -- so I gave Joe a pass on
splitting because it is make-work to appease the "thou shalt spoon
feed reviewers on a mailing list" rule (that again, I argue isn't
applicable for more elaborate changes that are in the end
intertwined). It hardly seems like time well spent to now go back and
re-write the code in terms of layered patches.

I'd much rather we spend that time on eliminating the abuse of
BUG_ONs, etc.

(I stopped short of saying this to you in chat because I wasn't
prepared to get into a tight loop with you interactively at that
particular moment.. or maybe ever ;)

But again, like I said in chat: I'll look closer, and of course
discuss with Joe, to see if splitting is worth the investment.

Thanks for your review, very much appreciated.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

