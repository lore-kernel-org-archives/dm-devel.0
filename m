From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH v2] DM RAID: Add support for MD RAID10
Date: Wed, 18 Jul 2012 09:45:51 -0500
Message-ID: <E06497F3-F83E-462B-A1F3-C565AE30E380@redhat.com>
References: <1342057001.22214.6.camel@f16> <20120712163207.222b4bcc@notabene.brown> <544F2898-B9C7-42CD-A0FD-F1DE35C5E628@redhat.com> <20120717123404.3516b943@notabene.brown> <3A8FC300-59E8-48CA-81DF-CCCF780BFE0C@redhat.com> <20120718111146.336c3228@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120718111146.336c3228@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: dm-devel@redhat.com, linux-raid@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids


On Jul 17, 2012, at 8:11 PM, NeilBrown wrote:

> On Tue, 17 Jul 2012 11:15:56 -0500 Brassow Jonathan <jbrassow@redhat.com>
> wrote:
> 
>> 
>> On Jul 16, 2012, at 9:34 PM, NeilBrown wrote:
>> 
>>>>>> 
>>>>>> @@ -536,9 +605,25 @@ static int parse_raid_params(struct raid
>>>>>> 	if (dm_set_target_max_io_len(rs->ti, max_io_len))
>>>>>> 		return -EINVAL;
>>>>>> 
>>>>>> -	if ((rs->raid_type->level > 1) &&
>>>>>> -	    sector_div(sectors_per_dev, (rs->md.raid_disks - rs->raid_type->parity_devs))) {
>>>>>> +	if (rs->raid_type->level == 10) {
>>>>>> +		/* (Len * Stripes) / Mirrors */
>>>>>> +		sectors_per_dev *= rs->md.raid_disks;
>>>>>> +		if (sector_div(sectors_per_dev, raid10_copies)) {
>>>>>> +			rs->ti->error = "Target length not divisible by number of data devices";
>>>>>> +			return -EINVAL;
>>>>>> +		}
>>>>> 
>>>>> I'm not entirely sure what you are trying to do here, but I don't think it
>>>>> works.
>>>>> 
>>>>> At the very least you would need to convert the "sectors_per_dev" number to a
>>>>> 'chunks_per_dev' before multiplying by raid_disks and dividing by copies.
>>>>> 
>>>>> But even that isn't necessary.  If you have a 3-device near=2 array with an
>>>>> odd number of chunks per device, that will still work.  The last chunk won't
>>>>> be mirrored, so won't be used.
>>>>> Until a couple of weeks ago a recovery of the last device would trigger an
>>>>> error when we try to recover that last chunk, but that is fixed now.
>>>>> 
>>>>> So if you want to impose this limitation (and there is some merit in making
>>>>> sure people don't confuse themselves), I suggest it get imposed in the
>>>>> user-space tools which create the RAID10.
>>>> 
>>>> I have seen what you do in calc_sectors(), I suppose I could bring that in.  However, I'm simply trying to find the value that will be preliminarily assigned to mddev->dev_sectors.  It is an enforced (perhaps unnecessary) constraint that the array length be divisible by the number of data devices.  I'm not accounting for chunk boundaries - I leave that to userspace to configure and MD to catch.
>>> 
>>> In that case I suggest you keep it out of dmraid.
>>> 
>>> It might make sense to check that the resulting array size matches what
>>> user-space said to expect - or is at-least-as-big-as.  However I don't see
>>> much point in other size changes there.
>> 
>> I'm not changing any sizes.  I'm finding a value for mddev->dev_sectors (what should I set it to if not the above?), which is the size of each device as computed from the total array size.  If the value can't be computed evenly, then an error is given.  I'm not sure what you are suggesting my alternative is when you say, "keep it out of dm-raid"...  I think this is the least I can do in dm-raid.
> 
> Sorry, I mean 'checks', not 'changes'.
> 
> I was confused a bit by the code.  It might be clearer to have
> 
>   sectors_per_dev = ti->len * rs->md.raid_disks;
>   remainder = sector_div(sectors_per_dev, raid10_copies);

Sure.  It's the same calculation, but I can do it this way to make things clearer.  (Although, I probably wouldn't add the extra 'remainder' variable).

> 
> In almost all cases raid10_copies will be 2 and ti->len will be a multiple of
> 8 (as we don't support chunk sizes less than 4K), so remainder will be 0.
> However this doesn't really prove anything.  It is still entirely possible
> that the resulting 'sectors_per_dev' will not result in a RAID10 which has
> the full ti->len sectors required.
> So your test is not sufficient.

And this is because I am not taking chunk size into account?  For example, if I had:
	ti->len == 100 sectors
	chuck_size == 16 sectors
	raid10_copies == 2
	raid_devices = 4
I would not detect any problems with the code above, but the '50' sectors_per_dev is not evenly divisible by the chunk size and would result in "short" devices.  Each device would have 3 chunks each, not 3.125 chunks.  Thus, I would have to have something like:
if (rs->raid_type->level == 10) {
		/* (Len * Stripes) / Mirrors */
		sectors_per_dev = ti->len * rs->md.raid_disks;
		if (sector_div(sectors_per_dev, raid10_copies) ||
		    (sectors_per_dev & (rs->md.chunk_sectors - 1))) {
			rs->ti->error = "Target length not divisible by number of data devices";
			return -EINVAL;
		}
}

> 
> Also your calculation is incorrect as it doesn't allow for the possibility of
> unused space in the array.
> A 3-drive 2-copy RAID10 with an odd number of chunks will not use the last
> chunk on the last device. In that case the above calculation will result in
> a sectors_per_dev that it too small.

It would also result in an error, wouldn't it?  Should I care (read "allow") about configurations that have unused space in the array?

> 
> I think your sectors_per_dev calculation should round up to a whole number of
> chunks.
> 
>   sectors_per_dev = DIV_ROUND_UP_SECTOR_T(ti->len * rs->md.raid_disks,
>                                           raid10_copies);
>   sectors_per_dev = round_up(sectors_per_dev, rs->md.chunk_sectors);
> 
> And then after calling md_run(), you should check that
> pers->size(mddev, 0, 0) == ti->len
> and abort if not.
> 
> Note that getting the sectors_per_dev right is really really important for
> RAID10-far.  For other layouts and levels a smaller sectors_per_dev will just
> result in less data being available.
> For raid10-far, sectors_per_dev is included in the layout calculations so
> changing it will change the location of data and could result in corruption.

I can certainly add a check after md_run to ensure that mddev->array_size == ti->len.

 brassow

