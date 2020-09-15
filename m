From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 1/3] block: fix blk_rq_get_max_sectors() to flow more
 carefully
Date: Tue, 15 Sep 2020 02:15:23 +0000
Message-ID: <CY4PR04MB3751C73F80061266BEFA458DE7200@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200911215338.44805-1-snitzer@redhat.com>
 <20200911215338.44805-2-snitzer@redhat.com> <20200912135252.GA210077@T590>
 <CY4PR04MB3751DAB758BAF8EB8A792FD2E7230@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200915020344.GB738570@T590>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Vijayendra Suman <vijayendra.suman@oracle.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: dm-devel.ids

On 2020/09/15 11:04, Ming Lei wrote:=0A=
> On Mon, Sep 14, 2020 at 12:43:06AM +0000, Damien Le Moal wrote:=0A=
>> On 2020/09/12 22:53, Ming Lei wrote:=0A=
>>> On Fri, Sep 11, 2020 at 05:53:36PM -0400, Mike Snitzer wrote:=0A=
>>>> blk_queue_get_max_sectors() has been trained for REQ_OP_WRITE_SAME and=
=0A=
>>>> REQ_OP_WRITE_ZEROES yet blk_rq_get_max_sectors() didn't call it for=0A=
>>>> those operations.=0A=
>>>=0A=
>>> Actually WRITE_SAME & WRITE_ZEROS are handled by the following if=0A=
>>> chunk_sectors is set:=0A=
>>>=0A=
>>>         return min(blk_max_size_offset(q, offset),=0A=
>>>                         blk_queue_get_max_sectors(q, req_op(rq)));=0A=
>>>  =0A=
>>>> Also, there is no need to avoid blk_max_size_offset() if=0A=
>>>> 'chunk_sectors' isn't set because it falls back to 'max_sectors'.=0A=
>>>>=0A=
>>>> Signed-off-by: Mike Snitzer <snitzer@redhat.com>=0A=
>>>> ---=0A=
>>>>  include/linux/blkdev.h | 19 +++++++++++++------=0A=
>>>>  1 file changed, 13 insertions(+), 6 deletions(-)=0A=
>>>>=0A=
>>>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h=0A=
>>>> index bb5636cc17b9..453a3d735d66 100644=0A=
>>>> --- a/include/linux/blkdev.h=0A=
>>>> +++ b/include/linux/blkdev.h=0A=
>>>> @@ -1070,17 +1070,24 @@ static inline unsigned int blk_rq_get_max_sect=
ors(struct request *rq,=0A=
>>>>  						  sector_t offset)=0A=
>>>>  {=0A=
>>>>  	struct request_queue *q =3D rq->q;=0A=
>>>> +	int op;=0A=
>>>> +	unsigned int max_sectors;=0A=
>>>>  =0A=
>>>>  	if (blk_rq_is_passthrough(rq))=0A=
>>>>  		return q->limits.max_hw_sectors;=0A=
>>>>  =0A=
>>>> -	if (!q->limits.chunk_sectors ||=0A=
>>>> -	    req_op(rq) =3D=3D REQ_OP_DISCARD ||=0A=
>>>> -	    req_op(rq) =3D=3D REQ_OP_SECURE_ERASE)=0A=
>>>> -		return blk_queue_get_max_sectors(q, req_op(rq));=0A=
>>>> +	op =3D req_op(rq);=0A=
>>>> +	max_sectors =3D blk_queue_get_max_sectors(q, op);=0A=
>>>>  =0A=
>>>> -	return min(blk_max_size_offset(q, offset),=0A=
>>>> -			blk_queue_get_max_sectors(q, req_op(rq)));=0A=
>>>> +	switch (op) {=0A=
>>>> +	case REQ_OP_DISCARD:=0A=
>>>> +	case REQ_OP_SECURE_ERASE:=0A=
>>>> +	case REQ_OP_WRITE_SAME:=0A=
>>>> +	case REQ_OP_WRITE_ZEROES:=0A=
>>>> +		return max_sectors;=0A=
>>>> +	}>> +=0A=
>>>> +	return min(blk_max_size_offset(q, offset), max_sectors);=0A=
>>>>  }=0A=
>>>=0A=
>>> It depends if offset & chunk_sectors limit for WRITE_SAME & WRITE_ZEROS=
=0A=
>>> needs to be considered.=0A=
>>=0A=
>> That limit is needed for zoned block devices to ensure that *any* write =
request,=0A=
>> no matter the command, do not cross zone boundaries. Otherwise, the writ=
e would=0A=
>> be immediately failed by the device.=0A=
> =0A=
> Looks both blk_bio_write_zeroes_split() and blk_bio_write_same_split()=0A=
> don't consider chunk_sectors limit, is that an issue for zone block?=0A=
=0A=
Hu... Never looked at these. Yes, it will be a problem. write zeroes for NV=
Me=0A=
ZNS drives and write same for SCSI/ZBC drives. So yes, definitely something=
=0A=
that needs to be fixed. User of these will be file systems that in the case=
 of=0A=
zoned block devices would be FS with zone support. f2fs does not use these=
=0A=
commands, and btrfs (posted recently) needs to be checked. But the FS itsel=
f=0A=
being zone aware, the requests will be zone aligned.=0A=
=0A=
But definitely worth fixing.=0A=
=0A=
Thanks !=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
