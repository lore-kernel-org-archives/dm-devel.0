From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 4/8] dm raid: skeleton raid456 target support
Date: Mon, 20 Dec 2010 21:37:41 -0500
Message-ID: <1292899065-31943-5-git-send-email-snitzer@redhat.com>
References: <1292899065-31943-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1292899065-31943-1-git-send-email-snitzer@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: jbrassow@redhat.com, neilb@suse.de
Cc: agk@redhat.com, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

From: NeilBrown <neilb@suse.de>

This patch is the skeleton for the DM target that will be
the bridge from DM to MD (initially RAID456 and later RAID1).  It
provides a way to use device-mapper interfaces to the MD RAID456
drivers.  Additional changes are still needed to provide a functional
DM target.

As with all device-mapper targets, the nominal public interfaces are the
constructor (CTR) tables and the status outputs (both STATUSTYPE_INFO
and STATUSTYPE_TABLE).  The CTR table looks like the following:

1: <s> <l> raid \
2:	<raid_type> <#raid_params> <raid_params> \
3:	<#raid_devs> <meta_dev1> <dev1> .. <meta_devN> <devN>

Line 1 contains the standard first three arguments to any device-mapper
target - the start, length, and target type fields.  The target type in
this case is "raid".

Line 2 contains the arguments that define the particular raid
type/personality/level, the required arguments for that raid type, and
any optional arguments.  Possible raid types include: raid4, raid5_la,
raid5_ls, raid5_rs, raid6_zr, raid6_nr, and raid6_nc.  (again, raid1 is
planned for the future.)  The list of required and optional parameters
is the same for all the current raid types.  The required parameters are
positional, while the optional parameters are given as key/value pairs.
The possible parameters are as follows:
 <chunk_size>		Chunk size in sectors.
 [[no]sync]		Force/Prevent RAID initialization
 [rebuild <idx>]	Rebuild the drive indicated by the index
 [daemon_sleep <ms>]	Time between bitmap daemon work to clear bits
 [min_recovery_rate <kB/sec/disk>]	Throttle RAID initialization
 [max_recovery_rate <kB/sec/disk>]	Throttle RAID initialization
 [max_write_behind <value>]		See '-write-behind=' (man mdadm)
 [stripe_cache <sectors>]		Stripe cache size for higher RAIDs

Line 3 contains the list of devices that compose the array in
metadata/data device pairs.  If the metadata is stored separately, a '-'
is given for the metadata device position.  If a drive has failed or is
missing at creation time, a '-' can be given for both the metadata and
data drives for a given position.

Examples:
# RAID4 - 4 data drives, 1 parity
# No metadata devices specified to hold superblock/bitmap info
# Chunk size of 1MiB
# (Lines separated for easy reading)
0 1960893648 raid \
	raid4 1 2048 \
	5 - 8:17 - 8:33 - 8:49 - 8:65 - 8:81

# RAID4 - 4 data drives, 1 parity (no metadata devices)
# Chunk size of 1MiB, force RAID initialization,
#	min recovery rate at 20 kiB/sec/disk
0 1960893648 raid \
        raid4 4 2048 min_recovery_rate 20 sync\
        5 - 8:17 - 8:33 - 8:49 - 8:65 - 8:81

Performing a 'dmsetup table' should display the CTR table used to
construct the mapping (with possible reordering of optional
parameters).

Performing a 'dmsetup status' will yield information on the state and
health of the array.  The output is as follows:
1: <s> <l> raid \
2:	<raid_type> <#devices> <1 health char for each dev> <resync_ratio>

Line 1 is standard DM output.  Line 2 is best shown by example:
	0 1960893648 raid raid4 5 AAAAA 2/490221568
Here we can see the RAID type is raid4, there are 5 devices - all of
which are 'A'live, and the array is 2/490221568 complete with recovery.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/Kconfig   |   23 ++
 drivers/md/Makefile  |    1 +
 drivers/md/dm-raid.c |  585 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 609 insertions(+), 0 deletions(-)
 create mode 100644 drivers/md/dm-raid.c

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index bf1a95e..386501f 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -240,6 +240,29 @@ config DM_MIRROR
          Allow volume managers to mirror logical volumes, also
          needed for live data migration tools such as 'pvmove'.
 
+config DM_RAID
+       tristate "RAID 4/5/6 target (EXPERIMENTAL)"
+       depends on BLK_DEV_DM && EXPERIMENTAL
+       select MD_RAID456
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
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 5e3aac4..d013860 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -36,6 +36,7 @@ obj-$(CONFIG_DM_SNAPSHOT)	+= dm-snapshot.o
 obj-$(CONFIG_DM_MIRROR)		+= dm-mirror.o dm-log.o dm-region-hash.o
 obj-$(CONFIG_DM_LOG_USERSPACE)	+= dm-log-userspace.o
 obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
+obj-$(CONFIG_DM_RAID)	+= dm-raid.o
 
 ifeq ($(CONFIG_DM_UEVENT),y)
 dm-mod-objs			+= dm-uevent.o
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
new file mode 100644
index 0000000..edcccd8
--- /dev/null
+++ b/drivers/md/dm-raid.c
@@ -0,0 +1,585 @@
+/*
+ * Copyright (C) 2010 Neil Brown
+ * Copyright (C) 2010 Red Hat, Inc. All rights reserved.
+ *
+ * This file is released under the GPL.
+ */
+
+#include <linux/slab.h>
+
+#include "md.h"
+#include "raid5.h"
+#include "dm.h"
+#include "bitmap.h"
+
+#define DM_MSG_PREFIX "raid"
+
+/*
+ * If the MD doesn't support MD_SYNC_STATE_FORCED yet, then
+ * make it so the flag doesn't set anything.
+ */
+#ifndef MD_SYNC_STATE_FORCED
+#define MD_SYNC_STATE_FORCED 0
+#endif
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
+/*
+ * Flags for rs->print_flags field.
+ */
+#define DMPF_DAEMON_SLEEP      0x1
+#define DMPF_MAX_WRITE_BEHIND  0x2
+#define DMPF_SYNC              0x4
+#define DMPF_NOSYNC            0x8
+#define DMPF_STRIPE_CACHE      0x10
+#define DMPF_MIN_RECOVERY_RATE 0x20
+#define DMPF_MAX_RECOVERY_RATE 0x40
+
+struct raid_set {
+	struct dm_target *ti;
+
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
+/*
+ * For every device we have two words
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
+ * RAID456:
+ *	<chunk_size> [optional_args]
+ *
+ * Optional args include:
+ *	[[no]sync]		Force or prevent recovery of the entire array
+ *	[rebuild <idx>]		Rebuild the drive indicated by the index
+ *	[daemon_sleep <ms>]	Time between bitmap daemon work to clear bits
+ *	[min_recovery_rate <kB/sec/disk>]
+ *	[max_recovery_rate <kB/sec/disk>]
+ *	[max_write_behind <sectors>]
+ *	[stripe_cache <sectors>]
+ */
+static int parse_raid_params(struct raid_set *rs, char **argv,
+			     unsigned long num_raid_params)
+{
+	int i, rebuild_cnt = 0;
+	unsigned long value;
+	char *key;
+	char *reason = NULL;
+	struct mddev_s *mddev = &rs->md;
+
+	/*
+	 * First, parse the in-order required arguments
+	 */
+	rs->ti->error = "Bad chunk size";
+	if ((strict_strtoul(argv[0], 10, &value) < 0) ||
+	    !is_power_of_2(value) || (value < 8))
+		return -EINVAL;
+	rs->md.new_chunk_sectors = rs->md.chunk_sectors = value;
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
+		if (!strcmp(argv[i], "nosync")) {
+			rs->md.recovery_cp = MaxSector;
+			rs->print_flags |= DMPF_NOSYNC;
+			rs->md.flags |= MD_SYNC_STATE_FORCED;
+			continue;
+		}
+		if (!strcmp(argv[i], "sync")) {
+			rs->md.recovery_cp = 0;
+			rs->print_flags |= DMPF_SYNC;
+			rs->md.flags |= MD_SYNC_STATE_FORCED;
+			continue;
+		}
+
+		/* The rest of the optional arguments come in key/value pairs */
+		if ((i + 1) >= num_raid_params) {
+			reason = "Wrong number of raid parameters given";
+			goto out;
+		}
+		key = argv[i];
+		i++;
+		if (strict_strtoul(argv[i], 10, &value) < 0) {
+			reason = "Bad numerical argument given in raid params";
+			goto out;
+		}
+
+		if (!strcmp(key, "rebuild")) {
+			if (++rebuild_cnt > rs->raid_type->parity_devs)
+				reason = "Too many rebuild drives given";
+			else if ((value < 0) || (value > rs->md.raid_disks))
+				reason = "Invalid rebuild index given";
+			else {
+				clear_bit(In_sync, &rs->dev[value].rdev.flags);
+				rs->dev[value].rdev.recovery_offset = 0;
+			}
+		} else if (!strcmp(key, "max_write_behind")) {
+			rs->print_flags |= DMPF_MAX_WRITE_BEHIND;
+
+			/*
+			 * In device-mapper, we specify things in sectors, but
+			 * MD records this value in kB
+			 */
+			value /= 2;
+			if (value > COUNTER_MAX)
+				reason = "Max write-behind limit out of range";
+			else
+				mddev->bitmap_info.max_write_behind = value;
+		} else if (!strcmp(key, "daemon_sleep")) {
+			rs->print_flags |= DMPF_DAEMON_SLEEP;
+			if ((value < 1) || (value > MAX_SCHEDULE_TIMEOUT))
+				reason = "daemon sleep period out of range";
+			else
+				mddev->bitmap_info.daemon_sleep = value;
+		} else if (!strcmp(key, "stripe_cache")) {
+			rs->print_flags |= DMPF_STRIPE_CACHE;
+
+			/*
+			 * In device-mapper, we specify things in sectors, but
+			 * MD records this value in kB
+			 */
+			value /= 2;
+			if (rs->raid_type->level < 5)
+				reason = "Inappropriate argument, stripe_cache";
+			else if (raid5_set_cache_size(&rs->md, (int)value))
+				reason = "Bad stripe_cache size";
+		} else if (!strcmp(key, "min_recovery_rate")) {
+			rs->print_flags |= DMPF_MIN_RECOVERY_RATE;
+			rs->md.sync_speed_min = (int)value;
+		} else if (!strcmp(key, "max_recovery_rate")) {
+			rs->print_flags |= DMPF_MAX_RECOVERY_RATE;
+			rs->md.sync_speed_max = (int)value;
+			rs->md.flags |= MD_SYNC_STATE_FORCED;
+		} else {
+			DMERR("Unable to parse RAID parameter, %s", key);
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
+	int sz = 0;
+	int raid_param_cnt = 1; /* at least 1 for chunksize */
+	int i;
+	sector_t sync;
+
+	switch (type) {
+	case STATUSTYPE_INFO:
+		DMEMIT("%s %d ", rs->raid_type->name, rs->md.raid_disks);
+		for (i = 0; i < rs->md.raid_disks; i++) {
+			if (test_bit(Faulty, &rs->dev[i].rdev.flags))
+				DMEMIT("D");
+			else if (test_bit(In_sync, &rs->dev[i].rdev.flags))
+				DMEMIT("A");
+			else
+				DMEMIT("a");
+		}
+		if (test_bit(MD_RECOVERY_RUNNING, &rs->md.recovery))
+			sync = rs->md.curr_resync_completed;
+		else
+			sync = rs->md.recovery_cp;
+		if (sync > rs->md.resync_max_sectors)
+			sync = rs->md.resync_max_sectors;
+		DMEMIT(" %llu/%llu",
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
+
+		raid_param_cnt += (hweight64(rs->print_flags) * 2);
+		if (rs->print_flags & (DMPF_SYNC | DMPF_NOSYNC))
+			raid_param_cnt--;
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
+			DMEMIT(" daemon_sleep %lu",
+			       rs->md.bitmap_info.daemon_sleep);
+		if (rs->print_flags & DMPF_MAX_WRITE_BEHIND)
+			DMEMIT(" max_write_behind %lu",
+			       rs->md.bitmap_info.max_write_behind);
+		if (rs->print_flags & DMPF_STRIPE_CACHE)
+			DMEMIT(" stripe_cache <unknown>");
+		if (rs->print_flags & DMPF_MIN_RECOVERY_RATE)
+			DMEMIT(" min_recovery_rate %d", rs->md.sync_speed_min);
+		if (rs->print_flags & DMPF_MAX_RECOVERY_RATE)
+			DMEMIT(" max_recovery_rate %d", rs->md.sync_speed_max);
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
-- 
1.7.2.3

