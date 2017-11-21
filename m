From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 00/13] block: assorted cleanup for bio      splitting and
 cloning.
Date: Mon, 20 Nov 2017 20:35:33 -0500
Message-ID: <20171121013533.GA14520@redhat.com>
References: <149776047907.23258.8058071140236879834.stgit@noble>
 <20170618184143.GA10920@kernel.dk>
 <87poe13rmm.fsf@notabene.neil.brown.name>
 <CAMM=eLf9Vu-z1ZEsGtRoSkhpaaQXAdr8TsUYUCSmAjqrqo=W-w@mail.gmail.com>
 <87a7zg31vx.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87a7zg31vx.fsf@notabene.neil.brown.name>
Sender: linux-block-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Mon, Nov 20 2017 at  7:34pm -0500,
NeilBrown <neilb@suse.com> wrote:

> On Mon, Nov 20 2017, Mike Snitzer wrote:
> 
> > On Sun, Jun 18, 2017 at 5:36 PM, NeilBrown <neilb@suse.com> wrote:
> >> On Sun, Jun 18 2017, Jens Axboe wrote:
> >>
> >>> On Sun, Jun 18 2017, NeilBrown wrote:
> >>>> This is a resend of my series of patches working
> >>>> towards removing the bioset work queues.
> >>>>
> >>>> This set is based on for-4.13/block.
> >>>>
> >>>> It incorporates the revised versions of all the patches that were
> >>>> resent following feedback on the last set.
> >>>>
> >>>> It also includes a minor grammatic improvement to a comment, and
> >>>> simple changes to compensate for a couple of changes to the block tree
> >>>> since the last posting.
> >>>>
> >>>> I hope to eventually get rid of the new BIOSET_NEED_RESCUER flag,
> >>>> but that needs work in dm and probably bcache first.
> >>>
> >>> Thanks Neil, applied.
> >>
> >> Thanks a lot Jens.
> >
> > I missed this line of work until now.  Not quite sure why I wasn't
> > cc'd or my review/ack required for the DM changes in this patchset.
> 
> Hi Mike,
>  I'm sorry you weren't included on those.  My thinking at the time was
>  probably that they were purely cosmetic changes which made no
>  functional difference to dm.  That is no excuse though and I do
>  apologize.
> 
> >
> > But I've now queued this patch for once Linus gets back (reverts DM
> > changes from commit 47e0fb461f):
> > https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=c9fdc42ba23eabd1ba7aef199fb9bb4b4fe5c545
> 
> This patch does two things.
> 1/ It removes the BIOSET_NEED_RESCUER flag from biosets created by dm.
>   This a functional changed over the code from before my patches.
>   Previously, all biosets were given a rescuer thread.
>   After my patch set, biosets only got a rescuer thread if
>   BIOSET_NEED_RESCUER was passed, and it was passed for all biosets.
>   I then removed it from places were I was certain it wasn't needed.
>   I didn't remove it from dm because I wasn't certain.  Your
>   patch does remove the flags, which I think is incorrect - see below.
> 
> 2/ It changes flush_current_bio_list() so that bios allocated from a
>    bioset that does not have a rescue_workqueue are now added to
>    the ->rescue_list for their bio_set, and ->rescue_work is queued
>    on the NULL ->rescue_workqueue, resulting in a NULL dereference.
>    I suspect you don't want this.
> 
> The patch description claims that the patch fixes something, but it
> isn't clear to me what it is meant to be fixing.
> 
> It makes reference to  dbba42d8 which is described as removing an unused
> bioset process, though what it actually does is remove an used bioset
> (and obvious the process disappears with it).  My patch doesn't change
> that behavior.

Well I looked at this because Zdenek reported that with more recent
kernels he is seeing the "bioset" per DM device again (whereas it was
thought to be removed with mikulas' commit dbba42d8 -- but that commit
removed "bioset" only in terms of q->bio_split.

Looks like the q->bio_split bioset is created with BIOSET_NEED_RESCUER
but DM calls bioset_free() for q->bio_split.  Strikes me as odd that
"bioset" was removed DM devices until it recently reappeared.
Especially if what you say is accurate (that BIOSET_NEED_RESCUER was
implied with the old code.. I believe you!)

I tried to quickly answer how "bioset" is now re-appearing for DM
devices but I obviously need to put more time to it.

(And my goodness does this bioset rescue workqueue need a better name
than "bioset"! Should include the bdevname too)

> > As is, it is my understanding that DM has no need for a bio_set's
> > rescue_workqueue.  So its removal would appear to only be gated by
> > bcache?
> >
> > But I could be mistaken, moving forward please let me know what you
> > feel needs doing in DM to make it a better citizen.
> 
> I think you are mistaken.
> Please see
>    https://www.redhat.com/archives/dm-devel/2017-August/msg00310.html
> and
>    https://www.redhat.com/archives/dm-devel/2017-August/msg00315.html
> for which the thread continues:
>    https://www.redhat.com/archives/dm-devel/2017-September/msg00001.html
> 
> These were sent to you, though most of the conversation happened with
> Mikulas.
> 
> I think that the patches in those threads explain why dm currently needs
> rescuer threads, and shows how dm can be changed to no longer need the
> rescuer.  I would appreciate your thoughts on these patches.  I can
> resend them if that would help.

No need to resend.  I'll work through the old threads.

> That would then just leave bcache....  I find it a bit of a challenge to
> reason about the code in bcache, but if we can remove
> BIOSET_NEED_RESCUER from dm, that will be an extra incentive for me to learn :-)

I'm all for properly removing BIOSET_NEED_RESCUER from DM.

I'll look closer at all of this in the morning (for now I'm backing the
patch I referenced out from linux-next)

Mike
