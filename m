From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW lib/datastruct/hash. ...
Date: 21 May 2008 16:14:47 -0000
Message-ID: <20080521161447.31882.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2008-05-21 16:14:46

Modified files:
	.              : WHATS_NEW 
	lib/datastruct : hash.c 
	lib/ioctl      : libdm-iface.c 
	lib/mm         : dbg_malloc.h 

Log message:
	Skip add_dev_node when ioctls disabled.
	Make dm_hash_iter safe against deletion.
	Accept a NULL pointer to dm_free silently.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.231&r2=1.232
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/datastruct/hash.c.diff?cvsroot=dm&r1=1.7&r2=1.8
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/ioctl/libdm-iface.c.diff?cvsroot=dm&r1=1.50&r2=1.51
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/mm/dbg_malloc.h.diff?cvsroot=dm&r1=1.4&r2=1.5

--- device-mapper/WHATS_NEW	2008/04/21 13:16:30	1.231
+++ device-mapper/WHATS_NEW	2008/05/21 16:14:44	1.232
@@ -1,5 +1,8 @@
 Version 1.02.26 - 
 =================================
+  Skip add_dev_node when ioctls disabled.
+  Make dm_hash_iter safe against deletion.
+  Accept a NULL pointer to dm_free silently.
   Add tables_loaded, readonly and suspended columns to reports.
   Add --prefixes to dmsetup.
   Add field name prefix option to reporting functions.
--- device-mapper/lib/datastruct/hash.c	2007/08/21 16:26:06	1.7
+++ device-mapper/lib/datastruct/hash.c	2008/05/21 16:14:45	1.8
@@ -215,12 +215,14 @@
 
 void dm_hash_iter(struct dm_hash_table *t, dm_hash_iterate_fn f)
 {
-	struct dm_hash_node *c;
+	struct dm_hash_node *c, *n;
 	unsigned i;
 
 	for (i = 0; i < t->num_slots; i++)
-		for (c = t->slots[i]; c; c = c->next)
+		for (c = t->slots[i]; c; c = n) {
+			n = c->next;
 			f(c->data);
+		}
 }
 
 void dm_hash_wipe(struct dm_hash_table *t)
--- device-mapper/lib/ioctl/libdm-iface.c	2007/12/05 16:24:41	1.50
+++ device-mapper/lib/ioctl/libdm-iface.c	2008/05/21 16:14:45	1.51
@@ -1690,8 +1690,10 @@
 
 	switch (dmt->type) {
 	case DM_DEVICE_CREATE:
-		add_dev_node(dmt->dev_name, MAJOR(dmi->dev), MINOR(dmi->dev),
-			     dmt->uid, dmt->gid, dmt->mode);
+		if (dmt->dev_name && *dmt->dev_name)
+			add_dev_node(dmt->dev_name, MAJOR(dmi->dev),
+				     MINOR(dmi->dev), dmt->uid, dmt->gid,
+				     dmt->mode);
 		break;
 
 	case DM_DEVICE_REMOVE:
--- device-mapper/lib/mm/dbg_malloc.h	2007/08/21 16:26:07	1.4
+++ device-mapper/lib/mm/dbg_malloc.h	2008/05/21 16:14:46	1.5
@@ -36,7 +36,7 @@
 
 #else
 
-#  define dm_free(p) free(p)
+#  define dm_free(p) do {if (p) free(p); } while (0)
 #  define dbg_realloc(p, s) realloc(p, s)
 #  define dump_memory()
 #  define bounds_check()
