From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC PATCH v2 3/3] dm zoned: add regular device info to metadata
Date: Wed, 25 Mar 2020 09:45:04 +0100
Message-ID: <6db63d3a-99e7-98f6-4b74-4a649d90d363@suse.de>
References: <20200324110255.8385-1-bob.liu@oracle.com>
 <20200324110255.8385-4-bob.liu@oracle.com>
 <CO2PR04MB23438E0AB35CC46732F96085E7CE0@CO2PR04MB2343.namprd04.prod.outlook.com>
 <812da9e9-cfd2-ea24-60cb-4af48f476079@suse.de>
 <0e7c5043-4345-b052-7cec-a53cfea340f7@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <0e7c5043-4345-b052-7cec-a53cfea340f7@oracle.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Bob Liu <bob.liu@oracle.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
List-Id: dm-devel.ids

On 3/25/20 8:29 AM, Bob Liu wrote:
> On 3/25/20 2:47 PM, Hannes Reinecke wrote:
>> On 3/25/20 7:29 AM, Damien Le Moal wrote:
>>> On 2020/03/24 20:04, Bob Liu wrote:
>>>> This patch implemented metadata support for regular device by:
>>>>    - Emulated zone information for regular device.
>>>>    - Store metadata at the beginning of regular device.
>>>>
>>>>        | --- zoned device --- | -- regular device ||
>>>>        ^                      ^
>>>>        |                      |Metadata
>>>> zone 0
>>>>
>>>> Signed-off-by: Bob Liu <bob.liu@oracle.com>
>>>> ---
>>>>    drivers/md/dm-zoned-metadata.c | 135 +++++++++++++++++++++++++++++++----------
>>>>    drivers/md/dm-zoned-target.c   |   6 +-
>>>>    drivers/md/dm-zoned.h          |   3 +-
>>>>    3 files changed, 108 insertions(+), 36 deletions(-)
>>>>
>> Having thought about it some more, I think we cannot continue with this 'simple' approach.
>> The immediate problem is that we lie about the disk size; clearly the
>> metadata cannot be used for regular data, yet we expose a target device with the full size of the underlying device.
> 
> The exposed size is "regular dev size + zoned dev size - metadata size - reserved seq zone size".
> I didn't see why there is a lie?
> 
The lie is in generating the device-mapper line for setting up the 
target device.
Format is

0 <size> zoned <zoned-dev> <cache-dev>

and <size> is the capacity of the resulting device-mapper device.
So we should have adapted this to exclude the metadata size and the 
reserved seq zone size (even with the original implementation); 
'blksize' is certainly wrong here.

>> Making me wonder if anybody ever tested a disk-full scenario...
>> The other problem is that with two devices we need to be able to stitch them together
>> in an automated fashion, eg via a systemd service or udev rule.
>> But for this we need to be able to identify the devices, which means both need to carry
>> metadata, and both need to have unique identifier within the metadata. Which the current
>> metadata doesn't allow to.
>>
>> Hence my plan is to implement a v2 metadata, carrying UUIDs for the dmz set _and_ the
>> component device. With that we can update blkid to create links etc so that the devices
>> can be identified in the system.
>> Additionally I would be updating dmzadm to write the new metadata.
>>
>> And I will add a new command 'start' to dmzadm which will then create the device-mapper
>> device _with the correct size_. It also has the benefit that we can create the device-mapper
>> target with the UUID specified in the metadata, so the persistent device links will be
>> created automatically.
>>
>> Bob, can you send me your improvements to dmzadm so that I can include them in my changes?
>>
> 
> Attached, but it's a big patch I haven't split them to smaller one.
> The dmz_check/repair can't work neither in current stage.
> 
Yeah, of course. Plan is to start with V2 metadata handling first anyway 
(it adding UUIDs), then add the 'start' functionality, and only then 
implement cache device handling.

Thanks for the patch.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
