From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper changes for 4.5
Date: Mon, 11 Jan 2016 15:01:11 -0500
Message-ID: <20160111200111.GA98674@redhat.com>
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
Cc: Mike Snitzer <snitzer@redhat.com>, Anup Limbu <anuplimbu14@gmail.com>, Joe Thornber <ejt@redhat.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Sami Tolvanen <samitolvanen@google.com>, Nikolay Borisov <kernel@kyup.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit ed8b45a3679eb49069b094c0711b30833f27c734:

  dm btree: fix bufio buffer leaks in dm_btree_del() error path (2015-12-10 10:30:18 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm tags/dm-4.5-changes

for you to fetch changes up to 385277bfb57faac44e92497104ba542cdd82d5fe:

  dm snapshot: fix hung bios when copy error occurs (2016-01-08 20:03:05 -0500)

Please pull, thanks!
Mike

----------------------------------------------------------------
- The most significant set of changes this cycle is the Forward Error
  Correction (FEC) support that has been added to the DM verity target.
  Google uses DM verity on all Android devices and it is believed that
  this FEC support will enable DM verity to recover from storage
  failures seen since DM verity was first deployed as part of Android.

- A stable fix for a race in the destruction of DM thin pool's workqueue

- A stable fix for hung IO if a DM snapshot copy hit an error

- A few small cleanups in DM core and DM persistent data.

- A couple DM thinp range discard improvements (address atomicity of
  finding a range and the efficiency of discarding a partially mapped
  thin device)

- Add ability to debug DM bufio leaks by recording stack trace when a
  buffer is allocated.  Upon detected leak the recorded stack is dumped.

----------------------------------------------------------------
Anup Limbu (1):
      dm bufio: use BUG_ON instead of conditional call to BUG

Joe Thornber (2):
      dm thin metadata: speed up discard of partially mapped volumes
      dm thin metadata: make dm_thin_find_mapped_range() atomic

Mike Snitzer (3):
      dm btree: factor out need_insert() helper
      dm space map metadata: remove unused variable in brb_pop()
      dm thin: bump thin and thin-pool target versions

Mikulas Patocka (5):
      dm: don't save and restore bi_private
      dm block manager: cleanup code that prints stacktrace
      dm bufio: return NULL to improve code clarity
      dm bufio: store stacktrace in buffers to help find buffer leaks
      dm snapshot: fix hung bios when copy error occurs

Nikolay Borisov (1):
      dm thin: fix race condition when destroying thin pool workqueue

Sami Tolvanen (7):
      dm verity: clean up duplicate hashing code
      dm verity: separate function for parsing opt args
      dm verity: move dm-verity.c to dm-verity-target.c
      dm verity: factor out structures and functions useful to separate object
      dm verity: factor out verity_for_bv_block()
      dm verity: add support for forward error correction
      dm verity: add ignore_zero_blocks feature

 Documentation/device-mapper/verity.txt             |  40 +-
 drivers/md/Kconfig                                 |  21 +
 drivers/md/Makefile                                |   5 +
 drivers/md/dm-bufio.c                              |  44 +-
 drivers/md/dm-cache-target.c                       |   3 -
 drivers/md/dm-exception-store.h                    |   2 +-
 drivers/md/dm-snap-persistent.c                    |   5 +-
 drivers/md/dm-snap-transient.c                     |   4 +-
 drivers/md/dm-snap.c                               |  26 +-
 drivers/md/dm-thin-metadata.c                      | 114 ++-
 drivers/md/dm-thin.c                               |   8 +-
 drivers/md/dm-verity-fec.c                         | 818 +++++++++++++++++++++
 drivers/md/dm-verity-fec.h                         | 152 ++++
 drivers/md/{dm-verity.c => dm-verity-target.c}     | 602 ++++++++-------
 drivers/md/dm-verity.h                             | 129 ++++
 drivers/md/persistent-data/Kconfig                 |   9 -
 drivers/md/persistent-data/dm-block-manager.c      |  11 +-
 drivers/md/persistent-data/dm-btree.c              |  17 +-
 drivers/md/persistent-data/dm-space-map-metadata.c |   3 -
 19 files changed, 1657 insertions(+), 356 deletions(-)
 create mode 100644 drivers/md/dm-verity-fec.c
 create mode 100644 drivers/md/dm-verity-fec.h
 rename drivers/md/{dm-verity.c => dm-verity-target.c} (69%)
 create mode 100644 drivers/md/dm-verity.h
