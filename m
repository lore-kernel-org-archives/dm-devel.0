From: crquan@gmail.com
Subject: [PATCH 3/3] dm-target: embed internally used list_head into target_type
Date: Fri, 19 Dec 2008 12:19:45 +0800
Message-ID: <1229660385-17153-4-git-send-email-crquan@gmail.com>
References: <1229660385-17153-1-git-send-email-crquan@gmail.com>
 <1229660385-17153-2-git-send-email-crquan@gmail.com>
 <1229660385-17153-3-git-send-email-crquan@gmail.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754401AbYLSEUU@vger.kernel.org>
In-Reply-To: <1229660385-17153-3-git-send-email-crquan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: Alasdair G Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Cheng Renquan <crquan@gmail.com>

The tt_internal is really just a list_head to manage registered target_type
in a double linked list,

Here embed the list_head into target_type directly,
1. to avoid kmalloc/kfree;
2. then tt_internal is really unneeded;

Signed-off-by: Cheng Renquan <crquan@gmail.com>
---
 drivers/md/dm-target.c        |   95 +++++++++++++++--------------------------
 include/linux/device-mapper.h |    3 +
 2 files changed, 37 insertions(+), 61 deletions(-)

diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
index a713c7f..ee120a9 100644
--- a/drivers/md/dm-target.c
+++ b/drivers/md/dm-target.c
@@ -14,40 +14,34 @@
 
 #define DM_MSG_PREFIX "target"
 
-struct tt_internal {
-	struct target_type *tt;
-
-	struct list_head list;
-};
-
 static LIST_HEAD(_targets);
 static DECLARE_RWSEM(_lock);
 
 #define DM_MOD_NAME_SIZE 32
 
-static inline struct tt_internal *__find_target_type(const char *name)
+static inline struct target_type *__find_target_type(const char *name)
 {
-	struct tt_internal *ti;
+	struct target_type *tt;
 
-	list_for_each_entry (ti, &_targets, list)
-		if (!strcmp(name, ti->tt->name))
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
 
-	ti = __find_target_type(name);
-	if (ti && !try_module_get(ti->tt->module))
-		ti = NULL;
+	tt = __find_target_type(name);
+	if (tt && !try_module_get(tt->module))
+		tt = NULL;
 
 	up_read(&_lock);
-	return ti;
+	return tt;
 }
 
 static void load_module(const char *name)
@@ -57,91 +51,70 @@ static void load_module(const char *name)
 
 struct target_type *dm_get_target_type(const char *name)
 {
-	struct tt_internal *ti = get_target_type(name);
+	struct target_type *tt = get_target_type(name);
 
-	if (!ti) {
+	if (!tt) {
 		load_module(name);
-		ti = get_target_type(name);
+		tt = get_target_type(name);
 	}
 
-	return ti ? ti->tt : NULL;
+	return tt;
 }
 
-void dm_put_target_type(struct target_type *t)
+void dm_put_target_type(struct target_type *tt)
 {
-	struct tt_internal *ti = (struct tt_internal *) t;
-
 	down_read(&_lock);
-	module_put(ti->tt->module);
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
-		ti->tt = t;
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
-		iter_func(ti->tt, param);
+	list_for_each_entry (tt, &_targets, list)
+		iter_func(tt, param);
 	up_read(&_lock);
 
 	return 0;
 }
 
-int dm_register_target(struct target_type *t)
+int dm_register_target(struct target_type *tt)
 {
 	int rv = 0;
-	struct tt_internal *ti = alloc_target(t);
-
-	if (!ti)
-		return -ENOMEM;
 
 	down_write(&_lock);
-	if (__find_target_type(t->name))
+	if (__find_target_type(tt->name))
 		rv = -EEXIST;
 	else
-		list_add(&ti->list, &_targets);
+		list_add(&tt->list, &_targets);
 
 	up_write(&_lock);
-	if (rv)
-		kfree(ti);
 	return rv;
 }
 
-int dm_unregister_target(struct target_type *t)
+int dm_unregister_target(struct target_type *tt)
 {
-	struct tt_internal *ti;
+	int rv = 0;
 
 	down_write(&_lock);
-	if (!(ti = __find_target_type(t->name))) {
-		up_write(&_lock);
-		return -EINVAL;
+	if (!__find_target_type(tt->name)) {
+		rv = -EINVAL;
+		goto out;
 	}
 
-	if (ti->tt->module && module_refcount(ti->tt->module)) {
-		up_write(&_lock);
-		return -ETXTBSY;
+	if (tt->module && module_refcount(tt->module)) {
+		rv = -ETXTBSY;
+		goto out;
 	}
 
-	list_del(&ti->list);
-	kfree(ti);
+	list_del(&tt->list);
 
+ out:
 	up_write(&_lock);
-	return 0;
+	return rv;
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
1.6.0.2.GIT
