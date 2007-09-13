From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH 2/4] dm: add uevent functions
Date: Thu, 13 Sep 2007 08:07:12 -0700
Message-ID: <2394.76128849692$1189696824@news.gmane.org>
References: <20070913150710.355370291@us.ibm.com>>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-uevent-add-to-core.patch
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
Cc: Kay Sievers <kay.sievers@vrfy.org>
List-Id: dm-devel.ids

This patch adds support for the dm_path_event dm_send_event functions which
create and send udev events.

Signed-off-by: Mike Anderson <andmike@us.ibm.com>

---

 drivers/md/dm-uevent.c        |  110 ++++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-uevent.h        |   18 ++++++
 drivers/md/dm.c               |   28 ++++++++++
 include/linux/device-mapper.h |    2 
 4 files changed, 158 insertions(+)

Index: b/drivers/md/dm-uevent.c
===================================================================
--- a/drivers/md/dm-uevent.c
+++ b/drivers/md/dm-uevent.c
@@ -27,6 +27,16 @@
 
 #define DM_MSG_PREFIX "uevent"
 
+static struct {
+	enum dm_uevent_type	type;
+	enum kobject_action	action;
+	char			*name;
+} dm_uevent_type_names[] = {
+	{DM_UEVENT_UNKNOWN, KOBJ_CHANGE, "UNKNOWN"},
+	{DM_UEVENT_PATH_FAILED, KOBJ_CHANGE, "PATH_FAILED"},
+	{DM_UEVENT_PATH_REINSTATED, KOBJ_CHANGE, "PATH_REINSTATED"},
+};
+
 static struct kmem_cache *_dme_cache;
 
 struct dm_uevent {
@@ -55,6 +65,106 @@ static struct dm_uevent *dm_uevent_alloc
 	return evt;
 }
 
+static struct dm_uevent *dm_build_path_uevent(struct mapped_device *md,
+					enum kobject_action action,
+					const char *dm_action,
+					const char *path,
+					int nr_valid_paths)
+{
+	struct dm_uevent *evt;
+
+	evt = dm_uevent_alloc(md);
+	if (!evt) {
+		DMERR("%s: dm_uevent_alloc() failed", __FUNCTION__);
+		goto out_nomem;
+	}
+
+	evt->action = action;
+
+	if (add_uevent_var(&evt->ku_env, "DM_ACTION=%s", dm_action)) {
+		DMERR("%s: add_uevent_var() for DM_ACTION failed",
+		      __FUNCTION__);
+		goto out_add;
+	}
+
+	if (add_uevent_var(&evt->ku_env, "DM_SEQNUM=%u",
+			   dm_next_uevent_seq(md))) {
+		DMERR("%s: add_uevent_var() for DM_SEQNUM failed",
+		      __FUNCTION__);
+		goto out_add;
+	}
+
+	if (add_uevent_var(&evt->ku_env, "DM_PATH=%s", path)) {
+		DMERR("%s: add_uevent_var() for DM_PATH failed",
+		      __FUNCTION__);
+		goto out_add;
+	}
+
+	if (add_uevent_var(&evt->ku_env, "DM_PATHS=%d", nr_valid_paths)) {
+		DMERR("%s: add_uevent_var() for DM_PATHS failed",
+		      __FUNCTION__);
+		goto out_add;
+	}
+
+	return evt;
+
+out_add:
+	dm_uevent_free(evt);
+out_nomem:
+	return ERR_PTR(-ENOMEM);
+}
+
+/**
+ * dm_send_uevents - send uevents for given list
+ *
+ * @events:	list of events to send
+ * @kobj:	kobject generating event
+ *
+ **/
+void dm_send_uevents(struct list_head *events, struct kobject *kobj)
+{
+	int r;
+	struct dm_uevent *evt, *next;
+
+	list_for_each_entry_safe(evt, next, events, elist) {
+		list_del_init(&evt->elist);
+		r = kobject_uevent_env(kobj, evt->action, evt->ku_env.envp);
+		if (r)
+			DMERR("%s: kobject_uevent_env failed", __FUNCTION__);
+		dm_uevent_free(evt);
+	}
+}
+EXPORT_SYMBOL_GPL(dm_send_uevents);
+
+/**
+ * dm_path_uevent - called to create a new path event and queue it
+ *
+ * @evt_type:		path event type enum
+ * @t:			pointer to a dm_table
+ * @path:		string containing pathname
+ * @nr_valid_paths:	number of valid paths remaining
+ *
+ **/
+void dm_path_uevent(enum dm_uevent_type evt_type, struct dm_table *t,
+		   const char *path, int nr_valid_paths)
+{
+	struct mapped_device *md = dm_table_get_md(t);
+	struct dm_uevent *evt;
+
+	if (evt_type < ARRAY_SIZE(dm_uevent_type_names)) {
+		evt = dm_build_path_uevent(md,
+				   dm_uevent_type_names[evt_type].action,
+				   dm_uevent_type_names[evt_type].name,
+				   path,
+				   nr_valid_paths);
+		if (!IS_ERR(evt))
+			dm_uevent_add(md, &evt->elist);
+	} else
+		DMERR("%s: Invalid evt_type %d", __FUNCTION__, evt_type);
+	dm_put(md);
+}
+EXPORT_SYMBOL_GPL(dm_path_uevent);
+
 int dm_uevent_init(void)
 {
 	_dme_cache = KMEM_CACHE(dm_uevent, 0);
Index: b/drivers/md/dm-uevent.h
===================================================================
--- a/drivers/md/dm-uevent.h
+++ b/drivers/md/dm-uevent.h
@@ -21,10 +21,19 @@
 #ifndef DM_UEVENT_H
 #define DM_UEVENT_H
 
+enum dm_uevent_type {
+	DM_UEVENT_UNKNOWN,
+	DM_UEVENT_PATH_FAILED,
+	DM_UEVENT_PATH_REINSTATED,
+};
+
 #ifdef CONFIG_DM_UEVENT
 
 extern int dm_uevent_init(void);
 extern void dm_uevent_exit(void);
+extern void dm_send_uevents(struct list_head *events, struct kobject *kobj);
+extern void dm_path_uevent(enum dm_uevent_type evt_type, struct dm_table *t,
+			   const char *path, int nr_valid_paths);
 
 #else
 
@@ -35,6 +44,15 @@ static inline int dm_uevent_init(void)
 static inline void dm_uevent_exit(void)
 {
 }
+static inline void dm_send_uevents(struct list_head *events,
+				   struct kobject *kobj)
+{
+}
+static inline void dm_path_uevent(enum dm_uevent_type evt_type,
+				  struct dm_table *t, const char *path,
+				  int nr_valid_paths)
+{
+}
 
 #endif	/* CONFIG_DM_UEVENT */
 
Index: b/drivers/md/dm.c
===================================================================
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -113,6 +113,9 @@ struct mapped_device {
 	 */
 	atomic_t event_nr;
 	wait_queue_head_t eventq;
+	atomic_t uevent_seq;
+	struct list_head uevent_list;
+	spinlock_t uevent_lock; /* Protect access to uevent_list */
 
 	/*
 	 * freeze/thaw support require holding onto a super block
@@ -991,6 +994,9 @@ static struct mapped_device *alloc_dev(i
 	atomic_set(&md->holders, 1);
 	atomic_set(&md->open_count, 0);
 	atomic_set(&md->event_nr, 0);
+	atomic_set(&md->uevent_seq, 0);
+	INIT_LIST_HEAD(&md->uevent_list);
+	spin_lock_init(&md->uevent_lock);
 
 	md->queue = blk_alloc_queue(GFP_KERNEL);
 	if (!md->queue)
@@ -1087,8 +1093,16 @@ static void free_dev(struct mapped_devic
  */
 static void event_callback(void *context)
 {
+	unsigned long flags;
+	LIST_HEAD(uevents);
 	struct mapped_device *md = (struct mapped_device *) context;
 
+	spin_lock_irqsave(&md->uevent_lock, flags);
+	list_splice_init(&md->uevent_list, &uevents);
+	spin_unlock_irqrestore(&md->uevent_lock, flags);
+
+	dm_send_uevents(&uevents, &md->disk->kobj);
+
 	atomic_inc(&md->event_nr);
 	wake_up(&md->eventq);
 }
@@ -1505,6 +1519,11 @@ out:
 /*-----------------------------------------------------------------
  * Event notification.
  *---------------------------------------------------------------*/
+uint32_t dm_next_uevent_seq(struct mapped_device *md)
+{
+	return atomic_add_return(1, &md->uevent_seq);
+}
+
 uint32_t dm_get_event_nr(struct mapped_device *md)
 {
 	return atomic_read(&md->event_nr);
@@ -1516,6 +1535,15 @@ int dm_wait_event(struct mapped_device *
 			(event_nr != atomic_read(&md->event_nr)));
 }
 
+void dm_uevent_add(struct mapped_device *md, struct list_head *elist)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&md->uevent_lock, flags);
+	list_add(elist, &md->uevent_list);
+	spin_unlock_irqrestore(&md->uevent_lock, flags);
+}
+
 /*
  * The gendisk is only valid as long as you have a reference
  * count on 'md'.
Index: b/include/linux/device-mapper.h
===================================================================
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -183,6 +183,8 @@ int dm_resume(struct mapped_device *md);
  */
 uint32_t dm_get_event_nr(struct mapped_device *md);
 int dm_wait_event(struct mapped_device *md, int event_nr);
+uint32_t dm_next_uevent_seq(struct mapped_device *md);
+void dm_uevent_add(struct mapped_device *md, struct list_head *elist);
 
 /*
  * Info functions.

-- 
