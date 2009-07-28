From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] Rename device_area_is_valid and reverse logic
	accordingly
Date: Tue, 28 Jul 2009 08:07:05 -0400
Message-ID: <20090728120705.GA10878@redhat.com>
References: <Pine.LNX.4.64.0907270913170.25437@hs20-bc2-1.build.redhat.com>
	<20090727141506.GA4964@redhat.com>
	<Pine.LNX.4.64.0907271022490.3823@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0907271022490.3823@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Jul 27 2009 at 10:23am -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> On Mon, 27 Jul 2009, Mike Snitzer wrote:
> 
> > On Mon, Jul 27 2009 at  9:21am -0400,
> > Mikulas Patocka <mpatocka@redhat.com> wrote:
> > 
> > > Hi
> > > 
> > > This patch fixes a bug introduced in 2.6.31-rc1. Targets that define 
> > > iterate_devices and don't contain any devices (such as dm-loop in fsio) 
> > > don't work.
> > > 
> > > Mikulas
> > > 
> > > ---
> > > 
> > > Fix reverse logic in device_area_is_valid
> > > 
> > > ->iterate_devices method calls the callback for every underlying device
> > > in the target. If the callback returns non-zero, iterate_devices exits
> > > and returns this value. If the callback returns zero for all the devices,
> > > iterate_devices returns zero.
> > > 
> > > The logic to check for invalid device areas was reversed.
> > > device_area_is_valid returned 0 on error and 1 on success.
> > > 
> > > Thus:
> > > - error was returned only if all the devices vere errorneous. If some of them
> > >   returned 1 (success), dm_calculate_queue_limits understood this as success.
> > > - if the target had no device (the example is dm-loop target in FSIO mode),
> > >   iterate_devices returned error straight away and dm_calculate_queue_limits
> > >   understood this as an error.
> > > 
> > > This patch reverses the logic so that 0 means success and 1 means error.
> > > 
> > > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > 
> > Nice catch, interesting that this was somehow missed.  All targets do
> > treat a non-zero return from .iterate_devices as an error.
> > 
> > We should probably rename device_area_is_valid to device_area_invalid.
> > 
> > Mike
> 
> Yes, you can rename it to that.
>
> Mikulas

---

From: Mikulas Patocka <mpatocka@redhat.com>

Rename device_area_is_valid and reverse logic accordingly

->iterate_devices method calls the callback for every underlying device
in the target.  If the callback returns non-zero iterate_devices exits
immediately and the caller should understand that an error occurred.

The logic to check for valid device areas was reversed relative to
proper use with iterate_devices.  device_area_is_valid returned 0 on
error and 1 on success.  Thus error (from iterate_devices) was returned
only if all the devices were invalid.

This patch renames device_area_is_valid to device_area_is_invalid and
reverses the logic so that 0 means valid and 1 means invalid (to match
iterate_devices).

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>

---
 drivers/md/dm-table.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index d952b34..aa60526 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -343,10 +343,10 @@ static void close_dev(struct dm_dev_internal *d, struct mapped_device *md)
 }
 
 /*
- * If possible, this checks an area of a destination device is valid.
+ * If possible, this checks an area of a destination device is invalid.
  */
-static int device_area_is_valid(struct dm_target *ti, struct dm_dev *dev,
-				sector_t start, sector_t len, void *data)
+static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
+				  sector_t start, sector_t len, void *data)
 {
 	struct queue_limits *limits = data;
 	struct block_device *bdev = dev->bdev;
@@ -357,16 +357,16 @@ static int device_area_is_valid(struct dm_target *ti, struct dm_dev *dev,
 	char b[BDEVNAME_SIZE];
 
 	if (!dev_size)
-		return 1;
+		return 0;
 
 	if ((start >= dev_size) || (start + len > dev_size)) {
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
@@ -374,7 +374,7 @@ static int device_area_is_valid(struct dm_target *ti, struct dm_dev *dev,
 		       dm_device_name(ti->table->md),
 		       (unsigned long long)start,
 		       limits->logical_block_size, bdevname(bdev, b));
-		return 0;
+		return 1;
 	}
 
 	if (len & (logical_block_size_sectors - 1)) {
@@ -383,10 +383,10 @@ static int device_area_is_valid(struct dm_target *ti, struct dm_dev *dev,
 		       dm_device_name(ti->table->md),
 		       (unsigned long long)len,
 		       limits->logical_block_size, bdevname(bdev, b));
-		return 0;
+		return 1;
 	}
 
-	return 1;
+	return 0;
 }
 
 /*
@@ -1000,8 +1000,8 @@ int dm_calculate_queue_limits(struct dm_table *table,
 		 * Check each device area is consistent with the target's
 		 * overall queue limits.
 		 */
-		if (!ti->type->iterate_devices(ti, device_area_is_valid,
-					       &ti_limits))
+		if (ti->type->iterate_devices(ti, device_area_is_invalid,
+					      &ti_limits))
 			return -EINVAL;
 
 combine_limits:
