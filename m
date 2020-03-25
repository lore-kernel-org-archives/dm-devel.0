From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [RFC PATCH v2 3/3] dm zoned: add regular device info to metadata
Date: Wed, 25 Mar 2020 10:02:13 +0000
Message-ID: <CO2PR04MB2343054E74EEDFC330FD98DAE7CE0@CO2PR04MB2343.namprd04.prod.outlook.com>
References: <20200324110255.8385-1-bob.liu@oracle.com>
 <20200324110255.8385-4-bob.liu@oracle.com>
 <CO2PR04MB23438E0AB35CC46732F96085E7CE0@CO2PR04MB2343.namprd04.prod.outlook.com>
 <812da9e9-cfd2-ea24-60cb-4af48f476079@suse.de>
 <CO2PR04MB23439B5FA88275A80D3449DFE7CE0@CO2PR04MB2343.namprd04.prod.outlook.com>
 <0bd2daa1-abbf-681d-405c-f7e4aecd577c@suse.de>
 <CO2PR04MB23433CAD26D492654041FCDCE7CE0@CO2PR04MB2343.namprd04.prod.outlook.com>
 <cdf003a6-b0c8-30c0-edc3-049471a7a2b0@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Bob Liu <bob.liu@oracle.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
List-Id: dm-devel.ids

On 2020/03/25 19:00, Hannes Reinecke wrote:=0A=
> On 3/25/20 10:10 AM, Damien Le Moal wrote:=0A=
>> On 2020/03/25 17:52, Hannes Reinecke wrote:=0A=
>>> On 3/25/20 9:02 AM, Damien Le Moal wrote:=0A=
>>>> On 2020/03/25 15:47, Hannes Reinecke wrote:=0A=
>>>>> On 3/25/20 7:29 AM, Damien Le Moal wrote:=0A=
>>>>>> On 2020/03/24 20:04, Bob Liu wrote:=0A=
>>>>>>> This patch implemented metadata support for regular device by:=0A=
>>>>>>>     - Emulated zone information for regular device.=0A=
>>>>>>>     - Store metadata at the beginning of regular device.=0A=
>>>>>>>=0A=
>>>>>>>         | --- zoned device --- | -- regular device ||=0A=
>>>>>>>         ^                      ^=0A=
>>>>>>>         |                      |Metadata=0A=
>>>>>>> zone 0=0A=
>>>>>>>=0A=
>>>>>>> Signed-off-by: Bob Liu <bob.liu@oracle.com>=0A=
>>>>>>> ---=0A=
>>>>>>>     drivers/md/dm-zoned-metadata.c | 135 ++++++++++++++++++++++++++=
+++++----------=0A=
>>>>>>>     drivers/md/dm-zoned-target.c   |   6 +-=0A=
>>>>>>>     drivers/md/dm-zoned.h          |   3 +-=0A=
>>>>>>>     3 files changed, 108 insertions(+), 36 deletions(-)=0A=
>>>>>>>=0A=
>>>>> Having thought about it some more, I think we cannot continue with th=
is=0A=
>>>>> 'simple' approach.=0A=
>>>>> The immediate problem is that we lie about the disk size; clearly the=
=0A=
>>>>> metadata cannot be used for regular data, yet we expose a target devi=
ce=0A=
>>>>> with the full size of the underlying device.=0A=
>>>>> Making me wonder if anybody ever tested a disk-full scenario...=0A=
>>>>=0A=
>>>> Current dm-zoned does not do that... What is exposed as target capacit=
y is=0A=
>>>> number of chunks * zone size, with the number of chunks being number o=
f zones=0A=
>>>> minus metadata zones minus number of zones reserved for reclaim. And I=
 did test=0A=
>>>> disk full scenario (when performance goes to the trash bin because rec=
laim=0A=
>>>> struggles...)=0A=
>>>>=0A=
>>> Thing is, the second number for the dmsetup target line is _supposed_ t=
o=0A=
>>> be the target size.=0A=
>>> Which clearly is wrong here.=0A=
>>> I must admit I'm not sure what device-mapper will do with a target=0A=
>>> definition which is larger than the resulting target device ...=0A=
>>> Mike should know, but it's definitely awkward.=0A=
>>=0A=
>> AHh. OK. Never thought of it like this, especially considering the fact =
that the=0A=
>> table entry is checked to see if the entire drive is given. So instead o=
f the=0A=
>> target size, I was in fact using the size parameter of dmsetup as the si=
ze to=0A=
>> use on the backend, which for dm-zoned must be the device capacity...=0A=
>>=0A=
>> Not sure if we can fix that now ? Especially considering that the number=
 of=0A=
>> reserved seq zones for reclaim is not constant but a dmzadm format optio=
n. So=0A=
>> the average user would have to know exactly the useable size to dmsetup =
the=0A=
>> target. Akward too, or rather, not super easy to use. I wonder how dm-th=
in or=0A=
>> other targets with metadata handle this ? Do they format themselves=0A=
>> automatically on dmsetup using the size specified ?=0A=
>>=0A=
> Which is _precisely_ why I want to have the 'start' option to dmzadm.=0A=
> That can read the metadata, validate it, and then generate the correct =
=0A=
> invocation for device-mapper.=0A=
> _And_ we get a device-uuid to boot, as this can only be set from the ioct=
l.=0A=
=0A=
OK. Got it. Done like this, it will also be easy to support the v1 metadata=
.=0A=
=0A=
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
