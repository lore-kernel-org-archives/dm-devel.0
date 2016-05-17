From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper changes for 4.7
Date: Tue, 17 May 2016 13:51:44 -0400
Message-ID: <20160517175143.GA9498@redhat.com>
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
Cc: axboe@kernel.dk, Michal Hocko <mhocko@suse.com>, Heinz Mauelshagen <heinzm@redhat.com>, Eric Engestrom <eric@engestrom.ch>, Amitoj Kaur Chawla <amitoj1606@gmail.com>, dm-devel@redhat.com, Joe Thornber <ejt@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

These DM changes are based ontop of Jens' block 'for-4.7/core'.  I
merged block 'for-4.7/core' because these 4.7 DM changes build on
4.6-rc4 DM changes (albeit minimally) -- yet block 'for-4.7/core' is
based on 4.6-rc3.  If I were to just base my DM 4.7 changes directly on
block's 'for-4.7/core' then DM commit 072623de1f from v4.6-rc4 would
need a post-merge fix to drop the extra 'ti->md' argument from
dm.c:__clone_and_map_data_bio()'s call to free_tio().

Please let me know if you want this situation handled differently now
(and/or in the future).  If not now, then:

The following changes since commit ef1d88ced108df7d652cf3f514b920e661826b71:

  Merge remote-tracking branch 'jens/for-4.7/core' into dm-4.7 (2016-05-05 15:21:14 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm tags/dm-4.7-changes

for you to fetch changes up to 202bae52934d4eb79ffaebf49f49b1cc64d8e40b:

  dm thin: unroll issue_discard() to create longer discard bio chains (2016-05-13 09:04:20 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- based on Jens' 'for-4.7/core' to have DM thinp's discard support use
  bio_inc_remaining() and the block core's new async
  __blkdev_issue_discard() interface

- make DM multipath's fast code-paths lockless, using lockless_deference,
  to significantly improve large NUMA performance when using blk-mq.  The
  m->lock spinlock contention was a serious bottleneck.

- a few other small code cleanups and Documentation fixes

----------------------------------------------------------------
Amitoj Kaur Chawla (1):
      dm thin: Remove return statement from void function

Eric Engestrom (1):
      dm stats: fix spelling mistake in Documentation

Heinz Mauelshagen (1):
      dm raid: make sure no feature flags are set in metadata

Joe Thornber (1):
      dm thin: unroll issue_discard() to create longer discard bio chains

Michal Hocko (1):
      dm ioctl: drop use of __GFP_REPEAT in copy_params()'s __vmalloc() call

Mike Snitzer (8):
      dm: remove unused mapped_device argument from free_tio()
      dm mpath: switch to using bitops for state flags
      dm mpath: use atomic_t for counting members of 'struct multipath'
      dm mpath: move trigger_event member to the end of 'struct multipath'
      dm mpath: eliminate use of spinlock in IO fast-paths
      dm cache: update cache-policies.txt now that mq is an alias for smq
      dm thin: remove __bio_inc_remaining() and switch to using bio_inc_remaining()
      dm thin: use __blkdev_issue_discard for async discard support

 Documentation/device-mapper/cache-policies.txt |  34 ++-
 Documentation/device-mapper/statistics.txt     |   2 +-
 drivers/md/dm-ioctl.c                          |   2 +-
 drivers/md/dm-mpath.c                          | 351 ++++++++++++++-----------
 drivers/md/dm-raid.c                           |   7 +-
 drivers/md/dm-thin.c                           | 165 ++++++------
 drivers/md/dm.c                                |  10 +-
 7 files changed, 298 insertions(+), 273 deletions(-)
