From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-4.16 PATCH v5 1/4] block: only bdi_unregister() in del_gendisk() if !GENHD_FL_HIDDEN
Date: Fri, 12 Jan 2018 10:06:03 -0500
Message-ID: <20180112150606.6037-2-snitzer@redhat.com>
References: <20180112150606.6037-1-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180112150606.6037-1-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: Ming Lei <tom.leiming@gmail.com>, hare@suse.de, Bart.VanAssche@wdc.com, David Jeffery <djeffery@redhat.com>, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

device_add_disk() will only call bdi_register_owner() if
!GENHD_FL_HIDDEN, so it follows that del_gendisk() should only call
bdi_unregister() if !GENHD_FL_HIDDEN.

Found with code inspection.  bdi_unregister() won't do any harm if
bdi_register_owner() wasn't used but best to avoid the unnecessary
call to bdi_unregister().

Fixes: 8ddcd65325 ("block: introduce GENHD_FL_HIDDEN")
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
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
