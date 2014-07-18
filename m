From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-multipath: Accept failed paths for multipath maps
Date: Fri, 18 Jul 2014 12:04:49 -0400
Message-ID: <20140718160449.GA5598@redhat.com>
References: <1387353155-7271-1-git-send-email-hare@suse.de>
	<20131218140858.GC17730@redhat.com> <52B1B046.3040301@suse.de>
	<1387380498.7608.6.camel@ict-vth-stewarts01.ict.englab.netapp.com>
	<20140718000411.GB337@redhat.com>
	<20140718002319.GA20071@redhat.com> <53C8B810.2060206@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <53C8B810.2060206@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, Bryn Reeves <breeves@redhat.com>, "Stewart,
	Sean" <Sean.Stewart@netapp.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Jul 18 2014 at  2:00am -0400,
Hannes Reinecke <hare@suse.de> wrote:

> On 07/18/2014 02:23 AM, Mike Snitzer wrote:
> >On Thu, Jul 17 2014 at  8:04pm -0400,
> >Mike Snitzer <snitzer@redhat.com> wrote:
> >
> >>Revisiting this can of worms...
> >>
> >>As part of full due-diligence on the approach that SUSE and NetApp have
> >>seemingly enjoyed "for years" I reviewed Hannes' v3 patch, fixed one
> >>issue and did some cleanup.  I then converted over to using a slightly
> >>different approach where-in the DM core becomes a more willing
> >>co-conspirator in this hack by introducing the ability to have
> >>place-holder devices (dm_dev without an opened bdev) referenced in a DM
> >>table.  The work is here:
> >>http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=throwaway-dm-mpath-placeholder-devs
> >
> >Here is the rolled up patch (the individual commits in the above branch
> >are rather noisy given the sequencing):
> >
> >  drivers/md/dm-mpath.c | 51 +++++++++++++++++++++++++++++++++----------------
> >  drivers/md/dm-table.c | 53 ++++++++++++++++++++++++++++++++++++++-------------
> >  drivers/md/dm.c       |  5 ++---
> >  drivers/md/dm.h       | 12 ++++++++++++
> >  4 files changed, 89 insertions(+), 32 deletions(-)
> >
> These patches look quite okay; I'll be cross-checking with my
> version and do some testing there.

Thanks, the intent was to make your approach more "official".  I did
have a couple fixes to the DM core patch so I rebased, see:
https://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=throwaway-dm-mpath-placeholder-devs

But as I said in earlier posts, I'm really not in love with using
place-holder devices (mainly because allowing references to dead devices
_seems_ to go against proper device stacking).  But I do think that DM
core _should_ acknowledge that everything isn't always going to be
perfect for all targets.  Especially a target like multipath whose
purpose is to cope with the potential for paths coming/going.

So there definitely is a case to be made for DM being more tolerate of
the potential for devices being inaccessible.

Now this is the last I'm going to channel Alasdair's argument for him on
this thread but: Alasdair would prefer to see userspace multipathd fixed
(more intelligent batched processing of uevents, etc).  As a second 
option, his preferred kernel change is a "handover" style approach that
hands the path group state over from the old table to the new.

I agree that userspace multipathd should be fixed to process events in
batches but I see that even then the kernel should accommodate potential
for imperfect table loads for targets like multipath.  I happen to
disagree with handover (I flipped and now flopped back on this point).
Handover would be serious churn (that agk somehow thinks more
worthwhile).  While I appreciate that mechanically handover is a
different means to the same end of having references to dm_devs that are
"removed failed devices" handover would be overly complicated and
brittle (and very disruptive to DM core because the dm_devs aren't
hanging directly off of a multipath structure, they are associated with
the DM table!)

In that light I do actually prefer the blunt/simple approach taken in my
'throwaway-dm-mpath-placeholder-devs' branch.  But I'm concerned that
accepting a workaround like this will just enable multipathd to never
get the attention it needs for improved uevent processing.  If others
commit to actually making multipathd's uevent processing better that'd
go a long way.

> Will be sending some update once the testing is done.

OK.  The stronger case that can be made for the stability of this change
(no missing checks for dev->bdev, etc) the better.

I did just do some basic testing, of both dm-mpath and dm-thinp, seems
fine.  The DM core changes really are simple (just some extra negative
checks that won't ever apply for the normal case -- where "normal case"
is DM targets that use dm_get_device rather than __dm_get_device, and
had to add a dev_t to struct dm_dev).
