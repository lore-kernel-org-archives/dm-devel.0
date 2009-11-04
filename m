From: bmarzins@sourceware.org
Subject: multipath-tools/libcheckers rdac.c
Date: 4 Nov 2009 20:21:44 -0000
Message-ID: <20091104202144.19493.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2009-11-04 20:21:43

Modified files:
	libcheckers    : rdac.c 

Log message:
	Fix for bz #531744. In rdac path checker, check if devices are connected,
	and if they are not, mark the path as failed. Already upstream.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/rdac.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.1.2.3&r2=1.1.2.4

--- multipath-tools/libcheckers/Attic/rdac.c	2009/06/24 21:15:52	1.1.2.3
+++ multipath-tools/libcheckers/Attic/rdac.c	2009/11/04 20:21:43	1.1.2.4
@@ -90,7 +90,8 @@
 
 struct volume_access_inq
 {
-	char dontcare0[8];
+	char PQ_PDT;
+	char dontcare0[7];
 	char avtcvp;
 	char dontcare1[39];
 };
@@ -103,6 +104,11 @@
 	if (0 != do_inq(c->fd, 0xC9, &inq, sizeof(struct volume_access_inq))) {
 		MSG(c, MSG_RDAC_DOWN);
 		return PATH_DOWN;
+	} else {
+		if ((inq.PQ_PDT & 0x20) || (inq.PQ_PDT & 0x7f)) {
+			/* LUN not connected*/
+			return PATH_DOWN;
+		}
 	}
 
 	if (inq.avtcvp & 0x1) {
