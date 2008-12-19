From: crquan@gmail.com
Subject: [PATCH 2/3] dm-target: use pointer reference instead of making a copy
Date: Fri, 19 Dec 2008 12:19:44 +0800
Message-ID: <1229660385-17153-3-git-send-email-crquan@gmail.com>
References: <1229660385-17153-1-git-send-email-crquan@gmail.com>
 <1229660385-17153-2-git-send-email-crquan@gmail.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754211AbYLSETz@vger.kernel.org>
In-Reply-To: <1229660385-17153-2-git-send-email-crquan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: Alasdair G Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Cheng Renquan <crquan@gmail.com>

The tt_internal always use target_type read-only, so there's no need to
making a copy, just a pointer reference is good, this could save
 (sizeof(target_type) - sizeof(pointer)) bytes memory per target_type.

  -		ti->tt = *t;
  +		ti->tt = t;

Signed-off-by: Cheng Renquan <crquan@gmail.com>
---
 drivers/md/dm-target.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
index 018df35..a713c7f 100644
--- a/drivers/md/dm-target.c
+++ b/drivers/md/dm-target.c
@@ -15,7 +15,7 @@
 #define DM_MSG_PREFIX "target"
 
 struct tt_internal {
-	struct target_type tt;
+	struct target_type *tt;
 
 	struct list_head list;
 };
@@ -30,7 +30,7 @@ static inline struct tt_internal *__find_target_type(const char *name)
 	struct tt_internal *ti;
 
 	list_for_each_entry (ti, &_targets, list)
-		if (!strcmp(name, ti->tt.name))
+		if (!strcmp(name, ti->tt->name))
 			return ti;
 
 	return NULL;
@@ -43,7 +43,7 @@ static struct tt_internal *get_target_type(const char *name)
 	down_read(&_lock);
 
 	ti = __find_target_type(name);
-	if (ti && !try_module_get(ti->tt.module))
+	if (ti && !try_module_get(ti->tt->module))
 		ti = NULL;
 
 	up_read(&_lock);
@@ -64,7 +64,7 @@ struct target_type *dm_get_target_type(const char *name)
 		ti = get_target_type(name);
 	}
 
-	return ti ? &ti->tt : NULL;
+	return ti ? ti->tt : NULL;
 }
 
 void dm_put_target_type(struct target_type *t)
@@ -72,7 +72,7 @@ void dm_put_target_type(struct target_type *t)
 	struct tt_internal *ti = (struct tt_internal *) t;
 
 	down_read(&_lock);
-	module_put(ti->tt.module);
+	module_put(ti->tt->module);
 	up_read(&_lock);
 
 	return;
@@ -83,7 +83,7 @@ static struct tt_internal *alloc_target(struct target_type *t)
 	struct tt_internal *ti = kzalloc(sizeof(*ti), GFP_KERNEL);
 
 	if (ti)
-		ti->tt = *t;
+		ti->tt = t;
 
 	return ti;
 }
@@ -96,7 +96,7 @@ int dm_target_iterate(void (*iter_func)(struct target_type *tt,
 
 	down_read(&_lock);
 	list_for_each_entry (ti, &_targets, list)
-		iter_func(&ti->tt, param);
+		iter_func(ti->tt, param);
 	up_read(&_lock);
 
 	return 0;
@@ -132,7 +132,7 @@ int dm_unregister_target(struct target_type *t)
 		return -EINVAL;
 	}
 
-	if (ti->tt.module && module_refcount(ti->tt.module)) {
+	if (ti->tt->module && module_refcount(ti->tt->module)) {
 		up_write(&_lock);
 		return -ETXTBSY;
 	}
-- 
1.6.0.2.GIT
