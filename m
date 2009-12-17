From: heinzm@sourceware.org
Subject: dmraid/lib/device partition.c
Date: 17 Dec 2009 14:29:24 -0000
Message-ID: <20091217142924.27772.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	dmraid
Changes by:	heinzm@sourceware.org	2009-12-17 14:29:24

Modified files:
	lib/device     : partition.c 

Log message:
	Avoid fd leak in _remove_subset_partitions (Neil Brown)

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/device/partition.c.diff?cvsroot=dm&r1=1.1&r2=1.2

--- dmraid/lib/device/partition.c	2009/12/16 11:39:18	1.1
+++ dmraid/lib/device/partition.c	2009/12/17 14:29:24	1.2
@@ -23,20 +23,27 @@
 
 	list_for_each_entry(rd, &rs->devs, devs) {
 		int fd = open(rd->di->path, O_RDWR);
+
 		if (fd < 0)
 			LOG_ERR(lc, 0, "opening %s: %s\n", rd->di->path,
 				strerror(errno));
 
 		/* There is no way to enumerate partitions */
 		for (part.pno = 1; part.pno <= 256; part.pno++) {
-			if (ioctl(fd, BLKPG, &io) < 0 && errno != ENXIO &&
-					(part.pno < 16 || errno != EINVAL))
+			if (ioctl(fd, BLKPG, &io) < 0 &&
+			    errno != ENXIO &&
+			    (part.pno < 16 || errno != EINVAL)) {
+				close(fd);
 				LOG_ERR(lc, 0,
 					"removing part %d from %s: %s\n",
 					part.pno, rd->di->path,
 					strerror(errno));
+			}
 		}
+
+		close(fd);
 	}
+
 	return 1;
 }
 
