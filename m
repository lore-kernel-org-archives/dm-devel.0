From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath configure.c disco ...
Date: 4 Dec 2009 21:19:53 -0000
Message-ID: <20091204211953.17379.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2009-12-04 21:19:52

Modified files:
	libmultipath   : configure.c discovery.c 

Log message:
	Fix for bzs #524178 and #537281. Make sure that multipath unlocks the paths
	if it encounters an error, and tweak some warning messages

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/configure.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.2.2.5&r2=1.2.2.6
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/discovery.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.32.2.9&r2=1.32.2.10

--- multipath-tools/libmultipath/configure.c	2009/09/28 16:30:27	1.2.2.5
+++ multipath-tools/libmultipath/configure.c	2009/12/04 21:19:51	1.2.2.6
@@ -269,6 +269,7 @@
 	struct pathgroup * pgp;
 	struct path * pp;
 	int i, j;
+	int x, y;
 
 	if (!mpp || !mpp->pg)
 		return 0;
@@ -279,12 +280,25 @@
 		vector_foreach_slot(pgp->paths, pp, j) {
 			if (lock && flock(pp->fd, LOCK_EX | LOCK_NB) &&
 			    errno == EWOULDBLOCK)
-				return 1;
+				goto fail;
 			else if (!lock)
 				flock(pp->fd, LOCK_UN);
 		}
 	}
 	return 0;
+fail:
+	vector_foreach_slot (mpp->pg, pgp, x) {
+		if (x > i)
+			return 1;
+		if (!pgp->paths)
+			continue;
+		vector_foreach_slot(pgp->paths, pp, y) {
+			if (x == i && y > j)
+				return 1;
+			flock(pp->fd, LOCK_UN);
+		}
+	}
+	return 1;
 }
 
 /*
@@ -331,8 +345,10 @@
 			return DOMAP_RETRY;
 		}
 
-		if (dm_map_present(mpp->alias))
+		if (dm_map_present(mpp->alias)) {
+			lock_multipath(mpp, 0);
 			break;
+		}
 
 		r = dm_addmap(DM_DEVICE_CREATE, DEFAULT_TARGET, mpp, 1, 0);
 
@@ -344,11 +360,12 @@
 		 * DM_TABLE_LOAD. Failing the second part leaves an
 		 * empty map. Clean it up.
 		 */
-		if (!r && dm_map_present(mpp->alias)) {
+		if (!r) {
+		 	if (dm_map_present(mpp->alias))
+				dm_flush_map(mpp->alias, DEFAULT_TARGET);
 			condlog(3, "%s: failed to load map "
 				   "(a path might be in use)",
 				   mpp->alias);
-			dm_flush_map(mpp->alias, DEFAULT_TARGET);
 		}
 
 		lock_multipath(mpp, 0);
--- multipath-tools/libmultipath/discovery.c	2009/11/23 21:08:34	1.32.2.9
+++ multipath-tools/libmultipath/discovery.c	2009/12/04 21:19:51	1.32.2.10
@@ -752,8 +752,9 @@
 	if (apply_format(pp->getuid, &buff[0], pp)) {
 		condlog(0, "error formatting uid callout command");
 		memset(pp->wwid, 0, WWID_SIZE);
-	} else if (execute_program(buff, pp->wwid, WWID_SIZE)) {
-		condlog(0, "error calling out %s", buff);
+	} else if (execute_program(buff, pp->wwid, WWID_SIZE) ||
+		   pp->wwid[0] == 0) {
+		condlog(0, "cannot get the the wwid for %s", pp->dev);
 		memset(pp->wwid, 0, WWID_SIZE);
 		return 1;
 	}
