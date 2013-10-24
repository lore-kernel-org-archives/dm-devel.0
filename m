From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 00/24] dm cache: proposed changes for v3.13 merge
Date: Thu, 24 Oct 2013 14:30:13 -0400
Message-ID: <1382639437-27007-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com
Cc: Morgan Mears <morgan.mears@netapp.com>, Heinz Mauelshagen <heinzm@redhat.com>, Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

The following patches have been published to the 'for-next' branch of
the device-mapper git repository:
git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git

The patches marked as RFC (19-24) could use the most review.  But all
review would be appreciated.

Thanks,
Mike

Heinz Mauelshagen (11):
  dm cache policy mq: return NULL if mq->free list is empty in alloc_entry
  dm cache policy: variable hints support
  dm cache policy: have policy_writeback_work return -ENODATA by default
  dm cache: use is_write_io() in more places
  dm cache: use cell_defer() boolean argument consistently
  dm cache: log error message if dm_kcopyd_copy() fails
  dm cache: use a boolean when setting cache->quiescing
  dm cache: optimize commit_if_needed
  dm cache: add hints policy
  dm cache: add cache block invalidation API
  dm cache policy era: add cache block invalidation support

Joe Thornber (9):
  dm: nest targets used for testing under DM_TEST_TARGETS
  dm space map disk: optimise sm_disk_dec_block
  dm cache policy: remove return from void policy_remove_mapping
  dm cache policy mq: a few small fixes
  dm cache policy mq: implement writeback_work() and mq_{set,clear}_dirty()
  dm cache: be much more aggressive about promoting writes to discarded blocks
  dm cache metadata: return bool from __superblock_all_zeroes
  dm cache metadata: check the metadata version when reading the superblock
  dm cache: add passthrough mode

Mike Snitzer (1):
  dm table: print error on preresume failure

Morgan Mears (3):
  dm cache: support for stackable caching policies
  dm cache: add era policy shim
  dm cache: add trc policy shim

 drivers/md/Kconfig                             |  68 ++-
 drivers/md/Makefile                            |   9 +-
 drivers/md/dm-cache-metadata.c                 | 189 +++++-
 drivers/md/dm-cache-metadata.h                 |  28 +-
 drivers/md/dm-cache-policy-cleaner.c           |  10 +-
 drivers/md/dm-cache-policy-era.c               | 542 +++++++++++++++++
 drivers/md/dm-cache-policy-hints.c             | 769 +++++++++++++++++++++++++
 drivers/md/dm-cache-policy-internal.h          |  31 +-
 drivers/md/dm-cache-policy-mq.c                | 343 ++++++++---
 drivers/md/dm-cache-policy-trc.c               | 263 +++++++++
 drivers/md/dm-cache-policy.c                   |  66 ++-
 drivers/md/dm-cache-policy.h                   |  77 ++-
 drivers/md/dm-cache-shim-utils.c               | 217 +++++++
 drivers/md/dm-cache-shim-utils.h               |  73 +++
 drivers/md/dm-cache-stack-utils.c              | 239 ++++++++
 drivers/md/dm-cache-stack-utils.h              |  34 ++
 drivers/md/dm-cache-target.c                   | 417 ++++++++++++--
 drivers/md/dm-table.c                          |   5 +-
 drivers/md/persistent-data/dm-space-map-disk.c |  18 +-
 19 files changed, 3167 insertions(+), 231 deletions(-)
 create mode 100644 drivers/md/dm-cache-policy-era.c
 create mode 100644 drivers/md/dm-cache-policy-hints.c
 create mode 100644 drivers/md/dm-cache-policy-trc.c
 create mode 100644 drivers/md/dm-cache-shim-utils.c
 create mode 100644 drivers/md/dm-cache-shim-utils.h
 create mode 100644 drivers/md/dm-cache-stack-utils.c
 create mode 100644 drivers/md/dm-cache-stack-utils.h

-- 
1.8.1.4
