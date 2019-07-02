From: Hou Tao <houtao1@huawei.com>
Subject: [RFC PATCH 1/3] md-debugfs: add md_debugfs_create_files()
Date: Tue, 2 Jul 2019 21:29:16 +0800
Message-ID: <20190702132918.114818-2-houtao1@huawei.com>
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

It will be used by the following patches to create debugfs files
under /sys/kernel/debug/mdX.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 drivers/md/Makefile     |  2 +-
 drivers/md/md-debugfs.c | 35 +++++++++++++++++++++++++++++++++++
 drivers/md/md-debugfs.h | 16 ++++++++++++++++
 3 files changed, 52 insertions(+), 1 deletion(-)
 create mode 100644 drivers/md/md-debugfs.c
 create mode 100644 drivers/md/md-debugfs.h

diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index be7a6eb92abc..49355e3b4cce 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -19,7 +19,7 @@ dm-cache-y	+= dm-cache-target.o dm-cache-metadata.o dm-cache-policy.o \
 dm-cache-smq-y   += dm-cache-policy-smq.o
 dm-era-y	+= dm-era-target.o
 dm-verity-y	+= dm-verity-target.o
-md-mod-y	+= md.o md-bitmap.o
+md-mod-y	+= md.o md-bitmap.o md-debugfs.o
 raid456-y	+= raid5.o raid5-cache.o raid5-ppl.o
 dm-zoned-y	+= dm-zoned-target.o dm-zoned-metadata.o dm-zoned-reclaim.o
 linear-y	+= md-linear.o
diff --git a/drivers/md/md-debugfs.c b/drivers/md/md-debugfs.c
new file mode 100644
index 000000000000..318c35fed24f
--- /dev/null
+++ b/drivers/md/md-debugfs.c
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Based on debugfs_create_files() in blk-mq */
+
+#include <linux/fs.h>
+#include <linux/debugfs.h>
+
+#include "md-debugfs.h"
+
+static int md_debugfs_open(struct inode *inode, struct file *file)
+{
+	const struct md_debugfs_file *dbg_file = inode->i_private;
+	void *data = d_inode(file_dentry(file)->d_parent)->i_private;
+
+	return single_open(file, dbg_file->show, data);
+}
+
+static const struct file_operations md_debugfs_fops = {
+	.owner = THIS_MODULE,
+	.open = md_debugfs_open,
+	.llseek = seq_lseek,
+	.read = seq_read,
+	.release = single_release,
+};
+
+void md_debugfs_create_files(struct dentry *parent, void *data,
+		const struct md_debugfs_file *files)
+{
+	const struct md_debugfs_file *file;
+
+	d_inode(parent)->i_private = data;
+
+	for (file = files; file->name; file++)
+		debugfs_create_file(file->name, 0444, parent,
+				(void *)file, &md_debugfs_fops);
+}
diff --git a/drivers/md/md-debugfs.h b/drivers/md/md-debugfs.h
new file mode 100644
index 000000000000..13b581d4ab63
--- /dev/null
+++ b/drivers/md/md-debugfs.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _MD_DEBUGFS_H
+#define _MD_DEBUGFS_H
+
+#include <linux/seq_file.h>
+#include <linux/debugfs.h>
+
+struct md_debugfs_file {
+	const char *name;
+	int (*show)(struct seq_file *m, void *data);
+};
+
+extern void md_debugfs_create_files(struct dentry *parent, void *data,
+		const struct md_debugfs_file *files);
+#endif
-- 
2.22.0
