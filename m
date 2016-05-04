From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/6] libmultipath: pass in cookie as argument for
	dm_simplecmd()
Date: Wed,  4 May 2016 07:57:25 +0200
Message-ID: <1462341450-5507-2-git-send-email-hare@suse.de>
References: <1462341450-5507-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1462341450-5507-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Instead of generating the cookie internally we should be passing
it in as an argument; that will allow for cookie reuse.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/devmapper.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index fb202e8..48e7d50 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -207,11 +207,12 @@ dm_prereq (void)
 #define do_deferred(x) ((x) == DEFERRED_REMOVE_ON || (x) == DEFERRED_REMOVE_IN_PROGRESS)
 
 static int
-dm_simplecmd (int task, const char *name, int no_flush, int need_sync, uint16_t udev_flags, int deferred_remove) {
+dm_simplecmd (int task, const char *name, int no_flush, int need_sync,
+	      uint16_t udev_flags, int deferred_remove, uint32_t *cookie)
+{
 	int r = 0;
 	int udev_wait_flag = (need_sync && (task == DM_DEVICE_RESUME ||
 					    task == DM_DEVICE_REMOVE));
-	uint32_t cookie = 0;
 	struct dm_task *dmt;
 
 	if (!(dmt = dm_task_create (task)))
@@ -231,18 +232,18 @@ dm_simplecmd (int task, const char *name, int no_flush, int need_sync, uint16_t
 		dm_task_deferred_remove(dmt);
 #endif
 	if (udev_wait_flag &&
-	    !dm_task_set_cookie(dmt, &cookie,
+	    !dm_task_set_cookie(dmt, cookie,
 				DM_UDEV_DISABLE_LIBRARY_FALLBACK | udev_flags)) {
-		dm_udev_complete(cookie);
+		dm_udev_complete(*cookie);
 		goto out;
 	}
 	r = dm_task_run (dmt);
 
 	if (udev_wait_flag) {
 		if (!r)
-			dm_udev_complete(cookie);
+			dm_udev_complete(*cookie);
 		else
-			dm_udev_wait(cookie);
+			dm_udev_wait(*cookie);
 	}
 	out:
 	dm_task_destroy (dmt);
@@ -251,18 +252,24 @@ dm_simplecmd (int task, const char *name, int no_flush, int need_sync, uint16_t
 
 extern int
 dm_simplecmd_flush (int task, const char *name, uint16_t udev_flags) {
-	return dm_simplecmd(task, name, 0, 1, udev_flags, 0);
+	uint32_t cookie = 0;
+
+	return dm_simplecmd(task, name, 0, 1, udev_flags, 0, &cookie);
 }
 
 extern int
 dm_simplecmd_noflush (int task, const char *name, int needsync, uint16_t udev_flags) {
-	return dm_simplecmd(task, name, 1, needsync, udev_flags, 0);
+	uint32_t cookie = 0;
+
+	return dm_simplecmd(task, name, 1, needsync, udev_flags, 0, &cookie);
 }
 
 static int
 dm_device_remove (const char *name, int needsync, int deferred_remove) {
+	uint32_t cookie = 0;
+
 	return dm_simplecmd(DM_DEVICE_REMOVE, name, 0, needsync, 0,
-			    deferred_remove);
+			    deferred_remove, &cookie);
 }
 
 static int
-- 
2.6.6
