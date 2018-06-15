From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 0/5] bitmap: Introduce alloc/free helpers
Date: Fri, 15 Jun 2018 16:20:12 +0300
Message-ID: <20180615132017.23889-1-andriy.shevchenko@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Yury Norov <ynorov@caviumnetworks.com>, linux-kernel@vger.kernel.org, mika.westerberg@linux.intel.com
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
List-Id: dm-devel.ids

A lot of code is using allocation of bitmaps using BITS_PER_LONG() macro and
sizeof(unsigned long) operator. The readability suffers because of this.

The series introduces three helpers, i.e. bitmap_alloc(), bitmap_zalloc() and
bitmap_free(), to make it more cleaner.

Patch 1 is a preparatory to avoid namespace collisions between bitmap API and
MD bitmap. No functional changes intended.

Patch 2 is just orphaned from previous release cycle.

Patch 3 introduces new helpers.

Patches 4 and 5 is just an example how to use new helpers. Locally I have like
dozen of them against different subsystems and drivers.

Ideally it would go through Input subsystem, thus, needs an Ack from MD maintainer(s).

Since v2:
 - added namespace fix patch against MD bitmap API
 - moved functions to lib/bitmap.c to avoid circular dependencies
 - appended Dmitry's tags

Andy Shevchenko (5):
  md: Avoid namespace collision with bitmap API
  bitmap: Drop unnecessary 0 check for u32 array operations
  bitmap: Add bitmap_alloc(), bitmap_zalloc() and bitmap_free()
  Input: gpio-keys - Switch to bitmap_zalloc()
  Input: evdev - Switch to bitmap_zalloc()

 drivers/input/evdev.c                         |  16 +-
 drivers/input/keyboard/gpio_keys.c            |   8 +-
 drivers/md/dm-raid.c                          |   6 +-
 drivers/md/md-bitmap.c                        | 301 +++++++++---------
 drivers/md/md-bitmap.h                        |  46 +--
 drivers/md/md-cluster.c                       |  16 +-
 drivers/md/md.c                               |  44 +--
 .../md/persistent-data/dm-space-map-common.c  |   8 +-
 drivers/md/raid1.c                            |  20 +-
 drivers/md/raid10.c                           |  26 +-
 drivers/md/raid5-cache.c                      |   2 +-
 drivers/md/raid5.c                            |  24 +-
 include/linux/bitmap.h                        |   8 +
 lib/bitmap.c                                  |  28 +-
 14 files changed, 281 insertions(+), 272 deletions(-)

-- 
2.17.1
