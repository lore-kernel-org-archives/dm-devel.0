From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCHv5 00/14] dm-zoned: metadata version 2
Date: Mon, 11 May 2020 06:55:04 +0000
Message-ID: <BY5PR04MB69009A2DBA8782E65AF7B6D8E7A10@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200508090332.40716-1-hare@suse.de>
	<BY5PR04MB6900138C0F78196D0F81BF07E7A10@BY5PR04MB6900.namprd04.prod.outlook.com>
	<1e68571f-0205-93c8-e535-a472c1a7b5d8@suse.de>
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
To: Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>
Cc: Bob Liu <bob.liu@oracle.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 2020/05/11 15:31, Hannes Reinecke wrote:
> On 5/11/20 4:46 AM, Damien Le Moal wrote:
>> On 2020/05/08 18:03, Hannes Reinecke wrote:
>>> Hi all,
>>>
>>> this patchset adds a new metadata version 2 for dm-zoned, which brings the
>>> following improvements:
>>>
>>> - UUIDs and labels: Adding three more fields to the metadata containing
>>>    the dm-zoned device UUID and label, and the device UUID. This allows
>>>    for an unique identification of the devices, so that several dm-zoned
>>>    sets can coexist and have a persistent identification.
>>> - Extend random zones by an additional regular disk device: A regular
>>>    block device can be added together with the zoned block device, providing
>>>    additional (emulated) random write zones. With this it's possible to
>>>    handle sequential zones only devices; also there will be a speed-up if
>>>    the regular block device resides on a fast medium. The regular block device
>>>    is placed logically in front of the zoned block device, so that metadata
>>>    and mapping tables reside on the regular block device, not the zoned device.
>>> - Tertiary superblock support: In addition to the two existing sets of metadata
>>>    another, tertiary, superblock is written to the first block of the zoned
>>>    block device. This superblock is for identification only; the generation
>>>    number is set to '0' and the block itself it never updated. The addition
>>>    metadate like bitmap tables etc are not copied.
>>>
>>> To handle this, some changes to the original handling are introduced:
>>> - Zones are now equidistant. Originally, runt zones were ignored, and
>>>    not counted when sizing the mapping tables. With the dual device setup
>>>    runt zones might occur at the end of the regular block device, making
>>>    direct translation between zone number and sector/block number complex.
>>>    For metadata version 2 all zones are considered to be of the same size,
>>>    and runt zones are simply marked as 'offline' to have them ignored when
>>>    allocating a new zone.
>>> - The block number in the superblock is now the global number, and refers to
>>>    the location of the superblock relative to the resulting device-mapper
>>>    device. Which means that the tertiary superblock contains absolute block
>>>    addresses, which needs to be translated to the relative device addresses
>>>    to find the referenced block.
>>>
>>> There is an accompanying patchset for dm-zoned-tools for writing and checking
>>> this new metadata.
>>>
>>> As usual, comments and reviews are welcome.
>>
>> I gave this series a good round of testing. See the attached picture for the
>> results. The test is this:
>> 1) Setup dm-zoned
>> 2) Format and mount with mkfs.ext4 -E packed_meta_blocks=1 /dev/mapper/xxx
>> 3) Create file random in size between 1 and 4MB and measure user seen throughput
>> over 100 files.
>> 3) Run that for 2 hours
>>
>> I ran this over a 15TB SMR drive single drive setup, and on the same drive + a
>> 500GB m.2 ssd added.
>>
>> For the single drive case, the usual 3 phases can be seen: start writing at
>> about 110MB/s, everything going to conventional zones (note conv zones are in
>> the middle of the disk, hence the low-ish throughput). Then after about 400s,
>> reclaim kicks in and the throughput drops to 60-70 MB/s. As reclaim cannot keep
>> up under this heavy write workload, performance drops to 20-30MB/s after 800s.
>> All good, without any idle time for reclaim to do its job, this is all expected.
>>
>> For the dual drive case, things are more interesting:
>> 1) The first phase is longer as overall, there is more conventional space (500G
>> ssd + 400G on SMR drive). So we see the SSD speed first (~425MB/s), then the
>> drive speed (100 MB/s), slightly lower than the single drive case toward the end
>> as reclaim triggers.
>> 2) Some recovery back to ssd speed, then a long phase at half the speed of the
>> ssd as writes go to ssd and reclaim is running moving data out of the ssd onto
>> the disk.
>> 3) Then a long phase at 25MB/s due to SMR disk reclaim.
>> 4) back up to half the ssd speed.
>>
>> No crashes, no data corruption, all good. But is does look like we can improve
>> on performance further by preventing using the drive conventional zones as
>> "buffer" zones. If we let those be the final resting place of data, the SMR disk
>> only reclaim would not kick in and hurt performance as seen here. That I think
>> can all be done on top of this series though. Let's get this in first.
>>
> Thanks for the data! That indeed is very interesting; guess I'll do some 
> tests here on my setup, too.
> (And hope it doesn't burn my NVDIMM ...)
> 
> But, guess what, I had the some thoughts; we should be treating the 
> random zones more like sequential zones in a two-disk setup.
> So guess I'll be resurrecting the idea from my very first patch and 
> implement 'cache' zones in addition to the existing 'random' and 
> 'sequential' zones.

Yes, exactly. With that, reclaim can be modified simply to work only on cache
zones and do not touch random zones. That will also work nicely for both single
and dual drive setups, with the difference that single drive will have no random
zones (all conventional zones will be cache zones).

With that, we could also play with intelligent zone allocation on the SMR drive
to try to put data that is most susceptible to change in random zones. Doing so,
we can do update in-place after the first reclaim of a cache zone into a random
zone and reduce overall reclaim overhead.

> But, as you said, that'll be a next series of patches.
> 
> What program did you use as a load generator?
> 
> Cheers,
> 
> Hannes
> 


-- 
Damien Le Moal
Western Digital Research
