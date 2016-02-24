From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: 4.4-final: 28 bioset threads on small notebook
Date: Tue, 23 Feb 2016 18:23:52 -0900
Message-ID: <20160224032352.GA22341@kmo-pixel>
References: <20160220200432.GB22120@amd>
 <20160220203856.GB27149@redhat.com>
 <20160220205519.GA14108@amd>
 <20160221041540.GA24735@kmo-pixel>
 <3A47B4705F6BE24CBB43C61AA73286211B3AA6A9@SSIEXCH-MB3.ssi.samsung.com>
 <CACVXFVPav3D2MzNFR-b4YadFMM6_KcyEYQ7dx4t1r9fMOLDaFw@mail.gmail.com>
 <20160222225818.GA2675@kmo-pixel>
 <CACVXFVNMMhR-uOSYvV+VLrSFtmQZUmoQBSAwKFcXcSvB_HUO-A@mail.gmail.com>
 <20160223145442.GB8047@redhat.com>
 <CACVXFVN+xV5_4zktCGpQUrnOtJ1EVOLPt5v4niuj9VUGL8uUEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACVXFVN+xV5_4zktCGpQUrnOtJ1EVOLPt5v4niuj9VUGL8uUEA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@canonical.com>
Cc: Mike Snitzer <snitzer@redhat.com>, "oleg.drokin@intel.com" <oleg.drokin@intel.com>, Ming Lin-SSI <ming.l@ssi.samsung.com>, "andreas.dilger@intel.com" <andreas.dilger@intel.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "minchan@kernel.org" <minchan@kernel.org>, "jkosina@suse.cz" <jkosina@suse.cz>, kernel list <linux-kernel@vger.kernel.org>, "jim@jtan.com" <jim@jtan.com>, "pjk1939@linux.vnet.ibm.com" <pjk1939@linux.vnet.ibm.com>, "axboe@fb.com" <axboe@fb.com>, "geoff@infradead.org" <geoff@infradead.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "dpark@posteo.net" <dpark@posteo.net>, Pavel Machek <pavel@ucw.cz>, "ngupta@vflare.org" <ngupta@vflare.org>, "hch@lst.de" <hch@lst.de>, "agk@redhat.com" <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Feb 24, 2016 at 10:48:10AM +0800, Ming Lei wrote:
> On Tue, Feb 23, 2016 at 10:54 PM, Mike Snitzer <snitzer@redhat.com> wrote:
> > On Mon, Feb 22 2016 at  9:55pm -0500,
> > Ming Lei <ming.lei@canonical.com> wrote:
> >
> >> On Tue, Feb 23, 2016 at 6:58 AM, Kent Overstreet
> >> <kent.overstreet@gmail.com> wrote:
> >> > On Sun, Feb 21, 2016 at 05:40:59PM +0800, Ming Lei wrote:
> >> >> On Sun, Feb 21, 2016 at 2:43 PM, Ming Lin-SSI <ming.l@ssi.samsung.com> wrote:
> >> >> >>-----Original Message-----
> >> >> >
> >> >> > So it's almost already "per request_queue"
> >> >>
> >> >> Yes, that is because of the following line:
> >> >>
> >> >> q->bio_split = bioset_create(BIO_POOL_SIZE, 0);
> >> >>
> >> >> in blk_alloc_queue_node().
> >> >>
> >> >> Looks like this bio_set doesn't need to be per-request_queue, and
> >> >> now it is only used for fast-cloning bio for splitting, and one global
> >> >> split bio_set should be enough.
> >> >
> >> > It does have to be per request queue for stacking block devices (which includes
> >> > loopback).
> >>
> >> In commit df2cb6daa4(block: Avoid deadlocks with bio allocation by
> >> stacking drivers), deadlock in this situation has been avoided already.
> >> Or are there other issues with global bio_set? I appreciate if you may
> >> explain it a bit if there are.
> >
> > Even with commit df2cb6daa4 there is still risk of deadlocks (even
> > without low memory condition), see:
> > https://patchwork.kernel.org/patch/7398411/
> 
> That is definitely another problem which isn't related with low memory,
> and I guess Kent means there might be deadlock risk in case of shared
> bio_set.
> 
> >
> > (you may recall you blocked this patch with concerns about performance,
> > context switches, plug merging being compromised, etc.. to which I never
> > circled back to verify your concerns)
> 
> I still remember that problem:
> 
> 1) Process A
>      - two bio(a, b) are splitted in dm's make_request funtion
>      - bio(a) is submitted via generic_make_request(), so it is staged
>        in current->bio_list
>      - time t1
>      - before bio(b) is submitted, down_write(&s->lock) is run and
>       never return
> 
> 2) Process B:
>      - just during time t1, wait completion of bio(a) by down_write(&s->lock)
> 
> Then Process A waits the lock which is acquired by B first, and the
> two bio(a, b)
> can't reach to driver/device at all.
> 
> Looks that current->bio_list is fragile to locks from make_request function,
> and moving the lock into workqueue context should be helpful.
> 
> And I am happy to continue to discuss this issue further.
> 
> >
> > But it illustrates the type of problems that can occur when your rescue
> > infrastructure is shared across devices (in the context of df2cb6daa4,
> > current->bio_list contains bios from multiple devices).
> >
> > If a single splitting bio_set were shared across devices there would be
> > no guarantee of forward progress with complex stacked devices (one or
> > more devices could exhaust the reserve and starve out other devices in
> > the stack).  So keeping the bio_set per request_queue isn't prone to
> > failure like a shared bio_set might be.
> 
> Not consider the dm lock problem, from Kent's commit(df2cb6daa4) log and
> the patch, looks forward progress can be guaranteed for stacked devices
> with same bio_set, but better to get Kent's clarification.
> 
> If forward progress can be guaranteed, percpu mempool might avoid
> easy exhausting, because it is reasonable to assume that one CPU can only
> provide a certain amount of bandwidth wrt. block transfer.

Generally speaking, with potential deadlocks like this I don't bother to work
out the specific scenario, it's enough to know that there's a shared resource
and multiple users that depend on each other... if you've got that, you'll have
a deadlock.

But, if you're curious: say we've got block devices a and b, when you submit to
a the bio will get passed down to b:

for the bioset itself: if a bio gets split when submitted to a, then needs to be
split again when it's submitted to b - you're allocating twice from the same
mempool, and the first allocation can't be freed until the original bio
completes. deadlock.

with the rescuer threads it's more subtle, but you just need a scenario where
the rescuer is required twice in a row. I'm not going to bother trying to work
out the details, but it's the same principle - you can end up in a situation
where you're blocked, and you need the rescuer thread to make forward progress
(or you'd deadlock - that's why it exists, right?) - well, what happens if that
happens twice in a row, and the second time you're running out of the rescuer
thread? oops.
