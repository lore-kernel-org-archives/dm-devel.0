From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 0/4] dm and bcache refcount conversions
Date: Fri, 20 Oct 2017 10:37:35 +0300
Message-ID: <1508485059-21881-1-git-send-email-elena.reshetova@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, kent.overstreet@gmail.com, koverstreet@google.com, ejt@redhat.comg, snitzer@redhat.com, shli@kernel.org, agk@redhat.com, peterz@infradead.org, keescook@chromium.org, Elena Reshetova <elena.reshetova@intel.com>
List-Id: dm-devel.ids

This series, for dm and bcache parts, replaces atomic_t reference
counters with the new refcount_t type and API (see include/linux/refcount.h).
By doing this we prevent intentional or accidental
underflows or overflows that can led to use-after-free vulnerabilities.

The patches are fully independent and can be cherry-picked separately.
Patches are based on top of linux-next as of yesterday.
If there are no objections to the patches, please merge them via respective trees

Elena Reshetova (4):
  bcache: convert cached_dev.count from atomic_t to refcount_t
  dm cache: convert dm_cache_metadata.ref_count from atomic_t to
    refcount_t
  dm: convert dm_dev_internal.count from atomic_t to refcount_t
  dm: convert table_device.count from atomic_t to refcount_t

 drivers/md/bcache/bcache.h     |  7 ++++---
 drivers/md/bcache/super.c      |  6 +++---
 drivers/md/bcache/writeback.h  |  2 +-
 drivers/md/dm-cache-metadata.c |  9 +++++----
 drivers/md/dm-table.c          |  6 +++---
 drivers/md/dm.c                | 12 +++++++-----
 drivers/md/dm.h                |  3 ++-
 7 files changed, 25 insertions(+), 20 deletions(-)

-- 
2.7.4

