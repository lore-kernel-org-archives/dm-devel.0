From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v3 3/7] dax, pmem: Add a dax operation zero_page_range
Date: Mon, 17 Feb 2020 13:08:07 -0500
Message-ID: <20200217180807.GC24816@redhat.com>
References: <20200207202652.1439-1-vgoyal@redhat.com>
 <20200207202652.1439-4-vgoyal@redhat.com>
 <20200217132607.GD14490@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200217132607.GD14490@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, dan.j.williams@intel.com, dm-devel@redhat.com, vishal.l.verma@intel.com
List-Id: dm-devel.ids

On Mon, Feb 17, 2020 at 05:26:07AM -0800, Christoph Hellwig wrote:
> > +	int rc;
> > +	struct pmem_device *pmem = dax_get_private(dax_dev);
> > +	struct page *page = ZERO_PAGE(0);
> 
> Nit: I tend to find code easier to read if variable declarations
> with assignments are above those without.

Fixed in V4. 

> 
> Also I don't think we need the page variable here.

Fixed in V4.

> 
> > +	rc = pmem_do_write(pmem, page, 0, offset, len);
> > +	if (rc > 0)
> > +		return -EIO;
> 
> pmem_do_write returns a blk_status_t, so the type of rc and the > check
> seem odd.  But I think pmem_do_write (and pmem_do_read) might be better
> off returning a normal errno anyway.

Now I am using blk_status_to_errno() to convert error in V4.

        rc = pmem_do_write(pmem, ZERO_PAGE(0), 0, offset, len);
        return blk_status_to_errno(rc);

Did not modify pmem_do_read()/pmem_do_write() to return errno as there
is still one caller which expects to return blk_status_t and then that
caller will have to do the converstion.

Having said that, it probably is good idea to clean up functions called
by pmem_do_read()/pmem_do_write() to return errno. I prefer not to take
that work in that patch series as that seems like a nice to have thing
and can be handled in a separate patch series.

Thanks
Vivek
