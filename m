From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v4 19/19] libmultipath: Fixup updating paths
Date: Tue,  9 Oct 2018 18:03:16 -0500
Message-ID: <1539126196-28926-20-git-send-email-bmarzins@redhat.com>
References: <1539126196-28926-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1539126196-28926-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Martin Wilck <mwilck@suse.de>
List-Id: dm-devel.ids

Commit 582c56cc broke some code paths in uev_update_path. First, it
changed the handling of paths that were not fully initialized.
uev_update_path was simply setting the wwids for all of these paths.
Instead, it should ignore the ones that had not requested a new uevent.
These paths are likely down, and are already getting handled by
check_path, after it verifies that they have become active. Also,
setting the wwid doesn't update all of the other information that
may have been missed when the path was initially added.

Also, it wasn't possible for pp->wwid_changed to transition back to
zero, unless the path's wwid was empty, in which case there was no
reason to worry about the wwid change in the first place, since the path
hadn't been fully initialized yet. So, even if a path's wwid changed and
then changed back to the original value, the path still could not be
used.

This patch fixes these issues, and also moves the check for paths that
have requested a new uevent up in the functions. These paths will get
fully reinitialized anyway, so there is no reason to do all the other
work first.

Fixes: 582c56cc ("libmultipath: uev_update_path: always warn if WWID
changed")

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 04dce04..af33239 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1208,6 +1208,15 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 		struct multipath *mpp = pp->mpp;
 		char wwid[WWID_SIZE];
 
+		if (pp->initialized == INIT_REQUESTED_UDEV) {
+			needs_reinit = 1;
+			goto out;
+		}
+		/* Don't deal with other types of failed initialization
+		 * now. check_path will handle it */
+		if (!strlen(pp->wwid))
+			goto out;
+
 		strcpy(wwid, pp->wwid);
 		get_uid(pp, pp->state, uev->udev);
 
@@ -1216,9 +1225,8 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 				uev->kernel, wwid, pp->wwid,
 				(disable_changed_wwids ? "disallowing" :
 				 "continuing"));
-			if (disable_changed_wwids &&
-			    (strlen(wwid) || pp->wwid_changed)) {
-				strcpy(pp->wwid, wwid);
+			strcpy(pp->wwid, wwid);
+			if (disable_changed_wwids) {
 				if (!pp->wwid_changed) {
 					pp->wwid_changed = 1;
 					pp->tick = 1;
@@ -1226,11 +1234,9 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 						dm_fail_path(pp->mpp->alias, pp->dev_t);
 				}
 				goto out;
-			} else if (!disable_changed_wwids)
-				strcpy(pp->wwid, wwid);
-			else
-				pp->wwid_changed = 0;
+			}
 		} else {
+			pp->wwid_changed = 0;
 			udev_device_unref(pp->udev);
 			pp->udev = udev_device_ref(uev->udev);
 			conf = get_multipath_config();
@@ -1241,9 +1247,7 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 			pthread_cleanup_pop(1);
 		}
 
-		if (pp->initialized == INIT_REQUESTED_UDEV)
-			needs_reinit = 1;
-		else if (mpp && ro >= 0) {
+		if (mpp && ro >= 0) {
 			condlog(2, "%s: update path write_protect to '%d' (uevent)", uev->kernel, ro);
 
 			if (mpp->wait_for_udev)
-- 
2.7.4
