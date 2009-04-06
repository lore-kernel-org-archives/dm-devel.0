From: bmarzins@sourceware.org
Subject: multipath-tools/multipathd main.c multipathd.i ...
Date: 6 Apr 2009 16:50:44 -0000
Message-ID: <20090406165044.22474.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2009-04-06 16:50:44

Modified files:
	multipathd     : main.c multipathd.init.redhat 

Log message:
	Fix for bz #493402. Change umask for multipathd. Already fixed upstream.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.69.2.17&r2=1.69.2.18
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/multipathd.init.redhat.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.2.4.3&r2=1.2.4.4

--- multipath-tools/multipathd/main.c	2009/04/03 15:09:03	1.69.2.17
+++ multipath-tools/multipathd/main.c	2009/04/06 16:50:43	1.69.2.18
@@ -775,6 +775,7 @@
 	add_handler(RESTOREQ+MAPS, cli_restore_all_queueing);
 	add_handler(RESIZE+MAP, cli_resize);
 
+	umask(077);
 	uxsock_listen(&uxsock_trigger, ap);
 
 	return NULL;
@@ -1497,7 +1498,6 @@
 	close(in_fd);
 	close(out_fd);
 	chdir("/");
-	umask(0);
 }
 
 enum child_flag_bits {
--- multipath-tools/multipathd/multipathd.init.redhat	2008/08/28 19:22:33	1.2.4.3
+++ multipath-tools/multipathd/multipathd.init.redhat	2009/04/06 16:50:44	1.2.4.4
@@ -29,6 +29,7 @@
 
 teardown_slaves()
 {
+pwd=`pwd`
 cd $1; 
 if [ -d "slaves" ]; then
 for slave in slaves/*;
@@ -54,6 +55,7 @@
 			exit 1
 		fi
 fi
+cd $pwd
 }
 
 #
