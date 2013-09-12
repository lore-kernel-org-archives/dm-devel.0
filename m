From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5/7] dm mpath: use dm_get_reserved_rq_based_ios
	to size mempool
Date: Thu, 12 Sep 2013 18:24:56 -0400
Message-ID: <1379024698-10487-6-git-send-email-snitzer@redhat.com>
References: <alpine.LRH.2.02.1308261012400.12373@file01.intranet.prod.int.rdu2.redhat.com>
	<1379024698-10487-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1379024698-10487-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Frank Mayhar <fmayhar@google.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Switch dm-mpath over to sizing its mempool using DM core's configurable
'reserved_rq_based_ios'.

Export dm_get_reserved_rq_based_ios() for use by DM targets and core
code.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-mpath.c |  6 +++---
 drivers/md/dm.c       | 12 ++++++++++++
 drivers/md/dm.h       |  1 +
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 5adede1..ddef91f 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -7,6 +7,7 @@
 
 #include <linux/device-mapper.h>
 
+#include "dm.h"
 #include "dm-path-selector.h"
 #include "dm-uevent.h"
 
@@ -116,8 +117,6 @@ struct dm_mpath_io {
 
 typedef int (*action_fn) (struct pgpath *pgpath);
 
-#define MIN_IOS 256	/* Mempool size */
-
 static struct kmem_cache *_mpio_cache;
 
 static struct workqueue_struct *kmultipathd, *kmpath_handlerd;
@@ -190,6 +189,7 @@ static void free_priority_group(struct priority_group *pg,
 static struct multipath *alloc_multipath(struct dm_target *ti)
 {
 	struct multipath *m;
+	unsigned min_ios = dm_get_reserved_rq_based_ios();
 
 	m = kzalloc(sizeof(*m), GFP_KERNEL);
 	if (m) {
@@ -202,7 +202,7 @@ static struct multipath *alloc_multipath(struct dm_target *ti)
 		INIT_WORK(&m->trigger_event, trigger_event);
 		init_waitqueue_head(&m->pg_init_wait);
 		mutex_init(&m->work_mutex);
-		m->mpio_pool = mempool_create_slab_pool(MIN_IOS, _mpio_cache);
+		m->mpio_pool = mempool_create_slab_pool(min_ios, _mpio_cache);
 		if (!m->mpio_pool) {
 			kfree(m);
 			return NULL;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 3f96c86..186f77d 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -287,6 +287,18 @@ static void __reserved_request_based_ios_refresh(void)
 	}
 }
 
+unsigned dm_get_reserved_rq_based_ios(void)
+{
+	unsigned ios;
+
+	mutex_lock(&dm_mempools_lock);
+	ios = reserved_rq_based_ios_latch;
+	mutex_unlock(&dm_mempools_lock);
+
+	return (ios ? : RESERVED_REQUEST_BASED_IOS);
+}
+EXPORT_SYMBOL_GPL(dm_get_reserved_rq_based_ios);
+
 static int __init local_init(void)
 {
 	int r = -ENOMEM;
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index e1982eb..1d1ad7b 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -185,6 +185,7 @@ void dm_free_md_mempools(struct dm_md_mempools *pools);
  * Helpers that are used by DM core
  */
 unsigned dm_get_reserved_bio_based_ios(void);
+unsigned dm_get_reserved_rq_based_ios(void);
 
 static inline bool dm_message_test_buffer_overflow(char *result, unsigned maxlen)
 {
-- 
1.8.1.4
