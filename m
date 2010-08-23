From: bmarzins@sourceware.org
Subject: multipath-tools/multipath mpath_wait multipath ...
Date: 23 Aug 2010 22:06:59 -0000
Message-ID: <20100823220659.26161.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2010-08-23 22:06:59

Modified files:
	multipath      : mpath_wait multipath.rules 

Log message:
	Fix for bz #568127. mpathwait will now wait for /dev/mapper/<mutipath_dev_name>
	to be created before calling kpartx on it.  This fixes a race condition. Not
	applicable upstream.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/mpath_wait.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.1&r2=1.1.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/multipath.rules.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.11.2.2&r2=1.11.2.3

--- multipath-tools/multipath/mpath_wait	2006/10/06 16:38:01	1.1
+++ multipath-tools/multipath/mpath_wait	2010/08/23 22:06:58	1.1.2.1
@@ -3,6 +3,18 @@
 retry=3
 sec=1
 
+if  [ $# -eq 1 ]
+then
+	while [ ! -e $1 -a "$retry" -gt 0 ]
+	do
+		retry=$(($retry - 1))
+		sleep $sec
+	done
+	[ -e $1 ]
+	ret=$?
+	exit $ret
+fi
+
 /sbin/dmsetup info -c --noheadings -j $1 -m $2 2> /dev/null | grep -q .*:${1}:${2}:L.*:.*:.*:.*:.*
 ret=$?
 
--- multipath-tools/multipath/multipath.rules	2009/09/29 17:52:27	1.11.2.2
+++ multipath-tools/multipath/multipath.rules	2010/08/23 22:06:58	1.11.2.3
@@ -6,7 +6,7 @@
 PROGRAM!="/sbin/mpath_wait %M %m", GOTO="end_mpath"
 PROGRAM!="/sbin/dmsetup info -c --noheadings -j %M -m %m", GOTO="end_mpath"
 RESULT!="*:*:*:*:*:*:*:mpath-*", GOTO="kpartx_check"
-PROGRAM=="/sbin/dmsetup info -c --noheadings -o name -j %M -m %m", RESULT=="?*", NAME="%k", SYMLINK="mpath/%c", RUN+="/sbin/kpartx -a -p p /dev/mapper/%c"
+PROGRAM=="/sbin/dmsetup info -c --noheadings -o name -j %M -m %m", RESULT=="?*", NAME="%k", SYMLINK="mpath/%c", RUN+="/bin/bash -c '/sbin/mpath_wait /dev/mapper/%c; /sbin/kpartx -a -p p /dev/mapper/%c'"
 OPTIONS="last_rule"
 LABEL="kpartx_check"
 RESULT!="*:*:*:*:*:*:*:part*-mpath-*", GOTO="end_mpath"
