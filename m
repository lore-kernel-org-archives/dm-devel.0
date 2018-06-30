From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v4 0/5] bitmap: Introduce alloc/free helpers
Date: Sat, 30 Jun 2018 23:17:45 +0300
Message-ID: <20180630201750.2588-1-andriy.shevchenko@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Yury Norov <ynorov@caviumnetworks.com>, linux-kernel@vger.kernel.org, mika.westerberg@linux.intel.com, Joe Perches <joe@perches.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
List-Id: dm-devel.ids

A lot of code is using allocation of bitmaps using BITS_PER_LONG() macro and
sizeof(unsigned long) operator. The readability suffers because of this.

The series introduces three helpers, i.e. bitmap_alloc(), bitmap_zalloc() and
bitmap_free(), to make it more cleaner.

Patches 1 and 2 are preparatory to avoid namespace collisions between
bitmap API and DM / MD bitmap. No functional changes intended.

Patch 3 introduces new helpers.

Patches 4 and 5 is just an example how to use new helpers. Locally I have
like dozen of them against different subsystems and drivers.

Taking above into consideration it might make sense to have
an immutable branch for this cycle.

Ideally it would go through Input subsystem, thus, needs an Ack
from MD / DM maintainer(s).

Since v3:
- split DM part and do rename accordingly (Mike)
- explain better in the commit message why we can't make helpers as
  inliners (Dmitry, Andrew)
- drop applied orphaned patch

Since v2:
- fix compilation issue in MD bitmap code
- elaborate changes in commit message of patch 5

Since v1:
- added namespace fix patch against MD bitmap API
- moved functions to lib/bitmap.c to avoid circular dependencies
- appended Dmitry's tags

Andy Shevchenko (5):
  dm: Avoid namespace collision with bitmap API
  md: Avoid namespace collision with bitmap API
  bitmap: Add bitmap_alloc(), bitmap_zalloc() and bitmap_free()
  Input: gpio-keys - Switch to bitmap_zalloc()
  Input: evdev - Switch to bitmap API

 drivers/input/evdev.c                         |  16 +-
 drivers/input/keyboard/gpio_keys.c            |   8 +-
 drivers/md/dm-raid.c                          |   6 +-
 drivers/md/md-bitmap.c                        | 305 +++++++++---------
 drivers/md/md-bitmap.h                        |  60 ++--
 drivers/md/md-cluster.c                       |  18 +-
 drivers/md/md.c                               |  44 +--
 .../md/persistent-data/dm-space-map-common.c  |  20 +-
 drivers/md/raid1.c                            |  35 +-
 drivers/md/raid10.c                           |  52 ++-
 drivers/md/raid5-cache.c                      |   8 +-
 drivers/md/raid5.c                            |  44 +--
 include/linux/bitmap.h                        |   8 +
 lib/bitmap.c                                  |  19 ++
 14 files changed, 326 insertions(+), 317 deletions(-)

-- 
2.18.0
