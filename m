From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v5 3/8] pmem: Enable pmem_do_write() to deal with
 arbitrary ranges
Date: Thu, 20 Feb 2020 08:17:32 -0800
Message-ID: <20200220161732.GB31606@infradead.org>
References: <20200218214841.10076-1-vgoyal@redhat.com>
 <20200218214841.10076-4-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200218214841.10076-4-vgoyal@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, hch@infradead.org, dan.j.williams@intel.com, dm-devel@redhat.com, vishal.l.verma@intel.com
List-Id: dm-devel.ids

On Tue, Feb 18, 2020 at 04:48:36PM -0500, Vivek Goyal wrote:
> Currently pmem_do_write() is written with assumption that all I/O is
> sector aligned. Soon I want to use this function in zero_page_range()
> where range passed in does not have to be sector aligned.
> 
> Modify this function to be able to deal with an arbitrary range. Which
> is specified by pmem_off and len.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
