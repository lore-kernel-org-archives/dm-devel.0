From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper changes for 5.5
Date: Fri, 22 Nov 2019 10:37:47 -0500
Message-ID: <20191122153747.GA23143@redhat.com>
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
Content-Disposition: inline
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nikos Tsironis <ntsironis@arrikto.com>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>, Heinz Mauelshagen <heinzm@redhat.com>, Krzysztof Kozlowski <krzk@kernel.org>, linux-block@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, Nathan Chancellor <natechancellor@gmail.com>, Maged Mokhtar <mmokhtar@petasan.org>, Alasdair G Kergon <agk@redhat.com>, Bryan Gurney <bgurney@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit a99d8080aaf358d5d23581244e5da23b35e340b9:

  Linux 5.4-rc6 (2019-11-03 14:07:26 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.5/dm-changes

for you to fetch changes up to f612b2132db529feac4f965f28a1b9258ea7c22b:

  Revert "dm crypt: use WQ_HIGHPRI for the IO and crypt workqueues" (2019-11-20 17:27:39 -0500)

Please pull, thanks!
Mike

----------------------------------------------------------------
- Fix DM core to disallow stacking request-based DM on partitions.

- Fix DM raid target to properly resync raidset even if bitmap needed
  additional pages.

- Fix DM crypt performance regression due to use of WQ_HIGHPRI for the
  IO and crypt workqueues.

- Fix DM integrity metadata layout that was aligned on 128K boundary
  rather than the intended 4K boundary (removes 124K of wasted space for
  each metadata block).

- Improve the DM thin, cache and clone targets to use spin_lock_irq
  rather than spin_lock_irqsave where possible.

- Fix DM thin single thread performance that was lost due to needless
  workqueue wakeups.

- Fix DM zoned target performance that was lost due to excessive backing
  device checks.

- Add ability to trigger write failure with the DM dust test target.

- Fix whitespace indentation in drivers/md/Kconfig.

- Various smalls fixes and cleanups (e.g. use struct_size, fix
  uninitialized variable, variable renames, etc).

----------------------------------------------------------------
Bryan Gurney (3):
      dm dust: change result vars to r
      dm dust: change ret to r in dust_map_read and dust_map
      dm dust: add limited write failure mode

Dmitry Fomichev (1):
      dm zoned: reduce overhead of backing device checks

Gustavo A. R. Silva (1):
      dm stripe: use struct_size() in kmalloc()

Heinz Mauelshagen (4):
      dm raid: change rs_set_dev_and_array_sectors API and callers
      dm raid: to ensure resynchronization, perform raid set grow in preresume
      dm raid: simplify rs_setup_recovery call chain
      dm raid: streamline rs_get_progress() and its raid_status() caller side

Jeffle Xu (1):
      dm thin: wakeup worker only when deferred bios exist

Krzysztof Kozlowski (1):
      dm: Fix Kconfig indentation

Maged Mokhtar (1):
      dm writecache: handle REQ_FUA

Mike Snitzer (2):
      dm table: do not allow request-based DM to stack on partitions
      Revert "dm crypt: use WQ_HIGHPRI for the IO and crypt workqueues"

Mikulas Patocka (6):
      dm writecache: fix uninitialized variable warning
      dm clone: replace spin_lock_irqsave with spin_lock_irq
      dm thin: replace spin_lock_irqsave with spin_lock_irq
      dm bio prison: replace spin_lock_irqsave with spin_lock_irq
      dm cache: replace spin_lock_irqsave with spin_lock_irq
      dm integrity: fix excessive alignment of metadata runs

Nathan Chancellor (1):
      dm raid: Remove unnecessary negation of a shift in raid10_format_to_md_layout

Nikos Tsironis (1):
      dm clone: add bucket_lock_irq/bucket_unlock_irq helpers

 .../admin-guide/device-mapper/dm-integrity.rst     |   5 +
 .../admin-guide/device-mapper/dm-raid.rst          |   2 +
 drivers/md/Kconfig                                 |  54 +++----
 drivers/md/dm-bio-prison-v1.c                      |  27 ++--
 drivers/md/dm-bio-prison-v2.c                      |  26 ++--
 drivers/md/dm-cache-target.c                       |  77 ++++------
 drivers/md/dm-clone-metadata.c                     |  29 ++--
 drivers/md/dm-clone-metadata.h                     |   4 +-
 drivers/md/dm-clone-target.c                       |  62 ++++----
 drivers/md/dm-crypt.c                              |   9 +-
 drivers/md/dm-dust.c                               |  97 ++++++++----
 drivers/md/dm-integrity.c                          |  28 +++-
 drivers/md/dm-raid.c                               | 164 +++++++++++----------
 drivers/md/dm-stripe.c                             |  15 +-
 drivers/md/dm-table.c                              |  27 +---
 drivers/md/dm-thin.c                               | 118 +++++++--------
 drivers/md/dm-writecache.c                         |   5 +-
 drivers/md/dm-zoned-metadata.c                     |  29 ++--
 drivers/md/dm-zoned-reclaim.c                      |   8 +-
 drivers/md/dm-zoned-target.c                       |  54 +++++--
 drivers/md/dm-zoned.h                              |   2 +
 include/linux/device-mapper.h                      |   3 -
 22 files changed, 433 insertions(+), 412 deletions(-)
