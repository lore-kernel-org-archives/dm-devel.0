From: bmarzins@sourceware.org
Subject: multipath-tools/multipath multipath.8
Date: 24 Nov 2009 22:12:36 -0000
Message-ID: <20091124221236.15319.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2009-11-24 22:12:36

Modified files:
	multipath      : multipath.8 

Log message:
	Fix for bz #510331
	Clarified manpage.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/multipath.8.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.9&r2=1.9.2.1

--- multipath-tools/multipath/multipath.8	2006/11/30 23:25:13	1.9
+++ multipath-tools/multipath/multipath.8	2009/11/24 22:12:35	1.9.2.1
@@ -75,6 +75,10 @@
 is in the /dev/sdb (as shown by udev in the $DEVNAME variable) or major:minor format.
 .I device
 may alternatively be a multipath mapname
+.SH NOTES
+a map may be unused if, eg, the file system on it is not mounted or
+there are no open file descriptors against the device file, as in a
+raw device.
 .SH "SEE ALSO"
 .BR udev (8),
 .BR dmsetup (8)
