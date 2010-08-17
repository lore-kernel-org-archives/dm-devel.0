From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH v2] dm-throttle: new device mapper target to
 throttle reads and writes
Date: Tue, 17 Aug 2010 15:01:19 +0200
Message-ID: <1282050079.17581.36.camel@o>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
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
Cc: vgoyal@redhat.com
List-Id: dm-devel.ids


This is v2 of a new device mapper "throttle" target which allows for
throttling reads and writes (ie. enforcing throughput limits) in units
of kilobytes per second.

Main difference to the patch I posted on 08/10/2010 is to stash/dispatch
bios in order to prevent caller threads from sleeping (eg. kernel aio).

I've been using it for a while in testing configurations and think it's
valuable for many people requiring simulation of low bandwidth
interconnects or simulating different throughput characteristics on
distinct address segments of a device (eg. fast outer disk spindles vs.
slower inner ones).

Please read Documentation/device-mapper/throttle.txt for how to use it.

Note: this target can be combined with the "delay" target, which is
already upstream in order to set io delays in addition to throttling,
again valuable for long distance transport simulations.


This target should stay separate rather than merged IMO, because it
basically serves testing purposes and hence should not complicate any
production mapping target. A potential merge with the "delay" target is
subject to discussion.


Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>

 Documentation/device-mapper/throttle.txt |   70 ++++
 drivers/md/Kconfig                       |    8 +
 drivers/md/Makefile                      |    1 +
 drivers/md/dm-throttle.c                 |  580 ++++++++++++++++++++++++++++++
 4 files changed, 659 insertions(+), 0 deletions(-)

diff --git a/Documentation/device-mapper/throttle.txt b/Documentation/device-mapper/throttle.txt
new file mode 100644
index 0000000..e385438
--- /dev/null
+++ b/Documentation/device-mapper/throttle.txt
@@ -0,0 +1,70 @@
+dm-throttle
+===========
+
+Device-Mapper's "throttle" target maps a linear range of the Device-Mapper
+device onto a linear range of another device providing the option to throttle
+read and write ios seperately.
+
+This target provides the ability to simulate low bandwidth transports to
+devices or different throughput to seperate address segements of a device.
+
+Parameters: <#variable params> <kbs> <write kbs> <dev path> <offset>
+    <#variable params> number of variable paramaters to set read and
+		       write throttling kilobytes per second limits
+		       Range: 0 - 2 with
+		       0 = no throttling.
+		       1 and <kbs> =
+			  set read+write throttling to the same value.
+		       2 and <kbs> <write kbs> =
+			  set read+write throttling separately.
+    <kbs> kilobytes per second limit (0 = no throttling).
+    <write kbs> write kilobatyes per second limit (0 = no throttling).
+    <dev path>: Full pathname to the underlying block-device, or a
+                "major:minor" device-number.
+    <offset>: Starting sector within the device.
+
+Throttling read and write values can be adjusted through the constructor
+by reloading a mapping table with the respective parameters or without
+reloading through the message interface:
+
+dmsetup message <mapped device name> <offset> read_kbs <read kbs>
+dmsetup message <mapped device name> <offset> write_kbs <read kbs>
+
+The target provides status information via its status interface:
+
+dmsetup status <mapped device name>
+
+Output includes the target version, the actual read and write kilobytes
+per second limits used, how many read and write ios have been processed,
+deferred and accounted for.
+
+Status can be reset without reloading the mapping table via the message
+interface as well:
+
+dmsetup message <mapped device name> <offset> stats reset
+
+
+Example scripts
+===============
+[[
+#!/bin/sh
+# Create an identity mapping for a device
+# setting 1MB/s read and write throttling
+echo "0 `blockdev --getsize $1` throttle 2 1024 1024 $1 0" | \
+dmsetup create throttle_identity
+]]
+
+[[
+#!/bin/sh
+# Set different throughput to first and second half of a device
+let size=`blockdev --getsize $1`/2
+echo "0 $size throttle 2 10480 8192 $1 0
+$size $size throttle 2 2048 1024 $1 $size" | \
+dmsetup create throttle_segmented
+]]
+
+[[
+#!/bin/sh
+# Change read throughput on 2nd segment of previous segemented mapping
+dmsetup message throttle_segmented $size 1 4096"
+]]
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 4a6feac..9c3cbe0 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -313,6 +313,14 @@ config DM_DELAY
 
 	If unsure, say N.
 
+config DM_THROTTLE
+	tristate "Throttling target (EXPERIMENTAL)"
+	depends on BLK_DEV_DM && EXPERIMENTAL
+	---help---
+
+	A target that supports device throughput throttling
+	with bandwidth selection for reads and writes.
+
 config DM_UEVENT
 	bool "DM uevents (EXPERIMENTAL)"
 	depends on BLK_DEV_DM && EXPERIMENTAL
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index e355e7f..6ea2598 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -37,6 +37,7 @@ obj-$(CONFIG_BLK_DEV_MD)	+= md-mod.o
 obj-$(CONFIG_BLK_DEV_DM)	+= dm-mod.o
 obj-$(CONFIG_DM_CRYPT)		+= dm-crypt.o
 obj-$(CONFIG_DM_DELAY)		+= dm-delay.o
+obj-$(CONFIG_DM_THROTTLE)	+= dm-throttle.o
 obj-$(CONFIG_DM_MULTIPATH)	+= dm-multipath.o dm-round-robin.o
 obj-$(CONFIG_DM_MULTIPATH_QL)	+= dm-queue-length.o
 obj-$(CONFIG_DM_MULTIPATH_ST)	+= dm-service-time.o
diff --git a/drivers/md/dm-throttle.c b/drivers/md/dm-throttle.c
new file mode 100644
index 0000000..02de1e2
--- /dev/null
+++ b/drivers/md/dm-throttle.c
@@ -0,0 +1,580 @@
+/*
+ * Copyright (C) 2010 Red Hat GmbH
+ *
+ * Module Author: Heinz Mauelshagen <heinzm@redhat.com>
+ *
+ * This file is released under the GPL.
+ *
+ * Test target to stack on top of arbitrary other block
+ * device to throttle io in units of kilobyes per second.
+ *
+ * Throttling is configurable separately for reads and write
+ * via the constructor and the message interfaces.
+ */
+
+#include "dm.h"
+#include <linux/kernel.h>
+#include <linux/slab.h>
+
+static const char *version = "1.0.1";
+
+#define	DM_MSG_PREFIX	"dm-throttle"
+#define	DAEMON		"kthrottled"
+
+#define	TI_ERR_RET(str, ret) \
+	do { ti->error = DM_MSG_PREFIX ": " str; return ret; } while (0);
+#define	TI_ERR(str)	TI_ERR_RET(str, -EINVAL)
+
+static struct workqueue_struct *_throttle_wq;
+
+/* Statistics for target status output (see throttle_status()). */
+struct stats {
+	atomic_t accounted[2];
+	atomic_t deferred_io[2];
+	atomic_t io[2];
+};
+
+/* Reset statistics variables. */
+static void stats_reset(struct stats *stats)
+{
+	int i = 2;
+
+	while (i--) {
+		atomic_set(&stats->accounted[i], 0);
+		atomic_set(&stats->deferred_io[i], 0);
+		atomic_set(&stats->io[i], 0);
+	}
+}
+
+/* Throttle context. */
+struct throttle_c {
+	struct dm_target *ti;
+
+	/* Device to throttle. */
+	struct {
+		struct dm_dev *dev;
+		sector_t start;
+	} dev;
+
+	/* ctr parameters. */
+	struct params {
+		unsigned kbs_ctr[2];	/* To save kb/s constructor args. */
+		unsigned bs[2];		/* Bytes per second. */
+		unsigned bs_new[2];	/* New required setting via message. */
+		unsigned params;	/* # of variable parameters. */
+	} params;
+
+	struct {
+		/* Accounting for reads and writes. */
+		struct ac_rw {
+			struct mutex mutex;
+			unsigned long end_jiffies;
+			unsigned size;
+		} rw[2];
+	} account;
+
+	struct {
+		struct mutex mutex;	/* Shared access to input list. */
+		struct bio_list in;	/* Central input list. */
+		struct delayed_work dws_do_throttle; /* io work. */
+	} io;
+
+	struct stats stats;
+};
+
+/* Check @arg to be >= @min && <= @max. */
+static inline int range_ok(int arg, int min, int max)
+{
+	return !(arg < min || arg > max);
+}
+
+/* Queue (optionally delayed) throttle work. */
+static void wake_do_throttle_delayed(struct throttle_c *tc, unsigned long delay)
+{
+	if (work_pending(&tc->io.dws_do_throttle.work))
+		cancel_delayed_work(&tc->io.dws_do_throttle);
+
+	queue_delayed_work(_throttle_wq, &tc->io.dws_do_throttle, delay);
+}
+
+/* Return 0/1 for read/write bio. */
+static int is_write(struct bio *bio)
+{
+	return !!(bio_data_dir(bio) == WRITE);
+}
+
+/* Remap sector. */
+static sector_t _remap_sector(struct throttle_c *tc, sector_t sector)
+{
+	return tc->dev.start + (sector - tc->ti->begin);
+}
+
+/* Return minimun read/write end jiffies for delaying work. */
+static long min_rw_end_jiffies(int write, struct throttle_c *tc)
+{
+	int r;
+
+	BUG_ON(!range_ok(write, 0, 1));
+
+	mutex_lock(&tc->account.rw[!write].mutex);
+	r = min(tc->account.rw[write].end_jiffies,
+		tc->account.rw[!write].end_jiffies);
+
+	mutex_unlock(&tc->account.rw[!write].mutex);
+	return r;
+}
+
+/* Return bytes/s value for kilobytes/s. */
+static inline unsigned to_bs(unsigned kbs)
+{
+	return kbs << 10;
+}
+
+static inline unsigned to_kbs(unsigned bs)
+{
+	return bs >> 10;
+}
+
+/* Reset account if measure time exceeded. */
+static void account_reset(struct ac_rw *ac_rw, unsigned long j)
+{
+	if (time_after(j, ac_rw->end_jiffies)) {
+		ac_rw->size = 0;
+		ac_rw->end_jiffies = jiffies + HZ;
+		smp_wmb();
+	}
+}
+
+/*
+ * Decide about throttling @bio.
+ *
+ * Must be called wih account mutex held.
+ */
+static int throttle(struct throttle_c *tc, struct bio *bio)
+{
+	int write = is_write(bio);
+	unsigned bps; /* Bytes per second. */
+
+	bps = tc->params.bs[write];
+	if (bps) {
+		struct ac_rw *ac_rw = tc->account.rw + write;
+
+		account_reset(ac_rw, jiffies); /* Measure time exceeded?. */
+
+		/* Hit kilobytes per second threshold? */
+		if (ac_rw->size + bio->bi_size > bps)
+			return -EPERM;
+
+		ac_rw->size += bio->bi_size;
+		smp_wmb();
+		atomic_inc(tc->stats.accounted + write); /* Statistics. */
+	}
+
+	return 0;
+}
+
+/* Adjust split io in case throttling is below BIO_MAX_SIZE. */
+static void set_split_io(struct dm_target *ti)
+{
+	struct throttle_c *tc = ti->private;
+	int minbs;
+
+	minbs = min(tc->params.bs[0], tc->params.bs[1]);
+	if (minbs < BIO_MAX_SIZE) {
+		if (minbs < PAGE_SIZE)
+			minbs = PAGE_SIZE;
+
+		ti->split_io = minbs >> SECTOR_SHIFT;
+	} else
+		ti->split_io = 0;
+}
+
+/*
+ * Destruct a throttle mapping.
+ */
+static void throttle_dtr(struct dm_target *ti)
+{
+	struct throttle_c *tc = ti->private;
+
+	if (tc->dev.dev)
+		dm_put_device(ti, tc->dev.dev);
+
+	kfree(tc);
+}
+
+/* Process bios on input queue. Must be called with tc->io.mutex held. */
+static void do_bios(struct throttle_c *tc)
+{
+	int r, write;
+	unsigned long end;
+	struct bio *bio;
+
+	while (!bio_list_empty(&tc->io.in)) {
+		bio = bio_list_peek(&tc->io.in);
+		mutex_unlock(&tc->io.mutex);
+
+		write = is_write(bio);
+
+		mutex_lock(&tc->account.rw[write].mutex);
+		r = throttle(tc, bio);
+	 	end = min_rw_end_jiffies(write, tc);
+		mutex_unlock(&tc->account.rw[write].mutex);
+
+		if (r) {
+			unsigned long j = jiffies;
+	
+			wake_do_throttle_delayed(tc, time_before(j, end) ?
+						     end - j : 0);
+			break;
+		} else {
+			/* No get 1st bio from input list. */
+			mutex_lock(&tc->io.mutex);
+			bio = bio_list_pop(&tc->io.in);
+			mutex_unlock(&tc->io.mutex);
+	
+			/* Remap & submit bio. */
+			bio->bi_bdev = tc->dev.dev->bdev;
+			bio->bi_sector = _remap_sector(tc, bio->bi_sector);
+			generic_make_request(bio);
+
+			/* Statistics */
+			atomic_inc(&tc->stats.io[is_write(bio)]);
+		}
+
+		mutex_lock(&tc->io.mutex);
+	}
+}
+
+/*
+ * Change throughput settings.
+ *
+ * Must be called with tc->io.mutex held.
+ *
+ * Chaging only when input bio list empty or when througput grows,
+ * because we have to adjust split_io and need t process any already
+ * split before we lower.
+ */
+static void do_settings(struct throttle_c *tc)
+{
+	int i = ARRAY_SIZE(tc->account.rw);
+
+	while (i--) {
+		mutex_lock(&tc->account.rw[i].mutex);
+		if (bio_list_empty(&tc->io.in) ||
+		    !tc->params.bs_new[i] ||
+		    tc->params.bs_new[i] > tc->params.bs[i] ||
+		    tc->params.bs_new[i] > BIO_MAX_SIZE)
+			tc->params.bs[i] = tc->params.bs_new[i];
+
+		mutex_unlock(&tc->account.rw[i].mutex);
+	}
+
+	set_split_io(tc->ti);
+}
+
+/*
+ * Main daemon worker function.
+ *
+ * Processes bio input list populated by map function
+ * and checks if it can submit bios unless throttling.
+ */
+static void do_throttle(struct work_struct *ws)
+{
+	struct throttle_c *tc = container_of(ws, struct throttle_c,
+					     io.dws_do_throttle.work);
+	mutex_lock(&tc->io.mutex);
+	do_bios(tc);
+	do_settings(tc);
+	mutex_unlock(&tc->io.mutex);
+}
+
+/* Return "write" or "read" string for @write */
+static const char *rw_str(int write)
+{
+	return write ? "write" : "read";
+}
+
+/* Return kbs argument and message in @err_msg on error. */
+static int get_kbs(int write, char *arg, char **err_msg)
+{
+	int r;
+
+	if (sscanf(arg, "%d", &r) != 1 || r < 0 ||
+	    (r && to_bs(r) < PAGE_SIZE)) {
+		static char msg[60];
+
+		snprintf(msg, sizeof(msg),
+			 "Invalid throttle %s kilobytes per second=%d",
+			 rw_str(write), r);
+		*err_msg = msg;
+		r = -EINVAL;
+	}
+
+	return r;
+}
+
+/*
+ * Construct a throttle mapping:
+ *
+ * <start> <len> throttle \
+ * #throttle_params <throttle_params> \
+ * orig_dev_name orig_dev_start
+ *
+ * #throttle_params = 0 - 2
+ * throttle_parms = [kbs [write_kbs]]
+ *
+ * throttle_params = 1: kbs will be used for reads and writes
+ * throttle_params = 2: kbs will be used for reads andwrite_kbs for  writes
+ *
+ */
+static int throttle_ctr(struct dm_target *ti, unsigned argc, char **argv)
+{
+	int i, kbs[] = { 0, 0 }, r, throttle_params;
+	unsigned long long tmp;
+	char *err_msg;
+	sector_t start;
+	struct throttle_c *tc;
+	struct params *params;
+
+	if (!range_ok(argc, 3, 5))
+		TI_ERR("Invalid argument count");
+
+	/* Get #throttle_params. */
+	if (sscanf(argv[0], "%d", &throttle_params) != 1 ||
+	    !range_ok(throttle_params, 0, 2))
+		TI_ERR("Invalid throttle parameter number argument");
+
+	/* Handle any variable throttle parameters. */
+	for (i = 0; i < throttle_params; i++) {
+		/* Get throttle read/write kilobytes per second. */
+		kbs[i] = get_kbs(i, argv[i + 1], &err_msg);
+		if (kbs[i] < 0) {
+			ti->error = err_msg;
+			return kbs[i];
+		}
+	}
+
+	/* Set write kbs to kbs in case of just one parameter */
+	if (throttle_params == 1)
+		kbs[1] = kbs[0];
+
+	if (sscanf(argv[2 + throttle_params], "%llu", &tmp) != 1)
+		TI_ERR("Invalid throttle device offset");
+
+	start = tmp;
+
+	/* Allocate throttle context. */
+	tc = kzalloc(sizeof(*tc), GFP_KERNEL);
+	if (!tc)
+		TI_ERR_RET("Cannot allocate throttle context", -ENOMEM);
+
+	ti->private = tc;
+	tc->ti = ti;
+
+	/* Aquire throttle device. */
+	r = dm_get_device(ti, argv[1 + throttle_params],
+			  dm_table_get_mode(ti->table), &tc->dev.dev);
+	if (r) {
+		DMERR("Throttle device lookup failed");
+		goto err;
+	}
+
+	tc->dev.start = start;
+	params = &tc->params;
+	params->params = throttle_params;
+
+	i = ARRAY_SIZE(kbs);
+	while (i--) {
+		params->kbs_ctr[i] = kbs[i];
+		params->bs[i] = params->bs_new[i] = to_bs(kbs[i]);
+		mutex_init(&tc->account.rw[i].mutex);
+	}
+
+	/* Must be after above params->bs[] definition. */
+	set_split_io(ti);
+
+	mutex_init(&tc->io.mutex);
+	bio_list_init(&tc->io.in);
+	INIT_DELAYED_WORK(&tc->io.dws_do_throttle, do_throttle);
+	stats_reset(&tc->stats);
+	return 0;
+err:
+	throttle_dtr(ti);
+	return -EINVAL;
+}
+
+/* Map a throttle io. */
+static int throttle_map(struct dm_target *ti, struct bio *bio,
+			union map_info *map_context)
+{
+	struct throttle_c *tc = ti->private;
+	int write = is_write(bio);
+	unsigned long end, j = jiffies;
+	struct ac_rw *ac_rw = tc->account.rw + write;
+
+	mutex_lock(&tc->io.mutex);
+	bio_list_add(&tc->io.in, bio);
+	mutex_unlock(&tc->io.mutex);
+
+	mutex_lock(&ac_rw->mutex);
+	account_reset(ac_rw, j); /* Measure time exceeded? */
+	end = min_rw_end_jiffies(write, tc);
+	mutex_unlock(&ac_rw->mutex);
+
+	wake_do_throttle_delayed(tc, time_before(j, end) ? end - j : 0);
+	atomic_inc(tc->stats.deferred_io + write); /* Statistics. */
+	return DM_MAPIO_SUBMITTED; /* Deal with bio in worker. */
+}
+
+/* Message method. */
+static int throttle_message(struct dm_target *ti, unsigned argc, char **argv)
+{
+	int kbs, write;
+	char *err_msg;
+	struct throttle_c *tc = ti->private;
+
+	if (argc == 2) {
+		if (!strcmp(argv[0], "stats") &&
+		    !strcmp(argv[1], "reset")) {
+			/* Reset statistics. */
+			stats_reset(&tc->stats);
+			return 0;
+		} else if (!strcmp(argv[0], "read_kbs"))
+			/* Adjust read kilobytes per second. */
+			write = 0;
+		else if (!strcmp(argv[0], "write_kbs"))
+			/* Adjust write kilobytes per second. */
+			write = 1;
+		else
+			goto err;
+
+		/* Read r/w kbs paramater. */
+		kbs = get_kbs(write, argv[1], &err_msg);
+		if (kbs < 0) {
+			DMWARN("%s", err_msg);
+			return kbs;
+		}
+
+		/* Preserve given parameters. */
+		mutex_lock(&tc->account.rw[write].mutex);
+		tc->params.bs_new[write] = to_bs(kbs);
+		mutex_unlock(&tc->account.rw[write].mutex);
+
+		wake_do_throttle_delayed(tc, 0);
+		return 0;
+	}
+err:
+	DMWARN("Unrecognised throttle message received.");
+	return -EINVAL;
+}
+
+/* Status output method. */
+static int throttle_status(struct dm_target *ti, status_type_t type,
+			   char *result, unsigned maxlen)
+{
+	ssize_t sz = 0;
+	struct throttle_c *tc = ti->private;
+	struct stats *s = &tc->stats;
+	struct params *p = &tc->params;
+
+	switch (type) {
+	case STATUSTYPE_INFO:
+		DMEMIT("v=%s rkb=%u wkb=%u r=%u w=%u rd=%u wd=%u "
+		       "acr=%u acw=%u",
+		       version,
+		       to_kbs(p->bs[0]), to_kbs(p->bs[1]),
+		       atomic_read(s->io), atomic_read(s->io + 1),
+		       atomic_read(s->deferred_io),
+		       atomic_read(s->deferred_io + 1),
+		       atomic_read(s->accounted),
+		       atomic_read(s->accounted + 1));
+		break;
+
+	case STATUSTYPE_TABLE:
+		DMEMIT("%u", p->params);
+
+		if (p->params) {
+			DMEMIT(" %u", p->kbs_ctr[0]);
+
+			if (p->params > 1)
+				DMEMIT(" %u", p->kbs_ctr[1]);
+		}
+
+		DMEMIT(" %s %llu",
+		       tc->dev.dev->name,
+		       (unsigned long long) tc->dev.start);
+	}
+
+	return 0;
+}
+
+/* biovec merge method. */
+static int throttle_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
+			  struct bio_vec *biovec, int max_size)
+{
+	struct throttle_c *tc = ti->private;
+	struct request_queue *q = bdev_get_queue(tc->dev.dev->bdev);
+
+	if (!q->merge_bvec_fn)
+		return max_size;
+
+	bvm->bi_bdev = tc->dev.dev->bdev;
+	bvm->bi_sector = _remap_sector(ti->private, bvm->bi_sector);
+	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
+}
+
+/* Device iteration method to support enforcing device io limits. */
+static int throttle_iterate_devices(struct dm_target *ti,
+				    iterate_devices_callout_fn fn, void *data)
+{
+	struct throttle_c *tc = ti->private;
+
+	return fn(ti, tc->dev.dev, tc->dev.start, ti->len, data);
+}
+
+static struct target_type throttle_target = {
+	.name		= "throttle",
+	.version	= {1, 0, 0},
+	.module		= THIS_MODULE,
+	.ctr		= throttle_ctr,
+	.dtr		= throttle_dtr,
+	.map		= throttle_map,
+	.message	= throttle_message,
+	.status		= throttle_status,
+	.merge		= throttle_merge,
+	.iterate_devices = throttle_iterate_devices,
+};
+
+int __init dm_throttle_init(void)
+{
+	int r;
+
+	_throttle_wq = create_singlethread_workqueue(DAEMON);
+	if (_throttle_wq) {
+		r = dm_register_target(&throttle_target);
+		if (r) {
+			destroy_workqueue(_throttle_wq);
+			DMERR("Failed to register %s [%d]", DM_MSG_PREFIX, r);
+		} else
+			DMINFO("registered %s %s", DM_MSG_PREFIX, version);
+	} else {
+		DMERR("failed to create " DAEMON);
+		r = -ENOMEM;
+	}
+	return r;
+}
+
+void dm_throttle_exit(void)
+{
+	dm_unregister_target(&throttle_target);
+	destroy_workqueue(_throttle_wq);
+	DMINFO("unregistered %s %s", DM_MSG_PREFIX, version);
+}
+
+/* Module hooks */
+module_init(dm_throttle_init);
+module_exit(dm_throttle_exit);
+
+MODULE_DESCRIPTION(DM_NAME "device-mapper throttle target");
+MODULE_AUTHOR("Heinz Mauelshagen <heinzm@redhat.com>");
+MODULE_LICENSE("GPL");
