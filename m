From: NeilBrown <nfbrown@novell.com>
Subject: [PATCH 1/8] md/dm: create dm-raid456 module using md/raid5
Date: Mon, 26 Jul 2010 13:24:35 +1000
Message-ID: <20100726032435.29687.77588.stgit@localhost.localdomain>
References: <20100726032230.29687.5366.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100726032230.29687.5366.stgit@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Heinz Mauelshagen <heinzm@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/Kconfig      |    8 +
 drivers/md/Makefile     |    1 
 drivers/md/dm-raid456.c |  445 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 454 insertions(+), 0 deletions(-)
 create mode 100644 drivers/md/dm-raid456.c

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 4a6feac..3465363 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -256,6 +256,14 @@ config DM_MIRROR
          Allow volume managers to mirror logical volumes, also
          needed for live data migration tools such as 'pvmove'.
 
+config DM_RAID456
+       tristate "RAID 4/5/6 target (EXPERIMENTAL)"
+       depends on BLK_DEV_DM && MD_RAID456 && EXPERIMENTAL
+       ---help---
+       A dm target that supports RAID4 RAID5 and RAID6 mapping
+
+       If unsure, say N.
+
 config DM_LOG_USERSPACE
 	tristate "Mirror userspace logging (EXPERIMENTAL)"
 	depends on DM_MIRROR && EXPERIMENTAL && NET
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index e355e7f..0734fba 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -44,6 +44,7 @@ obj-$(CONFIG_DM_SNAPSHOT)	+= dm-snapshot.o
 obj-$(CONFIG_DM_MIRROR)		+= dm-mirror.o dm-log.o dm-region-hash.o
 obj-$(CONFIG_DM_LOG_USERSPACE)	+= dm-log-userspace.o
 obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
+obj-$(CONFIG_DM_RAID456)	+= dm-raid456.o
 
 quiet_cmd_unroll = UNROLL  $@
       cmd_unroll = $(AWK) -f$(srctree)/$(src)/unroll.awk -vN=$(UNROLL) \
diff --git a/drivers/md/dm-raid456.c b/drivers/md/dm-raid456.c
new file mode 100644
index 0000000..d54f901
--- /dev/null
+++ b/drivers/md/dm-raid456.c
@@ -0,0 +1,445 @@
+
+/*
+ * dm-raid456 - implemented as wrapper for md/raid456
+ *
+ */
+#include <linux/slab.h>
+#include "md.h"
+#include "raid5.h"
+#include "dm.h"
+
+struct raid_dev {
+	struct dm_dev *dev;
+	struct mdk_rdev_s rdev;
+};
+
+struct raid_set {
+	struct dm_target *ti;
+	struct mddev_s md;
+	struct raid_type *raid_type;
+	struct raid_dev dev[0];
+};
+
+/* Supported raid types and properties. */
+static struct raid_type {
+	const char *name;		/* RAID algorithm. */
+	const char *descr;		/* Descriptor text for logging. */
+	const unsigned parity_devs;	/* # of parity devices. */
+	const unsigned minimal_devs;	/* minimal # of devices in set. */
+	const unsigned level;		/* RAID level. */
+	const unsigned algorithm;	/* RAID algorithm. */
+} raid_types[] = {
+	{"raid4",    "RAID4 (dedicated parity disk)",	1, 2, 5, ALGORITHM_PARITY_0},
+	{"raid5_la", "RAID5 (left asymmetric)",		1, 2, 5, ALGORITHM_LEFT_ASYMMETRIC},
+	{"raid5_ra", "RAID5 (right asymmetric)",	1, 2, 5, ALGORITHM_RIGHT_ASYMMETRIC},
+	{"raid5_ls", "RAID5 (left symmetric)",		1, 2, 5, ALGORITHM_LEFT_SYMMETRIC},
+	{"raid5_rs", "RAID5 (right symmetric)",		1, 2, 5, ALGORITHM_RIGHT_SYMMETRIC},
+	{"raid6_zr", "RAID6 (zero restart)",		2, 4, 6, ALGORITHM_ROTATING_ZERO_RESTART },
+	{"raid6_nr", "RAID6 (N restart)",		2, 4, 6, ALGORITHM_ROTATING_N_RESTART},
+	{"raid6_nc", "RAID6 (N continue)",		2, 4, 6, ALGORITHM_ROTATING_N_CONTINUE}
+};
+
+static struct raid_type *get_raid_type(char *name)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(raid_types); i++)
+		if (strcmp(raid_types[i].name, name) == 0)
+			return &raid_types[i];
+	return NULL;
+}
+
+static struct raid_set *
+context_alloc(struct raid_type *raid_type,
+	      unsigned long chunk_size,
+	      int recovery,
+	      long raid_devs, sector_t sectors_per_dev,
+	      struct dm_target *ti)
+{
+	struct raid_set *rs;
+
+	rs = kzalloc(sizeof(*rs) + raid_devs * sizeof(rs->dev[0]),
+		     GFP_KERNEL);
+	if (!rs) {
+		ti->error = "Cannot allocate raid context";
+		return ERR_PTR(-ENOMEM);
+	}
+
+	mddev_init(&rs->md);
+
+	rs->ti = ti;
+	rs->raid_type = raid_type;
+	rs->md.raid_disks = raid_devs;
+	rs->md.level = raid_type->level;
+	rs->md.dev_sectors = sectors_per_dev;
+	rs->md.persistent = 0;
+	rs->md.external = 1;
+	rs->md.layout = raid_type->algorithm;
+	rs->md.chunk_sectors = chunk_size;
+	rs->md.recovery_cp = recovery ? 0 : MaxSector;
+
+	rs->md.new_level = rs->md.level;
+	rs->md.new_chunk_sectors = rs->md.chunk_sectors;
+	rs->md.new_layout = rs->md.layout;
+	rs->md.delta_disks = 0;
+
+	return rs;
+}
+
+static void context_free(struct raid_set *rs)
+{
+	int i;
+	for (i = 0; i < rs->md.raid_disks; i++)
+		if (rs->dev[i].dev)
+			dm_put_device(rs->ti, rs->dev[i].dev);
+	kfree(rs);
+}
+
+/* For every device we have two words
+ *  device name, or "-" if missing
+ *  offset from start of devices, in sectors
+ *
+ * This code parses those words.
+ */
+static int dev_parms(struct raid_set *rs, char **argv)
+{
+	int i;
+
+	for (i = 0; i < rs->md.raid_disks; i++, argv += 2) {
+		int err = 0;
+		unsigned long long offset;
+
+		md_rdev_init(&rs->dev[i].rdev);
+		rs->dev[i].rdev.raid_disk = i;
+
+		if (strcmp(argv[0], "-") == 0)
+			rs->dev[i].dev = NULL;
+		else
+			err = dm_get_device(rs->ti, argv[0],
+					    dm_table_get_mode(rs->ti->table),
+					    &rs->dev[i].dev);
+		if (err) {
+			rs->ti->error = "RAID device lookup failure";
+			return err;
+		}
+		if (strict_strtoull(argv[1], 10, &offset) < 0) {
+			rs->ti->error = "RAID device offset is bad";
+			return -EINVAL;
+		}
+		rs->dev[i].rdev.data_offset = offset;
+
+		set_bit(In_sync, &rs->dev[i].rdev.flags);
+
+		rs->dev[i].rdev.mddev = &rs->md;
+		if (rs->dev[i].dev) {
+			rs->dev[i].rdev.bdev = rs->dev[i].dev->bdev;
+			list_add(&rs->dev[i].rdev.same_set, &rs->md.disks);
+		}
+	}
+	return 0;
+}
+
+static void do_table_event(struct work_struct *ws)
+{
+	struct raid_set *rs = container_of(ws, struct raid_set,
+					   md.event_work);
+	dm_table_event(rs->ti->table);
+}
+
+/*
+ * Construct a RAID4/5/6 mapping:
+ * Args:
+ *   log_type #log_params <log_params> \
+ *   raid_type #raid_params <raid_params> \
+ *   rebuild-drive-A [rebuild-drive-B] \
+ *   #raid_devs { <dev_path> <offset>  }
+ *        (a missing device is identified by dev_path == "-")
+ *
+ *  log_type must be 'core'. We ignore region_size and use sync/nosync to
+ *                decide if a resync is needed.
+ *  raid_type is from "raid_types" above
+ *  There are as many 'rebuild-drives' as 'parity_devs' in the raid_type.
+ *  -1 means no drive needs rebuilding.
+ *  raid_params are:
+ *    chunk_size  - in sectors, must be power of 2
+ */
+static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
+{
+	char *err = NULL;
+	int errnum = -EINVAL;
+	unsigned long cnt;
+	struct raid_type *rt;
+	unsigned long chunk_size;
+	int recovery = 1;
+	long raid_devs;
+	long rebuildA, rebuildB;
+	sector_t sectors_per_dev, chunks;
+	struct raid_set *rs = NULL;
+	int in_sync, i;
+
+	/* log type - core XXX [no]sync */
+	err = "Cannot parse log type";
+	if (argc < 2 ||
+	    strcmp(argv[0], "core") != 0 ||
+	    strict_strtoul(argv[1], 10, &cnt) < 0 ||
+	    cnt + 2 > argc)
+		goto err;
+	if (cnt >= 2 && strcmp(argv[3], "sync") == 0)
+		recovery = 0;
+	argc -= cnt+2;
+	argv += cnt+2;
+
+	/* raid type */
+	err = "Cannot find raid_type";
+	if (argc < 1 ||
+	    (rt = get_raid_type(argv[0])) == NULL)
+		goto err;
+	argc--; argv++;
+
+	/* number of parameters */
+	err = "Cannot understand number of RAID parameters";
+	if (argc < 1 ||
+	    strict_strtoul(argv[0], 10, &cnt) < 0 ||
+	    cnt + 1 > argc)
+		goto err;
+	argc--; argv++;
+
+	/* chunk size */
+	if (cnt) {
+		err = "Bad chunk size";
+		if (strict_strtoul(argv[0], 10, &chunk_size) < 0
+		    || !is_power_of_2(chunk_size)
+		    || chunk_size < 8
+			)
+			goto err;
+		cnt--; argc--; argv++;
+	}
+	/* Skip any extra args */
+	argc -= cnt;
+	argv += cnt;
+
+	/* drives needing rebuild */
+	err = "Cannot parse rebuild-drives";
+	if (argc < 1 ||
+	    strict_strtol(argv[0], 10, &rebuildA) < 0)
+		goto err;
+	argc--; argv++;
+
+	rebuildB = -1;
+	if (rt->parity_devs == 2) {
+		if (argc < 1 ||
+		    strict_strtol(argv[0], 10, &rebuildB) < 0)
+			goto err;
+		argc--; argv++;
+	}
+
+	/* number of raid devs */
+	err = "Bad number of raid devices";
+	if (argc < 1 ||
+	    strict_strtol(argv[0], 10, &raid_devs) < 0 ||
+	    raid_devs < rt->minimal_devs)
+		goto err;
+
+	err = "Bad number for rebuild device";
+	if (rebuildA < -1 || rebuildB < -1 ||
+	    rebuildA >= raid_devs || rebuildB >= raid_devs)
+		goto err;
+
+	argc--; argv++;
+	err = "Wrong number of arguments for number of raid devices";
+	if (argc != raid_devs * 2)
+		goto err;
+
+	/* check the sizes all match */
+	sectors_per_dev = ti->len;
+	err = "Target length not divisible by number of data devices";
+	if (sector_div(sectors_per_dev, (raid_devs - rt->parity_devs)))
+		goto err;
+	chunks = sectors_per_dev;
+	err = "Device length not divisible by chunk_size";
+	if (sector_div(chunks, chunk_size))
+		goto err;
+
+
+	/* Now the devices: three words each */
+	rs = context_alloc(rt, chunk_size, recovery,
+			   raid_devs, sectors_per_dev,
+			   ti);
+	if (IS_ERR(rs))
+		return PTR_ERR(rs);
+
+	errnum = dev_parms(rs, argv);
+	if (errnum) {
+		err = ti->error;
+		goto err;
+	}
+	errnum = EINVAL;
+
+	err = "Rebuild device not present";
+	if (rebuildA >= 0) {
+		if (rs->dev[rebuildA].dev == NULL)
+			goto err;
+		clear_bit(In_sync, &rs->dev[rebuildA].rdev.flags);
+		rs->dev[rebuildA].rdev.recovery_offset = 0;
+	}
+	if (rebuildB >= 0) {
+		if (rs->dev[rebuildB].dev == NULL)
+			goto err;
+		clear_bit(In_sync, &rs->dev[rebuildB].rdev.flags);
+		rs->dev[rebuildB].rdev.recovery_offset = 0;
+	}
+	in_sync = 0;
+	for (i = 0; i < rs->md.raid_disks; i++)
+		if (rs->dev[i].dev &&
+		    test_bit(In_sync, &rs->dev[i].rdev.flags))
+			in_sync++;
+	err = "Insufficient active RAID devices";
+	if (rs->md.raid_disks - in_sync > rt->parity_devs)
+		goto err;
+
+	INIT_WORK(&rs->md.event_work, do_table_event);
+	ti->split_io = rs->md.chunk_sectors;
+	ti->private = rs;
+
+	mutex_lock(&rs->md.reconfig_mutex);
+	err = "Fail to run raid array";
+	errnum = md_run(&rs->md);
+	rs->md.in_sync = 0; /* Assume already marked dirty */
+	mutex_unlock(&rs->md.reconfig_mutex);
+
+	if (errnum)
+		goto err;
+	return 0;
+err:
+	if (rs)
+		context_free(rs);
+	ti->error = err;
+	return errnum;
+}
+
+static void raid_dtr(struct dm_target *ti)
+{
+	struct raid_set *rs = ti->private;
+
+	md_stop(&rs->md);
+	context_free(rs);
+}
+
+static int raid_map(struct dm_target *ti, struct bio *bio,
+		    union map_info *map_context)
+{
+	struct raid_set *rs = ti->private;
+	mddev_t *mddev = &rs->md;
+
+	mddev->pers->make_request(mddev, bio);
+	return DM_MAPIO_SUBMITTED;
+}
+
+static int raid_status(struct dm_target *ti, status_type_t type,
+		       char *result, unsigned maxlen)
+{
+	struct raid_set *rs = ti->private;
+	struct raid5_private_data *conf = rs->md.private;
+	int sz = 0;
+	int rbcnt;
+	int i;
+	sector_t sync;
+
+	switch (type) {
+	case STATUSTYPE_INFO:
+		DMEMIT("%u ", rs->md.raid_disks);
+		for (i = 0; i < rs->md.raid_disks; i++) {
+			if (rs->dev[i].dev)
+				DMEMIT("%s ", rs->dev[i].dev->name);
+			else
+				DMEMIT("- ");
+		}
+		for (i = 0; i < rs->md.raid_disks; i++) {
+			if (test_bit(Faulty, &rs->dev[i].rdev.flags))
+				DMEMIT("D");
+			else if (test_bit(In_sync, &rs->dev[i].rdev.flags))
+				DMEMIT("A");
+			else
+				DMEMIT("Ai");
+		}
+		DMEMIT(" %u ", conf->max_nr_stripes);
+		if (test_bit(MD_RECOVERY_RUNNING, &rs->md.recovery))
+			sync = rs->md.curr_resync_completed;
+		else
+			sync = rs->md.recovery_cp;
+		if (sync > rs->md.resync_max_sectors)
+			sync = rs->md.resync_max_sectors;
+		DMEMIT("%llu/%llu ",
+		       (unsigned long long) sync,
+		       (unsigned long long) rs->md.resync_max_sectors);
+		DMEMIT("1 core");
+
+		break;
+	case STATUSTYPE_TABLE:
+		/* The string you would use to construct this array */
+		/* Pretend to use a core log with a region size of 1 sector */
+		DMEMIT("core 2 %u %ssync ", 1,
+		       rs->md.recovery_cp == MaxSector ? "" : "no");
+		DMEMIT("%s ", rs->raid_type->name);
+		DMEMIT("1 %u ", rs->md.chunk_sectors);
+
+		/* Print 1 or 2 rebuild_dev numbers */
+		rbcnt = 0;
+		for (i = 0; i < rs->md.raid_disks; i++)
+			if (rs->dev[i].dev &&
+			    !test_bit(In_sync, &rs->dev[i].rdev.flags) &&
+			    rbcnt < rs->raid_type->parity_devs) {
+				DMEMIT("%u ", i);
+				rbcnt++;
+			}
+		while (rbcnt < rs->raid_type->parity_devs) {
+			DMEMIT("-1 ");
+			rbcnt++;
+		}
+
+		DMEMIT("%u ", rs->md.raid_disks);
+		for (i = 0; i < rs->md.raid_disks; i++) {
+			mdk_rdev_t *rdev = &rs->dev[i].rdev;
+
+			if (rs->dev[i].dev)
+				DMEMIT("%s ", rs->dev[i].dev->name);
+			else
+				DMEMIT("- ");
+
+			DMEMIT("%llu ", (unsigned long long)rdev->data_offset);
+		}
+		break;
+	}
+	return 0;
+}
+
+static struct target_type raid_target = {
+	.name = "raid45",
+	.version = {1, 0, 0},
+	.module = THIS_MODULE,
+	.ctr = raid_ctr,
+	.dtr = raid_dtr,
+	.map = raid_map,
+	.status = raid_status,
+};
+
+static int __init dm_raid_init(void)
+{
+	int r = dm_register_target(&raid_target);
+
+	return r;
+}
+
+static void __exit dm_raid_exit(void)
+{
+	dm_unregister_target(&raid_target);
+}
+
+module_init(dm_raid_init);
+module_exit(dm_raid_exit);
+
+MODULE_DESCRIPTION(DM_NAME " raid4/5/6 target");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("dm-raid4");
+MODULE_ALIAS("dm-raid5");
+MODULE_ALIAS("dm-raid6");


