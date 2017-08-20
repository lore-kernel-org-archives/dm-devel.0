From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: replace "setting: array" with
	"setting: storage device" at multipath output
Date: Sun, 20 Aug 2017 02:47:13 +0200
Message-ID: <20170820004713.13812-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Reported-by: Martin Wilck <mwilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/propsel.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 175fbe1..2ee9a65 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -48,7 +48,7 @@ do {									\
 #define mp_set_mpe(var)							\
 do_set(var, mp->mpe, mp->var, "(setting: multipath.conf multipaths section)")
 #define mp_set_hwe(var)							\
-do_set(var, mp->hwe, mp->var, "(setting: array configuration)")
+do_set(var, mp->hwe, mp->var, "(setting: storage device configuration)")
 #define mp_set_ovr(var)							\
 do_set(var, conf->overrides, mp->var, "(setting: multipath.conf overrides section)")
 #define mp_set_conf(var)						\
@@ -59,7 +59,7 @@ do_default(mp->var, value)
 #define pp_set_mpe(var)							\
 do_set(var, mpe, pp->var, "(setting: multipath.conf multipaths section)")
 #define pp_set_hwe(var)							\
-do_set(var, pp->hwe, pp->var, "(setting: array configuration)")
+do_set(var, pp->hwe, pp->var, "(setting: storage device configuration)")
 #define pp_set_conf(var)						\
 do_set(var, conf, pp->var, "(setting: multipath.conf defaults/devices section)")
 #define pp_set_ovr(var)							\
@@ -219,7 +219,7 @@ want_user_friendly_names(struct config *conf, struct multipath * mp)
 	do_set(user_friendly_names, conf->overrides, user_friendly_names,
 	       "(setting: multipath.conf overrides section)");
 	do_set(user_friendly_names, mp->hwe, user_friendly_names,
-	       "(setting: array configuration)");
+	       "(setting: storage device configuration)");
 	do_set(user_friendly_names, conf, user_friendly_names,
 	       "(setting: multipath.conf defaults/devices section)");
 	do_default(user_friendly_names, DEFAULT_USER_FRIENDLY_NAMES);
@@ -363,11 +363,11 @@ int select_checker(struct config *conf, struct path *pp)
 
 	if (pp->detect_checker == DETECT_CHECKER_ON && pp->tpgs > 0) {
 		checker_name = TUR;
-		origin = "(setting: array autodetected)";
+		origin = "(setting: storage device autodetected)";
 		goto out;
 	}
 	do_set(checker_name, conf->overrides, checker_name, "(setting: multipath.conf overrides section)");
-	do_set(checker_name, pp->hwe, checker_name, "(setting: array configuration)");
+	do_set(checker_name, pp->hwe, checker_name, "(setting: storage device configuration)");
 	do_set(checker_name, conf, checker_name, "(setting: multipath.conf defaults/devices section)");
 	do_default(checker_name, DEFAULT_CHECKER);
 out:
@@ -468,14 +468,14 @@ int select_prio(struct config *conf, struct path *pp)
 	if (pp->detect_prio == DETECT_PRIO_ON) {
 		detect_prio(conf, pp);
 		if (prio_selected(p)) {
-			origin = "(setting: array autodetected)";
+			origin = "(setting: storage device autodetected)";
 			goto out;
 		}
 	}
 	mpe = find_mpe(conf->mptable, pp->wwid);
 	set_prio(conf->multipath_dir, mpe, "(setting: multipath.conf multipaths section)");
 	set_prio(conf->multipath_dir, conf->overrides, "(setting: multipath.conf overrides section)");
-	set_prio(conf->multipath_dir, pp->hwe, "(setting: array configuration)");
+	set_prio(conf->multipath_dir, pp->hwe, "(setting: storage device configuration)");
 	set_prio(conf->multipath_dir, conf, "(setting: multipath.conf defaults/devices section)");
 	prio_get(conf->multipath_dir, p, DEFAULT_PRIO, DEFAULT_PRIO_ARGS);
 	origin = "(setting: multipath internal)";
@@ -528,7 +528,7 @@ select_minio_rq (struct config *conf, struct multipath * mp)
 
 	do_set(minio_rq, mp->mpe, mp->minio, "(setting: multipath.conf multipaths section)");
 	do_set(minio_rq, conf->overrides, mp->minio, "(setting: multipath.conf overrides section)");
-	do_set(minio_rq, mp->hwe, mp->minio, "(setting: array configuration)");
+	do_set(minio_rq, mp->hwe, mp->minio, "(setting: storage device configuration)");
 	do_set(minio_rq, conf, mp->minio, "(setting: multipath.conf defaults/devices section)");
 	do_default(mp->minio, DEFAULT_MINIO_RQ);
 out:
-- 
2.13.5
