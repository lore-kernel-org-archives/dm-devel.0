From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 1/6] dm raid45 target: export region hash
	functions and add a needed one
Date: Mon, 22 Jun 2009 22:25:23 +1000
Message-ID: <19007.30771.340158.565686@notabene.brown>
References: <4a368301.KBrCZcokAm87BF/S%heinzm@redhat.com>
	<20090616140914.GA3348@infradead.org>
	<1245163906.28257.113.camel@o>
	<e9c3a7c20906161055g6434ffd8uc7fc1ca53950556@mail.gmail.com>
	<1245179467.4278.11.camel@o>
	<19000.8388.899607.749942@notabene.brown>
	<19002.60755.876186.489524@notabene.brown>
	<1245407630.12264.66.camel@o>
	<19006.8756.925105.737041@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: message from Neil Brown on Sunday June 21
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com, Dan Williams <dan.j.williams@intel.com>, device-mapper development <dm-devel@redhat.com>, Christoph Hellwig <hch@infradead.org>, Ed Ciechanowski <ed.ciechanowski@intel.com>
List-Id: dm-devel.ids

On Sunday June 21, neilb@suse.de wrote:
> On Friday June 19, heinzm@redhat.com wrote:
> > 
> > > 
> > > - You have introduced "dm-message" which is a frame work for sending
> > >   messages to dm targets.
> > 
> > dm-message is a parser for messages sent to a device-mapper targets
> > message interface. It aims at allowing common message parsing functions
> > to be shared between targets.
> > 
> > The message interface in general allows for runtime state changes of
> > targets like those you found below.
> > 
> > See "dmsetup message ..."
> > 

I didn't process this bit properly before...
When I saw "dm-message.c" I assumed you were setting up a whole not
messaging infrastructure, not just writing a parser.  Sorry about
that.
So I can now see that your approach is quite defensible. 
(I would still like to see dm using sysfs though :-)

> > > 
> > >  I will try to look at factoring out the md specific part of md/raid5
> > >  over the next few days (maybe next week) and see how that looks.
> > 
> > That'll be interesting to see how it fits into the device-mapper
> > framework
> > 
> > I take it You'll port code to create an "md-raid456" target ?
> 
> That's the idea.  I'll let you know when I have something credible.

Well... I now have something credible.
It is only lightly tested.  And parts of it are incredibly ugly.  The
could shouldn't be read as "this is how it should be done" but "this
is an issue that needs to be resolved - here is a hack for now".

I used a lot of your code and hacked md and raid5 until I could plug
them together.

I can feed
 0 12000000 raid456 core 1 1 raid5_la 6 128 -1 -1 -1 -1 nosync 4 3 /dev/sdb 0 /dev/sdc 0 /dev/sdd 0 /dev/sde 0

to "dmsetup create" and get a raid5.
I can change 'nosync' or 'sync' and it will resync.
If I mark one of the devices as needing rebuild, it will do that.
And I can mkfs, and "mount" and "cp -r" and it seems to work.
I can even "dmsetup remove" and then
  mdadm --create /dev/md0 -l5 -pla -n4 -z 2000000 --assume-clean /dev/sd[bcde]
and see the same data.

Some notes:
 - there are a number of raid5 layouts and raid6 layouts that md
   supports but which I have not coded support for.  These are mostly
   very odd layouts designed as transition points when converting a
   raid5 to a raid6.
 - I haven't supported all the possible positions for the parity block
   for raid4 - only '0' and 'N'.  Given that the kernel doesn't do any
   metadata management, user-space could always list the parity block
   first, then the data blocks, and you would only need one layout.
 - I have ignored io_size - md always uses PAGE_SIZE
 - Using "dev_to_initialize" doesn't generalise to raid6, which could
   have two devices to initialise.
 - Depending on metadata support, it can be useful to say "this device
   has been recovered up to sector X" or "the array is in-sync up to
   sector Y", rather than having binary flags for these concepts.
   It might be good to support this in the dm interface.  
   i.e. instead of "sync" or "nosync", have a number saying
   'sync from this sector onwards'.  Have a similar number for each
   drive.
 - The status reports I generate are quite different to what your code
   would generate, largely because I left some bits out.  You could
   put in some dummy values if you want currently-existing code to be
   able to parse it.
 - I haven't tested "dmsetup message" at all yet (it is getting late
   and I am tired :-)
 - I haven't preserved the XX_parm values... I'm not sure if I've lost
   something by not doing that.
 - I haven't supported auto-resize of the stripe cache.
 - I think that if a drive throws an error, the raid5 will freeze
   awaiting the faulty drive to be unblocked - which cannot currently
   be done.  It should alert user-space though.
 - Some of the code is really really ugly.
 - I've done something horrible to get a queue to use for unplugging.
   It doesn't feel right to use the dm devices queue, and there could
   be multiple targets hanging off the one dm-table, and they would
   fight for use of that queue.
 - Due it minor implementation details, you can currently only create
   one dm-raid5 at a time (it will be called 'md-X' in various
   messages and process names).
 - There are other ugly things in the code.
 - There are probably other things I've forgotten to mention.
 (BTW, there is an is_power_of_2() function in include/linux/log2.h)

I am unlikely to find more time to play with this until next week, but
I do hope to do some tidying up in md and raid5 then so some of this
code can be a little less ugly.

The following patch is on top of current linus.git kernel, with the
dm-message patch applied.

NeilBrown


commit b2224304f0d9553d73b1a47ddbdef2f0766dd07a
Author: NeilBrown <neilb@suse.de>
Date:   Mon Jun 22 21:52:32 2009 +1000

    dm-raid456

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 36e0675..eab8e52 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -264,4 +264,12 @@ config DM_UEVENT
 	---help---
 	Generate udev events for DM events.
 
+config DM_RAID456
+	tristate "RAID 4/5/6 target (EXPERIMENTAL)"
+	depends on BLK_DEV_DM && MD_RAID456 && EXPERIMENTAL
+	---help---
+	A targets that supports RAID4, RAID5, and RAID6 mappings
+
+	In unsure, say N.
+
 endif # MD
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 45cc595..dc99ae0 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -39,6 +39,7 @@ obj-$(CONFIG_DM_MULTIPATH)	+= dm-multipath.o dm-round-robin.o
 obj-$(CONFIG_DM_SNAPSHOT)	+= dm-snapshot.o
 obj-$(CONFIG_DM_MIRROR)		+= dm-mirror.o dm-log.o dm-region-hash.o
 obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
+obj-$(CONFIG_DM_RAID456)	+= dm-raid456.o dm-message.o
 
 quiet_cmd_unroll = UNROLL  $@
       cmd_unroll = $(PERL) $(srctree)/$(src)/unroll.pl $(UNROLL) \
diff --git a/drivers/md/dm-raid456.c b/drivers/md/dm-raid456.c
new file mode 100644
index 0000000..4bd1867
--- /dev/null
+++ b/drivers/md/dm-raid456.c
@@ -0,0 +1,1062 @@
+static const char *version = "v0.3000md";
+
+#include "md.h"
+#include "raid5.h"
+#include "dm.h"
+#include "dm-message.h"
+
+extern int raid5_congested(void *data, int bits);
+extern int raid5_set_cache_size(mddev_t *mddev, int size);
+extern int do_md_run(mddev_t * mddev);
+extern int do_md_stop(mddev_t * mddev, int mode, int is_open);
+extern int md_make_request(struct request_queue *q, struct bio *bio);
+extern void mddev_suspend(mddev_t *mddev);
+extern void mddev_resume(mddev_t *mddev);
+
+
+/* Factor out to dm.h. */
+/* Reference to array end. */
+#define ARRAY_END(a)    ((a) + ARRAY_SIZE(a))
+#define	SECTORS_PER_PAGE	(PAGE_SIZE >> SECTOR_SHIFT)
+
+/*
+ * Configurable parameters
+ */
+
+/* Minimum/maximum and default # of selectable stripes. */
+#define	STRIPES_MIN		8
+#define	STRIPES_MAX		16384
+#define	STRIPES_DEFAULT		80
+
+/* Maximum and default chunk size in sectors if not set in constructor. */
+#define	CHUNK_SIZE_MIN		8
+#define	CHUNK_SIZE_MAX		16384
+#define	CHUNK_SIZE_DEFAULT	64
+
+/* Default io size in sectors if not set in constructor. */
+#define	IO_SIZE_MIN		CHUNK_SIZE_MIN
+#define	IO_SIZE_DEFAULT		IO_SIZE_MIN
+
+/* Recover io size default in sectors. */
+#define	RECOVER_IO_SIZE_MIN		64
+#define	RECOVER_IO_SIZE_DEFAULT		256
+
+/* Default, minimum and maximum percentage of recover io bandwidth. */
+#define	BANDWIDTH_DEFAULT	10
+#define	BANDWIDTH_MIN		1
+#define	BANDWIDTH_MAX		100
+
+/* # of parallel recovered regions */
+#define RECOVERY_STRIPES_MIN	1
+#define RECOVERY_STRIPES_MAX	64
+#define RECOVERY_STRIPES_DEFAULT	RECOVERY_STRIPES_MIN
+/*
+ * END Configurable parameters
+ */
+
+#define	TARGET	"dm-raid45"
+#define	DM_MSG_PREFIX	TARGET
+
+/* Check value in range. */
+#define	range_ok(i, min, max)	(i >= min && i <= max)
+
+/* Check argument is power of 2. */
+#define POWER_OF_2(a) (!(a & (a - 1)))
+
+/* Factor out to dm.h */
+#define TI_ERR_RET(str, ret) \
+	do { ti->error = str; return ret; } while (0);
+#define TI_ERR(str)     TI_ERR_RET(str, -EINVAL)
+
+
+enum dm_lock_type { DM_RAID45_EX, DM_RAID45_SHARED };
+
+struct dm_raid45_locking_type {
+	/* Request a lock on a stripe. */
+	void* (*lock)(sector_t key, enum dm_lock_type type);
+
+	/* Release a lock on a stripe. */
+	void (*unlock)(void *lock_handle);
+};
+
+/*
+ * Stripe cache locking functions
+ */
+/* Dummy lock function for single host RAID4+5. */
+static void *no_lock(sector_t key, enum dm_lock_type type)
+{
+	return &no_lock;
+}
+
+/* Dummy unlock function for single host RAID4+5. */
+static void no_unlock(void *lock_handle)
+{
+}
+
+/* No locking (for single host RAID 4+5). */
+static struct dm_raid45_locking_type locking_none = {
+	.lock = no_lock,
+	.unlock = no_unlock,
+};
+
+struct raid_type {
+	const char *name;		/* RAID algorithm. */
+	const char *descr;		/* Descriptor text for logging. */
+	const unsigned parity_devs;	/* # of parity devices. */
+	const unsigned minimal_devs;	/* minimal # of devices in set. */
+	const unsigned level;		/* RAID level. */
+	const unsigned algorithm;	/* RAID algorithm. */
+};
+
+/* Supported raid types and properties. */
+static struct raid_type raid_types[] = {
+	{"raid4",    "RAID4 (dedicated parity disk)", 1, 2, 5, ALGORITHM_PARITY_0},
+	{"raid5_la", "RAID5 (left asymmetric)",       1, 2, 5, ALGORITHM_LEFT_ASYMMETRIC},
+	{"raid5_ra", "RAID5 (right asymmetric)",      1, 2, 5, ALGORITHM_RIGHT_ASYMMETRIC},
+	{"raid5_ls", "RAID5 (left symmetric)",        1, 2, 5, ALGORITHM_LEFT_SYMMETRIC},
+	{"raid5_rs", "RAID5 (right symmetric)",       1, 2, 5, ALGORITHM_RIGHT_SYMMETRIC},
+	{"raid6_zr", "RAID6 (zero restart)",          2, 4, 6, ALGORITHM_ROTATING_ZERO_RESTART },
+	{"raid6_nr", "RAID6 (N restart)",             2, 4, 6, ALGORITHM_ROTATING_N_RESTART},
+	{"raid6_nc", "RAID6 (N continue)",            2, 4, 5, ALGORITHM_ROTATING_N_CONTINUE}
+};
+
+/* Return pointer to raid_type structure for raid name. */
+static struct raid_type *get_raid_type(char *name)
+{
+	struct raid_type *r = ARRAY_END(raid_types);
+
+	while (r-- > raid_types) {
+		if (!strcmp(r->name, name))
+			return r;
+	}
+
+	return NULL;
+}
+
+/* FIXME: factor out to dm core. */
+static int multiple(sector_t a, sector_t b, sector_t *n)
+{
+	sector_t r = a;
+
+	sector_div(r, b);
+	*n = r;
+	return a == r * b;
+}
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
+	int raid_parms;
+	struct work_struct ws_do_table_event;
+	struct mdk_personality pers, *oldpers;
+	struct raid_dev dev[0];
+};
+
+/* Throw an event. */
+static void do_table_event(struct work_struct *ws)
+{
+	struct raid_set *rs = container_of(ws, struct raid_set,
+					   ws_do_table_event);
+	dm_table_event(rs->ti->table);
+}
+
+static void dm_raid5_error(mddev_t *mddev, mdk_rdev_t *rdev)
+{
+	struct raid_set *rs = container_of(mddev, struct raid_set, md);
+	
+	rs->oldpers->error_handler(mddev, rdev);
+	schedule_work(&rs->ws_do_table_event);
+}
+
+/*
+ * Allocate a RAID context (a RAID set)
+ */
+/* Structure for variable RAID parameters. */
+struct variable_parms {
+	int bandwidth;
+	int bandwidth_parm;
+	int chunk_size;
+	int chunk_size_parm;
+	int io_size;
+	int io_size_parm;
+	int stripes;
+	int stripes_parm;
+	int recover_io_size;
+	int recover_io_size_parm;
+	int raid_parms;
+	int recovery;
+	int recovery_stripes;
+	int recovery_stripes_parm;
+};
+
+static struct raid_set *
+context_alloc(struct raid_type *raid_type, struct variable_parms *p,
+	      unsigned raid_devs, sector_t sectors_per_dev,
+	      struct dm_target *ti, unsigned dl_parms, char **argv)
+{
+	/* No dirty log for now */
+	struct raid_set *rs;
+	int len;
+
+	len = sizeof(rs->dev[0]);
+	if (dm_array_too_big(sizeof(*rs), len, raid_devs))
+		goto bad_array;
+
+	len = sizeof(*rs) + raid_devs * len;
+	rs = kzalloc(len, GFP_KERNEL);
+	if (!rs)
+		goto bad_alloc;
+
+	rs->ti = ti;
+	/* initialisations from mddev_find */
+	mutex_init(&rs->md.reconfig_mutex);
+	INIT_LIST_HEAD(&rs->md.disks);
+	INIT_LIST_HEAD(&rs->md.all_mddevs);
+	init_timer(&rs->md.safemode_timer);
+	spin_lock_init(&rs->md.write_lock);
+	init_waitqueue_head(&rs->md.sb_wait);
+	init_waitqueue_head(&rs->md.recovery_wait);
+	rs->md.reshape_position = MaxSector;
+	rs->md.resync_max = MaxSector;
+	/* This is horrible! */
+	rs->md.queue = blk_alloc_queue(GFP_KERNEL);
+	/* initialise unplug timer */
+	blk_queue_make_request(rs->md.queue, NULL);
+	rs->md.queue->queuedata = &rs->md;
+	rs->md.sysfs_state = NULL;
+
+	rs->raid_type = raid_type;
+	rs->md.raid_disks = raid_devs;
+	rs->md.level = raid_type->level;
+	rs->md.dev_sectors = sectors_per_dev;
+	rs->md.persistent = 1;
+	rs->md.external = 1;
+	rs->md.layout = raid_type->algorithm;
+	rs->md.chunk_sectors = p->chunk_size;
+
+	if (p->recovery)
+		rs->md.recovery_cp = 0;
+	else
+		rs->md.recovery_cp = MaxSector;
+
+	rs->md.new_level = rs->md.level;
+	rs->md.new_chunk_sectors = rs->md.chunk_sectors;
+	rs->md.new_layout = rs->md.layout;
+	rs->md.delta_disks = 0;
+
+	INIT_WORK(&rs->ws_do_table_event, do_table_event);
+	return rs;
+
+bad_array:
+	TI_ERR_RET("Arry too big", ERR_PTR(-EINVAL));
+
+bad_alloc:
+	TI_ERR_RET("Cannot allocate raid context", ERR_PTR(-ENOMEM));
+}
+
+/* Free a RAID context (a RAID set). */
+static void context_free(struct raid_set *rs, unsigned p)
+{
+	while (p--)
+		dm_put_device(rs->ti, rs->dev[p].dev);
+
+	blk_put_queue(rs->md.queue);
+	kfree(rs);
+}
+
+/* Log RAID set information to kernel log. */
+static void rs_log(struct raid_set *rs)
+{
+	unsigned p;
+	char buf[BDEVNAME_SIZE];
+	raid5_conf_t *conf = rs->md.private;
+
+	for (p = 0; p < rs->md.raid_disks; p++)
+		DMINFO("/dev/%s is raid disk %u",
+		       bdevname(rs->dev[p].dev->bdev, buf), p);
+
+	DMINFO("%d sectors chunk size, %u stripes\n"
+	       "%s set with %u devices",
+	       rs->md.chunk_sectors,
+	       conf->max_nr_stripes,
+	       rs->raid_type->descr, rs->md.raid_disks);
+}
+/* Get all devices and offsets. */
+static int dev_parms(struct raid_set *rs, char **argv, int dev_to_init, int *p)
+{
+	struct dm_target *ti = rs->ti;
+
+	for (*p = 0; *p < rs->md.raid_disks; (*p)++, argv += 2) {
+		int r;
+		unsigned long long tmp;
+		struct raid_dev *dev = rs->dev + *p;
+
+		/* Get offset and device. */
+		if (sscanf(argv[1], "%llu", &tmp) != 1 ||
+		    tmp > rs->md.dev_sectors)
+			/* FIXME this test doesn't make sense */
+			TI_ERR("Invalid RAID device offset parameter");
+
+		dev->rdev.data_offset = tmp;
+		r = dm_get_device(ti, *argv, tmp,
+				  rs->md.dev_sectors,
+				  dm_table_get_mode(ti->table), &dev->dev);
+		if (r)
+			TI_ERR_RET("RAID device lookup failure", r);
+
+		/* avoid duplicates */
+		for (r=0; r < *p; r++)
+			if (dev->dev->bdev == rs->dev[r].dev->bdev) {
+				dm_put_device(ti, dev->dev);
+				TI_ERR_RET("Duplicate RAID device", -ENXIO);
+			}
+		/* initialise rest of 'rdev' - from md_import_device */
+		dev->rdev.desc_nr = -1;
+		dev->rdev.saved_raid_disk = -1;
+		dev->rdev.raid_disk = *p;
+		dev->rdev.flags = 0;
+		if (*p != dev_to_init)
+			set_bit(In_sync, &dev->rdev.flags);
+		atomic_set(&dev->rdev.nr_pending, 0);
+		atomic_set(&dev->rdev.read_errors, 0);
+		atomic_set(&dev->rdev.corrected_errors, 0);
+		init_waitqueue_head(&dev->rdev.blocked_wait);
+		dev->rdev.sb_start = 0;
+		dev->rdev.sb_size = 0;
+		/* and from bind_rdev_to_array */
+		dev->rdev.mddev = &rs->md;
+		dev->rdev.sysfs_state = NULL;
+		dev->rdev.bdev = dev->dev->bdev;
+		list_add(&dev->rdev.same_set, &rs->md.disks);
+	}
+
+	return 0;
+}
+
+/* Parse optional locking parameters. */
+static int get_raid_locking_parms(struct dm_target *ti, char **argv,
+				  int *locking_parms,
+				  struct dm_raid45_locking_type **locking_type)
+{
+	if (!strnicmp(argv[0], "locking", strlen(argv[0]))) {
+		char *lckstr = argv[1];
+		size_t lcksz = strlen(lckstr);
+
+		if (!strnicmp(lckstr, "none", lcksz)) {
+			*locking_type = &locking_none;
+			*locking_parms = 2;
+		} else if (!strnicmp(lckstr, "cluster", lcksz)) {
+			DMERR("locking type \"%s\" not yet implemented",
+			      lckstr);
+			return -EINVAL;
+		} else {
+			DMERR("unknown locking type \"%s\"", lckstr);
+			return -EINVAL;
+		}
+	}
+
+	*locking_parms = 0;
+	*locking_type = &locking_none;
+	return 0;
+}
+
+
+/* Set backing device read ahead properties of RAID set. */
+static void rs_set_read_ahead(struct raid_set *rs,
+			      unsigned sectors, unsigned stripes)
+{
+	unsigned ra_pages = dm_div_up(sectors, SECTORS_PER_PAGE);
+	struct mapped_device *md = dm_table_get_md(rs->ti->table);
+	struct backing_dev_info *bdi = &dm_disk(md)->queue->backing_dev_info;
+
+	/* Set read-ahead for the RAID set and the component devices. */
+	if (ra_pages) {
+		unsigned p = rs->md.raid_disks;
+		int data = p - 1;
+		if (rs->md.level == 6)
+			data --;
+
+		bdi->ra_pages = stripes * ra_pages * data;
+
+		while (p--) {
+			struct request_queue *q =
+				bdev_get_queue(rs->dev[p].dev->bdev);
+
+			q->backing_dev_info.ra_pages = ra_pages;
+		}
+	}
+
+	dm_put(md);
+}
+
+/* RAID set congested function. */
+static int rs_congested(void *congested_data, int bdi_bits)
+{
+	int r;
+	unsigned p;
+	struct raid_set *rs = congested_data;
+
+	r = raid5_congested(&rs->md, bdi_bits);
+	if (r)
+		;
+	else for (r = 0, p = rs->md.raid_disks; !r && p--; ) {
+		/* If any of our component devices are overloaded. */
+		struct request_queue *q = bdev_get_queue(rs->dev[p].dev->bdev);
+
+		r |= bdi_congested(&q->backing_dev_info, bdi_bits);
+	}
+
+	return r;
+}
+
+/* Set congested function. */
+static void rs_set_congested_fn(struct raid_set *rs)
+{
+	struct mapped_device *md = dm_table_get_md(rs->ti->table);
+	struct backing_dev_info *bdi = &dm_disk(md)->queue->backing_dev_info;
+
+	/* Set congested function and data. */
+	bdi->congested_fn = rs_congested;
+	bdi->congested_data = rs;
+	dm_put(md);
+}
+
+/* Set recovery bandwidth */
+static void
+recover_set_bandwidth(struct raid_set *rs, unsigned bandwidth)
+{
+	/* hack to convert a percent to K/s assuming the device
+	 * can manage 100M/sec
+	 */
+	rs->md.sync_speed_min = bandwidth * 1024;
+}
+
+/* Get recovery bandwidth */
+static unsigned
+recover_get_bandwidth(struct raid_set *rs)
+{
+	return rs->md.sync_speed_min / 1024;
+}
+
+/* Handle variable number of RAID parameters. */
+static int get_raid_variable_parms(struct dm_target *ti, char **argv, 
+				   struct variable_parms *vp)
+{
+	int p, value;
+	struct {
+		int action; /* -1: skip, 0: no power2 check, 1: power2 check */
+		char *errmsg;
+		int min, max;
+		int *var, *var2, *var3;
+	} argctr[] = {
+		{ 1,
+		  "Invalid chunk size; must be -1 or 2^^n and <= 16384",
+ 		  IO_SIZE_MIN, CHUNK_SIZE_MAX,
+		  &vp->chunk_size_parm, &vp->chunk_size, &vp->io_size },
+		{ 0,
+		  "Invalid number of stripes: must be -1 or >= 8 and <= 16384",
+		  STRIPES_MIN, STRIPES_MAX,
+		  &vp->stripes_parm, &vp->stripes, NULL },
+		{ 1,
+		  "Invalid io size; must -1 or >= 8, 2^^n and less equal "
+		  "min(BIO_MAX_SECTORS/2, chunk size)",
+		  IO_SIZE_MIN, 0, /* Needs to be updated in loop below. */
+		  &vp->io_size_parm, &vp->io_size, NULL },
+		{ 1,
+		  "Invalid recovery io size; must be -1 or "
+		  "2^^n and less equal BIO_MAX_SECTORS/2",
+		  RECOVER_IO_SIZE_MIN, BIO_MAX_SECTORS / 2,
+		  &vp->recover_io_size_parm, &vp->recover_io_size, NULL },
+		{ 0,
+		  "Invalid recovery bandwidth percentage; "
+		  "must be -1 or > 0 and <= 100",
+		  BANDWIDTH_MIN, BANDWIDTH_MAX,
+		  &vp->bandwidth_parm, &vp->bandwidth, NULL },
+		/* Handle sync argument seperately in loop. */
+		{ -1,
+		  "Invalid recovery switch; must be \"sync\" or \"nosync\"" },
+		{ 0,
+		  "Invalid number of recovery stripes;"
+		  "must be -1, > 0 and <= 16384",
+		  RECOVERY_STRIPES_MIN, RECOVERY_STRIPES_MAX,
+		  &vp->recovery_stripes_parm, &vp->recovery_stripes, NULL },
+	}, *varp;
+
+	/* Fetch # of variable raid parameters. */
+	if (sscanf(*(argv++), "%d", &vp->raid_parms) != 1 ||
+	    !range_ok(vp->raid_parms, 0, 7))
+		TI_ERR("Bad variable raid parameters number");
+
+	/* Preset variable RAID parameters. */
+	vp->chunk_size = CHUNK_SIZE_DEFAULT;
+	vp->io_size = IO_SIZE_DEFAULT;
+	vp->stripes = STRIPES_DEFAULT;
+	vp->recover_io_size = RECOVER_IO_SIZE_DEFAULT;
+	vp->bandwidth = BANDWIDTH_DEFAULT;
+	vp->recovery = 1;
+	vp->recovery_stripes = RECOVERY_STRIPES_DEFAULT;
+
+	/* Walk the array of argument constraints for all given ones. */
+	for (p = 0, varp = argctr; p < vp->raid_parms; p++, varp++) {
+	     	BUG_ON(varp >= ARRAY_END(argctr));
+
+		/* Special case for "[no]sync" string argument. */
+		if (varp->action < 0) {
+			if (!strcmp(*argv, "sync"))
+				;
+			else if (!strcmp(*argv, "nosync"))
+				vp->recovery = 0;
+			else
+				TI_ERR(varp->errmsg);
+
+			argv++;
+			continue;
+		}
+
+		/*
+		 * Special case for io_size depending
+		 * on previously set chunk size.
+		 */
+		if (p == 2)
+			varp->max = min(BIO_MAX_SECTORS / 2, vp->chunk_size);
+
+		if (sscanf(*(argv++), "%d", &value) != 1 ||
+		    (value != -1 &&
+		     ((varp->action && !POWER_OF_2(value)) ||
+		      !range_ok(value, varp->min, varp->max))))
+			TI_ERR(varp->errmsg);
+
+		*varp->var = value;
+		if (value != -1) {
+			if (varp->var2)
+				*varp->var2 = value;
+			if (varp->var3)
+				*varp->var3 = value;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Construct a RAID4/5 mapping:
+ *
+ * log_type #log_params <log_params> \
+ * raid_type [#parity_dev] #raid_variable_params <raid_params> \
+ * [locking "none"/"cluster"]
+ * #raid_devs #dev_to_initialize [<dev_path> <offset>]{3,}
+ *
+ * log_type = "core"/"disk",
+ * #log_params = 1-3 (1-2 for core dirty log type, 3 for disk dirty log only)
+ * log_params = [dirty_log_path] region_size [[no]sync])
+ *
+ * raid_type = "raid4", "raid5_la", "raid5_ra", "raid5_ls", "raid5_rs",
+ *              "raid6_la", "raid6_ra", "raid6_ls", "raid6_rs",
+ *
+ * #parity_dev = N if raid_type = "raid4"
+ * o N = -1: pick default = last device
+ * o N == 0 or == #raid_devs-1: parity device index
+ *
+ * #raid_variable_params = 0-7; raid_params (-1 = default):
+ *   [chunk_size [#stripes [io_size [recover_io_size \
+ *    [%recovery_bandwidth [recovery_switch [#recovery_stripes]]]]]]]
+ *   o chunk_size (unit to calculate drive addresses; must be 2^^n, > 8
+ *     and <= CHUNK_SIZE_MAX)
+ *   o #stripes is number of stripes allocated to stripe cache
+ *     (must be > 1 and < STRIPES_MAX)
+ *   o io_size (io unit size per device in sectors; must be 2^^n and > 8)
+ *   o recover_io_size (io unit size per device for recovery in sectors;
+ must be 2^^n, > SECTORS_PER_PAGE and <= region_size)
+ *   o %recovery_bandwith is the maximum amount spend for recovery during
+ *     application io (1-100%)
+ *   o recovery switch = [sync|nosync]
+ *   o #recovery_stripes is the number of recovery stripes used for
+ *     parallel recovery of the RAID set
+ * If raid_variable_params = 0, defaults will be used.
+ * Any raid_variable_param can be set to -1 to apply a default
+ *
+ * #raid_devs = N (N >= 2)
+ *
+ * #dev_to_initialize = N
+ * -1: initialize parity on all devices
+ * >= 0 and < #raid_devs: initialize raid_path; used to force reconstruction
+ * of a failed devices content after replacement
+ *
+ * <dev_path> = device_path (eg, /dev/sdd1)
+ * <offset>   = begin at offset on <dev_path>
+ *
+ */
+#define	MIN_PARMS	13
+static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
+{
+	int dev_to_init, dl_parms, i, locking_parms,
+	    parity_parm, pi = -1, r, raid_devs;
+	sector_t tmp, sectors_per_dev;
+	struct dm_raid45_locking_type *locking;
+	struct raid_set *rs;
+	struct raid_type *raid_type;
+	struct variable_parms parms;
+
+	/* Ensure minimum number of parameters. */
+	if (argc < MIN_PARMS)
+		TI_ERR("Not enough parameters");
+
+	/* Fetch # of dirty log parameters. */
+	if (sscanf(argv[1], "%d", &dl_parms) != 1 ||
+	    !range_ok(dl_parms, 1, 4711)) /* ;-) */
+		TI_ERR("Bad dirty log parameters number");
+
+	/* Check raid_type. */
+	raid_type = get_raid_type(argv[dl_parms + 2]);
+	if (!raid_type)
+		TI_ERR("Bad raid type");
+
+	/* In case of RAID4, parity drive is selectable. */
+	parity_parm = !!(raid_type->level == 4);
+
+	/* Handle variable number of RAID parameters. */
+	r = get_raid_variable_parms(ti, argv + dl_parms + parity_parm + 3,
+				    &parms);
+	if (r)
+		return r;
+
+	/* Handle any locking parameters. */
+	r = get_raid_locking_parms(ti,
+				   argv + dl_parms + parity_parm +
+				   parms.raid_parms + 4,
+				   &locking_parms, &locking);
+	if (r)
+		return r;
+
+	/* # of raid devices. */
+	i = dl_parms + parity_parm + parms.raid_parms + locking_parms + 4;
+	if (sscanf(argv[i], "%d", &raid_devs) != 1 ||
+	    raid_devs < raid_type->minimal_devs)
+		TI_ERR("Invalid number of raid devices");
+
+	/* In case of RAID4, check parity drive index is in limits. */
+	if (raid_type->algorithm == ALGORITHM_PARITY_0) {
+		/* Fetch index of parity device. */
+		if (sscanf(argv[dl_parms + 3], "%d", &pi) != 1 ||
+		    (pi != -1 && pi != 0 && pi != raid_devs - 1))
+			TI_ERR("Invalid RAID4 parity device index");
+	}
+
+	/*
+	 * Index of device to initialize starts at 0
+	 *
+	 * o -1 -> don't initialize a selected device;
+	 *         initialize parity conforming to algorithm
+	 * o 0..raid_devs-1 -> initialize respective device
+	 *   (used for reconstruction of a replaced device)
+	 */
+	if (sscanf(argv[dl_parms + parity_parm + parms.raid_parms +
+		   locking_parms + 5], "%d", &dev_to_init) != 1 ||
+	    !range_ok(dev_to_init, -1, raid_devs - 1))
+		TI_ERR("Invalid number for raid device to initialize");
+
+	/* Check # of raid device arguments. */
+	if (argc - dl_parms - parity_parm - parms.raid_parms - 6 !=
+	    2 * raid_devs)
+		TI_ERR("Wrong number of raid device/offset arguments");
+
+	/*
+	 * Check that the table length is devisable
+	 * w/o rest by (raid_devs - parity_devs)
+	 */
+	if (!multiple(ti->len, raid_devs - raid_type->parity_devs,
+		      &sectors_per_dev))
+		TI_ERR("Target length not divisible by number of data devices");
+
+	/*
+	 * Check that the device size is
+	 * devisable w/o rest by chunk size
+	 */
+	if (!multiple(sectors_per_dev, parms.chunk_size, &tmp))
+		TI_ERR("Device length not divisible by chunk_size");
+
+	/****************************************************************
+	 * Now that we checked the constructor arguments ->
+	 * let's allocate the RAID set
+	 ****************************************************************/
+	rs = context_alloc(raid_type, &parms, raid_devs, sectors_per_dev,
+			   ti, dl_parms, argv);
+	if (IS_ERR(rs))
+		return PTR_ERR(rs);
+
+
+	if (rs->md.layout == ALGORITHM_PARITY_0 &&
+	    pi != 0)
+		rs->md.layout = ALGORITHM_PARITY_N;
+
+	recover_set_bandwidth(rs, parms.bandwidth);
+
+	/* Get the device/offset tupels. */
+	argv += dl_parms + 6 + parity_parm + parms.raid_parms;
+	r = dev_parms(rs, argv, dev_to_init, &i);
+	if (r)
+		goto err;
+
+	/* Set backing device information (eg. read ahead). */
+	rs_set_read_ahead(rs, 2 * rs->md.chunk_sectors /* sectors per device */,
+			      2 /* # of stripes */);
+	rs_set_congested_fn(rs); /* Set congested function. */
+
+	rs->raid_parms = parms.raid_parms;
+	/*
+	 * Make sure that dm core only hands maximum chunk_size
+	 * length down and pays attention to io boundaries.
+	 * This is only need for reads.  If reads are within on chunk,
+	 * we can by-pass the cache.
+	 */
+	ti->split_io = rs->md.chunk_sectors;
+	ti->private = rs;
+
+	/* Initialize work queue to handle this RAID set's io. */
+	mutex_lock(&rs->md.reconfig_mutex); 
+	r = do_md_run(&rs->md);
+
+	/* Now this is *really* horrible, but I need a call-back
+	 * when an error is thrown
+	 */
+	rs->oldpers = rs->md.pers;
+	rs->pers = *rs->md.pers;
+	rs->pers.error_handler = dm_raid5_error;
+	rs->md.pers = &rs->pers;
+	mutex_unlock(&rs->md.reconfig_mutex); 
+	if (r)
+		goto err;
+	rs->md.safemode = 0;
+	rs->md.safemode_delay = 0;
+	rs->md.in_sync = 0;
+	rs->md.ro = 0;
+	/* Now we can adjust the cache size */
+	raid5_set_cache_size(&rs->md, parms.stripes);
+
+	rs_log(rs); /* Log information about RAID set. */
+	return 0;
+
+err:
+	context_free(rs, i);
+	return r;
+}
+
+/*
+ * Destruct a raid mapping
+ */
+static void raid_dtr(struct dm_target *ti)
+{
+	struct raid_set *rs = ti->private;
+	int d = rs->md.raid_disks;
+
+	mutex_lock(&rs->md.reconfig_mutex);
+	mddev_resume(&rs->md);
+	do_md_stop(&rs->md, 2, 100);
+	mutex_unlock(&rs->md.reconfig_mutex);
+
+	context_free(rs, d);
+}
+
+/* Raid mapping function. */
+static int raid_map(struct dm_target *ti, struct bio *bio,
+		    union map_info *map_context)
+{
+	struct raid_set *rs = ti->private;
+	struct request_queue *q = rs->md.queue;
+	md_make_request(q, bio);
+	return DM_MAPIO_SUBMITTED;
+}
+
+/* Device suspend. */
+static void raid_presuspend(struct dm_target *ti)
+{
+	struct raid_set *rs = ti->private;
+	mutex_lock(&rs->md.reconfig_mutex);
+	mddev_suspend(&rs->md);
+	mutex_unlock(&rs->md.reconfig_mutex);
+}
+
+/* Device resume. */
+static void raid_resume(struct dm_target *ti)
+{
+	struct raid_set *rs = ti->private;
+
+	mutex_lock(&rs->md.reconfig_mutex);
+	mddev_resume(&rs->md);
+	mutex_unlock(&rs->md.reconfig_mutex);
+}
+
+static int raid_status(struct dm_target *ti, status_type_t type,
+		       char *result, unsigned maxlen)
+{
+	unsigned p, sz = 0;
+	char buf[BDEVNAME_SIZE];
+	struct raid_set *rs = ti->private;
+	raid5_conf_t *conf = rs->md.private;
+
+	int raid_parms[] = {
+		rs->md.chunk_sectors,
+		conf->max_nr_stripes,
+		PAGE_SIZE,
+		PAGE_SIZE,
+		recover_get_bandwidth(rs),
+		-2,
+		conf->max_nr_stripes,
+	};
+
+	switch (type) {
+	case STATUSTYPE_INFO:
+
+		DMEMIT("%u ", rs->md.raid_disks);
+
+		for (p = 0; p < rs->md.raid_disks; p++)
+			DMEMIT("%s ",
+			       format_dev_t(buf, rs->dev[p].dev->bdev->bd_dev));
+
+		DMEMIT("2 ");
+		for (p = 0; p < rs->md.raid_disks; p++) {
+			DMEMIT("%c", !test_bit(Faulty, &rs->dev[p].rdev.flags)
+			       ? 'A' : 'D');
+
+			if (!test_bit(In_sync, &rs->dev[p].rdev.flags))
+				DMEMIT("i");
+			if (test_bit(Blocked, &rs->dev[p].rdev.flags))
+				DMEMIT("b");
+		}
+
+		DMEMIT(" %llu/%llu ",
+		       (unsigned long long) rs->md.curr_resync_completed,
+		       (unsigned long long) rs->md.dev_sectors);
+
+		break;
+	case STATUSTYPE_TABLE:
+		/* fake as core_status with sector size of 1 */
+		DMEMIT("core 2 1 ");
+
+		DMEMIT("%s %u ", rs->raid_type->name, rs->raid_parms);
+
+		for (p = 0; p < rs->raid_parms; p++) {
+			if (raid_parms[p] > -2)
+				DMEMIT("%d ", raid_parms[p]);
+			else
+				DMEMIT("%s ", rs->md.recovery_cp == MaxSector ?
+					      "sync" : "nosync");
+		}
+
+		DMEMIT("%u %d ", rs->md.raid_disks, -1);
+
+		for (p = 0; p < rs->md.raid_disks; p++)
+			DMEMIT("%s %llu ",
+			       format_dev_t(buf, rs->dev[p].dev->bdev->bd_dev),
+			       (unsigned long long) rs->dev[p].rdev.data_offset);
+	}
+
+	return 0;
+}
+
+/*
+ * Message interface
+ */
+enum raid_msg_actions {
+	act_bw,			/* Recovery bandwidth switch. */
+	act_dev,		/* Device failure switch. */
+	act_overwrite,		/* Stripe overwrite check. */
+	act_stats,		/* Development statistics switch. */
+	act_sc,			/* Stripe cache switch. */
+
+	act_on,			/* Set entity on. */
+	act_off,		/* Set entity off. */
+	act_reset,		/* Reset entity. */
+
+	act_set = act_on,	/* Set # absolute. */
+	act_grow = act_off,	/* Grow # by an amount. */
+	act_shrink = act_reset,	/* Shrink # by an amount. */
+};
+
+/* Turn a delta into an absolute value. */
+static int _absolute(unsigned long action, int act, int r)
+{
+	/* Make delta absolute. */
+	if (test_bit(act_set, &action))
+		;
+	else if (test_bit(act_grow, &action))
+		r += act;
+	else if (test_bit(act_shrink, &action))
+		r = act - r;
+	else
+		r = -EINVAL;
+
+	return r;
+}
+
+ /* Change recovery io bandwidth. */
+static int bandwidth_change(struct dm_msg *msg, void *context)
+{
+	struct raid_set *rs = context;
+	int act = recover_get_bandwidth(rs);
+	int bandwidth = DM_MSG_INT_ARG(msg);
+
+	if (range_ok(bandwidth, BANDWIDTH_MIN, BANDWIDTH_MAX)) {
+		/* Make delta bandwidth absolute. */
+		bandwidth = _absolute(msg->action, act, bandwidth);
+
+		/* Check range. */
+		if (range_ok(bandwidth, BANDWIDTH_MIN, BANDWIDTH_MAX)) {
+			recover_set_bandwidth(rs, bandwidth);
+			return 0;
+		}
+	}
+
+	set_bit(dm_msg_ret_arg, &msg->ret);
+	set_bit(dm_msg_ret_inval, &msg->ret);
+	return -EINVAL;
+}
+
+
+/* Resize the stripe cache. */
+static int sc_resize(struct dm_msg *msg, void *context)
+{
+	int act, stripes;
+	struct raid_set *rs = context;
+	raid5_conf_t *conf = rs->md.private;
+
+	stripes = DM_MSG_INT_ARG(msg);
+	if (stripes > 0) {
+		mutex_lock(&rs->md.reconfig_mutex);
+		act = conf->max_nr_stripes;
+
+		/* Make delta stripes absolute. */
+		stripes = _absolute(msg->action, act, stripes);
+
+		/*
+		 * Check range and that the # of stripes changes.
+		 */
+		if (range_ok(stripes, STRIPES_MIN, STRIPES_MAX) &&
+		    stripes != conf->max_nr_stripes) {
+			raid5_set_cache_size(&rs->md, stripes);
+			mutex_unlock(&rs->md.reconfig_mutex);
+			return 0;
+		}
+		mutex_unlock(&rs->md.reconfig_mutex);
+	}
+
+	set_bit(dm_msg_ret_arg, &msg->ret);
+	set_bit(dm_msg_ret_inval, &msg->ret);
+	return -EINVAL;
+}
+
+/* Parse the RAID message action. */
+/*
+ * 'ba[ndwidth] {se[t],g[row],sh[rink]} #'	# e.g 'ba se 50'
+ * "o[verwrite]  {on,of[f],r[eset]}'		# e.g. 'o of'
+ * 'sta[tistics] {on,of[f],r[eset]}'		# e.g. 'stat of'
+ * 'str[ipecache] {se[t],g[row],sh[rink]} #'	# e.g. 'stripe set 1024'
+ *
+ */
+static int raid_message(struct dm_target *ti, unsigned argc, char **argv)
+{
+	/* Variables to store the parsed parameters im. */
+	static int i[2];
+	static unsigned long *i_arg[] = {
+		(unsigned long *) i + 0,
+		(unsigned long *) i + 1,
+	};
+
+	/* Declare all message option strings. */
+	static char *str_sgs[] = { "set", "grow", "shrink" };
+#if 0
+	static char *str_oor[] = { "on", "off", "reset" };
+#endif
+	/* Declare all actions. */
+	static unsigned long act_sgs[] = { act_set, act_grow, act_shrink };
+#if 0
+	static unsigned long act_oor[] = { act_on, act_off, act_reset };
+#endif
+	/* Bandwidth option. */
+	static struct dm_message_option bw_opt = { 3, str_sgs, act_sgs };
+	static struct dm_message_argument bw_args = {
+		1, i_arg, { dm_msg_int_t }
+	};
+
+#if 0
+	static struct dm_message_argument null_args = {
+		0, NULL, { dm_msg_int_t }
+	};
+#endif
+	/* Sripecache option. */
+	static struct dm_message_option stripe_opt = { 3, str_sgs, act_sgs };
+
+	/* Declare messages. */
+	static struct dm_msg_spec specs[] = {
+		{ "bandwidth", act_bw, &bw_opt, &bw_args,
+		  0, bandwidth_change },
+		{ "stripecache", act_sc, &stripe_opt, &bw_args,
+		  0, sc_resize },
+	};
+
+	/* The message for the parser. */
+	struct dm_msg msg = {
+		.num_specs = ARRAY_SIZE(specs),
+		.specs = specs,
+	};
+
+	return dm_message_parse(TARGET, &msg, ti->private, argc, argv);
+}
+/*
+ * END message interface
+ */
+
+static struct target_type raid_target = {
+	.name = "raid456",
+	.version = {1, 0, 0},
+	.module = THIS_MODULE,
+	.ctr = raid_ctr,
+	.dtr = raid_dtr,
+	.map = raid_map,
+	.presuspend = raid_presuspend,
+	.resume = raid_resume,
+	.status = raid_status,
+	.message = raid_message,
+};
+
+static void init_exit(const char *bad_msg, const char *good_msg, int r)
+{
+	if (r)
+		DMERR("Failed to %sregister target [%d]", bad_msg, r);
+	else
+		DMINFO("%s %s", good_msg, version);
+}
+
+static int __init dm_raid_init(void)
+{
+	int r = dm_register_target(&raid_target);
+
+	init_exit("", "initialized", r);
+
+	/* avoid this being called under a lock */
+	init_emergency_isa_pool();
+	return r;
+}
+
+static void __exit dm_raid_exit(void)
+{
+	dm_unregister_target(&raid_target);
+	init_exit("un", "exit", 0);
+}
+
+/* Module hooks. */
+module_init(dm_raid_init);
+module_exit(dm_raid_exit);
+
+MODULE_DESCRIPTION(DM_NAME " raid4/5/6 target");
+MODULE_AUTHOR("Heinz Mauelshagen <hjm@redhat.com> and NeilBrown <neilb@suse.de>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("dm-raid4");
+MODULE_ALIAS("dm-raid5");
+MODULE_ALIAS("dm-raid6");
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 09be637..942ce83 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -208,7 +208,7 @@ static DEFINE_SPINLOCK(all_mddevs_lock);
  * call has finished, the bio has been linked into some internal structure
  * and so is visible to ->quiesce(), so we don't need the refcount any more.
  */
-static int md_make_request(struct request_queue *q, struct bio *bio)
+int md_make_request(struct request_queue *q, struct bio *bio)
 {
 	mddev_t *mddev = q->queuedata;
 	int rv;
@@ -238,29 +238,34 @@ static int md_make_request(struct request_queue *q, struct bio *bio)
 
 	return rv;
 }
+EXPORT_SYMBOL_GPL(md_make_request);
 
-static void mddev_suspend(mddev_t *mddev)
+void mddev_suspend(mddev_t *mddev)
 {
 	BUG_ON(mddev->suspended);
 	mddev->suspended = 1;
 	synchronize_rcu();
 	wait_event(mddev->sb_wait, atomic_read(&mddev->active_io) == 0);
 	mddev->pers->quiesce(mddev, 1);
-	md_unregister_thread(mddev->thread);
-	mddev->thread = NULL;
+	if (mddev->unit) {
+		md_unregister_thread(mddev->thread);
+		mddev->thread = NULL;
+	}
 	/* we now know that no code is executing in the personality module,
 	 * except possibly the tail end of a ->bi_end_io function, but that
 	 * is certain to complete before the module has a chance to get
 	 * unloaded
 	 */
 }
+EXPORT_SYMBOL_GPL(mddev_suspend);
 
-static void mddev_resume(mddev_t *mddev)
+void mddev_resume(mddev_t *mddev)
 {
 	mddev->suspended = 0;
 	wake_up(&mddev->sb_wait);
 	mddev->pers->quiesce(mddev, 0);
 }
+EXPORT_SYMBOL_GPL(mddev_resume);
 
 
 static inline mddev_t *mddev_get(mddev_t *mddev)
@@ -2981,8 +2986,8 @@ array_state_show(mddev_t *mddev, char *page)
 	return sprintf(page, "%s\n", array_states[st]);
 }
 
-static int do_md_stop(mddev_t * mddev, int ro, int is_open);
-static int do_md_run(mddev_t * mddev);
+int do_md_stop(mddev_t * mddev, int ro, int is_open);
+int do_md_run(mddev_t * mddev);
 static int restart_array(mddev_t *mddev);
 
 static ssize_t
@@ -3957,11 +3962,11 @@ static void md_safemode_timeout(unsigned long data)
 
 static int start_dirty_degraded;
 
-static int do_md_run(mddev_t * mddev)
+int do_md_run(mddev_t * mddev)
 {
 	int err;
 	mdk_rdev_t *rdev;
-	struct gendisk *disk;
+	struct gendisk *disk = NULL;
 	struct mdk_personality *pers;
 
 	if (list_empty(&mddev->disks))
@@ -4016,14 +4021,16 @@ static int do_md_run(mddev_t * mddev)
 				return -EINVAL;
 			}
 		}
-		sysfs_notify_dirent(rdev->sysfs_state);
+		if (rdev->sysfs_state)
+			sysfs_notify_dirent(rdev->sysfs_state);
 	}
 
-	md_probe(mddev->unit, NULL, NULL);
-	disk = mddev->gendisk;
-	if (!disk)
-		return -ENOMEM;
-
+	if (mddev->unit) {
+		md_probe(mddev->unit, NULL, NULL);
+		disk = mddev->gendisk;
+		if (!disk)
+			return -ENOMEM;
+	}
 	spin_lock(&pers_lock);
 	pers = find_pers(mddev->level, mddev->clevel);
 	if (!pers || !try_module_get(pers->owner)) {
@@ -4044,7 +4051,7 @@ static int do_md_run(mddev_t * mddev)
 	}
 	strlcpy(mddev->clevel, pers->name, sizeof(mddev->clevel));
 
-	if (pers->level >= 4 && pers->level <= 6)
+	if (pers->level >= 4 && pers->level <= 6 && mddev->gendisk)
 		/* Cannot support integrity (yet) */
 		blk_integrity_unregister(mddev->gendisk);
 
@@ -4123,7 +4130,7 @@ static int do_md_run(mddev_t * mddev)
 		bitmap_destroy(mddev);
 		return err;
 	}
-	if (mddev->pers->sync_request) {
+	if (mddev->pers->sync_request && mddev->unit) {
 		if (sysfs_create_group(&mddev->kobj, &md_redundancy_group))
 			printk(KERN_WARNING
 			       "md: cannot register extra attributes for %s\n",
@@ -4139,6 +4146,7 @@ static int do_md_run(mddev_t * mddev)
 	mddev->safemode_delay = (200 * HZ)/1000 +1; /* 200 msec delay */
 	mddev->in_sync = 1;
 
+	if (mddev->unit)
 	list_for_each_entry(rdev, &mddev->disks, same_set)
 		if (rdev->raid_disk >= 0) {
 			char nm[20];
@@ -4153,7 +4161,8 @@ static int do_md_run(mddev_t * mddev)
 	if (mddev->flags)
 		md_update_sb(mddev, 0);
 
-	set_capacity(disk, mddev->array_sectors);
+	if (disk)
+		set_capacity(disk, mddev->array_sectors);
 
 	/* If there is a partially-recovered drive we need to
 	 * start recovery here.  If we leave it to md_check_recovery,
@@ -4187,13 +4196,15 @@ static int do_md_run(mddev_t * mddev)
 
 	mddev->changed = 1;
 	md_new_event(mddev);
-	sysfs_notify_dirent(mddev->sysfs_state);
-	if (mddev->sysfs_action)
+	if (mddev->unit) {
+		sysfs_notify_dirent(mddev->sysfs_state);
 		sysfs_notify_dirent(mddev->sysfs_action);
-	sysfs_notify(&mddev->kobj, NULL, "degraded");
-	kobject_uevent(&disk_to_dev(mddev->gendisk)->kobj, KOBJ_CHANGE);
+		sysfs_notify(&mddev->kobj, NULL, "degraded");
+		kobject_uevent(&disk_to_dev(mddev->gendisk)->kobj, KOBJ_CHANGE);
+	}
 	return 0;
 }
+EXPORT_SYMBOL_GPL(do_md_run);
 
 static int restart_array(mddev_t *mddev)
 {
@@ -4250,7 +4261,7 @@ static void restore_bitmap_write_access(struct file *file)
  *   1 - switch to readonly
  *   2 - stop but do not disassemble array
  */
-static int do_md_stop(mddev_t * mddev, int mode, int is_open)
+int do_md_stop(mddev_t * mddev, int mode, int is_open)
 {
 	int err = 0;
 	struct gendisk *disk = mddev->gendisk;
@@ -4283,7 +4294,7 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 		case 2: /* stop */
 			bitmap_flush(mddev);
 			md_super_wait(mddev);
-			if (mddev->ro)
+			if (mddev->ro && disk)
 				set_disk_ro(disk, 0);
 
 			mddev->pers->stop(mddev);
@@ -4295,8 +4306,10 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 				mddev->private = &md_redundancy_group;
 			mddev->pers = NULL;
 			/* tell userspace to handle 'inactive' */
-			sysfs_notify_dirent(mddev->sysfs_state);
+			if (mddev->sysfs_state)
+				sysfs_notify_dirent(mddev->sysfs_state);
 
+			if (mddev->unit)
 			list_for_each_entry(rdev, &mddev->disks, same_set)
 				if (rdev->raid_disk >= 0) {
 					char nm[20];
@@ -4304,7 +4317,8 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 					sysfs_remove_link(&mddev->kobj, nm);
 				}
 
-			set_capacity(disk, 0);
+			if (disk)
+				set_capacity(disk, 0);
 			mddev->changed = 1;
 
 			if (mddev->ro)
@@ -4315,7 +4329,7 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 			mddev->in_sync = 1;
 			md_update_sb(mddev, 1);
 		}
-		if (mode == 1)
+		if (mode == 1 && disk)
 			set_disk_ro(disk, 1);
 		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 	}
@@ -4382,12 +4396,15 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 		printk(KERN_INFO "md: %s switched to read-only mode.\n",
 			mdname(mddev));
 	err = 0;
-	blk_integrity_unregister(disk);
-	md_new_event(mddev);
-	sysfs_notify_dirent(mddev->sysfs_state);
+	if (disk) {
+		blk_integrity_unregister(disk);
+		md_new_event(mddev);
+		sysfs_notify_dirent(mddev->sysfs_state);
+	}
 out:
 	return err;
 }
+EXPORT_SYMBOL_GPL(do_md_stop);
 
 #ifndef MODULE
 static void autorun_array(mddev_t *mddev)
@@ -6076,6 +6093,7 @@ void md_write_start(mddev_t *mddev, struct bio *bi)
 
 	BUG_ON(mddev->ro == 1);
 	if (mddev->ro == 2) {
+		printk("ro2\n");
 		/* need to switch to read/write */
 		mddev->ro = 0;
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
@@ -6087,6 +6105,7 @@ void md_write_start(mddev_t *mddev, struct bio *bi)
 	if (mddev->safemode == 1)
 		mddev->safemode = 0;
 	if (mddev->in_sync) {
+		printk("insync\n");
 		spin_lock_irq(&mddev->write_lock);
 		if (mddev->in_sync) {
 			mddev->in_sync = 0;
@@ -6330,8 +6349,10 @@ void md_do_sync(mddev_t *mddev)
 				   atomic_read(&mddev->recovery_active) == 0);
 			mddev->curr_resync_completed =
 				mddev->curr_resync;
-			set_bit(MD_CHANGE_CLEAN, &mddev->flags);
-			sysfs_notify(&mddev->kobj, NULL, "sync_completed");
+			if (mddev->unit) {
+				set_bit(MD_CHANGE_CLEAN, &mddev->flags);
+				sysfs_notify(&mddev->kobj, NULL, "sync_completed");
+			}
 		}
 
 		if (j >= mddev->resync_max)
@@ -6445,14 +6466,16 @@ void md_do_sync(mddev_t *mddev)
 					rdev->recovery_offset = mddev->curr_resync;
 		}
 	}
-	set_bit(MD_CHANGE_DEVS, &mddev->flags);
+	if (mddev->unit)
+		set_bit(MD_CHANGE_DEVS, &mddev->flags);
 
  skip:
 	mddev->curr_resync = 0;
 	mddev->curr_resync_completed = 0;
 	mddev->resync_min = 0;
 	mddev->resync_max = MaxSector;
-	sysfs_notify(&mddev->kobj, NULL, "sync_completed");
+	if (mddev->unit)
+		sysfs_notify(&mddev->kobj, NULL, "sync_completed");
 	wake_up(&resync_wait);
 	set_bit(MD_RECOVERY_DONE, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
@@ -6602,7 +6625,7 @@ void md_check_recovery(mddev_t *mddev)
 			if (mddev->safemode == 1)
 				mddev->safemode = 0;
 			spin_unlock_irq(&mddev->write_lock);
-			if (did_change)
+			if (did_change && mddev->sysfs_state)
 				sysfs_notify_dirent(mddev->sysfs_state);
 		}
 
@@ -6611,7 +6634,8 @@ void md_check_recovery(mddev_t *mddev)
 
 		list_for_each_entry(rdev, &mddev->disks, same_set)
 			if (test_and_clear_bit(StateChanged, &rdev->flags))
-				sysfs_notify_dirent(rdev->sysfs_state);
+				if (rdev->sysfs_state)
+					sysfs_notify_dirent(rdev->sysfs_state);
 
 
 		if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) &&
@@ -6629,6 +6653,7 @@ void md_check_recovery(mddev_t *mddev)
 				/* success...*/
 				/* activate any spares */
 				if (mddev->pers->spare_active(mddev))
+					if (mddev->unit)
 					sysfs_notify(&mddev->kobj, NULL,
 						     "degraded");
 			}
@@ -6647,6 +6672,7 @@ void md_check_recovery(mddev_t *mddev)
 			mddev->recovery = 0;
 			/* flag recovery needed just to double check */
 			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+			if (mddev->unit)
 			sysfs_notify_dirent(mddev->sysfs_action);
 			md_new_event(mddev);
 			goto unlock;
@@ -6709,7 +6735,8 @@ void md_check_recovery(mddev_t *mddev)
 				mddev->recovery = 0;
 			} else
 				md_wakeup_thread(mddev->sync_thread);
-			sysfs_notify_dirent(mddev->sysfs_action);
+			if (mddev->unit)
+				sysfs_notify_dirent(mddev->sysfs_action);
 			md_new_event(mddev);
 		}
 	unlock:
@@ -6726,7 +6753,8 @@ void md_check_recovery(mddev_t *mddev)
 
 void md_wait_for_blocked_rdev(mdk_rdev_t *rdev, mddev_t *mddev)
 {
-	sysfs_notify_dirent(rdev->sysfs_state);
+	if (rdev->sysfs_state)
+		sysfs_notify_dirent(rdev->sysfs_state);
 	wait_event_timeout(rdev->blocked_wait,
 			   !test_bit(Blocked, &rdev->flags),
 			   msecs_to_jiffies(5000));
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f9f991e..6fe6960 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3323,7 +3323,7 @@ static void raid5_unplug_device(struct request_queue *q)
 	unplug_slaves(mddev);
 }
 
-static int raid5_congested(void *data, int bits)
+int raid5_congested(void *data, int bits)
 {
 	mddev_t *mddev = data;
 	raid5_conf_t *conf = mddev->private;
@@ -3340,6 +3340,7 @@ static int raid5_congested(void *data, int bits)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(raid5_congested);
 
 /* We want read requests to align with chunks where possible,
  * but write requests don't need to.
@@ -3422,6 +3423,7 @@ static struct bio *remove_bio_from_retry(raid5_conf_t *conf)
 }
 
 
+static void *bio_fs_destructor;
 /*
  *  The "raid5_align_endio" should check if the read succeeded and if it
  *  did, call bio_endio on the original bio (having bio_put the new bio
@@ -3436,9 +3438,10 @@ static void raid5_align_endio(struct bio *bi, int error)
 	int uptodate = test_bit(BIO_UPTODATE, &bi->bi_flags);
 	mdk_rdev_t *rdev;
 
+	mddev = (void*)bi->bi_destructor;
+	bi->bi_destructor = bio_fs_destructor;
 	bio_put(bi);
 
-	mddev = raid_bi->bi_bdev->bd_disk->queue->queuedata;
 	conf = mddev->private;
 	rdev = (void*)raid_bi->bi_next;
 	raid_bi->bi_next = NULL;
@@ -3502,6 +3505,8 @@ static int chunk_aligned_read(struct request_queue *q, struct bio * raid_bio)
 	 */
 	align_bi->bi_end_io  = raid5_align_endio;
 	align_bi->bi_private = raid_bio;
+	bio_fs_destructor = align_bi->bi_destructor;
+	align_bi->bi_destructor = (void*)mddev;
 	/*
 	 *	compute position
 	 */
@@ -3537,6 +3542,7 @@ static int chunk_aligned_read(struct request_queue *q, struct bio * raid_bio)
 		return 1;
 	} else {
 		rcu_read_unlock();
+		align_bi->bi_destructor = bio_fs_destructor;
 		bio_put(align_bi);
 		return 0;
 	}
@@ -3613,12 +3619,13 @@ static int make_request(struct request_queue *q, struct bio * bi)
 
 	md_write_start(mddev, bi);
 
-	cpu = part_stat_lock();
-	part_stat_inc(cpu, &mddev->gendisk->part0, ios[rw]);
-	part_stat_add(cpu, &mddev->gendisk->part0, sectors[rw],
-		      bio_sectors(bi));
-	part_stat_unlock();
-
+	if (mddev->gendisk) {
+		cpu = part_stat_lock();
+		part_stat_inc(cpu, &mddev->gendisk->part0, ios[rw]);
+		part_stat_add(cpu, &mddev->gendisk->part0, sectors[rw],
+			      bio_sectors(bi));
+		part_stat_unlock();
+	}
 	if (rw == READ &&
 	     mddev->reshape_position == MaxSector &&
 	     chunk_aligned_read(q,bi))
@@ -4192,23 +4199,14 @@ raid5_show_stripe_cache_size(mddev_t *mddev, char *page)
 		return 0;
 }
 
-static ssize_t
-raid5_store_stripe_cache_size(mddev_t *mddev, const char *page, size_t len)
+int raid5_set_cache_size(mddev_t *mddev, int size)
 {
 	raid5_conf_t *conf = mddev->private;
-	unsigned long new;
 	int err;
 
-	if (len >= PAGE_SIZE)
-		return -EINVAL;
-	if (!conf)
-		return -ENODEV;
-
-	if (strict_strtoul(page, 10, &new))
-		return -EINVAL;
-	if (new <= 16 || new > 32768)
+	if (size <= 16 || size > 32768)
 		return -EINVAL;
-	while (new < conf->max_nr_stripes) {
+	while (size < conf->max_nr_stripes) {
 		if (drop_one_stripe(conf))
 			conf->max_nr_stripes--;
 		else
@@ -4217,11 +4215,32 @@ raid5_store_stripe_cache_size(mddev_t *mddev, const char *page, size_t len)
 	err = md_allow_write(mddev);
 	if (err)
 		return err;
-	while (new > conf->max_nr_stripes) {
+	while (size > conf->max_nr_stripes) {
 		if (grow_one_stripe(conf))
 			conf->max_nr_stripes++;
 		else break;
 	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(raid5_set_cache_size);
+	
+static ssize_t
+raid5_store_stripe_cache_size(mddev_t *mddev, const char *page, size_t len)
+{
+	raid5_conf_t *conf = mddev->private;
+	unsigned long new;
+	int err;
+
+	if (len >= PAGE_SIZE)
+		return -EINVAL;
+	if (!conf)
+		return -ENODEV;
+
+	if (strict_strtoul(page, 10, &new))
+		return -EINVAL;
+	err = raid5_set_cache_size(mddev, new);
+	if (err)
+		return err;
 	return len;
 }
 
@@ -4593,6 +4612,7 @@ static int run(mddev_t *mddev)
 	}
 
 	/* Ok, everything is just fine now */
+	if (mddev->unit)
 	if (sysfs_create_group(&mddev->kobj, &raid5_attrs_group))
 		printk(KERN_WARNING
 		       "raid5: failed to create sysfs attributes for %s\n",
@@ -4637,6 +4657,7 @@ static int stop(mddev_t *mddev)
 	kfree(conf->stripe_hashtbl);
 	mddev->queue->backing_dev_info.congested_fn = NULL;
 	blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
+	if (mddev->unit)
 	sysfs_remove_group(&mddev->kobj, &raid5_attrs_group);
 	kfree(conf->disks);
 	kfree(conf);
