From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/3] block: fix blk_rq_get_max_sectors() to
 flow more carefully
Date: Mon, 14 Sep 2020 10:49:28 -0400
Message-ID: <20200914144928.GA14410@redhat.com>
References: <20200911215338.44805-1-snitzer@redhat.com>
	<20200911215338.44805-2-snitzer@redhat.com>
	<20200912135252.GA210077@T590>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200912135252.GA210077@T590>
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
To: Ming Lei <ming.lei@redhat.com>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, Vijayendra Suman <vijayendra.suman@oracle.com>
List-Id: dm-devel.ids

On Sat, Sep 12 2020 at  9:52am -0400,
Ming Lei <ming.lei@redhat.com> wrote:

> On Fri, Sep 11, 2020 at 05:53:36PM -0400, Mike Snitzer wrote:
> > blk_queue_get_max_sectors() has been trained for REQ_OP_WRITE_SAME and
> > REQ_OP_WRITE_ZEROES yet blk_rq_get_max_sectors() didn't call it for
> > those operations.
> 
> Actually WRITE_SAME & WRITE_ZEROS are handled by the following if
> chunk_sectors is set:
> 
>         return min(blk_max_size_offset(q, offset),
>                         blk_queue_get_max_sectors(q, req_op(rq)));

Yes, but blk_rq_get_max_sectors() is a bit of a mess structurally.  he
duality of imposing chunk_sectors and/or considering offset when
calculating the return is very confused.

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
> > +
> > +	return min(blk_max_size_offset(q, offset), max_sectors);
> >  }
> 
> It depends if offset & chunk_sectors limit for WRITE_SAME & WRITE_ZEROS
> needs to be considered.

Yes, I see that now.  But why don't they need to be considered for
REQ_OP_DISCARD and REQ_OP_SECURE_ERASE?  Is it because the intent of the
block core is to offer late splitting of bios?  If so, then why impose
chunk_sectors so early?

Obviously this patch 1/3 should be dropped.  I didn't treat
chunk_sectors with proper priority.

But like I said above, blk_rq_get_max_sectors() vs blk_max_size_offset()
is not at all straight-forward.  And the code looks prone to imposing
limits that shouldn't be (or vice-versa).

Also, when falling back to max_sectors, why not consider offset to treat
max_sectors like a granularity?  Would allow for much more consistent IO
patterns.

Mike
