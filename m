From: bmarzins@sourceware.org
Subject: multipath-tools/libcheckers rdac.c
Date: 24 Jun 2009 21:15:53 -0000
Message-ID: <20090624211553.21042.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2009-06-24 21:15:52

Modified files:
	libcheckers    : rdac.c 

Log message:
	Pulled Charlie Brady's patch from dm-devel to make the rdac checker print the
	right message on changes to PATH_UP and PATH_GHOST.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/rdac.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.1.2.2&r2=1.1.2.3

--- multipath-tools/libcheckers/Attic/rdac.c	2007/06/18 21:12:54	1.1.2.2
+++ multipath-tools/libcheckers/Attic/rdac.c	2009/06/24 21:15:52	1.1.2.3
@@ -105,5 +105,12 @@
 		return PATH_DOWN;
 	}
 
-	return ((inq.avtcvp & 0x1) ? PATH_UP : PATH_GHOST);
+	if (inq.avtcvp & 0x1) {
+		MSG(c, MSG_RDAC_UP);
+		return PATH_UP;
+	}
+	else {
+		MSG(c, MSG_RDAC_GHOST);
+		return PATH_GHOST;
+	}
 }
