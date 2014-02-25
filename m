From: Nate Dailey <nate.dailey@stratus.com>
Subject: Re: [PATCH] dm-raid: check events in super_validate
Date: Tue, 25 Feb 2014 17:22:55 -0500
Message-ID: <530D17BF.7090008@stratus.com>
References: <52ED0628.4030203@stratus.com> <20140225163020.6f299f15@notabene.brown> <DB09A2EA-5D6C-449F-A61A-EFF556F269B8@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <DB09A2EA-5D6C-449F-A61A-EFF556F269B8@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brassow Jonathan <jbrassow@redhat.com>, NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Here's what I've done to reproduce this:

- remove a disk containing one leg of an LVM raid1 mirror
- do enough IO that a lengthy recovery will be required
- insert the removed disk
- let recovery begin, but deactivate the LV before it completes
- activate the LV

This is the point where the recovery should start back up, but it 
doesn't. I haven't tried this in a few weeks, but am happy to try it 
again if it would help.

Nate




On 02/25/2014 05:13 PM, Brassow Jonathan wrote:
> On Feb 24, 2014, at 11:30 PM, NeilBrown wrote:
>
>> On Sat, 1 Feb 2014 09:35:20 -0500 Nate Dailey <nate.dailey@stratus.com> wrote:
>>
>>> If an LVM raid1 recovery is interrupted by deactivating the LV, when the
>>> LV is reactivated it comes up with both members in sync--the recovery
>>> never completes.
>>>
>>> I've been trying to figure out how to fix this. Does this approach look
>>> okay? I'm not sure what else to use to determine that a member disk is
>>> out of sync. It looks like if disk_recovery_offset in the superblock
>>> were updated during the recovery, that would also cause it to resume
>>> after interruption--but MD skips the recovery target disk when writing
>>> superblocks, so this doesn't work.
>>>
>>> Comments?
>> I know it is confusing, but this should really have gone to dm-devel rather
>> than linux-raid, to make sure Jon Brassow see it (hi Jon!).
>>
>> Setting recovery_offset to 0 certainly looks wrong, it should be set to
>>   sb->disk_recovery_offset
>> like the code just above your change.
>> Why does the code there not meet your need.
>>
>> Jon: can you help?
> Sure, thanks for forwarding.
>
> Could you describe first how you are creating the problem?
>
> When I create a RAID1 LV, deactivate it, and reactivate it; I don't see it skip the sync.  Also, if I replace a single drive and cycle the LV, I don't see it skip the sync.  What steps am I missing?
>
>   brassow
>

