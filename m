From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 4 of 8] dm raid seed module
Date: Fri, 10 Dec 2010 17:24:10 -0600
Message-ID: <201012102324.oBANOAFl019688@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
Cc: agk@redhat.com
List-Id: dm-devel.ids

Patch name: dm-raid-seed-module.patch

This patch is the skeleton for the DM target that will be
the bridge from DM to MD (specifically, RAID456).  It
provides a way to use device-mapper interfaces to the MD
RAID456 drivers.

The original patch came from Neil Brown.  I've changed a
bit of the patch, but left the original 'Signed-off-by'.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Index: linux-2.6/drivers/md/Kconfig
===================================================================
--- linux-2.6.orig/drivers/md/Kconfig
+++ linux-2.6/drivers/md/Kconfig
@@ -240,6 +240,28 @@ config DM_MIRROR
          Allow volume managers to mirror logical volumes, also
          needed for live data migration tools such as 'pvmove'.
 
+config DM_RAID
+       tristate "RAID 4/5/6 target (EXPERIMENTAL)"
+       depends on BLK_DEV_DM && MD_RAID456 && EXPERIMENTAL
+       ---help---
+	 A dm target that supports RAID4, RAID5 and RAID6 mappings
+
+	 A RAID-5 set of N drives with a capacity of C MB per drive provides
+	 the capacity of C * (N - 1) MB, and protects against a failure
+	 of a single drive. For a given sector (row) number, (N - 1) drives
+	 contain data sectors, and one drive contains the parity protection.
+	 For a RAID-4 set, the parity blocks are present on a single drive,
+	 while a RAID-5 set distributes the parity across the drives in one
+	 of the available parity distribution methods.
+
+	 A RAID-6 set of N drives with a capacity of C MB per drive
+	 provides the capacity of C * (N - 2) MB, and protects
+	 against a failure of any two drives. For a given sector
+	 (row) number, (N - 2) drives contain data sectors, and two
+	 drives contains two independent redundancy syndromes.  Like
+	 RAID-5, RAID-6 distributes the syndromes across the drives
+	 in one of the available parity distribution methods.
+
 config DM_LOG_USERSPACE
 	tristate "Mirror userspace logging (EXPERIMENTAL)"
 	depends on DM_MIRROR && EXPERIMENTAL && NET
Index: linux-2.6/drivers/md/Makefile
===================================================================
--- linux-2.6.orig/drivers/md/Makefile
+++ linux-2.6/drivers/md/Makefile
@@ -36,6 +36,7 @@ obj-$(CONFIG_DM_SNAPSHOT)	+= dm-snapshot
 obj-$(CONFIG_DM_MIRROR)		+= dm-mirror.o dm-log.o dm-region-hash.o
 obj-$(CONFIG_DM_LOG_USERSPACE)	+= dm-log-userspace.o
 obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
+obj-$(CONFIG_DM_RAID)	+= dm-raid.o
 
 ifeq ($(CONFIG_DM_UEVENT),y)
 dm-mod-objs			+= dm-uevent.o
Index: linux-2.6/drivers/md/dm-raid.c
===================================================================
--- /dev/null
+++ linux-2.6/drivers/md/dm-raid.c
@@ -0,0 +1,549 @@
+
+/*
+ * dm-raid - implemented as wrapper for md/raid456
+ *
+ */
+#include <linux/slab.h>
+#include "md.h"
+#include "raid5.h"
+#include "dm.h"
+#include "bitmap.h"
+
+#define DM_MSG_PREFIX "raid"
+
+struct raid_dev {
+	/*
+	 * Two DM devices, one to hold metadata and one to hold the
+	 * actual data/parity.  The reason for this is to not confuse
+	 * ti->len and give more flexibility in altering size and
+	 * characteristics.
+	 *
+	 * While it is possible for this device to be associated
+	 * with a different physical device than the data_dev, it
+	 * is intended for it to be the same.
+	 *    |--------- Physical Device ---------|
+	 *    |- meta_dev -|------ data_dev ------|
+	 */
+	struct dm_dev *meta_dev;
+	struct dm_dev *data_dev;
+	struct mdk_rdev_s rdev;
+};
+
+struct raid_set {
+	struct dm_target *ti;
+
+#define DMPF_DAEMON_SLEEP 0x1
+#define DMPF_WRITE_BEHIND 0x2
+#define DMPF_SYNC         0x4
+#define DMPF_NOSYNC       0x8
+#define DMPF_STRIPECACHE  0x10
+#define DMPF_MINSPEED     0X20
+#define DMPF_MAXSPEED     0X40
+	uint64_t print_flags;
+
+	struct mddev_s md;
+	struct raid_type *raid_type;
+
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
+	{"raid6_zr", "RAID6 (zero restart)",		2, 4, 6, ALGORITHM_ROTATING_ZERO_RESTART},
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
+context_alloc(struct dm_target *ti, struct raid_type *raid_type, long raid_devs)
+{
+	int i;
+	struct raid_set *rs;
+	sector_t sectors_per_dev;
+
+	sectors_per_dev = ti->len;
+	if (sector_div(sectors_per_dev, (raid_devs - raid_type->parity_devs))) {
+		ti->error = "Target length not divisible by number of data devices";
+		return ERR_PTR(-EINVAL);
+	}
+
+	rs = kzalloc(sizeof(*rs) + raid_devs * sizeof(rs->dev[0]), GFP_KERNEL);
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
+	rs->md.new_level = rs->md.level;
+	rs->md.dev_sectors = sectors_per_dev;
+	rs->md.layout = raid_type->algorithm;
+	rs->md.new_layout = rs->md.layout;
+	rs->md.delta_disks = 0;
+	rs->md.recovery_cp = 0;
+
+	for (i = 0; i < raid_devs; i++)
+		md_rdev_init(&rs->dev[i].rdev);
+
+	/*
+	 * Remaining items to be initialized by further RAID params:
+	 *  rs->md.persistent
+	 *  rs->md.external
+	 *  rs->md.chunk_sectors
+	 *  rs->md.new_chunk_sectors
+	 */
+
+	return rs;
+}
+
+static void context_free(struct raid_set *rs)
+{
+	int i;
+	for (i = 0; i < rs->md.raid_disks; i++) {
+		if (rs->dev[i].data_dev)
+			dm_put_device(rs->ti, rs->dev[i].data_dev);
+	}
+	kfree(rs);
+}
+
+/* For every device we have two words
+ *  <meta_dev>: meta device name or '-' if missing
+ *  <data_dev>: data device name or '-' if missing
+ *
+ * This code parses those words.
+ */
+static int dev_parms(struct raid_set *rs, char **argv)
+{
+	int i;
+	int rebuild = 0;
+	int metadata_available = 0;
+
+	for (i = 0; i < rs->md.raid_disks; i++, argv += 2) {
+		int err = 0;
+
+		rs->dev[i].rdev.raid_disk = i;
+
+		rs->dev[i].meta_dev = NULL;
+		rs->dev[i].data_dev = NULL;
+
+		/*
+		 * There are no offsets, since there is a separate device
+		 * for data and metadata.
+		 */
+		rs->dev[i].rdev.data_offset = 0;
+		rs->dev[i].rdev.mddev = &rs->md;
+
+		if (strcmp(argv[0], "-") != 0) {
+			rs->ti->error = "Metadata devices not supported";
+			return -EINVAL;
+		}
+
+		if (strcmp(argv[1], "-") == 0) {
+			rs->ti->error = "Drive designated for rebuild not specified";
+			if (!test_bit(In_sync, &rs->dev[i].rdev.flags) &&
+			    (rs->dev[i].rdev.recovery_offset == 0))
+				return -EINVAL;
+
+			continue;
+		}
+
+		err = dm_get_device(rs->ti, argv[1],
+				    dm_table_get_mode(rs->ti->table),
+				    &rs->dev[i].data_dev);
+		rs->ti->error = "RAID device lookup failure";
+		if (err)
+			return err;
+
+		rs->dev[i].rdev.bdev = rs->dev[i].data_dev->bdev;
+		list_add(&rs->dev[i].rdev.same_set, &rs->md.disks);
+		if (!test_bit(In_sync, &rs->dev[i].rdev.flags))
+			rebuild++;
+	}
+
+	if (metadata_available) {
+		rs->md.external = 0;
+		rs->md.persistent = 1;
+		rs->md.major_version = 2;
+	} else if (rebuild && !rs->md.recovery_cp) {
+		/*
+		 * Without metadata, we will not be able to tell if the array
+		 * is in-sync or not - we must assume it is not.  Therefore,
+		 * it is impossible to rebuild a drive.
+		 *
+		 * Even if there is metadata, the on-disk information may
+		 * indicate that the array is not in-sync and it will then
+		 * fail at that time.
+		 *
+		 * User could specify 'nosync' option if desperate.
+		 */
+		DMERR("Unable to rebuild drive while array is not in-sync");
+		rs->ti->error = "RAID device lookup failure";
+		return -EINVAL;
+	}
+
+	rs->ti->error = NULL;
+	return 0;
+}
+
+/*
+ * Possible arguments are...
+ * RAID4:
+ *	<chunk_size> <parity_rebuild> [[no]sync]
+ * RAID5*:
+ *	<chunk_size> <parity_rebuild> [[no]sync]
+ * RAID6*:
+ *	<chunk_size> <parity_rebuildA> <parity_rebuildB> [[no]sync]
+ *
+ * The <parity_rebuild> argument causes the parity drive(s) to be rebuilt
+ * if they are specified (as an index to the device list).  -1 indicates
+ * the parity drive does not need to be rebuilt.
+ */
+static int parse_raid_params(struct raid_set *rs, char **argv,
+			     unsigned long num_raid_params)
+{
+	int i, rebuild_cnt = 0;
+	unsigned long arg;
+	char *reason = NULL;
+	struct mddev_s *mddev = &rs->md;
+
+	/*
+	 * First, parse the in-order required arguments
+	 */
+	rs->ti->error = "Bad chunk size";
+	if ((strict_strtoul(argv[0], 10, &arg) < 0) ||
+	    !is_power_of_2(arg) || (arg < 8))
+		return -EINVAL;
+	rs->md.new_chunk_sectors = rs->md.chunk_sectors = arg;
+	argv++;
+	num_raid_params--;
+
+	/*
+	 * Second, parse the unordered optional arguments
+	 */
+	for (i = 0; i < rs->md.raid_disks; i++)
+		set_bit(In_sync, &rs->dev[i].rdev.flags);
+
+	for (i = 0; i < num_raid_params; i++) {
+		if (strstr(argv[i], "rebuild=") &&
+		    (sscanf(argv[i], "rebuild=%lu", &arg) == 1)) {
+			if (++rebuild_cnt > rs->raid_type->parity_devs)
+				reason = "Too many rebuild drives given";
+			else if ((arg < 0) || (arg > rs->md.raid_disks))
+				reason = "Invalid rebuild index given";
+			else {
+				clear_bit(In_sync, &rs->dev[arg].rdev.flags);
+				rs->dev[arg].rdev.recovery_offset = 0;
+			}
+		} else if (strstr(argv[i], "write_behind=") &&
+			   (sscanf(argv[i], "write_behind=%lu", &arg) == 1)) {
+			rs->print_flags |= DMPF_WRITE_BEHIND;
+			if (arg > COUNTER_MAX)
+				reason = "write-behind limit out of range";
+			else
+				mddev->bitmap_info.max_write_behind = arg;
+		} else if (strstr(argv[i], "daemon_sleep=") &&
+			   (sscanf(argv[i], "daemon_sleep=%lu", &arg) == 1)) {
+			/* FIXME: Allow finer granularity? (only in sec now) */
+			rs->print_flags |= DMPF_DAEMON_SLEEP;
+			if ((arg < 1) || (arg > MAX_SCHEDULE_TIMEOUT/HZ))
+				reason = "daemon sleep period out of range";
+			else
+				mddev->bitmap_info.daemon_sleep = arg * HZ;
+		} else if (strstr(argv[i], "stripecache=") &&
+			   (sscanf(argv[i], "stripecache=%lu", &arg) == 1)) {
+			rs->print_flags |= DMPF_STRIPECACHE;
+			if (rs->raid_type->level < 5)
+				reason = "Inappropriate argument, stripecache";
+			else if (raid5_set_cache_size(&rs->md, (int)arg))
+				reason = "Bad stripecache size";
+		} else if (strstr(argv[i], "minspeed=") &&
+			   (sscanf(argv[i], "minspeed=%lu", &arg) == 1)) {
+			rs->print_flags |= DMPF_MINSPEED;
+			rs->md.sync_speed_min = (int)arg;
+		} else if (strstr(argv[i], "maxspeed=") &&
+			   (sscanf(argv[i], "maxspeed=%lu", &arg) == 1)) {
+			rs->print_flags |= DMPF_MAXSPEED;
+			rs->md.sync_speed_max = (int)arg;
+		} else if (!strcmp(argv[i], "nosync")) {
+			rs->md.recovery_cp = MaxSector;
+			rs->print_flags |= DMPF_NOSYNC;
+			rs->md.flags |= MD_SYNC_STATE_FORCED;
+		} else if (!strcmp(argv[i], "sync")) {
+			rs->md.recovery_cp = 0;
+			rs->print_flags |= DMPF_SYNC;
+			rs->md.flags |= MD_SYNC_STATE_FORCED;
+		} else {
+			DMERR("Unable to parse RAID parameter, %s", argv[i]);
+			reason = "Unable to parse RAID parameters";
+		}
+		if (reason)
+			goto out;
+	}
+
+	/* Assume there are no metadata devices until the drives are parsed */
+	rs->md.persistent = 0;
+	rs->md.external = 1;
+
+out:
+	rs->ti->error = reason;
+	return (reason) ? -EINVAL : 0;
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
+ *	<raid_type> <#raid_params> <raid_params>		\
+ *	<#raid_devs> { <meta_dev1> <dev1> .. <meta_devN> <devN> }
+ *
+ * ** metadata devices are not supported yet, use '-' instead **
+ *
+ * <raid_params> varies by <raid_type>.  See 'parse_raid_params' for
+ * details on possible <raid_params>.
+ */
+static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
+{
+	char *err = NULL;
+	int errnum = -EINVAL;
+	struct raid_type *rt;
+	unsigned long num_raid_params, num_raid_devs;
+	struct raid_set *rs = NULL;
+
+	/* Must have at least <raid_type> <#raid_params> */
+	err = "Too few arguments";
+	if (argc < 2)
+		goto err;
+
+	/* raid type */
+	err = "Cannot find raid_type";
+	rt = get_raid_type(argv[0]);
+	if (!rt)
+		goto err;
+	argc--; argv++;
+
+	/* number of RAID parameters */
+	err = "Cannot understand number of RAID parameters";
+	if (strict_strtoul(argv[0], 10, &num_raid_params) < 0)
+		goto err;
+	argc--; argv++;
+
+	/* Skip over RAID params for now and find out # of devices */
+	err = "Arguments do not agree with counts given";
+	if (num_raid_params + 1 > argc)
+		goto err;
+
+	err = "Bad number of raid devices";
+	if (strict_strtol(argv[num_raid_params], 10, &num_raid_devs) < 0)
+		goto err;
+
+	rs = context_alloc(ti, rt, num_raid_devs);
+	if (IS_ERR(rs))
+		return PTR_ERR(rs);
+
+	errnum = parse_raid_params(rs, argv, num_raid_params);
+	if (errnum) {
+		err = ti->error;
+		goto err;
+	}
+	errnum = -EINVAL;
+
+	argc -= num_raid_params + 1; /* +1: we already have num_raid_devs */
+	argv += num_raid_params + 1;
+
+	err = "Supplied RAID devices does not match the count given";
+	if (argc != (num_raid_devs * 2))
+		goto err;
+
+	errnum = dev_parms(rs, argv);
+	if (errnum) {
+		err = ti->error;
+		goto err;
+	}
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
+	if (!errnum)
+		return 0;
+
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
+	int raid_param_cnt = 1; /* at least 1 for chunksize */
+	int i;
+	sector_t sync;
+
+	switch (type) {
+	case STATUSTYPE_INFO:
+		DMEMIT("%s %d ", rs->raid_type->name, rs->md.raid_disks);
+		for (i = 0; i < rs->md.raid_disks; i++) {
+			if (rs->dev[i].data_dev)
+				DMEMIT("%s ", rs->dev[i].data_dev->name);
+			else
+				DMEMIT("- ");
+		}
+		for (i = 0; i < rs->md.raid_disks; i++) {
+			if (test_bit(Faulty, &rs->dev[i].rdev.flags))
+				DMEMIT("D");
+			else if (test_bit(In_sync, &rs->dev[i].rdev.flags))
+				DMEMIT("A");
+			else
+				DMEMIT("a");
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
+
+		break;
+	case STATUSTYPE_TABLE:
+		/* The string you would use to construct this array */
+		for (i = 0; i < rs->md.raid_disks; i++)
+			if (rs->dev[i].data_dev &&
+			    !test_bit(In_sync, &rs->dev[i].rdev.flags))
+				raid_param_cnt++; /* for rebuilds */
+		raid_param_cnt += hweight64(rs->print_flags);
+
+		DMEMIT("%s %d %u", rs->raid_type->name,
+		       raid_param_cnt, rs->md.chunk_sectors);
+
+		for (i = 0; i < rs->md.raid_disks; i++)
+			if (rs->dev[i].data_dev &&
+			    !test_bit(In_sync, &rs->dev[i].rdev.flags))
+				DMEMIT(" rebuild=%u", i);
+
+		if (rs->print_flags & DMPF_DAEMON_SLEEP)
+			DMEMIT(" daemon_sleep=%lu",
+			       rs->md.bitmap_info.daemon_sleep/HZ);
+		if (rs->print_flags & DMPF_WRITE_BEHIND)
+			DMEMIT(" write_behind=%lu",
+			       rs->md.bitmap_info.max_write_behind);
+		if (rs->print_flags & DMPF_STRIPECACHE)
+			DMEMIT(" stripecache=<unknown>");
+		if (rs->print_flags & DMPF_MINSPEED)
+			DMEMIT(" minspeed=%d", rs->md.sync_speed_min);
+		if (rs->print_flags & DMPF_MAXSPEED)
+			DMEMIT(" maxspeed=%d", rs->md.sync_speed_max);
+		if ((rs->print_flags & DMPF_SYNC) &&
+		    (rs->md.recovery_cp == MaxSector))
+			DMEMIT(" sync");
+		if (rs->print_flags & DMPF_NOSYNC)
+			DMEMIT(" nosync");
+
+		DMEMIT(" %d", rs->md.raid_disks);
+		for (i = 0; i < rs->md.raid_disks; i++) {
+			DMEMIT(" -"); /* metadata device */
+
+			if (rs->dev[i].data_dev)
+				DMEMIT(" %s", rs->dev[i].data_dev->name);
+			else
+				DMEMIT(" -");
+		}
+		break;
+	}
+	return 0;
+}
+
+static struct target_type raid_target = {
+	.name = "raid",
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
