From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 00/13] block: assorted cleanup for
 bio	splitting and cloning.
Date: Tue, 21 Nov 2017 07:10:50 -0500
Message-ID: <20171121121049.GA17014@redhat.com>
References: <149776047907.23258.8058071140236879834.stgit@noble>
	<20170618184143.GA10920@kernel.dk>
	<87poe13rmm.fsf@notabene.neil.brown.name>
	<CAMM=eLf9Vu-z1ZEsGtRoSkhpaaQXAdr8TsUYUCSmAjqrqo=W-w@mail.gmail.com>
	<87a7zg31vx.fsf@notabene.neil.brown.name>
	<20171121013533.GA14520@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20171121013533.GA14520@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: NeilBrown <neilb@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Mon, Nov 20 2017 at  8:35pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Mon, Nov 20 2017 at  7:34pm -0500,
> NeilBrown <neilb@suse.com> wrote:
> 
> > On Mon, Nov 20 2017, Mike Snitzer wrote:
> > 
> > >
> > > But I've now queued this patch for once Linus gets back (reverts DM
> > > changes from commit 47e0fb461f):
> > > https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=c9fdc42ba23eabd1ba7aef199fb9bb4b4fe5c545
> > 
> > This patch does two things.
> > 1/ It removes the BIOSET_NEED_RESCUER flag from biosets created by dm.
> >   This a functional changed over the code from before my patches.
> >   Previously, all biosets were given a rescuer thread.
> >   After my patch set, biosets only got a rescuer thread if
> >   BIOSET_NEED_RESCUER was passed, and it was passed for all biosets.
> >   I then removed it from places were I was certain it wasn't needed.
> >   I didn't remove it from dm because I wasn't certain.  Your
> >   patch does remove the flags, which I think is incorrect - see below.

Yeap, definitely was incorrect.  I've dropped the patch.

> > 2/ It changes flush_current_bio_list() so that bios allocated from a
> >    bioset that does not have a rescue_workqueue are now added to
> >    the ->rescue_list for their bio_set, and ->rescue_work is queued
> >    on the NULL ->rescue_workqueue, resulting in a NULL dereference.
> >    I suspect you don't want this.

Yes, I see that now.

> > The patch description claims that the patch fixes something, but it
> > isn't clear to me what it is meant to be fixing.
> > 
> > It makes reference to  dbba42d8 which is described as removing an unused
> > bioset process, though what it actually does is remove an used bioset
> > (and obvious the process disappears with it).  My patch doesn't change
> > that behavior.
> 
> Well I looked at this because Zdenek reported that with more recent
> kernels he is seeing the "bioset" per DM device again (whereas it was
> thought to be removed with mikulas' commit dbba42d8 -- but that commit
> removed "bioset" only in terms of q->bio_split.

I think Zdenek triggered a false-positive that DM had magically sprouted
a new "bioset" rescue_workqueue.  Reality is I cannot see how each
bio-based DM device can avoid having one.  And the commit d67a5f4b59
("dm: flush queued bios when process blocks to avoid deadlock") I
referenced earlier very much makes DM depend on it even more.

So apologies for being so off-base (by looking to prematurely revert
DM's use of BIOSET_NEED_RESCUER, etc).

> > Please see
> >    https://www.redhat.com/archives/dm-devel/2017-August/msg00310.html

I'll very likely pick these up for 4.16 shortly.  But hope to work
through complete removal of DM's use of BIOSET_NEED_RESCUER for 4.16 as
well.

> > and
> >    https://www.redhat.com/archives/dm-devel/2017-August/msg00315.html

This one [1] needs a lot of review and testing.  Particularly against this
test case that Mikulas created to reproduce the snapshot deadlock (same
deadlock that motivated commit dbba42d8):
https://www.redhat.com/archives/dm-devel/2017-January/msg00064.html

> > for which the thread continues:
> >    https://www.redhat.com/archives/dm-devel/2017-September/msg00001.html

Wish I could clone myself (or Kent, the world needs 2 Kents!) and pursue
this: https://www.redhat.com/archives/dm-devel/2014-May/msg00100.html

Short of that, how would you like to proceed?

> > That would then just leave bcache....  I find it a bit of a challenge to
> > reason about the code in bcache, but if we can remove
> > BIOSET_NEED_RESCUER from dm, that will be an extra incentive for me to learn :-)
> 
> I'm all for properly removing BIOSET_NEED_RESCUER from DM.

Should we work to make [1] (above) sure it fixes Mikulas' test case?

I'll set in on reviewing and playing with [1] now.

Thanks,
Mike
