From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC PATCH v2 3/3] dm zoned: add regular device info to metadata
Date: Wed, 25 Mar 2020 11:00:30 +0100
Message-ID: <cdf003a6-b0c8-30c0-edc3-049471a7a2b0@suse.de>
References: <20200324110255.8385-1-bob.liu@oracle.com>
 <20200324110255.8385-4-bob.liu@oracle.com>
 <CO2PR04MB23438E0AB35CC46732F96085E7CE0@CO2PR04MB2343.namprd04.prod.outlook.com>
 <812da9e9-cfd2-ea24-60cb-4af48f476079@suse.de>
 <CO2PR04MB23439B5FA88275A80D3449DFE7CE0@CO2PR04MB2343.namprd04.prod.outlook.com>
 <0bd2daa1-abbf-681d-405c-f7e4aecd577c@suse.de>
 <CO2PR04MB23433CAD26D492654041FCDCE7CE0@CO2PR04MB2343.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CO2PR04MB23433CAD26D492654041FCDCE7CE0@CO2PR04MB2343.namprd04.prod.outlook.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Damien Le Moal <Damien.LeMoal@wdc.com>, Bob Liu <bob.liu@oracle.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
List-Id: dm-devel.ids

On 3/25/20 10:10 AM, Damien Le Moal wrote:
> On 2020/03/25 17:52, Hannes Reinecke wrote:
>> On 3/25/20 9:02 AM, Damien Le Moal wrote:
>>> On 2020/03/25 15:47, Hannes Reinecke wrote:
>>>> On 3/25/20 7:29 AM, Damien Le Moal wrote:
>>>>> On 2020/03/24 20:04, Bob Liu wrote:
>>>>>> This patch implemented metadata support for regular device by:
>>>>>>     - Emulated zone information for regular device.
>>>>>>     - Store metadata at the beginning of regular device.
>>>>>>
>>>>>>         | --- zoned device --- | -- regular device ||
>>>>>>         ^                      ^
>>>>>>         |                      |Metadata
>>>>>> zone 0
>>>>>>
>>>>>> Signed-off-by: Bob Liu <bob.liu@oracle.com>
>>>>>> ---
>>>>>>     drivers/md/dm-zoned-metadata.c | 135 +++++++++++++++++++++++++++++++----------
>>>>>>     drivers/md/dm-zoned-target.c   |   6 +-
>>>>>>     drivers/md/dm-zoned.h          |   3 +-
>>>>>>     3 files changed, 108 insertions(+), 36 deletions(-)
>>>>>>
>>>> Having thought about it some more, I think we cannot continue with this
>>>> 'simple' approach.
>>>> The immediate problem is that we lie about the disk size; clearly the
>>>> metadata cannot be used for regular data, yet we expose a target device
>>>> with the full size of the underlying device.
>>>> Making me wonder if anybody ever tested a disk-full scenario...
>>>
>>> Current dm-zoned does not do that... What is exposed as target capacity is
>>> number of chunks * zone size, with the number of chunks being number of zones
>>> minus metadata zones minus number of zones reserved for reclaim. And I did test
>>> disk full scenario (when performance goes to the trash bin because reclaim
>>> struggles...)
>>>
>> Thing is, the second number for the dmsetup target line is _supposed_ to
>> be the target size.
>> Which clearly is wrong here.
>> I must admit I'm not sure what device-mapper will do with a target
>> definition which is larger than the resulting target device ...
>> Mike should know, but it's definitely awkward.
> 
> AHh. OK. Never thought of it like this, especially considering the fact that the
> table entry is checked to see if the entire drive is given. So instead of the
> target size, I was in fact using the size parameter of dmsetup as the size to
> use on the backend, which for dm-zoned must be the device capacity...
> 
> Not sure if we can fix that now ? Especially considering that the number of
> reserved seq zones for reclaim is not constant but a dmzadm format option. So
> the average user would have to know exactly the useable size to dmsetup the
> target. Akward too, or rather, not super easy to use. I wonder how dm-thin or
> other targets with metadata handle this ? Do they format themselves
> automatically on dmsetup using the size specified ?
> 
Which is _precisely_ why I want to have the 'start' option to dmzadm.
That can read the metadata, validate it, and then generate the correct 
invocation for device-mapper.
_And_ we get a device-uuid to boot, as this can only be set from the ioctl.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
