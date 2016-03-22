From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH 1/9] block: add block_device_operations methods to
 set and get reserved space
Date: Tue, 22 Mar 2016 08:05:49 -0400
Message-ID: <20160322120548.GA51718@bfoster.bfoster>
References: <1458225037-24155-1-git-send-email-bfoster@redhat.com>
 <1458225037-24155-2-git-send-email-bfoster@redhat.com>
 <20160321120829.GB25476@redhat.com>
 <20160321215333.GM11812@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160321215333.GM11812@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

Re-add dm-devel@redhat.com, linux-block@vger.kernel.org to CC.

On Tue, Mar 22, 2016 at 08:53:33AM +1100, Dave Chinner wrote:
> On Mon, Mar 21, 2016 at 01:08:29PM +0100, Carlos Maiolino wrote:
> > Hi,
> > 
> > Good news about this interface, I just have a small suggestion in this patch:
> > 
> > On Thu, Mar 17, 2016 at 10:30:29AM -0400, Brian Foster wrote:
> > > From: Mike Snitzer <snitzer@redhat.com>
> > > 
> > > Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> > > ---
> > >  fs/block_dev.c         | 20 ++++++++++++++++++++
> > >  include/linux/blkdev.h |  5 +++++
> > >  2 files changed, 25 insertions(+)
> > > 
> > > diff --git a/fs/block_dev.c b/fs/block_dev.c
> > > index 826b164..375a2e4 100644
> > > --- a/fs/block_dev.c
> > > +++ b/fs/block_dev.c
> > > @@ -497,6 +497,26 @@ long bdev_direct_access(struct block_device *bdev, struct blk_dax_ctl *dax)
> > >  }
> > >  EXPORT_SYMBOL_GPL(bdev_direct_access);
> > >  
> > > +int blk_reserve_space(struct block_device *bdev, sector_t nr_sects)
> > > +{
> > > +	const struct block_device_operations *ops = bdev->bd_disk->fops;
> > > +
> > > +	if (!ops->reserve_space)
> > > +		return -EOPNOTSUPP;
> > > +	return ops->reserve_space(bdev, nr_sects);
> > > +}
> > > +EXPORT_SYMBOL_GPL(blk_reserve_space);
> > 
> > Wouldn't be better to have this function name standardized accordingly to the
> > next one? Something like blk_set_reserved_space() maybe?
> 
> Personally I see no point in wrappers like this. We don't add
> wrappers for ops methods in any other layers of the stack,
> filesystems are quite capable of checking if the method is available
> directly, so it seems pretty pointless to me...
> 

I don't have too much of a preference, personally. I think these were
slapped together fairly quickly just to get some kind of mechanism
exposed. I was thinking more of combining them into a single method that
takes a signed value for a reservation delta rather than an absolute
value and simultaneously supports the ability to adjust or retrieve the
current reservation.

Unless I hear other thoughts or objections, I can probably clean that up
and drop the wrappers for a subsequent post as I have some other fixes
pending as well.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
