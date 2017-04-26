From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 00/13] Device mapper and dm-mpath patches
Date: Wed, 26 Apr 2017 11:37:15 -0700
Message-ID: <20170426183728.10821-1-bart.vanassche@sandisk.com>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hello Mike,

The patches in this series are:
* A few fixes for bugs in the dm-mpath driver I ran into while testing
  this driver.
* A resend of various dm / dm-mpath patches I had posted before but
  for which I'm still waiting for a review from you.

Please consider at least the dm-mpath bug fixes for kernel v4.12.

Thanks,

Bart.

Bart Van Assche (13):
  dm-mpath: Split activate_path()
  dm-mpath: Avoid that path removal can trigger an infinite loop
  dm-mpath: Delay requeuing while path initialization is in progress
  dm-rq: Adjust requeuing delays
  dm-mpath: Make it easier to analyze requeuing behavior
  dm-rq: Check blk_mq_register_dev() return value
  dm, persistence: Remove an unused argument from
    dm_block_manager_create()
  dm: Verify suspend_locking assumptions at runtime
  dm-mpath: Verify locking assumptions at runtime
  dm: Introduce enum dm_queue_mode
  dm-mpath: Micro-optimize the hot path
  dm-mpath: Introduce assign_bit()
  dm, dm-mpath: Make it easier to detect unintended I/O request flushes

 drivers/md/dm-cache-metadata.c                |   3 -
 drivers/md/dm-core.h                          |   2 +-
 drivers/md/dm-era-target.c                    |   2 -
 drivers/md/dm-ioctl.c                         |   2 +-
 drivers/md/dm-mpath.c                         | 187 +++++++++++++-------------
 drivers/md/dm-rq.c                            |  15 ++-
 drivers/md/dm-table.c                         |  18 ++-
 drivers/md/dm-thin-metadata.c                 |   2 -
 drivers/md/dm.c                               |  26 ++--
 drivers/md/dm.h                               |  12 +-
 drivers/md/persistent-data/dm-block-manager.c |   1 -
 drivers/md/persistent-data/dm-block-manager.h |   2 +-
 include/linux/device-mapper.h                 |  14 +-
 13 files changed, 148 insertions(+), 138 deletions(-)

-- 
2.12.2
