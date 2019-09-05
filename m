From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v5 0/7] Elevator cleanups and improvements
Date: Thu,  5 Sep 2019 18:51:28 +0900
Message-ID: <20190905095135.26026-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Cc: Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

This patch series implements some cleanup of the elevator initialization
code and introduces elevator features identification and device matching
to enhance checks for elevator/device compatibility and fitness.

The first 2 patches of the series are simple cleanups which simplify 
elevator initialization for newly allocated device queues.

Patch 3 introduce elevator features, allowing a clean and extensible
definition of devices and features that an elevator supports and match
these against features required by a block device. With this, the sysfs
elevator list for a device always shows only elevators matching the
features that a particular device requires, with the exception of the
none elevator which has no features but is always available for use
with any device.

The first feature defined is for zoned block device sequential write
constraint support through zone write locking which prevents the use of
any elevator that does not support this feature with zoned devices.

The last 4 patches of this series rework the default elevator selection
and initialization to allow for the elevator/device features matching
to work, doing so addressing cases not currently well supported, namely,
multi-queue zoned block devices.

Changes from v4:
* Fix patch 5 again to correctly handle request based DM devices and
  avoid that default queue elevator of these devices end up always
  being "none".

Changes from v3:
* Fixed patch 5 to correctly handle DM devices which do not register a
  request queue and so do not need elevator initialization.

Changes from v2:
* Fixed patch 4
* Call elevator_init_mq() earlier in device_add_disk() as suggested by
  Christoph (patch 5)
* Fixed title of patch 7

Changes from v1:
* Addressed Johannes comments
* Rebased on newest for-next branch to include Ming's sysfs lock changes

Damien Le Moal (7):
  block: Cleanup elevator_init_mq() use
  block: Change elevator_init_mq() to always succeed
  block: Introduce elevator features
  block: Improve default elevator selection
  block: Delay default elevator initialization
  block: Set ELEVATOR_F_ZBD_SEQ_WRITE for nullblk zoned disks
  sd: Set ELEVATOR_F_ZBD_SEQ_WRITE for ZBC disks

 block/blk-mq.c                |  20 +++--
 block/blk-settings.c          |  16 ++++
 block/blk.h                   |   2 +-
 block/elevator.c              | 137 ++++++++++++++++++++++++++--------
 block/genhd.c                 |   9 +++
 block/mq-deadline.c           |   1 +
 drivers/block/null_blk_main.c |   2 +
 drivers/md/dm-rq.c            |   2 +-
 drivers/scsi/sd_zbc.c         |   2 +
 include/linux/blk-mq.h        |   3 +-
 include/linux/blkdev.h        |   4 +
 include/linux/elevator.h      |   8 ++
 12 files changed, 161 insertions(+), 45 deletions(-)

-- 
2.21.0
