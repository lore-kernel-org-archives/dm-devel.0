From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: dm-multipath: multipathd blacklisting
Date: Tue, 14 Feb 2006 17:01:14 -0600
Message-ID: <20060214230114.GB14779@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="lrZ03NoBR/3+SXJZ"
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


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

multipathd doesn't correctly blacklist devices by wwid, because the blacklist
check happens before the device information is known. This patch fixes that.

-Ben

--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="blacklist.patch"

diff -urpN mp-devel-clean/multipathd/cli_handlers.c mp-devel-patched/multipathd/cli_handlers.c
--- mp-devel-clean/multipathd/cli_handlers.c	2006-02-13 11:53:36.000000000 -0600
+++ mp-devel-patched/multipathd/cli_handlers.c	2006-02-14 17:37:05.000000000 -0600
@@ -274,16 +274,18 @@ cli_add_path (void * v, char ** reply, i
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, PATH);
+	int r;
 
 	condlog(2, "%s: add path (operator)", param);
 
-	if (blacklist(conf->blist_devnode, param)) {
+	if (blacklist(conf->blist_devnode, param) ||
+	    (r = ev_add_path(param, vecs)) == 2) {
 		*reply = strdup("blacklisted");
 		*len = strlen(*reply) + 1;
 		condlog(2, "%s: path blacklisted", param);
 		return 0;
 	}
-	return ev_add_path(param, vecs);
+	return r;
 }
 
 int
diff -urpN mp-devel-clean/multipathd/main.c mp-devel-patched/multipathd/main.c
--- mp-devel-clean/multipathd/main.c	2006-02-13 11:53:36.000000000 -0600
+++ mp-devel-patched/multipathd/main.c	2006-02-14 17:37:18.000000000 -0600
@@ -622,9 +622,16 @@ static int
 uev_add_path (char * devname, struct vectors * vecs)
 {
 	condlog(2, "%s: add path (uevent)", devname);
-	return ev_add_path(devname, vecs);
+	return (ev_add_path(devname, vecs) != 1)? 0 : 1;
 }
 
+
+/*
+ * returns:
+ * 0: added
+ * 1: error
+ * 2: blacklisted
+ */
 int
 ev_add_path (char * devname, struct vectors * vecs)
 {
@@ -661,7 +668,13 @@ ev_add_path (char * devname, struct vect
 		condlog(0, "%s: failed to get path uid", devname);
 		return 1; /* leave path added to pathvec */
 	}
-
+	if (blacklist_path(conf, pp)){
+		int i = find_slot(vecs->pathvec, (void *)pp);
+		if (i != -1)
+			vector_del_slot(vecs->pathvec, i);
+		free_path(pp);
+		return 2;
+	}	
 	mpp = pp->mpp = find_mp_by_wwid(vecs->mpvec, pp->wwid);
 rescan:
 	if (mpp) {
@@ -1299,9 +1312,15 @@ configure (struct vectors * vecs, int st
 	 */
 	path_discovery(vecs->pathvec, conf, DI_ALL);
 
-	vector_foreach_slot (vecs->pathvec, pp, i)
-		pp->checkint = conf->checkint;
-
+	vector_foreach_slot (vecs->pathvec, pp, i){
+		if (blacklist_path(conf, pp)){
+			vector_del_slot(vecs->pathvec, i);
+			free_path(pp);
+			i--;
+		}	
+		else
+			pp->checkint = conf->checkint;
+	}
 	if (map_discovery(vecs))
 		return 1;
 

--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--lrZ03NoBR/3+SXJZ--
