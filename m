From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [dm-devel] [PATCH v4 1/7] pmem: Add functions for
 reading/writing page to/from pmem
Date: Tue, 18 Feb 2020 09:07:43 -0800
Message-ID: <20200218170743.GA30766@infradead.org>
References: <20200217181653.4706-1-vgoyal@redhat.com>
 <20200217181653.4706-2-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200217181653.4706-2-vgoyal@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, hch@infradead.org, dan.j.williams@intel.com, vishal.l.verma@intel.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Feb 17, 2020 at 01:16:47PM -0500, Vivek Goyal wrote:
> This splits pmem_do_bvec() into pmem_do_read() and pmem_do_write().
> pmem_do_write() will be used by pmem zero_page_range() as well. Hence
> sharing the same code.
> 
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
