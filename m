From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper changes for 5.4
Date: Thu, 19 Sep 2019 17:19:24 -0400
Message-ID: <20190919211923.GA16508@redhat.com>
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
Cc: Nikos Tsironis <ntsironis@arrikto.com>, Huaisheng Ye <yehs1@lenovo.com>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, ZhangXiaoxu <zhangxiaoxu5@huawei.com>, Alasdair G Kergon <agk@redhat.com>, Jaskaran Khurana <jaskarankhurana@linux.microsoft.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 1cfd5d3399e87167b7f9157ef99daa0e959f395d:

  dm table: fix invalid memory accesses with too high sector number (2019-08-23 10:11:42 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.4/dm-changes

for you to fetch changes up to afa179eb603847494aa5061d4f501224a30dd187:

  dm: introduce DM_GET_TARGET_VERSION (2019-09-16 10:18:01 -0400)

Please pull, thanks!
Mike

----------------------------------------------------------------
- crypto and DM crypt advances that allow the crypto API to reclaim
  implementation details that do not belong in DM crypt.  The wrapper
  template for ESSIV generation that was factored out will also be used
  by fscrypt in the future.

- Add root hash pkcs#7 signature verification to the DM verity target.

- Add a new "clone" DM target that allows for efficient remote
  replication of a device.

- Enhance DM bufio's cache to be tailored to each client based on use.
  Clients that make heavy use of the cache get more of it, and those
  that use less have reduced cache usage.

- Add a new DM_GET_TARGET_VERSION ioctl to allow userspace to query the
  version number of a DM target (even if the associated module isn't yet
  loaded).

- Fix invalid memory access in DM zoned target.

- Fix the max_discard_sectors limit advertised by the DM raid target; it
  was mistakenly storing the limit in bytes rather than sectors.

- Small optimizations and cleanups in DM writecache target.

- Various fixes and cleanups in DM core, DM raid1 and space map portion
  of DM persistent data library.

----------------------------------------------------------------
Ard Biesheuvel (4):
      dm crypt: reuse eboiv skcipher for IV generation
      crypto: essiv - create wrapper template for ESSIV generation
      dm crypt: switch to ESSIV crypto API template
      dm crypt: omit parsing of the encapsulated cipher

Gustavo A. R. Silva (2):
      dm raid1: use struct_size() with kzalloc()
      dm stats: use struct_size() helper

Huaisheng Ye (4):
      dm writecache: remove unused member pointer in writeback_struct
      dm writecache: add unlikely for getting two block with same LBA
      dm writecache: optimize performance by sorting the blocks for writeback_all
      dm writecache: skip writecache_wait for pmem mode

Jaskaran Khurana (1):
      dm verity: add root hash pkcs#7 signature verification

Mikulas Patocka (8):
      dm: make dm_table_find_target return NULL
      dm zoned: fix invalid memory access
      dm bufio: call adjust_total_allocated from __link_buffer and __unlink_buffer
      dm bufio: refactor adjust_total_allocated
      dm bufio: introduce a global queue
      dm bufio: remove old-style buffer cleanup
      dm bufio: introduce a global cache replacement
      dm: introduce DM_GET_TARGET_VERSION

Ming Lei (1):
      dm raid: fix updating of max_discard_sectors limit

Nikos Tsironis (1):
      dm: add clone target

ZhangXiaoxu (1):
      dm space map common: remove check for impossible sm_find_free() return value

 .../admin-guide/device-mapper/dm-clone.rst         |  333 +++
 Documentation/admin-guide/device-mapper/verity.rst |    7 +
 crypto/Kconfig                                     |   28 +
 crypto/Makefile                                    |    1 +
 crypto/essiv.c                                     |  663 ++++++
 drivers/md/Kconfig                                 |   27 +
 drivers/md/Makefile                                |    6 +
 drivers/md/dm-bufio.c                              |  192 +-
 drivers/md/dm-clone-metadata.c                     |  964 +++++++++
 drivers/md/dm-clone-metadata.h                     |  158 ++
 drivers/md/dm-clone-target.c                       | 2191 ++++++++++++++++++++
 drivers/md/dm-crypt.c                              |  341 +--
 drivers/md/dm-ioctl.c                              |   34 +-
 drivers/md/dm-raid.c                               |   10 +-
 drivers/md/dm-raid1.c                              |    7 +-
 drivers/md/dm-stats.c                              |    2 +-
 drivers/md/dm-table.c                              |    8 +-
 drivers/md/dm-verity-target.c                      |   43 +-
 drivers/md/dm-verity-verify-sig.c                  |  133 ++
 drivers/md/dm-verity-verify-sig.h                  |   60 +
 drivers/md/dm-verity.h                             |    2 +
 drivers/md/dm-writecache.c                         |   27 +-
 drivers/md/dm-zoned-target.c                       |    2 -
 drivers/md/dm.c                                    |    8 +-
 drivers/md/dm.h                                    |    5 -
 drivers/md/persistent-data/dm-space-map-common.c   |    4 -
 include/uapi/linux/dm-ioctl.h                      |    6 +-
 27 files changed, 4864 insertions(+), 398 deletions(-)
 create mode 100644 Documentation/admin-guide/device-mapper/dm-clone.rst
 create mode 100644 crypto/essiv.c
 create mode 100644 drivers/md/dm-clone-metadata.c
 create mode 100644 drivers/md/dm-clone-metadata.h
 create mode 100644 drivers/md/dm-clone-target.c
 create mode 100644 drivers/md/dm-verity-verify-sig.c
 create mode 100644 drivers/md/dm-verity-verify-sig.h
