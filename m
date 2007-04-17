From: Stephen.Wilson@amd.com
Subject: [PATCH]: dm-user w/ Linux 2.6.20
Date: Tue, 17 Apr 2007 18:10:35 -0500
Message-ID: <462553eb.Sw1f1vvfR3uNVt8E%Stephen.Wilson@amd.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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


Kernel Module: dm-user.ko

Found at: http://static.danplanet.com/hg/dm-userspace.ring

This patch fixes compilation issues for dm-user module when compiling for kernels equal or greater than Linux 2.6.20. In particular fixing up driver to work with newer workqueue API and fixing a couple deprecated type issues. There should be no functional changes to the driver with this patch.

Stephen Wilson
Operating System Research Center
AMD Corporation

Signed-off-by: Stephen Wilson <Stephen Wilson amd com>

diff -r 1af4bd771b30 module/dm-user.h
--- a/module/dm-user.h	Thu Jan 25 17:25:11 2007 -0800
+++ b/module/dm-user.h	Tue Apr 17 15:42:29 2007 -0500
@@ -19,13 +19,23 @@
 
 #ifndef __DM_USER_H
 #define __DM_USER_H
-
+#include <linux/version.h>
 #include <linux/dm-userspace.h>
 
 #include <linux/hardirq.h>
 #include <linux/slab.h>
 
 #define DMU_KEY_LEN 256
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
+#define INIT_WORKQ(_wq, _routine)	INIT_WORK(_wq, _routine, _wq)
+#define PREPARE_WORKQ(_wq, _routine)	PREPARE_WORK(_wq, _routine, _wq)
+#define WORK_ARG_TYPE void
+#else
+#define INIT_WORKQ(_wq, _routine)	INIT_WORK(_wq, _routine)
+#define PREPARE_WORKQ(_wq, _routine)	PREPARE_WORK(_wq, _routine)
+#define WORK_ARG_TYPE struct work_struct
+#endif
 
 extern struct target_type userspace_target;
 extern mempool_t *request_pool;
@@ -115,7 +125,7 @@ struct dmu_request {
 
 
 extern void add_tx_request(struct dmu_device *dev, struct dmu_request *req);
-extern void endio_worker(void *data);
+extern void endio_worker(WORK_ARG_TYPE *data);
 
 /* Find and grab a reference to a target device */
 struct target_device *find_target(struct dmu_device *dev,
diff -r 1af4bd771b30 module/dm-userspace-cache.c
--- a/module/dm-userspace-cache.c	Thu Jan 25 17:25:11 2007 -0800
+++ b/module/dm-userspace-cache.c	Tue Apr 17 15:42:27 2007 -0500
@@ -37,7 +37,7 @@
 
 #define DM_MSG_PREFIX "dm-userspace-cache"
 
-static kmem_cache_t *map_cache;
+static struct kmem_cache *map_cache;
 
 struct dmu_mappings {
 	struct list_head *table;
diff -r 1af4bd771b30 module/dm-userspace-chardev.c
--- a/module/dm-userspace-chardev.c	Thu Jan 25 17:25:11 2007 -0800
+++ b/module/dm-userspace-chardev.c	Tue Apr 17 15:42:27 2007 -0500
@@ -147,7 +147,7 @@ static void send_userspace_message(struc
 	 * then it needs to be freed after sending
 	 */
 	if (list_empty(&req->list)) {
- 		INIT_WORK(&req->task, endio_worker, req);
+ 		INIT_WORKQ(&req->task, endio_worker);
 		schedule_work(&req->task);
 	}
 }
@@ -306,9 +306,9 @@ static void copy_block(struct dmu_device
 	kcopyd_copy(dev->kcopy, &src, 1, &dst, 0, flush_block, req);
 }
 
-static void map_worker(void *data)
-{
-	struct dmu_request *req = data;
+static void map_worker(WORK_ARG_TYPE *data)
+{
+	struct dmu_request *req = container_of(data, struct dmu_request, task);
 	struct dmu_msg_map_response *msg = &req->response;
 	struct dmu_device *dev = req->dev;
 	struct target_device *src_dev, *dst_dev;
@@ -393,7 +393,7 @@ static void do_map_bio(struct dmu_device
 
 	memcpy(&req->response, msg, sizeof(req->response));
 
-	INIT_WORK(&req->task, map_worker, req);
+	INIT_WORKQ(&req->task, map_worker);
 	schedule_work(&req->task);
 }
 
diff -r 1af4bd771b30 module/dm-userspace.c
--- a/module/dm-userspace.c	Thu Jan 25 17:25:11 2007 -0800
+++ b/module/dm-userspace.c	Tue Apr 17 15:42:27 2007 -0500
@@ -40,7 +40,7 @@
 
 #define DM_MSG_PREFIX     "dm-userspace"
 
-static kmem_cache_t *request_cache;
+static struct kmem_cache *request_cache;
 mempool_t *request_pool;
 
 spinlock_t devices_lock;
@@ -51,9 +51,9 @@ int nocache;
 /* Device number for the control device */
 dev_t dmu_dev;
 
-void endio_worker(void *data)
-{
-	struct dmu_request *req = data;
+void endio_worker(WORK_ARG_TYPE *data)
+{
+	struct dmu_request *req = container_of(data, struct dmu_request, task);
 	struct dmu_device *dev = req->dev;
 
 	spin_lock(&dev->lock);
@@ -63,7 +63,7 @@ void endio_worker(void *data)
 		atomic_dec(&dev->total);
 		wake_up_interruptible(&dev->lowmem);
 	} else {
-		PREPARE_WORK(&req->task, endio_worker, req);
+		PREPARE_WORKQ(&req->task, endio_worker);
 		schedule_work(&req->task);
 	}
 	spin_unlock(&dev->lock);
@@ -474,7 +474,7 @@ static int dmu_end_io(struct dm_target *
 		add_tx_request(req->dev, req);
 		ret = 1;
 	} else {
-		INIT_WORK(&req->task, endio_worker, req);
+		INIT_WORKQ(&req->task, endio_worker);
 		schedule_work(&req->task);
 	}
 
