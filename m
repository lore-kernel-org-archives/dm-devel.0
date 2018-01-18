From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [for-4.16 PATCH v6 0/3] blk-mq: improve DM's blk-mq IO merging
 via blk_insert_cloned_request feedback
Date: Wed, 17 Jan 2018 19:54:52 -0500
Message-ID: <20180118005452.GB7649@redhat.com>
References: <20180117162558.28553-1-snitzer@redhat.com>
 <45f70a28-aeea-8278-0b8e-9601ea043595@kernel.dk>
 <20180117165832.GA5573@redhat.com>
 <1516231868.2820.84.camel@wdc.com>
 <1516232589.3805.2.camel@redhat.com>
 <1516233206.2820.103.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1516233206.2820.103.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "loberman@redhat.com" <loberman@redhat.com>, "hch@lst.de" <hch@lst.de>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "tom.leiming@gmail.com" <tom.leiming@gmail.com>
List-Id: dm-devel.ids

On Wed, Jan 17 2018 at  6:53pm -0500,
Bart Van Assche <Bart.VanAssche@wdc.com> wrote:

> On Wed, 2018-01-17 at 18:43 -0500, Laurence Oberman wrote:
> > On Wed, 2018-01-17 at 23:31 +0000, Bart Van Assche wrote:
> > > On Wed, 2018-01-17 at 11:58 -0500, Mike Snitzer wrote:
> > > > On Wed, Jan 17 2018 at 11:50am -0500,
> > > > Jens Axboe <axboe@kernel.dk> wrote:
> > > > 
> > > > > On 1/17/18 9:25 AM, Mike Snitzer wrote:
> > > > > > Hi Jens,
> > > > > > 
> > > > > > Think this finally takes care of it! ;)
> > > > > > 
> > > > > > Thanks,
> > > > > > Mike
> > > > > > 
> > > > > > Mike Snitzer (2):
> > > > > >   blk-mq: factor out a few helpers from
> > > > > > __blk_mq_try_issue_directly
> > > > > >   blk-mq-sched: remove unused 'can_block' arg from
> > > > > > blk_mq_sched_insert_request
> > > > > > 
> > > > > > Ming Lei (1):
> > > > > >   blk-mq: improve DM's blk-mq IO merging via
> > > > > > blk_insert_cloned_request feedback
> > > > > 
> > > > > Applied - added actual commit message to patch 3.
> > > > 
> > > > Great, thanks.
> > > 
> > > Hello Mike,
> > > 
> > > Laurence hit the following while retesting the SRP initiator code:
> > > 
> > > [ 2223.797129] list_add corruption. prev->next should be next
> > > (00000000e0ddd5dd), but was 000000003defe5cd.
> > > (prev=000000003defe5cd).
> > > [ 2223.862168] WARNING: CPU: 14 PID: 577 at lib/list_debug.c:28
> > > __list_add_valid+0x6a/0x70
> > > [ 2224.481151] CPU: 14 PID: 577 Comm: kworker/14:1H Tainted:
> > > G          I      4.15.0-rc8.bart3+ #1
> > > [ 2224.531193] Hardware name: HP ProLiant DL380 G7, BIOS P67
> > > 08/16/2015
> > > [ 2224.567150] Workqueue: kblockd blk_mq_run_work_fn
> > > [ 2224.593182] RIP: 0010:__list_add_valid+0x6a/0x70
> > > [ 2224.967002] Call Trace:
> > > [ 2224.980941]  blk_mq_request_bypass_insert+0x57/0xa0
> > > [ 2225.009044]  __blk_mq_try_issue_directly+0x56/0x1e0
> > > [ 2225.037007]  blk_mq_request_direct_issue+0x5d/0xc0
> > > [ 2225.090608]  map_request+0x142/0x260 [dm_mod]
> > > [ 2225.114756]  dm_mq_queue_rq+0xa4/0x120 [dm_mod]
> > > [ 2225.140812]  blk_mq_dispatch_rq_list+0x90/0x5b0
> > > [ 2225.211769]  blk_mq_sched_dispatch_requests+0x107/0x1a0
> > > [ 2225.240825]  __blk_mq_run_hw_queue+0x5f/0xf0
> > > [ 2225.264852]  process_one_work+0x141/0x340
> > > [ 2225.287872]  worker_thread+0x47/0x3e0
> > > [ 2225.308354]  kthread+0xf5/0x130
> > > [ 2225.396405]  ret_from_fork+0x32/0x40
> > > 
> > > That call trace did not show up before this patch series was added to
> > > Jens'
> > > tree. This is a regression. Could this have been introduced by this
> > > patch
> > > series?
> > > 
> > > Thanks,
> > > 
> > > Bart.
> > 
> > Hi Bart
> > One thing to note.
> > 
> > I tested Mike's combined tree on the weekend fully dm4.16-block4.16 and
> > did not see this.
> > This was with Mike combined tree and SRPT running 4.13-rc2.
> > 
> > I also tested your tree Monday with the revert of the scatter/gather
> > patches with both SRP and SRPT running your tree and it was fine.
> > 
> > So its a combination of what you provided me before and that has been
> > added to your tree.
> > 
> > Mike combined tree seemed to be fine, I can revisit that if needed. I
> > still have that kernel in place.
> > 
> > I was not running latest SRPT when I tested Mike's tree
> 
> Hello Laurence,
> 
> The tree I sent you this morning did not only include Mike's latest dm code
> but also Jens' latest for-next branch. So what you wrote above does not
> contradict what I wrote in my e-mail, namely that I suspect that a regression
> was introduced by the patches in the series "blk-mq: improve DM's blk-mq IO
> merging via blk_insert_cloned_request feedback". These changes namely went in
> through the block tree and not through the dm tree. Additionally, these
> changes were not present in the block-scsi-for-next branch I sent you on
> Monday.

Functionality shouldn't be any different than the variant (Ming's v4)
that Laurence tested on Sunday/Monday (once we got past the genirq issue
on HPSA).

But sure, I suppose there is something I missed when refactoring Ming's
change to get it acceptable for upstream.  I went over the mechanical
nature of what I did many times (comaping Ming's v4 to my v5).

Anyway, we'll see how Laurence fairs with this tree (but with the revert
of 84676c1 added, so his HPSA server will boot):
https://git.kernel.org/pub/scm/linux/kernel/git/snitzer/linux.git/log/?h=block-4.16_dm-4.16
(which is the same as linux-dm.git's 'for-next' at the moment)

The call to blk_mq_request_bypass_insert will only occur via
__blk_mq_fallback_to_insert.  Which as the name implies this is not the
fast path.  This will occur if the underlying blk-mq device cannot get
resources it needs in order to issue the request.  Specifically: if/when
in __blk_mq_try_issue_directly() the hctx is stopped, or queue is
quiesced, or it cannot get the driver tag or dispatch_budget (in the
case of scsi-mq).

The same fallback, via call to blk_mq_request_bypass_insert, occured
with Ming's v4 though.

Anyway, we'll see what Laurence finds when testing my above kernel.

Mike
