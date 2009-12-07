From: heinzm@sourceware.org
Subject: dmraid/lib/activate activate.c
Date: 7 Dec 2009 16:05:47 -0000
Message-ID: <20091207160547.31665.qmail@sourceware.org>
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
Module name:	dmraid
Changes by:	heinzm@sourceware.org	2009-12-07 16:05:46

Modified files:
	lib/activate   : activate.c 

Log message:
	Avoid (un)registering devices for monitoring if metadata format handler doesn't support it

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/activate/activate.c.diff?cvsroot=dm&r1=1.5&r2=1.6

--- dmraid/lib/activate/activate.c	2009/09/16 11:45:13	1.5
+++ dmraid/lib/activate/activate.c	2009/12/07 16:05:46	1.6
@@ -964,11 +964,13 @@
 {
 	int ret = 0;
 	char *table = NULL;
+	struct dmraid_format *fmt = get_format(rs);
 
 	if (T_GROUP(rs))
 		return 1;
 
-	if (what == DM_REGISTER)
+	if (what == DM_REGISTER &&
+	    fmt->metadata_handler)
 		return register_devices(lc, rs);
 
 	/* Call type handler */
@@ -1053,8 +1055,10 @@
 		    enum dm_what what)
 {
 	int ret = 1, status;
+	struct dmraid_format *fmt = get_format(rs);
 
-	if (what == DM_REGISTER)
+	if (what == DM_REGISTER &&
+	    fmt->metadata_handler)
 		return unregister_devices(lc, rs);
 
 	status = dm_status(lc, rs);
