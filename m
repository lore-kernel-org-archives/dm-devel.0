From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 5.8-rc3
Date: Fri, 26 Jun 2020 15:28:47 -0400
Message-ID: <20200626192847.GA11459@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-block-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Damien Le Moal <damien.lemoal@wdc.com>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Hou Tao <houtao1@huawei.com>, Huaisheng Ye <yehs1@lenovo.com>, Johannes Thumshirn <johannes.thumshirn@wdc.com>, Mauro Carvalho Chehab <mchehab+huawei@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit b3a9e3b9622ae10064826dccb4f7a52bd88c7407:

  Linux 5.8-rc1 (2020-06-14 12:45:04 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.8/dm-fixes

for you to fetch changes up to d35bd764e6899a7bea71958f08d16cea5bfa1919:

  dm writecache: add cond_resched to loop in persistent_memory_claim() (2020-06-19 12:32:24 -0400)

Please pull, thanks!
Mike

----------------------------------------------------------------
- Quite a few DM zoned target fixes and a Zone append fix in DM core.
  Considering the amount of dm-zoned changes that went in during the
  5.8 merge window these fixes are not that surprising.

- A few DM writecache target fixes.

- A fix to Documentation index to include DM ebs target docs.

- Small cleanup to use struct_size() in DM core's retrieve_deps().

----------------------------------------------------------------
Damien Le Moal (2):
      dm zoned: fix uninitialized pointer dereference
      dm zoned: Fix random zone reclaim selection

Gustavo A. R. Silva (1):
      dm ioctl: use struct_size() helper in retrieve_deps()

Hou Tao (1):
      dm zoned: assign max_io_len correctly

Huaisheng Ye (2):
      dm writecache: correct uncommitted_block when discarding uncommitted entry
      dm writecache: skip writecache_wait when using pmem mode

Johannes Thumshirn (1):
      dm: update original bio sector on Zone Append

Mauro Carvalho Chehab (1):
      docs: device-mapper: add dm-ebs.rst to an index file

Mikulas Patocka (1):
      dm writecache: add cond_resched to loop in persistent_memory_claim()

Shin'ichiro Kawasaki (2):
      dm zoned: Fix metadata zone size check
      dm zoned: Fix reclaim zone selection

 Documentation/admin-guide/device-mapper/index.rst |  1 +
 drivers/md/dm-ioctl.c                             |  2 +-
 drivers/md/dm-writecache.c                        | 10 ++++--
 drivers/md/dm-zoned-metadata.c                    | 42 +++++++++++++++++------
 drivers/md/dm-zoned-reclaim.c                     |  4 +--
 drivers/md/dm-zoned-target.c                      |  2 +-
 drivers/md/dm.c                                   | 13 +++++++
 7 files changed, 56 insertions(+), 18 deletions(-)
