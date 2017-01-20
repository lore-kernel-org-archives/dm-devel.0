From: Hou Tao <houtao1@huawei.com>
Subject: [PATCH RFC 4/4] dm thin: associate bio with current task
	if keep_bio_blkcg is enabled
Date: Fri, 20 Jan 2017 19:15:52 +0800
Message-ID: <1484910952-29820-5-git-send-email-houtao1@huawei.com>
References: <1484910952-29820-1-git-send-email-houtao1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1484910952-29820-1-git-send-email-houtao1@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, linux-block@vger.kernel.org
Cc: ejt@redhat.com, snitzer@redhat.com, agk@redhat.com, vgoyal@redhat.com
List-Id: dm-devel.ids

If keep_bio_blkcg is enabled, assign the io_context and the blkcg of
current task to bio before processing the bio.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 drivers/md/dm-thin.c |  5 +++++
 drivers/md/dm-thin.h | 17 +++++++++++++++++
 2 files changed, 22 insertions(+)
 create mode 100644 drivers/md/dm-thin.h

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 140cdae..0efbdbe 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -22,6 +22,8 @@
 #include <linux/sort.h>
 #include <linux/rbtree.h>
 
+#include "dm-thin.h"
+
 #define	DM_MSG_PREFIX	"thin"
 
 /*
@@ -2629,6 +2631,9 @@ static int thin_bio_map(struct dm_target *ti, struct bio *bio)
 	struct dm_bio_prison_cell *virt_cell, *data_cell;
 	struct dm_cell_key key;
 
+	if (keep_pool_bio_blkcg(tc->pool))
+		thin_keep_bio_blkcg(bio);
+
 	thin_hook_bio(tc, bio);
 
 	if (tc->requeue_mode) {
diff --git a/drivers/md/dm-thin.h b/drivers/md/dm-thin.h
new file mode 100644
index 0000000..09e920a
--- /dev/null
+++ b/drivers/md/dm-thin.h
@@ -0,0 +1,17 @@
+#ifndef DM_THIN_H
+#define DM_THIN_H
+
+#include <linux/bio.h>
+
+#ifdef CONFIG_BLK_CGROUP
+static inline void thin_keep_bio_blkcg(struct bio *bio)
+{
+	if (!bio->bi_css)
+		bio_associate_current(bio);
+}
+#else
+static inline void thin_keep_bio_blkcg(struct bio *bio) {}
+#endif /* CONFIG_BLK_CGROUP */
+
+#endif
+
-- 
2.5.0
