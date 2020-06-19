From: Ming Lei <ming.lei@redhat.com>
Subject: Re: dm-rq: don't call blk_mq_queue_stopped in dm_stop_queue()
Date: Fri, 19 Jun 2020 18:11:42 +0800
Message-ID: <20200619101142.GA339442@T590>
References: <20200619084214.337449-1-ming.lei@redhat.com>
 <20200619094250.GA18410@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200619094250.GA18410@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

Hi Mike,

On Fri, Jun 19, 2020 at 05:42:50AM -0400, Mike Snitzer wrote:
> Hi Ming,
> 
> Thanks for the patch!  But I'm having a hard time understanding what
> you've written in the patch header,
> 
> On Fri, Jun 19 2020 at  4:42am -0400,
> Ming Lei <ming.lei@redhat.com> wrote:
> 
> > dm-rq won't stop queue, meantime blk-mq won't stop one queue too, so
> > remove the check.
> 
> It'd be helpful if you could unpack this with more detail before going on
> to explain why using blk_queue_quiesced, despite dm-rq using
> blk_mq_queue_stopped, would also be ineffective.
> 
> SO:
> 
> > dm-rq won't stop queue
> 
> 1) why won't dm-rq stop the queue?  Do you mean it won't reliably
>    _always_ stop the queue because of the blk_mq_queue_stopped() check?

device mapper doesn't call blk_mq_stop_hw_queue or blk_mq_stop_hw_queues.

> 
> > meantime blk-mq won't stop one queue too, so remove the check.
> 
> 2) Meaning?: blk_mq_queue_stopped() will return true even if only one hw
> queue is stopped, given blk-mq must stop all hw queues a positive return
> from this blk_mq_queue_stopped() check is incorrectly assuming it meanss
> all hw queues are stopped.

blk-mq won't call blk_mq_stop_hw_queue or blk_mq_stop_hw_queues for
dm-rq's queue too, so dm-rq's hw queue won't be stopped.

BTW blk_mq_stop_hw_queue or blk_mq_stop_hw_queues are supposed to be
used for throttling queue.

> 
> > dm_stop_queue() actually tries to quiesce hw queues via blk_mq_quiesce_queue(),
> > we can't check via blk_queue_quiesced for avoiding unnecessary queue
> > quiesce because the flag is set before synchronize_rcu() and dm_stop_queue
> > may be called when synchronize_rcu from another blk_mq_quiesce_queue is
> > in-progress.
> 
> But I'm left with questions/confusion on this too:
> 
> 1) you mention blk_queue_quiesced instead of blk_mq_queue_stopped, so I
>    assume you mean that: not only is blk_mq_queue_stopped()
>    ineffective, blk_queue_quiesced() would be too?

blk_mq_queue_stopped isn't necessary because dm-rq's hw queue won't be
stopped by anyone, meantime replacing it with blk_queue_quiesced() is wrong.

> 
> 2) the race you detail (with competing blk_mq_quiesce_queue) relative to
>    synchronize_rcu() and testing "the flag" is very detailed yet vague.

If two code paths are calling dm_stop_queue() at the same time, one path may
return immediately and it is wrong, sine synchronize_rcu() from another path
may not be done.

> 
> Anyway, once we get this heaader cleaned up a bit more I'll be happy to
> get this staged as a stable@ fix for 5.8 inclusion ASAP.

This patch isn't a fix, and it shouldn't be related with rhel8's issue.

Thanks,
Ming

> 
> Thanks!
> Mike
> 
> > 
> > Cc: linux-block@vger.kernel.org
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >  drivers/md/dm-rq.c | 3 ---
> >  1 file changed, 3 deletions(-)
> > 
> > diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
> > index f60c02512121..ed4d5ea66ccc 100644
> > --- a/drivers/md/dm-rq.c
> > +++ b/drivers/md/dm-rq.c
> > @@ -70,9 +70,6 @@ void dm_start_queue(struct request_queue *q)
> >  
> >  void dm_stop_queue(struct request_queue *q)
> >  {
> > -	if (blk_mq_queue_stopped(q))
> > -		return;
> > -
> >  	blk_mq_quiesce_queue(q);
> >  }
> >  
> > -- 
> > 2.25.2
> > 

-- 
Ming
