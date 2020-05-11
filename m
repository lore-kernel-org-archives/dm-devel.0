From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCHv5 00/14] dm-zoned: metadata version 2
Date: Mon, 11 May 2020 11:25:02 +0000
Message-ID: <BY5PR04MB69008CD2C559E69DC17158C8E7A10@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200508090332.40716-1-hare@suse.de>
	<BY5PR04MB6900138C0F78196D0F81BF07E7A10@BY5PR04MB6900.namprd04.prod.outlook.com>
	<BY5PR04MB6900C76141ABD428F42C1840E7A10@BY5PR04MB6900.namprd04.prod.outlook.com>
	<f3b1182e-45fb-4b8b-71ca-a1b340403260@suse.de>
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

On 2020/05/11 20:19, Hannes Reinecke wrote:
> On 5/11/20 12:55 PM, Damien Le Moal wrote:
>> On 2020/05/11 11:46, Damien Le Moal wrote:
>>> Mike,
>>>
>>> I am still seeing the warning:
>>>
>>> [ 1827.839756] device-mapper: table: 253:1: adding target device sdj caused an
>>> alignment inconsistency: physical_block_size=4096, logical_block_size=4096,
>>> alignment_offset=0, start=0
>>> [ 1827.856738] device-mapper: table: 253:1: adding target device sdj caused an
>>> alignment inconsistency: physical_block_size=4096, logical_block_size=4096,
>>> alignment_offset=0, start=0
>>> [ 1827.874031] device-mapper: table: 253:1: adding target device sdj caused an
>>> alignment inconsistency: physical_block_size=4096, logical_block_size=4096,
>>> alignment_offset=0, start=0
>>> [ 1827.891086] device-mapper: table: 253:1: adding target device sdj caused an
>>> alignment inconsistency: physical_block_size=4096, logical_block_size=4096,
>>> alignment_offset=0, start=0
>>>
>>> when mixing 512B sector and 4KB sector devices. Investigating now.
>>
>>
>> OK. Figured that one out: the 500GB SSD I am using for the regular device is
>> 976773168 512B sectors capacity, that is, not a multiple of the 256MB zone size,
>> and not even a multiple of 4K. This causes the creation of a 12MB runt zone of
>> 24624 sectors, which is ignored. But the start sector of the second device in
>> the dm-table remains 976773168, so not aligned on 4K. This causes
>> bdev_stack_limits to return an error and the above messages to be printed.
>>
>> So I think we need to completely ignore the eventual "runt" zone of the regular
>> device so that everything aligns correctly. This will need changes in both
>> dmzadm and dm-zoned.
>>
>> Hannes, I can hack something on top of your series. Or can you resend with that
>> fixed ?
>>
>>
> I _thought_ I had this fixed; the idea was to manipulate the 'runt' zone 
> such that the zone would always displayed as a zone with same size as 
> all the other zones, but marked as offline. IE the (logical) zone layout 
> would always be equidistant, with no runt zones in between.
>  From that perspective the actual size of the runt zone wouldn't matter 
> at all.
> 
> Lemme check.

Was just playing with dmzadm right now, and I did notice that the second device
start offset is indeed a round number of zones, larger than the actual regular
device capacity in my test case. So indeed, that code is in place there.

So the problem may be on the kernel side, something using the first dev capacity
as is instead of the rounded-up value to the zone size... Digging too.

> 
> Cheers,
> 
> Hannes
> 


-- 
Damien Le Moal
Western Digital Research
