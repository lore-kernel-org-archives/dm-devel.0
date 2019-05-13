From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper changes for 5.2
Date: Mon, 13 May 2019 14:59:48 -0400
Message-ID: <20190513185948.GA26710@redhat.com>
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
Cc: Damien Le Moal <damien.lemoal@wdc.com>, YueHaibing <yuehaibing@huawei.com>, Mike Snitzer <snitzer@redhat.com>, Huaisheng Ye <yehs1@lenovo.com>, Nikos Tsironis <ntsironis@arrikto.com>, Peng Wang <rocking@whu.edu.cn>, Helen Koike <helen.koike@collabora.com>, Martin Wilck <mwilck@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Dan Carpenter <dan.carpenter@oracle.com>, Colin Ian King <colin.king@canonical.com>, Yufen Yu <yuyufen@huawei.com>, Christoph Hellwig <hch@lst.de>, Alasdair G Kergon <agk@redhat.com>, Bryan Gurney <bgurney@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit dc4060a5dc2557e6b5aa813bf5b73677299d62d2:

  Linux 5.1-rc5 (2019-04-14 15:17:41 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.2/dm-changes

for you to fetch changes up to 05d6909ea9d62bb357846177a84842e09fc15914:

  dm integrity: whitespace, coding style and dead code cleanup (2019-05-09 16:00:31 -0400)

----------------------------------------------------------------
- Improve DM snapshot target's scalability by using finer grained
  locking.  Requires some list_bl interface improvements.

- Add ability for DM integrity to use a bitmap mode, that tracks regions
  where data and metadata are out of sync, instead of using a journal.

- Improve DM thin provisioning target to not write metadata changes to
  disk if the thin-pool and associated thin devices are merely
  activated but not used.  This avoids metadata corruption due to
  concurrent activation of thin devices across different OS instances
  (e.g. split brain scenarios, which ultimately would be avoided if
  proper device filters were used -- but not having proper filtering has
  proven a very common configuration mistake)

- Fix missing call to path selector type->end_io in DM multipath.  This
  fixes reported performance problems due to inaccurate path selector IO
  accounting causing an imbalance of IO (e.g. avoiding issuing IO to
  particular path due to it seemingly being heavily used).

- Fix bug in DM cache metadata's loading of its discard bitset that
  could lead to all cache blocks being discarded if the very first cache
  block was discarded (thankfully in practice the first cache block is
  generally in use; be it FS superblock, partition table, disk label,
  etc).

- Add testing-only DM dust target which simulates a device that has
  failing sectors and/or read failures.

- Various small fixes to DM init, DM multipath, DM zoned, and DM crypt.

----------------------------------------------------------------
Bryan Gurney (1):
      dm: add dust target

Christoph Hellwig (1):
      dm crypt: fix endianness annotations around org_sector_of_dmreq

Colin Ian King (1):
      dm dust: remove redundant unsigned comparison to less than zero

Damien Le Moal (1):
      dm zoned: Fix zone report handling

Dan Carpenter (1):
      dm zoned: Silence a static checker warning

Helen Koike (1):
      dm init: fix max devices/targets checks

Huaisheng Ye (3):
      dm writecache: remove needless dereferences in __writecache_writeback_pmem()
      dm writecache: add unlikely for returned value of rb_next/prev
      dm writecache: remove unused member page_offset in writeback_struct

Martin Wilck (1):
      dm mpath: always free attached_handler_name in parse_path()

Mike Snitzer (5):
      dm space map common: zero entire ll_disk
      dm thin metadata: check __commit_transaction()'s return
      dm thin metadata: add wrappers for managing write locking of metadata
      dm thin metadata: do not write metadata if no changes occurred
      dm integrity: whitespace, coding style and dead code cleanup

Mikulas Patocka (13):
      dm delay: fix a crash when invalid device is specified
      dm writecache: avoid unnecessary lookups in writecache_find_entry()
      dm integrity: correctly calculate the size of metadata area
      dm integrity: don't check null pointer before kvfree and vfree
      dm integrity: don't report unused options
      dm integrity: update documentation
      dm integrity: introduce rw_journal_sectors()
      dm ingerity: pass size to dm_integrity_alloc_page_list()
      dm integrity: allow large ranges to be described
      dm integrity: introduce a function add_new_range_and_wait()
      dm integrity: add a bitmap mode
      dm integrity: handle machine reboot in bitmap mode
      dm integrity: implement synchronous mode for reboot handling

Nikos Tsironis (7):
      dm cache metadata: Fix loading discard bitset
      list: Don't use WRITE_ONCE() in hlist_add_behind()
      list_bl: Add hlist_bl_add_before/behind helpers
      dm snapshot: Don't sleep holding the snapshot lock
      dm snapshot: Replace mutex with rw semaphore
      dm snapshot: Make exception tables scalable
      dm snapshot: Use fine-grained locking scheme

Peng Wang (1):
      dm: only initialize md->dax_dev if CONFIG_DAX_DRIVER is enabled

YueHaibing (1):
      dm dust: Make dm_dust_init and dm_dust_exit static

Yufen Yu (1):
      dm mpath: fix missing call of path selector type->end_io

 Documentation/device-mapper/dm-dust.txt          | 272 +++++++++
 Documentation/device-mapper/dm-integrity.txt     |  32 +-
 drivers/md/Kconfig                               |   9 +
 drivers/md/Makefile                              |   1 +
 drivers/md/dm-cache-metadata.c                   |   9 +-
 drivers/md/dm-crypt.c                            |   8 +-
 drivers/md/dm-delay.c                            |   3 +-
 drivers/md/dm-dust.c                             | 515 ++++++++++++++++
 drivers/md/dm-exception-store.h                  |   3 +-
 drivers/md/dm-init.c                             |   8 +-
 drivers/md/dm-integrity.c                        | 717 ++++++++++++++++++++---
 drivers/md/dm-mpath.c                            |  19 +-
 drivers/md/dm-rq.c                               |   8 +-
 drivers/md/dm-snap.c                             | 359 ++++++++----
 drivers/md/dm-target.c                           |   3 +-
 drivers/md/dm-thin-metadata.c                    | 139 +++--
 drivers/md/dm-writecache.c                       |  29 +-
 drivers/md/dm-zoned-metadata.c                   |   5 +
 drivers/md/dm-zoned-target.c                     |   3 +-
 drivers/md/dm.c                                  |   6 +-
 drivers/md/persistent-data/dm-space-map-common.c |   2 +
 include/linux/device-mapper.h                    |   3 +-
 include/linux/list.h                             |   2 +-
 include/linux/list_bl.h                          |  26 +
 24 files changed, 1895 insertions(+), 286 deletions(-)
 create mode 100644 Documentation/device-mapper/dm-dust.txt
 create mode 100644 drivers/md/dm-dust.c
