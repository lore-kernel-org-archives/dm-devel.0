From: Mike Snitzer <snitzer@redhat.com>
Subject: [RFC][PATCH 1/2] dm: introduce target_type method
	.iterate_devices
Date: Sat, 13 Jun 2009 19:25:41 -0400
Message-ID: <1244935542-18919-1-git-send-email-snitzer@redhat.com>
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
Cc: martin.petersen@oracle.com, agk@redhat.com
List-Id: dm-devel.ids

Added .iterate_devices to 'struct target_type' to allow a function to be
called for all devices in a DM target.  Implemented it for both the
linear and stripe targets.

Once I get confirmation that this infrastructure looks reasonable I'll
implement .iterate_devices for the remaining targets.

I've not yet bumped each target_type's .version but I assume I need to
given the introduction of a new method.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: agk@redhat.com
Cc: martin.petersen@oracle.com
---
 drivers/md/dm-linear.c        |    8 ++++++++
 drivers/md/dm-stripe.c        |   21 +++++++++++++++++++++
 include/linux/device-mapper.h |   11 +++++++++++
 3 files changed, 40 insertions(+)

Index: linux-2.6/drivers/md/dm-linear.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-linear.c
+++ linux-2.6/drivers/md/dm-linear.c
@@ -132,6 +132,13 @@ static int linear_merge(struct dm_target
 	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
 }
 
+static int linear_iterate_devices(struct dm_target *ti,
+				  iterate_devices_callout_fn fn, void *data)
+{
+	struct linear_c *lc = (struct linear_c *) ti->private;
+	return (fn ? fn(ti, lc->dev, lc->start, data) : 0);
+}
+
 static struct target_type linear_target = {
 	.name   = "linear",
 	.version= {1, 0, 3},
@@ -142,6 +149,7 @@ static struct target_type linear_target 
 	.status = linear_status,
 	.ioctl  = linear_ioctl,
 	.merge  = linear_merge,
+	.iterate_devices = linear_iterate_devices,
 };
 
 int __init dm_linear_init(void)
Index: linux-2.6/include/linux/device-mapper.h
===================================================================
--- linux-2.6.orig/include/linux/device-mapper.h
+++ linux-2.6/include/linux/device-mapper.h
@@ -11,6 +11,7 @@
 #include <linux/bio.h>
 #include <linux/blkdev.h>
 
+struct dm_dev;
 struct dm_target;
 struct dm_table;
 struct mapped_device;
@@ -87,6 +88,15 @@ typedef int (*dm_merge_fn) (struct dm_ta
  */
 typedef int (*dm_busy_fn) (struct dm_target *ti);
 
+typedef int (*iterate_devices_callout_fn) (struct dm_target *ti,
+					   struct dm_dev *dev,
+					   sector_t physical_start,
+					   void *data);
+
+typedef int (*dm_iterate_devices_fn) (struct dm_target *ti,
+				      iterate_devices_callout_fn fn,
+				      void *data);
+
 void dm_error(const char *message);
 
 /*
@@ -138,6 +148,7 @@ struct target_type {
 	dm_ioctl_fn ioctl;
 	dm_merge_fn merge;
 	dm_busy_fn busy;
+	dm_iterate_devices_fn iterate_devices;
 
 	/* For internal device-mapper use. */
 	struct list_head list;
Index: linux-2.6/drivers/md/dm-stripe.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-stripe.c
+++ linux-2.6/drivers/md/dm-stripe.c
@@ -304,6 +304,26 @@ static int stripe_end_io(struct dm_targe
 	return error;
 }
 
+static int stripe_iterate_devices(struct dm_target *ti,
+				  iterate_devices_callout_fn fn, void *data)
+{
+	unsigned i;
+	struct stripe_c *sc = (struct stripe_c *) ti->private;
+	int ret = 0;
+
+	if (!fn)
+		return ret;
+
+	for (i = 0; i < sc->stripes; i++) {
+		ret = fn(ti, sc->stripe[i].dev,
+			 sc->stripe[i].physical_start, data);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
 static struct target_type stripe_target = {
 	.name   = "striped",
 	.version = {1, 1, 0},
@@ -313,6 +333,7 @@ static struct target_type stripe_target 
 	.map    = stripe_map,
 	.end_io = stripe_end_io,
 	.status = stripe_status,
+	.iterate_devices = stripe_iterate_devices,
 };
 
 int __init dm_stripe_init(void)
