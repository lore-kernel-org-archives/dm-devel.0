From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [resend PATCH v2 00/33] dax: introduce dax_operations
Date: Tue, 25 Apr 2017 15:33:38 -0700
Message-ID: <CAPcyv4iZ7A6mOK-p5gVqOgiq9_B0tfV9q0-ouLk5oECZRo4x0A@mail.gmail.com>
References: <149245612770.10206.15496018295337908594.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAPcyv4g+WEYD7RVAekDdBn0+-+GRdKiK1HOG8JrVBAT4h5-CvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAPcyv4g+WEYD7RVAekDdBn0+-+GRdKiK1HOG8JrVBAT4h5-CvQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Gerald Schaefer <gerald.schaefer-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: dm-devel.ids

On Fri, Apr 21, 2017 at 6:06 PM, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> [ adding akpm, sfr, and jens ]
>
> I applied this series and pushed it out for the nvdimm.git branch that
> gets auto pulled into -next. The set is still awaiting acks from
> device-mapper, ext4, xfs, and vfs (for the copy_from_iter_ops, patch
> 29/33). If those come next week perhaps this can be merged for 4.12,
> but if not this will need to wait until 4.13.
>
> There are some minor collisions with Al's copy_from_user rework, the
> new dax tracepoints, and the removal of discard support from the brd
> driver. A sample merge is available here:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git/log/?h=libnvdimm-for-4.12-merge
>
> If it causes any other problems just drop and I'll retry for 4.13.

Al has nak'd the uaccess related changes, and I'll need to rework
those patches to move the pmem routines into lib/iov_iter.c directly.
That doesn't affect the dax_device and dax_operations work, so I'm
still looking to move forward with that change.  That reduces the set
targeting 4.12 to just the first 18 patches from this series:

Dan Williams (18):
      device-dax: rename 'dax_dev' to 'dev_dax'
      dax: refactor dax-fs into a generic provider of 'struct
dax_device' instances
      dax: add a facility to lookup a dax device by 'host' device name
      dax: introduce dax_operations
      pmem: add dax_operations support
      axon_ram: add dax_operations support
      brd: add dax_operations support
      dcssblk: add dax_operations support
      block: kill bdev_dax_capable()
      dax: introduce dax_direct_access()
      dm: add dax_device and dax_operations support
      dm: teach dm-targets to use a dax_device + dax_operations
      ext2, ext4, xfs: retrieve dax_device for iomap operations
      Revert "block: use DAX for partition table reads"
      filesystem-dax: convert to dax_direct_access()
      block, dax: convert bdev_dax_supported() to dax_direct_access()
      block: remove block_device_operations ->direct_access()
      x86, dax, pmem: remove indirection around memcpy_from_pmem()
