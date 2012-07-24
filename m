From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH v4] DM RAID: Add support for MD RAID10
Date: Mon, 23 Jul 2012 20:18:03 -0500
Message-ID: <9EC0A670-52AB-4623-A9E7-997AA4930791@redhat.com>
References: <1343072962.20599.2.camel@f16> <20120724082611.41a275d2@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120724082611.41a275d2@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, linux-raid@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>
List-Id: dm-devel.ids


On Jul 23, 2012, at 5:26 PM, NeilBrown wrote:

> On Mon, 23 Jul 2012 14:49:22 -0500 Jonathan Brassow <jbrassow@redhat.com>

</snip>

> 
>> 
>> br@@ -436,6 +475,7 @@ static int parse_raid_params(struct raid
>> 				if (rebuild_cnt > rs->raid_type->parity_devs)
>> 					rs->ti->error = "Too many rebuild devices specified for given RAID type";
>> 				break;
>> +			case 10:
>> 			default:
>> 				DMERR("The rebuild parameter is not supported for %s", rs->raid_type->name);
>> 				rs->ti->error = "Rebuild not supported for this RAID type";
> 
> This hunk doesn't apply for me, or against 3.5.  Is there some patch I'm
> missing.
> I do vaguely recall you changing this to a switch statement I think, but I
> still have an if statement here.
> If I'm missing a patch - could you resend it please?

My fault.  I sent these two patches to dm-devel and failed to CC linux-raid or you.

https://www.redhat.com/archives/dm-devel/2012-July/msg00041.html
https://www.redhat.com/archives/dm-devel/2012-July/msg00042.html

Agk hasn't pushed these two yet and we should probably wait for that to happen.  The above two patches are necessary for this patch, but are dependent upon other patches that agk has staged at the moment.  The timing is not working out well, and we'll have to wait.

>>> @@ -536,8 +585,30 @@ static int parse_raid_params(struct raid
>> 	if (dm_set_target_max_io_len(rs->ti, max_io_len))
>> 		return -EINVAL;
>> 
>> -	if ((rs->raid_type->level > 1) &&
>> -	    sector_div(sectors_per_dev, (rs->md.raid_disks - rs->raid_type->parity_devs))) {
>> +	if (rs->raid_type->level == 10) {
>> +		if (raid10_copies > rs->md.raid_disks) {
>> +			rs->ti->error = "Not enough devices to satisfy specification";
>> +			return -EINVAL;
>> +		}
>> +
>> +		/* (Len * #mirrors) / #devices */
>> +		sectors_per_dev = rs->ti->len * raid10_copies;
>> +		if (sector_div(sectors_per_dev, rs->md.raid_disks)) {
>> +			rs->ti->error = "Target length not evenly divisible by number of stripes";
>> +			return -EINVAL;
>> +		}
> 
> This test is still completely pointless, and putting an extra test for chunk
> alignment after it doesn't make it any less pointless. 
> And putting an important division inside the condition of an if(), hides it a
> bit more than I like.
> But it probably isn't worth arguing about it any more so once I can get a
> patch to apply I'll take it.

I'll pull the division out of the conditional so that it's a little more visible.  Once agk has pushed the aforementioned patches, I'll repost this patch with that change as 'v5'.

I don't want to belabor the issue - especially since you are kind enough to be accommodating, but I don't know how I can get by without calculating and setting 'mddev->dev_sectors'.  MD can't get that information from anywhere else (when setting up RAID through DM).  The main point is to compute sectors_per_dev, but secondarily I am checking for other conditions - like not aligning on chunk boundaries or not being evenly divisible.  Failure to set sectors_per_dev - or set it correctly - results in an ill-sized array (mddev->array_sectors).  The per device value is not passed in via DM table either - it must be computed.  So, I don't understand why it is pointless.

 brassow


