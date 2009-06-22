From: Alasdair G Kergon <agk@redhat.com>
Subject: [git pull] device-mapper patches for 2.6.31-rc1
Date: Mon, 22 Jun 2009 10:32:28 +0100
Message-ID: <20090622093227.GH5744@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, martin.petersen@oracle.com, Mike Snitzer <snitzer@redhat.com>, Peter Rajnoha <prajnoha@redhat.com>, linux-kernel@vger.kernel.org, Stefan Bader <stefan.bader@canonical.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Please pull from:

  master.kernel.org:/pub/scm/linux/kernel/git/agk/linux-2.6-dm.git master

to get the following device-mapper changes for 2.6.31-rc1:

Alasdair G Kergon (1):
      dm: initialise tio in alloc_tio

Chandra Seetharaman (1):
      dm mpath: call activate fn for each path in pg_init

Hannes Reinecke (1):
      dm mpath: change attached scsi_dh

Jonathan Brassow (1):
      dm exception store: fix exstore lookup to be case insensitive

Jonthan Brassow (2):
      dm table: improve warning message when devices not freed before destruction
      dm raid1: add userspace log

Kiyoshi Ueda (8):
      dm mpath: add start_io and nr_bytes to path selectors
      dm mpath: add queue length load balancer
      dm mpath: add service time load balancer
      dm: prepare for request based option
      dm: enable request based option
      dm: do not set QUEUE_ORDERED_DRAIN if request based
      dm: disable interrupt when taking map_lock
      dm mpath: change to be request based

Mike Snitzer (7):
      dm table: ensure targets are aligned to logical_block_size
      dm table: validate device logical_block_size
      dm table: replace struct io_restrictions with struct queue_limits
      dm table: establish queue limits by copying table limits
      dm target:s introduce iterate devices fn
      dm log: fix create_log_context to use logical_block_size of log device
      dm: calculate queue limits during resume not load

Mikulas Patocka (24):
      dm mpath: validate table argument count
      dm mpath: validate hw_handler argument count
      dm raid1: keep retrying alloc if mempool_alloc failed
      dm mpath: flush keventd queue in destructor
      dm: avoid unsupported spanning of md stripe boundaries
      dm: use i_size_read
      dm: rename suspended_bdev to bdev
      dm: always hold bdev reference
      dm: make dm_flush return void
      dm: process requeue in dm_wq_work
      dm: store only first barrier error
      dm: remove EOPNOTSUPP for barriers
      dm: remove check that prevents mapping empty bios
      dm: introduce num_flush_requests
      dm: send empty barriers to targets in dm_flush
      dm: linear support flush
      dm: stripe support flush
      dm crypt: support flush
      dm delay: support barriers
      dm mpath: support barriers
      dm snapshot: support barriers
      dm io: record eopnotsupp
      dm io: retry after barrier error
      dm snapshot: use barrier when writing exception store

Milan Broz (2):
      dm: sysfs skip output when device is being destroyed
      dm ioctl: support cookies for udev

Peter Rajnoha (1):
      dm: sysfs add suspended attribute

 Documentation/device-mapper/dm-log.txt          |   54 ++
 Documentation/device-mapper/dm-queue-length.txt |   39 +
 Documentation/device-mapper/dm-service-time.txt |   91 ++
 drivers/md/Kconfig                              |   30 +
 drivers/md/Makefile                             |    5 +
 drivers/md/dm-crypt.c                           |   19 +-
 drivers/md/dm-delay.c                           |   26 +-
 drivers/md/dm-exception-store.c                 |    2 +-
 drivers/md/dm-exception-store.h                 |    2 +-
 drivers/md/dm-io.c                              |   14 +-
 drivers/md/dm-ioctl.c                           |   27 +-
 drivers/md/dm-linear.c                          |   15 +-
 drivers/md/dm-log-userspace-base.c              |  696 ++++++++++++++
 drivers/md/dm-log-userspace-transfer.c          |  276 ++++++
 drivers/md/dm-log-userspace-transfer.h          |   18 +
 drivers/md/dm-log.c                             |    9 +-
 drivers/md/dm-mpath.c                           |  334 +++++---
 drivers/md/dm-path-selector.h                   |    8 +-
 drivers/md/dm-queue-length.c                    |  263 ++++++
 drivers/md/dm-raid1.c                           |   17 +-
 drivers/md/dm-region-hash.c                     |    2 +-
 drivers/md/dm-round-robin.c                     |    2 +-
 drivers/md/dm-service-time.c                    |  339 +++++++
 drivers/md/dm-snap-persistent.c                 |    2 +-
 drivers/md/dm-snap.c                            |   11 +
 drivers/md/dm-stripe.c                          |   33 +-
 drivers/md/dm-sysfs.c                           |    9 +
 drivers/md/dm-table.c                           |  465 +++++++---
 drivers/md/dm.c                                 | 1133 ++++++++++++++++++++---
 drivers/md/dm.h                                 |   35 +-
 include/linux/Kbuild                            |    1 +
 include/linux/connector.h                       |    4 +-
 include/linux/device-mapper.h                   |   47 +-
 include/linux/dm-ioctl.h                        |   14 +-
 include/linux/dm-log-userspace.h                |  386 ++++++++
 35 files changed, 3993 insertions(+), 435 deletions(-)
 create mode 100644 Documentation/device-mapper/dm-log.txt
 create mode 100644 Documentation/device-mapper/dm-queue-length.txt
 create mode 100644 Documentation/device-mapper/dm-service-time.txt
 create mode 100644 drivers/md/dm-log-userspace-base.c
 create mode 100644 drivers/md/dm-log-userspace-transfer.c
 create mode 100644 drivers/md/dm-log-userspace-transfer.h
 create mode 100644 drivers/md/dm-queue-length.c
 create mode 100644 drivers/md/dm-service-time.c
 create mode 100644 include/linux/dm-log-userspace.h

Alasdair
-- 
agk@redhat.com
