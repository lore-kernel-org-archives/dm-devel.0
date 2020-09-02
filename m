From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 5.9-rc4
Date: Wed, 2 Sep 2020 14:02:48 -0400
Message-ID: <20200902180248.GA32957@lobo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-block-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Damien Le Moal <damien.lemoal@wdc.com>, Mikulas Patocka <mpatocka@redhat.com>, Ye Bin <yebin10@huawei.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit f75aef392f869018f78cfedf3c320a6b3fcfda6b:

  Linux 5.9-rc3 (2020-08-30 16:01:54 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.9/dm-fixes

for you to fetch changes up to 3a653b205f29b3f9827a01a0c88bfbcb0d169494:

  dm thin metadata: Fix use-after-free in dm_bm_set_read_only (2020-09-02 13:38:40 -0400)

Please pull, thanks!
Mike

----------------------------------------------------------------
- DM writecache fix to allow dax_direct_access() to partitioned pmem
  devices.

- DM multipath fix to avoid any Path Group initialization if
  'pg_init_in_progress' isn't set.

- DM crypt fix to use DECLARE_CRYPTO_WAIT() for onstack wait
  structures.

- DM integrity fix to properly check integrity after device creation
  when in bitmap mode.

- DM thinp and cache target __create_persistent_data_objects() fixes
  to reset the metadata's dm_block_manager pointer from PTR_ERR to
  NULL before returning from error path.

- DM persistent-data block manager fix to guard against
  dm_block_manager NULL pointer dereference in dm_bm_is_read_only()
  and update various opencoded bm->read_only checks to use
  dm_bm_is_read_only() instead.

----------------------------------------------------------------
Damien Le Moal (1):
      dm crypt: Initialize crypto wait structures

Mike Snitzer (1):
      dm mpath: fix racey management of PG initialization

Mikulas Patocka (2):
      dm writecache: handle DAX to partitions on persistent memory correctly
      dm integrity: fix error reporting in bitmap mode after creation

Ye Bin (3):
      dm cache metadata: Avoid returning cmd->bm wild pointer on error
      dm thin metadata:  Avoid returning cmd->bm wild pointer on error
      dm thin metadata: Fix use-after-free in dm_bm_set_read_only

 drivers/md/dm-cache-metadata.c                |  8 ++++++--
 drivers/md/dm-crypt.c                         |  4 ++--
 drivers/md/dm-integrity.c                     | 12 ++++++++++++
 drivers/md/dm-mpath.c                         | 22 +++++++++++++++-------
 drivers/md/dm-thin-metadata.c                 | 10 +++++++---
 drivers/md/dm-writecache.c                    | 12 ++++++++++--
 drivers/md/persistent-data/dm-block-manager.c | 14 ++++++++------
 7 files changed, 60 insertions(+), 22 deletions(-)
