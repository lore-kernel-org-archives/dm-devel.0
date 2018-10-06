From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: dm: Fix report zone remapping
Date: Sat, 6 Oct 2018 04:03:43 +0000
Message-ID: <BN3PR0401MB164048A8F408C67EDE5B82B6E7E40@BN3PR0401MB1640.namprd04.prod.outlook.com>
References: <20181005103452.7134-1-damien.lemoal@wdc.com>
	<20181005182948.GA5628@redhat.com>
	<BN3PR0401MB1640B2763051334D011B0111E7E40@BN3PR0401MB1640.namprd04.prod.outlook.com>
	<20181006034946.GA7891@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Mike,

On 2018/10/06 12:49, Mike Snitzer wrote:
> On Fri, Oct 05 2018 at  9:24pm -0400,
> Damien Le Moal <Damien.LeMoal@wdc.com> wrote:
> 
>> Mike,
>>
>> On 2018/10/06 3:29, Mike Snitzer wrote:
>>> On Fri, Oct 05 2018 at  6:34am -0400,
>>> Damien Le Moal <damien.lemoal@wdc.com> wrote:
>>>
>>>> If dm-linear or dm-flakey have targets on top of a partition of a zoned
>>>> block device, remapping of the start sector and write pointer position
>>>> of the zones reported by a report zones BIO must be modified to not
>>>> only account for the target table entry mapping, but also to account
>>>> for the partition first sector. This start sector must be substracted
>>>> to the start sector of all zones reported. The write pointer position
>>>> of sequential zones must also be reduced by this offset.
>>>>
>>>> Since there is no easy way to access the underlying bdev of the target
>>>> table entry from the dm_target or dm_target_io pointers, modify the
>>>> interface of the function dm_remap_zone_report() to allow a target to
>>>> pass the partition block device starting sector (offset).
>>>>
>>>> Fixes: 10999307c14e ("dm: introduce dm_remap_zone_report()")
>>>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
>>>> Cc: <stable@vger.kernel.org>
>>>
>>> [dropping the actual stable cc from the mail, please don't cc stable in
>>> the mail header, could be that git-send-email just pulled it in but...]
>>
>> My apologies about that. It was indeed git-send-email. Will fix that.
>>
>>> This needs a different fix.  There should be absolutely no need to pass
>>> in a start offset for a device that is already supposed to be described
>>> within the 'struct bio' passed to dm_remap_zone_report().
>>>
>>> Why can't you just use the bio->bi_bdev ?  Err, since commit
>>> 74d46992e0d9d, I mean bio->bi_disk to get the start sector?
>>>
>>> You should be able to get it from:
>>>
>>> struct hd_struct *part = disk_get_part(bio->bi_disk, bio->bi_partno);
>>> part->start_sect;
>>> disk_put_part(part);
>>>
>>> or:
>>>
>>> struct block_device *bdev = bdget_disk(bio->bi_disk, bio->bi_partno);
>>> get_start_sect(fc->dev->bdev);
>>> bdput(bdev);
>>
>> I am afraid this does not work. The original bio disk is of course /dev/dm-xx so
>> not the partition (partno == 0), and the mapped bio passed as argument to the
>> remap zone function (clone of the orig bio) is pointing to the entire underlying
>> disk, not the partition disk used in dmsetup. bi_partno is 0 for both BIOs.
>> Which seems weird, __bio_clone_fast() does copy the disk and part number as is.
>> The disk is of course correctly changed from the orig dm disk to the actual
>> physical disk in the clone, but the partition number stays the same. In the end,
>> only the target has the correct bdev (disk+partno) information it seems.
> 
> OK, that is a bug that must to be found then.

Nope. No bug. I figured it out: after the bio remapping in the target (which
calls bio_set_dev() to indicate the partition bdev target for the bio), the
block core will remap that bio to the container bdev (the entire disk) which is
partition 0. So the partition number is lost when the bio completes and zone
remap cannot get the starting physical sector for the adjustment of the zone
start and wp position.

>> It looks like the partno gets lost, which does not seem correct. I must be
>> missing something, but I fail to see what it is. Any suggestion ?
> 
> Not at the moment but I'll have a closer look early next week.

Now, I see 2 solutions:
* have the target add to the "start" argument passed to dm_remap_zone_report()
the offset (start sector) of the block device. The calculation match what needs
to be done, so it works. It is a little ugly though as the target has to be
"partition aware" in a sense.
* Add a "struct dm_dev *dev" argument to dm_remap_zone_report(). The device
start sector is simply "get_start_sect(dev->bdev)" with that.

I prefer the second solution... What do you think ?

Note that I have a zoned block device series in the work which improves zone
report and simplifies all of this remapping business in dm. But the current code
still needs fixing.

Best regards.

-- 
Damien Le Moal
Western Digital Research
