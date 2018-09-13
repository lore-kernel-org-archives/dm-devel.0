From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 4.19-rc4
Date: Thu, 13 Sep 2018 14:39:50 -0400
Message-ID: <20180913183949.GA5607@redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Joe Thornber <ejt@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 57361846b52bc686112da6ca5368d11210796804:

  Linux 4.19-rc2 (2018-09-02 14:37:30 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-4.19/dm-fixes

for you to fetch changes up to 3ab91828166895600efd9cdc3a0eb32001f7204a:

  dm thin metadata: try to avoid ever aborting transactions (2018-09-10 17:03:18 -0400)

Please pull, thanks!
Mike

----------------------------------------------------------------
- DM verity fix for crash due to using vmalloc'd buffers with the
  asynchronous crypto hadsh API.

- Fix to both DM crypt and DM integrity targets to discontinue using
  CRYPTO_TFM_REQ_MAY_SLEEP because its use of GFP_KERNEL can lead to
  deadlock by recursing back into a filesystem.

- Various DM raid fixes related to reshape and rebuild races.

- Fix for DM thin-provisioning to avoid data corruption that was a
  side-effect of needing to abort DM thin metadata transaction due to
  running out of metadata space.  Fix is to reserve a small amount of
  metadata space so that once it is used the DM thin-pool can finish its
  active transaction before switching to read-only mode.

----------------------------------------------------------------
Heinz Mauelshagen (5):
      dm raid: fix reshape race on small devices
      dm raid: fix stripe adding reshape deadlock
      dm raid: fix rebuild of specific devices by updating superblock
      dm raid: fix RAID leg rebuild errors
      dm raid: bump target version, update comments and documentation

Joe Thornber (1):
      dm thin metadata: try to avoid ever aborting transactions

Mikulas Patocka (2):
      dm verity: fix crash on bufio buffer that was allocated with vmalloc
      dm: disable CRYPTO_TFM_REQ_MAY_SLEEP to fix a GFP_KERNEL recursion deadlock

 Documentation/device-mapper/dm-raid.txt |   4 +
 drivers/md/dm-crypt.c                   |  10 +--
 drivers/md/dm-integrity.c               |   4 +-
 drivers/md/dm-raid.c                    | 154 +++++++++++++-------------------
 drivers/md/dm-thin-metadata.c           |  36 +++++++-
 drivers/md/dm-thin.c                    |  73 +++++++++++++--
 drivers/md/dm-verity-target.c           |  24 ++++-
 7 files changed, 192 insertions(+), 113 deletions(-)
