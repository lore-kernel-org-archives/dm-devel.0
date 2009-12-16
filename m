From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath pgpolicies.c
Date: 16 Dec 2009 05:31:51 -0000
Message-ID: <20091216053151.31526.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2009-12-16 05:31:51

Modified files:
	libmultipath   : pgpolicies.c 

Log message:
	Fix for 537977. The failover priority function now orders the paths by
	priority, so that multipath will correctly fail over.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/pgpolicies.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.7.2.1&r2=1.7.2.2

--- multipath-tools/libmultipath/pgpolicies.c	2009/04/03 15:09:02	1.7.2.1
+++ multipath-tools/libmultipath/pgpolicies.c	2009/12/16 05:31:50	1.7.2.2
@@ -206,7 +206,8 @@
 extern int
 one_path_per_group (struct multipath * mp)
 {
-	int i;
+	int i, j;
+	unsigned int prio;
 	struct path * pp;
 	struct pathgroup * pgp;
 
@@ -218,16 +219,30 @@
 
 	for (i = 0; i < VECTOR_SIZE(mp->paths); i++) {
 		pp = VECTOR_SLOT(mp->paths, i);
+		prio = pp->priority;
+
+		vector_foreach_slot(mp->pg, pgp, j) {
+			pp = VECTOR_SLOT(pgp->paths, 0);
+
+			if (prio > pp->priority)
+				break;
+		}
+
 		pgp = alloc_pathgroup();
 
 		if (!pgp)
 			goto out;
 
-		if (store_pathgroup(mp->pg, pgp))
-			goto out;
-		
-		if (store_path(pgp->paths, pp))
+		if (store_path(pgp->paths, VECTOR_SLOT(mp->paths, i)))
 			goto out;
+
+		if (j < VECTOR_SIZE(mp->pg)) {
+			if (!vector_insert_slot(mp->pg, j, pgp))
+				goto out;
+		} else {
+			if (store_pathgroup(mp->pg, pgp))
+				goto out;
+		}
 	}
 	free_pathvec(mp->paths, KEEP_PATHS);
 	mp->paths = NULL;
