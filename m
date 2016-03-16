From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 2/5] dm: Move multipath-specific stuff out of
	dm-uevent.c
Date: Wed, 16 Mar 2016 16:27:44 -0700
Message-ID: <1458170867-429-3-git-send-email-agrover@redhat.com>
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

There's a little bit of mpath-specific stuff that is in dm-uevent.c,
because all current uevents want to attach DM_PATH and DM_NR_VALID_PATHS
variables to the uevent. Makes sense since all currently defined DM
uevents are for dm-mpath, but is not true for future uevents. Move the
addition of these to dm-mpath.c and expose a few lower-level functions,
dm_build_uevent, dm_uevent_add and dm_uevent_free, for other dm targets to
build their own uevents.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/md/dm-mpath.c  | 71 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-uevent.c | 75 +++++---------------------------------------------
 drivers/md/dm-uevent.h | 30 ++++++++++++++++----
 drivers/md/dm.c        |  1 +
 4 files changed, 103 insertions(+), 74 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 677ba22..a47b5e0 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -29,6 +29,15 @@
 #define DM_PG_INIT_DELAY_MSECS 2000
 #define DM_PG_INIT_DELAY_DEFAULT ((unsigned) -1)
 
+static const struct {
+	enum dm_uevent_type type;
+	enum kobject_action action;
+	char *name;
+} _dm_mpath_uevent_type_names[] = {
+	{DM_UEVENT_PATH_FAILED, KOBJ_CHANGE, "PATH_FAILED"},
+	{DM_UEVENT_PATH_REINSTATED, KOBJ_CHANGE, "PATH_REINSTATED"},
+};
+
 /* Path properties */
 struct pgpath {
 	struct list_head list;
@@ -968,6 +977,68 @@ static void multipath_dtr(struct dm_target *ti)
 	free_multipath(m);
 }
 
+static struct dm_uevent *dm_build_path_uevent(struct mapped_device *md,
+					      struct dm_target *ti,
+					      enum kobject_action action,
+					      const char *dm_action,
+					      const char *path,
+					      unsigned nr_valid_paths)
+{
+	struct dm_uevent *event;
+
+	event = dm_build_uevent(md, ti, action, dm_action);
+	if (IS_ERR(event))
+		return event;
+
+	if (add_uevent_var(&event->ku_env, "DM_PATH=%s", path)) {
+		DMERR("%s: add_uevent_var() for DM_PATH failed", __func__);
+		goto err_add;
+	}
+
+	if (add_uevent_var(&event->ku_env, "DM_NR_VALID_PATHS=%d",
+			   nr_valid_paths)) {
+		DMERR("%s: add_uevent_var() for DM_NR_VALID_PATHS failed",
+		      __func__);
+		goto err_add;
+	}
+
+	return event;
+
+err_add:
+	dm_uevent_free(event);
+	return ERR_PTR(-ENOMEM);
+}
+
+/**
+ * dm_path_uevent - called to create a new path event and queue it
+ *
+ * @event_type:	path event type enum
+ * @ti:			pointer to a dm_target
+ * @path:		string containing pathname
+ * @nr_valid_paths:	number of valid paths remaining
+ *
+ */
+static void dm_path_uevent(enum dm_uevent_type event_type, struct dm_target *ti,
+		   const char *path, unsigned nr_valid_paths)
+{
+	struct mapped_device *md = dm_table_get_md(ti->table);
+	struct dm_uevent *event;
+
+	if (event_type >= ARRAY_SIZE(_dm_mpath_uevent_type_names)) {
+		DMERR("%s: Invalid event_type %d", __func__, event_type);
+		return;
+	}
+
+	event = dm_build_path_uevent(md, ti,
+				     _dm_mpath_uevent_type_names[event_type].action,
+				     _dm_mpath_uevent_type_names[event_type].name,
+				     path, nr_valid_paths);
+	if (IS_ERR(event))
+		return;
+
+	dm_uevent_add(md, &event->elist);
+}
+
 /*
  * Take a path out of use.
  */
diff --git a/drivers/md/dm-uevent.c b/drivers/md/dm-uevent.c
index 2d5f858..f7089dd 100644
--- a/drivers/md/dm-uevent.c
+++ b/drivers/md/dm-uevent.c
@@ -29,30 +29,13 @@
 
 #define DM_MSG_PREFIX "uevent"
 
-static const struct {
-	enum dm_uevent_type type;
-	enum kobject_action action;
-	char *name;
-} _dm_uevent_type_names[] = {
-	{DM_UEVENT_PATH_FAILED, KOBJ_CHANGE, "PATH_FAILED"},
-	{DM_UEVENT_PATH_REINSTATED, KOBJ_CHANGE, "PATH_REINSTATED"},
-};
-
 static struct kmem_cache *_dm_event_cache;
 
-struct dm_uevent {
-	struct mapped_device *md;
-	enum kobject_action action;
-	struct kobj_uevent_env ku_env;
-	struct list_head elist;
-	char name[DM_NAME_LEN];
-	char uuid[DM_UUID_LEN];
-};
-
-static void dm_uevent_free(struct dm_uevent *event)
+void dm_uevent_free(struct dm_uevent *event)
 {
 	kmem_cache_free(_dm_event_cache, event);
 }
+EXPORT_SYMBOL_GPL(dm_uevent_free);
 
 static struct dm_uevent *dm_uevent_alloc(struct mapped_device *md)
 {
@@ -68,12 +51,10 @@ static struct dm_uevent *dm_uevent_alloc(struct mapped_device *md)
 	return event;
 }
 
-static struct dm_uevent *dm_build_path_uevent(struct mapped_device *md,
-					      struct dm_target *ti,
-					      enum kobject_action action,
-					      const char *dm_action,
-					      const char *path,
-					      unsigned nr_valid_paths)
+struct dm_uevent *dm_build_uevent(struct mapped_device *md,
+					 struct dm_target *ti,
+					 enum kobject_action action,
+					 const char *dm_action)
 {
 	struct dm_uevent *event;
 
@@ -104,18 +85,6 @@ static struct dm_uevent *dm_build_path_uevent(struct mapped_device *md,
 		goto err_add;
 	}
 
-	if (add_uevent_var(&event->ku_env, "DM_PATH=%s", path)) {
-		DMERR("%s: add_uevent_var() for DM_PATH failed", __func__);
-		goto err_add;
-	}
-
-	if (add_uevent_var(&event->ku_env, "DM_NR_VALID_PATHS=%d",
-			   nr_valid_paths)) {
-		DMERR("%s: add_uevent_var() for DM_NR_VALID_PATHS failed",
-		      __func__);
-		goto err_add;
-	}
-
 	return event;
 
 err_add:
@@ -123,6 +92,7 @@ err_add:
 err_nomem:
 	return ERR_PTR(-ENOMEM);
 }
+EXPORT_SYMBOL_GPL(dm_build_uevent);
 
 /**
  * dm_send_uevents - send uevents for given list
@@ -170,37 +140,6 @@ uevent_free:
 	}
 }
 
-/**
- * dm_path_uevent - called to create a new path event and queue it
- *
- * @event_type:	path event type enum
- * @ti:			pointer to a dm_target
- * @path:		string containing pathname
- * @nr_valid_paths:	number of valid paths remaining
- *
- */
-void dm_path_uevent(enum dm_uevent_type event_type, struct dm_target *ti,
-		   const char *path, unsigned nr_valid_paths)
-{
-	struct mapped_device *md = dm_table_get_md(ti->table);
-	struct dm_uevent *event;
-
-	if (event_type >= ARRAY_SIZE(_dm_uevent_type_names)) {
-		DMERR("%s: Invalid event_type %d", __func__, event_type);
-		return;
-	}
-
-	event = dm_build_path_uevent(md, ti,
-				     _dm_uevent_type_names[event_type].action,
-				     _dm_uevent_type_names[event_type].name,
-				     path, nr_valid_paths);
-	if (IS_ERR(event))
-		return;
-
-	dm_uevent_add(md, &event->elist);
-}
-EXPORT_SYMBOL_GPL(dm_path_uevent);
-
 int dm_uevent_init(void)
 {
 	_dm_event_cache = KMEM_CACHE(dm_uevent, 0);
diff --git a/drivers/md/dm-uevent.h b/drivers/md/dm-uevent.h
index 2eccc8b..4ff2ad1 100644
--- a/drivers/md/dm-uevent.h
+++ b/drivers/md/dm-uevent.h
@@ -21,6 +21,17 @@
 #ifndef DM_UEVENT_H
 #define DM_UEVENT_H
 
+#include <linux/dm-ioctl.h> // for DM_*_LEN
+
+struct dm_uevent {
+	struct mapped_device *md;
+	enum kobject_action action;
+	struct kobj_uevent_env ku_env;
+	struct list_head elist;
+	char name[DM_NAME_LEN];
+	char uuid[DM_UUID_LEN];
+};
+
 enum dm_uevent_type {
 	DM_UEVENT_PATH_FAILED,
 	DM_UEVENT_PATH_REINSTATED,
@@ -31,9 +42,11 @@ enum dm_uevent_type {
 extern int dm_uevent_init(void);
 extern void dm_uevent_exit(void);
 extern void dm_send_uevents(struct list_head *events, struct kobject *kobj);
-extern void dm_path_uevent(enum dm_uevent_type event_type,
-			   struct dm_target *ti, const char *path,
-			   unsigned nr_valid_paths);
+struct dm_uevent *dm_build_uevent(struct mapped_device *md,
+					 struct dm_target *ti,
+					 enum kobject_action action,
+					 const char *dm_action);
+void dm_uevent_free(struct dm_uevent *event);
 
 #else
 
@@ -48,9 +61,14 @@ static inline void dm_send_uevents(struct list_head *events,
 				   struct kobject *kobj)
 {
 }
-static inline void dm_path_uevent(enum dm_uevent_type event_type,
-				  struct dm_target *ti, const char *path,
-				  unsigned nr_valid_paths)
+static inline struct dm_uevent *dm_build_uevent(struct mapped_device *md,
+						struct dm_target *ti,
+						enum kobject_action action,
+						const char *dm_action)
+{
+	return ERR_PTR(-ENOMEM);
+}
+static void dm_uevent_free(struct dm_uevent *event)
 {
 }
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index be49057..4c7f2c5 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -3473,6 +3473,7 @@ void dm_uevent_add(struct mapped_device *md, struct list_head *elist)
 	list_add(elist, &md->uevent_list);
 	spin_unlock_irqrestore(&md->uevent_lock, flags);
 }
+EXPORT_SYMBOL_GPL(dm_uevent_add);
 
 /*
  * The gendisk is only valid as long as you have a reference
-- 
2.5.0
