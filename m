From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [RFC PATCH v2 3/3] dm zoned: add regular device info to metadata
Date: Wed, 25 Mar 2020 08:02:30 +0000
Message-ID: <CO2PR04MB23439B5FA88275A80D3449DFE7CE0@CO2PR04MB2343.namprd04.prod.outlook.com>
References: <20200324110255.8385-1-bob.liu@oracle.com>
 <20200324110255.8385-4-bob.liu@oracle.com>
 <CO2PR04MB23438E0AB35CC46732F96085E7CE0@CO2PR04MB2343.namprd04.prod.outlook.com>
 <812da9e9-cfd2-ea24-60cb-4af48f476079@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Bob Liu <bob.liu@oracle.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
List-Id: dm-devel.ids

On 2020/03/25 15:47, Hannes Reinecke wrote:=0A=
> On 3/25/20 7:29 AM, Damien Le Moal wrote:=0A=
>> On 2020/03/24 20:04, Bob Liu wrote:=0A=
>>> This patch implemented metadata support for regular device by:=0A=
>>>   - Emulated zone information for regular device.=0A=
>>>   - Store metadata at the beginning of regular device.=0A=
>>>=0A=
>>>       | --- zoned device --- | -- regular device ||=0A=
>>>       ^                      ^=0A=
>>>       |                      |Metadata=0A=
>>> zone 0=0A=
>>>=0A=
>>> Signed-off-by: Bob Liu <bob.liu@oracle.com>=0A=
>>> ---=0A=
>>>   drivers/md/dm-zoned-metadata.c | 135 +++++++++++++++++++++++++++++++-=
---------=0A=
>>>   drivers/md/dm-zoned-target.c   |   6 +-=0A=
>>>   drivers/md/dm-zoned.h          |   3 +-=0A=
>>>   3 files changed, 108 insertions(+), 36 deletions(-)=0A=
>>>=0A=
> Having thought about it some more, I think we cannot continue with this =
=0A=
> 'simple' approach.=0A=
> The immediate problem is that we lie about the disk size; clearly the=0A=
> metadata cannot be used for regular data, yet we expose a target device =
=0A=
> with the full size of the underlying device.=0A=
> Making me wonder if anybody ever tested a disk-full scenario...=0A=
=0A=
Current dm-zoned does not do that... What is exposed as target capacity is=
=0A=
number of chunks * zone size, with the number of chunks being number of zon=
es=0A=
minus metadata zones minus number of zones reserved for reclaim. And I did =
test=0A=
disk full scenario (when performance goes to the trash bin because reclaim=
=0A=
struggles...)=0A=
=0A=
> The other problem is that with two devices we need to be able to stitch =
=0A=
> them together in an automated fashion, eg via a systemd service or udev =
=0A=
> rule.=0A=
=0A=
Yes, and that has been on my to-do list forever for the current dm-zoned...=
=0A=
=0A=
> But for this we need to be able to identify the devices, which means =0A=
> both need to carry metadata, and both need to have unique identifier =0A=
> within the metadata. Which the current metadata doesn't allow to.=0A=
> =0A=
> Hence my plan is to implement a v2 metadata, carrying UUIDs for the dmz =
=0A=
> set _and_ the component device. With that we can update blkid to create =
=0A=
> links etc so that the devices can be identified in the system.=0A=
> Additionally I would be updating dmzadm to write the new metadata.=0A=
=0A=
Yep. I think that is needed. And the metadata for the disk that does not st=
ore=0A=
the mapping tables and bitmaps can be read-only at run time, that is a supe=
r=0A=
block only holding identification/UUID.=0A=
=0A=
> And I will add a new command 'start' to dmzadm which will then create =0A=
> the device-mapper device _with the correct size_. It also has the =0A=
> benefit that we can create the device-mapper target with the UUID =0A=
> specified in the metadata, so the persistent device links will be =0A=
> created automatically.=0A=
=0A=
The size now should be correct with single device current setup.=0A=
=0A=
> =0A=
> Bob, can you send me your improvements to dmzadm so that I can include =
=0A=
> them in my changes?=0A=
> =0A=
> Cheers,=0A=
> =0A=
> Hannes=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
