From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH v2] DM RAID: Add support for MD RAID10
Date: Mon, 16 Jul 2012 17:06:32 -0500
Message-ID: <544F2898-B9C7-42CD-A0FD-F1DE35C5E628@redhat.com>
References: <1342057001.22214.6.camel@f16> <20120712163207.222b4bcc@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120712163207.222b4bcc@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: dm-devel@redhat.com, linux-raid@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids


On Jul 12, 2012, at 1:32 AM, NeilBrown wrote:

>> 
>> @@ -76,6 +80,7 @@ static struct raid_type {
>> 	const unsigned algorithm;	/* RAID algorithm. */
>> } raid_types[] = {
>> 	{"raid1",    "RAID1 (mirroring)",               0, 2, 1, 0 /* NONE */},
>> +	{"raid10",   "RAID10 (striped mirrors)",        0, 2, 10, -1 /* Varies */},
>> 	{"raid4",    "RAID4 (dedicated parity disk)",	1, 2, 5, ALGORITHM_PARITY_0},
>> 	{"raid5_la", "RAID5 (left asymmetric)",		1, 2, 5, ALGORITHM_LEFT_ASYMMETRIC},
>> 	{"raid5_ra", "RAID5 (right asymmetric)",	1, 2, 5, ALGORITHM_RIGHT_ASYMMETRIC},
> 
> Initialising the "unsigned" algorithm to "-1" looks like it is asking for
> trouble.

I'm initializing to -1 because I know it is a value that will fail if not set later in the setup process.  I could just as easily choose the default values (near = 2).

> 
>> @@ -493,7 +554,7 @@ static int parse_raid_params(struct raid
>> 			 */
>> 			value /= 2;
>> 
>> -			if (rs->raid_type->level < 5) {
>> +			if (rs->raid_type->level != 5) {
>> 				rs->ti->error = "Inappropriate argument: stripe_cache";
>> 				return -EINVAL;
>> 			}
> 
> This leaves RAID6 out in the cold.  Maybe
>  level < 5 || level > 6
> or      !=5          !=6
> or a switch statement?

Thanks.  For some reason I had thought that raid6 had level=5, like raid4...  Fixed.



>> @@ -536,9 +605,25 @@ static int parse_raid_params(struct raid
>> 	if (dm_set_target_max_io_len(rs->ti, max_io_len))
>> 		return -EINVAL;
>> 
>> -	if ((rs->raid_type->level > 1) &&
>> -	    sector_div(sectors_per_dev, (rs->md.raid_disks - rs->raid_type->parity_devs))) {
>> +	if (rs->raid_type->level == 10) {
>> +		/* (Len * Stripes) / Mirrors */
>> +		sectors_per_dev *= rs->md.raid_disks;
>> +		if (sector_div(sectors_per_dev, raid10_copies)) {
>> +			rs->ti->error = "Target length not divisible by number of data devices";
>> +			return -EINVAL;
>> +		}
> 
> I'm not entirely sure what you are trying to do here, but I don't think it
> works.
> 
> At the very least you would need to convert the "sectors_per_dev" number to a
> 'chunks_per_dev' before multiplying by raid_disks and dividing by copies.
> 
> But even that isn't necessary.  If you have a 3-device near=2 array with an
> odd number of chunks per device, that will still work.  The last chunk won't
> be mirrored, so won't be used.
> Until a couple of weeks ago a recovery of the last device would trigger an
> error when we try to recover that last chunk, but that is fixed now.
> 
> So if you want to impose this limitation (and there is some merit in making
> sure people don't confuse themselves), I suggest it get imposed in the
> user-space tools which create the RAID10.

I have seen what you do in calc_sectors(), I suppose I could bring that in.  However, I'm simply trying to find the value that will be preliminarily assigned to mddev->dev_sectors.  It is an enforced (perhaps unnecessary) constraint that the array length be divisible by the number of data devices.  I'm not accounting for chunk boundaries - I leave that to userspace to configure and MD to catch.

 brassow

