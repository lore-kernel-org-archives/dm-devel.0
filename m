From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 4/5] blk-mq: introduce blk_get_request_notify
Date: Tue, 23 Jan 2018 09:29:11 +0800
Message-ID: <20180123012910.GC4411@ming.t460p>
References: <20180122033550.27855-1-ming.lei@redhat.com>
 <20180122033550.27855-5-ming.lei@redhat.com>
 <1516641182.2545.26.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1516641182.2545.26.camel@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "loberman@redhat.com" <loberman@redhat.com>
List-Id: dm-devel.ids

On Mon, Jan 22, 2018 at 05:13:03PM +0000, Bart Van Assche wrote:
> On Mon, 2018-01-22 at 11:35 +0800, Ming Lei wrote:
> > DM-MPATH need to allocate request from underlying queue, but when the
> > allocation fails, there is no way to make underlying queue's RESTART
> > to restart DM's queue.
> > 
> > This patch introduces blk_get_request_notify() for this purpose, and
> > caller need to pass 'wait_queue_entry_t' to this function, and make
> > sure it is initialized well, so after the current allocation fails,
> > DM will get notified when there is request available from underlying
> > queue.
> 
> Please mention that this is only a partial solution because the case when
> e.g. blk_insert_cloned_request() returns BLK_STS_RESOURCE is not handled.

I don't think it is necessary to mention that in comment log, because
one patch won't deal with all things.

But definitely there will be one patch which deals with that in V2,
otherwise the performance issue can't be solved completely.

> This could help for drivers that support a very low queue depth (lpfc) but
> probably won't be that useful for other drivers.

Up to now, it is one dm-mpath specific performance issue under one
specific situation: IO is submitted to dm-mpath device and the
underlying queue at the same time, and the underlying queue depth is
very low, such as 1.

> 
> > +	/*
> > +	 * If caller requires notification when tag is available, add
> > +	 * wait entry of 'data->notifier' to the wait queue.
> > +	 */
> > +	if (data->flags & BLK_MQ_REQ_NOWAIT) {
> > +		bool added = false;
> > +
> > +		spin_lock_irq(&ws->wait.lock);
> > +		if (list_empty(&data->notifier->entry))
> > +			__add_wait_queue(&ws->wait, data->notifier);
> > +		else
> > +			added = true;
> > +		spin_unlock_irq(&ws->wait.lock);
> > +
> > +		if (added)
> > +			return BLK_MQ_TAG_FAIL;
> > +
> > +		tag = __blk_mq_get_tag(data, bt);
> > +		if (tag != -1)
> > +			goto found_tag;
> > +		return BLK_MQ_TAG_FAIL;
> > +	}
> 
> Sorry but I don't like this approach. Adding "data->notifier" to the wait
> queue creates a link between two request queues, e.g. a dm-mpath queue and
> one of the paths that is a member of that dm-mpath queue. This creates the
> potential for ugly races between e.g. "data->notifier" being triggered and
> removal of the dm-mpath queue.

I thought no such race because the dm request is still in dispatch list before
the 'notifier' is handled. And now looks this isn't true, but this issue can be
dealt easily by call blk_queue_enter_live() before the allocation, and
release them all once the notifier is triggered.

Anyway this interface need to be well documented.

> 
> > diff --git a/block/blk-mq.h b/block/blk-mq.h
> > index 88c558f71819..bec2f675f8f1 100644
> > --- a/block/blk-mq.h
> > +++ b/block/blk-mq.h
> > @@ -160,6 +160,7 @@ struct blk_mq_alloc_data {
> >  	struct request_queue *q;
> >  	blk_mq_req_flags_t flags;
> >  	unsigned int shallow_depth;
> > +	wait_queue_entry_t *notifier;
> 
> If others would agree with the approach of this patch please use another name
> than "notifier". In the context of the Linux kernel a notifier is an instance
> of struct notifier_block. The above "notifier" member is not a notifier but a
> wait queue entry.

OK, I will change to 'wait', similar with 'dispatch_wait'.

-- 
Ming
