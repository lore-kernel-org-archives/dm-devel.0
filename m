From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] fix reversed logic in device_area_is_valid
Date: Mon, 27 Jul 2009 09:21:31 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0907270913170.25437@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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
To: Alasdair G Kergon <agk@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

This patch fixes a bug introduced in 2.6.31-rc1. Targets that define 
iterate_devices and don't contain any devices (such as dm-loop in fsio) 
don't work.

Mikulas

---

Fix reverse logic in device_area_is_valid

->iterate_devices method calls the callback for every underlying device
in the target. If the callback returns non-zero, iterate_devices exits
and returns this value. If the callback returns zero for all the devices,
iterate_devices returns zero.

The logic to check for invalid device areas was reversed.
device_area_is_valid returned 0 on error and 1 on success.

Thus:
- error was returned only if all the devices vere errorneous. If some of them
  returned 1 (success), dm_calculate_queue_limits understood this as success.
- if the target had no device (the example is dm-loop target in FSIO mode),
  iterate_devices returned error straight away and dm_calculate_queue_limits
  understood this as an error.

This patch reverses the logic so that 0 means success and 1 means error.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-table.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

Index: linux-2.6.31-rc3-devel/drivers/md/dm-table.c
===================================================================
--- linux-2.6.31-rc3-devel.orig/drivers/md/dm-table.c	2009-07-26 22:11:53.000000000 +0200
+++ linux-2.6.31-rc3-devel/drivers/md/dm-table.c	2009-07-26 22:12:39.000000000 +0200
@@ -357,16 +357,16 @@ static int device_area_is_valid(struct d
 	char b[BDEVNAME_SIZE];
 
 	if (!dev_size)
-		return 1;
+		return 0;
 
 	if ((start >= dev_size) || (start + ti->len > dev_size)) {
 		DMWARN("%s: %s too small for target",
 		       dm_device_name(ti->table->md), bdevname(bdev, b));
-		return 0;
+		return 1;
 	}
 
 	if (logical_block_size_sectors <= 1)
-		return 1;
+		return 0;
 
 	if (start & (logical_block_size_sectors - 1)) {
 		DMWARN("%s: start=%llu not aligned to h/w "
@@ -374,7 +374,7 @@ static int device_area_is_valid(struct d
 		       dm_device_name(ti->table->md),
 		       (unsigned long long)start,
 		       limits->logical_block_size, bdevname(bdev, b));
-		return 0;
+		return 1;
 	}
 
 	if (ti->len & (logical_block_size_sectors - 1)) {
@@ -383,10 +383,10 @@ static int device_area_is_valid(struct d
 		       dm_device_name(ti->table->md),
 		       (unsigned long long)ti->len,
 		       limits->logical_block_size, bdevname(bdev, b));
-		return 0;
+		return 1;
 	}
 
-	return 1;
+	return 0;
 }
 
 /*
@@ -1005,8 +1005,8 @@ int dm_calculate_queue_limits(struct dm_
 		 * Check each device area is consistent with the target's
 		 * overall queue limits.
 		 */
-		if (!ti->type->iterate_devices(ti, device_area_is_valid,
-					       &ti_limits))
+		if (ti->type->iterate_devices(ti, device_area_is_valid,
+					      &ti_limits))
 			return -EINVAL;
 
 combine_limits:
