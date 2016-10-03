From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 3/9] dm: Inline dm_build_path_uevent into dm_path_uevent
Date: Mon,  3 Oct 2016 12:22:54 -0700
Message-ID: <1475522580-16723-4-git-send-email-agrover@redhat.com>
References: <1475522580-16723-1-git-send-email-agrover@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1475522580-16723-1-git-send-email-agrover@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, snitzer@redhat.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Since it's no longer an API boundary we can consolidate these two
functions.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/md/dm-mpath.c | 59 +++++++++++++++++++--------------------------------
 1 file changed, 22 insertions(+), 37 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index c563b6d..75fe28a 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1241,38 +1241,6 @@ static void multipath_dtr(struct dm_target *ti)
 	free_multipath(m);
 }
 
-static struct dm_uevent *dm_build_path_uevent(struct mapped_device *md,
-					      struct dm_target *ti,
-					      enum kobject_action action,
-					      const char *dm_action,
-					      const char *path,
-					      unsigned nr_valid_paths)
-{
-	struct dm_uevent *event;
-
-	event = dm_build_uevent(md, ti, action, dm_action);
-	if (IS_ERR(event))
-		return event;
-
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
-	return event;
-
-err_add:
-	dm_uevent_free(event);
-	return ERR_PTR(-ENOMEM);
-}
-
 /**
  * dm_path_uevent - called to create a new path event and queue it
  *
@@ -1293,14 +1261,31 @@ static void dm_path_uevent(enum dm_uevent_type event_type, struct dm_target *ti,
 		return;
 	}
 
-	event = dm_build_path_uevent(md, ti,
-				     _dm_mpath_uevent_type_names[event_type].action,
-				     _dm_mpath_uevent_type_names[event_type].name,
-				     path, nr_valid_paths);
-	if (IS_ERR(event))
+	event = dm_build_uevent(md,
+				ti,
+				_dm_mpath_uevent_type_names[event_type].action,
+				_dm_mpath_uevent_type_names[event_type].name);
+	if (IS_ERR(event)) {
+		DMERR("%s: dm_build_uevent() failed", __func__);
 		return;
+	}
+
+	if (add_uevent_var(&event->ku_env, "DM_PATH=%s", path)) {
+		DMERR("%s: add_uevent_var() for DM_PATH failed", __func__);
+		goto err;
+	}
+
+	if (add_uevent_var(&event->ku_env, "DM_NR_VALID_PATHS=%d",
+			   nr_valid_paths)) {
+		DMERR("%s: add_uevent_var() for DM_NR_VALID_PATHS failed",
+		      __func__);
+		goto err;
+	}
 
 	dm_uevent_add(md, &event->elist);
+	return;
+err:
+	dm_uevent_free(event);
 }
 
 /*
-- 
2.7.4
