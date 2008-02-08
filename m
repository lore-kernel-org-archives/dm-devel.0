From: Alasdair G Kergon <agk@redhat.com>
Subject: [git pull] device-mapper update for 2.6.25
Date: Fri, 8 Feb 2008 02:45:32 +0000
Message-ID: <20080208024532.GC24157@agk.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1763135AbYBHCrX@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Brian Wood <brian.j.wood@intel.com>, Daniel Walker <dwalker@mvista.com>, Herbert Xu <herbert@gondor.apana.org.au>, Jonathan Brassow <jbrassow@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Milan Broz <mbroz@redhat.com>, Paul Jimenez <pj@place.org>, "Robert P. J. Day" <rpjday@crashcourse.ca>, Vasily Averin <vvs@sw.ru>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Please pull from:

  master.kernel.org:/pub/scm/linux/kernel/git/agk/linux-2.6-dm.git

to get the following device-mapper update for 2.6.25:

Alasdair G Kergon (5):
      dm: mark function lists static
      dm ioctl: remove lock_kernel
      dm: targets no longer experimental
      dm mpath: add missing static
      dm crypt: move queue functions

Andrew Morton (3):
      dm snapshot: use uninitialized_var
      dm: table use uninitialized_var
      dm ioctl: use uninitialized_var

Brian Wood (2):
      dm: stripe trigger event on failure
      dm: stripe enhanced status return

Daniel Walker (1):
      dm: convert suspend_lock semaphore to mutex

Jonathan Brassow (6):
      dm log: auto load modules
      dm raid1: handle write failures
      dm raid1: handle recovery failures
      dm raid1: fix EIO after log failure
      dm raid1: handle read failures
      dm raid1: report fault status

Jun'ichi Nomura (1):
      dm: table remove unused total

Milan Broz (23):
      dm: add missing memory barrier to dm_suspend
      dm ioctl: move compat code
      dm: tidy alloc_dev labels
      dm: refactor deferred bio_list processing
      dm: tidy dm_suspend
      dm: split dm_suspend io_lock hold into two
      dm: refactor dm_suspend completion wait
      dm crypt: move convert_context inside dm_crypt_io
      dm crypt: remove unnecessary crypt_context write parm
      dm crypt: move error setting outside crypt_dec_pending
      dm crypt: tidy crypt_endio
      dm crypt: adjust io processing functions
      dm crypt: store sector mapping in dm_crypt_io
      dm crypt: abstract crypt_write_done
      dm crypt: introduce crypt_write_io_loop
      dm crypt: tidy io ref counting
      dm crypt: extract scatterlist processing
      dm crypt: add async request mempool
      dm crypt: add completion for async
      dm crypt: prepare async callback fn
      dm crypt: use async crypto
      dm: move deferred bio flushing to workqueue
      dm snapshot: combine consecutive exceptions in memory

Paul Jimenez (1):
      dm: table use list_for_each

Robert P. J. Day (1):
      dm snapshot: use rounddown_pow_of_two

Vasily Averin (1):
      dm: table remove unused variable

 drivers/md/Kconfig              |   24 +-
 drivers/md/dm-crypt.c           |  486 +++++++++++++++++++----------
 drivers/md/dm-exception-store.c |    2 +-
 drivers/md/dm-ioctl.c           |   32 ++-
 drivers/md/dm-log.c             |   51 +++-
 drivers/md/dm-mpath.c           |    2 +-
 drivers/md/dm-raid1.c           |  664 +++++++++++++++++++++++++++++++++-----
 drivers/md/dm-snap.c            |   95 ++++--
 drivers/md/dm-snap.h            |   50 +++-
 drivers/md/dm-stripe.c          |  105 ++++++-
 drivers/md/dm-table.c           |   20 +-
 drivers/md/dm.c                 |  238 +++++++++------
 fs/compat_ioctl.c               |   34 --
 include/linux/device-mapper.h   |   18 +-
 include/linux/dm-ioctl.h        |   34 +--
 15 files changed, 1372 insertions(+), 483 deletions(-)

Alasdair
-- 
agk@redhat.com
