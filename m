From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 5/9] dm: Rename dm_build_uevent to dm_uevent_build
Date: Mon,  3 Oct 2016 12:22:56 -0700
Message-ID: <1475522580-16723-6-git-send-email-agrover@redhat.com>
References: <1475522580-16723-1-git-send-email-agrover@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1475522580-16723-1-git-send-email-agrover@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, snitzer@redhat.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

For consistency with other function names that start with 'dm_uevent'.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 Documentation/device-mapper/dm-uevent.txt | 2 +-
 drivers/md/dm-mpath.c                     | 4 ++--
 drivers/md/dm-uevent.c                    | 4 ++--
 drivers/md/dm-uevent.h                    | 4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/device-mapper/dm-uevent.txt b/Documentation/device-mapper/dm-uevent.txt
index 0a5d909..5780e76 100644
--- a/Documentation/device-mapper/dm-uevent.txt
+++ b/Documentation/device-mapper/dm-uevent.txt
@@ -8,7 +8,7 @@ ioctl event interface is not.
 
 There are five functions DM targets should use.
 
-struct dm_uevent *dm_build_uevent(struct mapped_device *md,
+struct dm_uevent *dm_uevent_build(struct mapped_device *md,
 					 struct dm_target *ti,
 					 enum kobject_action action,
 					 const char *dm_action)
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 75fe28a..26f99d0 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1261,12 +1261,12 @@ static void dm_path_uevent(enum dm_uevent_type event_type, struct dm_target *ti,
 		return;
 	}
 
-	event = dm_build_uevent(md,
+	event = dm_uevent_build(md,
 				ti,
 				_dm_mpath_uevent_type_names[event_type].action,
 				_dm_mpath_uevent_type_names[event_type].name);
 	if (IS_ERR(event)) {
-		DMERR("%s: dm_build_uevent() failed", __func__);
+		DMERR("%s: dm_uevent_build() failed", __func__);
 		return;
 	}
 
diff --git a/drivers/md/dm-uevent.c b/drivers/md/dm-uevent.c
index f7089dd..6a72de7 100644
--- a/drivers/md/dm-uevent.c
+++ b/drivers/md/dm-uevent.c
@@ -51,7 +51,7 @@ static struct dm_uevent *dm_uevent_alloc(struct mapped_device *md)
 	return event;
 }
 
-struct dm_uevent *dm_build_uevent(struct mapped_device *md,
+struct dm_uevent *dm_uevent_build(struct mapped_device *md,
 					 struct dm_target *ti,
 					 enum kobject_action action,
 					 const char *dm_action)
@@ -92,7 +92,7 @@ err_add:
 err_nomem:
 	return ERR_PTR(-ENOMEM);
 }
-EXPORT_SYMBOL_GPL(dm_build_uevent);
+EXPORT_SYMBOL_GPL(dm_uevent_build);
 
 /**
  * dm_send_uevents - send uevents for given list
diff --git a/drivers/md/dm-uevent.h b/drivers/md/dm-uevent.h
index 4ff2ad1..4dc99c2 100644
--- a/drivers/md/dm-uevent.h
+++ b/drivers/md/dm-uevent.h
@@ -42,7 +42,7 @@ enum dm_uevent_type {
 extern int dm_uevent_init(void);
 extern void dm_uevent_exit(void);
 extern void dm_send_uevents(struct list_head *events, struct kobject *kobj);
-struct dm_uevent *dm_build_uevent(struct mapped_device *md,
+struct dm_uevent *dm_uevent_build(struct mapped_device *md,
 					 struct dm_target *ti,
 					 enum kobject_action action,
 					 const char *dm_action);
@@ -61,7 +61,7 @@ static inline void dm_send_uevents(struct list_head *events,
 				   struct kobject *kobj)
 {
 }
-static inline struct dm_uevent *dm_build_uevent(struct mapped_device *md,
+static inline struct dm_uevent *dm_uevent_build(struct mapped_device *md,
 						struct dm_target *ti,
 						enum kobject_action action,
 						const char *dm_action)
-- 
2.7.4
