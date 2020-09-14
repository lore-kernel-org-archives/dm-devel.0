From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/3] block: fix blk_rq_get_max_sectors() to flow more
 carefully
Date: Mon, 14 Sep 2020 10:52:09 -0400
Message-ID: <20200914145209.GB14410@redhat.com>
References: <20200911215338.44805-1-snitzer@redhat.com>
 <20200911215338.44805-2-snitzer@redhat.com>
 <20200912135252.GA210077@T590>
 <CY4PR04MB3751DAB758BAF8EB8A792FD2E7230@CY4PR04MB3751.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CY4PR04MB3751DAB758BAF8EB8A792FD2E7230@CY4PR04MB3751.namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: Ming Lei <ming.lei@redhat.com>, Vijayendra Suman <vijayendra.suman@oracle.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: dm-devel.ids

On Sun, Sep 13 2020 at  8:43pm -0400,
Damien Le Moal <Damien.LeMoal@wdc.com> wrote:

> On 2020/09/12 22:53, Ming Lei wrote:
> > On Fri, Sep 11, 2020 at 05:53:36PM -0400, Mike Snitzer wrote:
> >> blk_queue_get_max_sectors() has been trained for REQ_OP_WRITE_SAME and
> >> REQ_OP_WRITE_ZEROES yet blk_rq_get_max_sectors() didn't call it for
> >> those operations.
> > 
> > Actually WRITE_SAME & WRITE_ZEROS are handled by the following if
> > chunk_sectors is set:
> > 
> >         return min(blk_max_size_offset(q, offset),
> >                         blk_queue_get_max_sectors(q, req_op(rq)));
> >  
> >> Also, there is no need to avoid blk_max_size_offset() if
> >> 'chunk_sectors' isn't set because it falls back to 'max_sectors'.
> >>
> >> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> >> ---
> >>  include/linux/blkdev.h | 19 +++++++++++++------
> >>  1 file changed, 13 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> >> index bb5636cc17b9..453a3d735d66 100644
> >> --- a/include/linux/blkdev.h
> >> +++ b/include/linux/blkdev.h
> >> @@ -1070,17 +1070,24 @@ static inline unsigned int blk_rq_get_max_sectors(struct request *rq,
> >>  						  sector_t offset)
> >>  {
> >>  	struct request_queue *q = rq->q;
> >> +	int op;
> >> +	unsigned int max_sectors;
> >>  
> >>  	if (blk_rq_is_passthrough(rq))
> >>  		return q->limits.max_hw_sectors;
> >>  
> >> -	if (!q->limits.chunk_sectors ||
> >> -	    req_op(rq) == REQ_OP_DISCARD ||
> >> -	    req_op(rq) == REQ_OP_SECURE_ERASE)
> >> -		return blk_queue_get_max_sectors(q, req_op(rq));
> >> +	op = req_op(rq);
> >> +	max_sectors = blk_queue_get_max_sectors(q, op);
> >>  
> >> -	return min(blk_max_size_offset(q, offset),
> >> -			blk_queue_get_max_sectors(q, req_op(rq)));
> >> +	switch (op) {
> >> +	case REQ_OP_DISCARD:
> >> +	case REQ_OP_SECURE_ERASE:
> >> +	case REQ_OP_WRITE_SAME:
> >> +	case REQ_OP_WRITE_ZEROES:
> >> +		return max_sectors;
> >> +	}>> +
> >> +	return min(blk_max_size_offset(q, offset), max_sectors);
> >>  }
> > 
> > It depends if offset & chunk_sectors limit for WRITE_SAME & WRITE_ZEROS
> > needs to be considered.
> 
> That limit is needed for zoned block devices to ensure that *any* write request,
> no matter the command, do not cross zone boundaries. Otherwise, the write would
> be immediately failed by the device.

Thanks for the additional context, sorry to make you so concerned! ;)

Mike
