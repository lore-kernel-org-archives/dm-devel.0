From: bmarzins@sourceware.org
Subject: multipath-tools/multipathd main.c
Date: 12 Sep 2008 23:49:57 -0000
Message-ID: <20080912234957.16468.qmail@sourceware.org>
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
Module name:	multipath-tools
Branch: 	RHEL5_FC6
Changes by:	bmarzins@sourceware.org	2008-09-12 23:49:57

Modified files:
	multipathd     : main.c 

Log message:
	Fix for bz 449097.  When multipathd creates a new namespace for the
	callout functions, it now unmounts all of the unneeded mounts that it inherits
	the calling process.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.69.2.12&r2=1.69.2.13

--- multipath-tools/multipathd/main.c	2008/09/08 22:01:20	1.69.2.12
+++ multipath-tools/multipathd/main.c	2008/09/12 23:49:57	1.69.2.13
@@ -15,6 +15,7 @@
 #include <errno.h>
 #include <sys/time.h>
 #include <sys/resource.h>
+#include <sys/mount.h>
 
 /*
  * libsysfs
@@ -62,6 +63,10 @@
 #include "waiter.h"
 #include "copy.h"
 
+#if !defined(MNT_DETACH)
+#define MNT_DETACH 2
+#endif
+
 #define FILE_NAME_SIZE 256
 #define CMDSIZE 160
 
@@ -1231,6 +1236,47 @@
 	return NULL;
 }
 
+static int
+unmount_extra_devs(void)
+{
+	int ret;
+	char buf[LINE_MAX];
+	FILE *file;
+
+	file = fopen("/proc/mounts", "r");
+	if (!file) {
+		condlog(0, "couldn't open /proc/mounts : %s", strerror(errno));
+		return -1;
+	}
+
+	while (fgets(buf, LINE_MAX, file)) {
+		char *end, *mnt = strchr(buf, ' ');
+		if (!mnt)
+			continue;
+		mnt++;
+		end = strchr(mnt, ' ');
+		if (!end) {
+			condlog(2, "can't process /proc/mounts line (%s). skipping", buf);
+			continue;
+		}
+		*end = '\0';
+		if (strcmp(mnt, "/") == 0 || strcmp(mnt, "/sbin") == 0 ||
+		    strcmp(mnt, "/bin") == 0 || strcmp(mnt, "/tmp") == 0 ||
+		    strcmp(mnt, "/usr") == 0 || strncmp(mnt, "/usr/lib", 8) == 0 ||
+		    strncmp(mnt, "/etc", 4) == 0 || strncmp(mnt, "/proc", 5) == 0 ||
+		    strncmp(mnt, "/dev", 4) == 0 || strncmp(mnt, "/sys", 4) == 0 ||
+		    strncmp(mnt, "/var", 4) == 0 || strncmp(mnt, "/lib", 4) == 0)
+			continue;
+		if (umount2(mnt, MNT_DETACH) < 0 && errno != ENOENT) {
+			condlog(0, "failed to umount '%s' (%s). skipping", mnt, strerror(errno));
+		}
+	}
+	fclose(file);
+	return ret;
+}	
+	
+	
+
 
 #ifdef CLONE_NEWNS
 static int
@@ -1328,7 +1374,8 @@
 		return -1;
 	}
 	condlog(4, "bind ramfs on /tmp");
-
+	if (unmount_extra_devs() < 0)
+		return -1;
 	return 0;
 }
 #endif
