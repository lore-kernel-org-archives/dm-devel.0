From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/3] block: fix blk_rq_get_max_sectors() to
 flow more carefully
Date: Mon, 14 Sep 2020 11:03:52 -0400
Message-ID: <20200914150352.GC14410@redhat.com>
References: <20200911215338.44805-1-snitzer@redhat.com>
	<20200911215338.44805-2-snitzer@redhat.com>
	<CY4PR04MB375160D4EFBA9BE0957AC7EDE7230@CY4PR04MB3751.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CY4PR04MB375160D4EFBA9BE0957AC7EDE7230@CY4PR04MB3751.namprd04.prod.outlook.com>
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
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Vijayendra Suman <vijayendra.suman@oracle.com>, Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

On Sun, Sep 13 2020 at  8:46pm -0400,
Damien Le Moal <Damien.LeMoal@wdc.com> wrote:

> On 2020/09/12 6:53, Mike Snitzer wrote:
> > blk_queue_get_max_sectors() has been trained for REQ_OP_WRITE_SAME and
> > REQ_OP_WRITE_ZEROES yet blk_rq_get_max_sectors() didn't call it for
> > those operations.
> > 
> > Also, there is no need to avoid blk_max_size_offset() if
> > 'chunk_sectors' isn't set because it falls back to 'max_sectors'.
> > 
> > Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> > ---
> >  include/linux/blkdev.h | 19 +++++++++++++------
> >  1 file changed, 13 insertions(+), 6 deletions(-)
> > 
> > diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> > index bb5636cc17b9..453a3d735d66 100644
> > --- a/include/linux/blkdev.h
> > +++ b/include/linux/blkdev.h
> > @@ -1070,17 +1070,24 @@ static inline unsigned int blk_rq_get_max_sectors(struct request *rq,
> >  						  sector_t offset)
> >  {
> >  	struct request_queue *q = rq->q;
> > +	int op;
> > +	unsigned int max_sectors;
> >  
> >  	if (blk_rq_is_passthrough(rq))
> >  		return q->limits.max_hw_sectors;
> >  
> > -	if (!q->limits.chunk_sectors ||
> > -	    req_op(rq) == REQ_OP_DISCARD ||
> > -	    req_op(rq) == REQ_OP_SECURE_ERASE)
> > -		return blk_queue_get_max_sectors(q, req_op(rq));
> > +	op = req_op(rq);
> > +	max_sectors = blk_queue_get_max_sectors(q, op);
> >  
> > -	return min(blk_max_size_offset(q, offset),
> > -			blk_queue_get_max_sectors(q, req_op(rq)));
> > +	switch (op) {
> > +	case REQ_OP_DISCARD:
> > +	case REQ_OP_SECURE_ERASE:
> > +	case REQ_OP_WRITE_SAME:
> > +	case REQ_OP_WRITE_ZEROES:
> > +		return max_sectors;
> > +	}
> 
> Doesn't this break md devices ? (I think does use chunk_sectors for stride size,
> no ?)
> 
> As mentioned in my reply to Ming's email, this will allow these commands to
> potentially cross over zone boundaries on zoned block devices, which would be an
> immediate command failure.

Depending on the implementation it is beneficial to get a large
discard (one not constrained by chunk_sectors, e.g. dm-stripe.c's
optimization for handling large discards and issuing N discards, one per
stripe).  Same could apply for other commands.

Like all devices, zoned devices should impose command specific limits in
the queue_limits (and not lean on chunk_sectors to do a
one-size-fits-all).

But that aside, yes I agree I didn't pay close enough attention to the
implications of deferring the splitting of these commands until they
were issued to underlying storage.  This chunk_sectors early splitting
override is a bit of a mess... not quite following the logic given we
were supposed to be waiting to split bios as late as possible.

Mike
