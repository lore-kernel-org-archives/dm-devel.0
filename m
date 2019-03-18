From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 06/10] libmultipath: lazy tpgs probing
Date: Mon, 18 Mar 2019 12:24:41 +0100
Message-ID: <20190318112445.6636-7-mwilck@suse.com>
References: <20190318112445.6636-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190318112445.6636-1-mwilck@suse.com>
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

Provide a "getter" function that can be used to probe tpgs lazily.
This way we don't need to send an RTPG in the pathinfo() call
chain (e.g. in "multipath -u"). With this in place, no "user"
code should access pp->tpgs directly any more.

Moreover, in select_prio(), in the case where the alua checker
was statically configured, rather then calling into the alua
code directly, use get_tpgs(), which does all the proper error
checking, and fall back to const prio if it fails.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 10 +++++++---
 libmultipath/discovery.h |  2 +-
 libmultipath/propsel.c   | 25 +++++++++++++++----------
 multipathd/main.c        |  7 ++++---
 4 files changed, 27 insertions(+), 17 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index b2a43e86..b51a37b2 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -854,6 +854,13 @@ detect_alua(struct path * pp)
 	pp->tpgs = tpgs;
 }
 
+int path_get_tpgs(struct path *pp)
+{
+	if (pp->tpgs == TPGS_UNDEF)
+		detect_alua(pp);
+	return pp->tpgs;
+}
+
 #define DEFAULT_SGIO_LEN 254
 
 /* Query VPD page @pg. Returns number of INQUIRY bytes
@@ -1521,9 +1528,6 @@ scsi_ioctl_pathinfo (struct path * pp, struct config *conf, int mask)
 	struct udev_device *parent;
 	const char *attr_path = NULL;
 
-	if (pp->tpgs == TPGS_UNDEF)
-		detect_alua(pp);
-
 	if (!(mask & DI_SERIAL))
 		return;
 
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index a9a28add..01789339 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -31,7 +31,7 @@
 struct config;
 
 int path_discovery (vector pathvec, int flag);
-
+int path_get_tpgs(struct path *pp); /* This function never returns TPGS_UNDEF */
 int do_tur (char *);
 int path_offline (struct path *);
 int get_state (struct path * pp, struct config * conf, int daemon, int state);
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 624dc6ef..27474f05 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -425,7 +425,7 @@ int select_hwhandler(struct config *conf, struct multipath *mp)
 	dh_state = &handler[2];
 
 	vector_foreach_slot(mp->paths, pp, i)
-		all_tpgs = all_tpgs && (pp->tpgs > 0);
+		all_tpgs = all_tpgs && (path_get_tpgs(pp) > 0);
 	if (mp->retain_hwhandler != RETAIN_HWHANDLER_OFF) {
 		vector_foreach_slot(mp->paths, pp, i) {
 			if (get_dh_state(pp, dh_state, sizeof(handler) - 2) > 0
@@ -490,7 +490,7 @@ int select_checker(struct config *conf, struct path *pp)
 		if (check_rdac(pp)) {
 			ckr_name = RDAC;
 			goto out;
-		} else if (pp->tpgs > 0) {
+		} else if (path_get_tpgs(pp) != TPGS_NONE) {
 			ckr_name = TUR;
 			goto out;
 		}
@@ -552,6 +552,7 @@ detect_prio(struct config *conf, struct path * pp)
 	struct prio *p = &pp->prio;
 	char buff[512];
 	char *default_prio;
+	int tpgs;
 
 	switch(pp->bus) {
 	case SYSFS_BUS_NVME:
@@ -560,9 +561,10 @@ detect_prio(struct config *conf, struct path * pp)
 		default_prio = PRIO_ANA;
 		break;
 	case SYSFS_BUS_SCSI:
-		if (pp->tpgs <= 0)
+		tpgs = path_get_tpgs(pp);
+		if (tpgs == TPGS_NONE)
 			return;
-		if ((pp->tpgs == 2 || !check_rdac(pp)) &&
+		if ((tpgs == TPGS_EXPLICIT || !check_rdac(pp)) &&
 		    sysfs_get_asymmetric_access_state(pp, buff, 512) >= 0)
 			default_prio = PRIO_SYSFS;
 		else
@@ -607,6 +609,7 @@ int select_prio(struct config *conf, struct path *pp)
 	const char *origin;
 	struct mpentry * mpe;
 	struct prio * p = &pp->prio;
+	int log_prio = 3;
 
 	if (pp->detect_prio == DETECT_PRIO_ON) {
 		detect_prio(conf, pp);
@@ -628,14 +631,16 @@ out:
 	 * fetch tpgs mode for alua, if its not already obtained
 	 */
 	if (!strncmp(prio_name(p), PRIO_ALUA, PRIO_NAME_LEN)) {
-		int tpgs = 0;
-		unsigned int timeout = conf->checker_timeout;
+		int tpgs = path_get_tpgs(pp);
 
-		if(!pp->tpgs &&
-		   (tpgs = get_target_port_group_support(pp, timeout)) >= 0)
-			pp->tpgs = tpgs;
+		if (tpgs == TPGS_NONE) {
+			prio_get(conf->multipath_dir,
+				 p, DEFAULT_PRIO, DEFAULT_PRIO_ARGS);
+			origin = "(setting: emergency fallback - alua failed)";
+			log_prio = 1;
+		}
 	}
-	condlog(3, "%s: prio = %s %s", pp->dev, prio_name(p), origin);
+	condlog(log_prio, "%s: prio = %s %s", pp->dev, prio_name(p), origin);
 	condlog(3, "%s: prio args = \"%s\" %s", pp->dev, prio_args(p), origin);
 	return 0;
 }
diff --git a/multipathd/main.c b/multipathd/main.c
index fb520b64..269a96ec 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -936,7 +936,8 @@ ev_add_path (struct path * pp, struct vectors * vecs, int need_do_map)
 	}
 	if (mpp && mpp->wait_for_udev &&
 	    (pathcount(mpp, PATH_UP) > 0 ||
-	     (pathcount(mpp, PATH_GHOST) > 0 && pp->tpgs != TPGS_IMPLICIT &&
+	     (pathcount(mpp, PATH_GHOST) > 0 &&
+	      path_get_tpgs(pp) != TPGS_IMPLICIT &&
 	      mpp->ghost_delay_tick <= 0))) {
 		/* if wait_for_udev is set and valid paths exist */
 		condlog(3, "%s: delaying path addition until %s is fully initialized",
@@ -2106,8 +2107,8 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 	 * paths if there are no other active paths in map.
 	 */
 	disable_reinstate = (newstate == PATH_GHOST &&
-			    pp->mpp->nr_active == 0 &&
-			    pp->tpgs == TPGS_IMPLICIT) ? 1 : 0;
+			     pp->mpp->nr_active == 0 &&
+			     path_get_tpgs(pp) == TPGS_IMPLICIT) ? 1 : 0;
 
 	pp->chkrstate = newstate;
 	if (newstate != pp->state) {
-- 
2.21.0
