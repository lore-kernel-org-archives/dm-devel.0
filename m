From: heinzm@redhat.com
Subject: [PATCH 00/26] dm raid: fix/cleanup for dm-4.8 inclusion
Date: Wed,  6 Jul 2016 19:24:31 +0200
Message-ID: <1467825897-26058-1-git-send-email-heinzm@redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>


Patch series vs. kernel.org linux-dm, branch dm-4.8 to address
issues identified:

- superfluous memory bariers
- missing constructor argument checks (sync/nosync)
- typo in write_mostly constructor argument
- function argument types
- recovery ad raid set size issues 
- out-of-place reshape offset checks
- reject resize during reshape
- enhance reshape checks
- avoid memory leaks in destructor
- comment typos and enhancements

Please review and schedule for 4.8 inclusion



Heinz Mauelshagen (26):
  dm raid: avoid superfluous memory barriers on static metadata
  dm raid: prohibit to pass in both sync and nosync ctr flags
  dm raid: the sync_page_io() metadata_op argument is bool
  dm raid: reject too many write_mostly devices
  dm raid: more restricting data_offset value checks
  dm raid: remove bogus comment
  dm raid: enhance comments in takeover checks
  dm raid: fix comment typos
  dm raid: make rs_set_capacity to work on shrinking reshape
  dm raid: fix rs_set_capacity on growing reshape
  dm raid: clearify and fix recovery
  dm raid: prohibit 'nosync' on new raid6 and reject resize during reshape
  dm raid: fix raid10 device size error on out-of-place reshape
  dm raid: comments and fixed typos
  dm raid: fix new superblock/bitmap creation on disk addition
  dm raid: also reject size change during recovery
  dm raid: fix type in write_mostly flag
  dm raid: fix ctr memory leaks on error paths
  dm raid: fix rebuild and catch bogus sync/resync flags
  dm raid: fix rs_is_recovering() to allow for lvextend
  dm raid: found way to allow resize during shrink
  dm raid: enhance reshape check and factor out reshape setup
  dm raid: support delta_disk for raid1, fix table output
  dm raid: use rs->raid_disks to avoid memory leaks on free and more consistent throughout
  dm raid: use rdev_for_each in status
  dm raid: change logical functions to actually return bool

 drivers/md/dm-raid.c | 453 ++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 300 insertions(+), 153 deletions(-)

-- 
2.5.5
