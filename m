From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 6/9] multipathd: Fix miscounting active paths
Date: Fri, 22 Feb 2019 10:58:09 -0600
Message-ID: <1550854692-19873-7-git-send-email-bmarzins@redhat.com>
References: <1550854692-19873-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1550854692-19873-1-git-send-email-bmarzins@redhat.com>
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

When multipathd gets a change uevent, it calls pathinfo with DI_NOIO.
This sets the path state to the return value of path_offline(). If a
path is in the PATH_DOWN state but path_offline() returns PATH_UP, when
that path gets a change event, its state will get moved to PATH_UP
without either reinstating the path, or reloading the map.  The next
call to check_path() will move the path back to PATH_DOWN. Since
check_path() simply increments and decrements nr_active instead of
calculating it based on the actual number of active paths, nr_active
will get decremented a second time for this failed path, potentially
putting the multipath device into recovery mode.

This commit does two things to avoid this situation. It makes the
DI_NOIO flag only set pp->state in pathinfo() if DI_CHECKER is also set.
This isn't set in uev_update_path() to avoid changing the path state in
this case.  Also, to guard against pp->state getting changed in some
other code path without properly updating the map state, check_path()
now calls set_no_path_retry, which recalculates nr_active based on the
actual number of active paths, and makes sure that the queue_if_no_path
value in the features line is correct.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c | 11 ++++++-----
 multipath/main.c         |  2 +-
 multipathd/main.c        |  4 +++-
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 10bd8cd..729bcb9 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1914,11 +1914,12 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 	if (path_state == PATH_REMOVED)
 		goto blank;
 	else if (mask & DI_NOIO) {
-		/*
-		 * Avoid any IO on the device itself.
-		 * Behave like DI_CHECKER in the "path unavailable" case.
-		 */
-		pp->chkrstate = pp->state = path_state;
+		if (mask & DI_CHECKER)
+			/*
+			 * Avoid any IO on the device itself.
+			 * simply use the path_offline() return as its state
+			 */
+			pp->chkrstate = pp->state = path_state;
 		return PATHINFO_OK;
 	}
 
diff --git a/multipath/main.c b/multipath/main.c
index 5abb118..69141db 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -356,7 +356,7 @@ static int check_usable_paths(struct config *conf,
 			pp->udev = get_udev_device(pp->dev_t, DEV_DEVT);
 			if (pp->udev == NULL)
 				continue;
-			if (pathinfo(pp, conf, DI_SYSFS|DI_NOIO) != PATHINFO_OK)
+			if (pathinfo(pp, conf, DI_SYSFS|DI_NOIO|DI_CHECKER) != PATHINFO_OK)
 				continue;
 
 			if (pp->state == PATH_UP &&
diff --git a/multipathd/main.c b/multipathd/main.c
index 43830e8..678ecf8 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -392,7 +392,8 @@ static void set_no_path_retry(struct multipath *mpp)
 	default:
 		if (mpp->nr_active > 0) {
 			mpp->retry_tick = 0;
-			dm_queue_if_no_path(mpp->alias, 1);
+			if (!is_queueing)
+				dm_queue_if_no_path(mpp->alias, 1);
 		} else if (is_queueing && mpp->retry_tick == 0)
 			enter_recovery_mode(mpp);
 		break;
@@ -2072,6 +2073,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 	/* if update_multipath_strings orphaned the path, quit early */
 	if (!pp->mpp)
 		return 0;
+	set_no_path_retry(pp->mpp);
 
 	if ((newstate == PATH_UP || newstate == PATH_GHOST) &&
 			check_path_reinstate_state(pp)) {
-- 
2.17.2
