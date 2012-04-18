From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH 0 of 4] dm-raid: various bug fixes
Date: Wed, 18 Apr 2012 09:05:59 -0500
Message-ID: <3F107DB9-0ED6-47C5-9F5A-DF485017EA92@redhat.com>
References: <1334716219.23908.14.camel@f14.redhat.com> <20120418134843.1376cc7e@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120418134843.1376cc7e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: dm-devel@redhat.com, linux-raid@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids


On Apr 17, 2012, at 10:48 PM, NeilBrown wrote:

> On Tue, 17 Apr 2012 21:30:19 -0500 Jonathan Brassow <jbrassow@redhat.com>
> wrote:
> 
>> Neil,
>> 
>> I've cleaned up the first two patches I sent earlier:
>> 	[1 of 5] dm-raid-set-recovery-flags-on-resume.patch
>> 	[2 of 5] dm-raid-record-and-handle-missing-devices.patch
>> and added a couple more:
>> 	[3 of 5] dm-raid-need-safe-version-of-rdev_for_each.patch
>> 	[4 of 5] dm-raid-use-md_error-in-place-of-faulty-bit.patch
>> 	[5 of 5] md-raid1-further-conditionalize-fullsync.patch
>> 
>> Patch [5 of 5] I think needs some work.  It fixes the problem I'm seeing
>> and seems to go along with similar logic used for RAID5 in commit
>> d6b212f4b19da5301e6b6eca562e5c7a2a6e8c8d.  It also seems like a workable
>> solution based on the code surrounding commit
>> d30519fc59c5cc2f7772fa67b16b1a2426d36c95.  Can you let me know if I'm
>> stretching the usage of 'saved_raid_disk' too far?
>> 
>> Thanks,
>> brassow
> 
> Thanks.
> 
> 3-of-5 should go in 3.4 presumably.  The rest wait for 3.5?  Or do you think
> they should be in 3.4?
> 
> 5-of-5:  Maybe it would make sense just to check if saved_raid_disk >= 0 ??
> 
> This is only relevant for dm-raid isn't it?  I'd need to think through how
> all that fits together again.
> 
> The rest are all fine and are in my for-next

Thanks Neil,

Yes, 3-of-5 should probably go in sooner rather than later.  Waiting on the others shouldn't hurt.

5-of-5: changing the check to 'saved_raid_disk >= 0' would be fine, but I think I should initialize 'saved_raid_disk' to -1 in dm-raid.c then normally.  Right now, an nominal initial value is not set - meaning it is '0'.  (When a device comes back from a failure, 'saved_raid_disk' is assigned its old position.)

 brassow