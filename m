From: bmarzins@sourceware.org
Subject: multipath-tools/multipath main.c
Date: 24 Oct 2011 13:44:26 -0000
Message-ID: <20111024134426.744.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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
Module name:	multipath-tools
Branch: 	RHEL5_FC6
Changes by:	bmarzins@sourceware.org	2011-10-24 13:44:25

Modified files:
	multipath      : main.c 

Log message:
	Fix for bz #740022. Do better type checking on the argument passed to multipath,
	to determine whether it's a path device name, dev_t, or a multipath device.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.44.2.10&r2=1.44.2.11

--- multipath-tools/multipath/main.c	2010/04/24 05:28:06	1.44.2.10
+++ multipath-tools/multipath/main.c	2011/10/24 13:44:25	1.44.2.11
@@ -1,7 +1,7 @@
 /*
  * Soft:        multipath device mapper target autoconfig
  *
- * Version:     $Id: main.c,v 1.44.2.10 2010/04/24 05:28:06 bmarzins Exp $
+ * Version:     $Id: main.c,v 1.44.2.11 2011/10/24 13:44:25 bmarzins Exp $
  *
  * Author:      Christophe Varoqui
  *
@@ -21,7 +21,8 @@
  * Copyright (c) 2005 Patrick Caulfield, Redhat
  * Copyright (c) 2005 Edward Goggin, EMC
  */
-
+#include <sys/types.h>
+#include <sys/stat.h>
 #include <stdio.h>
 #include <unistd.h>
 #include <ctype.h>
@@ -47,6 +48,7 @@
 #include <configure.h>
 #include <pgpolicies.h>
 #include <version.h>
+#include "dev_t.h"
 
 static int
 filter_pathvec (vector pathvec, char * refwwid)
@@ -302,13 +304,29 @@
 	return r;
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
@@ -396,13 +414,7 @@
 
 		strncpy(conf->dev, argv[optind], FILE_NAME_SIZE);
 
-		if (filepresent(conf->dev))
-			conf->dev_type = DEV_DEVNODE;
-		else if (sscanf(conf->dev, "%d:%d", &i, &i) == 2)
-			conf->dev_type = DEV_DEVT;
-		else
-			conf->dev_type = DEV_DEVMAP;
-
+		conf->dev_type = get_dev_type(conf->dev);
 	}
 	dm_init();
 
