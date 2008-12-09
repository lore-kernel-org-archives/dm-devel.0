From: crquan@gmail.com
Subject: [PATCH] dm-target.c: simplify target_type to avoid
	kmalloc
Date: Tue,  9 Dec 2008 19:32:35 +0800
Message-ID: <1228822355-12674-1-git-send-email-crquan@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
Cc: linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Cheng Renquan <crquan@gmail.com>

Move the list_head from tt_internal into struct target_type embedded,
The struct tt_internal is totally unneeded, and the kmalloc is avoided,
block of memory copy is also avoided, like the original:

  -		ti->tt = *t;

the function of tt_internal's use field is replaced by the module's
reference count.

The only defect is that dm_register_target users cannot use const
target_type anymore.

Signed-off-by: Cheng Renquan <crquan@gmail.com>
---

I have simply tested it, that seems work well till now.

I found multi places in device-mapper code that kmalloc and vmalloc are over
used, if this would be applied, I want to start a series of dm patches to
improve them.

 drivers/md/dm-target.c        |  122 +++++++++++++---------------------------
 include/linux/device-mapper.h |    3 +
 2 files changed, 43 insertions(+), 82 deletions(-)

diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
index 835cf95..54a4ae0 100644
--- a/drivers/md/dm-target.c
+++ b/drivers/md/dm-target.c
@@ -14,142 +14,100 @@
 
 #define DM_MSG_PREFIX "target"
 
-struct tt_internal {
-	struct target_type tt;
-
-	struct list_head list;
-	long use;
-};
-
 static LIST_HEAD(_targets);
 static DECLARE_RWSEM(_lock);
 
-#define DM_MOD_NAME_SIZE 32
-
-static inline struct tt_internal *__find_target_type(const char *name)
+static inline struct target_type *__find_target_type(const char *name)
 {
-	struct tt_internal *ti;
+	struct target_type *tt;
 
-	list_for_each_entry (ti, &_targets, list)
-		if (!strcmp(name, ti->tt.name))
-			return ti;
+	list_for_each_entry (tt, &_targets, list)
+		if (!strcmp(name, tt->name))
+			return tt;
 
 	return NULL;
 }
 
-static struct tt_internal *get_target_type(const char *name)
+static struct target_type *get_target_type(const char *name)
 {
-	struct tt_internal *ti;
+	struct target_type *tt;
 
 	down_read(&_lock);
-
-	ti = __find_target_type(name);
-	if (ti) {
-		if ((ti->use == 0) && !try_module_get(ti->tt.module))
-			ti = NULL;
-		else
-			ti->use++;
-	}
-
+	tt = __find_target_type(name);
+	if (tt)
+		try_module_get(tt->module);
 	up_read(&_lock);
-	return ti;
-}
 
-static void load_module(const char *name)
-{
-	request_module("dm-%s", name);
+	return tt;
 }
 
 struct target_type *dm_get_target_type(const char *name)
 {
-	struct tt_internal *ti = get_target_type(name);
+	struct target_type *tt = get_target_type(name);
 
-	if (!ti) {
-		load_module(name);
-		ti = get_target_type(name);
+	if (!tt) {
+		request_module("dm-%s", name);
+		tt = get_target_type(name);
 	}
 
-	return ti ? &ti->tt : NULL;
+	return tt;
 }
 
-void dm_put_target_type(struct target_type *t)
+void dm_put_target_type(struct target_type *tt)
 {
-	struct tt_internal *ti = (struct tt_internal *) t;
-
 	down_read(&_lock);
-	if (--ti->use == 0)
-		module_put(ti->tt.module);
-
-	BUG_ON(ti->use < 0);
+	module_put(tt->module);
 	up_read(&_lock);
-
-	return;
 }
 
-static struct tt_internal *alloc_target(struct target_type *t)
-{
-	struct tt_internal *ti = kzalloc(sizeof(*ti), GFP_KERNEL);
-
-	if (ti)
-		ti->tt = *t;
-
-	return ti;
-}
-
-
 int dm_target_iterate(void (*iter_func)(struct target_type *tt,
 					void *param), void *param)
 {
-	struct tt_internal *ti;
+	struct target_type *tt;
 
 	down_read(&_lock);
-	list_for_each_entry (ti, &_targets, list)
-		iter_func(&ti->tt, param);
+	list_for_each_entry (tt, &_targets, list)
+		iter_func(tt, param);
 	up_read(&_lock);
 
 	return 0;
 }
 
-int dm_register_target(struct target_type *t)
+int dm_register_target(struct target_type *tt)
 {
-	int rv = 0;
-	struct tt_internal *ti = alloc_target(t);
-
-	if (!ti)
-		return -ENOMEM;
+	int ret = 0;
 
 	down_write(&_lock);
-	if (__find_target_type(t->name))
-		rv = -EEXIST;
+	if (__find_target_type(tt->name))
+		ret = -EEXIST;
 	else
-		list_add(&ti->list, &_targets);
-
+		list_add(&tt->list, &_targets);
 	up_write(&_lock);
-	if (rv)
-		kfree(ti);
-	return rv;
+
+	return ret;
 }
 
-int dm_unregister_target(struct target_type *t)
+int dm_unregister_target(struct target_type *tt)
 {
-	struct tt_internal *ti;
+	int ret = 0;
 
 	down_write(&_lock);
-	if (!(ti = __find_target_type(t->name))) {
-		up_write(&_lock);
-		return -EINVAL;
+	if (!__find_target_type(tt->name)) {
+		ret = -EINVAL;
+		goto out;
 	}
 
-	if (ti->use) {
-		up_write(&_lock);
-		return -ETXTBSY;
+	if (tt->module && module_refcount(tt->module)) {
+		ret = -ETXTBSY;
+		goto out;
 	}
 
-	list_del(&ti->list);
-	kfree(ti);
+	list_del(&tt->list);
 
+ out:
 	up_write(&_lock);
-	return 0;
+
+	return ret;
 }
 
 /*
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index c17fd33..8bcc7f5 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -117,6 +117,9 @@ struct target_type {
 	dm_message_fn message;
 	dm_ioctl_fn ioctl;
 	dm_merge_fn merge;
+
+	/* for internal use only */
+	struct list_head list;
 };
 
 struct io_restrictions {
-- 
1.6.0.4.762.gbd861
