From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper changes for 4.6
Date: Wed, 16 Mar 2016 10:21:11 -0400
Message-ID: <20160316142111.GA16256@redhat.com>
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
Cc: "Bryn M. Reeves" <bmr@redhat.com>, dm-devel@redhat.com, Bob Liu <bob.liu@oracle.com>, Joe Thornber <ejt@redhat.com>, DingXiang <dingxiang@huawei.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 4328daa2e79ed904a42ce00a9f38b9c36b44b21a:

  dm: fix dm_rq_target_io leak on faults with .request_fn DM w/ blk-mq paths (2016-02-21 20:27:50 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm tags/dm-4.6-changes

for you to fetch changes up to 98dbc9c6c61698792e3a66f32f3bf066201d42d7:

  dm: fix rq_end_stats() NULL pointer in dm_requeue_original_request() (2016-03-14 17:04:34 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Most attention this cycle went to optimizing blk-mq request-based DM
  (dm-mq) that is used exclussively by DM multipath.

  - A stable fix for dm-mq that eliminates excessive context switching
    offers the biggest performance improvement (for both IOPs and
    throughput).

  - But more work is needed, during the next cycle, to reduce spinlock
    contention in DM multipath on large NUMA systems.

- A stable fix for a NULL pointer seen when DM stats is enabled on a DM
  multipath device that must requeue an IO due to path failure.

- A stable fix for DM snapshot to disallow the COW and origin devices
  from being identical.  This amounts to graceful failure in the face of
  userspace error because these devices shouldn't ever be identical.

- Stable fixes for DM cache and DM thin provisioning to address crashes
  seen if/when their respective metadata device experiences failures
  that cause the transition to 'fail_io' mode.

- The DM cache 'mq' policy is now an alias for the 'smq' policy.  The
  'smq' policy proved to be consistently better than 'mq'.  As such
  'mq', with all its complex user-facing tunables, has been eliminated.

- Improve DM thin provisioning to consistently return -ENOSPC once the
  thin-pool's data volume is out of space.

- Improve DM core to properly handle error propagation if
  bio_integrity_clone() fails in clone_bio().

- Other small cleanups and improvements to DM core.

----------------------------------------------------------------
Bob Liu (1):
      dm: drop unnecessary assignment of md->queue

Bryn M. Reeves (1):
      dm: fix rq_end_stats() NULL pointer in dm_requeue_original_request()

DingXiang (1):
      dm snapshot: disallow the COW and origin devices from being identical

Joe Thornber (3):
      dm cache: make the 'mq' policy an alias for 'smq'
      dm thin metadata: don't issue prefetches if a transaction abort has failed
      dm cache: make sure every metadata function checks fail_io

Mike Snitzer (35):
      dm: do not return target from dm_get_live_table_for_ioctl()
      dm: fix sparse "unexpected unlock" warnings in ioctl code
      dm: fix excessive dm-mq context switching
      dm: remove unused dm_get_rq_mapinfo()
      dm: cleanup dm_any_congested()
      dm: set DM_TARGET_WILDCARD feature on "error" target
      dm: optimize dm_mq_queue_rq()
      dm: optimize dm_request_fn()
      dm: add 'dm_mq_nr_hw_queues' and 'dm_mq_queue_depth' module params
      dm: allocate blk_mq_tag_set rather than embed in mapped_device
      dm: fix a couple locking issues with use of block interfaces
      dm: remove support for stacking dm-mq on .request_fn device(s)
      dm: distinquish old .request_fn (dm-old) vs dm-mq request-based DM
      dm: rename target's per_bio_data_size to per_io_data_size
      dm: allow immutable request-based targets to use blk-mq pdu
      dm mpath: use blk-mq pdu for per-request 'struct dm_mpath_io'
      dm mpath: cleanup 'struct dm_mpath_io' management code
      dm mpath: use blk_mq_alloc_request() and blk_mq_free_request() directly
      dm mpath: remove unnecessary casts in front of ti->private
      dm mpath: remove repeat_count support from multipath core
      dm mpath: push path selector locking down to path selectors
      dm path selector: remove 'repeat_count' return from .select_path hook
      dm round robin: use percpu 'repeat_count' and 'current_path'
      dm mpath: switch from 'unsigned' to 'bool' for flags where appropriate
      dm mpath: remove __pgpath_busy forward declaration, rename to pgpath_busy
      dm mpath: cleanup reinstate_path() et al based on code review
      dm thin metadata: remove needless newline from subtree_dec() DMERR message
      dm: add 'dm_numa_node' module parameter
      dm: remove dummy definition of 'struct dm_table'
      dm: reorder 'struct mapped_device' members to fix alignment and holes
      dm: return error if bio_integrity_clone() fails in clone_bio()
      dm cache policy smq: clarify that mq registration failure was for 'mq'
      dm: add missing newline between DM_DEBUG_BLOCK_STACK_TRACING and DM_BUFIO
      dm cache: bump the target version
      dm thin: consistently return -ENOSPC if pool has run out of data space

 Documentation/device-mapper/cache-policies.txt |   39 +-
 block/blk-core.c                               |    2 +-
 drivers/md/Kconfig                             |   11 +-
 drivers/md/Makefile                            |    2 -
 drivers/md/dm-cache-metadata.c                 |   98 +-
 drivers/md/dm-cache-metadata.h                 |    4 +-
 drivers/md/dm-cache-policy-mq.c                | 1473 ------------------------
 drivers/md/dm-cache-policy-smq.c               |   92 +-
 drivers/md/dm-cache-target.c                   |   16 +-
 drivers/md/dm-crypt.c                          |    2 +-
 drivers/md/dm-delay.c                          |    2 +-
 drivers/md/dm-flakey.c                         |    2 +-
 drivers/md/dm-ioctl.c                          |    5 +-
 drivers/md/dm-log-writes.c                     |    2 +-
 drivers/md/dm-mpath.c                          |  216 ++--
 drivers/md/dm-path-selector.h                  |    5 -
 drivers/md/dm-queue-length.c                   |   37 +-
 drivers/md/dm-raid1.c                          |    2 +-
 drivers/md/dm-round-robin.c                    |   85 +-
 drivers/md/dm-service-time.c                   |   35 +-
 drivers/md/dm-snap.c                           |   11 +-
 drivers/md/dm-table.c                          |   66 +-
 drivers/md/dm-target.c                         |    3 +-
 drivers/md/dm-thin-metadata.c                  |    7 +-
 drivers/md/dm-thin.c                           |   23 +-
 drivers/md/dm-verity-fec.c                     |    2 +-
 drivers/md/dm-verity-target.c                  |   12 +-
 drivers/md/dm.c                                |  600 +++++-----
 drivers/md/dm.h                                |    4 +-
 include/linux/device-mapper.h                  |   15 +-
 30 files changed, 849 insertions(+), 2024 deletions(-)
 delete mode 100644 drivers/md/dm-cache-policy-mq.c
