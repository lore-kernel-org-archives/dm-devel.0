From: Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH 3/3] block: allow 'chunk_sectors' to be non-power-of-2
Date: Sun, 13 Sep 2020 19:43:06 -0700
Message-ID: <20200914024306.GA3657769@dhcp-10-100-145-180.wdl.wdc.com>
References: <20200911215338.44805-1-snitzer@redhat.com>
 <20200911215338.44805-4-snitzer@redhat.com>
 <20200912140630.GC210077@T590>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200912140630.GC210077@T590>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Vijayendra Suman <vijayendra.suman@oracle.com>, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

On Sat, Sep 12, 2020 at 10:06:30PM +0800, Ming Lei wrote:
> On Fri, Sep 11, 2020 at 05:53:38PM -0400, Mike Snitzer wrote:
> > It is possible for a block device to use a non power-of-2 for chunk
> > size which results in a full-stripe size that is also a non
> > power-of-2.
> > 
> > Update blk_queue_chunk_sectors() and blk_max_size_offset() to
> > accommodate drivers that need a non power-of-2 chunk_sectors.
> > 
> > Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> > ---
> >  block/blk-settings.c   | 10 ++++------
> >  include/linux/blkdev.h | 12 +++++++++---
> >  2 files changed, 13 insertions(+), 9 deletions(-)
> > 
> > diff --git a/block/blk-settings.c b/block/blk-settings.c
> > index b09642d5f15e..e40a162cc946 100644
> > --- a/block/blk-settings.c
> > +++ b/block/blk-settings.c
> > @@ -172,15 +172,13 @@ EXPORT_SYMBOL(blk_queue_max_hw_sectors);
> >   *
> >   * Description:
> >   *    If a driver doesn't want IOs to cross a given chunk size, it can set
> > - *    this limit and prevent merging across chunks. Note that the chunk size
> > - *    must currently be a power-of-2 in sectors. Also note that the block
> > - *    layer must accept a page worth of data at any offset. So if the
> > - *    crossing of chunks is a hard limitation in the driver, it must still be
> > - *    prepared to split single page bios.
> > + *    this limit and prevent merging across chunks. Note that the block layer
> > + *    must accept a page worth of data at any offset. So if the crossing of
> > + *    chunks is a hard limitation in the driver, it must still be prepared
> > + *    to split single page bios.
> >   **/
> >  void blk_queue_chunk_sectors(struct request_queue *q, unsigned int chunk_sectors)
> >  {
> > -	BUG_ON(!is_power_of_2(chunk_sectors));
> >  	q->limits.chunk_sectors = chunk_sectors;
> >  }
> >  EXPORT_SYMBOL(blk_queue_chunk_sectors);
> > diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> > index 453a3d735d66..e72bcce22143 100644
> > --- a/include/linux/blkdev.h
> > +++ b/include/linux/blkdev.h
> > @@ -1059,11 +1059,17 @@ static inline unsigned int blk_queue_get_max_sectors(struct request_queue *q,
> >  static inline unsigned int blk_max_size_offset(struct request_queue *q,
> >  					       sector_t offset)
> >  {
> > -	if (!q->limits.chunk_sectors)
> > +	unsigned int chunk_sectors = q->limits.chunk_sectors;
> > +
> > +	if (!chunk_sectors)
> >  		return q->limits.max_sectors;
> >  
> > -	return min(q->limits.max_sectors, (unsigned int)(q->limits.chunk_sectors -
> > -			(offset & (q->limits.chunk_sectors - 1))));
> > +	if (is_power_of_2(chunk_sectors))
> > +		chunk_sectors -= (offset & (chunk_sectors - 1));
> > +	else
> > +		chunk_sectors -= sector_div(offset, chunk_sectors);
> > +
> > +	return min(q->limits.max_sectors, chunk_sectors);
> >  }
> >  
> >  static inline unsigned int blk_rq_get_max_sectors(struct request *rq,
> > -- 
> > 2.15.0
> > 
> 
> is_power_of_2() is cheap enough for fast path, so looks fine to support
> non-power-of-2 chunk sectors.
> 
> Maybe NVMe PCI can remove the power_of_2() limit too.

I'd need to see the justification for that. The boundary is just a
suggestion in NVMe. The majority of IO never crosses it so the
calculation is usually wasted CPU cycles. Crossing the boundary is going
to have to be very costly on the device side in order to justify the
host side per-IO overhead for a non-power-of-2 split. 
