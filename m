From: agk@sourceware.org
Subject: device-mapper WHATS_NEW
Date: 6 Jun 2008 18:53:27 -0000
Message-ID: <20080606185327.23620.qmail@sourceware.org>
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
Module name:	device-mapper
Changes by:	agk@sourceware.org	2008-06-06 18:53:27

Modified files:
	.              : WHATS_NEW 

Log message:
	nameprefixes

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.234&r2=1.235

--- device-mapper/WHATS_NEW	2008/06/06 18:53:08	1.234
+++ device-mapper/WHATS_NEW	2008/06/06 18:53:26	1.235
@@ -5,7 +5,7 @@
   Make dm_hash_iter safe against deletion.
   Accept a NULL pointer to dm_free silently.
   Add tables_loaded, readonly and suspended columns to reports.
-  Add --fieldprefixes to dmsetup.
+  Add --nameprefixes to dmsetup.
   Add field name prefix option to reporting functions.
   Calculate string size within dm_pool_grow_object.
 
