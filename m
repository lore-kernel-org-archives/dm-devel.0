From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 1/3] block: fix blk_rq_get_max_sectors() to
 flow more carefully
Date: Tue, 15 Sep 2020 16:01:54 +0800
Message-ID: <20200915080154.GB761522@T590>
References: <20200911215338.44805-1-snitzer@redhat.com>
	<20200911215338.44805-2-snitzer@redhat.com>
	<CY4PR04MB375160D4EFBA9BE0957AC7EDE7230@CY4PR04MB3751.namprd04.prod.outlook.com>
	<20200914150352.GC14410@redhat.com>
	<CY4PR04MB37510A739D28F993250E2B66E7200@CY4PR04MB3751.namprd04.prod.outlook.com>
	<CY4PR04MB3751822DB93B9E155A0BE462E7200@CY4PR04MB3751.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CY4PR04MB3751822DB93B9E155A0BE462E7200@CY4PR04MB3751.namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Vijayendra Suman <vijayendra.suman@oracle.com>
List-Id: dm-devel.ids

On Tue, Sep 15, 2020 at 04:21:54AM +0000, Damien Le Moal wrote:
> On 2020/09/15 10:10, Damien Le Moal wrote:
> > On 2020/09/15 0:04, Mike Snitzer wrote:
> >> On Sun, Sep 13 2020 at  8:46pm -0400,
> >> Damien Le Moal <Damien.LeMoal@wdc.com> wrote:
> >>
> >>> On 2020/09/12 6:53, Mike Snitzer wrote:
> >>>> blk_queue_get_max_sectors() has been trained for REQ_OP_WRITE_SAME and
> >>>> REQ_OP_WRITE_ZEROES yet blk_rq_get_max_sectors() didn't call it for
> >>>> those operations.
> >>>>
> >>>> Also, there is no need to avoid blk_max_size_offset() if
> >>>> 'chunk_sectors' isn't set because it falls back to 'max_sectors'.
> >>>>
> >>>> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> >>>> ---
> >>>>  include/linux/blkdev.h | 19 +++++++++++++------
> >>>>  1 file changed, 13 insertions(+), 6 deletions(-)
> >>>>
> >>>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> >>>> index bb5636cc17b9..453a3d735d66 100644
> >>>> --- a/include/linux/blkdev.h
> >>>> +++ b/include/linux/blkdev.h
> >>>> @@ -1070,17 +1070,24 @@ static inline unsigned int blk_rq_get_max_sectors(struct request *rq,
> >>>>  						  sector_t offset)
> >>>>  {
> >>>>  	struct request_queue *q = rq->q;
> >>>> +	int op;
> >>>> +	unsigned int max_sectors;
> >>>>  
> >>>>  	if (blk_rq_is_passthrough(rq))
> >>>>  		return q->limits.max_hw_sectors;
> >>>>  
> >>>> -	if (!q->limits.chunk_sectors ||
> >>>> -	    req_op(rq) == REQ_OP_DISCARD ||
> >>>> -	    req_op(rq) == REQ_OP_SECURE_ERASE)
> >>>> -		return blk_queue_get_max_sectors(q, req_op(rq));
> >>>> +	op = req_op(rq);
> >>>> +	max_sectors = blk_queue_get_max_sectors(q, op);
> >>>>  
> >>>> -	return min(blk_max_size_offset(q, offset),
> >>>> -			blk_queue_get_max_sectors(q, req_op(rq)));
> >>>> +	switch (op) {
> >>>> +	case REQ_OP_DISCARD:
> >>>> +	case REQ_OP_SECURE_ERASE:
> >>>> +	case REQ_OP_WRITE_SAME:
> >>>> +	case REQ_OP_WRITE_ZEROES:
> >>>> +		return max_sectors;
> >>>> +	}
> >>>
> >>> Doesn't this break md devices ? (I think does use chunk_sectors for stride size,
> >>> no ?)
> >>>
> >>> As mentioned in my reply to Ming's email, this will allow these commands to
> >>> potentially cross over zone boundaries on zoned block devices, which would be an
> >>> immediate command failure.
> >>
> >> Depending on the implementation it is beneficial to get a large
> >> discard (one not constrained by chunk_sectors, e.g. dm-stripe.c's
> >> optimization for handling large discards and issuing N discards, one per
> >> stripe).  Same could apply for other commands.
> >>
> >> Like all devices, zoned devices should impose command specific limits in
> >> the queue_limits (and not lean on chunk_sectors to do a
> >> one-size-fits-all).
> > 
> > Yes, understood. But I think that  in the case of md, chunk_sectors is used to
> > indicate the boundary between drives for a raid volume. So it does indeed make
> > sense to limit the IO size on submission since otherwise, the md driver itself
> > would have to split that bio again anyway.
> > 
> >> But that aside, yes I agree I didn't pay close enough attention to the
> >> implications of deferring the splitting of these commands until they
> >> were issued to underlying storage.  This chunk_sectors early splitting
> >> override is a bit of a mess... not quite following the logic given we
> >> were supposed to be waiting to split bios as late as possible.
> > 
> > My view is that the multipage bvec (BIOs almost as large as we want) and late
> > splitting is beneficial to get larger effective BIO sent to the device as having
> > more pages on hand allows bigger segments in the bio instead of always having at
> > most PAGE_SIZE per segment. The effect of this is very visible with blktrace. A
> > lot of requests end up being much larger than the device max_segments * page_size.
> > 
> > However, if there is already a known limit on the BIO size when the BIO is being
> > built, it does not make much sense to try to grow a bio beyond that limit since
> > it will have to be split by the driver anyway. chunk_sectors is one such limit
> > used for md (I think) to indicate boundaries between drives of a raid volume.
> > And we reuse it (abuse it ?) for zoned block devices to ensure that any command
> > does not cross over zone boundaries since that triggers errors for writes within
> > sequential zones or read/write crossing over zones of different types
> > (conventional->sequential zone boundary).
> > 
> > I may not have the entire picture correctly here, but so far, this is my
> > understanding.
> 
> And I was wrong :) In light of Ming's comment + a little code refresher reading,
> indeed, chunk_sectors will split BIOs so that *requests* do not exceed that
> limit, but the initial BIO submission may be much larger regardless of
> chunk_sectors.
> 
> Ming, I think the point here is that building a large BIO first and splitting it
> later (as opposed to limiting the bio size by stopping bio_add_page()) is more
> efficient as there is only one bio submit instead of many, right ?

Yeah, this way allows generic_make_request(submit_bio_noacct) to handle arbitrarily
sized bios, so bio_add_page() becomes more efficiently and simplified a lot, and
stacking driver is simplified too, such as the original q->merge_bvec_fn() is killed.

On the other hand, the cost of bio splitting is added.

Especially for stacking driver, there may be two times of bio splitting,
one is in stacking driver, another is in underlying device driver.

Fortunately underlying queue's limits are propagated to stacking queue, so in theory
the bio splitting in stacking driver's ->submit_bio is enough most of times.



Thanks,
Ming
