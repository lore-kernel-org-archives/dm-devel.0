From: heinzm@redhat.com
Subject: [PATCH] dm raid: enhance
	attempt_restore_of_faulty_devices() to support more devices
Date: Tue,  9 Aug 2016 14:55:25 +0200
Message-ID: <1470747325-31414-1-git-send-email-heinzm@redhat.com>
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

attempt_restore_of_faulty_devices() is limited to 64 when it should support
the new maximum of 253 when identifying any failed devices. It clears any
rivivable devices via an MD personality hot remove and add cylce to allow
for for their recovery.

Address by using existing functions to retrieve and update all failed devices
bitfield members in the dm raid superblocks on all RAID devices and check for
any devices to clear in it.

Whilst on it, don't call attempt_restore_of_faulty_devices() for any MD
personality not providing disk hot add/remove methods (i.e. raid0 now),
because such personalities don't support reviving of failed disks.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 1b9795d..20e03b2 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3396,11 +3396,19 @@ static void raid_postsuspend(struct dm_target *ti)
 static void attempt_restore_of_faulty_devices(struct raid_set *rs)
 {
 	int i;
-	uint64_t failed_devices, cleared_failed_devices = 0;
+	uint64_t cleared_failed_devices[DISKS_ARRAY_ELEMS];
 	unsigned long flags;
+	bool cleared = false;
 	struct dm_raid_superblock *sb;
+	struct mddev *mddev = &rs->md;
 	struct md_rdev *r;
 
+	/* RAID personalities have to provide hot add/remove methods or we need to bail out. */
+	if (!mddev->pers || !mddev->pers->hot_add_disk || !mddev->pers->hot_remove_disk)
+		return;
+
+	memset(cleared_failed_devices, 0, sizeof(cleared_failed_devices));
+
 	for (i = 0; i < rs->md.raid_disks; i++) {
 		r = &rs->dev[i].rdev;
 		if (test_bit(Faulty, &r->flags) && r->sb_page &&
@@ -3420,7 +3428,7 @@ static void attempt_restore_of_faulty_devices(struct raid_set *rs)
 			 * ourselves.
 			 */
 			if ((r->raid_disk >= 0) &&
-			    (r->mddev->pers->hot_remove_disk(r->mddev, r) != 0))
+			    (mddev->pers->hot_remove_disk(mddev, r) != 0))
 				/* Failed to revive this device, try next */
 				continue;
 
@@ -3430,22 +3438,30 @@ static void attempt_restore_of_faulty_devices(struct raid_set *rs)
 			clear_bit(Faulty, &r->flags);
 			clear_bit(WriteErrorSeen, &r->flags);
 			clear_bit(In_sync, &r->flags);
-			if (r->mddev->pers->hot_add_disk(r->mddev, r)) {
+			if (mddev->pers->hot_add_disk(mddev, r)) {
 				r->raid_disk = -1;
 				r->saved_raid_disk = -1;
 				r->flags = flags;
 			} else {
 				r->recovery_offset = 0;
-				cleared_failed_devices |= 1 << i;
+				set_bit(i, (void *) cleared_failed_devices);
+				cleared = true;
 			}
 		}
 	}
-	if (cleared_failed_devices) {
+
+	/* If any failed devices could be cleared, update all sbs failed_devices bits */
+	if (cleared) {
+		uint64_t failed_devices[DISKS_ARRAY_ELEMS];
+
 		rdev_for_each(r, &rs->md) {
 			sb = page_address(r->sb_page);
-			failed_devices = le64_to_cpu(sb->failed_devices);
-			failed_devices &= ~cleared_failed_devices;
-			sb->failed_devices = cpu_to_le64(failed_devices);
+			sb_retrieve_failed_devices(sb, failed_devices);
+
+			for (i = 0; i < DISKS_ARRAY_ELEMS; i++)
+				failed_devices[i] &= ~cleared_failed_devices[i];
+
+			sb_update_failed_devices(sb, failed_devices);
 		}
 	}
 }
-- 
2.7.4
