From: Jens Axboe <axboe@kernel.dk>
Subject: Re: kernel oops with blk-mq-sched latest
Date: Wed, 18 Jan 2017 06:40:06 -0800
Message-ID: <89485b8b-b0f9-3a6c-7ccb-deb161efb7fc@kernel.dk>
References: <b6ce1c64-3577-8f86-b6a4-44a3a4ad2cbc@suse.de>
 <55b21574-baf3-25d9-a920-299fa2d04d72@kernel.dk>
 <10ffc7ea-564f-8eb0-ee00-5c1277c7efc3@kernel.dk>
 <a27c56a6-fbe8-90a6-ebbe-dcfbce67c4ba@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <a27c56a6-fbe8-90a6-ebbe-dcfbce67c4ba@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 01/18/2017 03:48 AM, Hannes Reinecke wrote:
> Nearly there.
> You're missing a 'blk_mq_start_hw_queues(q)' after
> blk_mq_unfreeze_queue(); without it the queue will stall after switching
> the scheduler.

Yes indeed, forgot that. Needed after the quiesce.

> Also what's quite suspicious is this:
> 
> struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
> 				    struct request_queue *q)
> {
> 	struct blkcg_gq *blkg;
> 
> 	WARN_ON_ONCE(!rcu_read_lock_held());
> 	lockdep_assert_held(q->queue_lock);
> 
> 	/*
> 	 * This could be the first entry point of blkcg implementation and
> 	 * we shouldn't allow anything to go through for a bypassing queue.
> 	 */
> 	if (unlikely(blk_queue_bypass(q)))
> 		return ERR_PTR(blk_queue_dying(q) ? -ENODEV : -EBUSY);
> 
> which now won't work as the respective flags aren't set anymore.
> Not sure if that's a problem, though.
> But you might want to look at that, too.

dying is still used on blk-mq, but yes, the bypass check should now be
frozen for blk-mq. Not really directly related to the above change,
but it should be fixed up.

> Nevertheless, with the mentioned modifications to your patch the crashes
> don't occur anymore.

Great

> Sad news is that it doesn't help _that_ much on spinning rust mpt3sas;
> there I still see a ~50% performance penalty on reads.
> Write's slightly better than sq performance, though.

What is the test case? Full details please, from hardware to what you
are running. As I've mentioned before, I don't necessarily think your
performance issues are related to scheduling. Would be nice to get
to the bottom of it, though. And for that, I need more details.

-- 
Jens Axboe

