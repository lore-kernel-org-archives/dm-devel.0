From: zkabelac@sourceware.org
Subject: dmraid/lib/device scan.c
Date: 13 Jul 2010 20:11:23 -0000
Message-ID: <20100713201123.21076.qmail@sourceware.org>
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
Module name:	dmraid
Changes by:	zkabelac@sourceware.org	2010-07-13 20:11:22

Modified files:
	lib/device     : scan.c 

Log message:
	Use const char* for get_size()

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/device/scan.c.diff?cvsroot=dm&r1=1.4&r2=1.5

--- dmraid/lib/device/scan.c	2009/09/17 11:25:57	1.4
+++ dmraid/lib/device/scan.c	2010/07/13 20:11:21	1.5
@@ -260,7 +260,7 @@
 }
 
 static int
-get_size(struct lib_context *lc, char *path, char *name, int sysfs)
+get_size(struct lib_context *lc, const char *path, char *name, int sysfs)
 {
 	int fd, ret = 0;
 	char *dev_path;
@@ -305,7 +305,8 @@
 discover_devices(struct lib_context *lc, char **devnodes)
 {
 	int sysfs, ret = 0;
-	char *path, *p;
+	const char *path;
+	char *p;
 	DIR *d;
 	struct dirent *de;
 
@@ -314,7 +315,7 @@
 		path = p;
 	} else {
 		sysfs = 0;
-		path = (char *) _PATH_DEV;
+		path = _PATH_DEV;
 		log_print(lc, "carrying on with %s", path);
 	}
 
