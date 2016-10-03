From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 7/9] dm: Implement dm_uevent_add()
Date: Mon,  3 Oct 2016 12:22:58 -0700
Message-ID: <1475522580-16723-8-git-send-email-agrover@redhat.com>
References: <1475522580-16723-1-git-send-email-agrover@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1475522580-16723-1-git-send-email-agrover@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, snitzer@redhat.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

This helper function builds and enqueues the uevent. Targets can use this
when they do not need to customize the uevent beyond its name.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 Documentation/device-mapper/dm-uevent.txt |  5 +++++
 drivers/md/dm-uevent.c                    | 26 ++++++++++++++++++++++++++
 include/linux/device-mapper.h             |  1 +
 3 files changed, 32 insertions(+)

diff --git a/Documentation/device-mapper/dm-uevent.txt b/Documentation/device-mapper/dm-uevent.txt
index 4fcb71d..097e7f4 100644
--- a/Documentation/device-mapper/dm-uevent.txt
+++ b/Documentation/device-mapper/dm-uevent.txt
@@ -30,6 +30,11 @@ void dm_uevent_free(struct dm_uevent *event)
 
 Something went wrong, free the uevent instead of queueing it.
 
+void dm_uevent_add(struct dm_target *ti, enum kobject_action action, char *name)
+
+Helper function that builds and queues a uevent if no additional
+variables need to be added.
+
 void dm_table_event(struct dm_table *t)
 
 Triggers sending of queued uevents as well as waking up processes waiting on
diff --git a/drivers/md/dm-uevent.c b/drivers/md/dm-uevent.c
index 6a72de7..d139135 100644
--- a/drivers/md/dm-uevent.c
+++ b/drivers/md/dm-uevent.c
@@ -95,6 +95,32 @@ err_nomem:
 EXPORT_SYMBOL_GPL(dm_uevent_build);
 
 /**
+ * dm_uevent_add - Create and queue a basic uevent
+ *
+ * @ti:		The target to add a uevent for
+ * @action:	The kobject action
+ * @name:	The name of the uevent to add and queue
+ *
+ * If targets wish to create and queue a uevent but don't need to add
+ * extra vars, they can do so more easily by calling this.
+ * This is usually followed by a call to dm_table_event().
+ */
+void dm_uevent_add(struct dm_target *ti, enum kobject_action action, char *name)
+{
+	struct mapped_device *md = dm_table_get_md(ti->table);
+	struct dm_uevent *event;
+
+	event = dm_uevent_build(md, ti, action, name);
+	if (IS_ERR(event)) {
+		DMERR("%s: dm_uevent_build() failed", __func__);
+		return;
+	}
+
+	dm_uevent_queue(md, &event->elist);
+}
+EXPORT_SYMBOL_GPL(dm_uevent_add);
+
+/**
  * dm_send_uevents - send uevents for given list
  *
  * @events:	list of events to send
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 024207c..c102e29 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -420,6 +420,7 @@ uint32_t dm_get_event_nr(struct mapped_device *md);
 int dm_wait_event(struct mapped_device *md, int event_nr);
 uint32_t dm_next_uevent_seq(struct mapped_device *md);
 void dm_uevent_queue(struct mapped_device *md, struct list_head *elist);
+void dm_uevent_add(struct dm_target *ti, enum kobject_action action, char *name);
 
 /*
  * Info functions.
-- 
2.7.4
