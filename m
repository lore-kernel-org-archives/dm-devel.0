From: Dave Chinner <david@fromorbit.com>
Subject: Re: disk/crypto performance regression 2.6.31 -> 2.6.32 (mmap
	problem?)
Date: Wed, 24 Feb 2010 09:41:11 +1100
Message-ID: <20100223224111.GC16175@discord.disaster>
References: <alpine.DEB.1.10.1002191729220.28940@uplift.swm.pp.se> <alpine.DEB.1.10.1002221337170.28940@uplift.swm.pp.se> <20100223044818.GD22370@discord.disaster> <alpine.DEB.1.10.1002230820110.12694@uplift.swm.pp.se> <20100223133219.GB16175@discord.disaster> <alpine.DEB.1.10.1002232138021.12694@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.1002232138021.12694@uplift.swm.pp.se>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Feb 23, 2010 at 09:42:40PM +0100, Mikael Abrahamsson wrote:
> On Wed, 24 Feb 2010, Dave Chinner wrote:
>
> Thought I should send the dump only to you, would you like me to post to  
> the list as well and include a link to the logfile (think attachments  
> shouldn't be done too much to lkml, right?). Feel free to post any  
> information from this letter or attachment back onto lkml if you feel 
> it's appropriate.

Attachments under roughly 100kb (IIRC) are fine for LKML. This is
allowed specifically to let people attach log files and configs.

I've re-added the lkml CC to continue the discussion there.  I also
added the DM mailing list, so that they know directly that barriers
are causing _significant_ system slowdowns. This is important,
because there have been several reports of this problem since the
start of the year to XFS forums as people are upgrading kernels.

>> Barriers are only recently supported across DM and MD, so it would be  
>> worth checking you logs for the last mount of the filesystems to  
>> confirm.
>
> You're right, it doesn't say that anymore in 2.6.31, so I think I'm 
> indeed running with barriers on.

And the stack traces confirm that. Every single blocked process
output set has this trace in it:

kdmflush      D 0000000000000000     0  3082      2 0x00000000
 ffff880208553d20 0000000000000046 ffff880210a5f640 0000000000015880
 ffff8802241ac7c0 0000000000015880 0000000000015880 0000000000015880
 0000000000015880 ffff8802241ac7c0 0000000000015880 0000000000015880
Call Trace:
 [<ffffffff81527cf8>] io_schedule+0x28/0x40
 [<ffffffff813e7ca7>] dm_wait_for_completion+0x87/0x150
 [<ffffffff81053c50>] ? default_wake_function+0x0/0x10
 [<ffffffff813e8617>] ? __split_and_process_bio+0x107/0x170
 [<ffffffff813e86a5>] dm_flush+0x25/0x70
 [<ffffffff813e8749>] process_barrier+0x59/0xf0
 [<ffffffff813e881b>] dm_wq_work+0x3b/0x100
 [<ffffffff813e87e0>] ? dm_wq_work+0x0/0x100
 [<ffffffff81073695>] run_workqueue+0x95/0x170
 [<ffffffff81073814>] worker_thread+0xa4/0x120
 [<ffffffff810789c0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81073770>] ? worker_thread+0x0/0x120
 [<ffffffff810785d6>] kthread+0xa6/0xb0
 [<ffffffff810130ea>] child_rip+0xa/0x20
 [<ffffffff81078530>] ? kthread+0x0/0xb0
 [<ffffffff810130e0>] ? child_rip+0x0/0x20

That is, it appears that DM is blocking waiting for a barrier to
complete. Everything else is backed up waiting for IO completion to
occur...

>>> Currently it's "lazy-count=0", so I'll change that setting tonight.
>
> I didn't do this before the test I'm referring to now.
>
>> When IO is really slow so we get a better idea of where things are  
>> blocking. Running a few of these 30s apart will give a fair indication  
>> of what is blocked and what is making progress....
>
> Attached to this email, logfile from yesterday and today.
>
> Some interesting parts as well, that didn't trigger from the above sysrq  
> stuff:
>
> Feb 22 19:56:16 ub kernel: [201245.583915] INFO: task md0_raid5:425 blocked for more than 120 seconds.
> Feb 22 22:36:16 ub kernel: [210846.031875] INFO: task xfssyncd:3167 blocked for more than 120 seconds.
> Feb 23 18:10:18 ub kernel: [281287.492499] INFO: task kdmflush:3082 blocked for more than 120 seconds.
> Feb 23 18:12:18 ub kernel: [281407.491041] INFO: task kdmflush:3082 blocked for more than 120 seconds.
> Feb 23 21:36:18 ub kernel: [293647.665917] INFO: task md0_raid5:425 blocked for more than 120 seconds.
>
> Didn't really think md0_raid5 could be blocked like that...

They are blocking in:

 [<ffffffff813dc0e1>] md_super_wait+0xc1/0xe0
 [<ffffffff810789c0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff813dc4e0>] md_update_sb+0x230/0x3b0
 [<ffffffff813de2f2>] md_check_recovery+0x272/0x590
 [<ffffffffa0063621>] raid5d+0x21/0x320 [raid456]
 [<ffffffff813dbd94>] md_thread+0x44/0x120

I'm assuming this is just taking a long time because of all the
other IO that is going on slowing this down. The other 3 (xfssyncd,
kdmflush) are all waiting for barrier IO to complete...

So it sounds like the immediate WAR for your extremely slow IO
problem is to mount the XFS filesystems with "-o nobarrier", but
keep in mind this can result in corruption if a crash occurrs.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
