From: bmarzins@sourceware.org
Subject: multipath-tools libmultipath/structs_vec.c mul ...
Date: 26 Mar 2009 03:28:10 -0000
Message-ID: <20090326032810.5957.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2009-03-26 03:28:10

Modified files:
	libmultipath   : structs_vec.c 
	multipathd     : main.c 

Log message:
	Fix for bz #452897
	Make sure that multipath modifying a map doesn't clear out the map's hardware
	entry.  Not applicable to upstream.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/structs_vec.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.1.2.3&r2=1.1.2.4
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.69.2.14&r2=1.69.2.15

--- multipath-tools/libmultipath/structs_vec.c	2008/09/04 20:09:48	1.1.2.3
+++ multipath-tools/libmultipath/structs_vec.c	2009/03/26 03:28:09	1.1.2.4
@@ -377,10 +377,16 @@
 		/*
 		 * see if path is in sysfs
 		 */
-		if (!pp->dev || sysfs_get_dev(sysfs_path,
-				  pp->dev, pp->dev_t, BLK_DEV_SIZE)) {
-			condlog(0, "%s: failed to access path %s", mpp->alias,
-				pp->dev ? pp->dev : pp->dev_t);
+		if (!(*pp->dev) ||
+		    sysfs_get_dev(sysfs_path, pp->dev, pp->dev_t,
+				  BLK_DEV_SIZE)) {
+			if (!(*pp->dev))
+				condlog(3,
+					"%s: removing path %s with no devname",
+					mpp->alias, pp->dev_t);
+			else
+				condlog(0, "%s: failed to access path %s",
+					mpp->alias, pp->dev);
 			count++;
 			vector_del_slot(mpp->paths, i);
 			i--;
--- multipath-tools/multipathd/main.c	2008/09/19 03:27:08	1.69.2.14
+++ multipath-tools/multipathd/main.c	2009/03/26 03:28:09	1.69.2.15
@@ -411,6 +411,7 @@
 			return 1; /* leave path added to pathvec */
 
 		verify_paths(mpp, vecs, NULL);
+		mpp->hwe = pp->hwe;
 		mpp->flush_on_last_del = FLUSH_UNDEF;
 		mpp->action = ACT_RELOAD;
 	}
