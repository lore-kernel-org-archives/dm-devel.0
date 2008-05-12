From: bmarzins@sourceware.org
Subject: multipath-tools/multipath main.c
Date: 12 May 2008 17:46:41 -0000
Message-ID: <20080512174641.22405.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2008-05-12 17:46:41

Modified files:
	multipath      : main.c 

Log message:
	fix config freeing.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.44.2.4&r2=1.44.2.5

--- multipath-tools/multipath/main.c	2007/11/10 00:01:59	1.44.2.4
+++ multipath-tools/multipath/main.c	2008/05/12 17:46:41	1.44.2.5
@@ -1,7 +1,7 @@
 /*
  * Soft:        multipath device mapper target autoconfig
  *
- * Version:     $Id: main.c,v 1.44.2.4 2007/11/10 00:01:59 bmarzins Exp $
+ * Version:     $Id: main.c,v 1.44.2.5 2008/05/12 17:46:41 bmarzins Exp $
  *
  * Author:      Christophe Varoqui
  *
@@ -414,9 +414,17 @@
 		condlog(3, "restart multipath configuration process");
 	
 out:
-	free_config(conf);
 	dm_lib_release();
 	dm_lib_exit();
+
+	/*
+	 * Freeing config must be done after dm_lib_exit(), because
+	 * the logging function (dm_write_log()), which is called there,
+	 * references the config.
+	 */
+	free_config(conf);
+	conf = NULL;
+
 #ifdef _DEBUG_
 	dbg_free_final(NULL);
 #endif
