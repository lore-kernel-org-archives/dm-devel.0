From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/7] block: use legacy path for flush
 requests for MQ with a scheduler
Date: Tue, 6 Dec 2016 14:50:57 -0500
Message-ID: <20161206195057.GB27003@redhat.com>
References: <1480734921-23701-1-git-send-email-axboe@fb.com>
	<1480734921-23701-2-git-send-email-axboe@fb.com>
	<20161205130517.GA7100@infradead.org>
	<4008ea37-3c08-a7ba-770d-00bbf69617e5@fb.com>
	<CAMM=eLct4w0R97RQcQRekpUVdWM_BM+192sFKr7CfrHtF9bjyg@mail.gmail.com>
	<56b3ae91-fbf7-8381-f732-a99c51fa47b7@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <56b3ae91-fbf7-8381-f732-a99c51fa47b7@fb.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, device-mapper development <dm-devel@redhat.com>, paolo.valente@linaro.org, linux-block@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Dec 05 2016 at  5:50pm -0500,
Jens Axboe <axboe@fb.com> wrote:

> On 12/05/2016 03:40 PM, Mike Snitzer wrote:
> > On Mon, Dec 5, 2016 at 10:07 AM, Jens Axboe <axboe@fb.com> wrote:
> >>
> >> On 12/05/2016 06:05 AM, Christoph Hellwig wrote:
> >>> On Fri, Dec 02, 2016 at 08:15:15PM -0700, Jens Axboe wrote:
> >>>> No functional changes with this patch, it's just in preparation for
> >>>> supporting legacy schedulers on blk-mq.
> >>>
> >>> Ewww.  I think without refactoring to clear what 'use_mq_path'
> >>> means here and better naming this is a total non-started.  Even with
> >>> that we'll now have yet another code path to worry about.  Is there
> >>> any chance to instead consolidate into a single path?
> >>
> >> It's not pretty at all. I should have prefaced this patchset with saying
> >> that it's an experiment in seeing what it would take to simply use the
> >> old IO schedulers, as a temporary measure, on blk/scsi-mq. I did clean
> >> it up a bit after posting:
> >>
> >> http://git.kernel.dk/cgit/linux-block/log/?h=blk-mq-legacy-sched
> >>
> >> but I'm not going to claim this is anywhere near merge read, nor clean.
> > 
> > Nice to see you've lowered your standards...
> > 
> > Maybe now we can revisit this line of work? ;)
> > http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=wip
> 
> I haven't lowered my standards. I thought this posting was pretty clear
> - it's an experiment in what supporting legacy schedulers would look
> like. As you quote me above, this is NOT proposed for merging, nor do I
> consider it anywhere near clean.

Where'd your sense of humor go?

> > I'm not seeing anything in elevator_switch() that would prevent an
> > elevator from attempting to be used on an mq device with > 1 hw queue.
> > But I could easily be missing it.
> 
> You missed it, it's in blk_mq_sched_init(), called from
> elv_iosched_store() when trying to switch (or setup a new) schedulers.
> 
> > That aside, this patchset has all the makings of a _serious_ problem
> > for dm-mq multipath (e.g. if dm_mod.use_blk_mq=Y and
> > dm_mod.dm_mq_nr_hw_queues=1).  There is a bunch of code in
> > drivers/dm/dm-rq.c that looks at q->mq_ops vs not to determine if mq
> > is used vs old .request_fn.
> > 
> > I think we really need a way to force an allocated mq request_queue
> > (with a single hw_queue) to not support this technological terror
> > you've constructed. (*cough*
> 
> See BLK_MQ_F_NO_SCHED.

Yeap, missed it, thanks.  Reviewing patches via gmail _sucks_ I
should've just looked at your git branch(es) from the start.
 
> > I could be super dense on this line of work.  But what is the point of
> > all this?  Seems like a really unfortunate distraction that makes the
> > block code all the more encumbered with fiddley old vs new logic.  So
> > now we're opening old .request_fn users up to blk-mq-with-scheduler vs
> > non-blk-mq bugs.
> 
> See above, it's just an experiment in seeing what this would look like,
> how transparent (or not) we could make that.

OK, seems not very transparent so far.  But that aside, I'm more curious
on what the goal(s) and/or benefit(s) might be?  I know that before you
were hopeful to eventually eliminate the old .request_fn path in block
core (in favor of blk-mq, once it grew IO scheduling capabilties).

But by tieing blk-mq through to the old request path (and associated IO
schedulers) it certainly complicates getting rid of all the legacy code.

Selfishly, I'm looking forward to eliminating the old .request_fn
request-based code in DM core.  This advance to supporting the old IO
schedulers make that less likely.

> Don't overthink any of this, and don't start making plans or coming up
> with problems on why X or Y would not work with whatever interface
> variant of dm. That's jumping the gun.

Not overthinking.. just thinking ;)  But if this does happen then maybe
I should look to invert the request-based DM core cleanup: remove all
the old .request_fn support and impose the same (namely IO scheduler
enabled DM multipath) via dm_mod.use_blk_mq=Y and
dm_mod.dm_mod.dm_mq_nr_hw_queues=1

Mike
