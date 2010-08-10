From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH} dm-throttle: new device mapper target to
 throttle reads and writes
Date: Tue, 10 Aug 2010 15:42:22 +0200
Message-ID: <1281447742.4964.46.camel@o>
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
List-Id: dm-devel.ids


This is a new device mapper "throttle" target which allows for
throttling reads and writes (ie. enforcing throughput limits) in units
of kilobytes per second.

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

 Documentation/device-mapper/throttle.txt |   68 ++++++
 drivers/md/Kconfig                       |    8 +
 drivers/md/Makefile                      |    1 +
 drivers/md/dm-throttle.c                 |  389 ++++++++++++++++++++++++++++++
 4 files changed, 466 insertions(+), 0 deletions(-)

diff --git a/Documentation/device-mapper/throttle.txt b/Documentation/device-mapper/throttle.txt
new file mode 100644
index 0000000..9deea6e
--- /dev/null
+++ b/Documentation/device-mapper/throttle.txt
@@ -0,0 +1,68 @@
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
+Parameters: <#variable params> <read kbs> <write kbs> <dev path> <offset>
+    <#variable params> number of variable paramaters to set read and
+		       write throttling kilobytes per second limits.
+		       Range: 0 - 2 with
+		       0 = no throttling,
+		       1 and <read kbs> = read throttling only and
+		       2 and <read kbs> <write kbs> = read and write throttling.
+    <read kbs> read kilobatyes per second limit
+    <write kbs> write kilobatyes per second limit
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
index 0000000..bc000d0
--- /dev/null
+++ b/drivers/md/dm-throttle.c
@@ -0,0 +1,389 @@
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
+#include <linux/slab.h>
+
+static const char *version = "1.0";
+
+#define	DM_MSG_PREFIX	"dm-throttle"
+#define	TI_ERR_RET(str, ret) \
+	do { ti->error = DM_MSG_PREFIX ": " str; return ret; } while (0);
+#define	TI_ERR(str)	TI_ERR_RET(str, -EINVAL)
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
+	/* Device to throttle. */
+	struct {
+		struct dm_dev *dev;
+		sector_t start;
+	} dev;
+
+	/* ctr parameters. */
+	struct params {
+		unsigned bs[2];		/* Bytes per second. */
+		unsigned kbs_ctr[2];	/* To save kb/s constructor args. */
+		unsigned params;	/* # of variable parameters. */
+	} params;
+
+	struct account {
+		/* Accounting for reads and writes. */
+		struct ac_rw {
+			struct mutex mutex;
+
+			unsigned long end_jiffies;
+			unsigned size;
+		} rw[2];
+
+		unsigned long flags;
+	} account;
+
+	struct stats stats;
+};
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
+/* Reset account. */
+static void account_reset(int rw, struct throttle_c *tc)
+{
+	struct account *ac = &tc->account;
+	struct ac_rw *ac_rw = ac->rw + rw;
+
+	ac_rw->size = 0;
+	ac_rw->end_jiffies = jiffies + HZ;
+	clear_bit(rw, &ac->flags);
+	smp_wmb();
+}
+
+/* Decide about throttling (ie. deferring bios). */
+static int throttle(struct throttle_c *tc, struct bio *bio)
+{
+	int rw = (bio_data_dir(bio) == WRITE);
+	unsigned bps; /* Bytes per second. */
+
+	smp_rmb();
+	bps = tc->params.bs[rw];
+	if (bps) {
+		unsigned size;
+		struct account *ac = &tc->account;
+		struct ac_rw *ac_rw = ac->rw + rw;
+
+		if (time_after(jiffies, ac_rw->end_jiffies))
+			/* Measure time exceeded. */
+			account_reset(rw, tc);
+		else if (test_bit(rw, &ac->flags))
+			/* In case we're throttled already. */
+			return 1;
+
+		/* Account I/O size. */
+		size = ac_rw->size + bio->bi_size;
+		if (size > bps) {
+			/* Hit kilobytes per second threshold. */
+			set_bit(rw, &ac->flags);
+			return 1;
+		} else {
+			ac_rw->size = size;
+			smp_wmb();
+		}
+
+		atomic_inc(tc->stats.accounted + rw); /* Statistics. */
+	}
+
+	return 0;
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
+/* Check @arg to be >= @min && <= @max. */
+static inline int range_ok(int arg, int min, int max)
+{
+	return !(arg < min || arg > max);
+}
+
+/* Return "write" or "read" string for @write */
+static const char *rw_str(int write)
+{
+	return write ? "write" : "read";
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
+ * throttle_parms = [read_kbs [write_kbs]]
+ *
+ */
+static int throttle_ctr(struct dm_target *ti, unsigned argc, char **argv)
+{
+	int i, kbs[] = { 0, 0 }, r, throttle_params;
+	unsigned long long tmp;
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
+		if (sscanf(argv[i + 1], "%d", kbs + i) != 1 || kbs[i] < 0) {
+			static char msg[60];
+
+			snprintf(msg, sizeof(msg),
+				 "Invalid throttle %s kilobytes per second",
+				 rw_str(i));
+			ti->error = msg;
+			return -EINVAL;
+		}
+	}
+
+	if (sscanf(argv[2 + throttle_params], "%llu", &tmp) != 1)
+		TI_ERR("Invalid throttle device offset");
+
+	start = tmp;
+
+	/* Allocate throttle context. */
+	tc = ti->private = kzalloc(sizeof(*tc), GFP_KERNEL);
+	if (!tc)
+		TI_ERR_RET("Cannot allocate throttle context", -ENOMEM);
+
+	/* Aquire throttle device. */
+	r = dm_get_device(ti, argv[1 + throttle_params],
+			  dm_table_get_mode(ti->table), &tc->dev.dev);
+	if (r) {
+		DMERR("Throttle device lookup failed");
+		goto err;
+	}
+
+	/* Check throttled device length. */
+	if (ti->len >
+	    i_size_read(tc->dev.dev->bdev->bd_inode) >> SECTOR_SHIFT) {
+		DMERR("Throttled device too small for mapping");
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
+		params->bs[i] = to_bs(kbs[i]);
+		mutex_init(&tc->account.rw[i].mutex);
+	}
+
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
+	int r, rw = (bio_data_dir(bio) == WRITE);
+	struct throttle_c *tc = ti->private;
+	struct ac_rw *ac_rw = tc->account.rw + rw;
+
+	mutex_lock(&ac_rw->mutex);
+	do {
+		r = throttle(tc, bio);
+		if (r) {
+			long end = ac_rw->end_jiffies, j = jiffies;
+
+			/* Wait till next second when KB/s reached. */
+			if (j < end)
+				schedule_timeout_uninterruptible(end - j);
+		}
+	} while (r);
+
+	mutex_unlock(&ac_rw->mutex);
+
+	/* Remap. */
+	bio->bi_bdev = tc->dev.dev->bdev;
+	bio->bi_sector = bio->bi_sector - ti->begin + tc->dev.start;
+
+	atomic_inc(&tc->stats.io[rw]); /* Statistics */
+	return 1; /* Done with the bio; let dm core submit it. */
+}
+
+/* Message method. */
+static int throttle_message(struct dm_target *ti, unsigned argc, char **argv)
+{
+	int kbs, rw;
+	struct throttle_c *tc = ti->private;
+
+	if (argc == 2) {
+		if (!strcmp(argv[0], "stats") &&
+		    !strcmp(argv[1], "reset")) {
+			/* Reset statistics. */
+			stats_reset(&tc->stats);
+			goto out;
+		} else if (!strcmp(argv[0], "read_kbs"))
+			/* Adjust read kilobytes per second. */
+			rw = 0;
+		else if (!strcmp(argv[0], "write_kbs"))
+			/* Adjust write kilobytes per second. */
+			rw = 1;
+		else
+			goto err;
+
+		/* Read r/w kbs paramater. */
+		if (sscanf(argv[1], "%d", &kbs) != 1 || kbs < 0) {
+			DMWARN("Unrecognised throttle %s_kbs parameter.",
+			       rw_str(rw));
+			return -EINVAL;
+		}
+
+		/* Update settings. */
+		mutex_lock(&tc->account.rw[rw].mutex);
+		tc->params.bs[rw] = to_bs(kbs);
+		account_reset(rw, tc);
+		mutex_unlock(&tc->account.rw[rw].mutex);
+out:
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
+static struct target_type throttle_target = {
+	.name		= "throttle",
+	.version	= {1, 0, 0},
+	.module		= THIS_MODULE,
+	.ctr		= throttle_ctr,
+	.dtr		= throttle_dtr,
+	.map		= throttle_map,
+	.message	= throttle_message,
+	.status		= throttle_status,
+};
+
+int __init dm_throttle_init(void)
+{
+	int r = dm_register_target(&throttle_target);
+
+	if (r)
+		DMERR("Failed to register %s [%d]", DM_MSG_PREFIX, r);
+	else
+		DMINFO("registered %s %s", DM_MSG_PREFIX, version);
+
+	return r;
+}
+
+void dm_throttle_exit(void)
+{
+	dm_unregister_target(&throttle_target);
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
