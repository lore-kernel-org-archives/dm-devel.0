From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 08/10] fix INIT_REQUESTED_UDEV code
Date: Fri, 28 Oct 2016 21:55:24 -0500
Message-ID: <1477709726-5442-9-git-send-email-bmarzins@redhat.com>
References: <1477709726-5442-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1477709726-5442-1-git-send-email-bmarzins@redhat.com>
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
List-Id: dm-devel.ids

uev_update_path was not checking pp->initialized to see if multipathd
had requested that the path be reinitialized unless the path's read-only
state had changed.  This kept the reinitialization code from running in
most cases where it was supposed to. This patch reorders the function to
move that check outside the read-only status change code block. This
does mean that uev_update_path now always grabs the vecs lock, where
before it would only be grabbed if the read-only status had changed. If
people are worried about this, I can add some code to limit this so that
uev_update_path will only grab it if there is a chance that it needs to
reinitialize the path.

Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 54 +++++++++++++++++++-----------------------------------
 1 file changed, 19 insertions(+), 35 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index f423e35..dbb4554 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -957,51 +957,35 @@ static int
 uev_update_path (struct uevent *uev, struct vectors * vecs)
 {
 	int ro, retval = 0;
+	struct path * pp;
 
 	ro = uevent_get_disk_ro(uev);
 
-	if (ro >= 0) {
-		struct path * pp;
-		struct multipath *mpp = NULL;
+	pthread_cleanup_push(cleanup_lock, &vecs->lock);
+	lock(&vecs->lock);
+	pthread_testcancel();
 
-		condlog(2, "%s: update path write_protect to '%d' (uevent)",
-			uev->kernel, ro);
-		pthread_cleanup_push(cleanup_lock, &vecs->lock);
-		lock(&vecs->lock);
-		pthread_testcancel();
-		/*
-		 * pthread_mutex_lock() and pthread_mutex_unlock()
-		 * need to be at the same indentation level, hence
-		 * this slightly convoluted codepath.
-		 */
-		pp = find_path_by_dev(vecs->pathvec, uev->kernel);
-		if (pp) {
-			if (pp->initialized == INIT_REQUESTED_UDEV) {
-				retval = 2;
-			} else {
-				mpp = pp->mpp;
-				if (mpp && mpp->wait_for_udev) {
-					mpp->wait_for_udev = 2;
-					mpp = NULL;
-					retval = 0;
-				}
-			}
-			if (mpp) {
-				retval = reload_map(vecs, mpp, 0, 1);
+	pp = find_path_by_dev(vecs->pathvec, uev->kernel);
+	if (pp) {
+		struct multipath *mpp = pp->mpp;
+
+		if (pp->initialized == INIT_REQUESTED_UDEV)
+			retval = uev_add_path(uev, vecs);
+		else if (mpp && ro >= 0) {
+			condlog(2, "%s: update path write_protect to '%d' (uevent)", uev->kernel, ro);
 
+			if (mpp->wait_for_udev)
+				mpp->wait_for_udev = 2;
+			else {
+				retval = reload_map(vecs, mpp, 0, 1);
 				condlog(2, "%s: map %s reloaded (retval %d)",
 					uev->kernel, mpp->alias, retval);
 			}
 		}
-		lock_cleanup_pop(vecs->lock);
-		if (!pp) {
-			condlog(0, "%s: spurious uevent, path not found",
-				uev->kernel);
-			return 1;
-		}
-		if (retval == 2)
-			return uev_add_path(uev, vecs);
 	}
+	lock_cleanup_pop(vecs->lock);
+	if (!pp)
+		condlog(0, "%s: spurious uevent, path not found", uev->kernel);
 
 	return retval;
 }
-- 
1.8.3.1
