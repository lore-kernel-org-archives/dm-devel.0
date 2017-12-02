From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH V2 00/12] dm raid: fix deadlocks and sync ratio
	races
Date: Sat,  2 Dec 2017 01:03:47 +0100
Message-ID: <cover.1512171097.git.heinzm@redhat.com>
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
Cc: snitzer@redhat.com
List-Id: dm-devel.ids

This is version 2 of the patch series addressing issues
causing deadlocks under load and sync ratio/action and
health char races.  I reordered patches and split a
large one further up.

Patches 1-8 are critical with 6-8 to be applied in
order and 9-11 providing cleanups and 12 adding
an additional constructor check.

Patch 1:
fix reshape conversion deadlock under io load
by moving md_stop_writes() to post suspend thus
allowing the MD resync thread to work until after
the raid set got quiesced.

Patch 2:
be prepared for MD raid personalities to adjust
rdev sectors after finishing a reshape conversion
(MD upstream commit c6563a8c38fde3c1c7fc925a10bde3ca20799301)

Patch 3:
avoid bogus resize assumption when reshsaping.
Needed becaue of patch 2.

Patch 4:
fix raid set size revalidation for disk adding reshape
and related deadlock:  do it before starting the reshape
when shrinking and after when growing (i.e. remove/add stripes).
Avoids random deadlocks.

Patch 5:
fix reshape staying frozen on multiple table reloads.
Only the last table reload may unfreeze the raid set
so that the proper reshape position can be retrieved
from the superblocks read in the constructor.

Patch 6:
close an recovery flag race in raid_status() and its
callees by taking a copy and passing it on.

Patch 7:
avoid the array_in_sync variale in preparation
for more state to pass between raid_status()
and its callees.

Patch 8:
fix various sync state issues causing racy/bogus sync ratio,
sync_action ad health chars in dm_status() info output.

Patch 9:
cleanup grouping the definition of raid set rw
and in_sync with mddev_suspend

Patch 10+11:
cleanup removing an unused struct member and fix comments

Patch 12:
enhance adding a data component device size check to the constructor
(i.e. reject on small component data devices)

Resolves: rhbz1210637
Resolves: rhbz1372101
Related:  rhbz1388632
Resolves: rhbz1507729
Resolves: rhbz1508070
Related:  rhbz1514215
Resolves: rhbz1514500


Heinz Mauelshagen (12):
  dm raid: fix deadlock caused by stopped writes
  dm raid: correct sizes and check of component devices
  dm raid: correct resizing state in ctr
  dm raid: correct raid set size revalidation
  dm raid: enhance resume() frozen checks
  dm raid: close MD recovery flags race window
  dm raid: avoid array_in_sync variable
  dm raid: fix rs_get_progress() synchronization state/ratio
  dm raid: group rw and in_sync definitions with mddev_resume()
  dm raid: remove unused "struct raid_set" member
  dm raid: comments
  dm raid: add component device size check

 Documentation/device-mapper/dm-raid.txt |   3 +-
 drivers/md/dm-raid.c                    | 274 ++++++++++++++++++++++----------
 2 files changed, 191 insertions(+), 86 deletions(-)

-- 
2.13.6
