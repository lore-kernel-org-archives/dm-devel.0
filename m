From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 2/3] dm: add reserved_rq_based_ios module
	parameter
Date: Fri, 13 Sep 2013 17:08:13 -0400
Message-ID: <1379106494-16366-3-git-send-email-snitzer@redhat.com>
References: <20130913203005.GA8635@redhat.com>
	<1379106494-16366-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1379106494-16366-1-git-send-email-snitzer@redhat.com>
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
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Allow user to change the number of IOs that are reserved by
request-based DM's mempools by writing to this file:
/sys/module/dm_mod/parameters/reserved_rq_based_ios

The default value is RESERVED_REQUEST_BASED_IOS (256).  The maximum
allowed value is RESERVED_MAX_IOS (1024).

Export dm_get_reserved_rq_based_ios() for use by DM targets and core
code.  Switch to sizing dm-mpath's mempool using DM core's configurable
'reserved_rq_based_ios'.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-mpath.c |    6 +++---
 drivers/md/dm.c       |   38 +++++++++++++++++++++++++++++++++++++-
 drivers/md/dm.h       |    2 ++
 3 files changed, 42 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index b759a12..e0bed10 100644
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
index 47bac14..93ba644 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -213,9 +213,41 @@ struct dm_md_mempools {
 
 #define RESERVED_BIO_BASED_IOS		16
 #define RESERVED_REQUEST_BASED_IOS	256
+#define RESERVED_MAX_IOS		1024
 static struct kmem_cache *_io_cache;
 static struct kmem_cache *_rq_tio_cache;
 
+/*
+ * Request-based DM's mempools' reserved IOs set by the user.
+ */
+static unsigned reserved_rq_based_ios = RESERVED_REQUEST_BASED_IOS;
+
+static unsigned __dm_get_reserved_ios(unsigned *reserved_ios,
+				      unsigned def, unsigned max)
+{
+	unsigned ios = ACCESS_ONCE(*reserved_ios);
+	unsigned modified_ios = 0;
+
+	if (!ios)
+		modified_ios = def;
+	else if (ios > max)
+		modified_ios = max;
+
+	if (modified_ios) {
+		(void)cmpxchg(reserved_ios, ios, modified_ios);
+		ios = modified_ios;
+	}
+
+	return ios;
+}
+
+unsigned dm_get_reserved_rq_based_ios(void)
+{
+	return __dm_get_reserved_ios(&reserved_rq_based_ios,
+				     RESERVED_REQUEST_BASED_IOS, RESERVED_MAX_IOS);
+}
+EXPORT_SYMBOL_GPL(dm_get_reserved_rq_based_ios);
+
 static int __init local_init(void)
 {
 	int r = -ENOMEM;
@@ -2867,7 +2899,7 @@ struct dm_md_mempools *dm_alloc_md_mempools(unsigned type, unsigned integrity, u
 		front_pad = roundup(per_bio_data_size, __alignof__(struct dm_target_io)) + offsetof(struct dm_target_io, clone);
 	} else if (type == DM_TYPE_REQUEST_BASED) {
 		cachep = _rq_tio_cache;
-		pool_size = RESERVED_REQUEST_BASED_IOS;
+		pool_size = dm_get_reserved_rq_based_ios();
 		front_pad = offsetof(struct dm_rq_clone_bio_info, clone);
 		/* per_bio_data_size is not used. See __bind_mempools(). */
 		WARN_ON(per_bio_data_size != 0);
@@ -2925,6 +2957,10 @@ module_exit(dm_exit);
 
 module_param(major, uint, 0);
 MODULE_PARM_DESC(major, "The major number of the device mapper");
+
+module_param(reserved_rq_based_ios, uint, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(reserved_rq_based_ios, "Reserved IOs in request-based mempools");
+
 MODULE_DESCRIPTION(DM_NAME " driver");
 MODULE_AUTHOR("Joe Thornber <dm-devel@redhat.com>");
 MODULE_LICENSE("GPL");
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 5e604cc..1539650 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -184,6 +184,8 @@ void dm_free_md_mempools(struct dm_md_mempools *pools);
 /*
  * Helpers that are used by DM core
  */
+unsigned dm_get_reserved_rq_based_ios(void);
+
 static inline bool dm_message_test_buffer_overflow(char *result, unsigned maxlen)
 {
 	return !maxlen || strlen(result) + 1 >= maxlen;
-- 
1.7.1
