From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 1/3] multipathd: handle changed wwids by removal
	and addition
Date: Mon, 18 Mar 2019 13:12:33 +0100
Message-ID: <20190318121235.8942-2-mwilck@suse.com>
References: <20190318121235.8942-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190318121235.8942-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

If a path's WWID changes, it's not necessarily failed. But it certainly
has to be removed from an existing map, otherwise data corruption is
imminent. Instead of keeping the path in the map, failing it, and
remembering the "changed WWID" state, this patch simply removes and
re-adds the path.

If the WWID is truly different now, the path will be readded as if
it was a new path. If the WWID is zero because of a (possibly temporary)
getuid() failure, and getuid() fails in uev_add_path() again, it
will be added with INIT_MISSING_UDEV status and thus handled appropriately
by the "missing udev" logic.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 71 +++++++++++++++++++++++++----------------------
 1 file changed, 38 insertions(+), 33 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index fb520b64..bd26209d 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1184,13 +1184,22 @@ fail:
 	return 1;
 }
 
+static bool is_wwid_changed(const struct path *pp, const char *old_wwid)
+{
+	bool wwid_changed = (strncmp(old_wwid, pp->wwid, WWID_SIZE) != 0);
+
+	if (wwid_changed)
+		condlog(1, "%s: WWID changed from \"%s\" to \"%s\"",
+			pp->dev, old_wwid, pp->wwid);
+	return wwid_changed;
+}
+
 static int
 uev_update_path (struct uevent *uev, struct vectors * vecs)
 {
 	int ro, retval = 0, rc;
 	struct path * pp;
 	struct config *conf;
-	int disable_changed_wwids;
 	int needs_reinit = 0;
 
 	switch ((rc = change_foreign(uev->udev))) {
@@ -1208,12 +1217,6 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 		break;
 	}
 
-	conf = get_multipath_config();
-	disable_changed_wwids = conf->disable_changed_wwids;
-	put_multipath_config(conf);
-
-	ro = uevent_get_disk_ro(uev);
-
 	pthread_cleanup_push(cleanup_lock, &vecs->lock);
 	lock(&vecs->lock);
 	pthread_testcancel();
@@ -1221,7 +1224,7 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 	pp = find_path_by_dev(vecs->pathvec, uev->kernel);
 	if (pp) {
 		struct multipath *mpp = pp->mpp;
-		char wwid[WWID_SIZE];
+		bool wwid_changed;
 
 		if (pp->initialized == INIT_REQUESTED_UDEV) {
 			needs_reinit = 1;
@@ -1232,36 +1235,38 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 		if (!strlen(pp->wwid))
 			goto out;
 
-		strcpy(wwid, pp->wwid);
-		get_uid(pp, pp->state, uev->udev);
-
-		if (strncmp(wwid, pp->wwid, WWID_SIZE) != 0) {
-			condlog(0, "%s: path wwid changed from '%s' to '%s'. %s",
-				uev->kernel, wwid, pp->wwid,
-				(disable_changed_wwids ? "disallowing" :
-				 "continuing"));
-			strcpy(pp->wwid, wwid);
-			if (disable_changed_wwids) {
-				if (!pp->wwid_changed) {
-					pp->wwid_changed = 1;
-					pp->tick = 1;
-					if (pp->mpp)
-						dm_fail_path(pp->mpp->alias, pp->dev_t);
-				}
-				goto out;
-			}
+		if (pp->mpp) {
+			get_uid(pp, pp->state, uev->udev);
+			wwid_changed = is_wwid_changed(pp, pp->mpp->wwid);
 		} else {
-			pp->wwid_changed = 0;
+			char *old_wwid = strdup(pp->wwid);
+
+			if (!old_wwid)
+				goto out;
+			pthread_cleanup_push(free, (void*)old_wwid);
+			wwid_changed = is_wwid_changed(pp, old_wwid);
+			pthread_cleanup_pop(1);
+		}
+
+		if (wwid_changed) {
+			ev_remove_path(pp, vecs, 1);
+			needs_reinit = 1;
+			goto out;
+		}
+
+		if (pp->udev != uev->udev) {
 			udev_device_unref(pp->udev);
 			pp->udev = udev_device_ref(uev->udev);
-			conf = get_multipath_config();
-			pthread_cleanup_push(put_multipath_config, conf);
-			if (pathinfo(pp, conf, DI_SYSFS|DI_NOIO) != PATHINFO_OK)
-				condlog(1, "%s: pathinfo failed after change uevent",
-					uev->kernel);
-			pthread_cleanup_pop(1);
 		}
 
+		conf = get_multipath_config();
+		pthread_cleanup_push(put_multipath_config, conf);
+		if (pathinfo(pp, conf, DI_SYSFS|DI_NOIO) != PATHINFO_OK)
+			condlog(1, "%s: pathinfo failed after change uevent",
+				uev->kernel);
+		pthread_cleanup_pop(1);
+
+		ro = uevent_get_disk_ro(uev);
 		if (mpp && ro >= 0) {
 			condlog(2, "%s: update path write_protect to '%d' (uevent)", uev->kernel, ro);
 
-- 
2.21.0
