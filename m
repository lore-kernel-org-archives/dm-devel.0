From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 4.4-rc3
Date: Tue, 24 Nov 2015 15:40:37 -0500
Message-ID: <20151124204036.GA19581@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
Cc: Junichi Nomura <j-nomura@ce.jp.nec.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 8005c49d9aea74d382f474ce11afbbc7d7130bec:

  Linux 4.4-rc1 (2015-11-15 17:00:27 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm tags/dm-4.4-fixes

for you to fetch changes up to 0fcb04d59351f790efb8da18edefd6ab4d9bbf3b:

  dm thin: fix regression in advertised discard limits (2015-11-23 14:54:46 -0500)

Please pull, thanks!
Mike

----------------------------------------------------------------
Two fixes for 4.4-rc1's DM ioctl changes that introduced the potential
for infinite recursion on ioctl (with DM multipath).

And four stable fixes:

- A DM thin-provisioning fix to restore 'error_if_no_space' setting when
  a thin-pool is made writable again (after having been out of space).

- A DM thin-provisioning fix to properly advertise discard support for
  thin volumes that are stacked on a thin-pool whose underlying data
  device doesn't support discards.

- A DM ioctl fix to allow ctrl-c to break out of an ioctl retry loop
  when DM multipath is configured to 'queue_if_no_path'.

- A DM crypt fix for a possible hang on dm-crypt device removal.

----------------------------------------------------------------
Junichi Nomura (2):
      dm: fix ioctl retry termination with signal
      dm mpath: fix infinite recursion in ioctl when no paths and !queue_if_no_path

Mike Snitzer (3):
      dm thin: restore requested 'error_if_no_space' setting on OODS to WRITE transition
      dm: do not reuse dm_blk_ioctl block_device input as local variable
      dm thin: fix regression in advertised discard limits

Mikulas Patocka (1):
      dm crypt: fix a possible hang due to race condition on exit

 drivers/md/dm-crypt.c | 22 +++++++++++++---------
 drivers/md/dm-mpath.c | 30 ++++++++++++++++--------------
 drivers/md/dm-thin.c  |  6 +++---
 drivers/md/dm.c       |  7 ++++---
 4 files changed, 36 insertions(+), 29 deletions(-)
