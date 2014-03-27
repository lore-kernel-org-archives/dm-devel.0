From: Joe Thornber <ejt@redhat.com>
Subject: [PATCH 0/4] Patchset to fix possible corruption with
	dm-thin et al.
Date: Thu, 27 Mar 2014 14:13:19 +0000
Message-ID: <1395929603-14604-1-git-send-email-ejt@redhat.com>
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
Cc: Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

The persistent-data library used by dm-thin, dm-cache and dm-era is
transactional.  If anything goes wrong, such as an io error when
writing new metadata or a power failure, then we roll back to the last
transaction.

Atomicity when committing a transaction is achieved by:

a) Never overwriting data from the previous transaction.
b) Writing the superblock last, after all other metadata has hit the
   disk.

This patchset fixes a bug associated with (b).  When committing it was
possible for the superblock to still be written in spite of an io
error occurring during the preceding flush.  With these patches we're
careful not to take the write lock out on the superblock until after
the flush has completed.

This issue was discovered by forcing io errors at the crucial time
using dm-flakey.

Joe Thornber (4):
  [perstent-data] Simplify dm_bm_flush_and_unlock() -> dm_bm_flush()
  [persistent-data] change the semantics of dm_tm_commit().
  [dm-cache] Switch to new dm_bm_flush() interface.
  [dm-thin, dm-cache, dm-era] Take care to copy the space map roots
    before locking the superblock.

 drivers/md/dm-cache-metadata.c                     |   63 +++++++++------
 drivers/md/dm-era-target.c                         |   68 ++++++++++-------
 drivers/md/dm-thin-metadata.c                      |   80 ++++++++++++--------
 drivers/md/persistent-data/dm-block-manager.c      |   15 +---
 drivers/md/persistent-data/dm-block-manager.h      |    3 +-
 .../md/persistent-data/dm-transaction-manager.c    |    5 +-
 .../md/persistent-data/dm-transaction-manager.h    |   17 ++---
 7 files changed, 143 insertions(+), 108 deletions(-)

--
1.7.10.4
