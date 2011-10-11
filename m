From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: better argument type checking
Date: Mon, 10 Oct 2011 22:18:09 -0500
Message-ID: <20111011031809.GU24133@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

The way that multipath decided what you passed in as an argument didn't
always work.  If the argument was the name of a file, then multipath
assumed that it was a path.  That meant if you were in /dev/mapper and ran

# multipath -f <mpath_device_name>

It would fail, since it thought you gave it a path name, instead of a
multipath device name.  Now multipath will only treat the argument
as a path name if it is a block device with a different major number than
device-mapper's.  Also, I've switched the MAJOR/MINOR/MKDEV macros to
work like kpartx, so that they can handle minor numbers over 255.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath/dev_t.h |   18 +++---------------
 multipath/main.c  |   30 +++++++++++++++++++++---------
 2 files changed, 24 insertions(+), 24 deletions(-)

Index: multipath-tools-111010/multipath/main.c
===================================================================
--- multipath-tools-111010.orig/multipath/main.c
+++ multipath-tools-111010/multipath/main.c
@@ -22,6 +22,8 @@
  * Copyright (c) 2005 Edward Goggin, EMC
  */
 
+#include <sys/types.h>
+#include <sys/stat.h>
 #include <stdio.h>
 #include <unistd.h>
 #include <ctype.h>
@@ -51,6 +53,7 @@
 #include <errno.h>
 #include <sys/time.h>
 #include <sys/resource.h>
+#include "dev_t.h"
 
 int logsink;
 
@@ -374,13 +377,29 @@ dump_config (void)
 	return 0;
 }
 
+static int
+get_dev_type(char *dev) {
+	struct stat buf;
+	int i;
+
+	if (stat(dev, &buf) == 0 && S_ISBLK(buf.st_mode)) {
+		if (dm_is_dm_major(MAJOR(buf.st_rdev)))
+			return DEV_DEVMAP;
+		return DEV_DEVNODE;
+	}
+	else if (sscanf(dev, "%d:%d", &i, &i) == 2)
+		return DEV_DEVT;
+	else
+		return DEV_DEVMAP;
+}
+
 int
 main (int argc, char *argv[])
 {
 	int arg;
 	extern char *optarg;
 	extern int optind;
-	int i, r = 1;
+	int r = 1;
 
 	if (getuid() != 0) {
 		fprintf(stderr, "need to be root\n");
@@ -478,14 +497,7 @@ main (int argc, char *argv[])
 			goto out;
 
 		strncpy(conf->dev, argv[optind], FILE_NAME_SIZE);
-
-		if (filepresent(conf->dev))
-			conf->dev_type = DEV_DEVNODE;
-		else if (sscanf(conf->dev, "%d:%d", &i, &i) == 2)
-			conf->dev_type = DEV_DEVT;
-		else
-			conf->dev_type = DEV_DEVMAP;
-
+		conf->dev_type = get_dev_type(conf->dev);
 	}
 	conf->daemon = 0;
 
Index: multipath-tools-111010/multipath/dev_t.h
===================================================================
--- multipath-tools-111010.orig/multipath/dev_t.h
+++ multipath-tools-111010/multipath/dev_t.h
@@ -1,15 +1,3 @@
-#define MINORBITS       20
-#define MINORMASK       ((1U << MINORBITS) - 1)
-
-#define MAJOR(dev)      ((unsigned int) ((dev) >> MINORBITS))
-#define MINOR(dev)      ((unsigned int) ((dev) & MINORMASK))
-#define MKDEV(ma,mi)    (((ma) << MINORBITS) | (mi))
-
-#define print_dev_t(buffer, dev)                                        \
-	sprintf((buffer), "%u:%u\n", MAJOR(dev), MINOR(dev))
-
-#define format_dev_t(buffer, dev)                                       \
-	({                                                              \
-		sprintf(buffer, "%u:%u", MAJOR(dev), MINOR(dev));       \
-		buffer;                                                 \
-	})
+#define MAJOR(dev)      ((dev & 0xfff00) >> 8)
+#define MINOR(dev)      ((dev & 0xff) | ((dev >> 12) & 0xfff00))
+#define MKDEV(ma,mi)    ((mi & 0xff) | (ma << 8) | ((mi & ~0xff) << 12))
