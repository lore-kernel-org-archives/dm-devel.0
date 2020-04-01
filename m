From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper changes for 5.7
Date: Wed, 1 Apr 2020 12:57:54 -0400
Message-ID: <20200401165628.GA22107@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-block-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Bob Liu <bob.liu@oracle.com>, Erich Eckner <git@eckner.net>, Mikulas Patocka <mpatocka@redhat.com>, Nikos Tsironis <ntsironis@arrikto.com>, Harshini X Shetty <Harshini.X.Shetty@sony.com>, Yang Yingliang <yangyingliang@huawei.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit fb33c6510d5595144d585aa194d377cf74d31911:

  Linux 5.6-rc6 (2020-03-15 15:01:23 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.7/dm-changes

for you to fetch changes up to 81d5553d1288c2ec0390f02f84d71ca0f0f9f137:

  dm clone metadata: Fix return type of dm_clone_nr_of_hydrated_regions() (2020-03-27 14:42:51 -0400)

Please pull, thanks!
Mike

----------------------------------------------------------------
- Add DM writecache "cleaner" policy feature that allows cache to be
  flushed while userspace monitors for completion to then discommision
  use of caching.

- Optimize DM writecache superblock writing and also yield CPU while
  initializing writecache on large PMEM devices to avoid CPU stalls.

- Various fixes to DM integrity target while preparing for the
  ability to resize a DM integrity device.  In addition to resize
  support, add optional discard support with the "allow_discards"
  feature.

- Fix DM clone target's discard handling and overflow bugs which could
  cause data corruption.

- Fix memory leak in destructor for DM verity FEC support.

- Fix DM zoned target's redundant increment of nr_rnd_zones.

- Small cleanup in DM crypt to use crypt_integrity_aead() helper.

----------------------------------------------------------------
Bob Liu (1):
      dm zoned: remove duplicate nr_rnd_zones increase in dmz_init_zone()

Erich Eckner (1):
      dm integrity: print device name in integrity_metadata() error message

Mikulas Patocka (12):
      dm writecache: do direct write if the cache is full
      dm writecache: implement the "cleaner" policy
      dm writecache: implement gradual cleanup
      dm writecache: optimize superblock write
      dm integrity: fix a crash with unusually large tag size
      dm integrity: remove sector type casts
      dm integrity: don't replay journal data past the end of the device
      dm integrity: factor out get_provided_data_sectors()
      dm integrity: allow resize of the integrity device
      dm integrity: add optional discard support
      dm integrity: improve discard in journal mode
      dm writecache: add cond_resched to avoid CPU hangs

Nikos Tsironis (4):
      dm clone: Fix handling of partial region discards
      dm clone: Add overflow check for number of regions
      dm clone: Add missing casts to prevent overflows and data corruption
      dm clone metadata: Fix return type of dm_clone_nr_of_hydrated_regions()

Shetty, Harshini X (EXT-Sony Mobile) (1):
      dm verity fec: fix memory leak in verity_fec_dtr

Yang Yingliang (1):
      dm crypt: use crypt_integrity_aead() helper

 drivers/md/dm-clone-metadata.c |  15 +-
 drivers/md/dm-clone-metadata.h |   2 +-
 drivers/md/dm-clone-target.c   |  66 ++++++---
 drivers/md/dm-crypt.c          |   6 +-
 drivers/md/dm-integrity.c      | 304 +++++++++++++++++++++++++++++++----------
 drivers/md/dm-verity-fec.c     |   1 +
 drivers/md/dm-writecache.c     | 138 +++++++++++++++++--
 drivers/md/dm-zoned-metadata.c |   1 -
 8 files changed, 431 insertions(+), 102 deletions(-)
