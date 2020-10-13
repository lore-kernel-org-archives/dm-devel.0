From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper changes for 5.10
Date: Tue, 13 Oct 2020 11:40:00 -0400
Message-ID: <20201013154000.GA53766@lobo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Sender: Mike Snitzer <snitzer@gmail.com>
Content-Disposition: inline
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Huaisheng Ye <yehs1@lenovo.com>, Mike Snitzer <snitzer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Qinglang Miao <miaoqinglang@huawei.com>
List-Id: dm-devel.ids

Hi Linus,

This pull's changes depend on various linux-block changes (as noted in
the refernced merge commit's header).

The following changes since commit 1471308fb5ec4335f9ae9fc65f65048dbe7c336e:

  Merge remote-tracking branch 'jens/for-5.10/block' into dm-5.10 (2020-09-29 16:31:35 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.10/dm-changes

for you to fetch changes up to 681cc5e8667e8579a2da8fa4090c48a2d73fc3bb:

  dm: fix request-based DM to not bounce through indirect dm_submit_bio (2020-10-07 18:08:51 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Improve DM core's bio splitting to use blk_max_size_offset(). Also
  fix bio splitting for bios that were deferred to the worker thread
  due to a DM device being suspended.

- Remove DM core's special handling of NVMe devices now that block
  core has internalized efficiencies drivers previously needed to
  be concerned about (via now removed direct_make_request).

- Fix request-based DM to not bounce through indirect dm_submit_bio;
  instead have block core make direct call to blk_mq_submit_bio().

- Various DM core cleanups to simplify and improve code.

- Update DM cryot to not use drivers that set
  CRYPTO_ALG_ALLOCATES_MEMORY.

- Fix DM raid's raid1 and raid10 discard limits for the purposes of
  linux-stable. But then remove DM raid's discard limits settings now
  that MD raid can efficiently handle large discards.

- A couple small cleanups across various targets.

----------------------------------------------------------------
Huaisheng Ye (1):
      dm thin metadata: Remove unused local variable when create thin and snap

Mike Snitzer (17):
      dm table: stack 'chunk_sectors' limit to account for target-specific splitting
      dm: change max_io_len() to use blk_max_size_offset()
      dm: push md->immutable_target optimization down to __process_bio()
      dm: optimize max_io_len() by inlining max_io_len_target_boundary()
      dm: push use of on-stack flush_bio down to __send_empty_flush()
      dm: simplify __process_abnormal_io()
      dm: eliminate need for start_io_acct() forward declaration
      dm table: make 'struct dm_table' definition accessible to all of DM core
      dm: use dm_table_get_device_name() where appropriate in targets
      dm raid: fix discard limits for raid1 and raid10
      dm raid: remove unnecessary discard limits for raid10
      dm: fix missing imposition of queue_limits from dm_wq_work() thread
      dm: fold dm_process_bio() into dm_submit_bio()
      dm: fix comment in __dm_suspend()
      dm: export dm_copy_name_and_uuid
      dm: remove special-casing of bio-based immutable singleton target on NVMe
      dm: fix request-based DM to not bounce through indirect dm_submit_bio

Mikulas Patocka (1):
      dm crypt: don't use drivers that have CRYPTO_ALG_ALLOCATES_MEMORY

Qinglang Miao (1):
      dm snap persistent: simplify area_io()

 block/blk-mq.c                        |   1 -
 drivers/md/dm-cache-target.c          |   2 +-
 drivers/md/dm-core.h                  |  56 ++++-
 drivers/md/dm-crypt.c                 |  17 +-
 drivers/md/dm-ioctl.c                 |   2 +-
 drivers/md/dm-mpath.c                 |  16 +-
 drivers/md/dm-raid.c                  |   9 -
 drivers/md/dm-rq.c                    |   2 +-
 drivers/md/dm-snap-persistent.c       |  11 +-
 drivers/md/dm-table.c                 |  84 +------
 drivers/md/dm-thin-metadata.c         |   6 +-
 drivers/md/dm.c                       | 404 +++++++++++-----------------------
 drivers/md/dm.h                       |   3 -
 drivers/md/persistent-data/dm-btree.c |   3 +-
 include/linux/device-mapper.h         |   1 -
 include/uapi/linux/dm-ioctl.h         |   4 +-
 16 files changed, 224 insertions(+), 397 deletions(-)
