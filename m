From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] dm-flakey target refreshed for 2.6.33
Date: Tue, 26 Jan 2010 14:20:51 -0500
Message-ID: <20100126192050.GA5550@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Hello,

I needed a dm target to do some failure testing on btrfs's raid code, and
Mike pointed me at this

http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-flakey.patch

It just needed a few tweaks, all I did was

-fix the Kconfig/Makefile part so it would apply properly
-changed SECTOR_FORMAT to "%llu"
-changed DMERR to printk (for some reason DMERR was failing and I have no idea
why)
-dm_unregister_target is void now, whereas this patch had it returning an int,
so fixed that too

Then this thing worked great for me.  It probably needs to be cleaned up more,
but I'm an FS person, not a DM person :).  This (or something like it) would be
super usefull for testing btrfs's raid code, or really any sort of failure mode
with an fs without having to do crazy things like rip out cables, so if it could
be included in mainline that would be helpful.  Thanks,

Josef
---
 drivers/md/Kconfig     |    6 ++
 drivers/md/Makefile    |    1 +
 drivers/md/dm-flakey.c |  155 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 162 insertions(+), 0 deletions(-)
 create mode 100644 drivers/md/dm-flakey.c

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index acb3a4e..0ae5420 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -319,4 +319,10 @@ config DM_UEVENT
 	---help---
 	Generate udev events for DM events.
 
+config DM_FLAKEY
+       tristate "Flakey target (EXPERIMENTAL)"
+       depends on BLK_DEV_DM && EXPERIMENTAL
+       ---help---
+         A debug only target that intermittently fails io.
+
 endif # MD
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index e355e7f..1d2a975 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -37,6 +37,7 @@ obj-$(CONFIG_BLK_DEV_MD)	+= md-mod.o
 obj-$(CONFIG_BLK_DEV_DM)	+= dm-mod.o
 obj-$(CONFIG_DM_CRYPT)		+= dm-crypt.o
 obj-$(CONFIG_DM_DELAY)		+= dm-delay.o
+obj-$(CONFIG_DM_FLAKEY)		+= dm-flakey.o
 obj-$(CONFIG_DM_MULTIPATH)	+= dm-multipath.o dm-round-robin.o
 obj-$(CONFIG_DM_MULTIPATH_QL)	+= dm-queue-length.o
 obj-$(CONFIG_DM_MULTIPATH_ST)	+= dm-service-time.o
diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
new file mode 100644
index 0000000..16d3704
--- /dev/null
+++ b/drivers/md/dm-flakey.c
@@ -0,0 +1,155 @@
+/*
+ * Copyright (C) 2003 Sistina Software (UK) Limited.
+ * Copyright (C) 2004 Red Hat, Inc. All rights reserved.
+ *
+ * This file is released under the GPL.
+ */
+
+#include "dm.h"
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/blkdev.h>
+#include <linux/bio.h>
+#include <linux/slab.h>
+
+typedef typeof(jiffies) jiffy_t;
+
+/*
+ * Flakey: Used for testing only, simulates intermittent,
+ * catastrophic device failure.
+ */
+struct flakey {
+	struct dm_dev *dev;
+	jiffy_t start_time;
+	sector_t start;
+	unsigned up_interval;
+	unsigned down_interval;
+};
+
+/*
+ * Construct a flakey mapping: <dev_path> <offset> <up interval> <down interval>
+ */
+static int flakey_ctr(struct dm_target *ti, unsigned int argc, char **argv)
+{
+	struct flakey *f;
+
+	if (argc != 4) {
+		ti->error = "dm-flakey: Invalid argument count";
+		return -EINVAL;
+	}
+
+	f = kmalloc(sizeof(*f), GFP_KERNEL);
+	if (!f) {
+		ti->error = "dm-flakey: Cannot allocate linear context";
+		return -ENOMEM;
+	}
+	f->start_time = jiffies;
+
+	if (sscanf(argv[1], "%llu", &f->start) != 1) {
+		ti->error = "dm-flakey: Invalid device sector";
+		goto bad;
+	}
+
+	if (sscanf(argv[2], "%u", &f->up_interval) != 1) {
+		ti->error = "dm-flakey: Invalid up interval";
+		goto bad;
+	}
+
+	if (sscanf(argv[3], "%u", &f->down_interval) != 1) {
+		ti->error = "dm-flakey: Invalid down interval";
+		goto bad;
+	}
+
+	if (dm_get_device(ti, argv[0], f->start, ti->len,
+			  dm_table_get_mode(ti->table), &f->dev)) {
+		ti->error = "dm-flakey: Device lookup failed";
+		goto bad;
+	}
+
+	ti->private = f;
+	return 0;
+
+ bad:
+	kfree(f);
+	return -EINVAL;
+}
+
+static void flakey_dtr(struct dm_target *ti)
+{
+	struct flakey *f = (struct flakey *) ti->private;
+
+	dm_put_device(ti, f->dev);
+	kfree(f);
+}
+
+static int flakey_map(struct dm_target *ti, struct bio *bio,
+		      union map_info *map_context)
+{
+	struct flakey *f = (struct flakey *) ti->private;
+	unsigned elapsed;
+
+	/* are we alive ? */
+	elapsed = (jiffies - f->start_time) / HZ;
+	elapsed %= (f->up_interval + f->down_interval);
+	if (elapsed >= f->up_interval)
+		return -EIO;
+
+	else {
+		bio->bi_bdev = f->dev->bdev;
+		bio->bi_sector = f->start + (bio->bi_sector - ti->begin);
+	}
+
+	return 1;
+}
+
+static int flakey_status(struct dm_target *ti, status_type_t type,
+			 char *result, unsigned int maxlen)
+{
+	struct flakey *f = (struct flakey *) ti->private;
+
+	switch (type) {
+	case STATUSTYPE_INFO:
+		result[0] = '\0';
+		break;
+
+	case STATUSTYPE_TABLE:
+		snprintf(result, maxlen, "%s %llu", f->dev->name,
+			 f->start);
+		break;
+	}
+	return 0;
+}
+
+static struct target_type flakey_target = {
+	.name   = "flakey",
+	.version= {1, 0, 1},
+	.module = THIS_MODULE,
+	.ctr    = flakey_ctr,
+	.dtr    = flakey_dtr,
+	.map    = flakey_map,
+	.status = flakey_status,
+};
+
+int __init dm_flakey_init(void)
+{
+	int r = dm_register_target(&flakey_target);
+
+	if (r < 0)
+		printk(KERN_ERR "flakey: register failed %d", r);
+
+	return r;
+}
+
+void __exit dm_flakey_exit(void)
+{
+	dm_unregister_target(&flakey_target);
+}
+
+/* Module hooks */
+module_init(dm_flakey_init);
+module_exit(dm_flakey_exit);
+
+MODULE_DESCRIPTION(DM_NAME " flakey target");
+MODULE_AUTHOR("Joe Thornber <dm-devel@redhat.com>");
+MODULE_LICENSE("GPL");
-- 
1.5.4.3
