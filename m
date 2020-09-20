From: Dan Williams <dan.j.williams@intel.com>
Subject: libnvdimm fixes 5.9-rc6
Date: Sun, 20 Sep 2020 11:55:48 -0700
Message-ID: <CAPcyv4h3oKM-2hoG=FWHJwzVqjptnpQV9C+W6txfp_qcBhd7yQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, device-mapper development <dm-devel@redhat.com>, Jan Kara <jack@suse.cz>, Adrian Huang12 <ahuang12@lenovo.com>, Mike Snitzer <snitzer@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
tags/libnvdimm-fixes-5.9-rc6

...to receive a handful of fixes to address a string of mistakes in
the mechanism for device-mapper to determine if its component devices
are dax capable. You will notice that this branch was rebased this
morning and it has not appeared in -next. I decided to cut short the
soak time because the infinite-recursion regression is currently
crashing anyone attempting to test filesystem-dax in 5.9-rc5+. The
most recent rebase folded in a compile fix reported by the kbuild
robot for the uncommon CONFIG_DAX=m case. It should, "should",  be all
good now.

---

The following changes since commit 856deb866d16e29bd65952e0289066f6078af773:

  Linux 5.9-rc5 (2020-09-13 16:06:00 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
tags/libnvdimm-fixes-5.9-rc6

for you to fetch changes up to d4c5da5049ac27c6ef8f6f98548c3a1ade352d25:

  dax: Fix stack overflow when mounting fsdax pmem device (2020-09-20
08:57:36 -0700)

----------------------------------------------------------------
libnvdimm fixes for 5.9-rc6

- Fix an original bug in device-mapper table reference counting when
  interrogating dax capability in the component device. This bug was
  hidden by the following bug.

- Fix device-mapper to use the proper helper (dax_supported() instead of
  the leaf helper generic_fsdax_supported()) to determine dax operation
  of a stacked block device configuration. The original implementation
  is only valid for one level of dax-capable block device stacking. This
  bug was discovered while fixing the below regression.

- Fix an infinite recursion regression introduced by broken attempts to
  quiet the generic_fsdax_supported() path and make it bail out before
  logging "dax capability not found" errors.

----------------------------------------------------------------
Adrian Huang (1):
      dax: Fix stack overflow when mounting fsdax pmem device

Dan Williams (1):
      dm/dax: Fix table reference counts

Jan Kara (1):
      dm: Call proper helper to determine dax support

 drivers/dax/super.c   | 16 ++++++++++------
 drivers/md/dm-table.c | 10 +++++++---
 drivers/md/dm.c       |  5 +++--
 include/linux/dax.h   | 22 ++++++++++++++++++++--
 4 files changed, 40 insertions(+), 13 deletions(-)
