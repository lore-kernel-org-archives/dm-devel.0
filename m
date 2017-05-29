From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 0/4] dm: zoned block device fixes
Date: Mon, 29 May 2017 19:23:03 +0900
Message-ID: <20170529102307.19814-1-damien.lemoal@wdc.com>
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
Cc: Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

Mike,

The first 3 patches of this series are incremental fixes for the zoned block
device support patches that you committed to the for-4.13/dm branch.

The first patch correct the zone alignement checks so that the check is
performed for any device, regardless of the device LBA size (it is skipped for
512B LBA devices otherwise).

The second patch is a fix for commit baf844bf4ae3 "dm table: add zoned block
devices validation". In that commit, the stacked limits zoned model was not
set to the zoned model of the table target devices, leading to the exposed
device always being exposed as a regular block device. With this fix, dm-flaky
and dm-linear work fine on top of host-managed  zoned block devices.

The third patch fixes zoned model validation again to allow for target types
emulating a different zoned model than the model of the table target devices,
e.g. dm-zoned.

The last patch is dm-zoned with various fixes (mainly crashes on setup error
and handling of the metadata cache shrinker). For your review, please use this
version.

Thank you.

Best regards.

Damien Le Moal (4):
  dm: Fix mapping zone alignment check
  dm: Fix staking limits for zoned block device
  dm: Fix zoned block device model validation
  dm-zoned: Drive-managed zoned block device target

 Documentation/device-mapper/dm-zoned.txt |  154 +++
 drivers/md/Kconfig                       |   17 +
 drivers/md/Makefile                      |    2 +
 drivers/md/dm-table.c                    |  190 +--
 drivers/md/dm-zoned-io.c                 | 1007 ++++++++++++++
 drivers/md/dm-zoned-metadata.c           | 2220 ++++++++++++++++++++++++++++++
 drivers/md/dm-zoned-reclaim.c            |  535 +++++++
 drivers/md/dm-zoned.h                    |  530 +++++++
 8 files changed, 4560 insertions(+), 95 deletions(-)
 create mode 100644 Documentation/device-mapper/dm-zoned.txt
 create mode 100644 drivers/md/dm-zoned-io.c
 create mode 100644 drivers/md/dm-zoned-metadata.c
 create mode 100644 drivers/md/dm-zoned-reclaim.c
 create mode 100644 drivers/md/dm-zoned.h

-- 
2.9.4

Western Digital Corporation (and its subsidiaries) E-mail Confidentiality Notice & Disclaimer:

This e-mail and any files transmitted with it may contain confidential or legally privileged information of WDC and/or its affiliates, and are intended solely for the use of the individual or entity to which they are addressed. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited. If you have received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.
