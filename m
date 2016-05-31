From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 2/7] libmultipath: remove calls to
	dm_udev_complete
Date: Tue, 31 May 2016 18:16:45 -0500
Message-ID: <1464736610-20027-3-git-send-email-bmarzins@redhat.com>
References: <1464736610-20027-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1464736610-20027-1-git-send-email-bmarzins@redhat.com>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

There were two places where the code was calling dm_udev_complete, when
dm_task_set_cookie() failed and when a subsequent call dm_task_run()
failed.  It is correct in neither of these cases.  If
dm_task_set_cookie() fails, device mapper will zero out the cookie
before returning, so there is nothing to complete. If it succeeds and
there is a cookie, something has to wait on it, or it will hang around
in the system forever. dm_udev_complete() will not wait on the cookie or
clean it up. Its job is to signal to the waiters that they are done
waiting.  This is called for us when dm_task_run() fails, so calling
dm_udev_wait() then will not block but immediately clean up the cookie.

This patch simply removes all of the dm_udev_complete() calls.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 kpartx/devmapper.c       | 20 ++++----------------
 libmultipath/devmapper.c | 17 +++--------------
 2 files changed, 7 insertions(+), 30 deletions(-)

diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
index e006bc3..c5ba39d 100644
--- a/kpartx/devmapper.c
+++ b/kpartx/devmapper.c
@@ -77,19 +77,13 @@ dm_simplecmd (int task, const char *name, int no_flush, uint16_t udev_flags) {
 #ifdef LIBDM_API_COOKIE
 	if (!udev_sync)
 		udev_flags |= DM_UDEV_DISABLE_LIBRARY_FALLBACK;
-	if (udev_wait_flag && !dm_task_set_cookie(dmt, &cookie, udev_flags)) {
-		dm_udev_complete(cookie);
+	if (udev_wait_flag && !dm_task_set_cookie(dmt, &cookie, udev_flags))
 		goto out;
-	}
 #endif
 	r = dm_task_run(dmt);
 #ifdef LIBDM_API_COOKIE
-	if (udev_wait_flag) {
-		if (!r)
-			dm_udev_complete(cookie);
-		else
+	if (udev_wait_flag)
 			dm_udev_wait(cookie);
-	}
 #endif
 	out:
 	dm_task_destroy(dmt);
@@ -145,19 +139,13 @@ dm_addmap (int task, const char *name, const char *target,
 	if (!udev_sync)
 		udev_flags = DM_UDEV_DISABLE_LIBRARY_FALLBACK;
 	if (task == DM_DEVICE_CREATE &&
-	    !dm_task_set_cookie(dmt, &cookie, udev_flags)) {
-		dm_udev_complete(cookie);
+	    !dm_task_set_cookie(dmt, &cookie, udev_flags))
 		goto addout;
-	}
 #endif
 	r = dm_task_run (dmt);
 #ifdef LIBDM_API_COOKIE
-	if (task == DM_DEVICE_CREATE) {
-		if (!r)
-			dm_udev_complete(cookie);
-		else
+	if (task == DM_DEVICE_CREATE)
 			dm_udev_wait(cookie);
-	}
 #endif
 addout:
 	dm_task_destroy (dmt);
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 6d1a5d6..ce884e2 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -237,12 +237,8 @@ dm_simplecmd (int task, const char *name, int no_flush, int need_sync, uint16_t
 
 	r = dm_task_run (dmt);
 
-	if (udev_wait_flag) {
-		if (!r)
-			dm_udev_complete(cookie);
-		else
+	if (udev_wait_flag)
 			dm_udev_wait(cookie);
-	}
 	out:
 	dm_task_destroy (dmt);
 	return r;
@@ -325,12 +321,8 @@ dm_addmap (int task, const char *target, struct multipath *mpp,
 
 	r = dm_task_run (dmt);
 
-	if (task == DM_DEVICE_CREATE) {
-		if (!r)
-			dm_udev_complete(cookie);
-		else
+	if (task == DM_DEVICE_CREATE)
 			dm_udev_wait(cookie);
-	}
 	freeout:
 	if (prefixed_uuid)
 		FREE(prefixed_uuid);
@@ -1431,10 +1423,7 @@ dm_rename (const char * old, char * new)
 		goto out;
 	r = dm_task_run(dmt);
 
-	if (!r)
-		dm_udev_complete(cookie);
-	else
-		dm_udev_wait(cookie);
+	dm_udev_wait(cookie);
 
 out:
 	dm_task_destroy(dmt);
-- 
1.8.3.1
