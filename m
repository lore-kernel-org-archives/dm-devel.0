From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v3 13/17] multipathd: handle changed wwids by
	removal and addition
Date: Sat, 30 Mar 2019 01:06:02 -0500
Message-ID: <1553925966-20958-14-git-send-email-bmarzins@redhat.com>
References: <1553925966-20958-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1553925966-20958-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

If a path's WWID changes, it's not necessarily failed. But it certainly
has to be removed from an existing map, otherwise data corruption is
imminent. Instead of keeping the path in the map, failing it, and
remembering the "changed WWID" state, this patch simply removes and
re-adds the path.

This is patch is heavily based on the previous patch of the same name
by Martin Wilck.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 28 ++++++----------------------
 1 file changed, 6 insertions(+), 22 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 7a317d9..b3571d9 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1191,7 +1191,6 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 	int ro, retval = 0, rc;
 	struct path * pp;
 	struct config *conf;
-	int disable_changed_wwids;
 	int needs_reinit = 0;
 
 	switch ((rc = change_foreign(uev->udev))) {
@@ -1209,12 +1208,6 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
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
@@ -1239,22 +1232,12 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 		if (rc != 0)
 			strcpy(pp->wwid, wwid);
 		else if (strncmp(wwid, pp->wwid, WWID_SIZE) != 0) {
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
+			condlog(0, "%s: path wwid changed from '%s' to '%s'",
+				uev->kernel, wwid, pp->wwid);
+			ev_remove_path(pp, vecs, 1);
+			needs_reinit = 1;
+			goto out;
 		} else {
-			pp->wwid_changed = 0;
 			udev_device_unref(pp->udev);
 			pp->udev = udev_device_ref(uev->udev);
 			conf = get_multipath_config();
@@ -1265,6 +1248,7 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 			pthread_cleanup_pop(1);
 		}
 
+		ro = uevent_get_disk_ro(uev);
 		if (mpp && ro >= 0) {
 			condlog(2, "%s: update path write_protect to '%d' (uevent)", uev->kernel, ro);
 
-- 
2.17.2
