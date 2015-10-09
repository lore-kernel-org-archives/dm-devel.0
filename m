From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 4.3-rc5
Date: Fri, 9 Oct 2015 17:46:53 -0400
Message-ID: <20151009214653.GA19859@redhat.com>
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
Cc: Junichi Nomura <j-nomura@ce.jp.nec.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Joe Thornber <ejt@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 9ffecb10283508260936b96022d4ee43a7798b4c:

  Linux 4.3-rc3 (2015-09-27 07:50:08 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm dm-4.3-fixes-2

for you to fetch changes up to b0d3cc011e532d8c9db76cf717bcafa53c135595:

  dm snapshot: add new persistent store option to support overflow (2015-10-09 16:57:03 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
3 stable@ fixes:

- DM core AB-BA deadlock fix in the device destruction path (vs device
  creation's DM table swap).

- DM raid fix to properly round up the region_size to the next
  power-of-2.

- DM cache fix for a NULL pointer seen while switching from the
  "cleaner" cache policy.

2 fixes for regressions introduced during the 4.3 merge:

- request-based DM error propagation regressed due to incorrect
  changes introduced when adding the bi_error field to bio.

- DM snapshot fix to only support snapshots that overflow if the client
  (e.g. lvm2) is prepared to deal with the associated snapshot status
  interface change.

----------------------------------------------------------------
Joe Thornber (1):
      dm cache: fix NULL pointer when switching from cleaner policy

Junichi Nomura (2):
      dm: fix AB-BA deadlock in __dm_destroy()
      dm: fix request-based dm error reporting

Mike Snitzer (1):
      dm snapshot: add new persistent store option to support overflow

Mikulas Patocka (1):
      dm raid: fix round up of default region size

 Documentation/device-mapper/snapshot.txt | 10 +++++++---
 drivers/md/dm-cache-policy-cleaner.c     |  2 +-
 drivers/md/dm-exception-store.c          |  6 +++---
 drivers/md/dm-exception-store.h          |  5 +++--
 drivers/md/dm-raid.c                     |  3 +--
 drivers/md/dm-snap-persistent.c          | 17 ++++++++++++++---
 drivers/md/dm-snap-transient.c           |  3 +--
 drivers/md/dm-snap.c                     | 14 +++++++++-----
 drivers/md/dm.c                          | 11 +++++------
 9 files changed, 44 insertions(+), 27 deletions(-)
