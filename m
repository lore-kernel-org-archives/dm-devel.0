From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/7] block: use legacy path for flush requests for MQ with
 a scheduler
Date: Mon, 5 Dec 2016 17:40:43 -0500
Message-ID: <CAMM=eLct4w0R97RQcQRekpUVdWM_BM+192sFKr7CfrHtF9bjyg@mail.gmail.com>
References: <1480734921-23701-1-git-send-email-axboe@fb.com>
 <1480734921-23701-2-git-send-email-axboe@fb.com> <20161205130517.GA7100@infradead.org>
 <4008ea37-3c08-a7ba-770d-00bbf69617e5@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <4008ea37-3c08-a7ba-770d-00bbf69617e5@fb.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, paolo.valente@linaro.org, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Dec 5, 2016 at 10:07 AM, Jens Axboe <axboe@fb.com> wrote:
>
> On 12/05/2016 06:05 AM, Christoph Hellwig wrote:
> > On Fri, Dec 02, 2016 at 08:15:15PM -0700, Jens Axboe wrote:
> >> No functional changes with this patch, it's just in preparation for
> >> supporting legacy schedulers on blk-mq.
> >
> > Ewww.  I think without refactoring to clear what 'use_mq_path'
> > means here and better naming this is a total non-started.  Even with
> > that we'll now have yet another code path to worry about.  Is there
> > any chance to instead consolidate into a single path?
>
> It's not pretty at all. I should have prefaced this patchset with saying
> that it's an experiment in seeing what it would take to simply use the
> old IO schedulers, as a temporary measure, on blk/scsi-mq. I did clean
> it up a bit after posting:
>
> http://git.kernel.dk/cgit/linux-block/log/?h=blk-mq-legacy-sched
>
> but I'm not going to claim this is anywhere near merge read, nor clean.

Nice to see you've lowered your standards...

Maybe now we can revisit this line of work? ;)
http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=wip

To fix: https://bugzilla.kernel.org/show_bug.cgi?id=119841

> >>  struct request *blk_get_request(struct request_queue *q, int rw, gfp_t gfp_mask)
> >>  {
> >> -    if (q->mq_ops)
> >> +    if (blk_use_mq_path(q))
> >>              return blk_mq_alloc_request(q, rw,
> >>                      (gfp_mask & __GFP_DIRECT_RECLAIM) ?
> >>                              0 : BLK_MQ_REQ_NOWAIT);
> >
> > So now with blk-mq and an elevator set we go into blk_old_get_request,
> > hich will simply allocate new requests.  How does this not break
> > every existing driver?
>
> Since Johannes found that confusion, maybe I should explain how it all
> works.
>
> Basically, if we are blk-mq (q->mq_ops) and now have an IO scheduler
> attached (q->elevator), then the path from bio to request is essentially
> the old one. We allocate a request through get_request() and friends,
> and insert it with the elevator interface. When the queue is later run,
> our blk_mq_sched_dispatch() asks the IO scheduler for a request, and if
> successful, we allocate a real MQ request and dispatch that. So all the
> driver ever sees is MQ requests, and it uses the MQ interface. Only the
> internal bits now look at blk_use_mq_path() to tell whether they should
> alloc+insert with that.
>
> The above will break if we have drivers manually allocating a request
> through blk_get_request(), and then using MQ functions to insert/run it.
> I didn't audit all of that, and I think most (all?) of them just use the
> MQ interfaces. That would also currently be broken, we either/or the
> logic to run software queues or run through the elevator.

I'm not seeing anything in elevator_switch() that would prevent an
elevator from attempting to be used on an mq device with > 1 hw queue.
But I could easily be missing it.

That aside, this patchset has all the makings of a _serious_ problem
for dm-mq multipath (e.g. if dm_mod.use_blk_mq=Y and
dm_mod.dm_mq_nr_hw_queues=1).  There is a bunch of code in
drivers/dm/dm-rq.c that looks at q->mq_ops vs not to determine if mq
is used vs old .request_fn.

I think we really need a way to force an allocated mq request_queue
(with a single hw_queue) to not support this technological terror
you've constructed. (*cough*
http://es.memegenerator.net/instance/58341711 )

In fact I'd prefer there be a mechanism to only allow this if some
opt-in interface is used... or the inverse: dm-mq can allocate a
blk-mq request_requeue that will _never_ support this.

I could be super dense on this line of work.  But what is the point of
all this?  Seems like a really unfortunate distraction that makes the
block code all the more encumbered with fiddley old vs new logic.  So
now we're opening old .request_fn users up to blk-mq-with-scheduler vs
non-blk-mq bugs.

Color me skeptical.  In time, maybe I'll warm to all this but for now
we need a big "OFF!" switch (aside from DEFAULT_MQ_SCHED_NONE, in
request_queue allocation interface).

FWIW, dm-multipath has supported a top-level .request_fn
requeue_queue, legacy elevator and all, stacked on blk-mq queue(s) for
quite a while.  If people _really_ want this you could easily give it
to them by forcing the use of the DM "multipath" target with
multipath's "queue_mode" feature set to "rq".
