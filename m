From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath devmapper.c
Date: 16 Aug 2007 16:41:58 -0000
Message-ID: <20070816164158.32613.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2007-08-16 16:41:58

Modified files:
	libmultipath   : devmapper.c 

Log message:
	typo.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/devmapper.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.22.2.2&r2=1.22.2.3

--- multipath-tools/libmultipath/devmapper.c	2007/08/14 18:08:54	1.22.2.2
+++ multipath-tools/libmultipath/devmapper.c	2007/08/16 16:41:58	1.22.2.3
@@ -676,8 +676,7 @@
 		}
 
 		if (!vector_alloc_slot(mp)) {
-			condlog(0, "can't allocate slot for multipath
-				    device\n");
+			condlog(0, "can't allocate slot for multipath device\n");
 			goto out1;
 		}
 
