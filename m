From: heinzm@redhat.com
Subject: [PATCH 00/10] dm raid: fix deadlocks and sync ratio races
Date: Fri,  1 Dec 2017 01:02:18 +0100
Message-ID: <20171201000228.32677-1-heinzm@redhat.com>
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
Cc: heinzm@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

This patch series addresses issues causing deadlocks
under load and sync ratio races.  The first 6 patches are
critical, the last 4 are cleanup and an enhancement
to constructor checks.

Patch 1+2:
be prepared for MD raid personalities to adjust
rdev sectors after finishing a reshape conversion
(MD upstream commit c6563a8c38fde3c1c7fc925a10bde3ca20799301)

Patch 3:
fix reshape conversion deadlock under io load
by moving md_stop_writes() to post suspend thus
allowing the MD resync thread to work until after
the raid set got quiesced.

Patch 4:
fix raid set size revalidation for disk adding reshape
and related deadlock:  do it before starting the reshape
when shrinking and after when growing (i.e. remove/add stripes).

Patch 5:
fix reshape staying frozen on multiple table reloads.
Only the last table reload may unfreeze the raid set
so that the proper reshape position can be retrieved
from the superblocks read in the constructor.

Patch 6:
Fix rs_get_progress to avoid bogus sync ratios.

Patch 7:
cleanup grouping the definition of raid set rw
and in_sync with mddev_suspend

Patch 8+9:
cleanup removing an unused struct member and fix comments

Patch 10:
enhance adding a data component device size check to the constructor
(i.e. reject on small component data devices)

Resolves: rhbz1372101
Related:  rhbz1388632
Resolves: rhbz1507729
Resolves: rhbz1508070
Related:  rhbz1514215
Resolves: rhbz1514500


Heinz Mauelshagen (10):
  dm raid: correct sizes and check of component devices
  dm raid: correct resizing state in ctr
  dm raid: fix deadlock caused by stopped writes
  dm raid: correct raid set size revalidation
  dm raid: enhance resume() frozen checks
  dm raid: clear out rs_get_progress()
  dm raid: group rw and in_sync definitions with mddev_resume()
  dm raid: remove unused "struct raid_set" member
  dm raid: comments
  dm raid: add component device size check

 Documentation/device-mapper/dm-raid.txt |   3 +-
 drivers/md/dm-raid.c                    | 261 +++++++++++++++++++++-----------
 2 files changed, 178 insertions(+), 86 deletions(-)

-- 
2.13.6
