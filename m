From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 1/3] block: fix blk_rq_get_max_sectors() to flow more
 carefully
Date: Tue, 15 Sep 2020 01:09:55 +0000
Message-ID: <CY4PR04MB37510A739D28F993250E2B66E7200@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200911215338.44805-1-snitzer@redhat.com>
 <20200911215338.44805-2-snitzer@redhat.com>
 <CY4PR04MB375160D4EFBA9BE0957AC7EDE7230@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200914150352.GC14410@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Ming Lei <ming.lei@redhat.com>, Vijayendra Suman <vijayendra.suman@oracle.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: dm-devel.ids

On 2020/09/15 0:04, Mike Snitzer wrote:=0A=
> On Sun, Sep 13 2020 at  8:46pm -0400,=0A=
> Damien Le Moal <Damien.LeMoal@wdc.com> wrote:=0A=
> =0A=
>> On 2020/09/12 6:53, Mike Snitzer wrote:=0A=
>>> blk_queue_get_max_sectors() has been trained for REQ_OP_WRITE_SAME and=
=0A=
>>> REQ_OP_WRITE_ZEROES yet blk_rq_get_max_sectors() didn't call it for=0A=
>>> those operations.=0A=
>>>=0A=
>>> Also, there is no need to avoid blk_max_size_offset() if=0A=
>>> 'chunk_sectors' isn't set because it falls back to 'max_sectors'.=0A=
>>>=0A=
>>> Signed-off-by: Mike Snitzer <snitzer@redhat.com>=0A=
>>> ---=0A=
>>>  include/linux/blkdev.h | 19 +++++++++++++------=0A=
>>>  1 file changed, 13 insertions(+), 6 deletions(-)=0A=
>>>=0A=
>>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h=0A=
>>> index bb5636cc17b9..453a3d735d66 100644=0A=
>>> --- a/include/linux/blkdev.h=0A=
>>> +++ b/include/linux/blkdev.h=0A=
>>> @@ -1070,17 +1070,24 @@ static inline unsigned int blk_rq_get_max_secto=
rs(struct request *rq,=0A=
>>>  						  sector_t offset)=0A=
>>>  {=0A=
>>>  	struct request_queue *q =3D rq->q;=0A=
>>> +	int op;=0A=
>>> +	unsigned int max_sectors;=0A=
>>>  =0A=
>>>  	if (blk_rq_is_passthrough(rq))=0A=
>>>  		return q->limits.max_hw_sectors;=0A=
>>>  =0A=
>>> -	if (!q->limits.chunk_sectors ||=0A=
>>> -	    req_op(rq) =3D=3D REQ_OP_DISCARD ||=0A=
>>> -	    req_op(rq) =3D=3D REQ_OP_SECURE_ERASE)=0A=
>>> -		return blk_queue_get_max_sectors(q, req_op(rq));=0A=
>>> +	op =3D req_op(rq);=0A=
>>> +	max_sectors =3D blk_queue_get_max_sectors(q, op);=0A=
>>>  =0A=
>>> -	return min(blk_max_size_offset(q, offset),=0A=
>>> -			blk_queue_get_max_sectors(q, req_op(rq)));=0A=
>>> +	switch (op) {=0A=
>>> +	case REQ_OP_DISCARD:=0A=
>>> +	case REQ_OP_SECURE_ERASE:=0A=
>>> +	case REQ_OP_WRITE_SAME:=0A=
>>> +	case REQ_OP_WRITE_ZEROES:=0A=
>>> +		return max_sectors;=0A=
>>> +	}=0A=
>>=0A=
>> Doesn't this break md devices ? (I think does use chunk_sectors for stri=
de size,=0A=
>> no ?)=0A=
>>=0A=
>> As mentioned in my reply to Ming's email, this will allow these commands=
 to=0A=
>> potentially cross over zone boundaries on zoned block devices, which wou=
ld be an=0A=
>> immediate command failure.=0A=
> =0A=
> Depending on the implementation it is beneficial to get a large=0A=
> discard (one not constrained by chunk_sectors, e.g. dm-stripe.c's=0A=
> optimization for handling large discards and issuing N discards, one per=
=0A=
> stripe).  Same could apply for other commands.=0A=
> =0A=
> Like all devices, zoned devices should impose command specific limits in=
=0A=
> the queue_limits (and not lean on chunk_sectors to do a=0A=
> one-size-fits-all).=0A=
=0A=
Yes, understood. But I think that  in the case of md, chunk_sectors is used=
 to=0A=
indicate the boundary between drives for a raid volume. So it does indeed m=
ake=0A=
sense to limit the IO size on submission since otherwise, the md driver its=
elf=0A=
would have to split that bio again anyway.=0A=
=0A=
> But that aside, yes I agree I didn't pay close enough attention to the=0A=
> implications of deferring the splitting of these commands until they=0A=
> were issued to underlying storage.  This chunk_sectors early splitting=0A=
> override is a bit of a mess... not quite following the logic given we=0A=
> were supposed to be waiting to split bios as late as possible.=0A=
=0A=
My view is that the multipage bvec (BIOs almost as large as we want) and la=
te=0A=
splitting is beneficial to get larger effective BIO sent to the device as h=
aving=0A=
more pages on hand allows bigger segments in the bio instead of always havi=
ng at=0A=
most PAGE_SIZE per segment. The effect of this is very visible with blktrac=
e. A=0A=
lot of requests end up being much larger than the device max_segments * pag=
e_size.=0A=
=0A=
However, if there is already a known limit on the BIO size when the BIO is =
being=0A=
built, it does not make much sense to try to grow a bio beyond that limit s=
ince=0A=
it will have to be split by the driver anyway. chunk_sectors is one such li=
mit=0A=
used for md (I think) to indicate boundaries between drives of a raid volum=
e.=0A=
And we reuse it (abuse it ?) for zoned block devices to ensure that any com=
mand=0A=
does not cross over zone boundaries since that triggers errors for writes w=
ithin=0A=
sequential zones or read/write crossing over zones of different types=0A=
(conventional->sequential zone boundary).=0A=
=0A=
I may not have the entire picture correctly here, but so far, this is my=0A=
understanding.=0A=
=0A=
Cheers.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
