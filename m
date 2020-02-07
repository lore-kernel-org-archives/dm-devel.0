From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v3 0/7] dax,pmem: Provide a dax operation to zero range of memory
Date: Fri,  7 Feb 2020 15:26:45 -0500
Message-ID: <20200207202652.1439-1-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, hch@infradead.org, dan.j.williams@intel.com
Cc: dm-devel@redhat.com, vishal.l.verma@intel.com, vgoyal@redhat.com
List-Id: dm-devel.ids

Hi,

This is V3 of patches. I have dropped RFC tag from the series as it
looks like there is agreement on the interface. These patches are also
available at.

https://github.com/rhvgoyal/linux/commits/dax-zero-range-v3

I posted previous versions here.

v2:
https://lore.kernel.org/linux-fsdevel/20200203200029.4592-1-vgoyal@redhat=
.com/
v1:
https://lore.kernel.org/linux-fsdevel/20200123165249.GA7664@redhat.com/

Changes since V2:

Primarily took care of comments from Christoph.

- Changed zero_copy_range() parameters to pass dax device offset as u64.
- Fixed comment which says current interface only supports zeroing
  with-in page.
- Refactored pmem_do_bvec() and reused write side of code in
  zero_page_range().
- Removed generic_dax_zero_page_range()
- Fixed s390 dcssblk.c compilation issue.

Please review.=20

Thanks
Vivek

Vivek Goyal (7):
  pmem: Add functions for reading/writing page to/from pmem
  pmem: Enable pmem_do_write() to deal with arbitrary ranges
  dax, pmem: Add a dax operation zero_page_range
  s390,dcssblk,dax: Add dax zero_page_range operation to dcssblk driver
  dm,dax: Add dax zero_page_range operation
  dax,iomap: Start using dax native zero_page_range()
  dax,iomap: Add helper dax_iomap_zero() to zero a range

 drivers/dax/super.c           |  19 ++++++
 drivers/md/dm-linear.c        |  21 +++++++
 drivers/md/dm-log-writes.c    |  19 ++++++
 drivers/md/dm-stripe.c        |  26 ++++++++
 drivers/md/dm.c               |  31 ++++++++++
 drivers/nvdimm/pmem.c         | 112 ++++++++++++++++++++++++----------
 drivers/s390/block/dcssblk.c  |  17 ++++++
 fs/dax.c                      |  53 ++++------------
 fs/iomap/buffered-io.c        |   9 +--
 include/linux/dax.h           |  20 ++----
 include/linux/device-mapper.h |   3 +
 11 files changed, 235 insertions(+), 95 deletions(-)

--=20
2.20.1
