From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 37/57] Remove 'udev_sync' argument from
	dm_simplecmd()
Date: Wed, 27 Apr 2016 13:10:38 +0200
Message-ID: <1461755458-29225-38-git-send-email-hare@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1461755458-29225-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

The 'udev_sync' attribute is pointless without a cookie, so we
can as well use the existence of the 'cookie' argument for
the same function.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/devmapper.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index a96cc0e..12ccf1a 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -207,12 +207,10 @@ dm_prereq (void)
 #define do_deferred(x) ((x) == DEFERRED_REMOVE_ON || (x) == DEFERRED_REMOVE_IN_PROGRESS)
 
 static int
-dm_simplecmd (int task, const char *name, int no_flush, int need_sync,
+dm_simplecmd (int task, const char *name, int no_flush,
 	      uint16_t udev_flags, int deferred_remove, uint32_t *cookie)
 {
 	int r = 0;
-	int udev_wait_flag = (need_sync && (task == DM_DEVICE_RESUME ||
-					    task == DM_DEVICE_REMOVE));
 	struct dm_task *dmt;
 
 	if (!(dmt = dm_task_create (task)))
@@ -231,7 +229,7 @@ dm_simplecmd (int task, const char *name, int no_flush, int need_sync,
 	if (do_deferred(deferred_remove))
 		dm_task_deferred_remove(dmt);
 #endif
-	if (udev_wait_flag &&
+	if (cookie &&
 	    !dm_task_set_cookie(dmt, cookie,
 				DM_UDEV_DISABLE_LIBRARY_FALLBACK | udev_flags)) {
 		dm_udev_complete(*cookie);
@@ -239,7 +237,7 @@ dm_simplecmd (int task, const char *name, int no_flush, int need_sync,
 	}
 	r = dm_task_run (dmt);
 
-	if (udev_wait_flag) {
+	if (cookie) {
 		if (!r)
 			dm_udev_complete(*cookie);
 		else
@@ -254,22 +252,27 @@ extern int
 dm_simplecmd_flush (int task, const char *name, uint16_t udev_flags) {
 	uint32_t cookie = 0;
 
-	return dm_simplecmd(task, name, 0, 1, udev_flags, 0, &cookie);
+	if (task == DM_DEVICE_RESUME ||
+	    task == DM_DEVICE_REMOVE)
+		return dm_simplecmd(task, name, 0, udev_flags, 0, &cookie);
+	else
+		return dm_simplecmd(task, name, 0, udev_flags, 0, NULL);
 }
 
 extern int
 dm_simplecmd_noflush (int task, const char *name, int needsync, uint16_t udev_flags) {
 	uint32_t cookie = 0;
 
-	return dm_simplecmd(task, name, 1, needsync, udev_flags, 0, &cookie);
+	return dm_simplecmd(task, name, 1, udev_flags, 0,
+			    needsync ? &cookie : NULL);
 }
 
 static int
 dm_device_remove (const char *name, int needsync, int deferred_remove) {
 	uint32_t cookie = 0;
 
-	return dm_simplecmd(DM_DEVICE_REMOVE, name, 0, needsync, 0,
-			    deferred_remove, &cookie);
+	return dm_simplecmd(DM_DEVICE_REMOVE, name, 0, 0,
+			    deferred_remove, needsync ? &cookie : NULL);
 }
 
 extern int
-- 
2.6.6
