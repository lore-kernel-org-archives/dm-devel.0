From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper changes for 5.6
Date: Wed, 29 Jan 2020 12:17:03 -0500
Message-ID: <20200129171703.GA26110@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-block-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Anatol Pomazau <anatol@google.com>, Bryan Gurney <bgurney@redhat.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>, Heinz Mauelshagen <heinzm@redhat.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, Joe Thornber <ejt@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Milan Broz <gmazyland@gmail.com>, "xianrong.zhou" <xianrong.zhou@transsion.com>, zhengbin <zhengbin13@huawei.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit c79f46a282390e0f5b306007bf7b11a46d529538:

  Linux 5.5-rc5 (2020-01-05 14:23:27 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.6/dm-changes

for you to fetch changes up to 47ace7e012b9f7ad71d43ac9063d335ea3d6820b:

  dm: fix potential for q->make_request_fn NULL pointer (2020-01-27 14:52:36 -0500)

Please pull, thanks!
Mike

----------------------------------------------------------------
- Fix DM core's potential for q->make_request_fn NULL pointer in the
  unlikely case that a DM device is created without a DM table and
  then accessed due to upper-layer userspace code or user error.

- Fix DM thin-provisioning's metadata_pre_commit_callback to not use
  memory after it is free'd.  Also refactor code to disallow changing
  the thin-pool's data device once in use -- doing so guarantees smae
  lifetime of pool's data device relative to the pool metadata.

- Fix DM space maps used by DM thinp and DM cache to avoid reuse of a
  already used block. This race was identified with extremely heavy
  snapshot use in the context of DM thin provisioning.

- Fix DM raid's table status relative to an active rebuild.

- Fix DM crypt to use GFP_NOIO rather than GFP_NOFS in call to
  skcipher_request_alloc(). Also fix benbi IV constructor crash if
  used in authenticated mode.

- Add DM crypt support for Elephant diffuser to allow for Bitlocker
  compatibility.

- Fix DM verity target to not prefetch hash blocks for data that has
  already been verified.

- Fix DM writecache's incorrect flush sequence during commit when in
  SSD mode.

- Improve DM writecache's sequential write performance on SSDs.

- Add DM zoned target support for zone sizes smaller than 128MiB.

- Add DM multipath 'queue_if_no_path_timeout_secs' module param to
  allow timeout if path isn't reinstated. This allows users a kernel
  safety-net against IO hanging indefinitely, due to no active paths,
  that has historically only been provided by multipathd userspace.

- Various DM code cleanups to use true/false rather than 1/0, a
  variable rename in dm-dust, and fix for a math error in comment for
  DM thin metadata's ondisk format.

----------------------------------------------------------------
Anatol Pomazau (1):
      dm mpath: Add timeout mechanism for queue_if_no_path

Bryan Gurney (1):
      dm dust: change ret to r in dust_map_write

Dmitry Fomichev (1):
      dm zoned: support zone sizes smaller than 128MiB

Heinz Mauelshagen (1):
      dm raid: table line rebuild status fixes

Jeffle Xu (1):
      dm thin metadata: Fix trivial math error in on-disk format documentation

Joe Thornber (1):
      dm space map common: fix to ensure new block isn't already in use

Mike Snitzer (3):
      dm thin metadata: use pool locking at end of dm_pool_metadata_close
      dm thin: fix use-after-free in metadata_pre_commit_callback
      dm: fix potential for q->make_request_fn NULL pointer

Mikulas Patocka (5):
      dm crypt: fix GFP flags passed to skcipher_request_alloc()
      dm writecache: fix incorrect flush sequence when doing SSD mode commit
      dm thin: don't allow changing data device during thin-pool reload
      dm thin: change data device's flush_bio to be member of struct pool
      dm writecache: improve performance of large linear writes on SSDs

Milan Broz (2):
      dm crypt: Implement Elephant diffuser for Bitlocker compatibility
      dm crypt: fix benbi IV constructor crash if used in authenticated mode

xianrong.zhou (1):
      dm verity: don't prefetch hash blocks for already-verified data

zhengbin (4):
      dm mpath: use true/false for bool variable
      dm bio prison v2: use true/false for bool variable
      dm snapshot: use true/false for bool variable
      dm thin metadata: use true/false for bool variable

 .../admin-guide/device-mapper/dm-raid.rst          |   2 +
 drivers/md/dm-bio-prison-v2.c                      |   2 +-
 drivers/md/dm-crypt.c                              | 335 ++++++++++++++++++++-
 drivers/md/dm-dust.c                               |   6 +-
 drivers/md/dm-mpath.c                              |  68 ++++-
 drivers/md/dm-raid.c                               |  43 +--
 drivers/md/dm-snap.c                               |   6 +-
 drivers/md/dm-thin-metadata.c                      |  22 +-
 drivers/md/dm-thin.c                               |  36 ++-
 drivers/md/dm-verity-target.c                      |  18 +-
 drivers/md/dm-writecache.c                         |  71 +++--
 drivers/md/dm-zoned-metadata.c                     |  23 +-
 drivers/md/dm.c                                    |   9 +-
 drivers/md/persistent-data/dm-space-map-common.c   |  27 ++
 drivers/md/persistent-data/dm-space-map-common.h   |   2 +
 drivers/md/persistent-data/dm-space-map-disk.c     |   6 +-
 drivers/md/persistent-data/dm-space-map-metadata.c |   5 +-
 17 files changed, 580 insertions(+), 101 deletions(-)
