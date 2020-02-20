From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v5 2/8] drivers/pmem: Allow pmem_clear_poison() to accept
 arbitrary offset and len
Date: Thu, 20 Feb 2020 08:17:16 -0800
Message-ID: <20200220161716.GA31606@infradead.org>
References: <20200218214841.10076-1-vgoyal@redhat.com>
 <20200218214841.10076-3-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200218214841.10076-3-vgoyal@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, hch@infradead.org, dan.j.williams@intel.com, dm-devel@redhat.com, vishal.l.verma@intel.com
List-Id: dm-devel.ids

On Tue, Feb 18, 2020 at 04:48:35PM -0500, Vivek Goyal wrote:
> Currently pmem_clear_poison() expects offset and len to be sector aligned.
> Atleast that seems to be the assumption with which code has been written.
> It is called only from pmem_do_bvec() which is called only from pmem_rw_page()
> and pmem_make_request() which will only passe sector aligned offset and len.
> 
> Soon we want use this function from dax_zero_page_range() code path which
> can try to zero arbitrary range of memory with-in a page. So update this
> function to assume that offset and length can be arbitrary and do the
> necessary alignments as needed.
> 
> nvdimm_clear_poison() seems to assume offset and len to be aligned to
> clear_err_unit boundary. But this is currently internal detail and is
> not exported for others to use. So for now, continue to align offset and
> length to SECTOR_SIZE boundary. Improving it further and to align it
> to clear_err_unit boundary is a TODO item for future.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

This looks sensibel to me, but I'd really like to have Dan take at look.
