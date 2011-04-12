From: "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
Date: Tue, 12 Apr 2011 12:44:17 -0400
Message-ID: <20110412164417.GA13890@infradead.org>
References: <20110411220505.1028816e@notabene.brown>
 <4DA2F00E.6010907@fusionio.com>
 <20110411223623.4278fad1@notabene.brown>
 <4DA2F8AD.1060605@fusionio.com>
 <20110412011255.GA29236@infradead.org>
 <4DA40F0E.1070903@fusionio.com>
 <20110412122248.GC31057@dastard>
 <4DA4456F.3070301@fusionio.com>
 <20110412124134.GD31057@dastard>
 <4DA44C86.3090305@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4DA44C86.3090305@fusionio.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Dave Chinner <david@fromorbit.com>, "hch@infradead.org" <hch@infradead.org>, NeilBrown <neilb@suse.de>, Mike Snitzer <snitzer@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

On Tue, Apr 12, 2011 at 02:58:46PM +0200, Jens Axboe wrote:
> Supposedly it's faster to do it inline rather than punt the dispatch.
> But that may actually not be true, if you have multiple plugs going (and
> thus multiple contenders for the queue lock on dispatch). So lets play
> it safe and punt to kblockd, we can always revisit this later.

Note that this can be optimized further by adding a new helper that just
queues up work on kblockd without taking the queue lock, e.g. adding a
new

void blk_run_queue_async(struct request_queue *q)
{
	if (likely(!blk_queue_stopped(q)))
		queue_delayed_work(kblockd_workqueue, &q->delay_work, 0);
}

And replacing all

	__blk_run_queue(q, true);

callers with that, at which point they won't need the queuelock any
more.
