From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH v2] DM RAID: Add support for MD RAID10
Date: Tue, 17 Jul 2012 11:15:56 -0500
Message-ID: <3A8FC300-59E8-48CA-81DF-CCCF780BFE0C@redhat.com>
References: <1342057001.22214.6.camel@f16> <20120712163207.222b4bcc@notabene.brown> <544F2898-B9C7-42CD-A0FD-F1DE35C5E628@redhat.com> <20120717123404.3516b943@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120717123404.3516b943@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: dm-devel@redhat.com, linux-raid@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids


On Jul 16, 2012, at 9:34 PM, NeilBrown wrote:

>>>> 
>>>> @@ -536,9 +605,25 @@ static int parse_raid_params(struct raid
>>>> 	if (dm_set_target_max_io_len(rs->ti, max_io_len))
>>>> 		return -EINVAL;
>>>> 
>>>> -	if ((rs->raid_type->level > 1) &&
>>>> -	    sector_div(sectors_per_dev, (rs->md.raid_disks - rs->raid_type->parity_devs))) {
>>>> +	if (rs->raid_type->level == 10) {
>>>> +		/* (Len * Stripes) / Mirrors */
>>>> +		sectors_per_dev *= rs->md.raid_disks;
>>>> +		if (sector_div(sectors_per_dev, raid10_copies)) {
>>>> +			rs->ti->error = "Target length not divisible by number of data devices";
>>>> +			return -EINVAL;
>>>> +		}
>>> 
>>> I'm not entirely sure what you are trying to do here, but I don't think it
>>> works.
>>> 
>>> At the very least you would need to convert the "sectors_per_dev" number to a
>>> 'chunks_per_dev' before multiplying by raid_disks and dividing by copies.
>>> 
>>> But even that isn't necessary.  If you have a 3-device near=2 array with an
>>> odd number of chunks per device, that will still work.  The last chunk won't
>>> be mirrored, so won't be used.
>>> Until a couple of weeks ago a recovery of the last device would trigger an
>>> error when we try to recover that last chunk, but that is fixed now.
>>> 
>>> So if you want to impose this limitation (and there is some merit in making
>>> sure people don't confuse themselves), I suggest it get imposed in the
>>> user-space tools which create the RAID10.
>> 
>> I have seen what you do in calc_sectors(), I suppose I could bring that in.  However, I'm simply trying to find the value that will be preliminarily assigned to mddev->dev_sectors.  It is an enforced (perhaps unnecessary) constraint that the array length be divisible by the number of data devices.  I'm not accounting for chunk boundaries - I leave that to userspace to configure and MD to catch.
> 
> In that case I suggest you keep it out of dmraid.
> 
> It might make sense to check that the resulting array size matches what
> user-space said to expect - or is at-least-as-big-as.  However I don't see
> much point in other size changes there.

I'm not changing any sizes.  I'm finding a value for mddev->dev_sectors (what should I set it to if not the above?), which is the size of each device as computed from the total array size.  If the value can't be computed evenly, then an error is given.  I'm not sure what you are suggesting my alternative is when you say, "keep it out of dm-raid"...  I think this is the least I can do in dm-raid.

 brassow