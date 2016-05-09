From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/7] devmapper: do not call dm_udev_complete if
	dm_task_set_cookie() failed
Date: Mon,  9 May 2016 12:53:00 +0200
Message-ID: <1462791185-2903-3-git-send-email-hare@suse.de>
References: <1462791185-2903-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1462791185-2903-1-git-send-email-hare@suse.de>
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
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

As per Benjamin Marzinski libdevice-mapper will take care of cleaning
up the cookie for us.
So there's no need to call dm_udev_complete() if dm_task_set_cookie()
fails.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/devmapper.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 2ac62a5..8a89f46 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -232,10 +232,9 @@ dm_simplecmd (int task, const char *name, int no_flush, int need_sync, uint16_t
 #endif
 	if (udev_wait_flag &&
 	    !dm_task_set_cookie(dmt, &cookie,
-				DM_UDEV_DISABLE_LIBRARY_FALLBACK | udev_flags)) {
-		dm_udev_complete(cookie);
+				DM_UDEV_DISABLE_LIBRARY_FALLBACK | udev_flags))
 		goto out;
-	}
+
 	r = dm_task_run (dmt);
 
 	if (udev_wait_flag) {
@@ -320,10 +319,9 @@ dm_addmap (int task, const char *target, struct multipath *mpp,
 
 	if (task == DM_DEVICE_CREATE &&
 	    !dm_task_set_cookie(dmt, &cookie,
-				DM_UDEV_DISABLE_LIBRARY_FALLBACK)) {
-		dm_udev_complete(cookie);
+				DM_UDEV_DISABLE_LIBRARY_FALLBACK))
 		goto freeout;
-	}
+
 	r = dm_task_run (dmt);
 
 	if (task == DM_DEVICE_CREATE) {
-- 
2.6.6
