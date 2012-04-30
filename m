From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 06/16] use struct udev_device during discovery
Date: Mon, 30 Apr 2012 12:25:58 +0200
Message-ID: <1335781568-13299-8-git-send-email-hare@suse.de>
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

We can save quite some parsing etc. by just using struct udev_device.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c |   44 ++++++++++++++++++--------------------------
 1 files changed, 18 insertions(+), 26 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index d68324b..fd0f827 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -56,34 +56,24 @@ out:
 }
 
 static int
-path_discover (vector pathvec, struct config * conf, char * devname, int flag)
+path_discover (vector pathvec, struct config * conf,
+	       struct udev_device *udevice, int flag)
 {
-	char path[FILE_NAME_SIZE];
 	struct path * pp;
+	const char * devname;
 
+	devname = udev_device_get_sysname(udevice);
 	if (!devname)
 		return 0;
 
 	if (filter_devnode(conf->blist_devnode, conf->elist_devnode,
-			   devname) > 0)
+			   (char *)devname) > 0)
 		return 0;
 
-	if(safe_sprintf(path, "%s/block/%s/device", sysfs_path,
-			devname)) {
-		condlog(0, "path too small");
-		return 1;
-	}
-
-	if (strncmp(devname,"cciss",5) && !filepresent(path)) {
-		condlog(4, "path %s not present", path);
-		return 0;
-	}
-
-	pp = find_path_by_dev(pathvec, devname);
-
+	pp = find_path_by_dev(pathvec, (char *)devname);
 	if (!pp) {
 		pp = store_pathinfo(pathvec, conf->hwtable,
-				    devname, flag);
+				    (char *)devname, flag);
 		return (pp ? 0 : 1);
 	}
 	return pathinfo(pp, conf->hwtable, flag);
@@ -94,8 +84,8 @@ path_discovery (vector pathvec, struct config * conf, int flag)
 {
 	struct udev_enumerate *udev_iter;
 	struct udev_list_entry *entry;
-	char *devpath;
-	char *devptr;
+	struct udev_device *udevice;
+	const char *devpath;
 	int r = 0;
 
 	udev_iter = udev_enumerate_new(conf->udev);
@@ -109,13 +99,15 @@ path_discovery (vector pathvec, struct config * conf, int flag)
 				udev_enumerate_get_list_entry(udev_iter)) {
 		devpath = udev_list_entry_get_name(entry);
 		condlog(4, "Discover device %s", devpath);
-		devptr = strrchr(devpath, '/');
-		if (devptr)
-			devptr++;
-		else
-			devptr = devpath;
-
-		r += path_discover(pathvec, conf, devptr, flag);
+		udevice = udev_device_new_from_syspath(conf->udev, devpath);
+		if (!udevice) {
+			condlog(4, "%s: no udev information", devpath);
+			r++;
+			continue;
+		}
+		if(!strncmp(udev_device_get_devtype(udevice), "disk", 4))
+			r += path_discover(pathvec, conf, udevice, flag);
+		udev_device_unref(udevice);
 	}
 	udev_enumerate_unref(udev_iter);
 	condlog(4, "Discovery status %d", r);
-- 
1.7.3.4
