From: wysochanski@sourceware.org
Subject: multipath-tools/libmultipath alias.h
Date: 9 Oct 2008 18:47:57 -0000
Message-ID: <20081009184757.28704.qmail@sourceware.org>
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
Changes by:	wysochanski@sourceware.org	2008-10-09 18:47:56

Modified files:
	libmultipath   : alias.h 

Log message:
	Fix rhbz445268: Increase bindings file lock timeout to avoid failure of user_friendly_names map
	
	Backport from upstream.
	From 29372b2edf719f30f21c610d502999fdf7d19885 Mon Sep 17 00:00:00 2001
	From: Dave Wysochanski <dwysocha@redhat.com>
	Date: Tue, 23 Sep 2008 13:16:38 -0400
	Subject: [PATCH] Increase bindings file lock timeout to avoid failure of user_friendly_names map.
	
	On setups with a large number of paths / multipath maps, contention for
	the advisory lock on the bindings file may take longer than 3 seconds,
	and some multipath processes may create maps based on WWID despite having
	user_friendly_names set.  Increasing the timeout is a simple fix that
	gets us a bit further.
	
	More extensive fixes might include:
	1) improving the efficiency of the critical section code
	2) use shared/read locks initially, then use exclusive/write locks only when
	it is known the bindings file needs updated

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/alias.h.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.1&r2=1.1.2.1

--- multipath-tools/libmultipath/alias.h	2005/11/09 22:28:58	1.1
+++ multipath-tools/libmultipath/alias.h	2008/10/09 18:47:50	1.1.2.1
@@ -1,4 +1,4 @@
-#define BINDINGS_FILE_TIMEOUT 3
+#define BINDINGS_FILE_TIMEOUT 30
 #define BINDINGS_FILE_HEADER \
 "# Multipath bindings, Version : 1.0\n" \
 "# NOTE: this file is automatically maintained by the multipath program.\n" \
