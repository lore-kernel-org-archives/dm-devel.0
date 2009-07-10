From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] expose dm-stripe target's topology I/O hints
Date: Fri, 10 Jul 2009 17:33:12 -0400
Message-ID: <1247261592-9803-1-git-send-email-snitzer@redhat.com>
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
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

Add .io_hints to 'struct target_type' to allow the I/O hints portion of
the 'struct queue_limits' to be set by each target.  Expose dm-stripe
target's topology I/O hints.

NOTE: This patch makes use of blk_limits_io_min(); which will be
upstream, via the block tree, in the near future.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---

diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index b240e85..9350566 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -328,6 +328,16 @@ static int stripe_iterate_devices(struct dm_target *ti,
 	return ret;
 }
 
+static void stripe_io_hints(struct dm_target *ti,
+			    struct queue_limits *limits)
+{
+	struct stripe_c *sc = ti->private;
+	unsigned chunk_size = (sc->chunk_mask + 1) << 9;
+
+	blk_limits_io_min(chunk_size);
+	limits->io_opt = chunk_size * sc->stripes;
+}
+
 static struct target_type stripe_target = {
 	.name   = "striped",
 	.version = {1, 2, 0},
@@ -338,6 +348,7 @@ static struct target_type stripe_target = {
 	.end_io = stripe_end_io,
 	.status = stripe_status,
 	.iterate_devices = stripe_iterate_devices,
+	.io_hints = stripe_io_hints,
 };
 
 int __init dm_stripe_init(void)
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 5d16d06..5dcdcfe 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -996,6 +996,10 @@ int dm_calculate_queue_limits(struct dm_table *table,
 		ti->type->iterate_devices(ti, dm_set_device_limits,
 					  &ti_limits);
 
+		/* Set I/O hints portion of queue limits */
+		if (ti->type->io_hints)
+			ti->type->io_hints(ti, &ti_limits);
+
 		/*
 		 * Check each device area is consistent with the target's
 		 * overall queue limits.
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 0d63106..e2b4865 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -91,6 +91,9 @@ typedef int (*dm_iterate_devices_fn) (struct dm_target *ti,
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
