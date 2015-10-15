From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 00/12] blk-integrity lifetime fixes
Date: Thu, 15 Oct 2015 15:59:39 -0400
Message-ID: <20151015195939.20721.23101.stgit@dwillia2-desk3.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: martin.petersen@oracle.com
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, linux-raid@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, linux-nvdimm@lists.01.org, axboe@fb.com, Vishal Verma <vishal.l.verma@intel.com>, James Bottomley <JBottomley@Odin.com>, NeilBrown <neilb@suse.com>, linux-nvme@lists.infradead.org, Sagi Grimberg <sagig@mellanox.com>, dm-devel@redhat.com, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, hch@lst.de
List-Id: dm-devel.ids

Changes since v1 [1]:
1/ Added a unification of nop profile definitions (Christoph)

2/ Fixed the CONFIG_BLK_DEV_INTEGRITY=n case (Martin)

3/ Folded a fix into "block: Consolidate static integrity profile
   properties", and squahsed the blk_integrity_unregister() removal patches
   into one. (Christoph, Martin)

4/ Collected Acked and Tested -by's from Keith, Neil, Vishal, and Ross

5/ Fixed up Documentation/ABI/testing/sysfs-block to reflect moving
   "integrity" sysfs attributes from "disk" to "disk/queue".

[1]: https://lists.01.org/pipermail/linux-nvdimm/2015-October/002430.html

---

The recent "Block integrity registration update" caused a failing
signature that had been triggering intermittently in the libnvdimm unit
tests to start failing reliably every run.  These tests run through
several blk_integrity configurations and as result exercise the
block-device setup/teardown path.  This is a re-flow of "Block integrity
registration update" with incremental fixes.

Patches apply on Jens' block.git for-4.4/drivers, also available here:

   git://git.kernel.org/pub/scm/linux/kernel/git/djbw/nvdimm for-4.4/blk-integrity

---

Dan Williams (7):
      md, dm, scsi, nvme, libnvdimm: drop blk_integrity_unregister() at shutdown
      md: suspend i/o during runtime blk_integrity_unregister
      nvme: suspend i/o during runtime blk_integrity_unregister
      block: generic request_queue reference counting
      block: move blk_integrity to request_queue
      block: blk_flush_integrity() for bio-based drivers
      block, libnvdimm, nvme: provide a built-in blk_integrity nop profile

Martin K. Petersen (5):
      block: Move integrity kobject to struct gendisk
      block: Consolidate static integrity profile properties
      block: Reduce the size of struct blk_integrity
      block: Export integrity data interval size in sysfs
      block: Inline blk_integrity in struct gendisk


 Documentation/ABI/testing/sysfs-block |   17 ++-
 block/bio-integrity.c                 |   17 ++-
 block/blk-core.c                      |   74 +++++++++++-
 block/blk-integrity.c                 |  199 +++++++++++++++------------------
 block/blk-mq-sysfs.c                  |    6 -
 block/blk-mq.c                        |   80 ++++---------
 block/blk-sysfs.c                     |    7 +
 block/blk.h                           |   22 ++++
 block/partition-generic.c             |    1 
 block/t10-pi.c                        |   16 +--
 drivers/md/dm-table.c                 |   88 ++++++++-------
 drivers/md/dm.c                       |    2 
 drivers/md/md.c                       |   13 +-
 drivers/md/multipath.c                |    2 
 drivers/md/raid1.c                    |    2 
 drivers/md/raid10.c                   |    2 
 drivers/nvdimm/btt.c                  |    1 
 drivers/nvdimm/core.c                 |   21 +--
 drivers/nvme/host/pci.c               |   40 ++-----
 drivers/scsi/sd.c                     |    1 
 drivers/scsi/sd_dif.c                 |   29 +++--
 drivers/target/target_core_iblock.c   |   10 +-
 fs/block_dev.c                        |    2 
 include/linux/blk-mq.h                |    1 
 include/linux/blkdev.h                |   54 ++++-----
 include/linux/genhd.h                 |   25 ++++
 include/linux/t10-pi.h                |    8 +
 27 files changed, 383 insertions(+), 357 deletions(-)
