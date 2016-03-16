From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 3/5] dm: Inline dm_build_path_uevent into
	dm_path_uevent
Date: Wed, 16 Mar 2016 16:27:45 -0700
Message-ID: <1458170867-429-4-git-send-email-agrover@redhat.com>
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

Since it's no longer an API boundary we can consolidate these two
functions.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/md/dm-mpath.c | 59 +++++++++++++++++++--------------------------------
 1 file changed, 22 insertions(+), 37 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index a47b5e0..98c90d3 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -977,38 +977,6 @@ static void multipath_dtr(struct dm_target *ti)
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
@@ -1029,14 +997,31 @@ static void dm_path_uevent(enum dm_uevent_type event_type, struct dm_target *ti,
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
2.5.0
