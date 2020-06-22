From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [RFC PATCH 2/2] dm: don't try to split REQ_OP_ZONE_APPEND bios
Date: Mon, 22 Jun 2020 00:27:34 +0000
Message-ID: <CY4PR04MB37514F8CCE7918A7C13FCA82E7970@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200619065905.22228-1-johannes.thumshirn@wdc.com>
 <20200619065905.22228-3-johannes.thumshirn@wdc.com>
 <CY4PR04MB37514CDC42E7F545244D66C6E7980@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200619162658.GB24642@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Naohiro Aota <Naohiro.Aota@wdc.com>
List-Id: dm-devel.ids

On 2020/06/20 1:27, Mike Snitzer wrote:=0A=
> On Fri, Jun 19 2020 at  3:54am -0400,=0A=
> Damien Le Moal <Damien.LeMoal@wdc.com> wrote:=0A=
> =0A=
>> On 2020/06/19 15:59, Johannes Thumshirn wrote:=0A=
>>> REQ_OP_ZONE_APPEND bios cannot be split so return EIO if we can't fit i=
t=0A=
>>> into one IO.=0A=
>>>=0A=
>>> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
>>> ---=0A=
>>>  drivers/md/dm.c | 3 +++=0A=
>>>  1 file changed, 3 insertions(+)=0A=
>>>=0A=
>>> diff --git a/drivers/md/dm.c b/drivers/md/dm.c=0A=
>>> index 058c34abe9d1..c720a7e3269a 100644=0A=
>>> --- a/drivers/md/dm.c=0A=
>>> +++ b/drivers/md/dm.c=0A=
>>> @@ -1609,6 +1609,9 @@ static int __split_and_process_non_flush(struct c=
lone_info *ci)=0A=
>>>  =0A=
>>>  	len =3D min_t(sector_t, max_io_len(ci->sector, ti), ci->sector_count)=
;=0A=
>>>  =0A=
>>> +	if (bio_op(ci->bio) =3D=3D REQ_OP_ZONE_APPEND && len < ci->sector_cou=
nt)=0A=
>>> +		return -EIO;=0A=
>>> +=0A=
>>>  	r =3D __clone_and_map_data_bio(ci, ti, ci->sector, &len);=0A=
>>>  	if (r < 0)=0A=
>>>  		return r;=0A=
>>>=0A=
>>=0A=
>> I think this is OK. The stacked max_zone_append_sectors limit should hav=
e=0A=
>> prevented that to happen  in the first place I think, but better safe th=
an sorry.=0A=
>>=0A=
>> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
> =0A=
> If stacked max_zone_append_sectors limit should prevent it then I'd=0A=
> rather not sprinkle more zoned specific checks in DM core.=0A=
=0A=
Mike,=0A=
=0A=
Just to be extra sure, I checked this again. Since for zoned block devices =
the=0A=
mapping of a target must be zoned aligned and a zone append command is alwa=
ys=0A=
fully contained within a zone, we do not need this check. The stacked limit=
s and=0A=
submit_bio() code will fail a zone append command that is too large or that=
=0A=
spans zones before we get here.=0A=
=0A=
That is of course assuming that the target does not expose zones that are m=
apped=0A=
using multiple chunks from different devices. There is currently no target =
doing=0A=
that, so this is OK. We can safely drop this patch.=0A=
=0A=
Thanks.=0A=
=0A=
> =0A=
> Thanks,=0A=
> Mike=0A=
> =0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
