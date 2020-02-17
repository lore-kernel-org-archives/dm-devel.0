From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 6/7] dax,iomap: Start using dax native
 zero_page_range()
Date: Mon, 17 Feb 2020 05:26:54 -0800
Message-ID: <20200217132654.GE14490@infradead.org>
References: <20200207202652.1439-1-vgoyal@redhat.com>
 <20200207202652.1439-7-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200207202652.1439-7-vgoyal@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, hch@infradead.org, dan.j.williams@intel.com, dm-devel@redhat.com, vishal.l.verma@intel.com
List-Id: dm-devel.ids

On Fri, Feb 07, 2020 at 03:26:51PM -0500, Vivek Goyal wrote:
> Get rid of calling block device interface for zeroing in iomap dax
> zeroing path and use dax native zeroing interface instead.
> 
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
