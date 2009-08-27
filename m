From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3] expose dm-stripe target's topology I/O hints
Date: Thu, 27 Aug 2009 10:46:37 -0400
Message-ID: <1251384397-31065-1-git-send-email-snitzer@redhat.com>
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

Add .io_hints to 'struct target_type' to allow the I/O hints portion
(io_min and io_opt) of the 'struct queue_limits' to be set by each
target.

Expose dm-stripe target's topology I/O hints.  This fix enables striped
DM devices to properly expose their I/O hints to userland via /sys.
Without this fix tools would not be able to reliably depend on the I/O
hints that the I/O topology infrastructure added in 2.6.31-rcX provides.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>

Index: linux-2.6/drivers/md/dm-stripe.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-stripe.c
+++ linux-2.6/drivers/md/dm-stripe.c
@@ -329,6 +329,16 @@ static int stripe_iterate_devices(struct
 	return ret;
 }
 
+static void stripe_io_hints(struct dm_target *ti,
+			    struct queue_limits *limits)
+{
+	struct stripe_c *sc = ti->private;
+	unsigned chunk_size = (sc->chunk_mask + 1) << 9;
+
+	blk_limits_io_min(limits, chunk_size);
+	limits->io_opt = chunk_size * sc->stripes;
+}
+
 static struct target_type stripe_target = {
 	.name   = "striped",
 	.version = {1, 2, 0},
@@ -339,6 +349,7 @@ static struct target_type stripe_target 
 	.end_io = stripe_end_io,
 	.status = stripe_status,
 	.iterate_devices = stripe_iterate_devices,
+	.io_hints = stripe_io_hints,
 };
 
 int __init dm_stripe_init(void)
Index: linux-2.6/drivers/md/dm-table.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-table.c
+++ linux-2.6/drivers/md/dm-table.c
@@ -996,6 +996,10 @@ int dm_calculate_queue_limits(struct dm_
 		ti->type->iterate_devices(ti, dm_set_device_limits,
 					  &ti_limits);
 
+		/* Set I/O hints portion of queue limits */
+		if (ti->type->io_hints)
+			ti->type->io_hints(ti, &ti_limits);
+
 		/*
 		 * Check each device area is consistent with the target's
 		 * overall queue limits.
Index: linux-2.6/include/linux/device-mapper.h
===================================================================
--- linux-2.6.orig/include/linux/device-mapper.h
+++ linux-2.6/include/linux/device-mapper.h
@@ -91,6 +91,9 @@ typedef int (*dm_iterate_devices_fn) (st
 				      iterate_devices_callout_fn fn,
 				      void *data);
 
+typedef void (*dm_io_hints_fn) (struct dm_target *ti,
+				struct queue_limits *limits);
+
 /*
  * Returns:
  *    0: The target can handle the next I/O immediately.
@@ -151,6 +154,7 @@ struct target_type {
 	dm_merge_fn merge;
 	dm_busy_fn busy;
 	dm_iterate_devices_fn iterate_devices;
+	dm_io_hints_fn io_hints;
 
 	/* For internal device-mapper use. */
 	struct list_head list;
