From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 00/14] pmem: stop abusing __copy_user_nocache(),
 and other reworks
Date: Fri, 09 Jun 2017 13:23:45 -0700
Message-ID: <149703982465.20620.14881139332926778446.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org
List-Id: dm-devel.ids

Changes since v2 [1]:
1/ Address the concerns from "[NAK] copy_from_iter_ops()" [2]. The
   copy_from_iter_ops approach is replaced with a new set _flushcache
   memcpy and user-copy helpers (Al)

2/ Use _flushcache as the suffix for the new cache managing copy helpers
   rather than _writethrough (Ingo and Toshi)

3/ Keep asm/pmem.h instead of moving the helpers to
   drivers/nvdimm/$arch.c (another side effect of Al's feedback)

[1]: https://lkml.org/lkml/2017/4/21/823
[2]: https://lists.01.org/pipermail/linux-nvdimm/2017-April/009942.html

---
A few months back, in the course of reviewing the memcpy_nocache()
proposal from Brian, Linus proposed that the pmem specific
memcpy_to_pmem() routine be moved to be implemented at the driver level
[3]:

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
appeared in embedded storage appliances (pre-ACPI-NFIT nvdimm
platforms).

Now, the comment about completely avoiding uaccess.h is augmented by
Al's recent assertion:

   "And for !@#!@# sake, comments like this
    +        * On x86_64 __copy_from_user_nocache() uses non-temporal stores
    +        * for the bulk of the transfer, but we need to manually flush
    +        * if the transfer is unaligned. A cached memory copy is used
    +        * when destination or size is not naturally aligned. That is:
    +        *   - Require 8-byte alignment when size is 8 bytes or larger.
    +        *   - Require 4-byte alignment when size is 4 bytes.
    mean only one thing: this should live in arch/x86/lib/usercopy_64.c,
    right next to the actual function that does copying.  NOT in
    drivers/nvdimm/x86.c.  At the very least it needs a comment in usercopy_64.c
    with dire warnings along the lines of "don't touch that code without
    looking into <filename>:pmem_from_user().."

So, this series proceeds to keep all the usercopy code centralized. The
change set:

1/ Moves what was previously named "the pmem api" out of the global
   namespace and into the libnvdimm sub-system that needs to be
   concerned with architecture specific persistent memory considerations.

2/ Arranges for dax to stop abusing __copy_user_nocache() and implements
   formal _flushcache helpers that use 'movnt' on x86_64.

3/ Makes filesystem-dax cache maintenance optional by arranging for dax
   to call driver specific copy and flush operations only if the driver
   publishes them.

4/ Allows filesytem-dax cache management to be controlled by the block
   device write-cache queue flag. The pmem driver is updated to clear
   that flag by default when pmem is driving volatile memory. In the future
   this same path may be used to detect platforms that have a
   cpu-cache-flush-on-fail capability. That said, an administrator has the
   option to force this behavior by writing to the $bdev/queue/write_cache
   attribute in sysfs.

[3]: https://lists.01.org/pipermail/linux-nvdimm/2017-January/008364.html

This series is based on v4.12-rc4 and passes the current ndctl
regression suite.

---

Dan Williams (14):
      x86, uaccess: introduce copy_from_iter_flushcache for pmem / cache-bypass operations
      dm: add ->copy_from_iter() dax operation support
      filesystem-dax: convert to dax_copy_from_iter()
      dax, pmem: introduce an optional 'flush' dax_operation
      dm: add ->flush() dax operation support
      filesystem-dax: convert to dax_flush()
      x86, dax: replace clear_pmem() with open coded memset + dax_ops->flush
      x86, dax, libnvdimm: move wb_cache_pmem() to libnvdimm
      x86, libnvdimm, pmem: move arch_invalidate_pmem() to libnvdimm
      pmem: remove global pmem api
      libnvdimm, pmem: fix persistence warning
      libnvdimm, nfit: enable support for volatile ranges
      filesystem-dax: gate calls to dax_flush() on QUEUE_FLAG_WC
      libnvdimm, pmem: disable dax flushing when pmem is fronting a volatile region


 MAINTAINERS                       |    1 
 arch/x86/Kconfig                  |    1 
 arch/x86/include/asm/pmem.h       |   81 ---------------------
 arch/x86/include/asm/string_64.h  |    5 +
 arch/x86/include/asm/uaccess_64.h |   12 +++
 arch/x86/lib/usercopy_64.c        |  129 ++++++++++++++++++++++++++++++++++
 drivers/acpi/nfit/core.c          |   15 +++-
 drivers/dax/super.c               |   24 ++++++
 drivers/md/dm-linear.c            |   30 ++++++++
 drivers/md/dm-stripe.c            |   40 ++++++++++
 drivers/md/dm.c                   |   45 ++++++++++++
 drivers/nvdimm/bus.c              |    8 +-
 drivers/nvdimm/claim.c            |    6 +-
 drivers/nvdimm/core.c             |    2 -
 drivers/nvdimm/dax_devs.c         |    2 -
 drivers/nvdimm/dimm_devs.c        |   10 ++-
 drivers/nvdimm/namespace_devs.c   |   14 +---
 drivers/nvdimm/nd-core.h          |    9 ++
 drivers/nvdimm/pfn_devs.c         |    4 +
 drivers/nvdimm/pmem.c             |   32 +++++++-
 drivers/nvdimm/pmem.h             |   13 +++
 drivers/nvdimm/region_devs.c      |   43 +++++++----
 fs/dax.c                          |   11 ++-
 include/linux/dax.h               |    9 ++
 include/linux/device-mapper.h     |    6 ++
 include/linux/libnvdimm.h         |    2 +
 include/linux/pmem.h              |  142 -------------------------------------
 include/linux/string.h            |    6 ++
 include/linux/uio.h               |   15 ++++
 lib/Kconfig                       |    3 +
 lib/iov_iter.c                    |   22 ++++++
 31 files changed, 464 insertions(+), 278 deletions(-)
 delete mode 100644 include/linux/pmem.h
