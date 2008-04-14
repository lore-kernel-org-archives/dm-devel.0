From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath discovery.c
Date: 14 Apr 2008 17:59:55 -0000
Message-ID: <20080414175955.18857.qmail@sourceware.org>
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
Branch: 	RHEL4_FC5
Changes by:	bmarzins@sourceware.org	2008-04-14 17:59:55

Modified files:
	libmultipath   : discovery.c 

Log message:
	Move the fd close call to fix a regression caused by the max_fd work.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/discovery.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.28.2.6&r2=1.28.2.7

--- multipath-tools/libmultipath/discovery.c	2008/03/05 20:53:14	1.28.2.6
+++ multipath-tools/libmultipath/discovery.c	2008/04/14 17:59:54	1.28.2.7
@@ -737,10 +737,6 @@
 		condlog(3, "serial = %s", pp->serial);
 	}
 
-#ifndef DAEMON
-	close(pp->fd);
-	pp->fd = -1;
-#endif
 	return 0;
 }
 
@@ -827,6 +823,10 @@
 	else if (strlen(pp->wwid))
 		condlog(3, "uid = %s (cache)", pp->wwid);
 
+#ifndef DAEMON
+	close(pp->fd);
+	pp->fd = -1;
+#endif
 	return 0;
 
 out:
