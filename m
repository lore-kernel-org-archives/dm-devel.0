From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 8/9] dm: Generate uevents for thin targets
Date: Mon,  3 Oct 2016 12:22:59 -0700
Message-ID: <1475522580-16723-9-git-send-email-agrover@redhat.com>
References: <1475522580-16723-1-git-send-email-agrover@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1475522580-16723-1-git-send-email-agrover@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, snitzer@redhat.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Generate uevents when thin pool devices hit data or metadata low water
marks, and when pool mode changes.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/md/dm-thin.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index d1c05c1..0778a2a 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1429,6 +1429,7 @@ static void check_low_water_mark(struct pool *pool, dm_block_t free_blocks)
 		spin_lock_irqsave(&pool->lock, flags);
 		pool->low_water_triggered = true;
 		spin_unlock_irqrestore(&pool->lock, flags);
+		dm_uevent_add(pool->ti, KOBJ_CHANGE, "THIN_LOW_WATER_DATA");
 		dm_table_event(pool->ti->table);
 	}
 }
@@ -2397,6 +2398,7 @@ static enum pool_mode get_pool_mode(struct pool *pool)
 
 static void notify_of_pool_mode_change(struct pool *pool, const char *new_mode)
 {
+	dm_uevent_add(pool->ti, KOBJ_CHANGE, "THIN_POOL_MODE");
 	dm_table_event(pool->ti->table);
 	DMINFO("%s: switching pool to %s mode",
 	       dm_device_name(pool->pool_md), new_mode);
@@ -3095,6 +3097,7 @@ static void metadata_low_callback(void *context)
 	DMWARN("%s: reached low water mark for metadata device: sending event.",
 	       dm_device_name(pool->pool_md));
 
+	dm_uevent_add(pool->ti, KOBJ_CHANGE, "THIN_LOW_WATER_METADATA");
 	dm_table_event(pool->ti->table);
 }
 
-- 
2.7.4
