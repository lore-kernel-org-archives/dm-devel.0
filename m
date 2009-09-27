From: Mike Galbraith <efault@gmx.de>
Subject: Re: IO scheduler based IO controller V10
Date: Sun, 27 Sep 2009 20:15:59 +0200
Message-ID: <1254075359.7354.66.camel@marge.simson.net>
References: <1253820332-10246-1-git-send-email-vgoyal@redhat.com>
	 <4ABC28DE.7050809@datenparkplatz.de> <20090925202636.GC15007@redhat.com>
	 <1253976676.7005.40.camel@marge.simson.net>
	 <1254034500.7933.6.camel@marge.simson.net>
	 <20090927164235.GA23126@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751851AbZI0SQI@vger.kernel.org>
In-Reply-To: <20090927164235.GA23126@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com, torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com
List-Id: dm-devel.ids

On Sun, 2009-09-27 at 18:42 +0200, Jens Axboe wrote:
> On Sun, Sep 27 2009, Mike Galbraith wrote:
> > My dd vs load non-cached binary woes seem to be coming from backmerge.
> > 
> > #if 0 /*MIKEDIDIT sand in gearbox?*/
> >         /*
> >          * See if our hash lookup can find a potential backmerge.
> >          */
> >         __rq = elv_rqhash_find(q, bio->bi_sector);
> >         if (__rq && elv_rq_merge_ok(__rq, bio)) {
> >                 *req = __rq;
> >                 return ELEVATOR_BACK_MERGE;
> >         }
> > #endif
> 
> It's a given that not merging will provide better latency.

Yeah, absolutely everything I've diddled that reduces the size of queued
data improves the situation, which makes perfect sense.  This one was a
bit unexpected.  Front merges didn't hurt at all, back merges did, and
lots.  After diddling the code a bit, I had the "well _duh_" moment.

>  We can't
> disable that or performance will suffer A LOT on some systems. There are
> ways to make it better, though. One would be to make the max request
> size smaller, but that would also hurt for streamed workloads. Can you
> try whether the below patch makes a difference? It will basically
> disallow merges to a request that isn't the last one.

That's what all the looking I've done ends up at.  Either you let the
disk be all it can be, and you pay in latency, or you don't, and you pay
in throughput.

> below wont work well for two (or more) streamed cases. I'll think a bit
> about that.

Cool, think away.  I've been eyeballing and pondering how to know when
latency is going to become paramount.  Absolutely nothing is happening,
even for "it's my root".

> Note this is totally untested!

I'll give it a shot first thing in the A.M.

Note: I tested my stable of kernels today (22->), and we are better off
dd vs read today than ever in this time span at least.

(i can't recall ever seeing a system where beating snot outta root
didn't hurt really bad... would be very nice though;)

> diff --git a/block/elevator.c b/block/elevator.c
> index 1975b61..d00a72b 100644
> --- a/block/elevator.c
> +++ b/block/elevator.c
> @@ -497,9 +497,17 @@ int elv_merge(struct request_queue *q, struct request **req, struct bio *bio)
>  	 * See if our hash lookup can find a potential backmerge.
>  	 */
>  	__rq = elv_rqhash_find(q, bio->bi_sector);
> -	if (__rq && elv_rq_merge_ok(__rq, bio)) {
> -		*req = __rq;
> -		return ELEVATOR_BACK_MERGE;
> +	if (__rq) {
> +		/*
> +		 * If requests are queued behind this one, disallow merge. This
> +		 * prevents streaming IO from continually passing new IO.
> +		 */
> +		if (elv_latter_request(q, __rq))
> +			return ELEVATOR_NO_MERGE;
> +		if (elv_rq_merge_ok(__rq, bio)) {
> +			*req = __rq;
> +			return ELEVATOR_BACK_MERGE;
> +		}
>  	}
>  
>  	if (e->ops->elevator_merge_fn)
> 
