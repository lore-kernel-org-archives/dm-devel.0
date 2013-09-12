From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 2/7] dm: add reserved_rq_based_ios module
	parameter
Date: Thu, 12 Sep 2013 18:24:53 -0400
Message-ID: <1379024698-10487-3-git-send-email-snitzer@redhat.com>
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

Allow user to change the number of IOs that are reserved by
request-based DM's mempools by writing to this file:
/sys/module/dm_mod/parameters/reserved_rq_based_ios

The default value is RESERVED_REQUEST_BASED_IOS (256).

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 47bac14..8553d03 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -216,6 +216,38 @@ struct dm_md_mempools {
 static struct kmem_cache *_io_cache;
 static struct kmem_cache *_rq_tio_cache;
 
+/*
+ * Request-based DM's mempools' reserved IOs set by the user
+ */
+static unsigned reserved_rq_based_ios;
+
+/*
+ * A copy of reserved_rq_based_ios because it can change anytime.
+ * If values disagree, the user has changed reserved_rq_based_ios.
+ */
+static unsigned reserved_rq_based_ios_latch;
+
+/*
+ * This mutex protects reserved_rq_based_ios_latch.
+ */
+static DEFINE_MUTEX(dm_mempools_lock);
+
+static void __reserved_request_based_ios_refresh(void)
+{
+	BUG_ON(!mutex_is_locked(&dm_mempools_lock));
+
+	reserved_rq_based_ios_latch = ACCESS_ONCE(reserved_rq_based_ios);
+
+	/*
+	 * If the user uses "0", it means default.  Modify
+	 * reserved_rq_based_ios to report the default to the user.
+	 */
+	if (!reserved_rq_based_ios_latch) {
+		(void)cmpxchg(&reserved_rq_based_ios, 0, RESERVED_REQUEST_BASED_IOS);
+		reserved_rq_based_ios_latch = reserved_rq_based_ios;
+	}
+}
+
 static int __init local_init(void)
 {
 	int r = -ENOMEM;
@@ -241,6 +273,10 @@ static int __init local_init(void)
 	if (!_major)
 		_major = r;
 
+	mutex_lock(&dm_mempools_lock);
+	__reserved_request_based_ios_refresh();
+	mutex_unlock(&dm_mempools_lock);
+
 	return 0;
 
 out_uevent_exit:
@@ -2867,7 +2903,14 @@ struct dm_md_mempools *dm_alloc_md_mempools(unsigned type, unsigned integrity, u
 		front_pad = roundup(per_bio_data_size, __alignof__(struct dm_target_io)) + offsetof(struct dm_target_io, clone);
 	} else if (type == DM_TYPE_REQUEST_BASED) {
 		cachep = _rq_tio_cache;
-		pool_size = RESERVED_REQUEST_BASED_IOS;
+
+		mutex_lock(&dm_mempools_lock);
+		/* Check if reserved_rq_based_ios changed. */
+		if (reserved_rq_based_ios != reserved_rq_based_ios_latch)
+			__reserved_request_based_ios_refresh();
+		pool_size = reserved_rq_based_ios_latch;
+		mutex_unlock(&dm_mempools_lock);
+
 		front_pad = offsetof(struct dm_rq_clone_bio_info, clone);
 		/* per_bio_data_size is not used. See __bind_mempools(). */
 		WARN_ON(per_bio_data_size != 0);
@@ -2925,6 +2968,10 @@ module_exit(dm_exit);
 
 module_param(major, uint, 0);
 MODULE_PARM_DESC(major, "The major number of the device mapper");
+
+module_param(reserved_rq_based_ios, uint, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(reserved_rq_based_ios, "Reserved IOs in request-based mempools");
+
 MODULE_DESCRIPTION(DM_NAME " driver");
 MODULE_AUTHOR("Joe Thornber <dm-devel@redhat.com>");
 MODULE_LICENSE("GPL");
-- 
1.8.1.4
