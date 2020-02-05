From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 2/5] s390,dax: Add dax zero_page_range operation to
 dcssblk driver
Date: Wed, 5 Feb 2020 15:04:25 -0500
Message-ID: <20200205200425.GF14544@redhat.com>
References: <20200203200029.4592-1-vgoyal@redhat.com>
 <20200203200029.4592-3-vgoyal@redhat.com>
 <20200205183205.GB26711@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200205183205.GB26711@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, dan.j.williams@intel.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Feb 05, 2020 at 10:32:05AM -0800, Christoph Hellwig wrote:
> > diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
> > index 63502ca537eb..f6709200bcd0 100644
> > --- a/drivers/s390/block/dcssblk.c
> > +++ b/drivers/s390/block/dcssblk.c
> > @@ -62,6 +62,7 @@ static const struct dax_operations dcssblk_dax_ops = {
> >  	.dax_supported = generic_fsdax_supported,
> >  	.copy_from_iter = dcssblk_dax_copy_from_iter,
> >  	.copy_to_iter = dcssblk_dax_copy_to_iter,
> > +	.zero_page_range = dcssblk_dax_zero_page_range,
> >  };
> >  
> >  struct dcssblk_dev_info {
> > @@ -941,6 +942,12 @@ dcssblk_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
> >  	return __dcssblk_direct_access(dev_info, pgoff, nr_pages, kaddr, pfn);
> >  }
> >  
> > +static int dcssblk_dax_zero_page_range(struct dax_device *dax_dev,pgoff_t pgoff,
> > +				       unsigned offset, size_t len)
> > +{
> > +	return generic_dax_zero_page_range(dax_dev, pgoff, offset, len);
> > +}
> 
> Wouldn't this need a forward declaration?  Then again given that dcssblk
> is the only caller of generic_dax_zero_page_range we might as well merge
> the two.  If you want to keep the generic one it could be wired up to
> dcssblk_dax_ops directly, though.

Given dcssblk is the only user, I am inclined to get rid of genric
version. We can add one later if another user shows up.

Thanks
Vivek
