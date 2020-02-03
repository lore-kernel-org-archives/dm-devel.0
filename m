From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [RFC PATCH] dm-zoned: extend the way of exposing zoned block
 device
Date: Mon, 3 Feb 2020 15:06:16 +0000
Message-ID: <BYAPR04MB5816B2967735225FB37D627BE7000@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20200108071212.27230-1-Nobody@nobody.com>
 <BYAPR04MB5816BA749332D2FC6CE3993AE73E0@BYAPR04MB5816.namprd04.prod.outlook.com>
 <c4ba178c-f5cf-4dd1-784b-e372d6b09f62@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Bob Liu <bob.liu@oracle.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

On 2020/02/03 21:47, Bob Liu wrote:=0A=
> On 1/8/20 3:40 PM, Damien Le Moal wrote:=0A=
>> On 2020/01/08 16:13, Nobody wrote:=0A=
>>> From: Bob Liu <bob.liu@oracle.com>=0A=
>>>=0A=
>>> Motivation:=0A=
>>> Now the dm-zoned device mapper target exposes a zoned block device(ZBC)=
 as a=0A=
>>> regular block device by storing metadata and buffering random writes in=
=0A=
>>> conventional zones.=0A=
>>> This way is not very flexible, there must be enough conventional zones =
and the=0A=
>>> performance may be constrained.=0A=
>>> By putting metadata(also buffering random writes) in separated device w=
e can get=0A=
>>> more flexibility and potential performance improvement e.g by storing m=
etadata=0A=
>>> in faster device like persistent memory.=0A=
>>>=0A=
>>> This patch try to split the metadata of dm-zoned to an extra block=0A=
>>> device instead of zoned block device itself.=0A=
>>> (Buffering random writes also in the todo list.)=0A=
>>>=0A=
>>> Patch is at the very early stage, just want to receive some feedback ab=
out=0A=
>>> this extension.=0A=
>>> Another option is to create an new md-zoned device with separated metad=
ata=0A=
>>> device based on md framework.=0A=
>>=0A=
>> For metadata only, it should not be hard at all to move to another=0A=
>> conventional zone device. It will however be a little more tricky for=0A=
>> conventional zones used for data since dm-zoned assumes that this random=
=0A=
>> write space is also zoned. Moving this space to a conventional device=0A=
>> requires implementing a zone emulation (fake zones) for the regular=0A=
>> drive, using a zone size that matches the size of sequential zones.=0A=
>>=0A=
>> Beyond this, dm-zoned also needs to be changed to accept partial drives=
=0A=
>> and the dm core code to accept mixing of regular and zoned disks (that=
=0A=
>> is forbidden now).=0A=
>>=0A=
>> Another approach worth exploring is stacking dm-zoned as is on top of a=
=0A=
>> modified dm-linear with the ability to emulate conventional zones on top=
=0A=
>> of a regular block device (you only need report zones method=0A=
>> implemented). =0A=
> =0A=
> Looks like the only way to do this emulation is in user space tool(dm-zon=
ed-tools).=0A=
> Write metadata(which contains emulated zone information constructed by dm=
-zoned-tools)=0A=
> into regular block device.=0A=
=0A=
User space tool will indeed need some modifications to allow the new=0A=
format. But I would not put this as "doing the emulation" since at that=0A=
level, zones are only an information checked for alignment of metadata=0A=
space and overall capacity of the target. With a regular disk holding the=
=0A=
metadata, all that needs to be done is assume that this drive is ion fact=
=0A=
composed solely of conventional zones with the same size as the larger SRM=
=0A=
disk backend. The total set of zones "assumed" + "real zones from SMR"=0A=
consitute the set of zones that dmzadm will work with for determining the=
=0A=
overall format, while currently it only uses the set of real zones.=0A=
=0A=
> It's impossible to add code to every regular block device for emulating c=
onventional zones. =0A=
=0A=
There is no need to do that. dm-zoned can emulate fake conventional zones=
=0A=
for the regular device (disk or ssd) holding the metadata. Since=0A=
conventional zones do not have any IO restriction nor do they need any zone=
=0A=
management command (no zone reset), dm-zoned only needs to create a set of=
=0A=
struct dm_zone for the emulated zones of the regular disk and "manually"=0A=
fill the zone information. This initialization is done in dmz_init_zones().=
=0A=
Some changes there to create these struct dm_zone and all the remaining=0A=
metadata and write buffering code should not need any change at all (modulo=
=0A=
the different bdev reference). Do you see the idea ?=0A=
=0A=
The only place that will need some care is sync processing as 2 devices=0A=
will need to be issued flushes instead of one. The reference to the=0A=
different bdev depending on the zone being accessed will need some care in=
=0A=
many places too, including reclaim. But dm-kcopy being used there, this=0A=
should be fairly easy.=0A=
=0A=
Adding a bdevid (an index) field to struct dm_zone, together with an array=
=0A=
of bdev pointers in struct dmz_dev, should do the trick to simplify=0A=
zone-to-bdev or block-to-bdev conversions (helper functions needed for that=
).=0A=
=0A=
Thoughts ?=0A=
=0A=
> =0A=
> Thanks,=0A=
> Bob=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
