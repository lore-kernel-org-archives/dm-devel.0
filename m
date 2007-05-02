From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] dm-multipath: Keep multipath from silently
	failing in path discovery
Date: Tue, 1 May 2007 19:26:10 -0500
Message-ID: <20070502002609.GB23026@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="nFreZHaLTZJo0R7j"
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This patch just makes sure that multipath doesn't silently not add a path or
fail.

-Ben

--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="no_silent_fail.patch"

diff -urpN a/libmultipath/discovery.c b/libmultipath/discovery.c
--- a/libmultipath/discovery.c	2007-04-06 12:54:05.000000000 -0500
+++ b/libmultipath/discovery.c	2007-05-01 19:19:24.000000000 -0500
@@ -71,8 +71,10 @@ path_discover (vector pathvec, struct co
 		return 1;
 	}
 			
-	if (!filepresent(path))
+	if (!filepresent(path)){
+		condlog(3, "%s doesn't exit, not adding %s", path, devname);
 		return 0;
+	}
 
 	pp = find_path_by_dev(pathvec, devname);
 
diff -urpN a/libmultipath/structs.c b/libmultipath/structs.c
--- a/libmultipath/structs.c	2006-11-27 17:16:41.000000000 -0600
+++ b/libmultipath/structs.c	2007-05-01 19:20:24.000000000 -0500
@@ -221,8 +221,10 @@ free_multipathvec (vector mpvec, int fre
 int
 store_path (vector pathvec, struct path * pp)
 {
-	if (!vector_alloc_slot(pathvec))
+	if (!vector_alloc_slot(pathvec)){
+		condlog(0, "unable to allocate space for path");
 		return 1;
+	}
 
 	vector_set_slot(pathvec, pp);
 

--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--nFreZHaLTZJo0R7j--
