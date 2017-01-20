From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 00/13] dax, pmem: move cpu cache maintenance to libnvdimm
Date: Thu, 19 Jan 2017 19:50:13 -0800
Message-ID: <148488421301.37913.12835362165895864897.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Cc: Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: dm-devel.ids

A couple weeks back, in the course of reviewing the memcpy_nocache()
proposal from Brian, Linus subtly suggested that the pmem specific
memcpy_to_pmem() routine be moved to be implemented at the driver
level [1]:

   "Quite frankly, the whole 'memcpy_nocache()' idea or (ab-)using
    copy_user_nocache() just needs to die. It's idiotic.
    
    As you point out, it's also fundamentally buggy crap.
    
    Throw it away. There is no possible way this is ever valid or
    portable. We're not going to lie and claim that it is.
    
    If some driver ends up using 'movnt' by hand, that is up to that
    *driver*. But no way in hell should we care about this one whit in
    the sense of <linux/uaccess.h>."

This feedback also dovetails with another fs/dax.c design wart of being
hard coded to assume the backing device is pmem. We call the pmem
specific copy, clear, and flush routines even if the backing device
driver is one of the other 3 dax drivers (axonram, dccssblk, or brd).
There is no reason to spend cpu cycles flushing the cache after writing
to brd, for example, since it is using volatile memory for storage.

Moreover, the pmem driver might be fronting a volatile memory range
published by the ACPI NFIT, or the platform might have arranged to flush
cpu caches on power fail. This latter capability is a feature that has
appeared in embedded storage appliances ("legacy" / pre-NFIT nvdimm
platforms).

So, this series:

1/ moves what was previously named "the pmem api" out of the global
   namespace and into "that *driver*" (libnvdimm / pmem).

2/ arranges for dax to stop abusing copy_user_nocache() and implements a
   libnvdimm-local memcpy that uses movnt

3/ makes cache maintenance optional by arranging for dax to call driver
   specific copy and flush operations only if the driver publishes them.

4/ adds a module parameter that can be used to inform libnvdimm of a
   platform-level flush-cache-on-power-fail capability.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2017-January/008364.html

These patches have a build success notification from the 0day kbuild robot
and pass the libnvdimm / ndctl unit tests. I am looking to take them
through the libnvdimm tree with acks from x86, block, dm etc...

---

Dan Williams (13):
      x86, dax, pmem: remove indirection around memcpy_from_pmem()
      block, dax: introduce dax_operations
      x86, dax, pmem: introduce 'copy_from_iter' dax operation
      dax, pmem: introduce an optional 'flush' dax operation
      x86, dax: replace clear_pmem() with open coded memset + dax_ops->flush
      x86, dax, libnvdimm: move wb_cache_pmem() to libnvdimm
      x86, libnvdimm, pmem: move arch_invalidate_pmem() to libnvdimm
      x86, libnvdimm, dax: stop abusing __copy_user_nocache
      libnvdimm, pmem: implement cache bypass for all copy_from_iter() operations
      libnvdimm, pmem: fix persistence warning
      libnvdimm, nfit: enable support for volatile ranges
      libnvdimm, pmem: disable dax flushing when pmem is fronting a volatile region
      libnvdimm, pmem: disable dax flushing for 'cache flush on fail' platforms


 MAINTAINERS                      |    2 
 arch/powerpc/sysdev/axonram.c    |    6 +
 arch/x86/Kconfig                 |    1 
 arch/x86/include/asm/pmem.h      |  121 ----------------------------
 arch/x86/include/asm/string_64.h |    1 
 drivers/acpi/nfit/core.c         |   15 ++-
 drivers/block/brd.c              |    6 +
 drivers/md/dm.c                  |    6 +
 drivers/nvdimm/Kconfig           |    5 +
 drivers/nvdimm/Makefile          |    2 
 drivers/nvdimm/bus.c             |   10 +-
 drivers/nvdimm/claim.c           |    9 +-
 drivers/nvdimm/core.c            |    2 
 drivers/nvdimm/dax_devs.c        |    2 
 drivers/nvdimm/dimm_devs.c       |    4 -
 drivers/nvdimm/namespace_devs.c  |    9 +-
 drivers/nvdimm/nd-core.h         |    9 ++
 drivers/nvdimm/pfn_devs.c        |    4 -
 drivers/nvdimm/pmem.c            |   46 ++++++++---
 drivers/nvdimm/pmem.h            |   20 +++++
 drivers/nvdimm/region_devs.c     |   52 ++++++++----
 drivers/nvdimm/x86-asm.S         |   71 ++++++++++++++++
 drivers/nvdimm/x86.c             |   84 +++++++++++++++++++
 drivers/s390/block/dcssblk.c     |    6 +
 fs/block_dev.c                   |    6 +
 fs/dax.c                         |   35 +++++++-
 include/linux/blkdev.h           |   10 ++
 include/linux/libnvdimm.h        |    9 ++
 include/linux/pmem.h             |  165 --------------------------------------
 include/linux/string.h           |    8 ++
 include/linux/uio.h              |    4 +
 lib/Kconfig                      |    6 +
 lib/iov_iter.c                   |   25 ++++++
 tools/testing/nvdimm/Kbuild      |    2 
 34 files changed, 405 insertions(+), 358 deletions(-)
 delete mode 100644 arch/x86/include/asm/pmem.h
 create mode 100644 drivers/nvdimm/x86-asm.S
 create mode 100644 drivers/nvdimm/x86.c
 delete mode 100644 include/linux/pmem.h
