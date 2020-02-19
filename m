From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2 1/5] multipath: fix issues found by compiling
	with gcc 10
Date: Wed, 19 Feb 2020 14:21:41 -0600
Message-ID: <1582143705-20886-2-git-send-email-bmarzins@redhat.com>
References: <1582143705-20886-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1582143705-20886-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 kpartx/dasd.c        |  6 +++---
 libmultipath/print.c | 16 ++++++++--------
 multipath/main.c     |  2 +-
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/kpartx/dasd.c b/kpartx/dasd.c
index 1486ccaa..14b9d3aa 100644
--- a/kpartx/dasd.c
+++ b/kpartx/dasd.c
@@ -186,7 +186,7 @@ read_dasd_pt(int fd, __attribute__((unused)) struct slice all,
 		goto out;
 	}
 
-	if ((!info.FBA_layout) && (!strcmp(info.type, "ECKD")))
+	if ((!info.FBA_layout) && (!memcmp(info.type, "ECKD", 4)))
 		memcpy (&vlabel, data, sizeof(vlabel));
 	else {
 		bzero(&vlabel,4);
@@ -216,7 +216,7 @@ read_dasd_pt(int fd, __attribute__((unused)) struct slice all,
 		sp[0].size  = size - sp[0].start;
 		retval = 1;
 	} else if ((strncmp(type, "VOL1", 4) == 0) &&
-		(!info.FBA_layout) && (!strcmp(info.type, "ECKD"))) {
+		(!info.FBA_layout) && (!memcmp(info.type, "ECKD",4))) {
 		/*
 		 * New style VOL1 labeled disk
 		 */
@@ -265,7 +265,7 @@ read_dasd_pt(int fd, __attribute__((unused)) struct slice all,
 			if (vlabel.ldl_version == 0xf2) {
 				fmt_size = sectors512(vlabel.formatted_blocks,
 						      blocksize);
-			} else if (!strcmp(info.type, "ECKD")) {
+			} else if (!memcmp(info.type, "ECKD",4)) {
 				/* formatted w/o large volume support */
 				fmt_size = geo.cylinders * geo.heads
 					* geo.sectors * (blocksize >> 9);
diff --git a/libmultipath/print.c b/libmultipath/print.c
index 1858d8ea..56f86b2f 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -29,6 +29,7 @@
 #include "uevent.h"
 #include "debug.h"
 #include "discovery.h"
+#include "util.h"
 
 #define MAX(x,y) (((x) > (y)) ? (x) : (y))
 #define MIN(x,y) (((x) > (y)) ? (y) : (x))
@@ -2032,7 +2033,6 @@ int snprint_devices(struct config *conf, char * buff, int len,
 	struct dirent *blkdev;
 	struct stat statbuf;
 	char devpath[PATH_MAX];
-	char *devptr;
 	int threshold = MAX_LINE_LEN;
 	int fwd = 0;
 	int r;
@@ -2048,15 +2048,14 @@ int snprint_devices(struct config *conf, char * buff, int len,
 	}
 	fwd += snprintf(buff + fwd, len - fwd, "available block devices:\n");
 
-	strcpy(devpath,"/sys/block/");
 	while ((blkdev = readdir(blkdir)) != NULL) {
 		if ((strcmp(blkdev->d_name,".") == 0) ||
 		    (strcmp(blkdev->d_name,"..") == 0))
 			continue;
 
-		devptr = devpath + 11;
-		*devptr = '\0';
-		strncat(devptr, blkdev->d_name, PATH_MAX-12);
+		if (safe_sprintf(devpath, "/sys/block/%s", blkdev->d_name))
+			continue;
+
 		if (stat(devpath, &statbuf) < 0)
 			continue;
 
@@ -2068,11 +2067,12 @@ int snprint_devices(struct config *conf, char * buff, int len,
 			return len;
 		}
 
-		fwd += snprintf(buff + fwd, len - fwd, "    %s", devptr);
-		pp = find_path_by_dev(vecs->pathvec, devptr);
+		fwd += snprintf(buff + fwd, len - fwd, "    %s",
+				blkdev->d_name);
+		pp = find_path_by_dev(vecs->pathvec, blkdev->d_name);
 		if (!pp) {
 			r = filter_devnode(conf->blist_devnode,
-					   conf->elist_devnode, devptr);
+					   conf->elist_devnode, blkdev->d_name);
 			if (r > 0)
 				fwd += snprintf(buff + fwd, len - fwd,
 						" devnode blacklisted, unmonitored");
diff --git a/multipath/main.c b/multipath/main.c
index 15007752..cf9d2a28 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -1025,7 +1025,7 @@ main (int argc, char *argv[])
 		if (!dev)
 			goto out;
 
-		strncpy(dev, argv[optind], FILE_NAME_SIZE);
+		strlcpy(dev, argv[optind], FILE_NAME_SIZE);
 		if (dev_type != DEV_UEVENT)
 			dev_type = get_dev_type(dev);
 		if (dev_type == DEV_NONE) {
-- 
2.17.2
