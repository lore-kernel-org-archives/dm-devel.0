From: bmarzins@sourceware.org
Subject: multipath-tools libmultipath/devmapper.c libmu ...
Date: 16 Apr 2010 22:08:03 -0000
Message-ID: <20100416220803.19055.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2010-04-16 22:08:03

Modified files:
	libmultipath   : devmapper.c devmapper.h 
	multipath      : main.c 

Log message:
	Fix for bz #517951. Updated prereq testing code.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/devmapper.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.22.2.8&r2=1.22.2.9
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/devmapper.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.11.2.5&r2=1.11.2.6
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.44.2.8&r2=1.44.2.9

--- multipath-tools/libmultipath/devmapper.c	2009/05/04 18:12:06	1.22.2.8
+++ multipath-tools/libmultipath/devmapper.c	2010/04/16 22:08:02	1.22.2.9
@@ -82,13 +82,35 @@
 	dm_log_init_verbose(conf ? conf->verbosity + 3 : 0);
 }
 
-extern int
-dm_prereq (char * str, int x, int y, int z)
+static int
+dm_libprereq (void)
+{
+	char version[64];
+	int v[3];
+	int minv[3] = {1, 2, 11};
+
+	dm_get_library_version(version, sizeof(version));
+	condlog(3, "libdevmapper version %s", version);
+	sscanf(version, "%d.%d.%d ", &v[0], &v[1], &v[2]);
+
+	if ((v[0] > minv[0]) ||
+	    ((v[0] ==  minv[0]) && (v[1] > minv[1])) ||
+	    ((v[0] == minv[0]) && (v[1] == minv[1]) && (v[2] >= minv[2])))
+		return 0;
+	condlog(0, "libdevmapper version must be >= %d.%.2d.%.2d",
+		minv[0], minv[1], minv[2]);
+	return 1;
+}
+
+static int
+dm_drvprereq (char * str)
 {
 	int r = 2;
 	struct dm_task *dmt;
 	struct dm_versions *target;
 	struct dm_versions *last_target;
+	int minv[3] = {1, 0, 3};
+	unsigned int *v;
 
 	if (!(dmt = dm_task_create(DM_DEVICE_LIST_VERSIONS)))
 		return 3;
@@ -104,25 +126,26 @@
 
 	do {
 		last_target = target;
-
 		if (!strncmp(str, target->name, strlen(str))) {
-			r--;
-			
-			if (target->version[0] >= x &&
-			    target->version[1] >= y &&
-			    target->version[2] >= z)
-				r--;
-
+			r = 1;
 			break;
 		}
-
 		target = (void *) target + target->next;
 	} while (last_target != target);
 
-	if (r == 2)
+	if (r == 2) {
 		condlog(0, "DM multipath kernel driver not loaded");
-	else if (r == 1)
-		condlog(0, "DM multipath kernel driver version too old");
+		goto out;
+	}
+	v = target->version;
+	if ((v[0] > minv[0]) ||
+	    ((v[0] == minv[0]) && (v[1] > minv[1])) ||
+	    ((v[0] == minv[0]) && (v[1] == minv[1]) && (v[2] >= minv[2]))) {
+		r = 0;
+		goto out;
+	}
+	condlog(0, "DM multipath kernel driver must be >= %u.%.2u.%.2u",
+		minv[0], minv[1], minv[2]);
 
 out:
 	dm_task_destroy(dmt);
@@ -130,6 +153,14 @@
 }
 
 extern int
+dm_prereq (char * str)
+{
+	if (dm_libprereq())
+		return 1;
+	return dm_drvprereq(str);
+}
+
+extern int
 dm_simplecmd (int task, const char *name, int no_flush) {
 	int r = 0;
 	struct dm_task *dmt;
--- multipath-tools/libmultipath/devmapper.h	2008/09/19 03:27:08	1.11.2.5
+++ multipath-tools/libmultipath/devmapper.h	2010/04/16 22:08:03	1.11.2.6
@@ -3,7 +3,7 @@
 #include "structs.h"
 
 void dm_init(void);
-int dm_prereq (char *, int, int, int);
+int dm_prereq (char *);
 int dm_simplecmd (int, const char *, int);
 int dm_addmap (int, const char *, struct multipath *, int, int); 
 int dm_map_present (char *);
--- multipath-tools/multipath/main.c	2010/04/08 19:31:49	1.44.2.8
+++ multipath-tools/multipath/main.c	2010/04/16 22:08:03	1.44.2.9
@@ -1,7 +1,7 @@
 /*
  * Soft:        multipath device mapper target autoconfig
  *
- * Version:     $Id: main.c,v 1.44.2.8 2010/04/08 19:31:49 bmarzins Exp $
+ * Version:     $Id: main.c,v 1.44.2.9 2010/04/16 22:08:03 bmarzins Exp $
  *
  * Author:      Christophe Varoqui
  *
@@ -315,7 +315,7 @@
 		exit(1);
 	}
 
-	if (dm_prereq(DEFAULT_TARGET, 1, 0, 3))
+	if (dm_prereq(DEFAULT_TARGET))
 		exit(1);
 
 	if (sysfs_get_mnt_path(sysfs_path, FILE_NAME_SIZE)) {
