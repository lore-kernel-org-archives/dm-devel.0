From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 40/78] Remove sysfs_get_dev
Date: Mon, 16 Mar 2015 13:36:27 +0100
Message-ID: <1426509425-15978-41-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
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

Pointless, and can be replaced by udev_device_get_devnum().

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c   | 9 ++++-----
 libmultipath/discovery.h   | 1 -
 libmultipath/structs_vec.c | 4 +++-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 899cbd5..7d3ff49 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -172,7 +172,6 @@ declare_sysfs_get_str(devtype);
 declare_sysfs_get_str(vendor);
 declare_sysfs_get_str(model);
 declare_sysfs_get_str(rev);
-declare_sysfs_get_str(dev);
 
 int
 sysfs_get_timeout(struct path *pp, unsigned int *timeout)
@@ -900,6 +899,8 @@ cciss_sysfs_pathinfo (struct path * pp)
 static int
 common_sysfs_pathinfo (struct path * pp)
 {
+	dev_t devt;
+
 	if (!pp)
 		return 1;
 
@@ -907,10 +908,8 @@ common_sysfs_pathinfo (struct path * pp)
 		condlog(4, "%s: udev not initialised", pp->dev);
 		return 1;
 	}
-	if (sysfs_get_dev(pp->udev, pp->dev_t, BLK_DEV_SIZE) <= 0) {
-		condlog(3, "%s: no 'dev' attribute in sysfs", pp->dev);
-		return 1;
-	}
+	devt = udev_device_get_devnum(pp->udev);
+	snprintf(pp->dev_t, BLK_DEV_SIZE, "%d:%d", major(devt), minor(devt));
 
 	condlog(3, "%s: dev_t = %s", pp->dev, pp->dev_t);
 
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index f14fcee..7e5680e 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -30,7 +30,6 @@
 
 struct config;
 
-ssize_t sysfs_get_dev (struct udev_device *udev, char * buff, size_t len);
 int path_discovery (vector pathvec, struct config * conf, int flag);
 
 int do_tur (char *);
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index a1f2212..79f31b1 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -8,6 +8,7 @@
 #include "debug.h"
 #include "structs.h"
 #include "structs_vec.h"
+#include "sysfs.h"
 #include "waiter.h"
 #include "devmapper.h"
 #include "dmparser.h"
@@ -501,7 +502,8 @@ verify_paths(struct multipath * mpp, struct vectors * vecs, vector rpvec)
 		/*
 		 * see if path is in sysfs
 		 */
-		if (sysfs_get_dev(pp->udev, pp->dev_t, BLK_DEV_SIZE) <= 0) {
+		if (sysfs_attr_get_value(pp->udev, "dev",
+					 pp->dev_t, BLK_DEV_SIZE) < 0) {
 			if (pp->state != PATH_DOWN) {
 				condlog(1, "%s: removing valid path %s in state %d",
 					mpp->alias, pp->dev, pp->state);
-- 
1.8.4.5
