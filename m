From: Vivek Goyal <vgoyal@redhat.com>
Subject: [RFC PATCH 0/5][V2] dax,pmem: Provide a dax operation to zero range of memory
Date: Mon,  3 Feb 2020 15:00:24 -0500
Message-ID: <20200203200029.4592-1-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, dan.j.williams@intel.com, hch@infradead.org
Cc: vgoyal@redhat.com, vishal.l.verma@intel.com, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,

This is V2 of patches. I posted V1 here.

https://lore.kernel.org/linux-fsdevel/20200123165249.GA7664@redhat.com/

Changes since V1.
- Took care of feedback from Christoph.
- Made ->zero_page_range() mandatory operation.
- Provided a generic helper to zero range for non-pmem drivers.
- Merged __dax_zero_page_range() and iomap_dax_zero()
- Made changes to dm drivers.
- Limited range zeroing to with-in single page.
- Tested patches with real hardware. =20

description
-----------
This is an RFC patch series to provide a dax operation to zero a range of
memory. It will also clear poison in the process.

Motivation from this patch comes from Christoph's feedback that he will
rather prefer a dax way to zero a range instead of relying on having to
call blkdev_issue_zeroout() in __dax_zero_page_range().

https://lkml.org/lkml/2019/8/26/361

My motivation for this change is virtiofs DAX support. There we use DAX
but we don't have a block device. So any dax code which has the assumptio=
n
that there is always a block device associated is a problem. So this
is more of a cleanup of one of the places where dax has this dependency
on block device and if we add a dax operation for zeroing a range, it
can help with not having to call blkdev_issue_zeroout() in dax path.

Thanks
Vivek

Vivek Goyal (5):
  dax, pmem: Add a dax operation zero_page_range
  s390,dax: Add dax zero_page_range operation to dcssblk driver
  dm,dax: Add dax zero_page_range operation
  dax,iomap: Start using dax native zero_page_range()
  dax,iomap: Add helper dax_iomap_zero() to zero a range

 drivers/dax/super.c           | 20 ++++++++++++
 drivers/md/dm-linear.c        | 18 +++++++++++
 drivers/md/dm-log-writes.c    | 17 ++++++++++
 drivers/md/dm-stripe.c        | 23 ++++++++++++++
 drivers/md/dm.c               | 30 ++++++++++++++++++
 drivers/nvdimm/pmem.c         | 50 +++++++++++++++++++++++++++++
 drivers/s390/block/dcssblk.c  |  7 ++++
 fs/dax.c                      | 60 ++++++++++++++---------------------
 fs/iomap/buffered-io.c        |  9 +-----
 include/linux/dax.h           | 17 ++++++----
 include/linux/device-mapper.h |  3 ++
 11 files changed, 204 insertions(+), 50 deletions(-)

--=20
2.18.1
