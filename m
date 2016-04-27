From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 34/57] Always set DM_UDEV_DISABLE_LIBRARY_FALLBACK
Date: Wed, 27 Apr 2016 13:10:35 +0200
Message-ID: <1461755458-29225-35-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

The 'DM_UDEV_DISABLE_LIBRARY_FALLBACK' should be set always,
as with modern installations udev is responsible for maintaining
the '/dev/mapper' directory.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/devmapper.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index c7d4b49..2fedf51 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -230,7 +230,9 @@ dm_simplecmd (int task, const char *name, int no_flush, int need_sync, uint16_t
 	if (do_deferred(deferred_remove))
 		dm_task_deferred_remove(dmt);
 #endif
-	if (udev_wait_flag && !dm_task_set_cookie(dmt, &cookie, ((conf->daemon)? DM_UDEV_DISABLE_LIBRARY_FALLBACK : 0) | udev_flags)) {
+	if (udev_wait_flag &&
+	    !dm_task_set_cookie(dmt, &cookie,
+				DM_UDEV_DISABLE_LIBRARY_FALLBACK | udev_flags)) {
 		dm_udev_complete(cookie);
 		goto out;
 	}
@@ -310,7 +312,8 @@ dm_addmap (int task, const char *target, struct multipath *mpp,
 	dm_task_no_open_count(dmt);
 
 	if (task == DM_DEVICE_CREATE &&
-	    !dm_task_set_cookie(dmt, &cookie, (conf->daemon)? DM_UDEV_DISABLE_LIBRARY_FALLBACK : 0)) {
+	    !dm_task_set_cookie(dmt, &cookie,
+				DM_UDEV_DISABLE_LIBRARY_FALLBACK)) {
 		dm_udev_complete(cookie);
 		goto freeout;
 	}
@@ -1401,7 +1404,8 @@ dm_rename (const char * old, char * new)
 
 	dm_task_no_open_count(dmt);
 
-	if (!dm_task_set_cookie(dmt, &cookie, (conf->daemon)? DM_UDEV_DISABLE_LIBRARY_FALLBACK : 0))
+	if (!dm_task_set_cookie(dmt, &cookie,
+				DM_UDEV_DISABLE_LIBRARY_FALLBACK))
 		goto out;
 	r = dm_task_run(dmt);
 
-- 
2.6.6
