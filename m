From: Alasdair G Kergon <agk@redhat.com>
Subject: [git pull] device-mapper patches for 2.6.38
Date: Thu, 13 Jan 2011 20:26:34 +0000
Message-ID: <20110113202634.GP28592@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Mike Snitzer <snitzer@redhat.com>, Andi Kleen <ak@linux.intel.com>, Chandra Seetharaman <sekharan@us.ibm.com>, Dan Carpenter <error27@gmail.com>, Jonathan Brassow <jbrassow@redhat.com>, Max Vozeler <max@hinterhof.net>, Mike Anderson <andmike@linux.vnet.ibm.com>, Mike Christie <michaelc@cs.wisc.edu>, NeilBrown <neilb@suse.de>, Nikanth Karthikesan <knikanth@suse.de>, Peter Jones <pjones@redhat.com>, Tejun Heo <tj@kernel.org>, stable@kernel.org, linux-raid@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Milan Broz <mbroz@redhat.com>, Peter Rajnoha <prajnoha@redhat.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Please pull from:

  master.kernel.org:/pub/scm/linux/kernel/git/agk/linux-2.6-dm.git master

to get the following device-mapper fixes and enhancements for inclusion in
2.6.38.

Of particular note are the dm-crypt performance enhancements and the
start made in sharing code between md and dm (raid456).
 
Andi Kleen (1):
      dm crypt: scale to multiple cpus

Chandra Seetharaman (1):
      dm mpath: delay activate_path retry on SCSI_DH_RETRY

Dan Carpenter (1):
      dm log: use PTR_ERR value instead of ENOMEM

Jonathan Brassow (4):
      dm log userspace: trap all failed log construction errors
      dm log userspace: split flush queue
      dm log userspace: group clear and mark requests
      dm log userspace: add version number to comms

Kiyoshi Ueda (1):
      dm: remove superfluous irq disablement in dm_request_fn

Mike Snitzer (4):
      dm: dont take i_mutex to change device size
      dm mpath: disable blk_abort_queue
      dm raid1: support discard
      dm snapshot: avoid storing private suspended state

Mikulas Patocka (2):
      dm io: remove BIO_RW_SYNCIO flag from kcopyd
      dm kcopyd: delay unplugging

Milan Broz (8):
      dm: remove dm_mutex after bkl conversion
      dm crypt: set key size early
      dm crypt: simplify compatible table output
      dm crypt: use io thread for reads only if mempool exhausted
      dm crypt: add post iv call to iv generator
      dm crypt: add multi key capability
      dm crypt: add loop aes iv generator
      dm ioctl: suppress needless warning messages

NeilBrown (3):
      dm: introduce target callbacks and congestion callback
      dm: per target unplug callback support
      dm: raid456 basic support

Peter Jones (1):
      dm ioctl: allow rename to fill empty uuid

Tejun Heo (6):
      dm snapshot: remove unused dm_snapshot queued_bios_work
      dm: dont use flush_scheduled_work
      dm stripe: switch from local workqueue to system_wq
      dm: convert workqueues to alloc_ordered
      dm: use non reentrant workqueues if equivalent
      dm snapshot: persistent make metadata_wq multithreaded

 Documentation/device-mapper/dm-crypt.txt |    7 +-
 Documentation/device-mapper/dm-raid.txt  |   70 +++
 drivers/md/Kconfig                       |   24 +
 drivers/md/Makefile                      |    1 +
 drivers/md/dm-crypt.c                    |  618 ++++++++++++++++++++++-----
 drivers/md/dm-delay.c                    |    2 +-
 drivers/md/dm-ioctl.c                    |  111 ++++--
 drivers/md/dm-kcopyd.c                   |   57 +++-
 drivers/md/dm-log-userspace-base.c       |  139 +++++--
 drivers/md/dm-log-userspace-transfer.c   |    1 +
 drivers/md/dm-log.c                      |    2 +-
 drivers/md/dm-mpath.c                    |   67 ++--
 drivers/md/dm-raid.c                     |  697 ++++++++++++++++++++++++++++++
 drivers/md/dm-raid1.c                    |   19 +-
 drivers/md/dm-snap-persistent.c          |    4 +-
 drivers/md/dm-snap.c                     |   62 +---
 drivers/md/dm-stripe.c                   |   27 +-
 drivers/md/dm-table.c                    |   19 +
 drivers/md/dm.c                          |   23 +-
 include/linux/device-mapper.h            |   12 +
 include/linux/dm-ioctl.h                 |   14 +-
 include/linux/dm-log-userspace.h         |   13 +-
 22 files changed, 1691 insertions(+), 298 deletions(-)
 create mode 100644 Documentation/device-mapper/dm-raid.txt
 create mode 100644 drivers/md/dm-raid.c

Thanks,
Alasdair.
