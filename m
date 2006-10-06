From: bmarzins@sourceware.org
Subject: multipath-tools/multipath Makefile multipath.r ...
Date: 6 Oct 2006 16:38:02 -0000
Message-ID: <20061006163802.6763.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2006-10-06 16:38:01

Modified files:
	multipath      : Makefile multipath.rules 
Added files:
	multipath      : mpath_wait 
Removed files:
	multipath      : kpartx_get_name mpath_get_name 

Log message:
	Fixed another part of bz 207772. All that's left is for the dm kernel fix to
	go in, and everything should be fine.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/mpath_wait.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/Makefile.diff?cvsroot=dm&r1=1.14&r2=1.15
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/multipath.rules.diff?cvsroot=dm&r1=1.9&r2=1.10
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/kpartx_get_name.diff?cvsroot=dm&r1=1.1&r2=NONE
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/mpath_get_name.diff?cvsroot=dm&r1=1.1&r2=NONE

/cvs/dm/multipath-tools/multipath/mpath_wait,v  -->  standard output
revision 1.1
--- multipath-tools/multipath/mpath_wait
+++ -	2006-10-06 16:38:01.655722000 +0000
@@ -0,0 +1,17 @@
+#!/bin/bash
+
+retry=3
+sec=1
+
+/sbin/dmsetup info -c --noheadings -j $1 -m $2 2> /dev/null | grep -q .*:${1}:${2}:L.*:.*:.*:.*:.*
+ret=$?
+
+while [ "$ret" -ne 0 -a "$retry" -gt 0 ]
+do
+        sleep $sec
+        /sbin/dmsetup info -c --noheadings -j $1 -m $2 2> /dev/null | grep -q .*:${1}:${2}:L.*:.*:.*:.*:.*
+        ret=$?
+        retry=$(($retry - 1))
+done
+
+exit $ret
--- multipath-tools/multipath/Makefile	2006/06/06 20:38:51	1.14
+++ multipath-tools/multipath/Makefile	2006/10/06 16:38:01	1.15
@@ -48,8 +48,7 @@
 	rm $(DESTDIR)/etc/udev/rules.d/40-multipath.rules
 	rm $(DESTDIR)$(bindir)/$(EXEC)
 	rm $(DESTDIR)$(bindir)/$(EXEC).static
-	rm $(DESTDIR)$(bindir)/mpath_get_name
-	rm $(DESTDIR)$(bindir)/kpartx_get_name
+	rm $(DESTDIR)$(bindir)/mpath_wait
 	rm $(DESTDIR)$(mandir)/$(EXEC).8
 
 clean:
--- multipath-tools/multipath/multipath.rules	2006/10/06 02:44:12	1.9
+++ multipath-tools/multipath/multipath.rules	2006/10/06 16:38:01	1.10
@@ -3,6 +3,7 @@
 SUBSYSTEM!="block", GOTO="end_mpath"
 KERNEL!="dm-[0-9]*", ACTION=="add", PROGRAM=="/bin/bash -c '/sbin/lsmod | /bin/grep ^dm_multipath'", RUN+="/sbin/multipath -v0 %M:%m"
 KERNEL!="dm-[0-9]*", GOTO="end_mpath"
+PROGRAM!="/sbin/mpath_wait %M %m", GOTO="end_mpath"
 ACTION=="add", RUN+="/sbin/dmsetup ls --target multipath --exec '/sbin/kpartx -a' -j %M -m %m"
 PROGRAM=="/sbin/dmsetup ls --target multipath --exec /bin/basename -j %M -m %m", RESULT=="?*", NAME="%k", SYMLINK="mpath/%c", OPTIONS="last_rule"
 PROGRAM!="/bin/bash -c '/sbin/dmsetup info -c --noheadings -j %M -m %m | /bin/grep -q .*:.*:.*:.*:.*:.*:.*:part[0-9]*-mpath-'", GOTO="end_mpath"
