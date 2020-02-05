From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 5/5] dax,iomap: Add helper dax_iomap_zero() to zero a
 range
Date: Wed, 5 Feb 2020 15:15:57 -0500
Message-ID: <20200205201557.GH14544@redhat.com>
References: <20200203200029.4592-1-vgoyal@redhat.com>
 <20200203200029.4592-6-vgoyal@redhat.com>
 <20200205183609.GE26711@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200205183609.GE26711@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, dan.j.williams@intel.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Feb 05, 2020 at 10:36:09AM -0800, Christoph Hellwig wrote:
> > +int dax_iomap_zero(loff_t pos, unsigned offset, unsigned size,
> > +			      struct iomap *iomap)
> >  {
> >  	pgoff_t pgoff;
> >  	long rc, id;
> > +	sector_t sector = iomap_sector(iomap, pos & PAGE_MASK);
> >  
> > -	rc = bdev_dax_pgoff(bdev, sector, PAGE_SIZE, &pgoff);
> > +	rc = bdev_dax_pgoff(iomap->bdev, sector, PAGE_SIZE, &pgoff);
> >  	if (rc)
> >  		return rc;
> >  
> >  	id = dax_read_lock();
> > -	rc = dax_zero_page_range(dax_dev, pgoff, offset, size);
> > +	rc = dax_zero_page_range(iomap->dax_dev, pgoff, offset, size);
> >  	dax_read_unlock(id);
> >  	return rc;
> >  }
> > -EXPORT_SYMBOL_GPL(__dax_zero_page_range);
> > +EXPORT_SYMBOL_GPL(dax_iomap_zero);
> 
> This function is only used by fs/iomap/buffered-io.c, so no need to
> export it.

Will do.

> 
> >  #ifdef CONFIG_FS_DAX
> > -int __dax_zero_page_range(struct block_device *bdev,
> > -		struct dax_device *dax_dev, sector_t sector,
> > -		unsigned int offset, unsigned int length);
> > +int dax_iomap_zero(loff_t pos, unsigned offset, unsigned size,
> > +			      struct iomap *iomap);
> >  #else
> > -static inline int __dax_zero_page_range(struct block_device *bdev,
> > -		struct dax_device *dax_dev, sector_t sector,
> > -		unsigned int offset, unsigned int length)
> > +static inline int dax_iomap_zero(loff_t pos, unsigned offset, unsigned size,
> > +				 struct iomap *iomap)
> >  {
> >  	return -ENXIO;
> >  }
> 
> Given that the only caller is under an IS_DAX() check you could just
> declare the function unconditionally and let the compiler optimize
> away the guaranteed dead call for the !CONFIG_FS_DAX case, like we
> do with various other functions.

Sure, will do.

Vivek
