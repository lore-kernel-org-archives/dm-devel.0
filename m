From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-ioctl: fix alignment of event number in the
	device list
Date: Wed, 20 Sep 2017 07:29:49 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1709200331390.26957@file01.intranet.prod.int.rdu2.redhat.com>
References: <20170917023849.GA4094@asgard.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170917023849.GA4094@asgard.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Eugene Syromiatnikov <esyr@redhat.com>
Cc: dm-devel@redhat.com, agrover@redhat.com, Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids



On Sun, 17 Sep 2017, Eugene Syromiatnikov wrote:

> > +			event_nr = align_ptr(((void *) (nl + 1)) + strlen(hc->name) + 1);
>
> If my understanding is correct, (nl + 1) differs between 32-bit and
> 64-bit kernels (as the structure contains of one 8-byte and one 4-byte field),
> so this logic is probably broken for compat.

You're right.

I've created this patch for this problem. The patch also increments 
version number (so that userspace can detect the fix) and it also triggers 
global event for device create/remove/rename/table change, so that we can 
monitor for these events.

Mikulas


From: Mikulas Patocka <mpatocka@redhat.com>

The size of struct dm_name_list is different on 32-bit and 64-bit kernels.

This mismatch caused some harmless difference in padding when using 32-bit
or 64-bit kernel. The patch 23d70c5e52dd added reporting event number in
the output of DM_LIST_DEVICES_CMD. This difference in padding makes it
impossible for userspace to determine the location of the event number
(the location would be different when running on 32-bit and 64-bit
kernel).

This patch fixes the padding is uses offsetof(struct dm_name_list, name)
instead of sizeof(struct dm_name_list) when determining the location of
entries.

The patch also increments version number to 37, so that the userspace can
use the version number to determine that the event number is present and
correctly located.

When we change it, I also added a code that raises global event when a dm
device is created, removed, renamed or when table is swapped, so that the
user can monitor for device changes.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Eugene Syromiatnikov <esyr@redhat.com>
Fixes: 23d70c5e52dd ("dm ioctl: report event number in DM_LIST_DEVICES")
Cc: stable@vger.kernel.org	# 4.13+

---
 drivers/md/dm-core.h          |    1 +
 drivers/md/dm-ioctl.c         |   37 ++++++++++++++++++++++++-------------
 drivers/md/dm.c               |   10 ++++++++--
 include/uapi/linux/dm-ioctl.h |    4 ++--
 4 files changed, 35 insertions(+), 17 deletions(-)

Index: linux-4.14-rc1/drivers/md/dm-ioctl.c
===================================================================
--- linux-4.14-rc1.orig/drivers/md/dm-ioctl.c
+++ linux-4.14-rc1/drivers/md/dm-ioctl.c
@@ -477,9 +477,13 @@ static int remove_all(struct file *filp,
  * Round up the ptr to an 8-byte boundary.
  */
 #define ALIGN_MASK 7
+static inline size_t align_val(size_t val)
+{
+	return (val + ALIGN_MASK) & ~ALIGN_MASK;
+}
 static inline void *align_ptr(void *ptr)
 {
-	return (void *) (((size_t) (ptr + ALIGN_MASK)) & ~ALIGN_MASK);
+	return (void *)align_val((size_t)ptr);
 }
 
 /*
@@ -505,7 +509,7 @@ static int list_devices(struct file *fil
 	struct hash_cell *hc;
 	size_t len, needed = 0;
 	struct gendisk *disk;
-	struct dm_name_list *nl, *old_nl = NULL;
+	struct dm_name_list *orig_nl, *nl, *old_nl = NULL;
 	uint32_t *event_nr;
 
 	down_write(&_hash_lock);
@@ -516,17 +520,15 @@ static int list_devices(struct file *fil
 	 */
 	for (i = 0; i < NUM_BUCKETS; i++) {
 		list_for_each_entry (hc, _name_buckets + i, name_list) {
-			needed += sizeof(struct dm_name_list);
-			needed += strlen(hc->name) + 1;
-			needed += ALIGN_MASK;
-			needed += (sizeof(uint32_t) + ALIGN_MASK) & ~ALIGN_MASK;
+			needed += align_val(offsetof(struct dm_name_list, name) + strlen(hc->name) + 1);
+			needed += align_val(sizeof(uint32_t));
 		}
 	}
 
 	/*
 	 * Grab our output buffer.
 	 */
-	nl = get_result_buffer(param, param_size, &len);
+	nl = orig_nl = get_result_buffer(param, param_size, &len);
 	if (len < needed) {
 		param->flags |= DM_BUFFER_FULL_FLAG;
 		goto out;
@@ -549,11 +551,16 @@ static int list_devices(struct file *fil
 			strcpy(nl->name, hc->name);
 
 			old_nl = nl;
-			event_nr = align_ptr(((void *) (nl + 1)) + strlen(hc->name) + 1);
+			event_nr = align_ptr(nl->name + strlen(hc->name) + 1);
 			*event_nr = dm_get_event_nr(hc->md);
 			nl = align_ptr(event_nr + 1);
 		}
 	}
+	/*
+	 * If mismatch happens, security may be compromised due to buffer
+	 * overflow, so it's better to crash.
+	 */
+	BUG_ON((char *)nl - (char *)orig_nl != needed);
 
  out:
 	up_write(&_hash_lock);
@@ -1621,7 +1628,8 @@ static int target_message(struct file *f
  * which has a variable size, is not used by the function processing
  * the ioctl.
  */
-#define IOCTL_FLAGS_NO_PARAMS	1
+#define IOCTL_FLAGS_NO_PARAMS		1
+#define IOCTL_FLAGS_ISSUE_GLOBAL_EVENT	2
 
 /*-----------------------------------------------------------------
  * Implementation of open/close/ioctl on the special char
@@ -1635,12 +1643,12 @@ static ioctl_fn lookup_ioctl(unsigned in
 		ioctl_fn fn;
 	} _ioctls[] = {
 		{DM_VERSION_CMD, 0, NULL}, /* version is dealt with elsewhere */
-		{DM_REMOVE_ALL_CMD, IOCTL_FLAGS_NO_PARAMS, remove_all},
+		{DM_REMOVE_ALL_CMD, IOCTL_FLAGS_NO_PARAMS | IOCTL_FLAGS_ISSUE_GLOBAL_EVENT, remove_all},
 		{DM_LIST_DEVICES_CMD, 0, list_devices},
 
-		{DM_DEV_CREATE_CMD, IOCTL_FLAGS_NO_PARAMS, dev_create},
-		{DM_DEV_REMOVE_CMD, IOCTL_FLAGS_NO_PARAMS, dev_remove},
-		{DM_DEV_RENAME_CMD, 0, dev_rename},
+		{DM_DEV_CREATE_CMD, IOCTL_FLAGS_NO_PARAMS | IOCTL_FLAGS_ISSUE_GLOBAL_EVENT, dev_create},
+		{DM_DEV_REMOVE_CMD, IOCTL_FLAGS_NO_PARAMS | IOCTL_FLAGS_ISSUE_GLOBAL_EVENT, dev_remove},
+		{DM_DEV_RENAME_CMD, IOCTL_FLAGS_ISSUE_GLOBAL_EVENT, dev_rename},
 		{DM_DEV_SUSPEND_CMD, IOCTL_FLAGS_NO_PARAMS, dev_suspend},
 		{DM_DEV_STATUS_CMD, IOCTL_FLAGS_NO_PARAMS, dev_status},
 		{DM_DEV_WAIT_CMD, 0, dev_wait},
@@ -1869,6 +1877,9 @@ static int ctl_ioctl(struct file *file,
 	    unlikely(ioctl_flags & IOCTL_FLAGS_NO_PARAMS))
 		DMERR("ioctl %d tried to output some data but has IOCTL_FLAGS_NO_PARAMS set", cmd);
 
+	if (!r && ioctl_flags & IOCTL_FLAGS_ISSUE_GLOBAL_EVENT)
+		dm_issue_global_event();
+
 	/*
 	 * Copy the results back to userland.
 	 */
Index: linux-4.14-rc1/include/uapi/linux/dm-ioctl.h
===================================================================
--- linux-4.14-rc1.orig/include/uapi/linux/dm-ioctl.h
+++ linux-4.14-rc1/include/uapi/linux/dm-ioctl.h
@@ -269,9 +269,9 @@ enum {
 #define DM_DEV_SET_GEOMETRY	_IOWR(DM_IOCTL, DM_DEV_SET_GEOMETRY_CMD, struct dm_ioctl)
 
 #define DM_VERSION_MAJOR	4
-#define DM_VERSION_MINOR	36
+#define DM_VERSION_MINOR	37
 #define DM_VERSION_PATCHLEVEL	0
-#define DM_VERSION_EXTRA	"-ioctl (2017-06-09)"
+#define DM_VERSION_EXTRA	"-ioctl (2017-09-20)"
 
 /* Status bits */
 #define DM_READONLY_FLAG	(1 << 0) /* In/Out */
Index: linux-4.14-rc1/drivers/md/dm.c
===================================================================
--- linux-4.14-rc1.orig/drivers/md/dm.c
+++ linux-4.14-rc1/drivers/md/dm.c
@@ -52,6 +52,12 @@ static struct workqueue_struct *deferred
 atomic_t dm_global_event_nr = ATOMIC_INIT(0);
 DECLARE_WAIT_QUEUE_HEAD(dm_global_eventq);
 
+void dm_issue_global_event(void)
+{
+	atomic_inc(&dm_global_event_nr);
+	wake_up(&dm_global_eventq);
+}
+
 /*
  * One of these is allocated per bio.
  */
@@ -1902,9 +1908,8 @@ static void event_callback(void *context
 	dm_send_uevents(&uevents, &disk_to_dev(md->disk)->kobj);
 
 	atomic_inc(&md->event_nr);
-	atomic_inc(&dm_global_event_nr);
 	wake_up(&md->eventq);
-	wake_up(&dm_global_eventq);
+	dm_issue_global_event();
 }
 
 /*
@@ -2321,6 +2326,7 @@ struct dm_table *dm_swap_table(struct ma
 	}
 
 	map = __bind(md, table, &limits);
+	dm_issue_global_event();
 
 out:
 	mutex_unlock(&md->suspend_lock);
Index: linux-4.14-rc1/drivers/md/dm-core.h
===================================================================
--- linux-4.14-rc1.orig/drivers/md/dm-core.h
+++ linux-4.14-rc1/drivers/md/dm-core.h
@@ -150,5 +150,6 @@ static inline bool dm_message_test_buffe
 
 extern atomic_t dm_global_event_nr;
 extern wait_queue_head_t dm_global_eventq;
+void dm_issue_global_event(void);
 
 #endif
