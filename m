From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-4.16 PATCH v2 1/3] block: only bdi_unregister() in del_gendisk() if !GENHD_FL_HIDDEN
Date: Tue,  9 Jan 2018 21:41:02 -0500
Message-ID: <20180110024104.34885-2-snitzer@redhat.com>
References: <20180110024104.34885-1-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180110024104.34885-1-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: hch@lst.de, Bart.VanAssche@wdc.com, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

device_add_disk() will only call bdi_register_owner() if
!GENHD_FL_HIDDEN so it follows that bdi_unregister() should be avoided
for !GENHD_FL_HIDDEN in del_gendisk().

Found with code inspection.  bdi_unregister() won't do much harm if
bdi_register_owner() wasn't used but best to avoid it.

Fixes: 8ddcd65325 ("block: introduce GENHD_FL_HIDDEN")
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/genhd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/genhd.c b/block/genhd.c
index 96a66f671720..00620e01e043 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -725,7 +725,8 @@ void del_gendisk(struct gendisk *disk)
 		 * Unregister bdi before releasing device numbers (as they can
 		 * get reused and we'd get clashes in sysfs).
 		 */
-		bdi_unregister(disk->queue->backing_dev_info);
+		if (!(disk->flags & GENHD_FL_HIDDEN))
+			bdi_unregister(disk->queue->backing_dev_info);
 		blk_unregister_queue(disk);
 	} else {
 		WARN_ON(1);
-- 
2.15.0
