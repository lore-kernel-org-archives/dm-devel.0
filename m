From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 4.2-rc3
Date: Fri, 17 Jul 2015 14:27:33 -0400
Message-ID: <20150717182733.GA830@redhat.com>
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
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Joe Thornber <ejt@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Dennis Yang <shinrairis@gmail.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit d770e558e21961ad6cfdf0ff7df0eb5d7d4f0754:

  Linux 4.2-rc1 (2015-07-05 11:01:52 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm tags/dm-4.2-fixes-2

for you to fetch changes up to 665022d72f9b5762f21b5ea02fa0503d04802849:

  dm cache: avoid calls to prealloc_free_structs() if possible (2015-07-16 22:32:08 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Revert a request-based DM core change that caused IO latency to
  increase and adversely impact both throughput and system load

- Fix for a use after free bug in DM core's device cleanup

- A couple DM btree removal fixes (used by dm-thinp)

- A DM thinp fix for order-5 allocation failure

- A DM thinp fix to not degrade to read-only metadata mode when in
  out-of-data-space mode for longer than the 'no_space_timeout'

- Fix a long-standing oversight in both dm-thinp and dm-cache by
  now exporting 'needs_check' in status if it was set in metadata

- Fix an embarrassing dm-cache busy-loop that caused worker threads to
  eat cpu even if no IO was actively being issued to the cache device

----------------------------------------------------------------
Dennis Yang (1):
      dm btree remove: fix bug in redistribute3

Joe Thornber (2):
      dm thin: allocate the cell_sort_array dynamically
      dm btree: silence lockdep lock inversion in dm_btree_del()

Mike Snitzer (7):
      Revert "dm: only run the queue on completion if congested or no requests pending"
      dm thin: stay in out-of-data-space mode once no_space_timeout expires
      dm thin: display 'needs_check' in status if it is set
      dm cache: display 'needs_check' in status if it is set
      dm cache: do not wake_worker() in free_migration()
      dm cache: avoid preallocation if no work in writeback_some_dirty_blocks()
      dm cache: avoid calls to prealloc_free_structs() if possible

Mikulas Patocka (1):
      dm: fix use after free crash due to incorrect cleanup sequence

 Documentation/device-mapper/cache.txt             |  6 ++++
 Documentation/device-mapper/thin-provisioning.txt |  9 ++++-
 drivers/md/dm-cache-target.c                      | 38 ++++++++++++--------
 drivers/md/dm-thin.c                              | 44 +++++++++++++++++++----
 drivers/md/dm.c                                   | 12 +++----
 drivers/md/persistent-data/dm-btree-remove.c      |  6 ++--
 drivers/md/persistent-data/dm-btree.c             |  2 +-
 7 files changed, 82 insertions(+), 35 deletions(-)
