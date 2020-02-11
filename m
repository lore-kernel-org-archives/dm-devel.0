From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: Re: [PATCH v3 4/7] s390,dcssblk,dax: Add dax zero_page_range
 operation to dcssblk driver
Date: Tue, 11 Feb 2020 16:49:54 +0100
Message-ID: <20200211164954.4df79b8b@thinkpad>
References: <20200207202652.1439-1-vgoyal@redhat.com>
        <20200207202652.1439-5-vgoyal@redhat.com>
        <20200210215315.27b7e310@thinkpad>
        <20200211151114.GA8590@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200211151114.GA8590@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, hch@infradead.org, dan.j.williams@intel.com, dm-devel@redhat.com, vishal.l.verma@intel.com, linux-s390@vger.kernel.org
List-Id: dm-devel.ids

On Tue, 11 Feb 2020 10:11:14 -0500
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Mon, Feb 10, 2020 at 09:53:15PM +0100, Gerald Schaefer wrote:
> > On Fri,  7 Feb 2020 15:26:49 -0500
> > Vivek Goyal <vgoyal@redhat.com> wrote:
> > 
> > > Add dax operation zero_page_range for dcssblk driver.
> > > 
> > > CC: linux-s390@vger.kernel.org
> > > Suggested-by: Christoph Hellwig <hch@infradead.org>
> > > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > > ---
> > >  drivers/s390/block/dcssblk.c | 17 +++++++++++++++++
> > >  1 file changed, 17 insertions(+)
> > > 
> > > diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
> > > index 63502ca537eb..331abab5d066 100644
> > > --- a/drivers/s390/block/dcssblk.c
> > > +++ b/drivers/s390/block/dcssblk.c
> > > @@ -57,11 +57,28 @@ static size_t dcssblk_dax_copy_to_iter(struct dax_device *dax_dev,
> > >  	return copy_to_iter(addr, bytes, i);
> > >  }
> > >  
> > > +static int dcssblk_dax_zero_page_range(struct dax_device *dax_dev, u64 offset,
> > > +				       size_t len)
> > > +{
> > > +	long rc;
> > > +	void *kaddr;
> > > +	pgoff_t pgoff = offset >> PAGE_SHIFT;
> > > +	unsigned page_offset = offset_in_page(offset);
> > > +
> > > +	rc = dax_direct_access(dax_dev, pgoff, 1, &kaddr, NULL);
> > 
> > Why do you pass only 1 page as nr_pages argument for dax_direct_access()?
> > In some other patch in this series there is a comment that this will
> > currently only be used for one page, but support for more pages might be
> > added later. Wouldn't it make sense to rather use something like
> > PAGE_ALIGN(page_offset + len) >> PAGE_SHIFT instead of 1 here, so that
> > this won't have to be changed when callers will be ready to use it
> > with more than one page?
> > 
> > Of course, I guess then we'd also need some check on the return value
> > from dax_direct_access(), i.e. if the returned available range is
> > large enough for the requested range.
> 
> I left it at 1 page because that's the current limitation of this
> interface and there are no callers which are zeroing across page
> boundaries.
> 
> I prefer to keep it this way and modify it when we are extending this
> interface to allow zeroing across page boundaries. Because even if I add
> that logic, I can't test it.

OK, fine with me.

Reviewed-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
