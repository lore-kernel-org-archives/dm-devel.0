From: heinzm@redhat.com
Subject: [PATCH] dm raid: fix validate_raid_redundancy()
	activation check
Date: Thu, 13 Jul 2017 17:36:12 +0200
Message-ID: <20170713153612.24503-1-heinzm@redhat.com>
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
Cc: heinzm@redhat.com
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

On growing reshapes (i.e. stripes being added to a raid set), the
new stripe images are not in sync and not part of the raid set until
the reshape is started.

LVM2 has to request multiple table reloads involving superblock updates
in order to reflect proper size of SubLVs in the cluster.  Before a stripe
adding reshape starts, validate_raid_redundancy() fails as a result of that
because it checks the total number of devices for the number of rebuild
ones rather than the actual ones in the raid set retrieved from the
superblock thus fails raid4/5/6/10 redundancy checks.

E.g. convert 3 stripes -> 7 stripes raid5 (which only allows for maximum
1 device to fail) requesting +4 delta disks causing 4 devices to rebuild
during reshaping thus failing activation.

Move validate_raid_redundancy() to get access to current raid_set members.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 60c524b..757355b 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2542,11 +2542,6 @@ static int analyse_superblocks(struct dm_target *ti, struct raid_set *rs)
 	if (!freshest)
 		return 0;
 
-	if (validate_raid_redundancy(rs)) {
-		rs->ti->error = "Insufficient redundancy to activate array";
-		return -EINVAL;
-	}
-
 	/*
 	 * Validation of the freshest device provides the source of
 	 * validation for the remaining devices.
@@ -2555,6 +2550,11 @@ static int analyse_superblocks(struct dm_target *ti, struct raid_set *rs)
 	if (super_validate(rs, freshest))
 		return -EINVAL;
 
+	if (validate_raid_redundancy(rs)) {
+		rs->ti->error = "Insufficient redundancy to activate array";
+		return -EINVAL;
+	}
+
 	rdev_for_each(rdev, mddev)
 		if (!test_bit(Journal, &rdev->flags) &&
 		    rdev != freshest &&
-- 
2.9.4
