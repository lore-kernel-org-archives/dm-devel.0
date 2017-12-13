From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH 0/5] dm raid: fix redundancy check and avoid
	frozen raid recovery
Date: Wed, 13 Dec 2017 03:02:33 +0100
Message-ID: <cover.1513125666.git.heinzm@redhat.com>
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
To: heinzm@redhat.com, dm-devel@redhat.com
Cc: snitzer@redhat.com
List-Id: dm-devel.ids


Patch 1 fixes validate_raid_redundancy() to check the
current raid set level as stored in the superblock rather than
the constructor requested one. In case of a raid0 to raid10
conversion, the related flaw caused a raid10 check on the
given raid0 raid set leading to a divide error.

Patch 2 hardens raid resync/recover/reshape by
retrieving any current related offsets from the active,
uspended mapping thus avoiding frozen raid recovery
across reloads altogether.

Patch 3 ensures 'a' chars during reshaping.

Patch 4 + 5 add simplification and cleanup without functional change.

This series presumes
https://www.redhat.com/archives/dm-devel/2017-December/msg00012.html
or
linux-dm.git, revision-range fbc7c07ec23c..b84cf26924cf
respectively.


Heinz Mauelshagen (5):
  dm raid: validate current raid sets redundancy
  dm raid: avoid keeping raid set frozen altogether
  dm raid: ensure 'a' chars during reshape
  dm raid: simplify rs_get_progress()
  dm raid: use rs_is_raid*() / comment

 Documentation/device-mapper/dm-raid.txt |   1 +
 drivers/md/dm-raid.c                    | 168 ++++++++++++++++++--------------
 2 files changed, 98 insertions(+), 71 deletions(-)

-- 
2.13.6
