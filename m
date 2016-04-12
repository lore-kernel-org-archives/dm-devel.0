From: Brian Foster <bfoster@redhat.com>
Subject: [RFC v2 PATCH 03/10] block: add block_device_operations methods to set and get reserved space
Date: Tue, 12 Apr 2016 12:42:46 -0400
Message-ID: <1460479373-63317-4-git-send-email-bfoster@redhat.com>
References: <1460479373-63317-1-git-send-email-bfoster@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1460479373-63317-1-git-send-email-bfoster@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: xfs@oss.sgi.com
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

From: Mike Snitzer <snitzer@redhat.com>

[BF:
 - Killed wrapper functions.
 - Condensed to single bdev op.]

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 include/linux/blkdev.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 669e419..6c6ea96 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1650,6 +1650,10 @@ struct blk_dax_ctl {
 	pfn_t pfn;
 };
 
+#define BDEV_RES_GET		0
+#define BDEV_RES_MOD		(1 << 0)
+#define BDEV_RES_PROVISION	(1 << 1)
+
 struct block_device_operations {
 	int (*open) (struct block_device *, fmode_t);
 	void (*release) (struct gendisk *, fmode_t);
@@ -1667,6 +1671,8 @@ struct block_device_operations {
 	int (*getgeo)(struct block_device *, struct hd_geometry *);
 	/* this callback is with swap_lock and sometimes page table lock held */
 	void (*swap_slot_free_notify) (struct block_device *, unsigned long);
+	int (*reserve_space) (struct block_device *, int, sector_t, sector_t,
+			      sector_t *);
 	struct module *owner;
 	const struct pr_ops *pr_ops;
 };
-- 
2.4.11

