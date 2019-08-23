From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 5.3-rc6
Date: Fri, 23 Aug 2019 11:41:53 -0400
Message-ID: <20190823154153.GA24648@lobo>
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
Cc: Wenwen Wang <wenwen@cs.uga.edu>, Dmitry Fomichev <dmitry.fomichev@wdc.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>, ZhangXiaoxu <zhangxiaoxu5@huawei.com>, Dan Carpenter <dan.carpenter@oracle.com>, Bryan Gurney <bgurney@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

More fixes than usual from DM at this stage in a release but...

The following changes since commit d45331b00ddb179e291766617259261c112db872:

  Linux 5.3-rc4 (2019-08-11 13:26:41 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.3/dm-fixes-2

for you to fetch changes up to 1cfd5d3399e87167b7f9157ef99daa0e959f395d:

  dm table: fix invalid memory accesses with too high sector number (2019-08-23 10:11:42 -0400)

Please pull, thanks!
Mike

----------------------------------------------------------------
- Revert a DM bufio change from during the 5.3 merge window now that a
  proper fix has been made to the block loopback driver.

- Fix DM kcopyd to wakeup so failed subjobs get completed.

- Various fixes to DM zoned target to address error handling, and other
  small tweaks (SPDX license identifiers and fix typos).

- Fix DM integrity range locking race by tracking whether journal has
  changed.

- Fix DM dust target to detect reads of badblocks beyond the first 512b
  sector (applicable if blocksize is larger than 512b).

- Fix DM persistent-data issue in both the DM btree and DM
  space-map-metadata interfaces.

- Fix out of bounds memory access with certain DM table configurations.

----------------------------------------------------------------
Bryan Gurney (1):
      dm dust: use dust block size for badblocklist index

Dan Carpenter (1):
      dm zoned: fix potential NULL dereference in dmz_do_reclaim()

Dmitry Fomichev (6):
      dm kcopyd: always complete failed jobs
      dm zoned: improve error handling in reclaim
      dm zoned: improve error handling in i/o map code
      dm zoned: properly handle backing device failure
      dm zoned: add SPDX license identifiers
      dm zoned: fix a few typos

Mikulas Patocka (3):
      Revert "dm bufio: fix deadlock with loop device"
      dm integrity: fix a crash due to BUG_ON in __journal_read_write()
      dm table: fix invalid memory accesses with too high sector number

Wenwen Wang (1):
      dm raid: add missing cleanup in raid_ctr()

ZhangXiaoxu (2):
      dm btree: fix order of block initialization in btree_split_beneath
      dm space map metadata: fix missing store of apply_bops() return value

 drivers/md/dm-bufio.c                              |  4 +-
 drivers/md/dm-dust.c                               | 11 +++-
 drivers/md/dm-integrity.c                          | 15 +++++
 drivers/md/dm-kcopyd.c                             |  5 +-
 drivers/md/dm-raid.c                               |  2 +-
 drivers/md/dm-table.c                              |  5 +-
 drivers/md/dm-zoned-metadata.c                     | 68 ++++++++++++++++------
 drivers/md/dm-zoned-reclaim.c                      | 47 +++++++++++----
 drivers/md/dm-zoned-target.c                       | 68 +++++++++++++++++++---
 drivers/md/dm-zoned.h                              | 11 ++++
 drivers/md/persistent-data/dm-btree.c              | 31 +++++-----
 drivers/md/persistent-data/dm-space-map-metadata.c |  2 +-
 12 files changed, 209 insertions(+), 60 deletions(-)
