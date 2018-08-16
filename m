From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper changes for 4.19
Date: Thu, 16 Aug 2018 16:04:31 -0400
Message-ID: <20180816200431.GA31084@redhat.com>
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
Cc: David Jeffery <djeffery@redhat.com>, Kees Cook <keescook@chromium.org>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Hou Tao <houtao1@huawei.com>, Ilya Dryomov <idryomov@gmail.com>, Andy Grover <agrover@redhat.com>, John Pittman <jpittman@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit d72e90f33aa4709ebecc5005562f52335e106a60:

  Linux 4.18-rc6 (2018-07-22 14:12:20 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-4.19/dm-changes

for you to fetch changes up to 1e1132ea21da6d7be92a72195204379c819cb70b:

  dm writecache: fix a crash due to reading past end of dirty_bitmap (2018-08-16 13:43:01 -0400)

Please pull, thanks!
Mike

----------------------------------------------------------------
- A couple stable fixes for the DM writecache target.

- A stable fix for the DM cache target that fixes the potential for data
  corruption after an unclean shutdown of a cache device using writeback
  mode.

- Update DM integrity target to allow the metadata to be stored on a
  separate device from data.

- Fix DM kcopyd and the snapshot target to cond_resched() where
  appropriate and be more efficient with processing completed work.

- A few fixes and improvements for DM crypt.

- Add DM delay target feature to configure delay of flushes independent
  of writes.

- Update DM thin-provisioning target to include metadata_low_watermark
  threshold in pool status.

- Fix stale DM thin-provisioning Documentation.

----------------------------------------------------------------
Andy Grover (1):
      dm thin: include metadata_low_watermark threshold in pool status

David Jeffery (1):
      dm snapshot: improve performance by switching out_of_order_list to rbtree

Hou Tao (1):
      dm thin: stop no_space_timeout worker when switching to write-mode

Ilya Dryomov (1):
      dm cache metadata: set dirty on all cache blocks after a crash

John Pittman (2):
      dm cache: only allow a single io_mode cache feature to be requested
      dm kcopyd: avoid softlockup in run_complete_job

Kees Cook (1):
      dm crypt: convert essiv from ahash to shash

Mike Snitzer (4):
      dm thin: update stale "Status" Documentation
      dm kcopyd: return void from dm_kcopyd_copy()
      dm cache metadata: save in-core policy_hint_size to on-disk superblock
      dm snapshot: remove stale FIXME in snapshot_map()

Mikulas Patocka (15):
      dm delay: refactor repetitive code
      dm delay: add flush as a third class of IO
      dm integrity: change 'suspending' variable from bool to int
      dm integrity: decouple common code in dm_integrity_map_continue()
      dm integrity: implement fair range locks
      dm integrity: report provided data sectors in the status
      dm integrity: add ic->start in get_data_sector()
      dm integrity: allow separate metadata device
      dm integrity: use version 2 for separate metadata
      dm integrity: flush journal on suspend when using separate metadata device
      dm integrity: recalculate checksums on creation
      dm crypt: use wake_up_process() instead of a wait queue
      dm writecache: report start_sector in status line
      dm crypt: don't decrease device limits
      dm writecache: fix a crash due to reading past end of dirty_bitmap

 Documentation/device-mapper/delay.txt             |   3 +-
 Documentation/device-mapper/dm-integrity.txt      |   4 +
 Documentation/device-mapper/thin-provisioning.txt |  20 +-
 drivers/md/dm-cache-metadata.c                    |  13 +-
 drivers/md/dm-cache-target.c                      |  35 +-
 drivers/md/dm-crypt.c                             |  66 ++-
 drivers/md/dm-delay.c                             | 249 +++++------
 drivers/md/dm-integrity.c                         | 501 ++++++++++++++++++----
 drivers/md/dm-kcopyd.c                            |  18 +-
 drivers/md/dm-raid1.c                             |  17 +-
 drivers/md/dm-snap.c                              |  41 +-
 drivers/md/dm-thin.c                              |  31 +-
 drivers/md/dm-writecache.c                        |   8 +-
 drivers/md/dm-zoned-reclaim.c                     |   6 +-
 include/linux/dm-kcopyd.h                         |  12 +-
 15 files changed, 690 insertions(+), 334 deletions(-)
