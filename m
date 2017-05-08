From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v3 00/10] dm: zoned block device support
Date: Mon, 8 May 2017 16:40:42 -0700
Message-ID: <20170508234052.32375-1-bart.vanassche@sandisk.com>
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
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Damien Le Moal <damien.lemoal@wdc.com>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

From: Damien Le Moal <damien.lemoal@wdc.com>

[ Note: I'm resending this patch series on Damien's behalf because Damien's ]
[ e-mails apparently do not reach the dm-devel mailing list - Bart.         ]

This series introduces zoned block device support to the device mapper
infrastructure. Pathces are as follows:

- Patch 1: Add a new target type feature flag to indicate if a target type
  supports host-managed zoned block devices. This prevents using these drives
  with the current target types since none of them have the proper support
  implemented and will not operate properly with these drives.
- Patch 2: If a target device is a zoned block device, check that the range of
  LBAs mapped is aligned to the device zone size and that the device start
  offset also aligns to zone boundaries. This is necessary for zone reset and
  zone report correct execution.
- Patch 3: Check that the different target devices of a table have compatible
  zone sizes and models. This is necessary for target types that expose a zone
  model different from the underlying device.
- Patch 4: Fix handling of REQ_OP_ZONE_RESET bios
- Patch 5: Fix handling of REQ_OP_ZONE_REPORT bios
- Patch 6: Introduce a new helper function to reverse map a device zone report
  to the target LBA range
- Patch 7: Add support for host-managed zoned block devices to dm-flakey. This
  is necessary for testing file systems supporting natively these drives (e.g.
  f2fs).
- Patch 8: Add support for for zoned block devices to dm-linear. This can have
  useful applications during development and testing (e.g. allow creating
  smaller zoned devices with different combinations and positions of zones).
  There are also interesting applications for production, for instance, the
  ability to aggregate conventional zones of different drives to create a
  regular disk.
- Patch 9: Add sequential write enforcement to dm_kcopyd_copy so that
  sequential zones of a host-managed zoned block device can be specified as
  destinations.
- Patch 10: New dm-zoned target type (this was already sent for review twice).
  This resend adds modifications suggested by Hannes to implement reclaim
  using dm-kcopyd. dm-zoned depends on patch 9.

As always, comments and reviews are welcome.

Changes from v2:
- Rebased on 4.12-rc tree
- Added Bart Reviewed-by tag

Changes from v1:
- Use for-loop in patch 3 as suggested by Bart
- Add memory shrinker to dm-zoned to shrink the metadata block cache under
  memory pressure (suggested by Bart)
- Added Hannes Reviewed-by tag

Damien Le Moal (10):
  dm-table: Introduce DM_TARGET_ZONED_HM feature
  dm-table: Check device area zone alignment
  dm-table: Check block devices zone model compatibility
  dm: Fix REQ_OP_ZONE_RESET bio handling
  dm: Fix REQ_OP_ZONE_REPORT bio handling
  dm: Introduce dm_remap_zone_report()
  dm-flakey: Add support for zoned block devices
  dm-linear: Add support for zoned block devices
  dm-kcopyd: Add sequential write feature
  dm-zoned: Drive-managed zoned block device target

 Documentation/device-mapper/dm-zoned.txt |  154 +++
 drivers/md/Kconfig                       |   17 +
 drivers/md/Makefile                      |    2 +
 drivers/md/dm-flakey.c                   |   21 +-
 drivers/md/dm-kcopyd.c                   |   68 +-
 drivers/md/dm-linear.c                   |   15 +-
 drivers/md/dm-table.c                    |  143 ++
 drivers/md/dm-zoned-io.c                 |  999 ++++++++++++++
 drivers/md/dm-zoned-metadata.c           | 2225 ++++++++++++++++++++++++++++++
 drivers/md/dm-zoned-reclaim.c            |  535 +++++++
 drivers/md/dm-zoned.h                    |  530 +++++++
 drivers/md/dm.c                          |   93 +-
 include/linux/device-mapper.h            |   16 +
 include/linux/dm-kcopyd.h                |    1 +
 14 files changed, 4812 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/device-mapper/dm-zoned.txt
 create mode 100644 drivers/md/dm-zoned-io.c
 create mode 100644 drivers/md/dm-zoned-metadata.c
 create mode 100644 drivers/md/dm-zoned-reclaim.c
 create mode 100644 drivers/md/dm-zoned.h

-- 
2.9.3
