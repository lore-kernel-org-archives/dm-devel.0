From: tang.wenjun3@zte.com.cn
Subject: [PATCH] multipathd: fix uev_update_path dead lock
Date: Tue, 8 Nov 2016 11:05:01 +0800
Message-ID: <1478574301-8432-1-git-send-email-tang.wenjun3@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: 10144149 <tang.wenjun3@zte.com.cn>, tang.junhui@zte.com.cn, zhang.kai16@zte.com.cn, dm-devel@redhat.com
List-Id: dm-devel.ids

From: 10144149 <tang.wenjun3@zte.com.cn>

Deadlock occurred in uev_add_path() when &vecs->lock would lock twice in uev_update_path()
---
 multipathd/main.c | 54 ++++++++++++++++++++++++++++++------------------------
 multipathd/main.h |  1 +
 2 files changed, 31 insertions(+), 24 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index d6f081f..e74d124 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -611,7 +611,7 @@ static int
 uev_add_path (struct uevent *uev, struct vectors * vecs)
 {
 	struct path *pp;
-	int ret = 0, i;
+	int ret = 0;
 	struct config *conf;
 
 	condlog(2, "%s: add path (uevent)", uev->kernel);
@@ -628,32 +628,11 @@ uev_add_path (struct uevent *uev, struct vectors * vecs)
 	pthread_testcancel();
 	pp = find_path_by_dev(vecs->pathvec, uev->kernel);
 	if (pp) {
-		int r;
-
 		condlog(0, "%s: spurious uevent, path already in pathvec",
 			uev->kernel);
 		if (!pp->mpp && !strlen(pp->wwid)) {
 			condlog(3, "%s: reinitialize path", uev->kernel);
-			udev_device_unref(pp->udev);
-			pp->udev = udev_device_ref(uev->udev);
-			conf = get_multipath_config();
-			r = pathinfo(pp, conf,
-				     DI_ALL | DI_BLACKLIST);
-			put_multipath_config(conf);
-			if (r == PATHINFO_OK)
-				ret = ev_add_path(pp, vecs);
-			else if (r == PATHINFO_SKIPPED) {
-				condlog(3, "%s: remove blacklisted path",
-					uev->kernel);
-				i = find_slot(vecs->pathvec, (void *)pp);
-				if (i != -1)
-					vector_del_slot(vecs->pathvec, i);
-				free_path(pp);
-			} else {
-				condlog(0, "%s: failed to reinitialize path",
-					uev->kernel);
-				ret = 1;
-			}
+			ret = ev_add_path_with_pathinfo(uev->udev, pp, vecs);
 		}
 	}
 	lock_cleanup_pop(vecs->lock);
@@ -693,6 +672,33 @@ uev_add_path (struct uevent *uev, struct vectors * vecs)
 	return ret;
 }
 
+int
+ev_add_path_with_pathinfo (struct udev_device *udevice, struct path * pp, struct vectors * vecs)
+{
+	int r;
+	int ret = 0, i;
+	struct config *conf;
+
+	udev_device_unref(pp->udev);
+	pp->udev = udev_device_ref(udevice);
+	conf = get_multipath_config();
+	r = pathinfo(pp, conf, DI_ALL | DI_BLACKLIST);
+	put_multipath_config(conf);
+	if (r == PATHINFO_OK)
+		ret = ev_add_path(pp, vecs);
+	else if (r == PATHINFO_SKIPPED) {
+		condlog(3, "%s: remove blacklisted path", pp->dev);
+		i = find_slot(vecs->pathvec, (void *)pp);
+		if (i != -1)
+			vector_del_slot(vecs->pathvec, i);
+		free_path(pp);
+	} else {
+		condlog(0, "%s: failed to reinitialize path", pp->dev);
+		ret = 1;
+	}
+	return ret;
+}
+
 /*
  * returns:
  * 0: added
@@ -995,7 +1001,7 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 		}
 
 		if (pp->initialized == INIT_REQUESTED_UDEV)
-			retval = uev_add_path(uev, vecs);
+			retval = ev_add_path_with_pathinfo(uev->udev, pp, vecs);
 		else if (mpp && ro >= 0) {
 			condlog(2, "%s: update path write_protect to '%d' (uevent)", uev->kernel, ro);
 
diff --git a/multipathd/main.h b/multipathd/main.h
index f72580d..d3cd145 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -23,6 +23,7 @@ const char * daemon_status(void);
 int need_to_delay_reconfig (struct vectors *);
 int reconfigure (struct vectors *);
 int ev_add_path (struct path *, struct vectors *);
+int ev_add_path_with_pathinfo (struct udev_device *, struct path *, struct vectors *);
 int ev_remove_path (struct path *, struct vectors *);
 int ev_add_map (char *, char *, struct vectors *);
 int ev_remove_map (char *, char *, int, struct vectors *);
-- 
2.8.1.windows.1
