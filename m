From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCHv2 0/6] dm-zoned: improve cache performance
Date: Thu, 21 May 2020 07:56:07 +0000
Message-ID: <BY5PR04MB690065822588EF8B23C63356E7B70@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200519081424.103318-1-hare@suse.de>
	<BY5PR04MB6900CC6DA3FECFAC70AFDC26E7B90@BY5PR04MB6900.namprd04.prod.outlook.com>
	<20200520185334.GA4926@redhat.com>
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 2020/05/21 3:53, Mike Snitzer wrote:
> On Tue, May 19 2020 at  6:36pm -0400,
> Damien Le Moal <Damien.LeMoal@wdc.com> wrote:
> 
>> On 2020/05/19 17:14, Hannes Reinecke wrote:
>>> Hi all,
>>>
>>> here's an update to dm-zoned to separate out cache zones.
>>> In the update to metadata version 2 the regular drive was split
>>> in emulated zones, which were handled just like 'normal' random
>>> write zones.
>>> This causes a performance drop once these emulated zones have
>>> been mapped, as typicall the random zones from the zoned drive
>>> will perform noticeably slower than those from the regular drive.
>>> (After all, that was kinda the idea of using a regular disk in
>>> the first place ...)
>>>
>>> So in this patchset I've introduced a separate 'cache' zone type,
>>> allowing us to differentiate between emulated and real zones.
>>> With that we can switch the allocation mode to use only cache
>>> zones, and use random zones similar to sequential write zones.
>>> That avoids the performance issue noted above.
>>>
>>> I've also found that the sequential write zones perform noticeably
>>> better on writes (which is all we're caching anyway), so I've
>>> added another patch switching the allocation routine from preferring
>>> sequential write zones for reclaim.
>>>
>>> This patchset also contains some minor fixes like remving an unused
>>> variable etc.
>>>
>>> As usual, comments and reviews are welcome.
>>
>> I ran this overnight with no problems. Throughput results attached.
>> Reclaim seems to be a little too aggressive as it triggers very early. But we
>> can tune that later if really needed: the combination of ext4 writing all over
>> the place and the faster cache zones on SSD may simply result in a percentage of
>> free cache zones becoming low very quickly, in which case, reclaim is working
>> exactly as expected :)
> 
> I've staged this series for 5.8 in linux-next
> 
> Just to make sure no regressions due to all the metadata2 changes: Did
> you happen to verify all worked as expected without using an extra
> drive?

Mike,

Checked again: no problems detected with backward compatibility for single drive
V1 formatted disks. And as I already signaled, I tested both single and dual
drive setups with V2 metadata. Everything is good for me, not seeing any
problem/regression.

Thanks !

> 
>> Mike,
>>
>> With the NVMe io_opt fix patch applied, the alignment warning for the target
>> limits is gone.
> 
> OK
> 
> Thanks,
> Mike
> 
> 


-- 
Damien Le Moal
Western Digital Research
