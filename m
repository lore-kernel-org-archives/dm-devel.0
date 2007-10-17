From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.24 PATCH 03/04] dm: uevent generate events
Date: Wed, 17 Oct 2007 13:54:53 +0100
Message-ID: <20071017125452.GO24157@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, Mike Anderson <andmike@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Mike Anderson <andmike@linux.vnet.ibm.com>

This patch adds support for the dm_path_event dm_send_event functions which
create and send udev events.

Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---

 Documentation/device-mapper/dm-uevent.txt |   97 +++++++++++++++++++
 drivers/md/dm-uevent.c                    |  150 ++++++++++++++++++++++++++++++
 drivers/md/dm-uevent.h                    |   18 +++
 drivers/md/dm.c                           |   28 +++++
 include/linux/device-mapper.h             |    2 
 5 files changed, 295 insertions(+)

Index: linux-2.6.23/Documentation/device-mapper/dm-uevent.txt
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.23/Documentation/device-mapper/dm-uevent.txt	2007-10-17 11:56:44.000000000 +0100
@@ -0,0 +1,97 @@
+The device-mapper uevent code adds the capability to device-mapper to create
+and send kobject uevents (uevents).  Previously device-mapper events were only
+available through the ioctl interface.  The advantage of the uevents interface
+is the event contains environment attributes providing increased context for
+the event avoiding the need to query the state of the device-mapper device after
+the event is received.
+
+There are two functions currently for device-mapper events.  The first function
+listed creates the event and the second function sends the event(s).
+
+void dm_path_uevent(enum dm_uevent_type event_type, struct dm_target *ti,
+                    const char *path, unsigned nr_valid_paths)
+
+void dm_send_uevents(struct list_head *events, struct kobject *kobj)
+
+
+The variables added to the uevent environment are:
+
+Variable Name: DM_TARGET
+Uevent Action(s): KOBJ_CHANGE
+Type: string
+Description:
+Value: Name of device-mapper target that generated the event.
+
+Variable Name: DM_ACTION
+Uevent Action(s): KOBJ_CHANGE
+Type: string
+Description:
+Value: Device-mapper specific action that caused the uevent action.
+	PATH_FAILED - A path has failed.
+	PATH_REINSTATED - A path has been reinstated.
+
+Variable Name: DM_SEQNUM
+Uevent Action(s): KOBJ_CHANGE
+Type: unsigned integer
+Description: A sequence number for this specific device-mapper device.
+Value: Valid unsigned integer range.
+
+Variable Name: DM_PATH
+Uevent Action(s): KOBJ_CHANGE
+Type: string
+Description: Major and minor number of the path device pertaining to this
+event.
+Value: Path name in the form of "Major:Minor"
+
+Variable Name: DM_NR_VALID_PATHS
+Uevent Action(s): KOBJ_CHANGE
+Type: unsigned integer
+Description:
+Value: Valid unsigned integer range.
+
+Variable Name: DM_NAME
+Uevent Action(s): KOBJ_CHANGE
+Type: string
+Description: Name of the device-mapper device.
+Value: Name
+
+Variable Name: DM_UUID
+Uevent Action(s): KOBJ_CHANGE
+Type: string
+Description: UUID of the device-mapper device.
+Value: UUID. (Empty string if there isn't one.)
+
+An example of the uevents generated as captured by udevmonitor is shown
+below.
+
+1.) Path failure.
+UEVENT[1192521009.711215] change@/block/dm-3
+ACTION=change
+DEVPATH=/block/dm-3
+SUBSYSTEM=block
+DM_TARGET=multipath
+DM_ACTION=PATH_FAILED
+DM_SEQNUM=1
+DM_PATH=8:32
+DM_NR_VALID_PATHS=0
+DM_NAME=mpath2
+DM_UUID=mpath-35333333000002328
+MINOR=3
+MAJOR=253
+SEQNUM=1130
+
+2.) Path reinstate.
+UEVENT[1192521132.989927] change@/block/dm-3
+ACTION=change
+DEVPATH=/block/dm-3
+SUBSYSTEM=block
+DM_TARGET=multipath
+DM_ACTION=PATH_REINSTATED
+DM_SEQNUM=2
+DM_PATH=8:32
+DM_NR_VALID_PATHS=1
+DM_NAME=mpath2
+DM_UUID=mpath-35333333000002328
+MINOR=3
+MAJOR=253
+SEQNUM=1131
Index: linux-2.6.23/drivers/md/dm-uevent.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-uevent.c	2007-10-17 11:56:43.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-uevent.c	2007-10-17 12:23:00.000000000 +0100
@@ -21,12 +21,22 @@
 #include <linux/list.h>
 #include <linux/slab.h>
 #include <linux/kobject.h>
+#include <linux/dm-ioctl.h>
 
 #include "dm.h"
 #include "dm-uevent.h"
 
 #define DM_MSG_PREFIX "uevent"
 
+static const struct {
+	enum dm_uevent_type type;
+	enum kobject_action action;
+	char *name;
+} _dm_uevent_type_names[] = {
+	{DM_UEVENT_PATH_FAILED, KOBJ_CHANGE, "PATH_FAILED"},
+	{DM_UEVENT_PATH_REINSTATED, KOBJ_CHANGE, "PATH_REINSTATED"},
+};
+
 static struct kmem_cache *_dm_event_cache;
 
 struct dm_uevent {
@@ -34,6 +44,8 @@ struct dm_uevent {
 	enum kobject_action action;
 	struct kobj_uevent_env ku_env;
 	struct list_head elist;
+	char name[DM_NAME_LEN];
+	char uuid[DM_UUID_LEN];
 };
 
 static void dm_uevent_free(struct dm_uevent *event)
@@ -55,6 +67,144 @@ static struct dm_uevent *dm_uevent_alloc
 	return event;
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
+	event = dm_uevent_alloc(md);
+	if (!event) {
+		DMERR("%s: dm_uevent_alloc() failed", __FUNCTION__);
+		goto err_nomem;
+	}
+
+	event->action = action;
+
+	if (add_uevent_var(&event->ku_env, "DM_TARGET=%s", ti->type->name)) {
+		DMERR("%s: add_uevent_var() for DM_TARGET failed",
+		      __FUNCTION__);
+		goto err_add;
+	}
+
+	if (add_uevent_var(&event->ku_env, "DM_ACTION=%s", dm_action)) {
+		DMERR("%s: add_uevent_var() for DM_ACTION failed",
+		      __FUNCTION__);
+		goto err_add;
+	}
+
+	if (add_uevent_var(&event->ku_env, "DM_SEQNUM=%u",
+			   dm_next_uevent_seq(md))) {
+		DMERR("%s: add_uevent_var() for DM_SEQNUM failed",
+		      __FUNCTION__);
+		goto err_add;
+	}
+
+	if (add_uevent_var(&event->ku_env, "DM_PATH=%s", path)) {
+		DMERR("%s: add_uevent_var() for DM_PATH failed", __FUNCTION__);
+		goto err_add;
+	}
+
+	if (add_uevent_var(&event->ku_env, "DM_NR_VALID_PATHS=%d",
+			   nr_valid_paths)) {
+		DMERR("%s: add_uevent_var() for DM_NR_VALID_PATHS failed",
+		      __FUNCTION__);
+		goto err_add;
+	}
+
+	return event;
+
+err_add:
+	dm_uevent_free(event);
+err_nomem:
+	return ERR_PTR(-ENOMEM);
+}
+
+/**
+ * dm_send_uevents - send uevents for given list
+ *
+ * @events:	list of events to send
+ * @kobj:	kobject generating event
+ *
+ */
+void dm_send_uevents(struct list_head *events, struct kobject *kobj)
+{
+	int r;
+	struct dm_uevent *event, *next;
+
+	list_for_each_entry_safe(event, next, events, elist) {
+		list_del_init(&event->elist);
+
+		/*
+		 * Need to call dm_copy_name_and_uuid from here for now.
+		 * Context of previous var adds and locking used for
+		 * hash_cell not compatable.
+		 */
+		if (dm_copy_name_and_uuid(event->md, event->name,
+					  event->uuid)) {
+			DMERR("%s: dm_copy_name_and_uuid() failed",
+			      __FUNCTION__);
+			goto uevent_free;
+		}
+
+		if (add_uevent_var(&event->ku_env, "DM_NAME=%s", event->name)) {
+			DMERR("%s: add_uevent_var() for DM_NAME failed",
+			      __FUNCTION__);
+			goto uevent_free;
+		}
+
+		if (add_uevent_var(&event->ku_env, "DM_UUID=%s", event->uuid)) {
+			DMERR("%s: add_uevent_var() for DM_UUID failed",
+			      __FUNCTION__);
+			goto uevent_free;
+		}
+
+		r = kobject_uevent_env(kobj, event->action, event->ku_env.envp);
+		if (r)
+			DMERR("%s: kobject_uevent_env failed", __FUNCTION__);
+uevent_free:
+		dm_uevent_free(event);
+	}
+}
+EXPORT_SYMBOL_GPL(dm_send_uevents);
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
+void dm_path_uevent(enum dm_uevent_type event_type, struct dm_target *ti,
+		   const char *path, unsigned nr_valid_paths)
+{
+	struct mapped_device *md = dm_table_get_md(ti->table);
+	struct dm_uevent *event;
+
+	if (event_type >= ARRAY_SIZE(_dm_uevent_type_names)) {
+		DMERR("%s: Invalid event_type %d", __FUNCTION__, event_type);
+		goto out;
+	}
+
+	event = dm_build_path_uevent(md, ti,
+				     _dm_uevent_type_names[event_type].action,
+				     _dm_uevent_type_names[event_type].name,
+				     path, nr_valid_paths);
+	if (IS_ERR(event))
+		goto out;
+
+	dm_uevent_add(md, &event->elist);
+
+out:
+	dm_put(md);
+}
+EXPORT_SYMBOL_GPL(dm_path_uevent);
+
 int dm_uevent_init(void)
 {
 	_dm_event_cache = KMEM_CACHE(dm_uevent, 0);
Index: linux-2.6.23/drivers/md/dm-uevent.h
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-uevent.h	2007-10-17 11:56:43.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-uevent.h	2007-10-17 11:56:44.000000000 +0100
@@ -21,10 +21,19 @@
 #ifndef DM_UEVENT_H
 #define DM_UEVENT_H
 
+enum dm_uevent_type {
+	DM_UEVENT_PATH_FAILED,
+	DM_UEVENT_PATH_REINSTATED,
+};
+
 #ifdef CONFIG_DM_UEVENT
 
 extern int dm_uevent_init(void);
 extern void dm_uevent_exit(void);
+extern void dm_send_uevents(struct list_head *events, struct kobject *kobj);
+extern void dm_path_uevent(enum dm_uevent_type event_type,
+			   struct dm_target *ti, const char *path,
+			   unsigned nr_valid_paths);
 
 #else
 
@@ -35,6 +44,15 @@ static inline int dm_uevent_init(void)
 static inline void dm_uevent_exit(void)
 {
 }
+static inline void dm_send_uevents(struct list_head *events,
+				   struct kobject *kobj)
+{
+}
+static inline void dm_path_uevent(enum dm_uevent_type event_type,
+				  struct dm_target *ti, const char *path,
+				  unsigned nr_valid_paths)
+{
+}
 
 #endif	/* CONFIG_DM_UEVENT */
 
Index: linux-2.6.23/drivers/md/dm.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm.c	2007-10-17 11:56:43.000000000 +0100
+++ linux-2.6.23/drivers/md/dm.c	2007-10-17 11:56:44.000000000 +0100
@@ -113,6 +113,9 @@ struct mapped_device {
 	 */
 	atomic_t event_nr;
 	wait_queue_head_t eventq;
+	atomic_t uevent_seq;
+	struct list_head uevent_list;
+	spinlock_t uevent_lock; /* Protect access to uevent_list */
 
 	/*
 	 * freeze/thaw support require holding onto a super block
@@ -985,6 +988,9 @@ static struct mapped_device *alloc_dev(i
 	atomic_set(&md->holders, 1);
 	atomic_set(&md->open_count, 0);
 	atomic_set(&md->event_nr, 0);
+	atomic_set(&md->uevent_seq, 0);
+	INIT_LIST_HEAD(&md->uevent_list);
+	spin_lock_init(&md->uevent_lock);
 
 	md->queue = blk_alloc_queue(GFP_KERNEL);
 	if (!md->queue)
@@ -1083,8 +1089,16 @@ static void free_dev(struct mapped_devic
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
@@ -1502,6 +1516,11 @@ out:
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
@@ -1513,6 +1532,15 @@ int dm_wait_event(struct mapped_device *
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
Index: linux-2.6.23/include/linux/device-mapper.h
===================================================================
--- linux-2.6.23.orig/include/linux/device-mapper.h	2007-10-17 11:56:43.000000000 +0100
+++ linux-2.6.23/include/linux/device-mapper.h	2007-10-17 11:56:44.000000000 +0100
@@ -183,6 +183,8 @@ int dm_resume(struct mapped_device *md);
  */
 uint32_t dm_get_event_nr(struct mapped_device *md);
 int dm_wait_event(struct mapped_device *md, int event_nr);
+uint32_t dm_next_uevent_seq(struct mapped_device *md);
+void dm_uevent_add(struct mapped_device *md, struct list_head *elist);
 
 /*
  * Info functions.
