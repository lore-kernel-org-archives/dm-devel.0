From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 04/16] Add global udev reference pointer to config
Date: Mon, 30 Apr 2012 12:25:56 +0200
Message-ID: <1335781568-13299-6-git-send-email-hare@suse.de>
References: <1335781568-13299-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1335781568-13299-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com, Kay Sievers <kay.sievers@vrfy.org>
List-Id: dm-devel.ids

Instead of using a local reference to udev we should be moving it
to the global config structure.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/config.c |    5 +++++
 libmultipath/config.h |    1 +
 libmultipath/uevent.c |   12 +++---------
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index f99465a..75eab38 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -5,6 +5,7 @@
  */
 #include <stdio.h>
 #include <string.h>
+#include <libudev.h>
 
 #include "checkers.h"
 #include "memory.h"
@@ -427,6 +428,9 @@ free_config (struct config * conf)
 	if (conf->dev)
 		FREE(conf->dev);
 
+	if (conf->udev)
+		udev_unref(conf->udev);
+
 	if (conf->udev_dir)
 		FREE(conf->udev_dir);
 
@@ -491,6 +495,7 @@ load_config (char * file)
 	if (!conf->verbosity)
 		conf->verbosity = DEFAULT_VERBOSITY;
 
+	conf->udev = udev_new();
 	conf->dmrq = dm_drv_get_rq();
 	conf->dev_type = DEV_NONE;
 	conf->minio = DEFAULT_MINIO;
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 6fcd45e..147eedf 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -109,6 +109,7 @@ struct config {
 	int reassign_maps;
 
 	char * dev;
+	struct udev * udev;
 	char * sysfs_dir;
 	char * udev_dir;
 	char * multipath_dir;
diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 3e4c4ec..4e31d4f 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -46,6 +46,8 @@
 #include "debug.h"
 #include "list.h"
 #include "uevent.h"
+#include "vector.h"
+#include "config.h"
 
 typedef int (uev_trigger)(struct uevent *, void * trigger_data);
 
@@ -375,7 +377,6 @@ exit:
 int uevent_listen(void)
 {
 	int err;
-	struct udev *udev = NULL;
 	struct udev_monitor *monitor = NULL;
 	int fd, socket_flags;
 	int need_failback = 1;
@@ -391,12 +392,7 @@ int uevent_listen(void)
 	pthread_cond_init(uev_condp, NULL);
 	pthread_cleanup_push(uevq_stop, NULL);
 
-	udev = udev_new();
-	if (!udev) {
-		condlog(2, "failed to create udev context");
-		goto out;
-	}
-	monitor = udev_monitor_new_from_netlink(udev, "udev");
+	monitor = udev_monitor_new_from_netlink(conf->udev, "udev");
 	if (!monitor) {
 		condlog(2, "failed to create udev monitor");
 		goto out;
@@ -500,8 +496,6 @@ int uevent_listen(void)
 out:
 	if (monitor)
 		udev_monitor_unref(monitor);
-	if (udev)
-		udev_unref(udev);
 	if (need_failback)
 		err = failback_listen();
 	pthread_cleanup_pop(1);
-- 
1.7.3.4
