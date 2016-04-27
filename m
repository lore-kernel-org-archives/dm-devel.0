From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 02/57] kpartx: handle more than 256 loop devices
Date: Wed, 27 Apr 2016 13:10:03 +0200
Message-ID: <1461755458-29225-3-git-send-email-hare@suse.de>
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

Update the loop handling code to support more than 256
devices.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 kpartx/lopart.c | 106 ++++++++++++++++++++++++++------------------------------
 1 file changed, 49 insertions(+), 57 deletions(-)

diff --git a/kpartx/lopart.c b/kpartx/lopart.c
index 26f3011..ffde6d9 100644
--- a/kpartx/lopart.c
+++ b/kpartx/lopart.c
@@ -25,8 +25,9 @@
 #include <sys/ioctl.h>
 #include <sys/stat.h>
 #include <sys/mman.h>
+#include <sys/types.h>
+#include <dirent.h>
 #include <sysmacros.h>
-#include <asm/posix_types.h>
 #include <linux/loop.h>
 
 #include "lopart.h"
@@ -98,78 +99,71 @@ is_loop_device (const char *device)
 extern char *
 find_loop_by_file (const char * filename)
 {
-	char dev[64];
-	char *loop_formats[] = { "/dev/loop%d", "/dev/loop/%d" };
-	int i, j, fd;
+	DIR *dir;
+	struct dirent *dent;
+	char dev[64], *found = NULL;
+	int fd;
 	struct stat statbuf;
 	struct loop_info loopinfo;
-	dev_t file_dev;
-	ino_t file_ino;
 
-	if (stat (filename, &statbuf) != 0) {
+	dir = opendir("/dev");
+	if (!dir)
 		return NULL;
-	}
-	file_dev = statbuf.st_dev;
-	file_ino = statbuf.st_ino;
-
-	for (j = 0; j < SIZE(loop_formats); j++) {
-
-		for (i = 0; i < 256; i++) {
-			sprintf (dev, loop_formats[j], i);
-
-			if (stat (dev, &statbuf) != 0 ||
-			    !S_ISBLK(statbuf.st_mode))
-				continue;
-
-			fd = open (dev, O_RDONLY);
 
-			if (fd < 0)
-				break;
+	while ((dent = readdir(dir)) != NULL) {
+		if (strncmp(dent->d_name,"loop",4))
+			continue;
+		if (!strcmp(dent->d_name, "loop-control"))
+			continue;
+		sprintf(dev, "/dev/%s", dent->d_name);
 
-			if (ioctl (fd, LOOP_GET_STATUS, &loopinfo) != 0) {
-				close (fd);
-				continue;
-			}
+		if (stat (dev, &statbuf) != 0 ||
+		    !S_ISBLK(statbuf.st_mode))
+			continue;
 
-			if (loopinfo.lo_device == file_dev && loopinfo.lo_inode == file_ino) {
-				close (fd);
-				return xstrdup(dev); /*found */
-			}
+		fd = open (dev, O_RDONLY);
+		if (fd < 0)
+			break;
 
+		if (ioctl (fd, LOOP_GET_STATUS, &loopinfo) != 0) {
 			close (fd);
 			continue;
 		}
+
+		if (0 == strcmp(filename, loopinfo.lo_name)) {
+			close (fd);
+			found = xstrdup(dev);
+			break;
+		}
+
+		close (fd);
 	}
-	return NULL;
+	closedir(dir);
+	return found;
 }
 
 extern char *
 find_unused_loop_device (void)
 {
-	/* Just creating a device, say in /tmp, is probably a bad idea -
-	   people might have problems with backup or so.
-	   So, we just try /dev/loop[0-7]. */
-
-	char dev[20];
-	char *loop_formats[] = { "/dev/loop%d", "/dev/loop/%d" };
-	int i, j, fd, first = 0, somedev = 0, someloop = 0, loop_known = 0;
+	char dev[20], *next_loop_dev = NULL;;
+	int fd, next_loop = 0, somedev = 0, someloop = 0, loop_known = 0;
 	struct stat statbuf;
 	struct loop_info loopinfo;
 	FILE *procdev;
 
-	if (stat("/dev/loop-control", &statbuf) == 0 &&
-	    S_ISCHR(statbuf.st_mode)) {
-		fd = open("/dev/loop-control", O_RDWR);
-		if (fd >= 0)
-			first = ioctl(fd, LOOP_CTL_GET_FREE);
-		close(fd);
-		if (first < 0)
-			first = 0;
-	}
-	for (j = 0; j < SIZE(loop_formats); j++) {
+	while (next_loop_dev == NULL) {
+		if (stat("/dev/loop-control", &statbuf) == 0 &&
+		    S_ISCHR(statbuf.st_mode)) {
+			fd = open("/dev/loop-control", O_RDWR);
+			if (fd < 0)
+				return NULL;
+			next_loop = ioctl(fd, LOOP_CTL_GET_FREE);
+			if (next_loop < 0)
+				return NULL;
+			close(fd);
+		}
 
-	    for(i = first; i < 256; i++) {
-		sprintf(dev, loop_formats[j], i);
+		sprintf(dev, "/dev/loop%d", next_loop);
 
 		if (stat (dev, &statbuf) == 0 && S_ISBLK(statbuf.st_mode)) {
 			somedev++;
@@ -182,18 +176,19 @@ find_unused_loop_device (void)
 
 				else if (errno == ENXIO) {
 					close (fd);
-					return xstrdup(dev);/* probably free */
+					next_loop_dev = xstrdup(dev);
 				}
 
 				close (fd);
 			}
-			
+
 			/* continue trying as long as devices exist */
 			continue;
 		}
 		break;
-	    }
 	}
+	if (next_loop_dev)
+		return next_loop_dev;
 
 	/* Nothing found. Why not? */
 	if ((procdev = fopen(PROC_DEVICES, "r")) != NULL) {
@@ -216,12 +211,10 @@ find_unused_loop_device (void)
 		fprintf(stderr, "mount: could not find any device /dev/loop#");
 
 	else if (!someloop) {
-
 	    if (loop_known == 1)
 		fprintf(stderr,
 		    "mount: Could not find any loop device.\n"
 		    "       Maybe /dev/loop# has a wrong major number?");
-	    
 	    else if (loop_known == -1)
 		fprintf(stderr,
 		    "mount: Could not find any loop device, and, according to %s,\n"
@@ -237,7 +230,6 @@ find_unused_loop_device (void)
 
 	} else
 		fprintf(stderr, "mount: could not find any free loop device");
-	
 	return 0;
 }
 
-- 
2.6.6
