From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v6 0/6] dax/pmem: Provide a dax operation to zero page
 range
Date: Tue, 10 Mar 2020 08:18:32 -0400
Message-ID: <20200310121832.GA38440@redhat.com>
References: <20200228163456.1587-1-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200228163456.1587-1-vgoyal@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, hch@infradead.org, dan.j.williams@intel.com
Cc: david@fromorbit.com, jmoyer@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Feb 28, 2020 at 11:34:50AM -0500, Vivek Goyal wrote:
> Hi,
> 
> This is V6 of patches. These patches are also available at.

Hi Dan,

Ping. Does this patch series look fine to you?

Vivek

> 
> Changes since V5:
> 
> - Dan Williams preferred ->zero_page_range() to only accept PAGE_SIZE
>   aligned request and clear poison only on page size aligned zeroing. So
>   I changed it accordingly. 
> 
> - Dropped all the modifications which were required to support arbitrary
>   range zeroing with-in a page.
> 
> - This patch series also fixes the issue where "truncate -s 512 foo.txt"
>   will fail if first sector of file is poisoned. Currently it succeeds
>   and filesystem expectes whole of the filesystem block to be free of
>   poison at the end of the operation.
> 
> Christoph, I have dropped your Reviewed-by tag on 1-2 patches because
> these patches changed substantially. Especially signature of of
> dax zero_page_range() helper.
> 
> Thanks
> Vivek
> 
> Vivek Goyal (6):
>   pmem: Add functions for reading/writing page to/from pmem
>   dax, pmem: Add a dax operation zero_page_range
>   s390,dcssblk,dax: Add dax zero_page_range operation to dcssblk driver
>   dm,dax: Add dax zero_page_range operation
>   dax: Use new dax zero page method for zeroing a page
>   dax,iomap: Add helper dax_iomap_zero() to zero a range
> 
>  drivers/dax/super.c           | 20 ++++++++
>  drivers/md/dm-linear.c        | 18 +++++++
>  drivers/md/dm-log-writes.c    | 17 ++++++
>  drivers/md/dm-stripe.c        | 23 +++++++++
>  drivers/md/dm.c               | 30 +++++++++++
>  drivers/nvdimm/pmem.c         | 97 ++++++++++++++++++++++-------------
>  drivers/s390/block/dcssblk.c  | 15 ++++++
>  fs/dax.c                      | 59 ++++++++++-----------
>  fs/iomap/buffered-io.c        |  9 +---
>  include/linux/dax.h           | 21 +++-----
>  include/linux/device-mapper.h |  3 ++
>  11 files changed, 221 insertions(+), 91 deletions(-)
> 
> -- 
> 2.20.1
> 
