From: Bob Liu <bob.liu@oracle.com>
Subject: Re: [RFC PATCH] dm-zoned: extend the way of exposing zoned block
 device
Date: Tue, 4 Feb 2020 11:57:26 +0800
Message-ID: <bc772b99-b629-1979-7ce9-b685242b86d0@oracle.com>
References: <20200108071212.27230-1-Nobody@nobody.com>
 <BYAPR04MB5816BA749332D2FC6CE3993AE73E0@BYAPR04MB5816.namprd04.prod.outlook.com>
 <c4ba178c-f5cf-4dd1-784b-e372d6b09f62@oracle.com>
 <BYAPR04MB5816B2967735225FB37D627BE7000@BYAPR04MB5816.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <BYAPR04MB5816B2967735225FB37D627BE7000@BYAPR04MB5816.namprd04.prod.outlook.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

On 2/3/20 11:06 PM, Damien Le Moal wrote:
> On 2020/02/03 21:47, Bob Liu wrote:
>> On 1/8/20 3:40 PM, Damien Le Moal wrote:
>>> On 2020/01/08 16:13, Nobody wrote:
>>>> From: Bob Liu <bob.liu@oracle.com>
>>>>
>>>> Motivation:
>>>> Now the dm-zoned device mapper target exposes a zoned block device(ZBC) as a
>>>> regular block device by storing metadata and buffering random writes in
>>>> conventional zones.
>>>> This way is not very flexible, there must be enough conventional zones and the
>>>> performance may be constrained.
>>>> By putting metadata(also buffering random writes) in separated device we can get
>>>> more flexibility and potential performance improvement e.g by storing metadata
>>>> in faster device like persistent memory.
>>>>
>>>> This patch try to split the metadata of dm-zoned to an extra block
>>>> device instead of zoned block device itself.
>>>> (Buffering random writes also in the todo list.)
>>>>
>>>> Patch is at the very early stage, just want to receive some feedback about
>>>> this extension.
>>>> Another option is to create an new md-zoned device with separated metadata
>>>> device based on md framework.
>>>
>>> For metadata only, it should not be hard at all to move to another
>>> conventional zone device. It will however be a little more tricky for
>>> conventional zones used for data since dm-zoned assumes that this random
>>> write space is also zoned. Moving this space to a conventional device
>>> requires implementing a zone emulation (fake zones) for the regular
>>> drive, using a zone size that matches the size of sequential zones.
>>>
>>> Beyond this, dm-zoned also needs to be changed to accept partial drives
>>> and the dm core code to accept mixing of regular and zoned disks (that
>>> is forbidden now).
>>>
>>> Another approach worth exploring is stacking dm-zoned as is on top of a
>>> modified dm-linear with the ability to emulate conventional zones on top
>>> of a regular block device (you only need report zones method
>>> implemented). 
>>
>> Looks like the only way to do this emulation is in user space tool(dm-zoned-tools).
>> Write metadata(which contains emulated zone information constructed by dm-zoned-tools)
>> into regular block device.
> 
> User space tool will indeed need some modifications to allow the new
> format. But I would not put this as "doing the emulation" since at that
> level, zones are only an information checked for alignment of metadata
> space and overall capacity of the target. With a regular disk holding the
> metadata, all that needs to be done is assume that this drive is ion fact
> composed solely of conventional zones with the same size as the larger SRM
> disk backend. The total set of zones "assumed" + "real zones from SMR"
> consitute the set of zones that dmzadm will work with for determining the
> overall format, while currently it only uses the set of real zones.
> 
>> It's impossible to add code to every regular block device for emulating conventional zones. 
> 
> There is no need to do that. dm-zoned can emulate fake conventional zones

Oh, what I intend to say is it's impossible adding "BLKREPORTZONE" to regular block device driver.
We have to construct fake zone information for regular device all by dmzadm, based on current information
we can get from regular device.

$ dmzadm --format `regular device` `real zoned device` --force 

> for the regular device (disk or ssd) holding the metadata. Since
> conventional zones do not have any IO restriction nor do they need any zone
> management command (no zone reset), dm-zoned only needs to create a set of
> struct dm_zone for the emulated zones of the regular disk and "manually"
> fill the zone information. This initialization is done in dmz_init_zones().
> Some changes there to create these struct dm_zone and all the remaining
> metadata and write buffering code should not need any change at all (modulo
> the different bdev reference). Do you see the idea ?
> 
> The only place that will need some care is sync processing as 2 devices
> will need to be issued flushes instead of one. The reference to the
> different bdev depending on the zone being accessed will need some care in
> many places too, including reclaim. But dm-kcopy being used there, this
> should be fairly easy.
> 
> Adding a bdevid (an index) field to struct dm_zone, together with an array
> of bdev pointers in struct dmz_dev, should do the trick to simplify
> zone-to-bdev or block-to-bdev conversions (helper functions needed for that).
> 
> Thoughts ?
> 

Thank you for all these suggestions.

Regards,
Bob
