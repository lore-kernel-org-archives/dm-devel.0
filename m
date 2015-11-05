From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper changes for 4.4
Date: Wed, 4 Nov 2015 20:04:44 -0500
Message-ID: <20151105010444.GA23997@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>, Julia Lawall <Julia.Lawall@lip6.fr>, dm-devel@redhat.com, Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>, Mikulas Patocka <mpatocka@redhat.com>, Christoph Hellwig <hch@lst.de>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

Smaller set of DM changes for this merge.  I've based these changes on
Jens' for-4.4/reservations branch because the associated DM changes
required it.

The following changes since commit a6dd1020d8ac55782f3e04856644cf68765f8c1b:

  nvme: add missing endianess annotations in nvme_pr_command (2015-10-22 09:15:48 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm tags/dm-4.4-changes

for you to fetch changes up to aad9ae4550755edc020b5c511a8b54f0104b2f47:

  dm switch: simplify conditional in alloc_region_table() (2015-10-31 19:06:06 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Revert a dm-multipath change that caused a regression for unprivledged
  users (e.g. kvm guests) that issued ioctls when a multipath device had
  no available paths.

- Include Christoph's refactoring of DM's ioctl handling and add support
  for passing through persistent reservations with DM multipath.

- All other changes are very simple cleanups.

----------------------------------------------------------------
Christoph Hellwig (2):
      dm: refactor ioctl handling
      dm: add support for passing through persistent reservations

Julia Lawall (1):
      dm: drop NULL test before kmem_cache_destroy() and mempool_destroy()

Mauricio Faria de Oliveira (1):
      Revert "dm mpath: fix stalls when handling invalid ioctls"

Mikulas Patocka (4):
      dm: initialize non-blk-mq queue data before queue is used
      dm: convert ffs to __ffs
      dm: eliminate unused "bioset" process for each bio-based DM device
      dm persistent data: eliminate unnecessary return values

Tomohiro Kusumi (5):
      dm linear: remove redundant target name from error messages
      dm delay: Use DM_MAPIO macros instead of open-coded equivalents
      dm delay: capitalize the start of an delay_ctr() error message
      dm delay: document that offsets are specified in sectors
      dm switch: simplify conditional in alloc_region_table()

 Documentation/device-mapper/delay.txt              |   1 +
 drivers/md/dm-bufio.c                              |  18 +-
 drivers/md/dm-cache-metadata.c                     |   8 +-
 drivers/md/dm-cache-policy-cleaner.c               |   2 +-
 drivers/md/dm-cache-policy-mq.c                    |   2 +-
 drivers/md/dm-cache-policy-smq.c                   |   2 +-
 drivers/md/dm-cache-target.c                       |   3 +-
 drivers/md/dm-crypt.c                              |   6 +-
 drivers/md/dm-delay.c                              |   7 +-
 drivers/md/dm-era-target.c                         |  15 +-
 drivers/md/dm-exception-store.c                    |   2 +-
 drivers/md/dm-flakey.c                             |  16 +-
 drivers/md/dm-io.c                                 |   3 +-
 drivers/md/dm-linear.c                             |  20 +-
 drivers/md/dm-log-userspace-base.c                 |   3 +-
 drivers/md/dm-log-writes.c                         |  13 +-
 drivers/md/dm-mpath.c                              |  34 ++--
 drivers/md/dm-region-hash.c                        |   6 +-
 drivers/md/dm-snap-persistent.c                    |   2 +-
 drivers/md/dm-switch.c                             |  25 ++-
 drivers/md/dm-thin-metadata.c                      |  16 +-
 drivers/md/dm-verity.c                             |  15 +-
 drivers/md/dm.c                                    | 209 ++++++++++++++++++---
 drivers/md/persistent-data/dm-array.c              |   4 +-
 drivers/md/persistent-data/dm-block-manager.c      |   4 +-
 drivers/md/persistent-data/dm-block-manager.h      |   2 +-
 drivers/md/persistent-data/dm-btree-internal.h     |   2 +-
 drivers/md/persistent-data/dm-btree-remove.c       |  36 +---
 drivers/md/persistent-data/dm-btree-spine.c        |  20 +-
 drivers/md/persistent-data/dm-btree.c              |   4 +-
 drivers/md/persistent-data/dm-space-map-common.c   |  32 ++--
 .../md/persistent-data/dm-transaction-manager.c    |   4 +-
 .../md/persistent-data/dm-transaction-manager.h    |   2 +-
 include/linux/device-mapper.h                      |   6 +-
 include/uapi/linux/dm-ioctl.h                      |   4 +-
 35 files changed, 333 insertions(+), 215 deletions(-)
