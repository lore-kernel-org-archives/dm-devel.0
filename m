Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A83EAC6FD1F
	for <dm-devel@archiver.kernel.org>; Sat, 25 Mar 2023 04:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679718120;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=b5XZw9X+HsyxaQH8bDJRfHKJ8yFDJO6LJOJ9D/iao0g=;
	b=Xqg52vIo34E/NryEEaQ+K5i2nrWfqYYju+7tYKvlW3CXW+FcPQ3l0+lQfBBCjqG+cxKeOv
	IQcPlXxcA6Q01tScAsq3kcOBVeXkdGLxhdCMWriw67d+BKrQhbwfhfTCAUUxRCL0MkhQMl
	S0TwO0kYhjVJKpl2o3pwx+UAj4o4PBw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-153-9dQHyxsLOde891Y89F2Xpg-1; Sat, 25 Mar 2023 00:21:56 -0400
X-MC-Unique: 9dQHyxsLOde891Y89F2Xpg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BB64A101A531;
	Sat, 25 Mar 2023 04:21:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6E9201121314;
	Sat, 25 Mar 2023 04:21:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 22DB31946A5E;
	Sat, 25 Mar 2023 04:21:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BD99C1946A5A
 for <dm-devel@listman.corp.redhat.com>; Sat, 25 Mar 2023 04:21:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B1B94492B01; Sat, 25 Mar 2023 04:21:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A941F492C3E
 for <dm-devel@redhat.com>; Sat, 25 Mar 2023 04:21:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8CE2D801206
 for <dm-devel@redhat.com>; Sat, 25 Mar 2023 04:21:50 +0000 (UTC)
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com
 [209.85.219.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-75-AYYb5NC1NK-mpB_rnw7Hpw-1; Sat, 25 Mar 2023 00:21:47 -0400
X-MC-Unique: AYYb5NC1NK-mpB_rnw7Hpw-1
Received: by mail-qv1-f47.google.com with SMTP id 59so2945790qva.11
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 21:21:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679718106;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=zBSDGh3YS3Fa9eWwcS4CMFYL4Pj94WmAyTt+eo4ImG4=;
 b=bOmJCRp8wIr+arbxDW8EQ2bxeZFgiFHNCAB6dx5rsoQN/pQg7WajEUTU5fFdCFBc7j
 sZP/7LjJc2W6q+BTPk8GeoUThRiGheHQEJmoeAilZVVSPVL+rTdASnWOufWFNXzeTyOm
 oHwL3m4iLCr6KLgeW1uM8XV8cYU90DKTLgbgrF1iij+KdWlRw9SkqclxgsVAN9lStEkD
 nViybHEFe3ajdX6o1mQiH663jOZzSvDJDqQTMA9CRbPh/i9bSOCcGsSpfImGsren+6Go
 ABxBxDYWBYDS1rTsL26HzKf7hAOJrzLmcq68Sz3yOG061lRghhmaIeQhACeSXExj8DJv
 pcgw==
X-Gm-Message-State: AAQBX9ezHhnRDFRWeZTlNEqpy2JVf+WyXRzOnyb2IlXPLyXV5mb/l0z9
 WDroKeykfRhiuji/a4NmLHr91/0=
X-Google-Smtp-Source: AKy350YbWa8Lhj5JN9We91ubIIL0D4DdSUiFQgWzSvdSvZrBkZXaq0d95Qdrzis/aSc5y9lUPmgw3g==
X-Received: by 2002:a05:6214:2028:b0:5a3:fd18:e734 with SMTP id
 8-20020a056214202800b005a3fd18e734mr9737449qvf.35.1679718106607; 
 Fri, 24 Mar 2023 21:21:46 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 w12-20020a0cc24c000000b005dd8b934568sm1204309qvh.0.2023.03.24.21.21.45
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 24 Mar 2023 21:21:46 -0700 (PDT)
Date: Sat, 25 Mar 2023 00:21:44 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Message-ID: <ZB522MSroOmkyzBC@redhat.com>
References: <20230324175656.85082-1-snitzer@kernel.org>
 <20230324175656.85082-4-snitzer@kernel.org>
 <a1b8ceb8-0a67-86a1-2222-1625f6ebbe33@kernel.dk>
 <ZB4p2NfwIhh9raxa@redhat.com>
 <e552ad80-37fe-247e-aaf1-064572ccc154@kernel.dk>
MIME-Version: 1.0
In-Reply-To: <e552ad80-37fe-247e-aaf1-064572ccc154@kernel.dk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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
Cc: ebiggers@kernel.org, keescook@chromium.org, heinzm@redhat.com,
 dm-devel@redhat.com, nhuck@google.com, linux-block@vger.kernel.org,
 ejt@redhat.com, mpatocka@redhat.com, luomeng12@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Mar 24 2023 at  7:11P -0400,
Jens Axboe <axboe@kernel.dk> wrote:

> On 3/24/23 4:53?PM, Mike Snitzer wrote:
> > On Fri, Mar 24 2023 at  3:34P -0400,
> > Jens Axboe <axboe@kernel.dk> wrote:
> > 
> >> Just some random drive-by comments.
> >>
> >>> diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> >>> index 1de1bdcda1ce..a58f8ac3ba75 100644
> >>> --- a/drivers/md/dm-bufio.c
> >>> +++ b/drivers/md/dm-bufio.c
> >>> +static void lru_destroy(struct lru *lru)
> >>> +{
> >>> +	BUG_ON(lru->cursor);
> >>> +	BUG_ON(!list_empty(&lru->iterators));
> >>> +}
> >>
> >> Ehm no, WARN_ON_ONCE() for these presumably.
> > 
> > Yeah, I raised concern about the BUG_ONs with Joe. Will try to rid the
> > code of BUG_ONs as follow-on work.
> 
> Please do.

FYI, you'll cringe if you open the latest upstream
drivers/dm/dm-bufio.c  Mikulas made heavy use of BUG_ONs. Because of
that Joe started working a code that was setting him up for
persecution (and me by association for allowing it in to begin with).

Good news, the dm-6.4-dev branch I point to below already addresses
many of the historic and new BUG_ONs.
 
> >>> @@ -116,9 +366,579 @@ struct dm_buffer {
> >>>  #endif
> >>>  };
> >>>  
> >>> +/*--------------------------------------------------------------*/
> >>> +
> >>> +/*
> >>> + * The buffer cache manages buffers, particularly:
> >>> + *  - inc/dec of holder count
> >>> + *  - setting the last_accessed field
> >>> + *  - maintains clean/dirty state along with lru
> >>> + *  - selecting buffers that match predicates
> >>> + *
> >>> + * It does *not* handle:
> >>> + *  - allocation/freeing of buffers.
> >>> + *  - IO
> >>> + *  - Eviction or cache sizing.
> >>> + *
> >>> + * cache_get() and cache_put() are threadsafe, you do not need to
> >>> + * protect these calls with a surrounding mutex.  All the other
> >>> + * methods are not threadsafe; they do use locking primitives, but
> >>> + * only enough to ensure get/put are threadsafe.
> >>> + */
> >>> +
> >>> +#define NR_LOCKS 64
> >>> +#define LOCKS_MASK (NR_LOCKS - 1)
> >>> +
> >>> +struct tree_lock {
> >>> +	struct rw_semaphore lock;
> >>> +} ____cacheline_aligned_in_smp;
> >>> +
> >>> +struct dm_buffer_cache {
> >>> +	/*
> >>> +	 * We spread entries across multiple trees to reduce contention
> >>> +	 * on the locks.
> >>> +	 */
> >>> +	struct tree_lock locks[NR_LOCKS];
> >>> +	struct rb_root roots[NR_LOCKS];
> >>> +	struct lru lru[LIST_SIZE];
> >>> +};
> >>
> >> This:
> >>
> >> struct foo_tree {
> >> 	struct rw_semaphore lock;
> >> 	struct rb_root root;
> >> 	struct lru lru;
> >> } ____cacheline_aligned_in_smp;
> >>
> >> would be a lot better.
> >>
> >> And where does this NR_LOCKS come from? Don't make up magic values out
> >> of thin air. Should this be per-cpu? per-node? N per node? I'll bet you
> >> that 64 is way too much for most use cases, and too little for others.
> > 
> > I cannot speak to the 64 magic value (other than I think it worked
> > well for Joe's testbed).  But the point of this exercise is to split
> > the lock to avoid contention.  Using 64 accomplishes this. Having
> > there be more or less isn't _that_ critical.  The hash to get the
> > region index isn't a function of cpu.  We aren't after lockless here.
> 
> I don't doubt it worked well in his setup, and it'll probably be fine in
> a lot of setups. But the point still stands - it's a magic value, it
> should at least be documented. And 64 is likely way too much on a lot of
> machines.

Yeap.

> > Now that said, will certainly discuss further with Joe and see if we
> > can be smarter here.
> > 
> > Your suggestion to combine members certainly makes a lot of sense.  I
> > ran with it relative to the bio-prison-v1 (patch 9) changes which have
> > the same layout. Definitely a win on in-core memory as well as
> > avoiding cacheline thrashing while accessing the lock and then the
> > rb_root members (as is always expected):
> 
> Right, this is why I suggested doing it like that. It's not very smart
> to split related members like that, wastes both memory and is less
> efficient than doing the right thing.

Was just an oversight. The code has had quite some review internally
at Red Hat. But we've been focused on ensuring the code stable. Case
of not seeing the forest from the trees... *shrug*  But nice catch,
appreciate it.

> >> I stopped reading here, the patch is just too long. Surely this could be
> >> split up?
> >>
> >>  1 file changed, 1292 insertions(+), 477 deletions(-)
> >>
> >> That's not a patch, that's a patch series.
> > 
> > I don't want to upset you or the community but saying this but:
> > in this narrow instance where a sizable percentage of the file got
> > rewritten: to properly review this work you need to look at the full
> > scope of the changes in combination.
> 
> That's nonsense. That's like saying "to see what this series does, apply
> the whole thing and compare it with the file before". With that logic,
> why even split changes ever.
> 
> A big patch that could be split is harder to properly review than a lot
> of small patches. Nobody ever reviews a 1000+ line patch. But I guess we
> can just stop reviewing?
> 
> It should be split, it's really not up for debate.

It should. And I've started to do it. I was trying to avoid making
Joe do it after the fact. And I loathe to do it.  It is developing in
reverse, it sucks (but I'm hopeful Joe has the work split out in old
devel trees, will check with him Monday).

For this specific code, the issue is that while the code changes are
split logically between:
1) LRU with clock algorithm
2) DM buffer cache manager
They are pretty tightly coupled (I see no point trying to implement
1 without 2 just to check a review box... it's thankless make-work,
100% so if nobody actually reviews the code that closely). Wanting
code to always be in that form isn't wrong, but it is very much a
suspect requirement if the evolution needs to be recreated in
post-mortum fashion.

And then having reviewers take time to understand various intermediate
transformations the code might go through to reach the final result
isn't necessarily a good use of reviewers' time.

BUT I _have_ already split out commits like this:
https://git.kernel.org/pub/scm/linux/kernel/git/snitzer/linux.git/commit/?h=dm-6.4-dev&id=8de2bc47d6ed5f96855e6262eb928a59e8a2a9cb

And if you look at the broader changes I made tonight in this
dm-6.4-dev tree you'll see I'm taking your review feedback seriously:
https://git.kernel.org/pub/scm/linux/kernel/git/snitzer/linux.git/log/?h=dm-6.4-dev

You'll hear from me with a v3 of this patchset next week.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

