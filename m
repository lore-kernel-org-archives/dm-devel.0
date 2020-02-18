From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v5 0/8] dax/pmem: Provide a dax operation to zero range of memory
Date: Tue, 18 Feb 2020 16:48:33 -0500
Message-ID: <20200218214841.10076-1-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, hch@infradead.org, dan.j.williams@intel.com
Cc: dm-devel@redhat.com, vishal.l.verma@intel.com, vgoyal@redhat.com
List-Id: dm-devel.ids

Hi,=20

This is V5 of patches. These patches are also available at.

https://github.com/rhvgoyal/linux/commits/dax-zero-range-v5

Changes since V4:

- Rebased on top of 5.6-rc2
- Added a separate patch so that pmem_clear_poison() accepts arbitrary
  offset and len and aligns these as needed. This takes away the burden
  of aligning from callers.

Previous versions of patches are here.
v4:
https://lore.kernel.org/linux-fsdevel/20200217181653.4706-1-vgoyal@redhat=
.com/
v3:
https://lore.kernel.org/linux-fsdevel/20200214125717.GA18654@redhat.com/T=
/#t
v2:
https://lore.kernel.org/linux-fsdevel/20200203200029.4592-1-vgoyal@redhat=
.com/
v1:
https://lore.kernel.org/linux-fsdevel/20200123165249.GA7664@redhat.com/

Thanks
Vivek

Vivek Goyal (8):
  pmem: Add functions for reading/writing page to/from pmem
  drivers/pmem: Allow pmem_clear_poison() to accept arbitrary offset and
    len
  pmem: Enable pmem_do_write() to deal with arbitrary ranges
  dax, pmem: Add a dax operation zero_page_range
  s390,dcssblk,dax: Add dax zero_page_range operation to dcssblk driver
  dm,dax: Add dax zero_page_range operation
  dax,iomap: Start using dax native zero_page_range()
  dax,iomap: Add helper dax_iomap_zero() to zero a range

 drivers/dax/super.c           |  19 +++++
 drivers/md/dm-linear.c        |  21 ++++++
 drivers/md/dm-log-writes.c    |  19 +++++
 drivers/md/dm-stripe.c        |  26 +++++++
 drivers/md/dm.c               |  31 ++++++++
 drivers/nvdimm/pmem.c         | 134 +++++++++++++++++++++++-----------
 drivers/s390/block/dcssblk.c  |  17 +++++
 fs/dax.c                      |  53 ++++----------
 fs/iomap/buffered-io.c        |   9 +--
 include/linux/dax.h           |  20 ++---
 include/linux/device-mapper.h |   3 +
 11 files changed, 246 insertions(+), 106 deletions(-)

--=20
2.20.1
