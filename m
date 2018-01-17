From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH 2/2] dm ram: new target redirecting io to RAM
Date: Wed, 17 Jan 2018 20:34:01 +0100
Message-ID: <8d7b30f652368c4f6a7994b87d602a8da041e6b1.1516124587.git.heinzm@redhat.com>
References: <cover.1516124587.git.heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cover.1516124587.git.heinzm@redhat.com>
In-Reply-To: <cover.1516124587.git.heinzm@redhat.com>
References: <cover.1516124587.git.heinzm@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com, dm-devel@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 Documentation/device-mapper/ram.txt |  15 ++++++
 drivers/md/Kconfig                  |   7 +++
 drivers/md/Makefile                 |   1 +
 drivers/md/dm-ram.c                 | 101 ++++++++++++++++++++++++++++++++++++
 4 files changed, 124 insertions(+)
 create mode 100644 Documentation/device-mapper/ram.txt
 create mode 100644 drivers/md/dm-ram.c

diff --git a/Documentation/device-mapper/ram.txt b/Documentation/device-mapper/ram.txt
new file mode 100644
index 000000000000..4358fbf57cae
--- /dev/null
+++ b/Documentation/device-mapper/ram.txt
@@ -0,0 +1,15 @@
+dm-ram
+======
+
+Device-Mapper's "ram" target provides a mapping to RAM.
+This is comparible to a loop device mapped to a tmpfs
+file but has less overhead, hence higher IOPS and bandwidth.
+
+dm-ram has no target-specific parameters.
+
+Example:
+
+dmsetup create ramdisk --table "0 $((2048*1024*2)) ram"
+
+This will create a 2GiB ramdisk /dev/mapper/ramdisk and
+will suceed presuming more than 2GiB free RAM are available.
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 1d80783b9ee8..abea7b8771f4 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -397,6 +397,13 @@ config DM_LOOP
 	  A target that redirects IOs to a backing file.
 	  E.g. useful in testing.
 
+config DM_RAM
+	tristate "RAM disk target (EXPERIMENTAL)"
+	depends on BLK_DEV_DM
+	---help---
+	  A target that redirects IO to RAM.
+	  E.g. useful in testing.
+
 config DM_MULTIPATH
 	tristate "Multipath target"
 	depends on BLK_DEV_DM
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 68baf79c5536..f404223629ab 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -58,6 +58,7 @@ obj-$(CONFIG_DM_MIRROR)		+= dm-mirror.o dm-log.o dm-region-hash.o
 obj-$(CONFIG_DM_LOG_USERSPACE)	+= dm-log-userspace.o
 obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
 obj-$(CONFIG_DM_LOOP)		+= dm-loop.o
+obj-$(CONFIG_DM_RAM)		+= dm-ram.o
 obj-$(CONFIG_DM_RAID)	+= dm-raid.o
 obj-$(CONFIG_DM_THIN_PROVISIONING)	+= dm-thin-pool.o
 obj-$(CONFIG_DM_VERITY)		+= dm-verity.o
diff --git a/drivers/md/dm-ram.c b/drivers/md/dm-ram.c
new file mode 100644
index 000000000000..9ef1a8516e1a
--- /dev/null
+++ b/drivers/md/dm-ram.c
@@ -0,0 +1,101 @@
+/*
+ * Copyright (C) 2018 Red Hat GmbH
+ *
+ * Ram disk target.
+ *
+ * This file is released under the GPL.
+ */
+
+#include <linux/device-mapper.h>
+#include <linux/module.h>
+
+static int ram_ctr(struct dm_target *ti, unsigned int argc, char **argv)
+{
+	int r;
+
+	if (argc) {
+		ti->error = "No arguments required";
+		return -EINVAL;
+	}
+
+	/* Allocation will fail anyway for the time being, but... */
+	if (ti->len != to_sector(to_bytes(ti->len))) {
+		ti->error = "Invalid target length";
+		return -EINVAL;
+	}
+
+	r = dm_set_target_max_io_len(ti, min(ti->len, (sector_t) UINT_MAX));
+	if (r)
+		return r;
+
+	ti->private = vmalloc(to_bytes(ti->len));
+	if (!ti->private) {
+		ti->error = "Cannot allocate ram disk";
+		return -ENOMEM;
+	}
+
+	ti->num_discard_bios = 1;
+	ti->discards_supported = true;
+
+	return 0;
+}
+
+static void ram_dtr(struct dm_target *ti)
+{
+	vfree(ti->private);
+}
+
+static int ram_map(struct dm_target *ti, struct bio *bio)
+{
+	struct bio_vec bvec;
+
+	switch (bio_op(bio)) {
+	case REQ_OP_READ:
+		bio_for_each_segment(bvec, bio, bio->bi_iter)
+			memcpy(page_address(bvec.bv_page) + bvec.bv_offset,
+			       ti->private + to_bytes(bio->bi_iter.bi_sector), bvec.bv_len);
+		break;
+	case REQ_OP_WRITE:
+		bio_for_each_segment(bvec, bio, bio->bi_iter)
+			memcpy(ti->private + to_bytes(bio->bi_iter.bi_sector),
+			       page_address(bvec.bv_page) + bvec.bv_offset, bvec.bv_len);
+		break;
+	case REQ_OP_DISCARD:
+		memset(ti->private + to_bytes(bio->bi_iter.bi_sector), 0, bio_cur_bytes(bio));
+		break;
+	default:
+		return DM_MAPIO_KILL;
+	}
+
+	bio_endio(bio);
+
+	return DM_MAPIO_SUBMITTED;
+}
+
+static struct target_type ram_target = {
+	.name	     = "ram",
+	.version     = {1, 0, 0},
+	.features    = DM_TARGET_SINGLETON | DM_TARGET_ALWAYS_WRITEABLE,
+	.module      = THIS_MODULE,
+	.ctr	     = ram_ctr,
+	.dtr	     = ram_dtr,
+	.map	     = ram_map
+};
+
+static int __init dm_ram_init(void)
+{
+	return dm_register_target(&ram_target);
+}
+
+static void __exit dm_ram_exit(void)
+{
+	dm_unregister_target(&ram_target);
+}
+
+/* Module hooks */
+module_init(dm_ram_init);
+module_exit(dm_ram_exit);
+
+MODULE_DESCRIPTION(DM_NAME " ram disk target");
+MODULE_AUTHOR("Heinz Mauelshagen <dm-devel@redhat.com>");
+MODULE_LICENSE("GPL");
-- 
2.14.3
