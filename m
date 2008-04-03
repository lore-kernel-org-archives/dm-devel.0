From: bmarzins@sourceware.org
Subject: multipath-tools Multipath-usage.txt
Date: 3 Apr 2008 15:11:07 -0000
Message-ID: <20080403151107.1125.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2008-04-03 15:11:06

Modified files:
	.              : Multipath-usage.txt 

Log message:
	Fix doc mistake reported in bz 305781

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/Multipath-usage.txt.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.4.2.2&r2=1.4.2.3

--- multipath-tools/Multipath-usage.txt	2007/01/10 21:56:17	1.4.2.2
+++ multipath-tools/Multipath-usage.txt	2008/04/03 15:11:02	1.4.2.3
@@ -289,7 +289,7 @@
 
 For each path:
 
- \_ host:channel:id:lun devnode major:minor [path_status][dm_status_if_known]
+ \_ host:channel:id:lun devnode major:minor [dm_status_if_known][path_status]
 
 The dm status (dm_status_if_known) is like the path status
 (path_status), but from the kernel's point of view.  The dm status has two
