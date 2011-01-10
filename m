From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH v3 0/8] dm-raid (raid456) target
Date: Mon, 10 Jan 2011 11:37:18 +1100
Message-ID: <20110110113718.1e042548@notabene.brown>
References: <1292899065-31943-1-git-send-email-snitzer@redhat.com>
	<20101221141443.5aea0b12@notabene.brown>
	<20110105223628.GA13164@redhat.com>
	<20110106214645.2bd321f4@notabene.brown>
	<D3D5994A-7CA9-43BE-8B81-A09139220A9E@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D3D5994A-7CA9-43BE-8B81-A09139220A9E@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, agk@redhat.com, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

On Thu, 6 Jan 2011 08:43:35 -0600 Jonathan Brassow <jbrassow@redhat.com>
wrote:

> 
> On Jan 6, 2011, at 4:46 AM, NeilBrown wrote:
> >
> > Patches 1 and 2 aren't really needed - I feel inclined not to remove  
> > that
> > stuff until all the dust settles..  So I'll put them at the bottom  
> > of my
> > queue and bring them forward in a couple of releases if that seems
> > appropriate.
> 
> No problem.
> 
> > Patch 3 I'll push out through my tree shortly.
> 
> thanks
> 
> > The rest I am happy with going out through 'dm' to -next and beyond  
> > whenever
> > you like.
> >
> > However I will take this opportunity to suggest that the raid  
> > parameters
> > might need a bit of review before they are finalised.
> >
> > The possible parameters are as follows:
> > <chunk_size>		Chunk size in sectors.
> > [[no]sync]		Force/Prevent RAID initialization
> > [rebuild <idx>]	Rebuild the drive indicated by the index
> > [daemon_sleep <ms>]	Time between bitmap daemon work to clear bits
> > [min_recovery_rate <kB/sec/disk>]	Throttle RAID initialization
> > [max_recovery_rate <kB/sec/disk>]	Throttle RAID initialization
> > [max_write_behind <value>]		See '-write-behind=' (man mdadm)
> > [stripe_cache <sectors>]		Stripe cache size for higher RAIDs
> >
> >
> > 'rebuild idx' only allows one device to be rebuilt at a time.  With  
> > RAID6 it
> > is possible that two devices can be ready for rebuild, in which case  
> > we would
> > want to rebuild both of them.
> 
> In which case, you can specify the parameter twice:
> "... rebuild 0 rebuild 1..."
> No problem there, I think.

Yes, I see.  I'm use to seeing positional parameter in dm tables and didn't
process properly that these are key/value parameters.


> 
> > Also if you stop an array during a rebuild you really want to start  
> > again
> > where you were up to.
> 
> This is kept in the superblock (forthcoming patches).  In the case  
> where metadata devices are not specified (or can't be specified, as in  
> this initial set of patches), the user has two choices: 1) allow the  
> array to completely resync, or 2) specify [no]sync.

OK... though 'resync' and 'rebuild' are very different things and should not
be confused.  So the [no]sync option should not affect rebuild of new devices.



> 
> > Most general solution would be to combine the rebuild information  
> > with the
> > list of component devices - either a sector number or something to  
> > indicate
> > that the rebuild it complete (which could be just a v.big sector  
> > number).
> 
> Is there something more to this, or is the above comment suitable for  
> this also?

No, I think you've address it all.


> 
> > I'd much prefer 'daemon_sleep' to be in seconds, we decimals  
> > supported if
> > needed.
> 
> I had this in seconds originally, but device-mapper tables already  
> have a precedent for specifying things in ms.  We don't want to have  
> each target pick their own units.  (A similar thing can be said for  
> values given in sectors.  We may have wanted kiB or B, but sectors is  
> the standard.)

Fair enough.


> 
> >
> > Also:
> >
> > 3:	<#raid_devs> <meta_dev1> <dev1> .. <meta_devN> <devN>
> >
> > This doesn't allow offsets into the various devices like dm-stripe,
> > dm-linear, dm-raid1 all do.
> 
> This is a conscious choice.  The offset was discarded because it is  
> unneeded.

Famous last words!!!

When reshaping a RAID5/6 to change the chunk size or layout, or when
converting an N drive RAID5 to N+1 drive RAID6, it makes it a lot easier if
you can can change the data offset at the same time.  Then you don't have to
keep backing up data.  md cannot do this yet but I hope to add the code soon
and because 'data_offset' is a distinct value it is conceptually easy to do.
If 'data_offset' is assumed to be zero, then it isn't.

But I don't know to what extent you are planning on supporting reshaping of
arrays....

Thanks,

NeilBrown



> 
>   brassow
