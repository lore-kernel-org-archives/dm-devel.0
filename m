From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v3 0/2] dax, dm: stop requiring dax for device-mapper
Date: Wed, 02 Aug 2017 10:57:59 -0700
Message-ID: <150169667935.39569.15808116323143633486.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: snitzer@redhat.com
Cc: kbuild test robot <lkp@intel.com>, linux-nvdimm@lists.01.org, Michael Ellerman <mpe@ellerman.id.au>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, dm-devel@redhat.com, Paul Mackerras <paulus@samba.org>, Alasdair Kergon <agk@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, Gerald Schaefer <gerald.schaefer@de.ibm.com>
List-Id: dm-devel.ids

Changes since v2 [1]:
* rebase on -next to integrate with commit 273752c9ff03 "dm, dax: Make
  sure dm_dax_flush() is called if device supports it" (kbuild robot)
* fix CONFIG_DAX dependencies to upgrade CONFIG_DAX=m to CONFIG_DAX=y
  (kbuild robot)

[1]: https://www.spinics.net/lists/kernel/msg2570522.html

---

Bart points out that the DAX core is unconditionally enabled if
device-mapper is enabled. Add some config machinery and some
stub-static-inline routines to allow dax infrastructure to be deleted
from device-mapper at compile time.

Since this depends on commit 273752c9ff03 that's already in -next, this
should go through the device-mapper tree.
---

Dan Williams (2):
      dax: introduce CONFIG_DAX_DRIVER
      dm: allow device-mapper to operate without dax support


 arch/powerpc/platforms/Kconfig |    1 +
 drivers/block/Kconfig          |    1 +
 drivers/dax/Kconfig            |    4 +++-
 drivers/md/Kconfig             |    2 +-
 drivers/md/dm-linear.c         |    6 ++++++
 drivers/md/dm-stripe.c         |    6 ++++++
 drivers/md/dm.c                |   10 ++++++----
 drivers/nvdimm/Kconfig         |    1 +
 drivers/s390/block/Kconfig     |    1 +
 include/linux/dax.h            |   30 ++++++++++++++++++++++++------
 10 files changed, 50 insertions(+), 12 deletions(-)
