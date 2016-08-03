From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 3/5] multipath-tools: remove indent from labels
Date: Wed,  3 Aug 2016 20:13:58 +0200
Message-ID: <1470248040-11789-3-git-send-email-xose.vazquez@gmail.com>
References: <1470248040-11789-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470248040-11789-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Found by checkpatch - WARNING: labels should not be indented

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 kpartx/devmapper.c       | 4 ++--
 libmultipath/devmapper.c | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
index 382f511..474d879 100644
--- a/kpartx/devmapper.c
+++ b/kpartx/devmapper.c
@@ -47,7 +47,7 @@ dm_prereq (char * str, int x, int y, int z)
 		target = (void *) target + target->next;
 	} while (last_target != target);
 
-	out:
+out:
 	dm_task_destroy(dmt);
 	return r;
 }
@@ -85,7 +85,7 @@ dm_simplecmd (int task, const char *name, int no_flush, uint16_t udev_flags) {
 	if (udev_wait_flag)
 			dm_udev_wait(cookie);
 #endif
-	out:
+out:
 	dm_task_destroy(dmt);
 	return r;
 }
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 9b2c706..5eb1713 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -243,7 +243,7 @@ dm_simplecmd (int task, const char *name, int no_flush, int need_sync, uint16_t
 
 	if (udev_wait_flag)
 			dm_udev_wait(cookie);
-	out:
+out:
 	dm_task_destroy (dmt);
 	return r;
 }
@@ -327,11 +327,11 @@ dm_addmap (int task, const char *target, struct multipath *mpp,
 
 	if (task == DM_DEVICE_CREATE)
 			dm_udev_wait(cookie);
-	freeout:
+freeout:
 	if (prefixed_uuid)
 		FREE(prefixed_uuid);
 
-	addout:
+addout:
 	dm_task_destroy (dmt);
 
 	return r;
@@ -891,7 +891,7 @@ dm_flush_maps (void)
 		names = (void *) names + next;
 	} while (next);
 
-	out:
+out:
 	dm_task_destroy (dmt);
 	return r;
 }
-- 
2.7.4
