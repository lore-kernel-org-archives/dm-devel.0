From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 4/5] dax,iomap: Start using dax native zero_page_range()
Date: Wed, 5 Feb 2020 15:10:31 -0500
Message-ID: <20200205201031.GG14544@redhat.com>
References: <20200203200029.4592-1-vgoyal@redhat.com>
 <20200203200029.4592-5-vgoyal@redhat.com>
 <20200205183356.GD26711@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200205183356.GD26711@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, dan.j.williams@intel.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Feb 05, 2020 at 10:33:56AM -0800, Christoph Hellwig wrote:
> On Mon, Feb 03, 2020 at 03:00:28PM -0500, Vivek Goyal wrote:
> > +	id = dax_read_lock();
> > +	rc = dax_zero_page_range(dax_dev, pgoff, offset, size);
> > +	dax_read_unlock(id);
> > +	return rc;
> 
> Is there a good reason not to move the locking into dax_zero_page_range?

No reason. I can move locking inside dax_zero_page_range(). Will do.

Vivek
