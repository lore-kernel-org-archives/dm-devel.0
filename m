From: bmarzins@sourceware.org
Subject: multipath-tools libmultipath/devmapper.c multi ...
Date: 4 May 2009 18:12:07 -0000
Message-ID: <20090504181207.5596.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2009-05-04 18:12:07

Modified files:
	libmultipath   : devmapper.c 
	multipath      : main.c 

Log message:
	Fix for bz #477023.  Fix for multipath -F return codes ported from upstream.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/devmapper.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.22.2.7&r2=1.22.2.8
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.44.2.6&r2=1.44.2.7

--- multipath-tools/libmultipath/devmapper.c	2009/04/03 15:09:02	1.22.2.7
+++ multipath-tools/libmultipath/devmapper.c	2009/05/04 18:12:06	1.22.2.8
@@ -465,7 +465,7 @@
 		return 0;
 
 	if (dm_type(mapname, type) <= 0)
-		return 1;
+		return 0;
 
 	if (dm_remove_partmaps(mapname))
 		return 1;
@@ -507,7 +507,7 @@
 		goto out;
 
 	do {
-		r += dm_flush_map(names->name, type);
+		r |= dm_flush_map(names->name, type);
 		next = names->next;
 		names = (void *) names + next;
 	} while (next);
--- multipath-tools/multipath/main.c	2008/08/22 21:55:43	1.44.2.6
+++ multipath-tools/multipath/main.c	2009/05/04 18:12:07	1.44.2.7
@@ -1,7 +1,7 @@
 /*
  * Soft:        multipath device mapper target autoconfig
  *
- * Version:     $Id: main.c,v 1.44.2.6 2008/08/22 21:55:43 bmarzins Exp $
+ * Version:     $Id: main.c,v 1.44.2.7 2009/05/04 18:12:07 bmarzins Exp $
  *
  * Author:      Christophe Varoqui
  *
@@ -404,14 +404,14 @@
 
 	if (conf->remove == FLUSH_ONE) {
 		if (conf->dev_type == DEV_DEVMAP)
-			dm_flush_map(conf->dev, DEFAULT_TARGET);
+			r = dm_flush_map(conf->dev, DEFAULT_TARGET);
 		else
 			condlog(0, "must provide a map name to remove");
 
 		goto out;
 	}
 	else if (conf->remove == FLUSH_ALL) {
-		dm_flush_maps(DEFAULT_TARGET);
+		r = dm_flush_maps(DEFAULT_TARGET);
 		goto out;
 	}
 	while ((r = configure()) < 0)
