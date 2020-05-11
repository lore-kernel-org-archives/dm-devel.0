From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 15/15] dm-zoned: metadata version 2
Date: Mon, 11 May 2020 08:51:49 +0000
Message-ID: <BY5PR04MB6900D34837D615DB2C1EB80FE7A10@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200511082430.39455-1-hare@suse.de>
	<20200511082430.39455-16-hare@suse.de>
	<BY5PR04MB69008424543BE9E497BBEE9DE7A10@BY5PR04MB6900.namprd04.prod.outlook.com>
	<0601428c-8c71-06a9-07b9-d7b1b6331c70@suse.de>
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

On 2020/05/11 17:46, Hannes Reinecke wrote:
> On 5/11/20 10:36 AM, Damien Le Moal wrote:
>> On 2020/05/11 17:24, Hannes Reinecke wrote:
>>> Implement handling for metadata version 2. The new metadata adds
>>> a label and UUID for the device mapper device, and additional UUID
>>> for the underlying block devices.
>>> It also allows for an additional regular drive to be used for
>>> emulating random access zones. The emulated zones will be placed
>>> logically in front of the zones from the zoned block device, causing
>>> the superblocks and metadata to be stored on that device.
>>> The first zone of the original zoned device will be used to hold
>>> another, tertiary copy of the metadata; this copy carries a
>>> generation number of 0 and is never updated; it's just used
>>> for identification.
>>>
>>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>>> Reviewed-by: Bob Liu <bob.liu@oracle.com>
>>> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
>>
>> Forgot to read through the documentation update. A couple of comments added below.
>>
>>> ---
>>>   .../admin-guide/device-mapper/dm-zoned.rst         |  34 ++-
>>>   drivers/md/dm-zoned-metadata.c                     | 310 +++++++++++++++++----
>>>   drivers/md/dm-zoned-target.c                       | 185 ++++++++----
>>>   drivers/md/dm-zoned.h                              |   7 +-
>>>   4 files changed, 427 insertions(+), 109 deletions(-)
>>>
>>> diff --git a/Documentation/admin-guide/device-mapper/dm-zoned.rst b/Documentation/admin-guide/device-mapper/dm-zoned.rst
>>> index 7547ce635161..553752ea2521 100644
>>> --- a/Documentation/admin-guide/device-mapper/dm-zoned.rst
>>> +++ b/Documentation/admin-guide/device-mapper/dm-zoned.rst
>>> @@ -37,9 +37,13 @@ Algorithm
>>>   dm-zoned implements an on-disk buffering scheme to handle non-sequential
>>>   write accesses to the sequential zones of a zoned block device.
>>>   Conventional zones are used for caching as well as for storing internal
>>> -metadata.
>>> +metadata. It can also use a regular block device together with the zoned
>>> +block device; in that case the regular block device will be split logically
>>> +in zones with the same size as the zoned block device. These zones will be
>>> +placed in front of the zones from the zoned block device and will be handled
>>> +just like conventional zones.
>>>   
>>> -The zones of the device are separated into 2 types:
>>> +The zones of the device(s) are separated into 2 types:
>>>   
>>>   1) Metadata zones: these are conventional zones used to store metadata.
>>>   Metadata zones are not reported as useable capacity to the user.
>>> @@ -127,6 +131,13 @@ resumed. Flushing metadata thus only temporarily delays write and
>>>   discard requests. Read requests can be processed concurrently while
>>>   metadata flush is being executed.
>>>   
>>> +If a regular device is used in conjunction with the zoned block device,
>>> +a third set of metadata (without the zone bitmaps) is written to the
>>> +start of the zoned block device. This metadata has a generation counter of
>>> +'0' and will never be updated during normal operation; it just serves for
>>> +identification purposes. The first and second copy of the metadata
>>> +are located at the start of the regular block device.
>>> +
>>>   Usage
>>>   =====
>>>   
>>> @@ -138,12 +149,21 @@ Ex::
>>>   
>>>   	dmzadm --format /dev/sdxx
>>>   
>>> -For a formatted device, the target can be created normally with the
>>> -dmsetup utility. The only parameter that dm-zoned requires is the
>>> -underlying zoned block device name. Ex::
>>>   
>>> -	echo "0 `blockdev --getsize ${dev}` zoned ${dev}" | \
>>> -	dmsetup create dmz-`basename ${dev}`
>>> +If two drives are to be used, both devices must be specified, with the
>>> +regular block device as the first device.
>>
>> Actually, the zoned block device must be first. Otherwise dmzadm complains. We
>> can change that, or change the doc. Which do you prefer ? No strong opinion here.
>>
> Nope, not any more. Fixed it in my local repo (which I haven't pushed, 
> sorry).
> 
> But after the last discussion we had I thought it better and more 
> consistent to have the regular device first, just like the device-mapper 
> interface.

Works for me !

> 
>>> +
>>> +Ex::
>>> +
>>> +	dmzadm --format /dev/sdxx /dev/sdyy
>>> +
>>> +
>>> +Fomatted device(s) can be started with the dmzadm utility, too.:
>>> +
>>> +Ex::
>>> +
>>> +	dmzadm --start /dev/sdxx /dev/sdyy
>>
>> And same here, the zoned device must come first. I added a patch that internally
>> reverse that order for the dm start operation so that the regular device is
>> specified first.
>>
> See above. I've fixed up dmzadm for this.
> 
> I just hadn't pushed the patch as I wanted to get the kernel bits 
> settled. But now that we have I'll be pushing the dm-zoned-tools updates.

Please send changes on top of the "staging" branch. Your first batch of changes
is already merged in that branch.

> 
> Cheers,
> 
> Hannes
> 


-- 
Damien Le Moal
Western Digital Research
