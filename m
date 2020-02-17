From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v3 1/7] pmem: Add functions for reading/writing page
 to/from pmem
Date: Mon, 17 Feb 2020 13:04:56 -0500
Message-ID: <20200217180456.GB24816@redhat.com>
References: <20200207202652.1439-1-vgoyal@redhat.com>
 <20200207202652.1439-2-vgoyal@redhat.com>
 <20200217132138.GB14490@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200217132138.GB14490@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, dan.j.williams@intel.com, dm-devel@redhat.com, vishal.l.verma@intel.com
List-Id: dm-devel.ids

On Mon, Feb 17, 2020 at 05:21:38AM -0800, Christoph Hellwig wrote:
> On Fri, Feb 07, 2020 at 03:26:46PM -0500, Vivek Goyal wrote:
> > +static blk_status_t pmem_do_bvec(struct pmem_device *pmem, struct page *page,
> > +			unsigned int len, unsigned int off, unsigned int op,
> > +			sector_t sector)
> > +{
> > +	if (!op_is_write(op))
> > +		return pmem_do_read(pmem, page, off, sector, len);
> > +
> > +	return pmem_do_write(pmem, page, off, sector, len);
> 
> Why not:
> 
> 	if (op_is_write(op))
> 		return pmem_do_write(pmem, page, off, sector, len);
> 	return pmem_do_read(pmem, page, off, sector, len);
> 
> that being said I don't see the point of this pmem_do_bvec helper given
> that it only has two callers.

Ok, I am about to post V4 of patches and I got rid of pmem_do_bvec() and
callers are directly calling pmem_do_read()/pmem_do_write().

Vivek
