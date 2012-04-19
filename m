From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 02/12] multipathd: remove references to
	sysfs_device
Date: Thu, 19 Apr 2012 11:08:56 +0200
Message-ID: <1334826546-32039-3-git-send-email-hare@suse.de>
References: <1334826546-32039-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1334826546-32039-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Device-mapper Development <dm-devel@redhat.com>
List-Id: dm-devel.ids

When processing events we don't need to take a reference to the
sysfs_device; it will be done later on during pathinfo.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/main.c |   30 ++----------------------------
 1 files changed, 2 insertions(+), 28 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 9cf0a80..0667a2b 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -372,14 +372,7 @@ ev_remove_map (char * devname, char * alias, int minor, struct vectors * vecs)
 static int
 uev_add_path (struct uevent *uev, struct vectors * vecs)
 {
-	struct sysfs_device * dev;
-
-	dev = sysfs_device_get(uev->devpath);
-	if (!dev) {
-		condlog(2, "%s: not found in sysfs", uev->devpath);
-		return 1;
-	}
-	condlog(2, "%s: add path (uevent)", dev->kernel);
+	condlog(2, "%s: add path (uevent)", uev->kernel);
 	return (ev_add_path(dev->kernel, vecs) != 1)? 0 : 1;
 }
 
@@ -556,21 +549,10 @@ fail:
 static int
 uev_remove_path (struct uevent *uev, struct vectors * vecs)
 {
-	struct sysfs_device * dev;
 	int retval;
 
-	dev = sysfs_device_get(uev->devpath);
-	if (!dev) {
-		condlog(2, "%s: not found in sysfs", uev->devpath);
-		return 1;
-	}
 	condlog(2, "%s: remove path (uevent)", uev->kernel);
-	retval = ev_remove_path(uev->kernel, vecs);
-
-	if (!retval)
-		sysfs_device_put(dev);
-
-	return retval;
+	return ev_remove_path(uev->kernel, vecs);
 }
 
 int
@@ -679,14 +661,8 @@ fail:
 static int
 uev_update_path (struct uevent *uev, struct vectors * vecs)
 {
-	struct sysfs_device * dev;
 	int retval, ro;
 
-	dev = sysfs_device_get(uev->devpath);
-	if (!dev) {
-		condlog(2, "%s: not found in sysfs", uev->devpath);
-		return 1;
-	}
 	ro = uevent_get_disk_ro(uev);
 
 	if (ro >= 0) {
@@ -708,8 +684,6 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 
 	}
 
-	sysfs_device_put(dev);
-
 	return retval;
 }
 
-- 
1.7.3.4
