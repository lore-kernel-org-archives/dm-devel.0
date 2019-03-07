From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper changes for 5.1
Date: Thu, 7 Mar 2019 11:24:51 -0500
Message-ID: <20190307162450.GA8985@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Snitzer <snitzer@redhat.com>, Huaisheng Ye <yehs1@lenovo.com>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Chengguang Xu <cgxu519@gmx.com>, Helen Koike <helen.koike@collabora.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, NeilBrown <neil@brown.name>, Alasdair G Kergon <agk@redhat.com>, Jason Cai <jason.cai.kern@gmail.com>
List-Id: dm-devel.ids

Hi Linus,

I had to rebase a couple days ago because I decided to drop the
bio-based DM "noclone" feature that was developed this past development
cycle.  The "noclone" support allowed certain DM targets to work without
requiring bio cloning.  A performance win of ~10% was realized with 512b
bio payloads, on _really_ fast storage, but if the bio payload just
increased to as small as 4K then the improvement was only 1%.  The risk
vs reward trade-off skewed toward too risky at this time given late
breaking reports of Fedora boot hangs on s390 and x86_64 kvm guests for
particular kernel configs.  Persistent memory may warrant revisiting
this line of work in the future but for now it has been tabled.

The following changes since commit 4ae280b4ee3463fa57bbe6eede26b97daff8a0f1:

  dm thin: fix bug where bio that overwrites thin block ignores FUA (2019-02-14 19:02:29 -0500)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.1/dm-changes

for you to fetch changes up to 225557446856448039a9e495da37b72c20071ef2:

  dm integrity: limit the rate of error messages (2019-03-06 09:03:00 -0500)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Update bio-based DM core to always call blk_queue_split() and update
  DM targets to properly advertise discard limits that blk_queue_split()
  looks at when dtermining to split discard.  Whereby allowing DM core's
  own 'split_discard_bios' to be removed.

- Improve DM cache target to provide support for discard passdown to the
  origin device.

- Introduce support to directly boot to a DM mapped device from init by
  using dm-mod.create= module param.  This eliminates the need for an
  elaborate initramfs that is otherwise needed to create DM devices.
  This feature's implementation has been worked on for quite some time
  (got up to v12) and is of particular interest to Android and other
  more embedded platforms (e.g. ARM).

- Rate limit errors from the DM integrity target that were identified as
  the cause for recent NMI hangs due to console limitations.

- Add sanity checks for user input to thin-pool and external snapshot
  creation.

- Remove some unused leftover kmem caches from when old .request_fn
  request-based support was removed.

- Various small cleanups and fixes to targets (e.g. typos, needless
  unlikely() annotations, use struct_size(), remove needless
  .direct_access method from dm-snapshot)

----------------------------------------------------------------
Chengguang Xu (3):
      dm integrity: remove redundant unlikely annotation
      dm verity fec: remove redundant unlikely annotation
      dm block manager: remove redundant unlikely annotation

Gustavo A. R. Silva (1):
      dm switch: use struct_size() in kzalloc()

Helen Koike (1):
      dm: add support to directly boot to a mapped device

Huaisheng Ye (1):
      dm writecache: fix typo in name for writeback_wq

Jason Cai (Xiang Feng) (1):
      dm thin: add sanity checks to thin-pool and external snapshot creation

Mike Snitzer (5):
      dm: update dm_process_bio() to split bio if in ->make_request_fn()
      dm: eliminate 'split_discard_bios' flag from DM target interface
      dm: remove unused _rq_tio_cache and _rq_cache
      dm: always call blk_queue_split() in dm_process_bio()
      dm cache: add support for discard passdown to the origin device

Mikulas Patocka (2):
      dm snapshot: don't define direct_access if we don't support it
      dm integrity: limit the rate of error messages

NeilBrown (1):
      dm: fix to_sector() for 32bit

 Documentation/device-mapper/cache.txt         |   3 +
 Documentation/device-mapper/dm-init.txt       | 114 ++++++++++
 drivers/md/Kconfig                            |  12 +
 drivers/md/Makefile                           |   4 +
 drivers/md/dm-cache-target.c                  | 127 ++++++++---
 drivers/md/dm-init.c                          | 303 ++++++++++++++++++++++++++
 drivers/md/dm-integrity.c                     |  10 +-
 drivers/md/dm-ioctl.c                         | 103 +++++++++
 drivers/md/dm-raid.c                          |  14 +-
 drivers/md/dm-rq.c                            |  16 ++
 drivers/md/dm-rq.h                            |  16 --
 drivers/md/dm-snap.c                          |   8 -
 drivers/md/dm-switch.c                        |   3 +-
 drivers/md/dm-thin.c                          |  14 +-
 drivers/md/dm-verity-fec.c                    |   6 +-
 drivers/md/dm-writecache.c                    |   2 +-
 drivers/md/dm-zoned-target.c                  |   1 -
 drivers/md/dm.c                               | 139 ++++++------
 drivers/md/persistent-data/dm-block-manager.c |   8 +-
 include/linux/device-mapper.h                 |  17 +-
 include/uapi/linux/dm-ioctl.h                 |   4 +-
 21 files changed, 776 insertions(+), 148 deletions(-)
 create mode 100644 Documentation/device-mapper/dm-init.txt
 create mode 100644 drivers/md/dm-init.c
