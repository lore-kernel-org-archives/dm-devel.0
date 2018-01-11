From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH V3 0/5]  dm-rq: improve sequential I/O performance
Date: Thu, 11 Jan 2018 17:07:42 -0500
Message-ID: <20180111220742.GA31944@redhat.com>
References: <20180111060159.12991-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180111060159.12991-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>, axboe@kernel.dk
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

On Thu, Jan 11 2018 at  1:01am -0500,
Ming Lei <ming.lei@redhat.com> wrote:

> Hi Guys,
> 
> The 1st patch removes the workaround of blk_mq_delay_run_hw_queue() in
> case of requeue, this way isn't necessary, and more worse, it makes
> BLK_MQ_S_SCHED_RESTART not working, and degarde I/O performance.
> 
> The 2nd patch return DM_MAPIO_REQUEUE to dm-rq if underlying request
> allocation fails, then we can return BLK_STS_RESOURCE from dm-rq to
> blk-mq, so that blk-mq can hold the requests to be dequeued.

In general the delayed requeue was meant to cope (slightly better) with
queue_if_no_path and no paths being available.  I think patch 1 respect
that intent.  And patch 2 looks right to me, BLK_STS_RESOURCE definitely
should be returned if blk_get_request() fails.

So I picked these up for dm-4.16 (and staged them in linux-next).  I
reworded both headers and the 2nd patch's block comment, see:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.16&id=64e4e12bf474cf3aaaf59245bbeba3057d2fedf9
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.16&id=c50de17c1cc7d5910df58aba9b950e99579e239d

Bart, if for some reason we regress for some workload you're able to
more readily test we can deal with it.  But I'm too encouraged by Ming's
performance improvements to hold these changes back any further.

> The other 3 paches changes the blk-mq part of blk_insert_cloned_request(),
> in which we switch to blk_mq_try_issue_directly(), so that both dm-rq
> and blk-mq can get the dispatch result of underlying queue, and with
> this information, blk-mq can handle IO merge much better, then
> sequential I/O performance is improved much.
> 
> In my dm-mpath over virtio-scsi test, this whole patchset improves
> sequential IO by 3X ~ 5X.

I've merged dm-4.16 and for-4.16/block and patched 3 - 5 apply cleanly
(so we won't have any merge conflicts during 4.16), resulting git branch
is here:
https://git.kernel.org/pub/scm/linux/kernel/git/snitzer/linux.git/log/?h=block-4.16_dm-4.16

I'll reply to patches 3 - 5 individually with my Reviewed-by.
Jens, please feel free to pick them up for 4.16.

Thanks,
Mike
