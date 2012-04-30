From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 05/16] Use udev enumeration during discovery
Date: Mon, 30 Apr 2012 12:25:57 +0200
Message-ID: <1335781568-13299-7-git-send-email-hare@suse.de>
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

Instead of scanning /sys/block by hand we should be using enumeration
provided by udev.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c |   40 ++++++++++++++++++----------------------
 1 files changed, 18 insertions(+), 22 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 426c511..d68324b 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -11,6 +11,7 @@
 #include <dirent.h>
 #include <errno.h>
 #include <libgen.h>
+#include <libudev.h>
 
 #include "checkers.h"
 #include "vector.h"
@@ -91,37 +92,32 @@ path_discover (vector pathvec, struct config * conf, char * devname, int flag)
 int
 path_discovery (vector pathvec, struct config * conf, int flag)
 {
-	DIR *blkdir;
-	struct dirent *blkdev;
-	struct stat statbuf;
-	char devpath[PATH_MAX];
+	struct udev_enumerate *udev_iter;
+	struct udev_list_entry *entry;
+	char *devpath;
 	char *devptr;
 	int r = 0;
 
-	if (!(blkdir = opendir("/sys/block")))
+	udev_iter = udev_enumerate_new(conf->udev);
+	if (!udev_iter)
 		return 1;
 
-	strcpy(devpath,"/sys/block");
-	while ((blkdev = readdir(blkdir)) != NULL) {
-		if ((strcmp(blkdev->d_name,".") == 0) ||
-		    (strcmp(blkdev->d_name,"..") == 0))
-			continue;
-
-		devptr = devpath + 10;
-		*devptr = '\0';
-		strcat(devptr,"/");
-		strcat(devptr,blkdev->d_name);
-		if (stat(devpath, &statbuf) < 0)
-			continue;
-
-		if (S_ISDIR(statbuf.st_mode) == 0)
-			continue;
+	udev_enumerate_add_match_subsystem(udev_iter, "block");
+	udev_enumerate_scan_devices(udev_iter);
 
+	udev_list_entry_foreach(entry,
+				udev_enumerate_get_list_entry(udev_iter)) {
+		devpath = udev_list_entry_get_name(entry);
 		condlog(4, "Discover device %s", devpath);
+		devptr = strrchr(devpath, '/');
+		if (devptr)
+			devptr++;
+		else
+			devptr = devpath;
 
-		r += path_discover(pathvec, conf, blkdev->d_name, flag);
+		r += path_discover(pathvec, conf, devptr, flag);
 	}
-	closedir(blkdir);
+	udev_enumerate_unref(udev_iter);
 	condlog(4, "Discovery status %d", r);
 	return r;
 }
-- 
1.7.3.4
