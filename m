From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm table: improve terse warning messages with
	more context
Date: Fri, 31 Jul 2009 12:25:24 -0400
Message-ID: <1249057524-20911-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

NOTE: this patch depends on the pending device_area_is_invalid() patch:
http://patchwork.kernel.org/patch/37759/

---

The lack of context in two dm-table warnings has already proven
unfortunate when analyzing the root-cause of these warnings.  Two recent
fixes went in to address issues that triggered these terse warnings:
5dea271b6d87bd1d79a59c1d5baac2596a841c37
ea9df47cc92573b159ef3b4fda516c32cba9c4fd

If the warnings contained the additional info that this patch provides
it would have made life easier on both the developers and end-users.

Having specific information up-front will improve the dialog with users
that hit these warnings in the future.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>

---

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index aa60526..50981b0 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -360,8 +360,12 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 		return 0;
 
 	if ((start >= dev_size) || (start + len > dev_size)) {
-		DMWARN("%s: %s too small for target",
-		       dm_device_name(ti->table->md), bdevname(bdev, b));
+		DMWARN("%s: %s too small for target: "
+		       "start=%llu, len=%llu, dev_size=%llu",
+		       dm_device_name(ti->table->md), bdevname(bdev, b),
+		       (unsigned long long)start,
+		       (unsigned long long)len,
+		       (unsigned long long)dev_size);
 		return 1;
 	}
 
@@ -496,8 +500,13 @@ int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
 	}
 
 	if (blk_stack_limits(limits, &q->limits, start << 9) < 0)
-		DMWARN("%s: target device %s is misaligned",
-		       dm_device_name(ti->table->md), bdevname(bdev, b));
+		DMWARN("%s: target device %s is misaligned: "
+		       "physical_block_size=%hu, alignment_offset=%hu, "
+		       "start=%llu",
+		       dm_device_name(ti->table->md), bdevname(bdev, b),
+		       q->limits.physical_block_size,
+		       q->limits.alignment_offset,
+		       (unsigned long long) start << 9);
 
 	/*
 	 * Check if merge fn is supported.
