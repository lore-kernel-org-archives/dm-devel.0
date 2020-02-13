From: Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: [PATCH v7 0/6] block: Introduce REQ_ALLOCATE flag for
 REQ_OP_WRITE_ZEROES
Date: Thu, 13 Feb 2020 10:39:01 +0300
Message-ID: <158157930219.111879.12072477040351921368.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, bob.liu@oracle.com, axboe@kernel.dk, darrick.wong@oracle.com
Cc: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, song@kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, Chaitanya.Kulkarni@wdc.com, ming.lei@redhat.com, osandov@fb.com, jthumshirn@suse.de, minwoo.im.dev@gmail.com, damien.lemoal@wdc.com, andrea.parri@amarulasolutions.com, hare@suse.com, tj@kernel.org, ajay.joshi@wdc.com, sagi@grimberg.me, dsterba@suse.com, chaitanya.kulkarni@wdc.com, bvanassche@acm.org, dhowells@redhat.com, asml.silence@gmail.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, ktkhai@virtuozzo.com
List-Id: dm-devel.ids

(was "[PATCH block v2 0/3] block: Introduce REQ_NOZERO flag
      for REQ_OP_WRITE_ZEROES operation";
 was "[PATCH RFC 0/3] block,ext4: Introduce REQ_OP_ASSIGN_RANGE
      to reflect extents allocation in block device internals")

v7: Two comments changed.

v6: req_op() cosmetic change.

v5: Kill dm|md patch, which disables REQ_ALLOCATE for these devices.
    Disable REQ_ALLOCATE for all stacking devices instead of this.

v4: Correct argument for mddev_check_write_zeroes().

v3: Rename REQ_NOZERO to REQ_ALLOCATE.
    Split helpers to separate patches.
    Add a patch, disabling max_allocate_sectors inheritance for dm.

v2: Introduce new flag for REQ_OP_WRITE_ZEROES instead of
    introduction a new operation as suggested by Martin K. Petersen.
    Removed ext4-related patch to focus on block changes
    for now.

Information about continuous extent placement may be useful
for some block devices. Say, distributed network filesystems,
which provide block device interface, may use this information
for better blocks placement over the nodes in their cluster,
and for better performance. Block devices, which map a file
on another filesystem (loop), may request the same length extent
on underlining filesystem for less fragmentation and for batching
allocation requests. Also, hypervisors like QEMU may use this
information for optimization of cluster allocations.

This patchset introduces REQ_ALLOCATE flag for REQ_OP_WRITE_ZEROES,
which makes a block device to allocate blocks instead of actual
blocks zeroing. This may be used for forwarding user's fallocate(0)
requests into block device internals. E.g., in loop driver this
will result in allocation extents in backing-file, so subsequent
write won't fail by the reason of no available space. Distributed
network filesystems will be able to assign specific servers for
specific extents, so subsequent write will be more efficient.

Patches [1-3/6] are preparation on helper functions, patch [4/6]
introduces REQ_ALLOCATE flag and implements all the logic,
patch [5/6] adds one more helper, patch [6/6] adds loop
as the first user of the flag.

Note, that here is only block-related patches, example of usage
for ext4 with a performance numbers may be seen in [1].

[1] https://lore.kernel.org/linux-ext4/157599697369.12112.10138136904533871162.stgit@localhost.localdomain/T/#me5bdd5cc313e14de615d81bea214f355ae975db0
---

Kirill Tkhai (6):
      block: Add @flags argument to bdev_write_zeroes_sectors()
      block: Pass op_flags into blk_queue_get_max_sectors()
      block: Introduce blk_queue_get_max_write_zeroes_sectors()
      block: Add support for REQ_ALLOCATE flag
      block: Add blk_queue_max_allocate_sectors()
      loop: Add support for REQ_ALLOCATE


 block/blk-core.c                    |    6 +++---
 block/blk-lib.c                     |   17 ++++++++++-------
 block/blk-merge.c                   |    9 ++++++---
 block/blk-settings.c                |   17 +++++++++++++++++
 drivers/block/loop.c                |   20 +++++++++++++-------
 drivers/md/dm-kcopyd.c              |    2 +-
 drivers/target/target_core_iblock.c |    4 ++--
 fs/block_dev.c                      |    4 ++++
 include/linux/blk_types.h           |    6 ++++++
 include/linux/blkdev.h              |   34 ++++++++++++++++++++++++++--------
 10 files changed, 88 insertions(+), 31 deletions(-)

--
Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Reviewed-by: Bob Liu <bob.liu@oracle.com>
