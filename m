From: Paul Wise <pabs3@bonedaddy.net>
Subject: [PATCH 2/3] dm raid: only check for RAID 4/5/6 once during discard support setup
Date: Sun, 19 Apr 2020 15:30:25 +0800
Message-ID: <20200419073026.197967-3-pabs3@bonedaddy.net>
References: <20200419073026.197967-1-pabs3@bonedaddy.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200419073026.197967-1-pabs3@bonedaddy.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Paul Wise <pabs3@bonedaddy.net>
List-Id: dm-devel.ids

The RAID level 4/5/6 check no longer looks at the devices in the array,
so it isn't necessary for it to be checked once for each device,
so check it before the loop over the devices.

This makes the code cleaner and easier to understand since it
disentangles whole-array checks from per-device checks.

Commit 48920ff2a5a9 ("block: remove the discard_zeroes_data flag") removed
the per-device discard_zeroes_data check since REQ_OP_WRITE_ZEROES
operation was used everywhere and commit 48cf06bc5f50 ("dm raid: add
discard support for RAID levels 4, 5 and 6") introduced the RAID 4/5/6
check.

Signed-off-by: Paul Wise <pabs3@bonedaddy.net>
---
 drivers/md/dm-raid.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 9a18bef0a5ff..0f95e50e62a8 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2944,13 +2944,16 @@ static int rs_setup_reshape(struct raid_set *rs)
 static void configure_discard_support(struct raid_set *rs)
 {
 	int i;
-	bool raid456;
 	struct dm_target *ti = rs->ti;
 
 	/*
 	 * XXX: RAID level 4,5,6 require zeroing for safety.
 	 */
-	raid456 = rs_is_raid456(rs);
+	if (rs_is_raid456(rs) && !devices_handle_discard_safely) {
+		DMERR("raid456 discard support disabled due to discard_zeroes_data uncertainty.");
+		DMERR("Set dm-raid.devices_handle_discard_safely=Y to override.");
+		return;
+	}
 
 	for (i = 0; i < rs->raid_disks; i++) {
 		struct request_queue *q;
@@ -2961,14 +2964,6 @@ static void configure_discard_support(struct raid_set *rs)
 		q = bdev_get_queue(rs->dev[i].rdev.bdev);
 		if (!q || !blk_queue_discard(q))
 			return;
-
-		if (raid456) {
-			if (!devices_handle_discard_safely) {
-				DMERR("raid456 discard support disabled due to discard_zeroes_data uncertainty.");
-				DMERR("Set dm-raid.devices_handle_discard_safely=Y to override.");
-				return;
-			}
-		}
 	}
 
 	ti->num_discard_bios = 1;
-- 
2.26.1
