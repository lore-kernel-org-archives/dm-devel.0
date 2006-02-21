From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: dm-multipath: syncing path states
Date: Tue, 21 Feb 2006 16:37:08 -0600
Message-ID: <20060221223708.GB5670@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="zYM0uCDKw75PZbzx"
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


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Occasionally, the path states for multipathd and device mapper are out of sync.
This happens either when multipathd starts, or after a multipath map is
created or reloaded (what a path is added or removed, or a map is added).
The attached patch syncs the paths' dmstate with it's state after one of
these actions happens.

-Ben

--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="state_sync.patch"

diff -urpN mp-devel-clean/multipathd/main.c mp-devel-patched/multipathd/main.c
--- mp-devel-clean/multipathd/main.c	2006-02-17 16:07:19.000000000 -0600
+++ mp-devel-patched/multipathd/main.c	2006-02-21 17:14:42.000000000 -0600
@@ -475,6 +475,40 @@ out:
 	return 1;
 }
 
+static void
+sync_map_state(struct multipath *mpp)
+{
+	int i, j;
+	struct pathgroup *pgp;
+        struct path *pp;
+
+	vector_foreach_slot (mpp->pg, pgp, i){
+		vector_foreach_slot (pgp->paths, pp, j){
+			if (pp->state <= PATH_UNCHECKED)
+				continue;
+			if ((pp->dmstate == PSTATE_FAILED ||
+			     pp->dmstate == PSTATE_UNDEF) &&
+			    (pp->state == PATH_UP || pp->state == PATH_GHOST))
+				dm_reinstate_path(mpp->alias, pp->dev_t);
+			else if ((pp->dmstate == PSTATE_ACTIVE ||
+				  pp->dmstate == PSTATE_UNDEF) &&
+				 (pp->state == PATH_DOWN ||
+				  pp->state == PATH_SHAKY))
+				dm_fail_path(mpp->alias, pp->dev_t);
+		}
+	}
+}
+
+static void
+sync_maps_state(vector mpvec)
+{
+	int i;
+	struct multipath *mpp;
+
+	vector_foreach_slot (mpvec, mpp, i) 
+		sync_map_state(mpp);
+}
+
 static int
 flush_map(struct multipath * mpp, struct vectors * vecs)
 {
@@ -556,6 +590,7 @@ ev_add_map (char * devname, struct vecto
 	 */
 	if (map_present && (mpp = add_map_without_path(vecs, minor, alias,
 					start_waiter_thread))) {
+		sync_map_state(mpp);
 		condlog(3, "%s: devmap %s added", alias, devname);
 		return 0;
 	}
@@ -728,6 +763,8 @@ rescan:
 	if (setup_multipath(vecs, mpp))
 		goto out;
 
+	sync_map_state(mpp);
+
 	if (mpp->action == ACT_CREATE &&
 	    start_waiter_thread(mpp, vecs))
 			goto out;
@@ -826,6 +863,7 @@ ev_remove_path (char * devname, struct v
 					free_pathvec(rpvec, KEEP_PATHS);
 					goto out;
 				}
+				sync_map_state(mpp);
 
 				condlog(3, "%s path removed from devmap %s",
 					devname, mpp->alias);
@@ -1354,6 +1392,8 @@ configure (struct vectors * vecs, int st
 
 	dm_lib_release();
 
+	sync_maps_state(mpvec);
+
 	if (conf->verbosity > 2)
 		vector_foreach_slot(mpvec, mpp, i)
 			print_map(mpp);

--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--zYM0uCDKw75PZbzx--
