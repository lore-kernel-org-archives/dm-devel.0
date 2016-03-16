From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 4/5] dm: Add uevent support for dm-thin
Date: Wed, 16 Mar 2016 16:27:46 -0700
Message-ID: <1458170867-429-5-git-send-email-agrover@redhat.com>
References: <1458170867-429-1-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1458170867-429-1-git-send-email-agrover@redhat.com>
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

Create a uevent before calling dm_table_event() when either data or
metadata low water are hit, as well as when pool mode changes.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/md/dm-thin.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 92237b6..b9fa18f 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -7,6 +7,7 @@
 #include "dm-thin-metadata.h"
 #include "dm-bio-prison.h"
 #include "dm.h"
+#include "dm-uevent.h"
 
 #include <linux/device-mapper.h>
 #include <linux/dm-io.h>
@@ -1345,6 +1346,20 @@ static int commit(struct pool *pool)
 	return r;
 }
 
+static void add_thin_uevent(struct dm_target *ti, char *name)
+{
+	struct mapped_device *md = dm_table_get_md(ti->table);
+	struct dm_uevent *event;
+
+	event = dm_build_uevent(md, ti, KOBJ_CHANGE, name);
+	if (IS_ERR(event)) {
+		DMERR("%s: dm_build_uevent() failed", __func__);
+		return;
+	}
+
+	dm_uevent_add(md, &event->elist);
+}
+
 static void check_low_water_mark(struct pool *pool, dm_block_t free_blocks)
 {
 	unsigned long flags;
@@ -1355,6 +1370,7 @@ static void check_low_water_mark(struct pool *pool, dm_block_t free_blocks)
 		spin_lock_irqsave(&pool->lock, flags);
 		pool->low_water_triggered = true;
 		spin_unlock_irqrestore(&pool->lock, flags);
+		add_thin_uevent(pool->ti, "THIN_LOW_WATER_DATA");
 		dm_table_event(pool->ti->table);
 	}
 }
@@ -2331,6 +2347,7 @@ static enum pool_mode get_pool_mode(struct pool *pool)
 
 static void notify_of_pool_mode_change(struct pool *pool, const char *new_mode)
 {
+	add_thin_uevent(pool->ti, "THIN_POOL_MODE");
 	dm_table_event(pool->ti->table);
 	DMINFO("%s: switching pool to %s mode",
 	       dm_device_name(pool->pool_md), new_mode);
@@ -3026,6 +3043,7 @@ static void metadata_low_callback(void *context)
 	DMWARN("%s: reached low water mark for metadata device: sending event.",
 	       dm_device_name(pool->pool_md));
 
+	add_thin_uevent(pool->ti, "THIN_LOW_WATER_METADATA");
 	dm_table_event(pool->ti->table);
 }
 
-- 
2.5.0
