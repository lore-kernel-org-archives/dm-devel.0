From: Hou Tao <houtao1@huawei.com>
Subject: [RFC PATCH 3/3] raid1: export inflight io counters and internal stats in debugfs
Date: Tue, 2 Jul 2019 21:29:18 +0800
Message-ID: <20190702132918.114818-4-houtao1@huawei.com>
References: <20190702132918.114818-1-houtao1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190702132918.114818-1-houtao1@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, songliubraving@fb.com
Cc: neilb@suse.com, linux-block@vger.kernel.org, snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, houtao1@huawei.com
List-Id: dm-devel.ids

Just like the previous patch which exports debugfs files for md-core,
this patch exports debugfs file for md-raid1 under
/sys/kernel/debug/block/mdX/raid1.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 drivers/md/raid1.c | 78 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/raid1.h |  1 +
 2 files changed, 79 insertions(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 2aa36e570e04..da06bb47195b 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -35,6 +35,7 @@
 #include "md.h"
 #include "raid1.h"
 #include "md-bitmap.h"
+#include "md-debugfs.h"
 
 #define UNSUPPORTED_MDDEV_FLAGS		\
 	((1L << MD_HAS_JOURNAL) |	\
@@ -2901,6 +2902,80 @@ static sector_t raid1_size(struct mddev *mddev, sector_t sectors, int raid_disks
 	return mddev->dev_sectors;
 }
 
+enum {
+	IOSTAT_NR_PENDING = 0,
+	IOSTAT_NR_WAITING,
+	IOSTAT_NR_QUEUED,
+	IOSTAT_BARRIER,
+	IOSTAT_CNT,
+};
+
+static int raid1_dbg_iostat_show(struct seq_file *m, void *data)
+{
+	struct r1conf *conf = m->private;
+	int idx;
+	int sum[IOSTAT_CNT] = {};
+
+	seq_printf(m, "retry_list active %d\n",
+			!list_empty(&conf->retry_list));
+	seq_printf(m, "bio_end_io_list active %d\n",
+			!list_empty(&conf->bio_end_io_list));
+	seq_printf(m, "pending_bio_list active %d cnt %d\n",
+			!bio_list_empty(&conf->pending_bio_list),
+			conf->pending_count);
+
+	for (idx = 0; idx < BARRIER_BUCKETS_NR; idx++) {
+		sum[IOSTAT_NR_PENDING] += atomic_read(&conf->nr_pending[idx]);
+		sum[IOSTAT_NR_WAITING] += atomic_read(&conf->nr_waiting[idx]);
+		sum[IOSTAT_NR_QUEUED] += atomic_read(&conf->nr_queued[idx]);
+		sum[IOSTAT_BARRIER] += atomic_read(&conf->barrier[idx]);
+	}
+
+	seq_printf(m, "sync_pending %d\n", atomic_read(&conf->nr_sync_pending));
+	seq_printf(m, "nr_pending %d\n", sum[IOSTAT_NR_PENDING]);
+	seq_printf(m, "nr_waiting %d\n", sum[IOSTAT_NR_WAITING]);
+	seq_printf(m, "nr_queued %d\n", sum[IOSTAT_NR_QUEUED]);
+	seq_printf(m, "barrier %d\n", sum[IOSTAT_BARRIER]);
+
+	return 0;
+}
+
+static int raid1_dbg_stat_show(struct seq_file *m, void *data)
+{
+	struct r1conf *conf = m->private;
+
+	seq_printf(m, "array_frozen %d\n", conf->array_frozen);
+	return 0;
+}
+
+static const struct md_debugfs_file raid1_dbg_files[] = {
+	{.name = "iostat", .show = raid1_dbg_iostat_show},
+	{.name = "stat", .show = raid1_dbg_stat_show},
+	{},
+};
+
+static void raid1_unregister_debugfs(struct r1conf *conf)
+{
+	debugfs_remove_recursive(conf->debugfs_dir);
+}
+
+static void raid1_register_debugfs(struct mddev *mddev, struct r1conf *conf)
+{
+	struct dentry *dir;
+
+	conf->debugfs_dir = NULL;
+
+	if (!mddev->debugfs_dir)
+		return;
+
+	dir = debugfs_create_dir("raid1", mddev->debugfs_dir);
+	if (IS_ERR_OR_NULL(dir))
+		return;
+
+	md_debugfs_create_files(dir, conf, raid1_dbg_files);
+	conf->debugfs_dir = dir;
+}
+
 static struct r1conf *setup_conf(struct mddev *mddev)
 {
 	struct r1conf *conf;
@@ -3022,6 +3097,8 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 	if (!conf->thread)
 		goto abort;
 
+	raid1_register_debugfs(mddev, conf);
+
 	return conf;
 
  abort:
@@ -3136,6 +3213,7 @@ static void raid1_free(struct mddev *mddev, void *priv)
 {
 	struct r1conf *conf = priv;
 
+	raid1_unregister_debugfs(conf);
 	mempool_exit(&conf->r1bio_pool);
 	kfree(conf->mirrors);
 	safe_put_page(conf->tmppage);
diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
index e7ccad898736..d627020e92d4 100644
--- a/drivers/md/raid1.h
+++ b/drivers/md/raid1.h
@@ -139,6 +139,7 @@ struct r1conf {
 	sector_t		cluster_sync_low;
 	sector_t		cluster_sync_high;
 
+	struct dentry *debugfs_dir;
 };
 
 /*
-- 
2.22.0
