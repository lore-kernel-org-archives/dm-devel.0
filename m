From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/5] dax,iomap: Start using dax native zero_page_range()
Date: Wed, 5 Feb 2020 10:33:56 -0800
Message-ID: <20200205183356.GD26711@infradead.org>
References: <20200203200029.4592-1-vgoyal@redhat.com>
 <20200203200029.4592-5-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200203200029.4592-5-vgoyal@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, dan.j.williams@intel.com, hch@infradead.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Feb 03, 2020 at 03:00:28PM -0500, Vivek Goyal wrote:
> +	id = dax_read_lock();
> +	rc = dax_zero_page_range(dax_dev, pgoff, offset, size);
> +	dax_read_unlock(id);
> +	return rc;

Is there a good reason not to move the locking into dax_zero_page_range?
