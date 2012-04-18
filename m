From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH 0 of 2] dm-raid: Bug fixes
Date: Tue, 17 Apr 2012 20:09:26 -0500
Message-ID: <AE025552-8180-470B-A2A5-86207AA62E73@redhat.com>
References: <1334619917.16017.25.camel@f14.redhat.com> <20120417142658.265a0a40@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120417142658.265a0a40@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: dm-devel@redhat.com, linux-raid@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids

Thanks Neil,

1st patch:
I'll move 'MD_RECOVERY_NEEDED' into mddev_resume and keep FROZEN in raid_resume.

2nd patch:
I pulled out the 'degraded' accounting.  I'll switch from setting Faulty in 'read_sb_page' to calling 'md_error' in a separate patch.

Apologies for the the flush question.  I had confused device-mapper's use of "flush" and "lockfs", thinking that a 'flush' would perform the 'lock_fs'.  It does not, so we should expect the file system to be caching some bits.  (Snapshots use the 'lock_fs' feature to quiesce the file system before the snapshot is finalized.  I think it would make sense to do this when a mirror image is split-off also, but that's now a userspace issue.)

I have a few other patches I pass along as well,
 brassow

On Apr 16, 2012, at 11:26 PM, NeilBrown wrote:

> On Mon, 16 Apr 2012 18:45:17 -0500 Jonathan Brassow <jbrassow@redhat.com>
> wrote:
> 
>> Neil,
>> 
>> I have 3 bugs that I've been working on.  Two I have fixed and one I
>> have not, but have a question.
>> 
>> The first patch (dm-raid-set-recovery-flags-on-resume) addresses the
>> fact that some recovery flags are altered during suspend, but not
>> corrected upon resume.  I'm wondering if you think these flags would be
>> better pushed into 'mddev_resume' rather that being altered in
>> dm-raid.c?
> 
> I think setting MD_RECOVERY_NEEDED in mddev_resume makes perfect sense.
> It is quite safe to set it at any time, and the one place where md.c calls
> mddev_resume() it sets the flag immediately afterwards.  So moving that
> setting into mddev_resume() makes sense.
> 
> MD_RECOVERY_FROZEN I'm less sure about.  If we clear it in mddev_resume(),
> then as soon as you convert a RAID5 to a RAID6 it would start recovery of the
> extra device, even if you had set sync_action to 'frozen' first.  That would
> be wrong.
> 
> I guess we are over-loading 'MD_RECOVERY_FROZEN' it bit.  It means both
> "user-space requested a freeze" and  "resync temporarily disabled".
> 
> I wonder if md_stop_writes() only needs to set it temporarily, and to make
> sure MD_RECOVERY_NEEDED isn't set when it completes.  That might be enough??
> 
> However maybe it is easiest to just clear it in raid_resume() like you did.
> 
> 
>> 
>> The second patch (dm-raid-record-and-handle-missing-devices) adds code
>> to address the case where the user specifies particular array positions
>> as missing.  I don't have any significant questions about this patch.
> 
> I do :-)
> 
> md already does all the proper accounting for ->degraded, dm-raid shouldn't
> need to.
> 
> Incrementing md.degraded in dev_parms shouldn't be needed as md_run is
> subsequently called, and it sets md.degraded correctly.
> 
> incrementing it in read_disk_sb() and setting the Faulty flag is wrong.  I
> think it should just call md_error().
> 
> The other changes in that patch look OK.
> 
> 
>> 
>> The 3rd issue I am seeing concerns how 'suspend' happens.  Suspend
>> should flush all outstanding I/O and quiesce.  When I look at the code,
>> I feel it should be doing this.  ('md_stop_writes' is called and
>> followed-up by a call to 'mddev_suspend', which quiesces the
>> personality.)  However, if I create a RAID1 device, suspend it, and then
>> detach one of the legs, it does not show the changes written immediately
>> before the suspend.  If I issue a 'sync', then the changes do show-up.
>> I confused as to why the suspend process doesn't seem to be pushing out
>> the writes that have been issued.  Any ideas?
> 
> That sounds like it is behaving exactly as I would expect.
> You have written to the filesystem (and so to the pagecache) but the
> filesystem hasn't written to the device yet.  That happens after a time, or
> on a 'sync' or 'fsync'.
> 
> You might be able to get the block device to ask the filesystem to flush
> things out using freeze_bdev(), but I'm not sure of the details there.
> It might not flush things, it might just ensure metadata is consistent - or
> something.
> 
> 
> NeilBrown

