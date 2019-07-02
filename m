From: Hou Tao <houtao1@huawei.com>
Subject: [RFC PATCH 2/3] md: export inflight io counters and internal stats in debugfs
Date: Tue, 2 Jul 2019 21:29:17 +0800
Message-ID: <20190702132918.114818-3-houtao1@huawei.com>
References: <20190702132918.114818-1-houtao1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190702132918.114818-1-houtao1@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, songliubraving@fb.com
Cc: neilb@suse.com, linux-block@vger.kernel.org, snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, houtao1@huawei.com
List-Id: dm-devel.ids

There are so many io counters and stats/flags in md, so I think
export these info in debugfs will be helpful for online-debugging,
especially when the vmlinux and crash utility are not available.
And these files can also be utilized during code understanding.

Debug info are divided into two debugfs files:
* iostat
  contains io counters and io related stats (e.g., mddev->pending_writes
  and the active status of mddev->sb_wait)
* stat
  contains internal stats or flags (e.g., mddev->sb_flags)

These two debugfs files will be created both by md-core and the used
md-personality for each md device. This patch creates debug files
for md-core under /sys/kernel/debug/block/mdX, and the following patch
will creates these files for RAID1. The following lines show the hierarchy
of debugfs files created for a RAID1 device:

  $ pwd
  /sys/kernel/debug/block/md0
  $ tree
  .
  ├── iostat
  ├── raid1
  │   ├── iostat
  │   └── stat
  └── stat

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 drivers/md/md.c | 65 +++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/md.h |  1 +
 2 files changed, 66 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9801d540fea1..dceb8fd59ba0 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -64,11 +64,14 @@
 #include "md.h"
 #include "md-bitmap.h"
 #include "md-cluster.h"
+#include "md-debugfs.h"
 
 #ifndef MODULE
 static void autostart_arrays(int part);
 #endif
 
+extern struct dentry *blk_debugfs_root;
+
 /* pers_list is a list of registered personalities protected
  * by pers_lock.
  * pers_lock does extra service to protect accesses to
@@ -5191,6 +5194,65 @@ md_attr_store(struct kobject *kobj, struct attribute *attr,
 	return rv;
 }
 
+static int md_dbg_iostat_show(struct seq_file *m, void *data)
+{
+	struct mddev *mddev = m->private;
+	int active_bm_io = 0;
+
+	spin_lock(&mddev->lock);
+	if (mddev->bitmap)
+		active_bm_io = atomic_read(&mddev->bitmap->pending_writes);
+	spin_unlock(&mddev->lock);
+
+	seq_printf(m, "active_io %d\n",
+			atomic_read(&mddev->active_io));
+	seq_printf(m, "sb_wait %d pending_writes %d\n",
+			waitqueue_active(&mddev->sb_wait),
+			atomic_read(&mddev->pending_writes));
+	seq_printf(m, "recovery_active %d\n",
+			atomic_read(&mddev->recovery_active));
+	seq_printf(m, "bitmap pending_writes %d\n", active_bm_io);
+
+	return 0;
+}
+
+static int md_dbg_stat_show(struct seq_file *m, void *data)
+{
+	struct mddev *mddev = m->private;
+
+	seq_printf(m, "flags 0x%lx\n", mddev->flags);
+	seq_printf(m, "sb_flags 0x%lx\n", mddev->sb_flags);
+	seq_printf(m, "recovery 0x%lx\n", mddev->recovery);
+
+	return 0;
+}
+
+static const struct md_debugfs_file md_dbg_files[] = {
+	{.name = "iostat", .show = md_dbg_iostat_show},
+	{.name = "stat", .show = md_dbg_stat_show},
+	{},
+};
+
+static void md_unregister_debugfs(struct mddev *mddev)
+{
+	debugfs_remove_recursive(mddev->debugfs_dir);
+}
+
+static void md_register_debugfs(struct mddev *mddev)
+{
+	const char *name;
+	struct dentry *dir;
+
+	name = kobject_name(&disk_to_dev(mddev->gendisk)->kobj);
+	dir = debugfs_create_dir(name, blk_debugfs_root);
+	if (!IS_ERR_OR_NULL(dir)) {
+		md_debugfs_create_files(dir, mddev, md_dbg_files);
+		mddev->debugfs_dir = dir;
+	} else {
+		mddev->debugfs_dir = NULL;
+	}
+}
+
 static void md_free(struct kobject *ko)
 {
 	struct mddev *mddev = container_of(ko, struct mddev, kobj);
@@ -5227,6 +5289,7 @@ static void mddev_delayed_delete(struct work_struct *ws)
 {
 	struct mddev *mddev = container_of(ws, struct mddev, del_work);
 
+	md_unregister_debugfs(mddev);
 	sysfs_remove_group(&mddev->kobj, &md_bitmap_group);
 	kobject_del(&mddev->kobj);
 	kobject_put(&mddev->kobj);
@@ -5353,6 +5416,8 @@ static int md_alloc(dev_t dev, char *name)
 	if (mddev->kobj.sd &&
 	    sysfs_create_group(&mddev->kobj, &md_bitmap_group))
 		pr_debug("pointless warning\n");
+
+	md_register_debugfs(mddev);
 	mutex_unlock(&mddev->open_mutex);
  abort:
 	mutex_unlock(&disks_mutex);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 7c930c091193..e79ef2101c45 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -466,6 +466,7 @@ struct mddev {
 	unsigned int			good_device_nr;	/* good device num within cluster raid */
 
 	bool	has_superblocks:1;
+	struct dentry *debugfs_dir;
 };
 
 enum recovery_flags {
-- 
2.22.0
