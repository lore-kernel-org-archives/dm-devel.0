From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 7/7] dax,iomap: Add helper dax_iomap_zero() to zero a
 range
Date: Mon, 17 Feb 2020 05:27:41 -0800
Message-ID: <20200217132741.GF14490@infradead.org>
References: <20200207202652.1439-1-vgoyal@redhat.com>
 <20200207202652.1439-8-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200207202652.1439-8-vgoyal@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, hch@infradead.org, dan.j.williams@intel.com, dm-devel@redhat.com, vishal.l.verma@intel.com
List-Id: dm-devel.ids

On Fri, Feb 07, 2020 at 03:26:52PM -0500, Vivek Goyal wrote:
> Add a helper dax_ioamp_zero() to zero a range. This patch basically
> merges __dax_zero_page_range() and iomap_dax_zero().
> 
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/dax.c               | 12 ++++++------
>  fs/iomap/buffered-io.c |  9 +--------
>  include/linux/dax.h    | 17 +++--------------
>  3 files changed, 10 insertions(+), 28 deletions(-)

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
