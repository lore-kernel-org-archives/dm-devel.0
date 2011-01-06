From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH v3 0/8] dm-raid (raid456) target
Date: Thu, 6 Jan 2011 21:46:45 +1100
Message-ID: <20110106214645.2bd321f4@notabene.brown>
References: <1292899065-31943-1-git-send-email-snitzer@redhat.com>
	<20101221141443.5aea0b12@notabene.brown>
	<20110105223628.GA13164@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110105223628.GA13164@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: jbrassow@redhat.com, agk@redhat.com, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

On Wed, 5 Jan 2011 17:36:29 -0500 Mike Snitzer <snitzer@redhat.com> wrote:

> On Mon, Dec 20 2010 at 10:14pm -0500,
> Neil Brown <neilb@suse.de> wrote:
> 
> > On Mon, 20 Dec 2010 21:37:37 -0500 Mike Snitzer <snitzer@redhat.com> wrote:
> > 
> > > I reviewed all patches and adjusted patch headers in preparation for
> > > inclusion in Alasdair's tree (upstream target being v2.6.38).  The 2
> > > md/bitmap changes can obviously go through Neil's MD tree if that is
> > > preferred.
> > > 
> > > - added Copyright to the top of dm-raid.c
> > > - fixed drivers/md/Kconfig so that DM_RAID will select MD_RAID456
> > > - removed unused 'conf' variable in raid_status()
> > > - few misc style and whitespace changes
> > > 
> > > Neil,
> > > Hopefully you're comfortable with the authorship of most of these
> > > patches still being attributed to you (despite Jon's changes to your
> > > original patches).
> > > 
> > > Please advise, thanks!
> > 
> > I haven't had a chance to have a proper look yet, and I'm about to go on
> > leave for a couple of weeks.
> > I'm probably happy with the authorship remaining as-is, but I reserve the
> > right to change my mind (about anything) once I've had a chance to have a
> > proper look.
> 
> Hi Neil,
> 
> Please advise on how you'd like things to proceed with this initial 8
> patch set.  Ideally we'd get them in to linux-next now and ultimately
> 2.6.38 before the merge window closes.
> 
> Thanks,
> Mike

Sorry for long delays ... leave is always followed by piles of things that
all need to be done at once :-(

Patches 1 and 2 aren't really needed - I feel inclined not to remove that
stuff until all the dust settles..  So I'll put them at the bottom of my
queue and bring them forward in a couple of releases if that seems
appropriate.

Patch 3 I'll push out through my tree shortly.

The rest I am happy with going out through 'dm' to -next and beyond whenever
you like.

However I will take this opportunity to suggest that the raid parameters
might need a bit of review before they are finalised.

The possible parameters are as follows:
 <chunk_size>		Chunk size in sectors.
 [[no]sync]		Force/Prevent RAID initialization
 [rebuild <idx>]	Rebuild the drive indicated by the index
 [daemon_sleep <ms>]	Time between bitmap daemon work to clear bits
 [min_recovery_rate <kB/sec/disk>]	Throttle RAID initialization
 [max_recovery_rate <kB/sec/disk>]	Throttle RAID initialization
 [max_write_behind <value>]		See '-write-behind=' (man mdadm)
 [stripe_cache <sectors>]		Stripe cache size for higher RAIDs


'rebuild idx' only allows one device to be rebuilt at a time.  With RAID6 it
is possible that two devices can be ready for rebuild, in which case we would
want to rebuild both of them.
Also if you stop an array during a rebuild you really want to start again
where you were up to.

Most general solution would be to combine the rebuild information with the
list of component devices - either a sector number or something to indicate
that the rebuild it complete (which could be just a v.big sector number).

I'd much prefer 'daemon_sleep' to be in seconds, we decimals supported if
needed.

Also:

3:	<#raid_devs> <meta_dev1> <dev1> .. <meta_devN> <devN>

This doesn't allow offsets into the various devices like dm-stripe,
dm-linear, dm-raid1 all do.

So I suspect a bit of work is needed there.

NeilBrown
