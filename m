From: Mike Snitzer <snitzer@gmail.com>
Subject: [RFC][PATCH 2/2] properly expose dm-stripe target's I/O
	hints
Date: Fri, 26 Jun 2009 00:55:16 -0400
Message-ID: <1245992116-28947-2-git-send-email-snitzer@gmail.com>
References: <1245992116-28947-1-git-send-email-snitzer@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1245992116-28947-1-git-send-email-snitzer@gmail.com>
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
Cc: martin.petersen@oracle.com
List-Id: dm-devel.ids

Add .io_hints to 'struct target_type' to allow the I/O hints portion of
the 'struct queue_limits' to be set in dm-stripe target.

---
 drivers/md/dm-stripe.c        |   11 +++++++++++
 drivers/md/dm-table.c         |    4 ++++
 include/linux/device-mapper.h |    4 ++++
 3 files changed, 19 insertions(+)

Index: linux-2.6/drivers/md/dm-stripe.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-stripe.c	2009-06-26 00:39:22.000000000 -0400
+++ linux-2.6/drivers/md/dm-stripe.c	2009-06-26 00:44:42.000000000 -0400
@@ -328,6 +328,16 @@
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
@@ -338,6 +348,7 @@
 	.end_io = stripe_end_io,
 	.status = stripe_status,
 	.iterate_devices = stripe_iterate_devices,
+	.io_hints = stripe_io_hints,
 };
 
 int __init dm_stripe_init(void)
Index: linux-2.6/drivers/md/dm-table.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-table.c	2009-06-26 00:39:22.000000000 -0400
+++ linux-2.6/drivers/md/dm-table.c	2009-06-26 00:44:42.000000000 -0400
@@ -1001,6 +1001,10 @@
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
--- linux-2.6.orig/include/linux/device-mapper.h	2009-06-26 00:39:22.000000000 -0400
+++ linux-2.6/include/linux/device-mapper.h	2009-06-26 00:44:42.000000000 -0400
@@ -91,6 +91,9 @@
 				      iterate_devices_callout_fn fn,
 				      void *data);
 
+typedef void (*dm_io_hints_fn) (struct dm_target *ti,
+				struct queue_limits *limits);
+
 /*
  * Returns:
  *    0: The target can handle the next I/O immediately.
@@ -151,6 +154,7 @@
 	dm_merge_fn merge;
 	dm_busy_fn busy;
 	dm_iterate_devices_fn iterate_devices;
+	dm_io_hints_fn io_hints;
 
 	/* For internal device-mapper use. */
 	struct list_head list;
