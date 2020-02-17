From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/6] dax,iomap,ext4,ext2,xfs: Save dax_offset in "struct
 iomap"
Date: Mon, 17 Feb 2020 05:31:17 -0800
Message-ID: <20200217133117.GB20444@infradead.org>
References: <20200212170733.8092-1-vgoyal@redhat.com>
 <20200212170733.8092-3-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200212170733.8092-3-vgoyal@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, dan.j.williams@intel.com, hch@infradead.org, dm-devel@redhat.com, jack@suse.cz
List-Id: dm-devel.ids

On Wed, Feb 12, 2020 at 12:07:29PM -0500, Vivek Goyal wrote:
> Add a new field "sector_t dax_offset" to "struct iomap". This will be
> filled by filesystems and dax code will make use of this to convert
> sector into page offset (dax_pgoff()), instead of bdev_dax_pgoff(). This
> removes the dependency of having to pass in block device for dax operations.

NAK.  The iomap is not a structure to bolt random layering violation
onto.
