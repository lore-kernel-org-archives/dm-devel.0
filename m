From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 5.1-rc4
Date: Fri, 5 Apr 2019 18:59:29 -0400
Message-ID: <20190405225928.GB26473@redhat.com>
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
Cc: Andi Kleen <ak@linux.intel.com>, YueHaibing <yuehaibing@huawei.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Ilya Dryomov <idryomov@gmail.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 79a3aaa7b82e3106be97842dedfd8429248896e6:

  Linux 5.1-rc3 (2019-03-31 14:39:29 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.1/dm-fixes

for you to fetch changes up to 4ed319c6ac08e9a28fca7ac188181ac122f4de84:

  dm integrity: fix deadlock with overlapping I/O (2019-04-05 18:49:08 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Two queue_limits stacking fixes: disable discards if underlying driver
  does.  And propagate BDI_CAP_STABLE_WRITES to fix sporadic checksum
  errors.

- Fix that reverts a DM core limit that wasn't needed given that
  dm-crypt was already updated to impose an equivalent limit.

- Fix dm-init to properly establish 'const' for __initconst array.

- Fix deadlock in DM integrity target that occurs when overlapping IO is
  being issued to it.  And two smaller fixes to the DM integrity target.

----------------------------------------------------------------
Andi Kleen (1):
      dm init: fix const confusion for dm_allowed_targets array

Ilya Dryomov (1):
      dm table: propagate BDI_CAP_STABLE_WRITES to fix sporadic checksum errors

Mike Snitzer (1):
      dm: disable DISCARD if the underlying storage no longer supports it

Mikulas Patocka (3):
      dm integrity: change memcmp to strncmp in dm_integrity_ctr
      dm: revert 8f50e358153d ("dm: limit the max bio size as BIO_MAX_PAGES * PAGE_SIZE")
      dm integrity: fix deadlock with overlapping I/O

YueHaibing (1):
      dm integrity: make dm_integrity_init and dm_integrity_exit static

 drivers/md/dm-core.h      |  1 +
 drivers/md/dm-init.c      |  2 +-
 drivers/md/dm-integrity.c | 16 +++++++---------
 drivers/md/dm-rq.c        | 11 +++++++----
 drivers/md/dm-table.c     | 39 +++++++++++++++++++++++++++++++++++++++
 drivers/md/dm.c           | 30 +++++++++++++++++-------------
 6 files changed, 72 insertions(+), 27 deletions(-)
