From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 4.16-rc5
Date: Fri, 9 Mar 2018 15:41:21 -0500
Message-ID: <20180309204121.GA13907@redhat.com>
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
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Arnd Bergmann <arnd@arndb.de>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 661e50bc853209e41a5c14a290ca4decc43cbfd1:

  Linux 4.16-rc4 (2018-03-04 14:54:11 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-4.16/dm-fixes-2

for you to fetch changes up to c934edadcc7a64e399942ae34b912939057a77a7:

  dm table: allow upgrade from bio-based to specialized bio-based variant (2018-03-06 20:23:58 -0500)

Please pull, thanks!
Mike

----------------------------------------------------------------
- Fix an uninitialized variable false warning in dm bufio

- Fix DM's passthrough ioctl support to be race free against an
  underlying device being removed.

- Fix corner-case of DM raid resync reporting if/when the raid becomes
  degraded during resync; otherwise automated raid repair will fail.

- A few DM multipath fixes to make non-SCSI optimizations, that were
  introduced during the 4.16 merge, useful for all non-SCSI devices,
  rather than narrowly define this non-SCSI mode in terms of "nvme".
  This allows the removal of "queue_mode nvme" that really didn't need
  to be introduced.  Instead DM core will internalize whether
  nvme-specific IO submission optimizations are doable and DM multipath
  will only do SCSI-specific device handler operations if SCSI is in
  use.

----------------------------------------------------------------
Arnd Bergmann (1):
      dm bufio: avoid false-positive Wmaybe-uninitialized warning

Jonathan Brassow (1):
      dm raid: fix incorrect sync_ratio when degraded

Mike Snitzer (3):
      dm: use blkdev_get rather than bdgrab when issuing pass-through ioctl
      dm mpath: remove unnecessary NVMe branching in favor of scsi_dh checks
      dm table: allow upgrade from bio-based to specialized bio-based variant

Mikulas Patocka (1):
      dm table: fix "nvme" test

 drivers/md/dm-bufio.c | 16 +++++--------
 drivers/md/dm-mpath.c | 66 ++++++++++++++++++++++-----------------------------
 drivers/md/dm-raid.c  |  7 +++---
 drivers/md/dm-table.c | 16 +++++--------
 drivers/md/dm.c       | 35 +++++++++++++++------------
 5 files changed, 65 insertions(+), 75 deletions(-)
