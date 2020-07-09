From: mwilck@suse.com
Subject: [PATCH 72/74] libmpathpersist: use
	update_pathvec_from_dm()
Date: Thu,  9 Jul 2020 12:51:43 +0200
Message-ID: <20200709105145.9211-20-mwilck@suse.com>
References: <20200709105145.9211-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709105145.9211-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

The libmpathpersist-specific function updatepaths() can be replaced
with the generic function.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_persist.c | 54 +--------------------------------
 1 file changed, 1 insertion(+), 53 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index cb3182f..0c66ff3 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -65,52 +65,6 @@ mpath_lib_exit (struct config *conf)
 	return 0;
 }
 
-static int
-updatepaths (struct multipath * mpp)
-{
-	int i, j;
-	struct pathgroup * pgp;
-	struct path * pp;
-	struct config *conf;
-
-	if (!mpp->pg)
-		return 0;
-
-	vector_foreach_slot (mpp->pg, pgp, i){
-		if (!pgp->paths)
-			continue;
-
-		vector_foreach_slot (pgp->paths, pp, j){
-			if (!strlen(pp->dev)){
-				/*
-				 * path is not in sysfs anymore
-				 */
-				pp->state = PATH_DOWN;
-				continue;
-			}
-			pp->mpp = mpp;
-			if (pp->udev == NULL) {
-				pp->udev = get_udev_device(pp->dev_t, DEV_DEVT);
-				if (pp->udev == NULL) {
-					pp->state = PATH_DOWN;
-					continue;
-				}
-				conf = get_multipath_config();
-				pathinfo(pp, conf, DI_SYSFS|DI_CHECKER);
-				put_multipath_config(conf);
-				continue;
-			}
-			if (pp->state == PATH_UNCHECKED ||
-					pp->state == PATH_WILD) {
-				conf = get_multipath_config();
-				pathinfo(pp, conf, DI_CHECKER);
-				put_multipath_config(conf);
-			}
-		}
-	}
-	return 0;
-}
-
 int
 mpath_prin_activepath (struct multipath *mpp, int rq_servact,
 	struct prin_resp * resp, int noisy)
@@ -392,13 +346,7 @@ get_mpvec (vector curmp, vector pathvec, char * refwwid)
 		dm_get_status(mpp->alias, status);
 		condlog(3, "status = %s", status);
 		disassemble_map (pathvec, params, mpp);
-
-		/*
-		 * disassemble_map() can add new paths to pathvec.
-		 * If not in "fast list mode", we need to fetch information
-		 * about them
-		 */
-		updatepaths(mpp);
+		update_pathvec_from_dm(pathvec, mpp, DI_CHECKER);
 		disassemble_status (status, mpp);
 
 	}
-- 
2.26.2
