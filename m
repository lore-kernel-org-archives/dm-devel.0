From: zkabelac@sourceware.org
Subject: dmraid/lib/activate activate.h activate.c
Date: 13 Jul 2010 20:25:10 -0000
Message-ID: <20100713202510.26146.qmail@sourceware.org>
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
Changes by:	zkabelac@sourceware.org	2010-07-13 20:25:09

Modified files:
	lib/activate   : activate.h activate.c 

Log message:
	Add missing declaration of libdmraid_make_table
	FIXME - should be using dmraid.h

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/activate/activate.h.diff?cvsroot=dm&r1=1.3&r2=1.4
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/activate/activate.c.diff?cvsroot=dm&r1=1.7&r2=1.8

--- dmraid/lib/activate/activate.h	2009/09/16 11:45:13	1.3
+++ dmraid/lib/activate/activate.h	2010/07/13 20:25:09	1.4
@@ -16,6 +16,9 @@
 	A_RELOAD,
 };
 
+/* FIXME - dmraid.h */
+extern char *libdmraid_make_table(struct lib_context *lc, struct raid_set *rs);
+
 int change_set(struct lib_context *lc, enum activate_type what, void *rs);
 void delete_error_target(struct lib_context *lc, struct raid_set *rs);
 
--- dmraid/lib/activate/activate.c	2010/03/18 13:10:42	1.7
+++ dmraid/lib/activate/activate.c	2010/07/13 20:25:09	1.8
@@ -20,6 +20,7 @@
 
 #include "internal.h"
 #include "devmapper.h"
+//#include "dmraid/dmraid.h"
 
 static int
 valid_rd(struct raid_dev *rd)
